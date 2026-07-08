# Detection: Privileged Account Created

**Purpose**
Alert when a new user account is created and then immediately (or shortly after) added to a privileged group such as Domain Admins. This can indicate either a misconfiguration or an attacker establishing a persistence mechanism.

**Threat**
An attacker with some level of access creates a new account specifically so they have a backup way into the domain, even if the account they originally compromised gets found and disabled. This is a common persistence technique.

**MITRE ATT&CK Mapping**
- T1136.002 - Create Account: Domain Account
- T1098 - Account Manipulation (if the new account is then added to a privileged group)

**Event IDs**
- 4720 - A user account was created
- 4728 - A member was added to a security-enabled global group (e.g., Domain Admins)

**SPL Query**
```
index=main sourcetype=WinEventLog:Security EventCode=4720
| eval created_account=Account_Name
| join created_account
    [ search index=main sourcetype=WinEventLog:Security EventCode=4728 Group_Name="Domain Admins"
      | eval created_account=Account_Name ]
| table _time, created_account, Subject_Account_Name
```

**Expected Output**
A table showing the account name, the time it was created, and the admin account that created it, joined against any subsequent addition of that same account to Domain Admins.

**False Positives**
- Legitimate new hires into an IT admin role, where account creation and Domain Admins addition is an expected, approved part of onboarding.
- Bulk provisioning scripts run by IT that create and configure several admin accounts at once.

**Recommended Response**
1. Confirm whether a change ticket or manager approval exists for this account being added to Domain Admins.
2. If unapproved, immediately remove the account from Domain Admins.
3. Disable the account pending investigation if no legitimate justification is found.
4. Review who created the account (Subject_Account_Name) and confirm they had the authority to do so.
