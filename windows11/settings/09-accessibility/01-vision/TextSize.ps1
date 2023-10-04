
# Source the required functions and helpers
. ..\..\WinUser.ps1

function Set-TextSize {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateRange(100, 225)]
        [int]
        $Percent
    )
    
    Set-ItemProperty "HKCU:\Software\Microsoft\Accessibility" "TextScaleFactor" $Percent

    if (![WinUser]::SystemParametersInfo($systemWideParameters.SPI_SETLOGICALDPIOVERRIDE, 0, $null, 0)) {
        [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
    }
}
