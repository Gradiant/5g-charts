#!/usr/bin/env python3
"""MongoDB dependency and startup regression tests (requires Helm and PyYAML)."""
import os
from pathlib import Path
import subprocess
import tempfile
import time
import unittest

import yaml

ROOT = Path(__file__).resolve().parents[2]
COMPONENTS = ("hss", "pcrf", "pcf", "udr", "webui")


def render(component, *overrides, release="db-test"):
    chart = ROOT / "charts" / ("open5gs-" + component)
    result = subprocess.run(
        ["helm", "template", release, str(chart), "-n", "db-test",
         "--set", "mongodb.enabled=false", *overrides],
        text=True, capture_output=True, check=True,
    )
    return [doc for doc in yaml.safe_load_all(result.stdout) if doc]


def deployment(docs):
    return next(doc["spec"]["template"]["spec"] for doc in docs
                if doc["kind"] == "Deployment")


class MongoDBCharts(unittest.TestCase):
    def test_local_dependency_and_official_image(self):
        for component in COMPONENTS:
            with self.subTest(component=component):
                metadata = yaml.safe_load((ROOT / "charts" / ("open5gs-" + component) / "Chart.yaml").read_text())
                dependency = next(d for d in metadata["dependencies"] if d["name"] == "mongodb")
                self.assertEqual(dependency["repository"], "file://../mongodb")
                docs = render(component, "--set", "mongodb.enabled=true", "--set", "mongodb.auth.enabled=false")
                db = next(d for d in docs if d["kind"] == "StatefulSet")
                self.assertEqual(db["spec"]["template"]["spec"]["containers"][0]["image"], "mongo:8.0.34")

    def test_wait_precedes_application_and_matches_uri(self):
        for component in COMPONENTS:
            with self.subTest(component=component):
                pod = deployment(render(component))
                wait = pod["initContainers"][0]
                self.assertEqual(wait["name"], "wait-for-mongodb")
                env = {e["name"]: e["value"] for e in wait["env"]}
                app_env = {e["name"]: e.get("value") for e in pod["containers"][0]["env"]}
                self.assertEqual(env["DB_URI"], app_env["DB_URI"])
                self.assertEqual(env["DB_URI"], "mongodb://db-test-mongodb/open5gs")
                self.assertFalse(wait["securityContext"]["allowPrivilegeEscalation"])
                self.assertTrue(wait["securityContext"]["runAsNonRoot"])
                self.assertEqual(wait["securityContext"]["capabilities"]["drop"], ["ALL"])

    def test_external_uri_and_custom_service_port(self):
        for component in COMPONENTS:
            with self.subTest(component=component):
                pod = deployment(render(component, "--set-string", "dbURI=mongodb://db.external:27018/test?authSource=admin"))
                expected = "mongodb://db.external:27018/test?authSource=admin"
                for container in (pod["initContainers"][0], pod["containers"][0]):
                    self.assertEqual(next(e["value"] for e in container["env"] if e["name"] == "DB_URI"), expected)
                pod = deployment(render(component, "--set", "mongodb.service.port=27018", release="mongodb"))
                self.assertEqual(next(e["value"] for e in pod["initContainers"][0]["env"] if e["name"] == "DB_URI"),
                                 "mongodb://mongodb-mongodb:27018/open5gs")

    def test_opt_out_preserves_custom_init_containers(self):
        for component in COMPONENTS:
            with self.subTest(component=component):
                pod = deployment(render(component, "--set", "mongodbWait.enabled=false", "--set", "initContainers[0].name=custom", "--set", "initContainers[0].image=busybox:1.37"))
                names = [c["name"] for c in pod["initContainers"]]
                self.assertNotIn("wait-for-mongodb", names)
                self.assertIn("custom", names)

    def test_wait_configuration_validation(self):
        for component in COMPONENTS:
            with self.subTest(component=component):
                with self.assertRaises(subprocess.CalledProcessError):
                    render(component, "--set", "mongodbWait.timeoutSeconds=0")
                with self.assertRaises(subprocess.CalledProcessError):
                    render(component, "--set", "mongodbWait.retryIntervalSeconds=0")

    def test_existing_claim_and_custom_init_order(self):
        for component in COMPONENTS:
            with self.subTest(component=component):
                docs = render(component, "--set", "mongodb.enabled=true", "--set", "mongodb.auth.enabled=false",
                              "--set", "mongodb.persistence.existingClaim=restored-data",
                              "--set", "initContainers[0].name=custom", "--set", "initContainers[0].image=busybox:1.37")
                db = next(d for d in docs if d["kind"] == "StatefulSet")
                volume = next(v for v in db["spec"]["template"]["spec"]["volumes"] if v["name"] == "data")
                self.assertEqual(volume["persistentVolumeClaim"]["claimName"], "restored-data")
                self.assertNotIn("volumeClaimTemplates", db["spec"])
                names = [c["name"] for c in deployment(docs)["initContainers"]]
                self.assertLess(names.index("wait-for-mongodb"), names.index("custom"))

    def test_authentication_cannot_be_silently_disabled(self):
        for component in COMPONENTS:
            with self.subTest(component=component):
                with self.assertRaises(subprocess.CalledProcessError):
                    render(component, "--set", "mongodb.enabled=true", "--set", "mongodb.auth.enabled=true")

    def test_templated_external_uri(self):
        for component in COMPONENTS:
            with self.subTest(component=component):
                docs = render(component, "--set-string", "dbURI=mongodb://external.{{ .Release.Namespace }}.svc/custom")
                wait = deployment(docs)["initContainers"][0]
                uri = next(e["value"] for e in wait["env"] if e["name"] == "DB_URI")
                self.assertEqual(uri, "mongodb://external.db-test.svc/custom")

    def test_umbrella_uses_one_shared_database(self):
        result = subprocess.run(["helm", "template", "open5gs", str(ROOT / "charts/open5gs"),
                                 "-n", "db-test"], text=True, capture_output=True, check=True)
        docs = [d for d in yaml.safe_load_all(result.stdout) if d]
        databases = [d for d in docs if d["kind"] == "StatefulSet" and d["metadata"]["name"].endswith("-mongodb")]
        self.assertEqual(len(databases), 1)
        for component in COMPONENTS:
            with self.subTest(component=component):
                doc = next(d for d in docs if d["kind"] == "Deployment" and d["metadata"]["name"] == "open5gs-" + component)
                pod = doc["spec"]["template"]["spec"]
                for container in (pod["initContainers"][0], pod["containers"][0]):
                    uri = next(e["value"] for e in container["env"] if e["name"] == "DB_URI")
                    self.assertEqual(uri, "mongodb://open5gs-mongodb/open5gs")

    def test_subscriber_population_waits_for_database_before_inserting(self):
        result = subprocess.run(["helm", "template", "open5gs", str(ROOT / "charts/open5gs"),
                                 "-n", "db-test"], text=True, capture_output=True, check=True)
        docs = list(yaml.safe_load_all(result.stdout))
        doc = next(d for d in docs if d and d["kind"] == "Deployment" and d["metadata"]["name"] == "open5gs-populate")
        initializers = doc["spec"]["template"]["spec"]["initContainers"]
        self.assertEqual([c["name"] for c in initializers], ["wait-for-mongodb", "init"])
        uris = [next(e["value"] for e in c["env"] if e["name"] == "DB_URI") for c in initializers]
        self.assertEqual(uris, ["mongodb://open5gs-mongodb/open5gs"] * 2)

    def test_cnti_configuration_has_no_privileged_containers(self):
        result = subprocess.run(["helm", "template", "open5gs", str(ROOT / "charts/open5gs"),
                                 "-n", "open5gs", "-f", str(ROOT / ".github/cnti/values.yaml")],
                                text=True, capture_output=True, check=True)
        for doc in yaml.safe_load_all(result.stdout):
            if not doc or doc["kind"] not in ("Deployment", "StatefulSet"):
                continue
            pod = doc["spec"]["template"]["spec"]
            for container in pod.get("initContainers", []) + pod["containers"]:
                self.assertFalse(container.get("securityContext", {}).get("privileged", False))
                self.assertNotIn("bitnamilegacy/mongodb", container["image"])

    def test_wait_scripts_are_consistent(self):
        scripts = [(ROOT / "charts" / ("open5gs-" + component) / "resources/wait-for-mongodb.sh").read_bytes()
                   for component in COMPONENTS]
        scripts.append((ROOT / "charts/open5gs/resources/wait-for-mongodb.sh").read_bytes())
        self.assertTrue(all(script == scripts[0] for script in scripts))


