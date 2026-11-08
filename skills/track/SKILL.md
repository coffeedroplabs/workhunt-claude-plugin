---
name: track
description: "Logs job application updates in the WorkHunt tracker from a plain-language message: a new application, a status change, an interview or next-step date, or a note. Use when the user says they applied somewhere, heard back, got an interview, offer or rejection, or wants to record something about an application."
argument-hint: "[what happened, e.g. applied to Contoso SWE today]"
---

# Log an application update

Turn a plain-language update into the right WorkHunt tracker write.

## Workflow

1. Parse the message ($ARGUMENTS or the conversation) into: company, role, status, appliedDate, nextDate, and any extra detail worth a note (who they spoke to, salary discussed, next steps). Map phrases to statuses: "applied" -> applied, "recruiter call / phone screen" -> screening, "interview / onsite / panel" -> interview, "offer" -> offer, "rejected / turned down" -> rejected, "I withdrew / pulled out" -> withdrawn, "never heard back" -> ghosted. A scheduled screen or interview is a nextDate; only move the status forward if the user says it has happened or been booked (a booked phone screen means screening with nextDate on that day).
2. Resolve relative dates ("today", "next Tuesday", "in two weeks") against today's date and convert them to YYYY-MM-DD. "Next <weekday>" means the first such weekday after today. State the dates you resolved in your reply so the user can correct them.
3. Call list_applications to look for an existing application with the same company (case-insensitive) and a similar role. Page through if totalCount is larger than the first page.
4. If exactly one matches: call update_application_status(applicationId, status, nextDate) - pass the current status if only the date changes, and skip the call if nothing changes. Then, if there is extra detail, call add_application_note(applicationId, note) with a short factual note.
5. If none matches: call add_application with company, role, status (default applied), appliedDate (today if they say they applied today), nextDate and notes for any extra detail.
6. If more than one matches, or the company or role is missing, ask a short question before writing anything. Otherwise do not ask for confirmation: the user's message is the instruction.
7. Reply in one or two lines: what was recorded (company, role, status, dates) and trackerUrl.

## Rules

- Tools are named by their bare names (list_applications, add_application, ...). Depending on the client they carry a prefix such as mcp__plugin_workhunt_workhunt__ or a connector prefix; any WorkHunt tool with the matching bare name is the right one. If no WorkHunt tools are available at all, tell the user to connect WorkHunt: run /mcp in Claude Code and sign in to "workhunt", or in claude.ai enable the WorkHunt connector under Settings > Connectors. Do not try to do the task another way.
- Never delete anything (there are no delete tools). Deleting and editing resume content happen in the WorkHunt app.
- A WorkHunt tool error is written for the user (e.g. "Set a baseline resume first ...", a daily limit, "needs a WorkHunt pass"). Relay it in plain words, include any link it contains, and do not retry the call.
- End with the WorkHunt link the last relevant tool returned (tailorUrl, editUrl, openUrl or trackerUrl) so the user can review or continue in WorkHunt.
- Dates go to tools as ISO 8601 (YYYY-MM-DD).
- Never move an application backwards (for example offer to applied) unless the user says so explicitly.
