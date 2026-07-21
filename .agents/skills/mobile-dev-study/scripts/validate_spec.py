#!/usr/bin/env python3
"""
validate_spec.py — Validates GSD specification files for a mobile study module directory.

Checks that CONTEXT.md, UI-SPEC.md (or SPEC.md), and RESEARCH.md exist and are non-empty.

Usage:
    python validate_spec.py <module_output_directory>

Exit codes:
    0 = all checks passed
    1 = critical failures found
"""

import sys
import os
import re
import json
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")



def read_text(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8", errors="ignore")
    except Exception:
        return ""


def check_gsd_spec_files(module_dir: Path) -> list[dict]:
    results = []
    
    # Check CONTEXT.md
    context_path = module_dir / "CONTEXT.md"
    if context_path.exists():
        content = read_text(context_path)
        if len(content.strip()) > 20:
            results.append({
                "check": "context_md_exists",
                "status": "PASS",
                "message": "CONTEXT.md found and valid",
                "path": str(context_path),
            })
        else:
            results.append({
                "check": "context_md_exists",
                "status": "CRITICAL",
                "message": "CONTEXT.md is empty or too short",
                "path": str(context_path),
            })
    else:
        results.append({
            "check": "context_md_exists",
            "status": "CRITICAL",
            "message": "CONTEXT.md NOT found",
            "path": str(context_path),
        })

    # Check UI-SPEC.md or SPEC.md
    ui_spec_path = module_dir / "UI-SPEC.md"
    spec_path = module_dir / "SPEC.md"
    target_spec = ui_spec_path if ui_spec_path.exists() else (spec_path if spec_path.exists() else None)
    
    if target_spec and target_spec.exists():
        content = read_text(target_spec)
        if len(content.strip()) > 20:
            results.append({
                "check": "ui_spec_exists",
                "status": "PASS",
                "message": f"{target_spec.name} found and valid",
                "path": str(target_spec),
            })
        else:
            results.append({
                "check": "ui_spec_exists",
                "status": "CRITICAL",
                "message": f"{target_spec.name} is empty or too short",
                "path": str(target_spec),
            })
    else:
        results.append({
            "check": "ui_spec_exists",
            "status": "CRITICAL",
            "message": "Neither UI-SPEC.md nor SPEC.md found",
            "path": str(module_dir),
        })

    # Check RESEARCH.md
    research_path = module_dir / "RESEARCH.md"
    if research_path.exists():
        content = read_text(research_path)
        if len(content.strip()) > 20:
            results.append({
                "check": "research_md_exists",
                "status": "PASS",
                "message": "RESEARCH.md found and valid",
                "path": str(research_path),
            })
        else:
            results.append({
                "check": "research_md_exists",
                "status": "WARNING",
                "message": "RESEARCH.md is empty or short",
                "path": str(research_path),
            })
    else:
        results.append({
            "check": "research_md_exists",
            "status": "WARNING",
            "message": "RESEARCH.md not created yet",
            "path": str(research_path),
        })

    return results


def validate_spec(module_dir: str) -> dict:
    module_path = Path(module_dir)
    report = {
        "module_path": str(module_path),
        "passed": [],
        "critical": [],
        "warnings": [],
        "info": [],
    }
    if not module_path.exists() or not module_path.is_dir():
        report["critical"].append({
            "check": "module_dir_exists",
            "status": "CRITICAL",
            "message": f"Module directory does not exist: {module_dir}",
        })
        return report

    all_checks = check_gsd_spec_files(module_path)
    for check in all_checks:
        status = check["status"]
        if status == "PASS":
            report["passed"].append(check)
        elif status == "CRITICAL":
            report["critical"].append(check)
        elif status == "WARNING":
            report["warnings"].append(check)
        else:
            report["info"].append(check)
    return report


def main():
    if len(sys.argv) != 2:
        print("Usage: python validate_spec.py <module_output_directory>")
        sys.exit(1)
    module_dir = sys.argv[1]
    report = validate_spec(module_dir)
    print(json.dumps(report, indent=2, ensure_ascii=False))
    
    total_pass = len(report["passed"])
    total_crit = len(report["critical"])
    total_warn = len(report["warnings"])
    print(f"\n{'='*60}")
    print(f"  ✅ Passed: {total_pass}  |  🔴 Critical: {total_crit}  |  ⚠️ Warnings: {total_warn}")
    print(f"{'='*60}")
    
    if total_crit > 0:
        sys.exit(1)
    elif total_warn > 0:
        sys.exit(2)
    else:
        sys.exit(0)


if __name__ == "__main__":
    main()
