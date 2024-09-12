function Install-gMSAScheduledTask {
    
    param (
        [Parameter(ParameterSetName ="FromPath")]
        [Parameter(ParameterSetName ="FromScriptBlock")]
        [Parameter(ParameterSetName ="FromApplication")]
        [String] $Name,

        [Parameter(ParameterSetName ="FromPath")]
        [String] $Path,
        
        [Parameter(ParameterSetName ="FromScriptBlock")]
        [ScriptBlock] $ScriptBlock,
        
        [Parameter(ParameterSetName ="FromApplication")]
        [String] $Application,
        
        [Parameter(ParameterSetName ="FromApplication")]
        [String] $Arguments,
        
        [Parameter(ParameterSetName ="FromUrl")]
        [Parameter(ParameterSetName ="FromPath")]
        [Parameter(ParameterSetName ="FromScriptBlock")]
        [Parameter(ParameterSetName ="FromApplication")]
        [Object] $Trigger
    )

    $account           = 'gMSA-SchTask$'
    $scripts_directory = 'C:\Scripts'

    if($scriptblock) {
        $path = Join-Path -Path $scripts_directory -ChildPath ("{0}.ps1" -f $name)
        $scriptblock.ToString() | Out-File $path
    }

    if($path) {
        if( -not ( Test-Path -Path $path ) ){
            Write-Host ('Could not find {0}' -f $path)
            break
        }
        $application    = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
        $arguments      = "-NonInteractive -NoLogo -NoProfile -File {0}" -f $path
    }

    $action     = New-ScheduledTaskAction  -Execute $application -Argument $arguments 
    $principal  = New-ScheduledTaskPrincipal -UserID $account -LogonType Password

    Register-ScheduledTask -TaskName $name -Action $action -Trigger $trigger -Principal $principal

}