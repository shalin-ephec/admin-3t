# Author : Samuel Halin
# Version : 1.0
#
# Description : This script automatically create users based on the information present in the provided csv file
#
# Prerequisite : The following script should 
#                   - Be run on a domain joined windows machine
#                   - Be run as a user with user creation privilegies over the domain
#
# Input : The script must be called with the path tho a CSV document containing the following collumn 
#           - userName  :   The AD username 
#           - password  :   The passowrd for the user
#           - firstName :   The first name of the person linked to the user
#           - lastName  :   The last name of the person linked to the user
#           - ou        :   The Organisational Unit in which the user should be created

# Import Active Directory module for running AD cmdlets
Import-Module activedirectory

#Store the data from your file in the $users variable
$users = Import-csv $args[0]

#Loop through each row containing user details in the CSV file
foreach ($user in $users) {
    #Read user data from each field in each row and assign the data to a variable as below
    $uname = $user.userName
    $password = $user.password
    $fname = $user.firstName
    $lname = $user.lastName
    $OU = $user.ou

    #Check to see if the user already exists in the AD
    if (Get-ADUser -F { SamAccountName -eq $uname }) {
        Write-Warning "A user account with uname $uname already exists in Active Directory."
    }
    #Else, create the user
    else {
        New-ADUser `
            -SamAccountName $uname `
            -UserPrincipalName "$uname@<domain>" `
            -Name "$fname $lname" `
            -GivenName $fname `
            -Surname $lname `
            -Enabled $True `
            -DisplayName "$lname, $fname" `
            -Path $OU `
            -AccountPassword (convertto-securestring $password -AsPlainText -Force) `
            -ChangePasswordAtLogon $false `
            -PasswordNeverExpire $True
    }
}