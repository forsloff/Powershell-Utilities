Register-SecretVault -Name SecretStore -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault

$configuration = @{
    Authentication  = 'None'
    Interaction     = 'None'
    Confirm         = $false
}

Set-SecretStoreConfiguration @configuration