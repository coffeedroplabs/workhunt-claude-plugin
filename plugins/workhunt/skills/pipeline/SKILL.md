---
name: pipeline
description: "Reviews the user's WorkHunt job application pipeline: what is in each stage, upcoming and overdue next steps, applications that have gone quiet, and suggested moves. Use when the user asks how their job hunt or applications are going, what to follow up on, or wants a pipeline review or weekly check-in."
---

# Review the job pipeline

Give the user a compact, honest read of where their WorkHunt pipeline stands, what needs attention, and which moves to make next.

## Workflow

1. Call `list_applications` with no status filter.

   If `totalCount` is larger than the number of applications you received, call it again with `page`: 2, 3, and so on until you have them all.

2. If there are none, say so, give the `trackerUrl`, and offer to log the first one: ask what they applied to and for which role.

3. Summarise counts by stage in pipeline order: tailored, applied, screening, interview, offer, then the closed stages (rejected, withdrawn, ghosted) kept to a single line.

4. Flag what needs attention, measured against today's date, as a short list giving company, role and the date:

   - Upcoming: `nextDate` within the next 7 days.

   - Overdue: `nextDate` in the past on an open application (not rejected, withdrawn or ghosted).

   - Gone quiet: status applied or screening, `updatedAt` more than 14 days ago, and no upcoming `nextDate`. Suggest a follow-up, or marking it ghosted once it is past 30 days.

   - Offers: every application sitting in offer.

   State how many days away or how many days ago each date is.

5. Suggest concrete moves as a numbered list, for example "Move Contoso to ghosted" or "Follow up with Fabrikam this week". Change nothing yet.

6. Only after the user confirms a move, or the whole list, call `update_application_status` for each confirmed one. When only the date changes, pass the current status alongside the new `nextDate`. Never change a status on your own judgement.

   If the user shares extra detail such as who they spoke to or what was agreed, offer `add_application_note` for it.

7. Finish with the `trackerUrl`.

Keep the review compact: a table or a tight list, never a paragraph per application.

## Output shape

| Stage | Count |
| --- | --- |
| Interview | 2 |
| Applied | 9 |

Needs attention:

- Fabrikam, Backend Engineer: next step was due 3 days ago.
- Contoso, Platform Engineer: no movement for 31 days, consider ghosted.

Suggested moves:

1. Move Contoso to ghosted.
2. Follow up with Fabrikam this week.

## Rules

- Tools are named by their bare names (`tailor_resume`, `list_applications`, and so on). Depending on the client they carry a prefix such as `mcp__plugin_workhunt_workhunt__` or a connector prefix; any WorkHunt tool with the matching bare name is the right one. If no WorkHunt tools are available at all, tell the user to connect WorkHunt: run `/mcp` in Claude Code and sign in to "workhunt", or in claude.ai enable the WorkHunt connector under Settings > Connectors. Do not try to do the task another way.

- Never delete anything (there are no delete tools). Deleting and editing resume content happen in the WorkHunt app.

- A WorkHunt tool error is written for the user (for example "Set a baseline resume first ...", a daily limit, "needs a WorkHunt pass"). Relay it in plain words, include any link it contains, and do not retry the call.

- End with the WorkHunt link the last relevant tool returned (`tailorUrl`, `editUrl`, `openUrl` or `trackerUrl`) so the user can review or continue in WorkHunt.

- Dates go to tools as ISO 8601 (YYYY-MM-DD).
