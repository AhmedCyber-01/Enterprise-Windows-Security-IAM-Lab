# 05 - User Lifecycle (Provisioning, Role Change, Termination)

## Why This Matters

A lot of security incidents I've read about (during TryHackMe rooms and SOC reading) don't come from some sophisticated exploit - they come from accounts that should have been disabled and weren't, or permissions that should have been removed during a role change and were left in place. So I wanted to actually simulate the full lifecycle of a user account, not just create one and leave it.

## Stage 1: New Hire / Provisioning

Simulated process:

1. "Manager approval" - in a real company this would be a ticket or form; in my lab I just documented this as a step rather than building a ticketing system.
2. Create the AD user account in the correct department OU.
3. Set a temporary password with "User must change password at next logon" enabled.
4. Add the user to the correct department security group (e.g., `Finance_Read`).
5. Log in as the new user on CLIENT01 to verify the account works and has the expected folder access.

I automated steps 2-4 with `PowerShell/ProvisionUser.ps1` after doing it manually a few times to understand what the script actually needed to do.

## Stage 2: Role Change

Example scenario I tested: an HR employee moves into a Finance role.

1. Remove the user from `HR_Read` / `HR_Modify`.
2. Add the user to `Finance_Read` (or `Finance_Modify`, depending on the new role).
3. Move the user object to the Finance OU in ADUC.
4. Verify old HR folder access is gone and new Finance folder access works.

I tested this with `priya.sharma`, moving her from HR_Read into Finance_Read, and confirmed through the folder access tests that HR access was revoked and Finance access was granted.

## Stage 3: Termination / Offboarding

1. Disable the account (not delete immediately - this preserves the account for auditing and any legal/HR retention requirements).
2. Remove the user from all security groups.
3. Move the account to a dedicated "Disabled Users" OU, separate from the department OUs.
4. After a lab-simulated "retention period," the account can be deleted.

I automated the disable + group removal + OU move with `PowerShell/DisableUser.ps1`.

## Mistake I Made

The first time I tested offboarding, I disabled the account but forgot to remove it from its security groups. The account couldn't log in (since it was disabled), but it was technically still a member of `Finance_Modify`. This wouldn't cause an immediate problem, but it's bad practice - if the account were ever re-enabled by mistake (which is one of the incident scenarios in `10-IncidentResponse.md`), it would come back with full access instead of no access. After that, I made sure my offboarding script always removes group memberships before moving the account, not after.

## What I Learned

- Disabling an account isn't the same as fully de-provisioning it. Group memberships, home directory access, and any application-level permissions need to be cleaned up too, or they just sit there as dormant risk.
- Doing this manually first, then scripting it, meant I actually understood every step the script needed to perform instead of writing a script I didn't fully understand.
