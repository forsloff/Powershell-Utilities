$credential = Import-CliXml -Path 'c:\Automation\SSVault.xml'
Unlock-SecretStore -Password $credential.Password

$configuration = @{
    Authentication  = 'None'
    Interaction     = 'None'
    Confirm         = $false
}

Set-SecretStoreConfiguration @configuration