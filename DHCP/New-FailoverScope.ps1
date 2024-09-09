function New-FailoverScope {

    # This script is predicated upon a /24 subnet, and a windows DHCP server configured configured in a Windows failover cluster.

    param(
        [Parameter(Mandatory=$true)]
        [IPAddress]$ScopeId,
        [Parameter(Mandatory=$true)]
        [String]$Description,
        [Parameter(Mandatory=$true)]
        [String[]]$DNS,
        [String[]]$Voice,
        [ValidateRange(1,255)]
        [int]$start = 20,
        [ValidateRange(1,255)]
        [int]$end = 200,
        [ValidateRange(1,255)]
        [int]$gateway = 1,
        [ValidateSet("DHCP", "BootP", "Both")]
        [String]$type = "DHCP",
        [TimeSpan]$duration = (New-TimeSpan -Hours 4)
    )
 
    $failover = Get-DhcpServerv4Failover
 
    if($null -ne (Get-DhcpServerv4Scope -ScopeId $ScopeId -ErrorAction SilentlyContinue)) {
        $message = "The DHCP Scope {0} already exists" -f $scope_id
        Write-Error $message
        Break
    }
 
    $scope_id   = [IPAddress]$ScopeId
    $address    = $scope_id.GetAddressBytes()
 
    $gateway    = [IPAddress]("{0}.{1}.{2}.{3}" -f $address[0], $address[1], $address[2], $gateway)
 
    $scope_settings     = @{
        "Name"          = $description
        "StartRange"    = [IPAddress]("{0}.{1}.{2}.{3}" -f $address[0], $address[1], $address[2], $start)
        "EndRange"      = [IPAddress]("{0}.{1}.{2}.{3}" -f $address[0], $address[1], $address[2], $end)
        "SubnetMask"    = [IPAddress]"255.255.255.0"
        "Description"   = $description
        "LeaseDuration" = [TimeSpan]$duration
        "Delay"         = 0
        "Type"          = $type
    }
 
    Add-DhcpServerv4Scope @scope_settings

    Set-DhcpServerv4OptionValue -OptionId 3 -ScopeId $scope_id -Value $gateway
    Set-DhcpServerv4OptionValue -OptionId 6 -ScopeId $scope_id -Value $dns

    if($voice) {
        Set-DhcpServerv4OptionValue -OptionId 150 -ScopeId $scope_id -Value $voice
    }
 
    Add-DhcpServerv4FailoverScope -Name $failover.Name -ScopeId $scope_id
     
}