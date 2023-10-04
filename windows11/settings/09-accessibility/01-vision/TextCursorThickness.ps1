
# Source the required functions and helpers
. ..\..\WinUser.ps1

function Set-TextCursorThickness {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateRange(1, 20)]
        [int]
        $Thickness
    )

    Set-ItemProperty "HKCU:\Control Panel\Desktop" "CaretWidth" $Thickness
    
    # Still need to actually "apply" the change
}
