# 03 - Role-Based Access Control (RBAC)

## Why Groups Instead of Individual Users

The first time I set up folder permissions in this lab, I assigned NTFS permissions directly to individual user accounts. It worked fine with 3 users. It stopped making sense the moment I added a 4th and 5th person to the HR department, because I had to go back and manually update permissions on the folder for every new hire.

Switching to security groups fixed this. Now the pattern is:

```
User  --->  Security Group  --->  Folder Permission
```

Instead of granting "Priya has read access to the HR folder," I grant "the HR_Read group has read access to the HR folder," and then just add or remove Priya from that group. Onboarding and offboarding become a group membership change instead of a permissions change.

## Groups I Created

| Group Name | Purpose |
|---|---|
| HR_Read | Read-only access to the HR shared folder |
| HR_Modify | Read/write access to the HR shared folder |
| Finance_Read | Read-only access to the Finance shared folder |
| Finance_Modify | Read/write access to the Finance shared folder |
| Sales_Read | Read-only access to the Sales shared folder |
| Sales_Modify | Read/write access to the Sales shared folder |
| IT_Admin | Local admin rights on CLIENT01, full control over all department shares |
| VPN_Users | Placeholder group for accounts allowed to use the lab's simulated VPN policy |
| Remote_Users | Placeholder group for accounts allowed remote desktop access to CLIENT01 |

I split each department into `_Read` and `_Modify` rather than one combined group, because in a real company not everyone in a department needs to edit files - some people (like a new hire still in training) might only need to view them.

## Applying Permissions

On the shared folder itself (e.g., `\\DC01\HR-Share`):

1. Right-click the folder > Properties > Security tab
2. Removed the default "Everyone" / "Authenticated Users" broad access where it existed
3. Added `HR_Read` group with Read & Execute permissions
4. Added `HR_Modify` group with Modify permissions
5. Repeated for Finance and Sales shares

For IT_Admin, I added the group to the local Administrators group on CLIENT01 through Group Policy Restricted Groups, rather than manually adding it on the machine itself - this way if I add more IT machines later, the same policy applies automatically.

## Nested Groups

`IT_Admin` is nested inside the local Administrators group on CLIENT01. This is a small example of nested groups, but it demonstrates the same idea used at larger scale in real companies - a group of groups, so a single policy change cascades down to everyone who needs it.

## What I Learned

- RBAC isn't really a complicated idea once you've done it once - it's just "permission the group, not the person." The value becomes obvious the first time you have to offboard someone and realize you only need to remove one group membership instead of hunting through every folder's permission list.
- I initially made the mistake of naming groups things like "HR Group 1" before I understood the convention - renaming them to `HR_Read` / `HR_Modify` made the permission structure self-documenting, which matters a lot when someone else (or future me) has to audit this later.
