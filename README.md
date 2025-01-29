# Omnissa
Scripts related to Omnissa

## Horizon-Prefs.ps1

Horizon-Prefs deploys a Base64 encoded verions of `prefs.txt` to all users, a single user, or both.

Parameters:
* `-prefs_b64`
  * Base64 of the Horizon prefs file
  * Default: Connection server horizon.company.com
* `-prefs_location`
   * Path for the prefs file.
   * Default: \AppData\Roaming\Omnissa\Omnissa Horizon Client

#### `Put-Base64` function
* Outputs a Base64 string to a file.

#### `Set-Horizon-prefs-AllUsers` function
* Enumerate all users found in `C:\Users` ignoring Administrator, Public, and Default.
* Checks if the folders for the prefs file exists if not it creates them.
* Uses the `Put-Base64` function to output the Base64 encoded `prefs.txt` file.

#### `Set-Horizon-prefs-SingleUser` function
* Checks if the folders for the prefs file exists if not it creates them.
* Uses the `Put-Base64` function to output the Base64 encoded `prefs.txt` file.

### Things to note
* If a user's profile already has an existing `prefs.txt` file it will be replaced.

[More detailed documentation](https://thedxt.ca/2025/01/horizon-client-prefs-txt/)
