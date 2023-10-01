################################################################################################
# This file houses the functionality to change the "Audio Settings" under Accessibility -> Audio
################################################################################################

function Set-MonoAudio {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    $value = 0
    if ($Enabled) {
        $value = 1
    }

    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Multimedia\Audio" -Name "AccessibilityMonoMixState" -Value $value

    # Restart the "Windows Audio" service
    Start-Process -FilePath "net.exe" -ArgumentList "STOP Audiosrv" -Wait -Verb RunAs
    Start-Process -FilePath "net.exe" -ArgumentList "START Audiosrv" -Wait -Verb RunAs
}
