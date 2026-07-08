# 07 - Windows Auditing

## Overview

After configuring the audit policies, I performed different administrative actions in Active Directory and verified that the corresponding Windows Security events were generated.

## Events Verified

| Action | Event ID |
|--------|----------|
| User account created | 4720 |
| User account deleted | 4726 |
| User account disabled | 4725 |
| User account enabled | 4722 |
| Password changed | 4723 |
| Password reset | 4724 |
| User added to a security group | 4728 / 4732 / 4756 |
| Successful logon | 4624 |
| Failed logon | 4625 |
| Account locked out | 4740 |
| User added to Domain Admins | 4728 |

For each event, I generated the activity in Active Directory and confirmed it in **Event Viewer** before forwarding the logs to Splunk.

---

## What I Learned

This exercise helped me understand how common Active Directory actions appear in the Windows Security log. I also learned that group membership events use different Event IDs depending on whether the group is **Global**, **Local**, or **Universal**, which was something I hadn't noticed before.
