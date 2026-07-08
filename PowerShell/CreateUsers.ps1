<#
.SYNOPSIS
    Bulk-creates AD users from a CSV file and places them in the correct department OU.

.NOTES
    I wrote this after creating the first few users manually in ADUC, once I understood
    what fields actually mattered (OU path, department, temp password). Doing it manually
    first helped me write a script that actually matches what the domain needs instead of
    guessing at parameters.

    Expects a CSV file (Users.csv) with columns:
    FirstName,LastName,Department,Username

    Example row:
    Priya,Sharma,HR,priya.sharma

    Run this on the domain controller (DC01) with the ActiveDirectory module available.
#>

Import-Module ActiveDirectory

$csvPath = "C:\Lab\Users.csv"
$domain  = "corp.local"
$baseOU  = "DC=corp,DC=local"
$tempPassword = "ChangeMe123!"  # lab only - real environments should generate unique temp passwords

$users = Import-Csv -Path $csvPath

foreach ($user in $users) {

    $ouPath = "OU=$($user.Department),$baseOU"
    $upn    = "$($user.Username)@$domain"
    $displayName = "$($user.FirstName) $($user.LastName)"

    # Skip if the account already exists - I added this after accidentally
    # trying to re-run the script and getting duplicate account errors.
    if (Get-ADUser -Filter "SamAccountName -eq '$($user.Username)'" -ErrorAction SilentlyContinue) {
        Write-Host "Skipping $($user.Username) - already exists."
        continue
    }

    New-ADUser `
        -Name $displayName `
        -GivenName $user.FirstName `
        -Surname $user.LastName `
        -SamAccountName $user.Username `
        -UserPrincipalName $upn `
        -Path $ouPath `
        -AccountPassword (ConvertTo-SecureString $tempPassword -AsPlainText -Force) `
        -Enabled $true `
        -ChangePasswordAtLogon $true `
        -Department $user.Department

    Write-Host "Created user: $($user.Username) in OU: $ouPath"
}

Write-Host "Bulk user creation complete."
