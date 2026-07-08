# 06 - Group Policy

## Where I Configured This

All settings below were configured through Group Policy Management Console (GPMC) on DC01, mostly on the Default Domain Policy, with a couple of settings split into a separate policy linked to the domain root so I could keep audit settings distinct from password settings.

## Password Policy

Location: `Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies > Password Policy`

| Setting | Value | Why |
|---|---|---|
| Minimum password length | 12 characters | Longer passwords are harder to brute force than complex-but-short ones |
| Password must meet complexity requirements | Enabled | Requires a mix of character types |
| Maximum password age | 90 days | Rotates credentials periodically |
| Enforce password history | 10 passwords remembered | Stops users from cycling back to an old password immediately |

## Account Lockout Policy

| Setting | Value | Why |
|---|---|---|
| Account lockout threshold | 5 invalid attempts | Slows down brute force / password guessing attempts |
| Account lockout duration | 15 minutes | Temporary lockout instead of permanent, to reduce helpdesk load |
| Reset account lockout counter after | 15 minutes | Matches lockout duration |

## Audit Policy

Location: `Computer Configuration > Policies > Windows Settings > Security Settings > Advanced Audit Policy Configuration`

| Audit Subcategory | Setting | Why |
|---|---|---|
| Audit Logon | Success and Failure | Needed for Event ID 4624 (logon) and 4625 (failed logon) |
| Audit Account Management (User Account Management) | Success and Failure | Needed for Event IDs 4720 (user created), 4722/4725 (enabled/disabled), 4726 (user deleted) |
| Audit Security Group Management | Success and Failure | Needed for Event ID 4728/4732/4756 (member added to group) |
| Audit Object Access | Success and Failure | Needed to monitor access to the shared folders (with a SACL configured on the folder itself) |

I enabled Object Access auditing at the policy level, but I also had to manually configure the SACL (System Access Control List) on each shared folder through the folder's Advanced Security Settings > Auditing tab - the GPO setting alone doesn't audit anything until the specific object has an audit entry configured.

## Windows Defender / Firewall

I left Windows Defender and Windows Firewall on their default enabled settings for both DC01 and CLIENT01, and just documented that these should be enabled rather than building custom rules, since the focus of this lab was IAM and auditing rather than endpoint hardening.

## Mistake I Made

My first attempt at testing the audit policy showed nothing in the Security event log when I created a test user. I had enabled the audit policy at the domain level, but hadn't run `gpupdate /force` on DC01 before testing, so the policy hadn't actually applied yet. After forcing a policy update and re-testing, Event ID 4720 showed up as expected.

## What I Learned

- Enabling an audit policy through GPO and having it actually take effect are two different steps - a `gpupdate /force` (or waiting for the normal refresh interval) is required.
- Advanced Audit Policy settings and the legacy Audit Policy settings can conflict if both are configured. I made sure to only use the Advanced Audit Policy Configuration to avoid this.
