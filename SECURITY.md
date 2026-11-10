# Security

## Reporting a vulnerability

Email support@workhunt.ai with "Security" in the subject. Please do not open a public issue for a vulnerability. Include what you found, how to reproduce it and what an attacker could do with it. We aim to reply within three business days.

## Scope

This repository holds the plugin: skill instructions, a connector entry and an eval suite. It contains no executable code and no credentials.

- In scope here: a skill instruction that could make Claude leak data, act without the user's consent or call a tool it should not; anything in the repository that should not be public.
- The WorkHunt service itself (`api.workhunt.ai`, `app.workhunt.ai`), including sign-in and the MCP server, is covered by the same contact address.

## Supported versions

Only the latest release receives fixes.
