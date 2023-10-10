function Set-RememberWindowLocations {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    $value = $Enabled ? 0 : 1
    
    Set-ItemProperty "HKCU:\Control Panel\Desktop" "RestorePreviousStateRecalcBehavior" $value
}

function Set-MinimizeWindowsOnDisconnect {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    $value = $Enabled ? 0 : 1

    Set-ItemProperty "HKCU:\Control Panel\Desktop" "MonitorRemovalRecalcBehavior" $value
}

function Set-EaseCursorMovement {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    $value = $Enabled ? 1 : 0

    Set-ItemProperty "HKCU:\Control Panel\Cursors" "CursorDeadzoneJumpingSetting" $value
}
