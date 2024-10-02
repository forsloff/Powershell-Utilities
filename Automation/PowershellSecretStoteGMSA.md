


## Configuration

To configure a Secret Value for a Group Managed Service Account, we will run powershell as the GMSA using PSExec. The `~` will bypass warnings about not using a password.

```Batch
./psexec -i -u forslof\gMSA-Example$ -p ~ powershell.exe

```
Install the SecretStore and SecretManagement powershell modules.
```Powershell
Install-Module -Name Microsoft.PowerShell.SecretStore -Repository PSGallery -Force
Install-Module -Name Microsoft.PowerShell.SecretManagement -Repository PSGallery -Force
Import-Module Microsoft.PowerShell.SecretStore
Import-Module Microsoft.PowerShell.SecretManagemen
```

Configure the SecretVault and SecretVault, there are two ways to configure the secret Vault, with and without a password.

### Password

```Powershell
$credential = Get-Credential -UserName 'SecureStore'
$credential.Password |  Export-Clixml -Path 'c:\Automation\SSVault.xml'

Register-SecretVault -Name SecretStore -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault

$configuration = @{
    Authentication  = 'Password'
    PasswordTimeout = 3600
    Interaction     = 'None'
    Password        = $credential.Password
    Confirm         = $false
}

Set-SecretStoreConfiguration @configuration
```

### Without Password

To configure a passwordless vault, follow the configuration for a password and then remove the password configuration.

```Powershell

$password = Import-CliXml -Path 'c:\Automation\SSVault.xml'
Unlock-SecretStore -Password $credential.Password

$configuration = @{
    Authentication  = 'None'
    Interaction     = 'None'
    Confirm         = $false
}

Set-SecretStoreConfiguration @configuration
```

## Access Vault

When using a password with a vault you must unlock the store frist.
```Powershell
$password = Import-CliXml -Path 'c:\Automation\SSVault.xml'
Unlock-SecretStore -Password $credential.Password
```

```Powershell
Set-Secret -Name 'UserToken' -Secret $token
```

```Powershell
$token = Get-Secret -Name 'UserToken'
```