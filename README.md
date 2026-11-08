# WorkHunt for Claude

Tailor your resume to any job posting, write a matching cover letter and interview prep, and track every application, right inside Claude. The plugin bundles the WorkHunt connector, a remote MCP server at https://api.workhunt.ai/mcp, with four guided skills for the parts of a job search you repeat: tailoring to a posting, reviewing your pipeline, preparing for interviews and logging what happened.

## What you need

- A WorkHunt account, free to start at https://workhunt.ai, with a baseline resume set. Upload one or build one at https://app.workhunt.ai/builder, then mark it as your baseline.
- Interview prep needs a WorkHunt pass. AI tailoring uses your plan's daily allowance, the same as in the web app.
- Claude Code, Claude Cowork, or a claude.ai account where plugins and connectors are available.

## Install

### Claude Code

```
/plugin marketplace add coffeedroplabs/workhunt-claude-plugin
/plugin install workhunt@workhunt
```

Or from a shell:

```
claude plugin marketplace add coffeedroplabs/workhunt-claude-plugin
claude plugin install workhunt@workhunt
```

Then run `/mcp`, select workhunt and sign in. You sign in and approve on WorkHunt's own page; Claude never sees your password.

### claude.ai and Claude Cowork

Download this repo as a zip (Code > Download ZIP on GitHub), then in Claude open Customize > Plugins and upload it. Open the WorkHunt connector and sign in when asked.

The plugin will also be in the Claude plugin directory once it is listed there.

If you already added the WorkHunt connector directly, you do not need both; the plugin adds the skills on top of the same connector.

## Skills

Each skill is a short set of instructions that tells Claude which WorkHunt tools to call, in what order, and what to do with the result.

| Skill | Command | What it does | Try saying |
| --- | --- | --- | --- |
| tailor | `/workhunt:tailor` | Tailors your baseline resume to a posting (pasted text or a URL), then offers a cover letter and tracking. | "Tailor my resume to this job: [paste the posting]" |
| pipeline | `/workhunt:pipeline` | Reviews your applications by stage, flags upcoming and overdue next steps and applications that have gone quiet, and suggests moves. Changes nothing until you confirm. | "How's my job hunt going?" |
| prep | `/workhunt:prep` | Finds the tailored session for an application, generates interview prep (questions, company brief, recruiter scripts) and can run a short mock interview. | "Prep me for my Northwind interview" |
| track | `/workhunt:track` | Logs a new application, a status change, an interview date or a note from a plain-language message. | "Applied to Contoso for Software Engineer today, phone screen next Tuesday" |

Claude also picks the right skill on its own when you describe what you want; the slash commands are shortcuts.

## A first run

1. You paste a posting and ask for a tailored resume. Claude tailors it in WorkHunt and gives you a link to review every change, with a short note on what it emphasised for the role.
2. You ask for a cover letter. Claude generates it, shows the body and links to it in WorkHunt.
3. You say you applied today. Claude checks the tracker, adds the application as applied and links the tailored resume to it.
4. A week later you ask how the job hunt is going. Claude runs the pipeline review and suggests the follow-ups worth doing this week.

## Tools

The connector gives Claude these tools:

- `list_resumes`, `get_resume`
- `tailor_resume`
- `generate_cover_letter`, `get_cover_letter`
- `generate_interview_prep`, `get_interview_prep`
- `list_applications`, `get_application`, `add_application`, `update_application_status`, `add_application_note`

Nothing can be deleted through Claude; deleting and editing resume content happen in the WorkHunt app. Tailoring and interview prep spend your AI allowance, and Claude asks before tailoring unless you asked for it directly.

## Troubleshooting

- No WorkHunt tools available: run `/mcp` in Claude Code and sign in to workhunt, or in claude.ai enable the WorkHunt connector under Settings > Connectors.
- "Set a baseline resume first": open https://app.workhunt.ai/builder, upload or build a resume and mark it as baseline.
- Hitting a daily limit: AI tailoring uses the same daily allowance as the web app, so try again tomorrow or use the app.
- Prep asks for a WorkHunt pass: interview prep is part of the pass, and the message links to where you can get one.
- Commands not showing: restart Claude Code after installing, then run `/plugin` to confirm the plugin is enabled.

## Privacy and support

- Privacy policy: https://workhunt.ai/privacy/ (see the section "ChatGPT & Claude"). We never sell your data and your resume is never used to train AI models. Data is stored in Sydney, Australia.
- Terms: https://workhunt.ai/terms/
- Support: https://workhunt.ai/contact/ or support@workhunt.ai
- Setup guide: https://app.workhunt.ai/connect

## Development

- Validate the plugin: `claude plugin validate . --strict`
- Run the evals: `claude plugin eval .`. They use mocked tools, so no real account or AI allowance is spent.
- Iterate on one case: `claude plugin eval . --case <name> --runs 1 --ablation none`
- Cases live in `evals/<case>/`, tool mocks in `evals/mocks/workhunt/`, and `evals/mocks/workhunt/_tools.json` holds the server's real tools/list response.
- Try a local checkout: `claude plugin marketplace add ./` then `claude plugin install workhunt@workhunt`.

## License

MIT, see LICENSE.