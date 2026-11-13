#!/usr/bin/env python3
"""Select existing Helm charts from a JSON list of changed paths on stdin."""
import json
from pathlib import Path, PurePosixPath
import sys


def main():
    paths = json.load(sys.stdin)
    if not isinstance(paths, list) or not all(isinstance(path, str) for path in paths):
        raise ValueError("Expected a JSON list of changed file paths")

    charts = set()
    for path in paths:
        parts = PurePosixPath(path).parts
        if len(parts) < 3 or parts[0] != "charts" or ".." in parts:
            continue
        chart = parts[1]
        if (Path("charts") / chart / "Chart.yaml").is_file():
            charts.add(chart)

    print(json.dumps({"chart": sorted(charts)}, separators=(",", ":")))


if __name__ == "__main__":
    main()
