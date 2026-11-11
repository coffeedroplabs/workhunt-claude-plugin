#!/usr/bin/env bash
# Builds the zip users upload to claude.ai and Claude Cowork: the plugin only,
# without the eval suite, CI or scripts. Run from the repository root.
set -euo pipefail

out=$(realpath -m "${1:-workhunt-plugin.zip}")
rm -f "$out"
# Zipped from inside the plugin folder so .claude-plugin/plugin.json sits at the
# zip's root, where the upload looks for it.
(
  cd plugins/workhunt
  git ls-files -z -- .claude-plugin .mcp.json skills assets LICENSE README.md \
    | xargs -0 zip -q -X "$out"
)
echo "Built $out:"
unzip -l "$out"
