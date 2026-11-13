#!/usr/bin/env python3
"""Probe rendering regressions. Requires Helm and PyYAML."""
from pathlib import Path
import subprocess
import unittest

import yaml

ROOT = Path(__file__).resolve().parents[2]
COMPONENTS = ("amf", "ausf", "bsf", "nrf", "nssf", "pcf", "scp", "sepp", "smf", "udm", "udr", "upf", "webui")
LEGACY = ("hss", "mme", "pcrf", "sgwc", "sgwu")
PROBES = ("startupProbe", "readinessProbe", "livenessProbe")
CUSTOM = {"exec": {"command": ["/bin/sh", "-c", "exit 0"]},
          "periodSeconds": 7, "timeoutSeconds": 4, "failureThreshold": 9}


def render(component, values=None, *, documents=False):
    chart = "mongodb" if component == "mongodb" else "open5gs-" + component
    config = {} if component == "mongodb" else {"mongodb": {"enabled": False}}
    config.update(values or {})
    result = subprocess.run(["helm", "template", "probe-test", str(ROOT / "charts" / chart),
                             "-n", "probe-test", "-f", "-"],
                            input=yaml.safe_dump(config), text=True, capture_output=True, check=True)
    docs = [d for d in yaml.safe_load_all(result.stdout) if d]
    if documents:
        return docs
    kind = "StatefulSet" if component == "mongodb" else "Deployment"
    doc = next(d for d in docs if d["kind"] == kind)
    return doc["spec"]["template"]["spec"]["containers"][0]


class Open5GSProbes(unittest.TestCase):
    def test_defaults_allow_fast_start_and_protect_slow_start(self):
        for component in COMPONENTS:
            with self.subTest(component=component):
                container = render(component)
                for name, period, failures in (("startupProbe", 5, 60), ("readinessProbe", 5, 3), ("livenessProbe", 10, 3)):
                    probe = container[name]
                    self.assertEqual(probe["initialDelaySeconds"], 0)
                    self.assertEqual(probe["periodSeconds"], period)
                    self.assertEqual(probe["failureThreshold"], failures)
                    self.assertEqual(probe["successThreshold"], 1)
                    self.assertEqual(probe["timeoutSeconds"], 5 if component == "upf" else 2)
                    self.assertIn("exec" if component == "upf" else "tcpSocket", probe)
                    self.assertNotIn("httpGet", probe)

    def test_custom_probes_override_enabled_defaults(self):
        for component in COMPONENTS:
            for name in PROBES:
                with self.subTest(component=component, probe=name):
                    custom = "custom" + name[0].upper() + name[1:]
                    container = render(component, {name: {"enabled": True}, custom: CUSTOM})
                    self.assertEqual(container[name], CUSTOM)

    def test_custom_probes_work_with_defaults_disabled(self):
        for component in COMPONENTS + LEGACY:
            with self.subTest(component=component):
                values = {name: {"enabled": False} for name in PROBES} if component in COMPONENTS else {}
                values.update({"custom" + name[0].upper() + name[1:]: CUSTOM for name in PROBES})
                container = render(component, values)
                for name in PROBES:
                    self.assertEqual(container[name], CUSTOM)

    def test_disabled_probes_are_omitted(self):
        for component in COMPONENTS:
            with self.subTest(component=component):
                container = render(component, {name: {"enabled": False} for name in PROBES})
                for name in PROBES:
                    self.assertNotIn(name, container)

    def test_application_services_respect_readiness_by_default(self):
        for component in COMPONENTS:
            with self.subTest(component=component):
                docs = render(component, {"metrics": {"enabled": True}}, documents=True)
                services = [d for d in docs if d["kind"] == "Service"]
                self.assertTrue(services)
                for service in services:
                    metrics = all(port["name"] == "metrics" for port in service["spec"]["ports"])
                    self.assertEqual(service["spec"].get("publishNotReadyAddresses", False), metrics)

    def test_service_bootstrap_publication_is_configurable(self):
        for component in COMPONENTS:
            with self.subTest(component=component):
                values = yaml.safe_load((ROOT / "charts" / ("open5gs-" + component) / "values.yaml").read_text())
                groups = values["services"]
                config = {"services": {name: {"publishNotReadyAddresses": True} for name in groups}}
                for service in (d for d in render(component, config, documents=True) if d["kind"] == "Service"):
                    self.assertTrue(service["spec"]["publishNotReadyAddresses"])
                config = {"services": {name: {"publishNotReadyAddresses": False} for name in groups}}
                for service in (d for d in render(component, config, documents=True) if d["kind"] == "Service"):
                    self.assertFalse(service["spec"]["publishNotReadyAddresses"])

    def test_legacy_defaults_still_require_explicit_probes(self):
        for component in LEGACY:
            with self.subTest(component=component):
                container = render(component)
                for name in PROBES:
                    self.assertNotIn(name, container)

    def test_invalid_probe_timings_are_rejected(self):
        for component in COMPONENTS:
            for name, field, value in (("startupProbe", "failureThreshold", 0),
                                       ("startupProbe", "successThreshold", 2),
                                       ("livenessProbe", "successThreshold", 2),
                                       ("readinessProbe", "periodSeconds", 0)):
                with self.subTest(component=component, probe=name, field=field):
                    with self.assertRaises(subprocess.CalledProcessError):
                        render(component, {name: {field: value}})


class MongoDBProbes(unittest.TestCase):
    def test_startup_and_regular_probes_use_database_ping(self):
        container = render("mongodb")
        for name, period, failures in (("startupProbe", 10, 30), ("readinessProbe", 10, 3), ("livenessProbe", 20, 3)):
            probe = container[name]
            self.assertEqual(probe["initialDelaySeconds"], 0)
            self.assertEqual(probe["periodSeconds"], period)
            self.assertEqual(probe["timeoutSeconds"], 10)
            self.assertEqual(probe["failureThreshold"], failures)
            self.assertIn("mongosh", probe["exec"]["command"])
            self.assertIn("db.adminCommand", probe["exec"]["command"][-1])

    def test_custom_probes_override_enabled_defaults(self):
        for name in PROBES:
            with self.subTest(probe=name):
                key = "custom" + name[0].upper() + name[1:]
                self.assertEqual(render("mongodb", {key: CUSTOM})[name], CUSTOM)

    def test_disabled_probes_are_omitted(self):
        container = render("mongodb", {name: {"enabled": False} for name in PROBES})
        for name in PROBES:
            self.assertNotIn(name, container)

    def test_invalid_timings_are_rejected(self):
        with self.assertRaises(subprocess.CalledProcessError):
            render("mongodb", {"startupProbe": {"failureThreshold": 0}})


if __name__ == "__main__":
    unittest.main(verbosity=2)
