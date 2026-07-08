# Lessons Learned

I kept this file separate from the individual documentation pages because a few things I learned span the whole project rather than one specific part.

## Technical Lessons

- **DNS is the foundation of AD.** My first domain join failure was a DNS misconfiguration on the client, not an AD problem at all. A lot of "AD issues" I've since read about online actually trace back to DNS.
- **Enabling an audit policy isn't enough by itself.** Between GPO settings not applying until a `gpupdate /force`, and Object Access auditing needing a SACL configured on the actual folder, I learned that auditing has more moving parts than "turn it on."
- **Group scope matters for auditing.** Global, Domain Local, and Universal groups generate different Event IDs for membership changes (4728 / 4732 / 4756). I didn't know this before building the lab.
- **Least privilege has to be tested, not just configured.** I found a leftover "Authenticated Users" permission on a share that I never would have caught without logging in as a low-privilege test account and trying to access it directly.
- **Offboarding needs a defined order of operations.** Disabling an account without removing its group memberships leaves a gap - if the account is ever re-enabled (by mistake or otherwise), it comes back with full access. I only caught this because I made the mistake myself and then had to fix it.

## Process / Workflow Lessons

- Doing each task manually before scripting it made the scripts better, because I understood exactly what needed automating instead of guessing at parameters.
- Testing detections against events I generated myself (rather than trusting the query looked syntactically correct) caught mistakes early - a couple of my first SPL queries returned zero results because I had the wrong field name.
- Writing the incident scenarios based on my own mistakes (the offboarding gap, the leftover share permission) made them feel a lot more real than scenarios I would have just invented from scratch.

## What I'd Do Differently Next Time

- Set up a second domain controller from the start, so I could also document replication and understand what happens when one DC goes down.
- Add Sysmon earlier in the process - I only thought about process-level telemetry after finishing the Windows Security log work, and it would have made the "compromised account" investigation scenario more realistic.
- Keep a running log of mistakes as I made them, rather than trying to remember them afterward for this documentation. A few smaller issues I ran into definitely didn't make it into these docs because I forgot the details by the time I sat down to write.
