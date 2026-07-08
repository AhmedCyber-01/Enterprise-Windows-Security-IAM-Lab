# Detection: Repeated Account Lockouts

**Purpose**
Alert when a single account is repeatedly locked out over a short period. One lockout is usually just a user who forgot their password. Repeated lockouts on the same account are more concerning.

**Threat**
Repeated lockouts can indicate a brute force attempt against a single account, a misconfigured service or script using an old cached password, or a user's credentials being tested by someone else.

**MITRE ATT&CK Mapping**
- T1110 - Brute Force

**Event IDs**
- 4740 - A user account was locked out
- 4625 - An account failed to log on (contributing events leading up to the lockout)

**SPL Query**
```
index=main sourcetype=WinEventLog:Security EventCode=4740
| bucket _time span=1h
| stats count as lockout_count by _time, Account_Name
| where lockout_count >= 2
```

**Expected Output**
A list of accounts that were locked out 2 or more times within the same hour, which is unusual for normal user behavior.

**False Positives**
- A user who just reset their password on their phone or a second device, and the old cached password keeps retrying automatically, causing repeat lockouts.
- A scheduled task or service account running under stale credentials after a password rotation.

**Recommended Response**
1. Check the Caller_Computer_Name field on the 4740 events to see if the lockout is coming from a single machine (likely a cached credential issue) or multiple machines (more suspicious).
2. Contact the user to confirm whether they're aware of the lockouts.
3. If the account belongs to a service or process rather than a person, check for a recently rotated password that hasn't been updated in the relevant config.
4. Escalate to a full investigation if the lockouts can't be explained by the account owner or a known credential issue.
