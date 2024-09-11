function New-FailoverReservation {

    param(
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [String]$Description,
        [IPAddress]$ScopeId,
        [IPAddress]$ClientId,
        [IPAddress]$IPAddress,
        [ValidateSet("DHCP", "BootP", "Both")]
        [String]$type = "DHCP"
    )
 
    $reservation_settings = @{
        "Name"          = $Name
        "ScopeId"       = [IPAddress]$ScopeId
        "ClientId"      = $ClientId
        "IPAddress"     = [IPAddress]$IPAddress
        "Description"   = $Description
        "Type"          = $Type
    }

    Add-DhcpServerv4Reservation -ScopeId $ScopeId @reservation_settings

    Invoke-DhcpServerv4FailoverReplication -ScopeId $ScopeId

}