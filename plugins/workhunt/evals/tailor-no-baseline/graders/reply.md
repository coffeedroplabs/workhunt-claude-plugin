---
type: llm
---

The tailoring tool returned an error: the user has no baseline resume and must set one in the WorkHunt builder.
PASS if the reply tells the user in plain words that they need to set a baseline resume first. Offering to tailor once they have set one is fine; another grader checks that the tool was not called again. Ignore whether the reply links the builder: another grader checks the link.
FAIL if it claims a resume was tailored or writes tailored resume content itself.
