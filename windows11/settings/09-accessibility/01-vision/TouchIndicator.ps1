
<#
This handles both "Touch indicator" and "Make the circle darker and larger" as a single function.
The behavior of the Windows Settings UI modifies both sets of values together, regardless of order toggled.
#>
function Set-TouchIndicator {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled,
        
        [Parameter(Mandatory=$true)]
        [bool]
        $DarkerAndLargerCircle
    )

    $registryPath = "HKCU:\Control Panel\Cursors"

    # Defaults to "Disabled"
    $gestureVisualization = 24
    $contactVisualization = 0

    if ($Enabled) {
        $gestureVisualization = 31

        if ($DarkerAndLargerCircle) {
            $contactVisualization = 2
        } else {
            $contactVisualization = 1
        }
    }

    Set-ItemProperty -Path $registryPath -Name "ContactVisualization" -Value $contactVisualization
    Set-ItemProperty -Path $registryPath -Name "GestureVisualization" -Value $gestureVisualization

    if (![WinUser]::SystemParametersInfo($systemWideParameters.SPI_SETCONTACTVISUALIZATION, 0, $contactVisualization, 0)) {
        [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
    }

    if (![WinUser]::SystemParametersInfo($systemWideParameters.SPI_SETGESTUREVISUALIZATION, 0, $gestureVisualization, 0)) {
        [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
    }
}
