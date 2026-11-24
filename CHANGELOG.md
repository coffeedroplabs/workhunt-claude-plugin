# Changelog

All notable changes to the WorkHunt plugin for Claude are recorded here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the plugin uses [semantic versioning](https://semver.org/).

## [1.2.0] - 2026-11-25

### Changed

- `tailor` passes a job posting link to WorkHunt as `jobUrl`, and WorkHunt reads the page, instead of Claude fetching it with its web fetch tool. When a site blocks that (LinkedIn, SEEK), it asks for the posting text; the blocked attempt spends nothing.
- `prep` names the one or two questions to focus on, instead of listing them, where the client shows WorkHunt's interview prep card.
- The "connect WorkHunt" fallback, the homepage and the documentation link point to the setup guide at https://workhunt.ai/claude/.
- The daily allowance is called "AI tailoring sessions", as in the WorkHunt app.
- The eval mocks hold the connector's current 15 tools, with two new cases for job links.

## [1.1.0] - 2026-11-13

### Added

- The saved stage: `track` saves a job to apply to later, `pipeline` lists saved jobs first, and `tailor` moves a saved job to tailored.

## [1.0.0] - 2026-11-11

### Added

- Skills: `tailor` (tailor a resume to a job posting, then offer a cover letter and tracking), `pipeline` (review the application pipeline and suggest moves), `prep` (interview prep and a mock interview) and `track` (log application updates from a plain-language message).
- The WorkHunt connector, a remote MCP server at `https://api.workhunt.ai/mcp`, with OAuth sign-in.
- An eval suite with mocked tools, so the skills can be tested without a WorkHunt account.
