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

### Research

# Strength updates                    HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.settings\windows.data.bluelightreduction.settings\Data
# Schedule night light On/Off updates HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.settings\windows.data.bluelightreduction.settings\Data
# Set hours Turn On updates           HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.settings\windows.data.bluelightreduction.settings\Data
# Set hours Turn Off updates          HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.settings\windows.data.bluelightreduction.settings\Data
# Turn on now updates                 HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.bluelightreductionstate\windows.data.bluelightreduction.bluelightreductionstate\Data
# Turn off now updates                HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.bluelightreductionstate\windows.data.bluelightreduction.bluelightreductionstate\Data

$data = (0x43, 0x42, 0x01, 0x00, 0x0A, 0x02, 0x01, 0x00, 0x2A, 0x06)
$epochTime = [System.DateTimeOffset]::new((date)).ToUnixTimeSeconds()
$data += $epochTime -band 0x7F -bor 0x80
$data += ($epochTime -shr 7) -band 0x7F -bor 0x80
$data += ($epochTime -shr 14) -band 0x7F -bor 0x80
$data += ($epochTime -shr 21) -band 0x7F -bor 0x80
$data += $epochTime -shr 28
$data
$data += (0x2A, 0x2B, 0x0E, 0x1D, 0x43, 0x42, 0x01, 0x00)
If ($Enabled) {$data += (0x02, 0x01)}
$data += (0xCA, 0x14, 0x0E)



# Off / 0 / Off         - 43,42,01,00,0a,02,01,00,2a,06,b0,f7,c2,a8,06,2a,2b,0e,21,43,42,01,00,ca,14,0e,04,00,ca,1e,0e,10,00,cf,28,c8,65,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# Off / 50 / Off        - 43,42,01,00,0a,02,01,00,2a,06,cc,f9,c2,a8,06,2a,2b,0e,21,43,42,01,00,ca,14,0e,04,00,ca,1e,0e,10,00,cf,28,94,3c,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# Off / 63 / Off        - 43,42,01,00,0a,02,01,00,2a,06,fa,f9,c2,a8,06,2a,2b,0e,21,43,42,01,00,ca,14,0e,04,00,ca,1e,0e,10,00,cf,28,b2,31,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# Off / 100 / Off       - 43,42,01,00,0a,02,01,00,2a,06,9c,fa,c2,a8,06,2a,2b,0e,21,43,42,01,00,ca,14,0e,04,00,ca,1e,0e,10,00,cf,28,e0,12,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# On / 0 / Off          - 43,42,01,00,0a,02,01,00,2a,06,d0,fa,c2,a8,06,2a,2b,0e,21,43,42,01,00,ca,14,0e,04,00,ca,1e,0e,10,00,cf,28,c8,65,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# On / 50 / Off         - 43,42,01,00,0a,02,01,00,2a,06,98,fb,c2,a8,06,2a,2b,0e,21,43,42,01,00,ca,14,0e,04,00,ca,1e,0e,10,00,cf,28,94,3c,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# On / 63 / Off         - 43,42,01,00,0a,02,01,00,2a,06,c0,fb,c2,a8,06,2a,2b,0e,21,43,42,01,00,ca,14,0e,04,00,ca,1e,0e,10,00,cf,28,b2,31,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# On / 100 / Off        - 43,42,01,00,0a,02,01,00,2a,06,e2,fb,c2,a8,06,2a,2b,0e,21,43,42,01,00,ca,14,0e,04,00,ca,1e,0e,10,00,cf,28,e0,12,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# Off / 0 / Sunset      - 43,42,01,00,0a,02,01,00,2a,06,96,84,c3,a8,06,2a,2b,0e,23,43,42,01,00,02,01,ca,14,0e,04,00,ca,1e,0e,10,00,cf,28,c8,65,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# Off / 50 / Sunset     - 43,42,01,00,0a,02,01,00,2a,06,da,83,c3,a8,06,2a,2b,0e,23,43,42,01,00,02,01,ca,14,0e,04,00,ca,1e,0e,10,00,cf,28,94,3c,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# Off / 63 / Sunset     - 43,42,01,00,0a,02,01,00,2a,06,88,85,c3,a8,06,2a,2b,0e,23,43,42,01,00,02,01,ca,14,0e,04,00,ca,1e,0e,10,00,cf,28,b2,31,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# Off / 100 / Sunset    - 43,42,01,00,0a,02,01,00,2a,06,b0,85,c3,a8,06,2a,2b,0e,23,43,42,01,00,02,01,ca,14,0e,04,00,ca,1e,0e,10,00,cf,28,e0,12,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# Off / 0 / 12am-12pm   - 43,42,01,00,0a,02,01,00,2a,06,df,86,c3,a8,06,2a,2b,0e,24,43,42,01,00,02,01,c2,0a,00,ca,14,00,ca,1e,0e,0c,00,cf,28,c8,65,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# Off / 50 / 12am-12pm  - 43,42,01,00,0a,02,01,00,2a,06,a7,87,c3,a8,06,2a,2b,0e,24,43,42,01,00,02,01,c2,0a,00,ca,14,00,ca,1e,0e,0c,00,cf,28,94,3c,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# Off / 63 / 12am-12pm  - 43,42,01,00,0a,02,01,00,2a,06,cd,87,c3,a8,06,2a,2b,0e,24,43,42,01,00,02,01,c2,0a,00,ca,14,00,ca,1e,0e,0c,00,cf,28,b2,31,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# Off / 100 / 12am-12pm - 43,42,01,00,0a,02,01,00,2a,06,bb,85,c3,a8,06,2a,2b,0e,24,43,42,01,00,02,01,c2,0a,00,ca,14,00,ca,1e,0e,0c,00,cf,28,e0,12,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# Off / 0 / 7pm-7am     - 43,42,01,00,0a,02,01,00,2a,06,8d,8b,c3,a8,06,2a,2b,0e,26,43,42,01,00,02,01,c2,0a,00,ca,14,0e,13,00,ca,1e,0e,07,00,cf,28,c8,65,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# Off / 50 / 7pm-7am    - 43,42,01,00,0a,02,01,00,2a,06,f1,8a,c3,a8,06,2a,2b,0e,26,43,42,01,00,02,01,c2,0a,00,ca,14,0e,13,00,ca,1e,0e,07,00,cf,28,94,3c,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# Off / 63 / 7pm-7am    - 43,42,01,00,0a,02,01,00,2a,06,c3,8a,c3,a8,06,2a,2b,0e,26,43,42,01,00,02,01,c2,0a,00,ca,14,0e,13,00,ca,1e,0e,07,00,cf,28,b2,31,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
# Off / 100 / 7pm-7am   - 43,42,01,00,0a,02,01,00,2a,06,e7,89,c3,a8,06,2a,2b,0e,26,43,42,01,00,02,01,c2,0a,00,ca,14,0e,13,00,ca,1e,0e,07,00,cf,28,e0,12,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00
