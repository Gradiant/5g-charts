#!/usr/bin/env python3
"""Regression tests for release chart selection; uses only the standard library."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]
SCRIPT = ROOT / "scripts" / "release-matrix.py"


class ReleaseMatrix(unittest.TestCase):
    def setUp(self):
        self.workspace = tempfile.TemporaryDirectory()
        self.addCleanup(self.workspace.cleanup)
        self.root = Path(self.workspace.name)
        for chart in ("open5gs", "open5gs-upf", "mongodb"):
            directory = self.root / "charts" / chart
            directory.mkdir(parents=True)
            (directory / "Chart.yaml").write_text(f"name: {chart}\nversion: 1.0.0\n")
        (self.root / "charts" / "_helm-docs.gotmpl").write_text("shared template\n")
        (self.root / "charts" / "not-a-chart").mkdir()

    def matrix(self, paths):
        result = subprocess.run(
            [sys.executable, str(SCRIPT)], cwd=self.root,
            input=json.dumps(paths), capture_output=True, text=True, check=True,
        )
        return json.loads(result.stdout)

    def test_shared_template_is_not_a_chart(self):
        self.assertEqual(self.matrix([
            "charts/_helm-docs.gotmpl", "charts/open5gs/README.md",
            "charts/mongodb/Chart.yaml",
        ]), {"chart": ["mongodb", "open5gs"]})

    def test_non_adjacent_duplicates_are_removed(self):
        self.assertEqual(self.matrix([
            "charts/open5gs-upf/Chart.yaml", "charts/mongodb/values.yaml",
            "charts/open5gs-upf/templates/deployment.yaml",
        ]), {"chart": ["mongodb", "open5gs-upf"]})

    def test_only_shared_or_unrelated_files_produce_empty_matrix(self):
        self.assertEqual(self.matrix([
            "charts/_helm-docs.gotmpl", "README.md",
            "docs/charts/open5gs/README.md", "charts/not-a-chart/README.md",
            "charts/deleted-chart/Chart.yaml",
        ]), {"chart": []})

    def test_empty_change_list(self):
        self.assertEqual(self.matrix([]), {"chart": []})

    def test_spaces_and_shell_characters_in_file_names(self):
        self.assertEqual(self.matrix([
            "charts/open5gs/docs/a file.md", "charts/mongodb/$(touch INJECTED).md",
        ]), {"chart": ["mongodb", "open5gs"]})
        self.assertFalse((self.root / "INJECTED").exists())

    def test_invalid_input_fails_instead_of_releasing(self):
        for value in ("not json", '{}', '"charts/open5gs/Chart.yaml"', '[null]'):
            with self.subTest(value=value):
                result = subprocess.run(
                    [sys.executable, str(SCRIPT)], cwd=self.root,
                    input=value, capture_output=True, text=True,
                )
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(result.stdout, "")


if __name__ == "__main__":
    unittest.main()
