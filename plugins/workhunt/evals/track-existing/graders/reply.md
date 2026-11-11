---
type: llm
---

The user's tracker already holds a Litware, Backend Engineer application in the interview stage. The track skill records the change without asking first, then states the date it resolved so the user can correct it.
PASS if the reply says the existing Litware application was updated with the new interview date and gives that date as a calendar date. Offering to fix the date if it is wrong is what the skill asks for, not a request for confirmation.
Ignore whether the date is right and whether the reply links the tracker: other graders check the recorded date and the link.
FAIL if it says it has not recorded the change yet and asks whether to, says a new application was added, says the status changed to something other than interview, or omits the date.
