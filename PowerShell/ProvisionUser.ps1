<#
.SYNOPSIS
    Provisions a single new hire: creates the account, sets it in the right OU,
    and adds them to the correct department group.

.NOTES
    This is the script version of the manual steps in Documentation/05-UserProvisioning.md.
    I wrote the manual steps first, then turned them into this script once I was doing
    the same thing over and over for each new test user.

.EXAMPLE
    .\ProvisionUser.ps1 -FirstName "Arjun" -LastName "Mehta" -Department "Finance" -AccessLevel "Read"
#>

param(
    [Parameter(Mandatory=$true)][string]$FirstName,
    [Parameter(Mandatory=$true)][string]$LastName,
    [Parameter(Mandatory=$true)][ValidateSet("HR","Finance","IT","Sales")][string]$Department,
    [Parameter(Mandatory=$true)][ValidateSet("Read","Modify")][string]$AccessLevel
)

Import-Module ActiveDirectory

$domain   = "corp.local"
$username = ("$FirstName.$LastName").ToLower()
$upn      = "$username@$domain"
$ouPath   = "OU=$Department,DC=corp,DC=local"
$tempPassword = "ChangeMe123!"

# IT gets IT_Admin regardless of the AccessLevel param, since there's no
# read/modify split for the IT department in this lab.
if ($Department -eq "IT") {
    $groupName = "IT_Admin"
} else {
    $groupName = "$Department`_$AccessLevel"
}

if (Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue) {
    Write-Host "User $username already exists. Aborting to avoid duplicate accounts."
    exit
}

New-ADUser `
    -Name "$FirstName $LastName" `
    -GivenName $FirstName `
    -Surname $LastName `
    -SamAccountName $username `
    -UserPrincipalName $upn `
    -Path $ouPath `
    -AccountPassword (ConvertTo-SecureString $tempPassword -AsPlainText -Force) `
    -Enabled $true `
    -ChangePasswordAtLogon $true `
    -Department $Department

Add-ADGroupMember -Identity $groupName -Members $username

Write-Host "Provisioned $username in $ouPath, added to $groupName."
Write-Host "Temporary password set - user must change at next logon."
