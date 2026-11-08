---
name: prep
description: "Prepares the user for a job interview with WorkHunt interview prep (likely questions, a company brief, recruiter-screen scripts) and can run a short mock interview. Use when the user has an interview or screen coming up for a job they are tracking or tailored for, or asks to prep, practise or rehearse for an interview."
argument-hint: "[company or role]"
---

# Prepare for an interview

Get the user ready for a specific interview using the prep WorkHunt already holds for their tailored session.

## Workflow

1. Find the tailoring session. If a `sessionId` returned by tailor_resume is already in this conversation and matches the job, use it. Otherwise call list_applications and match the company or role from $ARGUMENTS or from the conversation, case-insensitive. If totalCount is larger than the first page, page through until you have seen every application. Use the matching application's `sessionId`. If several applications match, ask which one. If none matches, or the match has no `sessionId`, explain that prep is built from a tailored session, offer to tailor the resume to the posting first (the tailor workflow), and stop.
2. Call get_interview_prep(sessionId) first. It never generates anything and never spends anything.
3. If `questions`, `companyBrief` or `recruiterScripts` are null or empty, tell the user you are generating prep and that each call takes around 25 seconds, then call generate_interview_prep(sessionId). While `pending` is non-empty, call it again with `sections` set to `pending`. Stop after 4 calls in total and give the `openUrl` if anything is still pending.
4. If a tool says prep needs a WorkHunt pass, relay that in plain words with any link it contains and stop.
5. Summarise for the user:
   - the three to five most useful points from `companyBrief`;
   - the top five likely questions, one line each on what a strong answer covers, using the question's own guidance where present.
   Mention that the other sections exist (recruiter scripts, day-of checklist, technical challenges, resume coaching) without dumping them, and show any of them in full if asked.
6. Offer a short mock interview. If the user accepts, ask one question at a time from the generated questions, wait for their answer, then give brief feedback: what landed, what to tighten, and one concrete improvement, judged against that question's guidance and the company brief. Move on when the user is ready. Stop when they say so and end with a two-line summary of their strengths and the one thing to practise.
7. End with the `openUrl` link so the user can review the prep in WorkHunt.

## Rules

- Tools are named by their bare names (get_interview_prep, generate_interview_prep, list_applications, tailor_resume). Depending on the client they carry a prefix such as mcp__plugin_workhunt_workhunt__ or a connector prefix; any WorkHunt tool with the matching bare name is the right one. If no WorkHunt tools are available at all, tell the user to connect WorkHunt: run /mcp in Claude Code and sign in to "workhunt", or in claude.ai enable the WorkHunt connector under Settings > Connectors. Do not try to do the task another way.
- Never delete anything. There are no delete tools; deleting and editing resume content happen in the WorkHunt app.
- A WorkHunt tool error is written for the user (for example "Set a baseline resume first ...", a daily limit, or "needs a WorkHunt pass"). Relay it in plain words, include any link it contains, and do not retry the call.
- End with the WorkHunt link the last relevant tool returned (`openUrl`, `tailorUrl`, `editUrl` or `trackerUrl`) so the user can review or continue in WorkHunt.
- Dates go to tools as ISO 8601 (YYYY-MM-DD).
- Never invent facts about the company beyond the brief. If the user asks something the brief does not cover, say the brief does not cover it and suggest where they could check.
