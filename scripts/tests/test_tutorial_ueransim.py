#!/usr/bin/env python3
"""Proof gating and version selection for the executable UERANSIM tutorial."""
import importlib.util
import json
import contextlib
import io
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
import subprocess

ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location("tutorial", ROOT / "scripts/tutorials/ueransim.py")
tutorial = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(tutorial)


class TutorialProof(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.directory = self.root / "tutorials/open5gs-ueransim"
        self.directory.mkdir(parents=True)
        self.versions = {"open5gs": "2.4.1", "ueransim-gnb": "0.2.6"}
        (self.directory / "versions.json").write_text(json.dumps(self.versions))
        (self.directory / "tutorial.md.in").write_text("Open5GS @OPEN5GS_VERSION@, validated @VALIDATED_AT@")
        for name in ("open5gs-values.yaml", "ueransim-values.yaml", "tutorial.sh"):
            (self.directory / name).write_text("example\n")
        scripts = self.root / "scripts/tutorials"
        scripts.mkdir(parents=True)
        (scripts / "ueransim.py").write_text("helper\n")

    def proof(self):
        return {"source": "published", "versions": self.versions,
                "fingerprint": tutorial.fingerprint(self.root),
                "checks": {name: True for name in tutorial.CHECKS},
                "validated_at": "2026-11-16T00:00:00Z", "commit": "a" * 40, "committed": True,
                "run_url": "https://github.com/Gradiant/5g-charts/actions/runs/1"}

    def test_published_success_can_render_existing_pages_url(self):
        output = self.root / "output"
        tutorial.render(self.root, output, self.proof())
        page = (output / "open5gs-ueransim-gnb.md").read_text()
        self.assertIn("2.4.1", page)
        self.assertNotIn("@VALIDATED_AT@", page)
        self.assertTrue((output / "docs/open5gs-ueransim-gnb/5gSA-values.yaml").is_file())

    def test_candidate_result_cannot_publish(self):
        proof = self.proof()
        proof["source"] = "candidate"
        with self.assertRaises(ValueError):
            tutorial.render(self.root, self.root / "output", proof)

    def test_uncommitted_sources_cannot_publish(self):
        proof = self.proof()
        proof['committed'] = False
        with self.assertRaises(ValueError):
            tutorial.render(self.root, self.root / "output", proof)

    def test_every_functional_check_is_required(self):
        for name in tutorial.CHECKS:
            for bad in (False, "true", None):
                with self.subTest(name=name, bad=bad):
                    proof = self.proof()
                    proof["checks"][name] = bad
                    with self.assertRaises(ValueError):
                        tutorial.validate_proof(self.root, proof)

    def test_stale_values_or_commands_cannot_publish(self):
        proof = self.proof()
        for name in ("open5gs-values.yaml", "tutorial.sh"):
            file = self.directory / name
            original = file.read_text()
            file.write_text("changed\n")
            with self.assertRaises(ValueError):
                tutorial.validate_proof(self.root, proof)
            file.write_text(original)

    def test_version_mismatch_cannot_publish(self):
        proof = self.proof()
        proof["versions"] = {**self.versions, "open5gs": "2.4.2"}
        with self.assertRaises(ValueError):
            tutorial.validate_proof(self.root, proof)

    def test_invalid_versions_rejected(self):
        for value in ("latest", "2.4.1; touch /tmp/no", "../2.4.1", ""):
            (self.directory / "versions.json").write_text(json.dumps({**self.versions, "open5gs": value}))
            with self.assertRaises(ValueError):
                tutorial.versions(self.root)

    def test_candidates_come_from_chart_metadata(self):
        for name, version in self.versions.items():
            chart = self.root / "charts" / name
            chart.mkdir(parents=True)
            (chart / "Chart.yaml").write_text(f"name: {name}\nversion: {version}\n")
        self.assertEqual(tutorial.candidate_versions(self.root), self.versions)

    def test_release_reads_only_metadata_from_the_exact_commit(self):
        ref = 'b' * 40
        with patch.object(tutorial.subprocess, "check_output", side_effect=['version: 2.4.2\n', 'version: 0.2.7\n']) as command:
            self.assertEqual(tutorial.candidate_versions(self.root, ref),
                             {'open5gs': '2.4.2', 'ueransim-gnb': '0.2.7'})
            self.assertEqual(command.call_args_list[0].args[0],
                             ['git', 'show', ref + ':charts/open5gs/Chart.yaml'])
        with self.assertRaises(ValueError):
            tutorial.candidate_versions(self.root, 'main; command')

    def test_invalid_proof_metadata_rejected(self):
        for field, value in (("commit", "main"), ("validated_at", "yesterday"),
                             ("run_url", "javascript:alert(1)")):
            proof = self.proof()
            proof[field] = value
            with self.subTest(field=field), self.assertRaises(ValueError):
                tutorial.validate_proof(self.root, proof)

    def test_record_preserves_checks_and_runtime_image_digests(self):
        state = self.root / "state"
        state.mkdir()
        (state / "checks.json").write_text(json.dumps(self.proof()["checks"]))
        (state / "images.json").write_text(json.dumps({"items": [{
            "metadata": {"name": "upf"}, "status": {"containerStatuses": [
                {"name": "upf", "image": "example:1", "imageID": "sha256:test"}]}}]}))
        (state / "packages").mkdir()
        (state / "packages/chart.tgz").write_bytes(b"package")
        with patch.object(tutorial.subprocess, "check_output", side_effect=["", "a" * 40, "v4.3.0", '{}']):
            tutorial.record(self.root, state, "published")
        proof = json.loads((state / "validation.json").read_text())
        tutorial.validate_proof(self.root, proof)
        self.assertEqual(proof["images"][0]["containers"][0]["imageID"], "sha256:test")
        self.assertEqual(len(proof["package_sha256"]["chart.tgz"]), 64)
        (state / "checks.json").write_text('{}')
        with self.assertRaises(ValueError):
            tutorial.record(self.root, state, "published")

    def test_cli_uses_selected_mode_and_validates_before_render(self):
        for name, version in self.versions.items():
            chart = self.root / "charts" / name
            chart.mkdir(parents=True)
            (chart / "Chart.yaml").write_text(f"version: {version}\n")
        state = self.root / "state"
        state.mkdir()
        (state / "validation.json").write_text(json.dumps(self.proof()))
        commands = [
            ["version", "--chart", "open5gs"],
            ["version", "--chart", "open5gs", "--source", "candidate"],
            ["select-release"], ["validate", "--state", str(state)],
            ["render", "--state", str(state), "--output", str(self.root / "out")],
            ["record", "--state", str(state)],
        ]
        for args in commands:
            # select-release changes JSON formatting, so refresh the matching proof.
            (state / "validation.json").write_text(json.dumps(self.proof()))
            with self.subTest(args=args), patch.object(tutorial, "ROOT", self.root), \
                    patch("sys.argv", ["ueransim.py", *args]), \
                    patch.object(tutorial, "record") as record, contextlib.redirect_stdout(io.StringIO()):
                # Defaults are bound at definition time; use explicit fixture versions.
                with patch.object(tutorial, "versions", return_value=self.versions), \
                        patch.object(tutorial, "candidate_versions", return_value=self.versions):
                    tutorial.main()
                if args[0] == "record":
                    record.assert_called_once()

    def test_cleanup_cannot_succeed_when_cluster_query_fails(self):
        binary = self.root / "bin"
        binary.mkdir()
        kubectl = binary / "kubectl"
        kubectl.write_text('#!/bin/sh\nif [ "$1" = config ]; then echo kind-5g-tutorial; else exit 1; fi\n')
        helm = binary / "helm"
        helm.write_text('#!/bin/sh\nexit 0\n')
        kubectl.chmod(0o755)
        helm.chmod(0o755)
        result = subprocess.run(["bash", str(ROOT / "tutorials/open5gs-ueransim/tutorial.sh"), "clean"],
                                env={**os.environ, "PATH": str(binary) + os.pathsep + os.environ['PATH'],
                                     "TUTORIAL_STATE_DIR": str(self.root / 'state')}, capture_output=True)
        self.assertNotEqual(result.returncode, 0)

    def test_version_proposal_skips_semantically_unchanged_pins(self):
        report = self.root / "reports/verified"
        report.mkdir(parents=True)
        (report / "versions.json").write_text(json.dumps(self.versions, separators=(',', ':')))
        result = subprocess.run(['bash', str(ROOT / 'scripts/tutorials/propose-ueransim.sh')],
                                cwd=self.root, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn('no documentation PR needed', result.stdout)

    def test_version_proposal_rejects_stale_evidence_before_git_or_github(self):
        import shutil
        report = self.root / "reports/verified"
        report.mkdir(parents=True)
        (report / "versions.json").write_text(json.dumps({**self.versions, 'open5gs': '2.4.2'}))
        (report / "validation.json").write_text(json.dumps(self.proof()))
        shutil.copyfile(ROOT / 'scripts/tutorials/ueransim.py', self.root / 'scripts/tutorials/ueransim.py')
        result = subprocess.run(['bash', str(ROOT / 'scripts/tutorials/propose-ueransim.sh')],
                                cwd=self.root, capture_output=True, text=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('Validation is stale', result.stderr)


if __name__ == "__main__":
    unittest.main()
