$ServiceStatus = Get-Service -Name W32time

if ( ( $ServiceStatus | ForEach-Object StartType ) -ne "Automatic" ) {
    Set-Service -Name W32Time -startupType Automatic
}
if ( ( $ServiceStatus | ForEach-Object Status ) -ne "Running" ) {
    Start-Service -Name W32Time
}

C:\WINDOWS\system32\sc.exe triggerinfo w32time start/networkon stop/networkoff
