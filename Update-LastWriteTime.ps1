
# Update-LastWriteTime -path C:\Temp\file.txt
# touch C:\Temp\file.txt

function Update-LastWriteTime {
    param (
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string] $Path
    )
    $item = Get-Item -Path $path
    $item.LastWriteTime = (Get-Date)
}

Set-Alias -Name touch -Value Update-LastWriteTime