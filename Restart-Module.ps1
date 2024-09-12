function Restart-Module {
    param (
        [string]$Name
    )

    $module = Get-Module -Name $Name
    Remove-Module -Name $module.Name
    Import-Module $module.Path
}