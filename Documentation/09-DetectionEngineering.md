# 09 - Detection Engineering

## What This Section Is

Once I had logs flowing into Splunk, I wanted to go a step further than just writing search queries - I wanted to write them the way an actual detection rule is documented in a SOC, with a clear purpose, the threat it's catching, the MITRE ATT&CK mapping, and what a real analyst would do when it fires.

The four detections I built are in the `DetectionRules/` folder:

1. `PrivilegedAccountCreated.md`
2. `PasswordSpray.md`
3. `AccountLockout.md`
4. `UserAddedToAdmins.md`

Each one follows the same structure:

- Purpose
- Threat it addresses
- MITRE ATT&CK mapping
- Relevant Event IDs
- SPL query
- Expected output
- Known false positives
- Recommended response

## How I Picked These Four

I picked these based on what I could realistically simulate and test in my own lab, and what came up repeatedly in SOC analyst job postings and TryHackMe SOC rooms:

- **Privileged account created** - a new account showing up unexpectedly in a privileged group is a classic sign of either a misconfiguration or an attacker establishing persistence.
- **Password spray** - one of the most common real-world attack patterns against exposed authentication endpoints, and something I could actually simulate with repeated failed logins across multiple accounts.
- **Account lockout** - closely related to password spray, but focused on legitimate account lockout behavior that could indicate either an attack or a user who forgot their password.
- **User added to Domain Admins** - the highest-impact privilege escalation event in an AD environment, and directly testable in my lab.

## Testing Each Detection

For each rule, I didn't just write the SPL query and assume it worked - I actually performed the action in the lab (created a privileged account, ran repeated failed logins, added a user to Domain Admins) and confirmed the query returned the expected result before considering the detection "done." A couple of my first draft queries returned zero results because I had the wrong field name, which I only caught by testing against real generated events.

## What I Learned

- Writing a detection rule is not the same as writing a search query. The MITRE mapping and false positive notes forced me to think about *why* this matters and *who* would act on it, not just whether the syntax works.
- Testing detections against events I generated myself (instead of trusting sample data) is the only way I'd actually trust a detection rule in a real environment.
