# 06 - Group Policy

## Overview

I used **Group Policy Management Console (GPMC)** to configure password, account lockout, and audit policies for the domain.

---

## Password Policy

| Setting | Value |
|---------|-------|
| Minimum password length | 12 characters |
| Password complexity | Enabled |
| Maximum password age | 90 days |
| Password history | 10 passwords |

---

## Account Lockout Policy

| Setting | Value |
|---------|-------|
| Lockout threshold | 5 failed attempts |
| Lockout duration | 15 minutes |
| Reset counter | 15 minutes |

---

## Audit Policy

To collect useful Windows Security events in Splunk, I enabled the following audit policies:

| Audit Policy | Purpose |
|--------------|---------|
| Logon Events | Successful and failed logons |
| User Account Management | User creation, deletion, enable/disable |
| Security Group Management | Group membership changes |
| Object Access | Access to shared folders |

I also configured auditing on the shared folders so these events would be recorded.

---

## What I Learned

While testing, I noticed that no security events were being generated after changing the audit policy. Running `gpupdate /force` applied the policy, and the expected Windows Security events started appearing. This helped me understand that configuring a Group Policy is only the first step—it also needs to be applied before testing.
