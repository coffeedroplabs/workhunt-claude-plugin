#!/usr/bin/env bash
# Repository checks the Claude plugin directory applies on submission that
# `claude plugin validate` does not cover. Run from the repository root.
set -euo pipefail

fail=0
err() { echo "ERROR: $*" >&2; fail=1; }

# Every JSON file parses.
while IFS= read -r f; do
  python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "$f" 2>/dev/null || err "$f is not valid JSON"
done < <(git ls-files '*.json')

# Every tool mock body is valid JSON once its frontmatter is removed.
for f in evals/mocks/*/*.md evals/*/mocks/*/*.md; do
  [ -e "$f" ] || continue
  python3 - "$f" <<'PY' || err "$f: mock body is not valid JSON"
import json, re, sys
text = open(sys.argv[1]).read()
front = re.match(r"\A---\n(.*?)\n---\n", text, flags=re.S)
if front and re.search(r"^error:\s*true\s*$", front.group(1), flags=re.M):
    sys.exit(0)  # an error mock's body is the error message, not JSON
text = re.sub(r"\A---\n.*?\n---\n", "", text, flags=re.S)
text = re.sub(r'"\{\{[^}]+\}\}"', '""', text)
json.loads(text)
PY
done

# Every tool the live server lists has a mock, and every mock names a real tool.
python3 - <<'PY' || fail=1
import json, pathlib, sys
tools = {t["name"] for t in json.load(open("evals/mocks/workhunt/_tools.json"))["tools"]}
mocks = {p.stem for p in pathlib.Path("evals/mocks/workhunt").glob("*.md")}
bad = False
for name in sorted(tools - mocks):
    print(f"ERROR: tool {name} has no mock", file=sys.stderr); bad = True
for name in sorted(mocks - tools):
    print(f"ERROR: mock {name} is not a tool in _tools.json", file=sys.stderr); bad = True
sys.exit(1 if bad else 0)
PY

# Every tool has a title and a read-only or destructive hint (connector review).
python3 - <<'PY' || fail=1
import json, sys
bad = False
for t in json.load(open("evals/mocks/workhunt/_tools.json"))["tools"]:
    a = t.get("annotations") or {}
    if not (t.get("title") or a.get("title")):
        print(f"ERROR: tool {t['name']} has no title", file=sys.stderr); bad = True
    if "readOnlyHint" not in a and "destructiveHint" not in a:
        print(f"ERROR: tool {t['name']} has no readOnlyHint or destructiveHint", file=sys.stderr); bad = True
    if len(t["name"]) > 64:
        print(f"ERROR: tool name {t['name']} is longer than 64 characters", file=sys.stderr); bad = True
sys.exit(1 if bad else 0)
PY

# The remote MCP server is https.
python3 - <<'PY' || fail=1
import json, sys
bad = False
for name, s in json.load(open(".mcp.json"))["mcpServers"].items():
    if not s.get("url", "").startswith("https://"):
        print(f"ERROR: MCP server {name} is not https", file=sys.stderr); bad = True
sys.exit(1 if bad else 0)
PY

# Each skill has a name matching its folder and a description within the limit.
for f in skills/*/SKILL.md; do
  python3 - "$f" <<'PY' || fail=1
import pathlib, re, sys
path = pathlib.Path(sys.argv[1])
m = re.match(r"\A---\n(.*?)\n---\n", path.read_text(), flags=re.S)
if not m:
    print(f"ERROR: {path} has no frontmatter", file=sys.stderr); sys.exit(1)
fm = dict(re.findall(r"^([\w-]+):\s*(.*)$", m.group(1), flags=re.M))
bad = False
if fm.get("name") != path.parent.name:
    print(f"ERROR: {path}: name must be {path.parent.name}", file=sys.stderr); bad = True
desc = fm.get("description", "").strip('"')
if not desc or len(desc) > 1024:
    print(f"ERROR: {path}: description missing or over 1024 characters", file=sys.stderr); bad = True
sys.exit(1 if bad else 0)
PY
done

# Files the directory rejects or holds for manual review.
while IFS= read -r f; do
  [ -L "$f" ] && err "$f is a symlink"
  case "$f" in *.DS_Store) err "$f must not be committed" ;; esac
  case "$f" in
    *.png|*.jpg|*.jpeg|*.gif|*.svg|*.webp) ;;
    *) [ "$(wc -c < "$f")" -gt 262144 ] && err "$f is over 256 KiB" ;;
  esac
done < <(git ls-files)
[ -f .gitmodules ] && err "submodules are not allowed"
[ "$(git ls-files | wc -l)" -gt 512 ] && err "more than 512 files"
[ -f LICENSE ] || err "LICENSE is missing"
[ "$(wc -w < README.md)" -ge 40 ] || err "README.md is under 40 words"

# The changelog has an entry for the version being released.
version=$(python3 -c 'import json; print(json.load(open(".claude-plugin/plugin.json"))["version"])')
grep -q "^## \[$version\]" CHANGELOG.md || err "CHANGELOG.md has no entry for $version"

[ "$fail" -eq 0 ] && echo "All repository checks passed (version $version)."
exit "$fail"
