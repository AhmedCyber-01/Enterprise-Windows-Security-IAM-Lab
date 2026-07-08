# 02 - Active Directory Setup

## Installing AD DS

On DC01, I installed the Active Directory Domain Services role through Server Manager:

1. Server Manager > Add Roles and Features
2. Selected "Active Directory Domain Services"
3. Accepted the default features and completed the install
4. Clicked "Promote this server to a domain controller"
5. Chose "Add a new forest" and typed the root domain name: `corp.local`
6. Set the Directory Services Restore Mode (DSRM) password
7. Let the wizard run through DNS and NetBIOS name checks, then rebooted

After the reboot, I logged in as `CORP\Administrator` to confirm the domain was live.

## Creating Organizational Units (OUs)

I used Active Directory Users and Computers (ADUC) to build the OU structure. I organized it by department since that matched how I wanted to apply Group Policy and permissions later:

```
corp.local
├── HR
├── Finance
├── IT
├── Sales
└── Disabled Users   (for offboarded accounts)
```

I created a separate "Disabled Users" OU early on because I knew from the lifecycle documentation (`05-UserProvisioning.md`) that offboarded accounts should be moved somewhere separate rather than left in their original OU.

## Creating Users

I created a small set of test users per department (about 3-4 each) so I'd have enough accounts to test group membership and permissions without it getting unmanageable. Naming convention I used: `firstname.lastname`.

Example users:

| Username | Department | OU |
|---|---|---|
| priya.sharma | HR | HR |
| arjun.mehta | Finance | Finance |
| rohit.verma | IT | IT |
| sneha.rao | Sales | Sales |

I created these manually the first time through ADUC to understand the process, then wrote `PowerShell/CreateUsers.ps1` to automate creating the rest in bulk.

## Creating Security Groups

Groups I created (details on the reasoning are in `03-RBAC.md`):

- HR_Read
- HR_Modify
- Finance_Read
- Finance_Modify
- Sales_Read
- Sales_Modify
- IT_Admin
- VPN_Users
- Remote_Users

## Group Membership and Nesting

I added department users to their respective `_Read` or `_Modify` groups depending on their role. For IT staff, I nested `IT_Admin` inside the local Administrators group on CLIENT01 so IT users get local admin rights on the workstation without directly assigning permissions to each individual account.

## Password Policy and Account Lockout

Configured through Group Policy (details in `06-GroupPolicy.md`), but the core settings I set on the Default Domain Policy:

- Minimum password length: 12 characters
- Password complexity: enabled
- Account lockout threshold: 5 invalid attempts
- Account lockout duration: 15 minutes
- Reset lockout counter after: 15 minutes

## Fine-Grained Password Policy

I also created a Fine-Grained Password Policy (PSO) targeting the `IT_Admin` group specifically, requiring a longer minimum password length (16 characters) since admin accounts are a higher-value target. This was done through Active Directory Administrative Center (ADAC), under "Password Settings Container."

## What I Learned

- Building the OU structure before creating users made everything else (GPO, permissions) much simpler. I tried the opposite order at first (users first) and ended up having to move a bunch of accounts afterward.
- Fine-Grained Password Policies are more flexible than I expected - I didn't realize you could apply different password rules to different groups within the same domain until I did this.
