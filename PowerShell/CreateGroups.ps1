<#
.SYNOPSIS
    Creates the department-based RBAC security groups used throughout this lab.

.NOTES
    These are the groups referenced in Documentation/03-RBAC.md. I hardcoded them here
    rather than reading from a CSV since there are only a handful and they don't change
    often - if I were doing this for a bigger environment I'd read the group list from
    a config file instead.
#>

Import-Module ActiveDirectory

$groupOU = "OU=Groups,DC=corp,DC=local"

$groups = @(
    "HR_Read",
    "HR_Modify",
    "Finance_Read",
    "Finance_Modify",
    "Sales_Read",
    "Sales_Modify",
    "IT_Admin",
    "VPN_Users",
    "Remote_Users"
)

foreach ($group in $groups) {

    if (Get-ADGroup -Filter "Name -eq '$group'" -ErrorAction SilentlyContinue) {
        Write-Host "Skipping $group - already exists."
        continue
    }

    New-ADGroup `
        -Name $group `
        -SamAccountName $group `
        -GroupCategory Security `
        -GroupScope Global `
        -Path $groupOU `
        -Description "Lab RBAC group - see Documentation/03-RBAC.md"

    Write-Host "Created group: $group"
}

Write-Host "Group creation complete."
