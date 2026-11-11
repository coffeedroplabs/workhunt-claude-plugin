# WorkHunt for Claude

Tailor your resume to any job posting, write a matching cover letter and interview prep, and track every application, right inside Claude.

Install steps, skills, privacy and support are in the [plugin README](plugins/workhunt/README.md).

## Repository layout

- `plugins/workhunt/` is the plugin: its manifest, the WorkHunt connector entry, four skills and the icon. It is the folder the Claude plugin directory scans, and the release zip is built from it. Its `evals/` folder lives there because `claude plugin eval` only reads cases inside the plugin, but the zip leaves it out.
- `.claude-plugin/marketplace.json` lists the plugin, so `/plugin marketplace add coffeedroplabs/workhunt-claude-plugin` finds it.
- `scripts/`, `.github/` and `docs/` are development tooling and submission notes. They sit outside the plugin folder so the directory does not hold the plugin for reviewing them.

## Development

- Validate the marketplace and the plugin: `claude plugin validate . --strict` and `claude plugin validate plugins/workhunt --strict --profile directory`
- Run the repository checks CI runs: `./scripts/check-plugin.sh`
- Run the evals: `claude plugin eval plugins/workhunt`. They use mocked tools, so no real account or AI allowance is spent.
- Iterate on one case: `claude plugin eval plugins/workhunt --case <name> --runs 1 --ablation none`
- Cases live in `plugins/workhunt/evals/<case>/`, tool mocks in `plugins/workhunt/evals/mocks/workhunt/`, and `_tools.json` there holds the server's real tools/list response.
- Try a local checkout: `claude plugin marketplace add ./` then `claude plugin install workhunt@workhunt`.

### Releasing

1. If the server's tools changed, replace `plugins/workhunt/evals/mocks/workhunt/_tools.json` with the live `tools/list` response and update any mock or skill that names a changed field.
2. Bump `version` in `plugins/workhunt/.claude-plugin/plugin.json` (without a bump, `claude plugin update` reports nothing new) and add a dated entry to `CHANGELOG.md` (`## [x.y.z] - YYYY-MM-DD`).
3. Run `./scripts/check-plugin.sh`, both validate commands above and `claude plugin eval plugins/workhunt`; every case must pass.
4. Merge to `main`, then `claude plugin tag --push plugins/workhunt`. The `workhunt--v<version>` tag runs the evals in CI and publishes a GitHub release with `workhunt-plugin.zip`.

## License

MIT, see LICENSE.

## Also listed on

- [Claude AI Directory](https://www.claudeai.directory/launches/workhunt), a community directory not run by Anthropic.
