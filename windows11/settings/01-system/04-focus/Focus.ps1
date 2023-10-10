function Set-SessionDuration {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateScript(
            { $_ -in 5..240 -and $_ % 5 -eq 0 },
            ErrorMessage = 'Value {0} is not between 5 and 240, nor a multiple of 5.'
        )]
        [int]
        $Duration
    )
    
    Write-Host "Duration passed-in was: $Duration"
}

function Set-ShowTimerInTheClockApp {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    $value = $Enabled ? 1 : 0
    
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-310093Enabled" $value
}

function Set-HideBadgesOnTaskbarApps {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    $value = $Enabled ? 1 : 0
    
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-310093Enabled" $value
}

function Set-HideFlashingOnTaskbarApps {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    $value = $Enabled ? 1 : 0
    
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-310093Enabled" $value
}

function Set-TurnOnDoNotDisturb {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    $value = $Enabled ? 1 : 0
    
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-310093Enabled" $value
}