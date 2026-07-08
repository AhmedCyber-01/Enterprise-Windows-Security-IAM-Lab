# Detection: Password Spray

**Purpose**
Detect a low-and-slow authentication attack where a small number of passwords are tried against many different accounts, rather than many passwords against one account. This pattern is designed to avoid tripping a per-account lockout threshold.

**Threat**
Password spraying lets an attacker try common or leaked passwords across an entire user list without locking out any single account, making it harder to catch with a simple lockout-based alert.

**MITRE ATT&CK Mapping**
- T1110.003 - Brute Force: Password Spraying

**Event IDs**
- 4625 - An account failed to log on

**SPL Query**
```
index=main sourcetype=WinEventLog:Security EventCode=4625
| bucket _time span=5m
| stats dc(Account_Name) as unique_accounts, count as attempts by _time, src_ip
| where unique_accounts >= 4
```

**Expected Output**
Time-bucketed results showing 4 or more distinct account names generating failed logons from the same source within a 5-minute window - a strong indicator of a spray rather than a single mistyped password.

**False Positives**
- A shared workstation where multiple users log in and out throughout the day and occasionally mistype a password.
- A service account restart storm where a misconfigured service tries to authenticate as several accounts in quick succession.

**Recommended Response**
1. Identify the source IP or hostname generating the failed attempts.
2. Check whether any of the targeted accounts had a *successful* login shortly after the failed attempts (this would indicate a successful spray hit).
3. Block or isolate the source if internal, or block the source IP at the firewall if external.
4. Force a password reset on any account with a suspicious successful login following the spray window.
