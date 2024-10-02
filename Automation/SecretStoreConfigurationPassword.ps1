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