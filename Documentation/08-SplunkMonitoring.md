# 08 - Splunk Monitoring Setup

## Why Splunk

I've used Splunk before during SOC analyst training on LetsDefend and in my bootcamp, so I wanted to actually set up log forwarding myself instead of just querying a pre-built dataset. This felt like the missing piece between "AD generates security events" and "a SOC analyst can actually see and search them."

## Setup Steps

1. Installed Splunk Enterprise (I put it on DC01 itself in my lab to save resources - in a real environment this would be a separate server).
2. Installed the Splunk Universal Forwarder concept is normally used on the source machine, but since Splunk was local in my case, I configured a local input directly instead:
   - Splunk Web > Settings > Data Inputs > Local event log collection
   - Enabled the "Security" log for collection
3. Confirmed the index (`main`) was receiving data by running a simple search: `index=main sourcetype=WinEventLog:Security`
4. Verified events like 4624, 4625, 4720, and 4728 were showing up with the correct fields parsed (EventCode, Account_Name, etc.)

## Problem I Ran Into

When I first set this up with a separate forwarder VM in mind, I ran into a connection issue on port 9997 (the default forwarder-to-indexer port) - Windows Firewall on the receiving server was blocking it. I confirmed this by checking the forwarder's `splunkd.log`, which showed repeated connection refused errors. After adding an inbound firewall rule for TCP 9997, the forwarder connected and started sending data. I ended up simplifying my final lab setup to local collection to reduce moving parts, but I kept notes on this forwarder issue since it's a very common real-world problem.

## SPL Queries I Use

**Failed logins**
```
index=main sourcetype=WinEventLog:Security EventCode=4625
| stats count by Account_Name, src_ip
| sort -count
```

**Account lockouts**
```
index=main sourcetype=WinEventLog:Security EventCode=4740
| table _time, Account_Name, Caller_Computer_Name
```

**New user creation**
```
index=main sourcetype=WinEventLog:Security EventCode=4720
| table _time, Account_Name, Subject_Account_Name
```

**Disabled accounts**
```
index=main sourcetype=WinEventLog:Security EventCode=4725
| table _time, Account_Name, Subject_Account_Name
```

**Privilege escalation (added to a privileged group)**
```
index=main sourcetype=WinEventLog:Security (EventCode=4728 OR EventCode=4732 OR EventCode=4756)
| table _time, Group_Name, Account_Name, Subject_Account_Name
```

**User added to Domain Admins specifically**
```
index=main sourcetype=WinEventLog:Security EventCode=4728 Group_Name="Domain Admins"
| table _time, Account_Name, Subject_Account_Name
```

**Group membership changes (general)**
```
index=main sourcetype=WinEventLog:Security EventCode IN (4728,4729,4732,4733,4756,4757)
| table _time, EventCode, Group_Name, Account_Name
```

## What I Learned

- Getting logs into Splunk is only half the work - the field names Windows uses (`Account_Name`, `Subject_Account_Name`, `Group_Name`) aren't always intuitive, and I had to run a few broad searches and look at the raw event to figure out which field actually held the value I wanted.
- Testing each query against an event I had deliberately generated (rather than trusting the query looked "correct") caught a couple of mistakes early, like initially filtering on the wrong field and getting zero results.
