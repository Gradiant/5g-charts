#!/usr/bin/env python3
"""Version selection and publication proofs for the UERANSIM tutorial."""
import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import platform
import re
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[2]
RELATIVE = Path("tutorials/open5gs-ueransim")
CHARTS = ("open5gs", "ueransim-gnb")
CHECKS = ("registration_0", "registration_1", "session_0", "session_1",
          "traffic_0", "traffic_1", "subscribers", "additional_subscriber", "webui", "cleanup")
SEMVER = re.compile(r"[0-9]+\.[0-9]+\.[0-9]+(?:-[A-Za-z0-9.-]+)?")


def validate_versions(values):
    if not isinstance(values, dict) or set(values) != set(CHARTS) or any(
        not isinstance(value, str) or not SEMVER.fullmatch(value) for value in values.values()
    ):
        raise ValueError("Expected explicit semantic versions for both tutorial charts")
    return values


def versions(root=ROOT):
    return validate_versions(json.loads((root / RELATIVE / "versions.json").read_text()))


def candidate_versions(root=ROOT, ref=None):
    if ref is not None and not re.fullmatch(r"[0-9a-f]{40}", ref):
        raise ValueError("Release ref must be a full commit SHA")
    values = {}
    for chart in CHARTS:
        text = (subprocess.check_output(["git", "show", f"{ref}:charts/{chart}/Chart.yaml"], cwd=root, text=True)
                if ref else (root / "charts" / chart / "Chart.yaml").read_text())
        match = re.search(r"^version:\s*([^\s]+)\s*$", text, re.M)
        if not match:
            raise ValueError(f"Missing chart version: {chart}")
        values[chart] = match[1]
    return validate_versions(values)


def fingerprint(root=ROOT):
    files = [root / RELATIVE / name for name in
             ("versions.json", "tutorial.md.in", "open5gs-values.yaml", "ueransim-values.yaml", "tutorial.sh")]
    files.append(root / "scripts/tutorials/ueransim.py")
    digest = hashlib.sha256()
    for path in files:
        digest.update(str(path.relative_to(root)).encode() + b"\0" + path.read_bytes() + b"\0")
    return digest.hexdigest()


def validate_proof(root, proof):
    if proof.get("source") != "published":
        raise ValueError("Only a published-package run can update documentation")
    if proof.get("versions") != versions(root) or proof.get("fingerprint") != fingerprint(root):
        raise ValueError("Validation is stale: tutorial, commands or versions changed")
    if any(proof.get("checks", {}).get(name) is not True for name in CHECKS):
        raise ValueError("All functional checks must pass")
    if not re.fullmatch(r"[0-9a-f]{40}", proof.get("commit", "")):
        raise ValueError("Validation must identify a source commit")
    datetime.fromisoformat(proof["validated_at"])
    if proof.get("run_url") and not re.fullmatch(
        r"https://github\.com/Gradiant/5g-charts/actions/runs/[0-9]+", proof["run_url"]
    ):
        raise ValueError("Unexpected validation run URL")


def render(root, output, proof):
    validate_proof(root, proof)
    if proof.get("committed") is not True:
        raise ValueError("Public instructions must refer to committed tutorial sources")
    directory = root / RELATIVE
    text = (directory / "tutorial.md.in").read_text()
    substitutions = {"OPEN5GS_VERSION": proof["versions"]["open5gs"],
                     "UERANSIM_VERSION": proof["versions"]["ueransim-gnb"],
                     "VALIDATED_AT": proof["validated_at"], "COMMIT": proof["commit"],
                     "RUN_URL": proof.get("run_url") or "https://github.com/Gradiant/5g-charts/actions/workflows/tutorial-ueransim.yml"}
    for key, value in substitutions.items():
        text = text.replace("@" + key + "@", value)
    output.mkdir(parents=True, exist_ok=True)
    (output / "open5gs-ueransim-gnb.md").write_text(text)
    assets = output / "docs/open5gs-ueransim-gnb"
    assets.mkdir(parents=True, exist_ok=True)
    for source, destination in (("open5gs-values.yaml", "5gSA-values.yaml"),
                                ("ueransim-values.yaml", "gnb-ues-values.yaml"),
                                ("versions.json", "versions.json")):
        shutil.copyfile(directory / source, assets / destination)


def record(root, state, source):
    checks = json.loads((state / "checks.json").read_text())
    if any(checks.get(name) is not True for name in CHECKS):
        raise ValueError("Cannot record an incomplete or failed run")
    pods = json.loads((state / "images.json").read_text())["items"]
    images = [{"pod": pod["metadata"]["name"],
               "containers": [{key: status.get(key, "") for key in ("name", "image", "imageID")}
                              for field in ("initContainerStatuses", "containerStatuses")
                              for status in pod.get("status", {}).get(field, [])]}
              for pod in pods]
    packages = {path.name: hashlib.sha256(path.read_bytes()).hexdigest()
                for path in sorted((state / "packages").glob("*.tgz"))}
    committed = not subprocess.check_output(
        ["git", "status", "--porcelain", "--", str(RELATIVE), "scripts/tutorials/ueransim.py"],
        cwd=root, text=True).strip()
    proof = {"source": source, "versions": candidate_versions(root) if source == "candidate" else versions(root), "checks": checks,
             "fingerprint": fingerprint(root), "validated_at": datetime.now(timezone.utc).isoformat(),
             "commit": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=root, text=True).strip(),
             "kernel": platform.release(), "committed": committed,
             "run_url": os.environ.get("TUTORIAL_RUN_URL", ""),
             "images": images, "package_sha256": packages,
             "helm": subprocess.check_output(["helm", "version", "--short"], text=True).strip(),
             "kubernetes": json.loads(subprocess.check_output(["kubectl", "version", "-o", "json"], text=True))}
    (state / "validation.json").write_text(json.dumps(proof, indent=2) + "\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("version", "select-release", "record", "render", "validate"))
    parser.add_argument("--chart", choices=CHARTS)
    parser.add_argument("--ref", help="Published release commit; metadata only, never checked out or executed")
    parser.add_argument("--state", type=Path, default=Path("reports/tutorial-ueransim"))
    parser.add_argument("--source", choices=("candidate", "published"), default="published")
    parser.add_argument("--output", type=Path, default=Path("reports/tutorial-pages"))
    args = parser.parse_args()
    if args.command == "version":
        print((candidate_versions() if args.source == "candidate" else versions())[args.chart])
    elif args.command == "select-release":
        (ROOT / RELATIVE / "versions.json").write_text(json.dumps(candidate_versions(ROOT, args.ref), indent=2) + "\n")
    elif args.command == "record":
        record(ROOT, args.state, args.source)
    else:
        proof = json.loads((args.state / "validation.json").read_text())
        if args.command == "render":
            render(ROOT, args.output, proof)
        else:
            validate_proof(ROOT, proof)


if __name__ == "__main__":
    main()
