# 07 - Windows Auditing

## Purpose

Once the audit policy from `06-GroupPolicy.md` was actually applying, I went through and generated each type of event myself so I could confirm the exact Event ID and see what the raw log entry looks like. This was useful because a lot of guides just list Event IDs without showing what triggered them.

## Events I Generated and Confirmed

| Action | Event ID | Log | Notes |
|---|---|---|---|
| User account created | 4720 | Security | Triggered by creating a new user in ADUC |
| User account deleted | 4726 | Security | Triggered by deleting a test user |
| User account disabled | 4725 | Security | Triggered by disabling an account during offboarding testing |
| User account enabled | 4722 | Security | Triggered by re-enabling a disabled test account |
| Password changed (by user) | 4723 | Security | Triggered by logging in and changing my own test password |
| Password reset (by admin) | 4724 | Security | Triggered when I reset a user's password from ADUC |
| User added to a security group | 4728 (global), 4732 (local), 4756 (universal) | Security | Depends on the group scope - I mostly saw 4728 since my groups are global |
| Failed logon | 4625 | Security | Triggered by intentionally typing the wrong password a few times |
| Successful logon | 4624 | Security | Triggered by normal logons |
| Account locked out | 4740 | Security | Triggered after 5 failed logon attempts, matching my lockout threshold |
| Privileged group membership change (Domain Admins) | 4728 | Security | Triggered by adding a test account to Domain Admins, then removing it |

## Example: Confirming Event 4720

Steps I took:

1. Opened ADUC on DC01
2. Created a new user, `test.audit`
3. Opened Event Viewer > Windows Logs > Security
4. Filtered for Event ID 4720
5. Found the entry, confirmed the "New Account Name" field matched `test.audit` and the "Subject" field showed my admin account as the one who created it

Screenshot in `Screenshots/AD/`.

## Mistake I Made

When I first went looking for Event ID 4728 (user added to a group), I couldn't find it anywhere in the log. I eventually realized my test group was a **Universal** group, not Global, so the correct Event ID was actually 4756, not 4728. This taught me that the Event ID depends on the group's scope, which I hadn't known before - I had just memorized "4728 = group membership change" without realizing there's a different ID for each group type.

## What I Learned

- Generating the events myself and searching the raw log was much more useful than just memorizing a table of Event IDs from a cheat sheet. I now understand what each event actually looks like, not just its number.
- Group scope (Global vs Domain Local vs Universal) affects which Event ID gets logged for membership changes - this is a detail that's easy to miss.
