#!/usr/bin/env python3
"""
init.py — post-initialization script for AI-dev-template.

Reads .ai-dev-template.config.json and strips all configuration-conditional
sections from template files, leaving only the instructions applicable to
this specific project configuration.

Run once after creating a repository from this template and filling in
.ai-dev-template.config.json.

Usage:
    python scripts/init.py

Marker syntax used in template files:
    <!-- IF:dotted.path=value -->
        content kept when condition is true
    <!-- END IF -->

    <!-- IF:dotted.path!=value -->
        content kept when condition is false
    <!-- END IF -->

    {{dotted.path}}  — replaced with the actual value from config

Markers can be nested. Blank lines around removed blocks are collapsed.
Ordered list items are renumbered after stripping.
"""

import json
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).parent.parent

# Files to process with IF-marker stripping
PROCESS_FILES = [
    REPO_ROOT / "AGENTS.md",
    REPO_ROOT / "docs" / "07-workflow.md",
    REPO_ROOT / "docs" / "08-vector-db.md",
    REPO_ROOT / "templates" / "session-start-checklist.md",
]

# (config_path, operator, compare_value, file_to_delete, reason)
CONDITIONAL_DELETIONS = [
    ("rag.mode", "==", "off", "docs/08-vector-db.md",                "rag is disabled"),
    ("rag.mode", "==", "off", "docker-compose.vector-db.yml",        "rag is disabled"),
    ("rag.mode", "==", "off", ".env.example",                        "rag is disabled"),
    ("pull_requests.enabled", "==", "false", ".github/PULL_REQUEST_TEMPLATE.md",
                                                                      "pull requests disabled"),
    # Post-init: the workflow-configuration doc explains the config fields
    # to a human setting up the project. After init the config is fixed,
    # so this explanatory doc adds noise to the agent context without value.
    (None, "always", None,   "docs/11-workflow-configuration.md",    "not needed post-init"),
]


# ── Config helpers ────────────────────────────────────────────────────────────

def get_value(config: dict, path: str):
    """Return value at dotted path, or None if missing."""
    current = config
    for part in path.split("."):
        if not isinstance(current, dict):
            return None
        current = current.get(part)
    return current


def evaluate_condition(config: dict, condition: str) -> bool:
    """Evaluate 'path=value' or 'path!=value'."""
    condition = condition.strip()
    if "!=" in condition:
        path, expected = condition.split("!=", 1)
        actual = get_value(config, path.strip())
        return str(actual).lower() != expected.strip().lower()
    if "=" in condition:
        path, expected = condition.split("=", 1)
        actual = get_value(config, path.strip())
        return str(actual).lower() == expected.strip().lower()
    return False


# ── Content processors ────────────────────────────────────────────────────────

_IF_RE  = re.compile(r"^<!--\s*IF:(.*?)\s*-->$")
_END_RE = re.compile(r"^<!--\s*END IF\s*-->$")


def process_conditionals(content: str, config: dict) -> str:
    """
    Strip <!-- IF:cond --> ... <!-- END IF --> blocks.
    Supports arbitrary nesting via a boolean stack.
    """
    lines = content.split("\n")
    result = []
    stack: list[bool] = []   # True = include, False = skip

    for line in lines:
        stripped = line.strip()
        m_if  = _IF_RE.match(stripped)
        m_end = _END_RE.match(stripped)

        if m_if:
            # Evaluate only when all parent levels are active
            active = all(stack) if stack else True
            is_true = evaluate_condition(config, m_if.group(1)) if active else False
            stack.append(is_true)
            # Drop the marker line itself

        elif m_end:
            if stack:
                stack.pop()
            # Drop the marker line itself

        else:
            if all(stack) if stack else True:
                result.append(line)

    return "\n".join(result)


def substitute_values(content: str, config: dict) -> str:
    """Replace {{dotted.path}} with actual config values."""
    def replacer(m):
        val = get_value(config, m.group(1).strip())
        return str(val) if val is not None else m.group(0)
    return re.sub(r"\{\{(.*?)\}\}", replacer, content)


def collapse_blank_lines(content: str) -> str:
    """Collapse three or more consecutive blank lines to two."""
    return re.sub(r"\n{3,}", "\n\n", content)


def renumber_ordered_lists(content: str) -> str:
    """
    Renumber ordered list items so they are always sequential.
    A blank line or a non-list line resets the counter for that indent level.
    """
    lines = content.split("\n")
    result = []
    counters: dict[int, int] = {}

    for line in lines:
        m = re.match(r"^( *)(\d+)\. (.+)$", line)
        if m:
            indent   = len(m.group(1))
            orig_num = int(m.group(2))
            text     = m.group(3)

            # Clear deeper indent counters when stepping out
            for k in list(counters.keys()):
                if k > indent:
                    del counters[k]

            # Start fresh when the author wrote 1 or the level is new
            if orig_num == 1 or indent not in counters:
                counters[indent] = 1
            else:
                counters[indent] += 1

            result.append(f"{m.group(1)}{counters[indent]}. {text}")
        else:
            result.append(line)
            if not line.strip():
                counters = {}   # blank line resets all counters

    return "\n".join(result)


def process_file(path: Path, config: dict) -> None:
    if not path.exists():
        return
    content = path.read_text(encoding="utf-8")
    content = process_conditionals(content, config)
    content = substitute_values(content, config)
    content = collapse_blank_lines(content)
    content = renumber_ordered_lists(content)
    content = content.strip() + "\n"
    path.write_text(content, encoding="utf-8")
    print(f"  processed  {path.relative_to(REPO_ROOT)}")


# ── File deletion ─────────────────────────────────────────────────────────────

def maybe_delete(config: dict, cfg_path, operator, compare, rel_file: str, reason: str) -> None:
    target = REPO_ROOT / rel_file
    if not target.exists():
        return

    if operator == "always":
        should_delete = True
    elif operator == "==":
        actual = get_value(config, cfg_path)
        should_delete = str(actual).lower() == compare.lower()
    elif operator == "!=":
        actual = get_value(config, cfg_path)
        should_delete = str(actual).lower() != compare.lower()
    else:
        should_delete = False

    if should_delete:
        target.unlink()
        print(f"  deleted    {rel_file}  ({reason})")


# ── Entry point ───────────────────────────────────────────────────────────────

def main() -> None:
    config_path = REPO_ROOT / ".ai-dev-template.config.json"
    if not config_path.exists():
        print("Error: .ai-dev-template.config.json not found in repository root.")
        sys.exit(1)

    config = json.loads(config_path.read_text(encoding="utf-8"))

    rag_mode   = get_value(config, "rag.mode") or "off"
    pr_enabled = get_value(config, "pull_requests.enabled")
    exec_mode  = get_value(config, "workflow.execution_mode") or "hybrid"

    print("=== AI-dev-template init ===")
    print(f"  execution_mode        = {exec_mode}")
    print(f"  rag.mode              = {rag_mode}")
    print(f"  pull_requests.enabled = {pr_enabled}")
    print()

    print("Processing files...")
    for f in PROCESS_FILES:
        process_file(f, config)

    print("\nRemoving unused files...")
    for row in CONDITIONAL_DELETIONS:
        maybe_delete(config, *row)

    print("\nDone.")
    print("The repository is now tailored to its configuration.")
    print("Review the changes with `git diff` before committing.")


if __name__ == "__main__":
    main()
