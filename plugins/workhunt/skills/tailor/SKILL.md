---
name: tailor
description: Tailors the user's resume to a specific job posting with WorkHunt, then offers a cover letter and tracking the application. Use when the user shares a job posting (text or URL) and wants their resume tailored, adapted or customised for it, or says "apply to this job". Do not use for general resume advice.
argument-hint: "[job posting text or URL]"
---

# Tailor a resume to a job

Adapt the user's baseline resume to one specific job posting with WorkHunt, then offer a
cover letter and tracking for the application.

## Workflow

1. **Get the posting.** Use the text in $ARGUMENTS or in the conversation. If it is a
   URL, fetch the page with the web fetch tool and extract the posting text (title,
   company, responsibilities, requirements). If the fetch fails or the page has no
   posting (login wall, expired listing), ask the user to paste the text. If there is no
   posting at all, ask for one. Pass the full posting text to the tool, not a summary.

2. **Identify the company and role.** Form jobTitle as "<Role> at <Company>", at most
   about 100 characters. If either part is unclear, leave jobTitle out instead of
   guessing.

3. **Confirm the spend only when needed.** tailor_resume uses one of the user's daily AI
   analyses. If the user clearly asked to tailor their resume to this posting, call it
   straight away without asking. If they only shared a posting or asked something softer
   ("thoughts on this job?"), ask once whether to tailor their resume to it and mention
   that it uses one daily analysis.

4. **Call tailor_resume once** with the full posting text and jobTitle. Never call it
   twice for the same posting in a conversation; keep the sessionId and reuse it.

5. **Report the result.** If resume.status is "generating", say the resume is being
   written and will be ready in WorkHunt shortly, and that it fills in by itself where
   the client shows an inline preview. Do not poll get_resume; call it only if the user
   later asks to see the content. If status is "failed", relay generationError. Otherwise
   the resume is written: summarise briefly what was emphasised for this role, based on
   the returned content. Always give tailorUrl so the user can review every change.

6. **Offer next steps in one short message:** a cover letter and tracking the
   application. Do not do either unprompted.

7. **Cover letter, if the user wants one.** Call generate_cover_letter(sessionId). If
   status is "generating", call get_cover_letter(sessionId) once; if it is still
   generating, give openUrl and say the letter will be there shortly. Show the body when
   it is ready.

8. **Track the application, if the user wants it.** Call list_applications first and look
   for an existing application with the same company and a similar role (compare
   case-insensitively). If one exists, offer to update it with update_application_status
   instead of adding a duplicate. Otherwise call add_application with company, role,
   status "tailored" (or "applied" if the user says they already applied, with
   appliedDate set to today), plus sessionId and resume.id from step 4 so the tailored
   resume is linked. Finish with trackerUrl.

## Rules

- Tools are named by their bare names (tailor_resume, list_applications, ...). Depending
  on the client they carry a prefix such as mcp__plugin_workhunt_workhunt__ or a
  connector prefix; any WorkHunt tool with the matching bare name is the right one. If no
  WorkHunt tools are available at all, tell the user to connect WorkHunt: run /mcp in
  Claude Code and sign in to "workhunt", or in claude.ai enable the WorkHunt connector
  under Settings > Connectors. Do not try to do the task another way.

- Never delete anything (there are no delete tools). Deleting and editing resume content
  happen in the WorkHunt app.

- A WorkHunt tool error is written for the user (for example "Set a baseline resume first
  ...", a daily limit, "needs a WorkHunt pass"). Relay it in plain words, include any link
  it contains, and do not retry the call.

- Never invent experience, and never claim the tailored resume contains something you
  have not seen in the tool output.

- End with the WorkHunt link the last relevant tool returned (tailorUrl, editUrl,
  openUrl or trackerUrl) so the user can review or continue in WorkHunt.

- Dates go to tools as ISO 8601 (YYYY-MM-DD).
