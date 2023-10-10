function Set-ShowWelcomeExperienceAfterUpdates {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    $value = $Enabled ? 1 : 0
    
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-310093Enabled" $value
}

function Set-GetTipsAndSuggestions {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    $value = $Enabled ? 1 : 0
    
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338389Enabled" $value
}
