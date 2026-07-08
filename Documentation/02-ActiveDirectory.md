# 02 - Active Directory Setup

## Installing Active Directory

I installed the **Active Directory Domain Services (AD DS)** role on **DC01**, promoted it to a Domain Controller, and created a new forest named `corp.local`. After the server restarted, I verified the domain by logging in with the domain administrator account.

---

## Organizational Units (OUs)

To keep users organized, I created separate OUs for each department.

```text
corp.local
├── HR
├── Finance
├── IT
├── Sales
└── Disabled Users
```

The **Disabled Users** OU is used to move accounts that are no longer active.

---

## Users and Groups

I created test users for each department using the `firstname.lastname` naming format.

Example:

| Username | Department |
|----------|------------|
| priya.sharma | HR |
| arjun.mehta | Finance |
| rohit.verma | IT |
| sneha.rao | Sales |

I created the first few users manually through **ADUC**, then used a PowerShell script to create the remaining users.

I also created security groups such as:

- HR_Read
- HR_Modify
- Finance_Read
- Finance_Modify
- Sales_Read
- Sales_Modify
- IT_Admin

Department users were added to the appropriate groups, and the **IT_Admin** group was given local administrator access on the client machine.

---

## Password Policies

Using Group Policy, I configured:

- Minimum password length: **12 characters**
- Password complexity enabled
- Account lockout after **5 failed attempts**
- Lockout duration: **15 minutes**

I also created a Fine-Grained Password Policy for the **IT_Admin** group with a **16-character minimum password**.

---

## What I Learned

This part of the project helped me understand how Active Directory is organized using OUs, users, and security groups. I also learned how Group Policy and Fine-Grained Password Policies can be used to manage different security requirements across the domain.
