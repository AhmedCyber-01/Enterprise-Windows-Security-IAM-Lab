# Enterprise Windows Security Monitoring & Identity Access Management Lab

## About This Project

I built this lab to understand how Identity and Access Management actually works inside a Windows enterprise environment, not just the theory behind it. Most of what I knew about Active Directory before this came from bootcamp slides and YouTube videos, so I wanted a hands-on project where I could create the users myself, break things, fix them, and see the logs generated in Splunk.

This is a **home lab**, built on VirtualBox on my own laptop. It is not a production environment and nothing here was implemented at a real company. But the concepts, the misconfigurations, and the fixes are all real - I ran into most of these problems myself while building it.

The goal was to put together something that shows I can:

- Stand up a small Active Directory domain from scratch
- Design a department structure using OUs and security groups
- Apply least privilege instead of just giving everyone access to everything
- Handle the full user lifecycle (onboarding, role change, offboarding)
- Configure Group Policy for password and audit settings
- Forward Windows Security logs to Splunk and write detection queries
- Investigate a few incident scenarios using the logs I generated

## Architecture

```
                        corp.local
                             |
                    Domain Controller (DC01)
                    Windows Server 2022
                             |
              -------------------------------
              |               |              |
           HR OU          Finance OU      IT OU / Sales OU
              |               |              |
         HR Users       Finance Users    IT / Sales Users
              |               |              |
        HR Security      Finance Security  IT_Admin Group
          Groups            Groups
              |               |              |
         Shared HR       Shared Finance   Full Admin Access
          Folder           Folder

                    Windows 10 Client (CLIENT01)
                    joined to corp.local

                    Splunk Enterprise (forwarder + search head)
                    receiving Windows Security event logs
```

A full diagram (drawio source + exported PNG) is in the `Architecture/` folder. I built it after finishing the lab, once I actually understood how everything connected - trying to diagram it first would have just been guessing.

## Project Structure

```
Enterprise-Windows-Security-IAM-Lab/
├── README.md
├── Architecture/
│   ├── Architecture.png
│   └── Network-Diagram.drawio
├── Documentation/
│   ├── 01-Environment.md
│   ├── 02-ActiveDirectory.md
│   ├── 03-RBAC.md
│   ├── 04-LeastPrivilege.md
│   ├── 05-UserProvisioning.md
│   ├── 06-GroupPolicy.md
│   ├── 07-Auditing.md
│   ├── 08-SplunkMonitoring.md
│   ├── 09-DetectionEngineering.md
│   └── 10-IncidentResponse.md
├── PowerShell/
│   ├── CreateUsers.ps1
│   ├── CreateGroups.ps1
│   ├── ProvisionUser.ps1
│   └── DisableUser.ps1
├── Screenshots/
│   ├── AD/
│   ├── Groups/
│   ├── Users/
│   ├── GPO/
│   ├── Splunk/
│   └── Investigations/
├── DetectionRules/
│   ├── PrivilegedAccountCreated.md
│   ├── PasswordSpray.md
│   ├── AccountLockout.md
│   └── UserAddedToAdmins.md
└── LessonsLearned.md
```

## Environment

| Component | Details |
|---|---|
| Domain Controller | Windows Server 2022, hostname `DC01` |
| Client | Windows 10, hostname `CLIENT01` |
| Domain | `corp.local` |
| Hypervisor | VirtualBox |
| SIEM | Splunk Enterprise (free trial license) |
| Departments simulated | HR, Finance, IT, Sales |

More detail on how this was set up is in `Documentation/01-Environment.md`.

## Skills Demonstrated

- Active Directory installation and domain setup
- OU design and security group structure
- Role-Based Access Control (RBAC) using nested groups instead of direct permission assignment
- Least privilege / Zero Trust style access restrictions
- User lifecycle management (provisioning, role change, termination)
- Group Policy configuration (password policy, account lockout, audit policy)
- Windows Security event log analysis (Event IDs for account/group changes)
- Splunk log forwarding and SPL query writing
- Detection engineering with MITRE ATT&CK mapping
- Incident investigation and timeline reconstruction
- PowerShell automation for AD administration

## Tools Used

- VirtualBox
- Windows Server 2022 (Evaluation)
- Windows 10 (Evaluation)
- Active Directory Domain Services (AD DS)
- Group Policy Management Console (GPMC)
- Splunk Enterprise
- Splunk Universal Forwarder
- PowerShell 5.1
- draw.io (for diagrams)

## Screenshots

Screenshots from my own build are organized under `Screenshots/`, split by topic (AD setup, group creation, user provisioning, GPO settings, Splunk searches, and the investigation walkthroughs). I've kept the folder structure here so anyone reproducing this lab knows exactly where each screenshot in the documentation is referenced from.

## MITRE ATT&CK Mapping

Each detection rule in `DetectionRules/` is mapped to a specific ATT&CK technique. A quick summary:

| Detection | Technique | ID |
|---|---|---|
| User added to Domain Admins | Account Manipulation | T1098 |
| Password spray | Brute Force: Password Spraying | T1110.003 |
| Repeated account lockouts | Brute Force | T1110 |
| Privileged account created unexpectedly | Create Account: Domain Account | T1136.002 |

## What I Learned

This project taught me more about how enterprise access control actually works than any course did, mainly because I had to fix my own mistakes. A few examples:

- I initially assigned NTFS permissions directly to individual users. It worked, but I quickly realized that managing 15+ users this way was a nightmare, and any new hire meant repeating the same manual steps. Switching to security groups made this manageable.
- I forgot to enable the audit policy before testing user creation and deletion, so my first few "detections" had nothing to detect. After turning on the right audit subcategories, the expected Event IDs started showing up in the Security log.
- Getting the Splunk Universal Forwarder to actually send logs to my indexer took a few tries - I had a firewall rule blocking port 9997 that I didn't notice until I checked the forwarder logs.


