# 04 - Least Privilege

## Testing Access

After creating users, security groups, and shared folders, I tested the permissions by logging in as different users to verify that access was working as expected.

| Test | Result |
|------|--------|
| HR user accessing Finance share | Access Denied |
| Finance user modifying HR share | Access Denied |
| Sales user accessing IT share | Access Denied |
| IT_Admin accessing all shares | Full Access |
| HR_Read user deleting a file | Access Denied |

---

## Issue I Faced

During testing, I noticed that a Sales user could see the IT shared folder. The issue was caused by the default **Authenticated Users** permission. After removing it and allowing access only through the required security groups, the folder was no longer visible.

---

## What I Learned

This exercise helped me understand the importance of the **Least Privilege** principle. Users should only have the permissions they need to perform their tasks. I also learned that testing access with different user accounts is the best way to verify that permissions are configured correctly.
