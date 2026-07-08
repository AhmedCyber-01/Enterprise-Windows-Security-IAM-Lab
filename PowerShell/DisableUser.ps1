<#
.SYNOPSIS
    Offboards a user: removes all group memberships, disables the account,
    and moves it to the Disabled Users OU.

.NOTES
    This is the corrected version of my offboarding script. My first version only
    disabled the account and moved it, without removing group memberships - see
    the "Mistake I Made" section in Documentation/05-UserProvisioning.md and
    Incident Scenario 4 in Documentation/10-IncidentResponse.md for why I changed
    the order of operations here.

    Order matters: remove groups BEFORE moving/disabling, so there's no window
    where a disabled-but-not-yet-cleaned-up account could be re-enabled with its
    old access still intact.

.EXAMPLE
    .\DisableUser.ps1 -Username "priya.sharma"
#>

param(
    [Parameter(Mandatory=$true)][string]$Username
)

Import-Module ActiveDirectory

$disabledOU = "OU=Disabled Users,DC=corp,DC=local"

$user = Get-ADUser -Identity $Username -Properties MemberOf -ErrorAction SilentlyContinue

if (-not $user) {
    Write-Host "User $Username not found."
    exit
}

# Step 1: Remove all group memberships first.
$groups = $user.MemberOf
foreach ($group in $groups) {
    Remove-ADGroupMember -Identity $group -Members $Username -Confirm:$false
    Write-Host "Removed $Username from $group"
}

# Step 2: Disable the account.
Disable-ADAccount -Identity $Username
Write-Host "Disabled account: $Username"

# Step 3: Move to the Disabled Users OU.
Move-ADObject -Identity $user.DistinguishedName -TargetPath $disabledOU
Write-Host "Moved $Username to $disabledOU"

Write-Host "Offboarding complete for $Username."
Write-Host "Account retained for audit/retention purposes - delete manually after the retention period."
