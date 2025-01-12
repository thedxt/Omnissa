# Horizon-Prefs.ps1
#
# Author: Daniel Keer
# Created: 2024-07-14
# Last Modified: 2025-01-12
# Version 2.0.0
#
# Description:
#   This script automates the placement of the Horizon prefs file for users.
#
# Parameters:
#
#   -$prefs_b64 <string>
#       Base64 of the Horizon prefs file
#       Default: Connection server horizon.company.com
#
#   -prefs_location <string>
#       Path for the prefs file.
#       Default: \AppData\Roaming\Omnissa\Omnissa Horizon Client
#
# Usage:
#   .\Horizon-Prefs.ps1
#
#
# set the defaults
  [CmdletBinding()]
  param (
      [string]$prefs_b64 = "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPFJvb3Q+CiAgPFJlY2VudFNlcnZlciBzZXJ2ZXJOYW1lPSJob3Jpem9uLmNvbXBhbnkuY29tIj48L1JlY2VudFNlcnZlcj4KPC9Sb290Pg==",
      [string]$prefs_location = "\AppData\Roaming\Omnissa\Omnissa Horizon Client"
  )

# Function: Put-Base64
#
# Original Author: Daniel Keer
# Created: 2024-02-13
# Last Modified: 2025-01-07
# Version 2.0.0
# Description:
#   Places a Base64 item into a location.
#
# Parameters:
#   - Dest <string>
#       The full path of the base64 item.
#
#   - Base64 <string>
#       The base64 encoding of the item.


function Put-Base64{
param(
[Parameter (Mandatory = $true)] [String]$Dest,
[Parameter (Mandatory = $true)] [String]$Base64
)

    try {
        Write-Verbose "Placing Base64 item in: $Dest"
        $out = [Convert]::FromBase64String($Base64)
        [IO.File]::WriteAllBytes($Dest, $out)
        Write-Verbose "Base64 item placed"
    } catch {
        Write-Verbose "Error placing the Base64 item: $_"
        Exit 1
    }

}

# Function: Set-Horizon-prefs-AllUsers
#
# Original Author: Daniel Keer
# Created: 2024-07-14
# Last Modified: 2025-01-12
# Version 2.0.0
# Description:
#   Uses the Put-Base64 Function to place the Base64 encoded prefs file for all existing users on the system.
#
# Parameters:
#   - prefs_path <string>
#       pathing of the app data location


function Set-Horizon-prefs-AllUsers{
param(
[Parameter (Mandatory = $true)] [String]$prefs_path
)

write-host "Getting list of users"
# get the users minus Default and Administrator and Public
$list_of_users = Get-ChildItem -Path $Env:SystemDrive\Users | Where-Object {($_.Name -notlike "Public") -and ($_.Name -notlike "Administrator") -and ($_.Name -notlike "Default")}

write-host "-----------------------------"
Write-Host "Starting deployment of the Horizon Prefs for All Users"
write-host "-----------------------------"

# loop for each user found
Foreach ($user in $list_of_users)

{

write-host "-----------------------------"
# check if the folder exists already
if (Test-Path "$($user.FullName)$($prefs_path)")

# if folder is found create the prefs file
{
write-host "Found $($user.FullName)$($prefs_path)"
Write-host "Creating the Horizon prefs for $user"

#call and use the Put-Base64 function
Put-Base64 -Base64 $prefs_b64 -Dest "$($user.FullName)$($prefs_path)\prefs.txt"
Write-host "The Horizon prefs for $user are created"
write-host "-----------------------------"
}
else
# if folder is not found make it then create the prefs file
{
write-Host "-----------------------------"
write-host "Did not Find $($user.FullName)$($prefs_path)"
write-host "Creating $($user.FullName)$($prefs_path)"
New-Item -ItemType Directory "$($user.FullName)$($prefs_path)" | out-null
Write-host "Creating the Horizon prefs for $user"

#call and use the Put-Base64 function
Put-Base64 -Base64 $prefs_b64 -Dest "$($user.FullName)$($prefs_path)\prefs.txt"
Write-host "The Horizon prefs for $user are created"
write-host "-----------------------------"
}
}
write-host "-----------------------------"
Write-Host "Completed deployment of the Horizon Prefs for All Users"
write-host "-----------------------------"
}

# Function: Set-Horizon-prefs-SingleUser
#
# Original Author: Daniel Keer
# Created: 2024-07-14
# Last Modified: 2025-01-12
# Version 2.0.0
# Description:
#   Uses the Put-Base64 Function to place the Base64 encoded prefs file for a single user.
#
# Parameters:
#   - SingleUser <string>
#       name of the user you want to place Base64 encoded prefs file
#
# Parameters:
#   - prefs_path <string>
#       pathing of the app data location
#

function Set-Horizon-prefs-SingleUser{
param(
[Parameter (Mandatory = $true)] [String]$SingleUser,
[Parameter (Mandatory = $true)] [String]$prefs_path
)
write-host "-----------------------------"
Write-Host "Starting deployment of the Horizon Prefs for $SingleUser"
write-host "-----------------------------"

$user_prefs_path = Join-Path -Path "C:\Users\$SingleUser" -ChildPath $prefs_path

# check if the folder exists already
   if (Test-Path "$Env:SystemDrive\Users\$SingleUser$prefs_path")
   # if folder is found create the prefs file
    {
    write-host "-----------------------------"
    write-host "Found $Env:SystemDrive\Users\$SingleUser$prefs_path"
    Write-host "Creating the Horizon prefs for $SingleUser"
    
    #call and use the Put-Base64 function
    Put-Base64 -Base64 $prefs_b64 -Dest "$Env:SystemDrive\Users\$SingleUser$prefs_path\prefs.txt"
    Write-host "The Horizon prefs for $SingleUser are created"
    }else{
    # if folder is not found make it then create the prefs file
    write-host "Did Not Find $Env:SystemDrive\Users\$SingleUser$prefs_path"
    write-host "Creating $Env:SystemDrive\Users\$SingleUser$prefs_path Folder"
    New-Item -ItemType Directory $Env:SystemDrive\Users\$SingleUser$prefs_path | out-null
    Write-host "Creating the Horizon prefs for $SingleUser"
    
    #call and use the Put-Base64 function
    Put-Base64 -Base64 $prefs_b64 -Dest "$Env:SystemDrive\Users\$SingleUser$prefs_path\prefs.txt"
    Write-host "The Horizon prefs for $SingleUser are created"
}
write-host "-----------------------------"
Write-Host "Completed deployment of the Horizon Prefs for $SingleUser"
write-host "-----------------------------"
}

# run it

Set-Horizon-prefs-AllUsers -prefs_path $prefs_location
Set-Horizon-prefs-SingleUser -SingleUser "Default" -prefs_path $prefs_location
