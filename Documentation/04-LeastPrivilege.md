# 04 - Least Privilege

## What I Was Trying to Prove

Once the groups and shared folders were set up, I wanted to actually test that access was restricted the way I thought it was, instead of just assuming the permissions worked. So I logged in as different test users and tried to access folders I shouldn't have had access to.

## Tests I Ran

| Test | User | Target | Expected Result | Actual Result |
|---|---|---|---|---|
| HR user accessing Finance share | priya.sharma (HR) | `\\DC01\Finance-Share` | Access denied | Access denied - confirmed |
| Finance user modifying HR share | arjun.mehta (Finance, Finance_Read only) | `\\DC01\HR-Share` | Access denied | Access denied - confirmed |
| Sales user accessing IT share | sneha.rao (Sales) | `\\DC01\IT-Share` | Access denied | Access denied - confirmed |
| IT_Admin accessing all shares | rohit.verma (IT_Admin) | All shares | Full access | Full access - confirmed |
| HR_Read user trying to delete a file | priya.sharma | `\\DC01\HR-Share\test.txt` | Denied (read-only) | Denied - confirmed |

## Why This Matters (Zero Trust)

The idea behind least privilege is simple: an account should only be able to do what it actually needs to do for its job, and nothing more. If an HR account gets compromised (phished, weak password, whatever), the damage is contained to the HR folder - the attacker can't just pivot into Finance data because the account was never granted that access in the first place.

This connects to Zero Trust because Zero Trust assumes you can't fully trust any account or device by default, even ones already inside the network. Restricting access by department and by read/modify role is a small, practical example of that principle - I'm not trusting "this is an internal employee account" as a reason to grant broad access.

## A Mistake I Made

While testing, I initially found that a Sales user *could* browse into the IT share (though not open any files). This was because I had left "Authenticated Users" with List Folder Contents permission on the share from the default Windows settings, and never removed it. I caught this specifically because I was testing as different users rather than assuming the group permissions alone were doing all the work. After removing "Authenticated Users" from the share's permission list and confirming only the intended groups remained, retesting showed the folder was no longer visible to the Sales account at all.

## What I Learned

- Least privilege isn't just about the groups you create - it's also about the default permissions you forget to remove. The "Authenticated Users" issue above wouldn't have been visible without actually testing as a low-privilege account.
- Testing from the perspective of each role (not just the admin account) is the only way to actually verify least privilege is working. It's easy to configure permissions and assume they're correct without checking.
