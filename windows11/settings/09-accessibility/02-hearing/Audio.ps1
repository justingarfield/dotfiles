##################################################################################################
# This file houses the functionality to change the "Audio Settings" under Accessibility -> Audio
##################################################################################################

# Source the required functions and helpers
. ..\..\WinServices.ps1

function Set-MonoAudio {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    $value = $Enabled ? 1 : 0

    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Multimedia\Audio" -Name "AccessibilityMonoMixState" -Value $value

    # Restart the "Windows Audio" service
    Restart-WindowsService -ServiceName "Audiosrv"
}
