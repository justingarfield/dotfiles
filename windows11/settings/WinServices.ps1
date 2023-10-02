#############################################################################################################
# This file houses the functionality to perform Interop calls to the WinUser.h related functions in Windows
#
# Note: An elevated PowerShell session is required to call these since they Start/Stop Windows Services.
#############################################################################################################

$netExe = "net.exe"

function Start-WindowsService {
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $ServiceName
    )

    Start-Process -FilePath $netExe -ArgumentList "START $ServiceName" -Wait -Verb RunAs
}

function Stop-WindowsService {
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $ServiceName
    )

    Start-Process -FilePath $netExe -ArgumentList "STOP $ServiceName" -Wait -Verb RunAs
}

function Restart-WindowsService {
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $ServiceName
    )

    Stop-WindowsService -ServiceName $ServiceName
    Start-WindowsService -ServiceName $ServiceName
}
