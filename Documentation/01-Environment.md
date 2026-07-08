# 01 - Environment Setup

## Why I Built This

I wanted to understand how Active Directory works by building a small Windows domain from scratch instead of only learning the theory. This home lab helped me practice setting up a domain, joining a client machine, and preparing Windows logs for Splunk.

## Lab Environment

| VM | Role | OS |
|----|------|----|
| DC01 | Domain Controller | Windows Server 2022 |
| CLIENT01 | Domain Client | Windows 10 |

## Network

- Domain: `corp.local`
- Network: VirtualBox Internal Network
- DC01 IP: `192.168.10.10`

## Setup Steps

1. Installed Windows Server 2022 and configured `DC01`.
2. Installed Active Directory Domain Services.
3. Created the `corp.local` domain.
4. Installed Windows 10 on `CLIENT01`.
5. Joined `CLIENT01` to the domain.
6. Verified domain login.

## Challenge

While joining the client to the domain, I got a DNS error because the client was using my router as its DNS server. After changing the DNS to the Domain Controller (`192.168.10.10`), the domain join worked successfully.

## What I Learned

This setup helped me understand how Active Directory depends on DNS and gave me hands-on experience creating and managing a Windows domain.
