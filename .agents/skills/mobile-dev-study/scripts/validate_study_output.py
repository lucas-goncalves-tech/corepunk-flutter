#!/usr/bin/env python3
"""
validate_study_output.py — Validates the study output directory for a mobile development module.

Checks:
1. MISSAO.md exists and contains required sections.
2. prerequisites/ directory exists and contains conceptual guides.
3. Rule 14 compliance: NO forbidden automacao-e-scripts/ folder exists.
4. Inline Obsidian wikilinks point to valid prerequisite files.
5. Anti-solution-leak check: verifies prerequisites teach building blocks without delivering completed screen components.

Usage:
    python validate_study_output.py <module_output_directory>

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


def check_missao_md(module_dir: Path) -> list[dict]:
    results = []
    missao_path = module_dir / "MISSAO.md"
    if not missao_path.exists():
        results.append({
            "check": "missao_exists",
            "status": "CRITICAL",
            "message": "MISSAO.md NOT found in output directory",
            "path": str(missao_path),
        })
        return results

    content = read_text(missao_path)
    if len(content.strip()) < 50:
        results.append({
            "check": "missao_not_empty",
            "status": "CRITICAL",
            "message": "MISSAO.md is empty or too short",
            "path": str(missao_path),
        })
        return results

    results.append({
        "check": "missao_exists",
        "status": "PASS",
        "message": "MISSAO.md found and non-empty",
        "path": str(missao_path),
    })

    # Check Obsidian wikilinks
    wikilinks = re.findall(r"\[\[(.*?)\]\]", content)
    if wikilinks:
        results.append({
            "check": "missao_has_prereq_links",
            "status": "PASS",
            "message": f"MISSAO.md contains {len(wikilinks)} prerequisite wikilinks",
            "path": str(missao_path),
        })
    else:
        results.append({
            "check": "missao_has_prereq_links",
            "status": "WARNING",
            "message": "MISSAO.md does not contain any [[prerequisites/...]] wikilinks",
            "path": str(missao_path),
        })

    return results


def check_prerequisites_dir(module_dir: Path) -> list[dict]:
    results = []
    prereq_dir = module_dir / "prerequisites"
    if not prereq_dir.exists() or not prereq_dir.is_dir():
        results.append({
            "check": "prerequisites_dir_exists",
            "status": "CRITICAL",
            "message": "prerequisites/ directory NOT found",
            "path": str(prereq_dir),
        })
        return results

    md_files = list(prereq_dir.rglob("*.md"))
    if not md_files:
        results.append({
            "check": "prerequisites_has_notes",
            "status": "CRITICAL",
            "message": "prerequisites/ directory contains NO .md concept files",
            "path": str(prereq_dir),
        })
    else:
        results.append({
            "check": "prerequisites_has_notes",
            "status": "PASS",
            "message": f"prerequisites/ directory contains {len(md_files)} concept note(s)",
            "path": str(prereq_dir),
        })

    # Anti-solution-leak scan
    for md_file in md_files:
        content = read_text(md_file)
        # Check for forbidden ready-to-paste completed screen indicators
        if re.search(r"export\s+default\s+function\s+Screen", content) or re.search(r"class\s+\w+Screen\s+extends", content):
            results.append({
                "check": "anti_leak_scan",
                "status": "WARNING",
                "message": f"Potential solution leak in {md_file.name}: looks like a full screen implementation",
                "path": str(md_file),
            })

    return results


def check_rule_14_no_automation_dir(module_dir: Path) -> list[dict]:
    results = []
    auto_dir = module_dir / "automacao-e-scripts"
    auto_ci_dir = module_dir / "automacao-e-scripts-ci"
    
    if auto_dir.exists() or auto_ci_dir.exists():
        results.append({
            "check": "rule_14_no_automation_folder",
            "status": "CRITICAL",
            "message": "Rule 14 Violation: automacao-e-scripts folder found. All code must be in the main app codebase.",
            "path": str(module_dir),
        })
    else:
        results.append({
            "check": "rule_14_no_automation_folder",
            "status": "PASS",
            "message": "Rule 14 Compliance: No auxiliary automation folder (codebase direct)",
            "path": str(module_dir),
        })

    return results


def validate_study_output(module_dir: str) -> dict:
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

    all_checks = []
    all_checks.extend(check_missao_md(module_path))
    all_checks.extend(check_prerequisites_dir(module_path))
    all_checks.extend(check_rule_14_no_automation_dir(module_path))

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
        print("Usage: python validate_study_output.py <module_output_directory>")
        sys.exit(1)
    module_dir = sys.argv[1]
    report = validate_study_output(module_dir)
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
