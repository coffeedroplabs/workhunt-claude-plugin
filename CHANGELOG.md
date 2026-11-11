# Changelog

All notable changes to the WorkHunt plugin for Claude are recorded here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the plugin uses [semantic versioning](https://semver.org/).

## [1.0.0] - 2026-11-11

### Added

- Skills: `tailor` (tailor a resume to a job posting, then offer a cover letter and tracking), `pipeline` (review the application pipeline and suggest moves), `prep` (interview prep and a mock interview) and `track` (log application updates from a plain-language message).
- The WorkHunt connector, a remote MCP server at `https://api.workhunt.ai/mcp`, with OAuth sign-in.
- An eval suite with mocked tools, so the skills can be tested without a WorkHunt account.
