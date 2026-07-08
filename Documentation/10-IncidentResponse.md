# 10 - Incident Investigations

## Why I Did This

Building detections is one thing, but I wanted to practice the part that actually matters in a SOC job: taking an alert and working through it like a real investigation, with a timeline, evidence, and a documented conclusion. I set up four scenarios in my lab, generated the actual events, and then investigated them as if I were seeing the alert cold.

Screenshots referenced below are in `Screenshots/Investigations/`.

---

## Scenario 1: Helpdesk Accidentally Adds User to Domain Admins

**Setup:** I simulated a helpdesk technician (`test.helpdesk`) adding `sneha.rao` (a Sales user) to the Domain Admins group, supposedly to fix a permissions issue, without realizing the impact.

**Timeline**

| Time | Event |
|---|---|
| 10:02 | `sneha.rao` reports she can't access a shared drive (simulated helpdesk ticket) |
| 10:05 | `test.helpdesk` logs into DC01 and adds `sneha.rao` to Domain Admins (Event ID 4728, Group_Name="Domain Admins") |
| 10:06 | Splunk alert fires on the "User Added to Domain Admins" detection |
| 10:10 | I (as the analyst) begin investigating |

**Evidence**

- Event ID 4728 in the Security log showing `sneha.rao` added to Domain Admins
- Subject account: `test.helpdesk`
- No corresponding change ticket or manager approval on file (simulated - there shouldn't be one, since this was a mistake)

**Impact**

A Sales user account now has full domain admin rights. This is a significant privilege escalation risk - if that account were compromised even by an unrelated phishing email, the attacker would have full control of the domain, not just Sales folder access.

**Containment**

Removed `sneha.rao` from Domain Admins immediately, confirmed via a follow-up Splunk search that no other unexpected group changes occurred from the same account around that time.

**Recovery**

Restored `sneha.rao`'s original group membership (`Sales_Read`), verified she could still access what she actually needed.

**Lessons Learned**

Helpdesk accounts should not have the ability to modify Domain Admins membership at all - that action should require a more restricted set of admin accounts, ideally with a change approval step. In a real environment, this is where I'd recommend delegating only the specific, limited AD permissions helpdesk actually needs, instead of broad admin rights.

---

## Scenario 2: Password Spray

**Setup:** I simulated a password spray by attempting a small number of common passwords against several different accounts in a short window (rather than many attempts against one account, which would just trigger a lockout).

**Timeline**

| Time | Event |
|---|---|
| 14:00 - 14:03 | Multiple Event ID 4625 (failed logon) entries across `priya.sharma`, `arjun.mehta`, `rohit.verma`, `sneha.rao` |

**Evidence**

SPL query from `DetectionRules/PasswordSpray.md` returned all four accounts with failed logon attempts within a 3-minute window, all from the same source computer name.

**Impact**

No accounts were compromised in my simulation (none of the guessed passwords matched), but this pattern is exactly what a password spray attack looks like in the logs - low volume per account, spread across many accounts, to avoid tripping a per-account lockout threshold.

**Containment**

In a real scenario, I'd recommend blocking the source IP/host and forcing a password reset on any account with a successful login shortly after the spray attempts (none occurred here).

**Recovery**

No recovery needed since this was a simulation with no successful logins.

**Lessons Learned**

Account lockout thresholds alone don't catch password spraying, since the attacker deliberately stays under the per-account threshold. A detection has to look across multiple accounts, not just one.

---

## Scenario 3: Compromised Account

**Setup:** I simulated a "compromised" scenario by logging into `arjun.mehta`'s account from CLIENT01 at an unusual time (for lab purposes, I just picked a time outside a "normal" 9-5 window I defined for the exercise) and then browsing folders his role wouldn't normally need.

**Timeline**

| Time | Event |
|---|---|
| 23:14 | Successful logon (Event ID 4624) for `arjun.mehta` on CLIENT01 |
| 23:16 | Access attempt to `\\DC01\IT-Share` (denied, since Finance_Read has no access there) |

**Evidence**

Successful off-hours logon followed by an access attempt to a resource outside the account's normal role.

**Impact**

Limited in this case since the access attempt was denied by the existing least-privilege controls (see `04-LeastPrivilege.md`) - this scenario mainly demonstrates how the permission model contains the blast radius even if credentials are compromised.

**Containment**

In a real scenario, I'd disable the account immediately and force a password reset, then check for any other unusual activity from the same account.

**Recovery**

Reset the account's password (simulated), confirmed normal access resumed afterward.

**Lessons Learned**

This scenario is really what tied the whole lab together for me - the least-privilege groups I set up earlier are the reason this "compromised" account couldn't actually reach the IT share, even after a successful logon. Detection and access control work together, not separately.

---

## Scenario 4: Disabled Account Re-enabled

**Setup:** Directly connected to the mistake I made in `05-UserProvisioning.md` - I disabled a test account without removing its group memberships, then re-enabled it to see what would happen.

**Timeline**

| Time | Event |
|---|---|
| 16:00 | Test account disabled (Event ID 4725), group memberships not removed |
| 16:05 | Test account re-enabled (Event ID 4722) |
| 16:06 | Account logs in successfully, still has original `Finance_Modify` access |

**Evidence**

Event ID 4722 (account enabled) shortly followed by a successful logon, with the account retaining its original group memberships.

**Impact**

An account that was supposedly offboarded came back with full access, because the offboarding process didn't remove group memberships. If this had been a real termination rather than a lab mistake, that's a serious gap.

**Containment / Recovery**

Fixed the underlying process: updated `PowerShell/DisableUser.ps1` to remove all group memberships as part of the disable step, not as a separate manual step that could be skipped.

**Lessons Learned**

This is the scenario that made the biggest impression on me. It came directly from a mistake I made, not something I planned in advance, which is exactly why I think it's worth including - it shows a real gap in the process rather than a textbook example.
