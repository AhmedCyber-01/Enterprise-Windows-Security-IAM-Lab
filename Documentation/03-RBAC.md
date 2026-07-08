# 03 - Role-Based Access Control (RBAC)

## Why I Used Security Groups

Instead of assigning permissions directly to individual users, I used **security groups** to manage access. This makes it easier to add, remove, or change user access without modifying folder permissions every time.

```text
User → Security Group → Folder Permission
```

---

## Security Groups

| Group | Purpose |
|------|---------|
| HR_Read | Read access to HR folder |
| HR_Modify | Read/Write access to HR folder |
| Finance_Read | Read access to Finance folder |
| Finance_Modify | Read/Write access to Finance folder |
| Sales_Read | Read access to Sales folder |
| Sales_Modify | Read/Write access to Sales folder |
| IT_Admin | Local administrator access on CLIENT01 |
| VPN_Users | Simulated VPN access |
| Remote_Users | Remote Desktop access |

---

## Folder Permissions

For each department share, I:

- Removed unnecessary default permissions.
- Assigned **Read** access to the `_Read` group.
- Assigned **Modify** access to the `_Modify` group.

The **IT_Admin** group was added to the local **Administrators** group on `CLIENT01`.

---

## What I Learned

This project helped me understand how **Role-Based Access Control (RBAC)** simplifies permission management. Instead of assigning permissions to every user, access can be managed by adding or removing users from security groups. I also learned the importance of using clear group names like `HR_Read` and `HR_Modify`, which makes administration much easier.
