# Detection: User Added to Domain Admins

**Purpose**
Alert immediately whenever any account is added to the Domain Admins group. This is one of the highest-impact changes possible in an Active Directory environment and should be rare enough that every occurrence is worth reviewing.

**Threat**
Whether from a misconfiguration (see Incident Scenario 1 in `Documentation/10-IncidentResponse.md`) or an attacker escalating privileges after compromising a lower-level account, an unexpected addition to Domain Admins is one of the clearest signs of a serious problem in the environment.

**MITRE ATT&CK Mapping**
- T1098 - Account Manipulation

**Event IDs**
- 4728 - A member was added to a security-enabled global group

**SPL Query**
```
index=main sourcetype=WinEventLog:Security EventCode=4728 Group_Name="Domain Admins"
| table _time, Account_Name, Subject_Account_Name, Caller_Computer_Name
```

**Expected Output**
Every instance of an account being added to Domain Admins, along with who performed the action and from which computer.

**False Positives**
- Legitimate, approved additions of a new IT admin to the group, ideally tied to a change ticket.
- Scheduled/automated provisioning scripts that manage admin group membership as part of an approved process.

**Recommended Response**
1. Immediately verify whether there is an approved change request for this addition.
2. If unapproved, remove the account from Domain Admins right away.
3. Investigate the account that performed the change (Subject_Account_Name) - confirm it wasn't itself compromised.
4. Document the incident regardless of outcome, since even a "helpdesk mistake" (like Scenario 1) represents a process gap worth fixing.
