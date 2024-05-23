# Import-Module Active Directory
Import-Module ActiveDirectory

# Define the path to the CSV file
$csvFilePath = "C:\Users.csv"

# Import the CSV file
$users = Import-Csv -Path $csvFilePath -Delimiter ';'

# Loop through each user in the CSV
foreach ($user in $users) {
    # Construct the Distinguished Name (DN) for the user
    $dn = "CN=$($user.GivenName) $($user.Surname),$($user.path)"
    
    # Users properties for my csv model
    $userAdd = @{
        SamAccountName    = $user.SamAccountName
        UserPrincipalName = $user.UserPrincipalName
        Path              = $user.path
        GivenName         = $user.GivenName
        Surname           = $user.Surname
        Name              = $user.Name
        DisplayName       = $user.DisplayName
        Initials          = $user.Initials
        AccountPassword   = (ConvertTo-SecureString $user.password -AsPlainText -Force)
        Enabled           = $true
    }

    # Create the new user
    try {
        New-ADUser @userAdd -PassThru | Set-ADUser -ChangePasswordAtLogon $true
        Write-Host "Successfully created user: $($user.SamAccountName)"
    } catch {
        Write-Host "Failed to create user: $($user.SamAccountName). Error: $_"
    }
}