class MongoDBWait(unittest.TestCase):
    def invoke(self, fake_mongosh, timeout=2, interval=1):
        script = ROOT / "charts/open5gs-udr/resources/wait-for-mongodb.sh"
        self.assertTrue(script.exists(), "The MongoDB readiness script must exist")
        with tempfile.TemporaryDirectory() as directory:
            executable = Path(directory) / "mongosh"
            executable.write_text("#!/bin/bash\n" + fake_mongosh)
            executable.chmod(0o755)
            env = dict(os.environ, PATH=directory + os.pathsep + os.environ["PATH"],
                       DB_URI="mongodb://user:private-password@database/open5gs",
                       MONGODB_WAIT_TIMEOUT_SECONDS=str(timeout),
                       MONGODB_WAIT_INTERVAL_SECONDS=str(interval), TEST_STATE=str(Path(directory) / "attempted"))
            started = time.monotonic()
            result = subprocess.run(["bash", str(script)], env=env, capture_output=True, text=True, timeout=8)
            self.assertNotIn("private-password", result.stdout + result.stderr)
            return result, time.monotonic() - started

    def test_database_ready(self):
        result, _ = self.invoke("exit 0\n")
        self.assertEqual(result.returncode, 0)

    def test_database_becomes_ready_after_retry(self):
        result, _ = self.invoke('if [ -e "$TEST_STATE" ]; then exit 0; fi\ntouch "$TEST_STATE"\nexit 1\n', timeout=4)
        self.assertEqual(result.returncode, 0)

    def test_ready_database_does_not_wait_for_a_large_timeout(self):
        result, elapsed = self.invoke("exit 0\n", timeout=30)
        self.assertEqual(result.returncode, 0)
        self.assertLess(elapsed, 5)

    def test_retry_interval_cannot_exceed_remaining_timeout(self):
        result, elapsed = self.invoke("exit 1\n", timeout=2, interval=30)
        self.assertNotEqual(result.returncode, 0)
        self.assertLess(elapsed, 5)

    def test_unavailable_database_times_out(self):
        result, elapsed = self.invoke("exit 1\n")
        self.assertNotEqual(result.returncode, 0)
        self.assertLess(elapsed, 5)
        self.assertIn("Timed out", result.stdout + result.stderr)

    def test_invalid_runtime_timeout_is_rejected(self):
        result, elapsed = self.invoke("exit 0\n", timeout=0)
        self.assertNotEqual(result.returncode, 0)
        self.assertLess(elapsed, 3)
        self.assertIn("positive integers", result.stderr)

    def test_client_ignoring_termination_is_killed_without_logging_uri(self):
        result, elapsed = self.invoke("trap '' TERM\nwhile true; do sleep 1; done\n", timeout=1)
        self.assertNotEqual(result.returncode, 0)
        self.assertLess(elapsed, 5)

    def test_unresponsive_client_is_bounded(self):
        result, elapsed = self.invoke("exec sleep 20\n", timeout=1)
        self.assertNotEqual(result.returncode, 0)
        self.assertLess(elapsed, 4)


if __name__ == "__main__":
    unittest.main(verbosity=2)
