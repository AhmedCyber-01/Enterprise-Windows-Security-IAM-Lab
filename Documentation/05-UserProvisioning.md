# 05 - User Lifecycle (Provisioning, Role Change, Termination)

## Overview

To understand how user accounts are managed in Active Directory, I simulated the complete user lifecycle—from creating a new user to changing roles and offboarding.

---

## User Provisioning

For a new user, I:

- Created the user account in the correct OU
- Assigned a temporary password
- Enabled **User must change password at next logon**
- Added the user to the appropriate security group
- Verified the user could log in and access the required shared folder

After performing these steps manually, I automated them using a PowerShell script.

---

## Role Change

To simulate an employee changing departments, I:

- Removed the user from the old security group
- Added the user to the new security group
- Moved the account to the new OU
- Verified that old permissions were removed and new permissions were applied

---

## User Offboarding

For offboarding, I:

- Disabled the user account
- Removed the user from all security groups
- Moved the account to the **Disabled Users** OU

I automated these steps using PowerShell to make the process consistent.

---

## What I Learned

This exercise helped me understand that managing user accounts involves more than just creating and deleting accounts. Properly updating group memberships and permissions is an important part of maintaining secure access in an Active Directory environment.
