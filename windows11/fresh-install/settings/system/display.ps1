# Settings -> System -> Display

function Scalar-To-Hex {
    param (
        [string]$Scalar
    )

    return $Scalar.Split(',') | ForEach-Object { "0x$_"}
}

# Note: Night light isn't available if your device uses certain drivers (DisplayLink or Basic Display).
# Note: The Night Light feature requires the Connected Devices Platform Service to be enabled, running, and set to automatic.
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.settings")) {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.settings" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.settings\windows.data.bluelightreduction.settings")) {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.settings\windows.data.bluelightreduction.settings" -Type Folder | Out-Null}
$blueLightReductionSettings = Scalar-To-Hex "43,42,01,00,0a,02,01,00,2a,06,ea,86,c1,a8,06,2a,2b,0e,1b,43,42,01,00,02,01,ca,14,0e,13,00,ca,1e,0e,07,00,cf,28,94,3c,ca,32,00,ca,3c,00,00,00,00,00"
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.settings\windows.data.bluelightreduction.settings -Name Data -Value ([byte[]]($blueLightReductionSettings))

if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.bluelightreductionstate")) {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.bluelightreductionstate" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.bluelightreductionstate\windows.data.bluelightreduction.bluelightreductionstate")) {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.bluelightreductionstate\windows.data.bluelightreduction.bluelightreductionstate" -Type Folder | Out-Null}
$blueLightReductionState = Scalar-To-Hex "43,42,01,00,0a,02,01,00,2a,06,b0,ad,c0,a8,06,2a,2b,0e,10,43,42,01,00,c6,14,bf,ff,ea,98,e4,da,fb,ec,01,00,00,00,00"
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.bluelightreductionstate\windows.data.bluelightreduction.bluelightreductionstate -Name Data -Value ([byte[]]($blueLightReductionState))
