# 01 - Environment Setup

## Why I Built This

Before this project, I understood Active Directory as a concept but had never actually built a domain from scratch. I wanted a lab where I could break things safely and see exactly what happens in the logs, so I set up a small AD environment on my own laptop.

## Hardware / Hypervisor

I used VirtualBox because it's free and I already had it installed from earlier TryHackMe work. Everything runs on an internal (host-only) network so none of this is exposed to the internet.

| VM | Role | OS | RAM | vCPU |
|---|---|---|---|---|
| DC01 | Domain Controller | Windows Server 2022 (Evaluation) | 4 GB | 2 |
| CLIENT01 | Domain-joined workstation | Windows 10 (Evaluation) | 4 GB | 2 |
| SPLUNK01 | SIEM (or installed directly on DC01 for lab simplicity) | Windows Server 2022 / Splunk Enterprise | 4 GB | 2 |

Note: In my build I actually installed Splunk Enterprise on the same server as the DC to save resources, since my laptop only has 16 GB of RAM. In a real environment the SIEM would obviously be a separate box - I'm noting this here so it's clear this is a resource shortcut, not something I'd do in production.

## Network Configuration

- Network type: VirtualBox Internal Network (`intnet`)
- DC01 static IP: `192.168.10.10`
- CLIENT01: DHCP or static, pointed at DC01 for DNS
- Domain: `corp.local`

## Steps I Followed

1. Installed Windows Server 2022 on DC01, set a static IP, renamed the machine to `DC01`.
2. Installed the AD DS (Active Directory Domain Services) role.
3. Promoted the server to a domain controller and created the new forest `corp.local`.
4. Installed Windows 10 on CLIENT01, set DNS to point to `192.168.10.10`.
5. Joined CLIENT01 to the `corp.local` domain.
6. Verified the join by logging into CLIENT01 with a domain account.

Detailed screenshots of each step are in `Screenshots/AD/`.

## Problem I Ran Into

When I first tried joining CLIENT01 to the domain, it failed with a DNS-related error. I had left CLIENT01's DNS server pointed at my router instead of the domain controller. Once I set the DNS setting on CLIENT01's network adapter to `192.168.10.10`, the domain join worked immediately.

## What I Learned

- DNS is basically the backbone of Active Directory - if DNS is wrong, nothing else works, and the error messages don't always make that obvious.
- Doing this manually (rather than following a video tutorial exactly) forced me to actually understand each step instead of copy-pasting.
