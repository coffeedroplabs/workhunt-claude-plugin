# Claude plugin directory submission

Working notes for submitting at https://claude.ai/directory/manage (Submit new > Plugin bundle). Checked boxes were verified on 2026-11-11; the rest need your accounts.

## Before submitting

- [x] The repository is public.
- [ ] `main` has the `Validate` workflow passing.
- [ ] `workhunt--v<version>` is tagged and the GitHub release has `workhunt-plugin.zip`.
- [ ] The WorkHunt connector (the MCP server at `https://api.workhunt.ai/mcp`) is submitted or listed as a connector.
- [ ] Tool descriptions on the server contain no instructions aimed at Claude. `tailor_resume` and `get_resume` used to; the fix is on `resumae-api` branch `claude/eloquent-allen-jjh2uj` and takes effect once that is merged and deployed. The skills carry the guidance instead.
- [ ] `evals/mocks/workhunt/_tools.json` matches the live connector's tools (names, descriptions and input fields). It already holds the corrected `tailor_resume` and `get_resume` descriptions, so it matches again once the `resumae-api` fix is deployed.
- [ ] A reviewer test account exists (see below).
- [x] Privacy, terms, contact and setup URLs in `.claude-plugin/plugin.json` load without signing in.
- [x] The MCP endpoint answers unauthenticated requests with 401 and OAuth metadata (PKCE S256, dynamic client registration, refresh tokens).
- [ ] The release zip uploads cleanly in claude.ai and Claude Cowork. If the upload rejects the `argument-hint` key in `skills/{tailor,prep,track}/SKILL.md`, remove it; `$ARGUMENTS` works without it.

## Source

- Repository: `coffeedroplabs/workhunt-claude-plugin`
- Track: `main`, publishing each version manually until a few releases have gone through.

## Listing details

- Name: WorkHunt
- Short description: Tailor resumes to job postings and track your job applications with WorkHunt.
- Long description: Tailor your resume to any job posting, write a matching cover letter and interview prep, and track every application through your pipeline, without leaving Claude. Four skills cover the parts of a job search you repeat: tailoring to a posting, reviewing your pipeline, preparing for interviews and logging what happened.
- Category: Productivity
- Example prompts:
  - "Tailor my resume to this job: [paste the posting]"
  - "How's my job hunt going?"
  - "Prep me for my Northwind interview"
  - "Applied to Contoso for Software Engineer today, phone screen next Tuesday"
- Icon: `assets/icon.png` (512 x 512)
- Documentation: https://app.workhunt.ai/connect
- Support: https://workhunt.ai/contact/ and support@workhunt.ai
- Privacy policy: https://workhunt.ai/privacy/
- Terms: https://workhunt.ai/terms/

## Data handling

- What leaves Claude: the job posting text the user asks to tailor to, and the application details the user asks to log (company, role, status, dates, notes). Sent only to `https://api.workhunt.ai/mcp`, only when Claude calls a tool.
- What comes back: the user's own resumes, cover letters, interview prep and applications.
- Authentication: OAuth on WorkHunt's sign-in page. The plugin holds no credentials and has no `userConfig`.
- Local execution: none. No hooks, commands, agents or bundled binaries.
- Other network access: none by the plugin. The tailor skill may ask Claude to fetch a job posting URL the user supplied, with Claude's own web fetch tool.
- Storage: Sydney, Australia (database, file storage and API hosting). WorkHunt stores what Claude's requests create (tailored resumes, cover letters, interview prep, applications) in the user's account.
- AI processing on WorkHunt's side: tailoring, cover letters and interview prep are written by WorkHunt's model provider (through OpenRouter, currently Google), with data collection disabled.
- Retention: data is kept while the account is open. Deleting the account from Settings takes effect immediately; only billing records and audit entries required by law are kept.
- Connection: access tokens last an hour and renew for up to 30 days of inactivity, at most 90 days after approval. Users disconnect from Claude's connector settings.
- Model training and sale: resume and job-search content is not used to train AI models, and personal information is not sold.

These statements were checked against https://workhunt.ai/privacy/ (last updated 8 November 2026) on 2026-11-11.

## Compliance

- Licence: MIT (`LICENSE`).
- Destructive actions: none. No tool deletes anything; every tool declares `destructiveHint: false`.
- Paid usage: tailoring spends one of the user's daily AI analyses, and interview prep needs a WorkHunt pass. The skills ask before tailoring unless the user asked for it directly.

## Reviewer test account

Provide through the form, never in this repository:

- An account with a baseline resume, at least five applications across stages (one with a tailored session), an active WorkHunt pass and enough daily allowance for several tailoring runs.
- Steps: install the plugin, sign in to the WorkHunt connector, then try the four example prompts above.

## After listing

- Replace the README line "The plugin will also be in the Claude plugin directory once it is listed there." with the directory install step.
- Ask about a listing in `anthropics/claude-plugins-official` through that repository's submission form or an Anthropic contact.
