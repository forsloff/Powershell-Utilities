
function Submit-CertificateRequest{

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position=0)]
        [String] $CertificateSigningRequest,
        [Parameter(Mandatory)]
        [ValidateScript(
            { 
                $command = "certutil.exe -caTemplates"
                $output = Invoke-Expression -Command $command
                $templates = @();

                foreach($template in $output) {
                    $name = ($template | Select-String -Pattern "^([a-zA-Z_]*):").Matches[0].Groups[1].Value
                    if($name -eq 'CertUtil') { Continue }
                    $templates += "CertificateTemplate:{0}" -f $name
                }
                $_ -in $templates
            },
            ErrorMessage = 'Please Specify a Valid Certificate Template.'
        )]
        [ArgumentCompleter(
            {
                param($cmd, $param, $wordToComplete)

                $command = "certutil.exe -caTemplates"
                $output = Invoke-Expression -Command $command
                $templates = @();

                foreach($template in $output) {
                    $name = ($template | Select-String -Pattern "^([a-zA-Z_]*):").Matches[0].Groups[1].Value
                    if($name -eq 'CertUtil') { Continue }
                    $templates += "CertificateTemplate:{0}" -f $name
                }

                foreach($item in $templates) {
                    if($item -notlike "$wordToComplete*") { Continue }
                    $completion = "'$item'"

                    [System.Management.Automation.CompletionResult]::new(
                        $completion, $item,
                        [System.Management.Automation.CompletionResultType]::ParameterValue,
                        'some tooltip here if you want')
                }
            }
        )]
        [String] $Template
    )

    Write-Host ("certreq -submit -attrib '{1}' {2}" -f $template, $CertificateSigningRequest)

}

function Get-PendingCertificateRequests {

    $command    = "certutil.exe -View -Restrict 'Disposition=9' -out Request.RequestID,Request.CommonName,Request.RequesterName CSV"
    $output     = Invoke-Expression -Command $command | ConvertFrom-Csv | Sort-Object -Property "Request ID" -Descending | Out-GridView
    return $output
}

function Approve-PendingCertificateRequest {

    param (
        [Int]$RequestID
    )
    
    $command = 'certutil.exe -resubmit {0}' -f $RequestID
    
    Invoke-Expression -Command $command

}

function Complete-CertificateRequest {

    param (
        [Int]$RequestID
    )

    $command = "certutil.exe -View -Restrict 'RequestID={0}'" -f $RequestID
    $request = Invoke-Expression -Command $command | ConvertFrom-Csv

    $output = Join-Path -Path $path -ChildPath ("{0}.cer" -f $request.'Request Common Name')

    $command = 'certreq.exe -retrieve {0} {1}' -f $RequestID, $output

    Invoke-Expression -Command $command

}