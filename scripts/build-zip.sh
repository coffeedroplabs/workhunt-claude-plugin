#!/usr/bin/env bash
# Builds the zip users upload to claude.ai and Claude Cowork: the plugin only,
# without the eval suite, CI or scripts. Run from the repository root.
set -euo pipefail

out=${1:-workhunt-plugin.zip}
rm -f "$out"
git ls-files -z -- .claude-plugin .mcp.json skills assets LICENSE README.md \
  | xargs -0 zip -q -X "$out"
echo "Built $out:"
unzip -l "$out"
