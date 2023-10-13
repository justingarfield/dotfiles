. ..\..\Registry.ps1

$focusOptionBytes = @{
    ShowTimerInTheClockApp = (0xc2, 0x14, 0x01)    # 194, 20, 1
    HideBadgesOnTaskbarApps = (0xc2, 0x1e, 0x01)   # 194, 30, 1
    HideFlashingOnTaskbarApps = (0xc2, 0x28, 0x01) # 194, 40, 1
    TurnOnDoNotDisturb = (0xc2, 0x32, 0x01)        # 194, 50, 1
}

$focusRegistryKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default`$windows.data.shell.focussessionactivetheme\windows.data.shell.focussessionactivetheme`${1b019365-25a5-4ff1-b50a-c155229afc8f}"

function Set-ShowTimerInTheClockApp {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )
    
    setFocusOptionBytes -TargetFocusOptionBytes $focusOptionBytes.ShowTimerInTheClockApp -Enabled $Enabled
}

function Set-HideBadgesOnTaskbarApps {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    setFocusOptionBytes -TargetFocusOptionBytes $focusOptionBytes.HideBadgesOnTaskbarApps -Enabled $Enabled
}

function Set-HideFlashingOnTaskbarApps {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    setFocusOptionBytes -TargetFocusOptionBytes $focusOptionBytes.HideFlashingOnTaskbarApps -Enabled $Enabled
}

function Set-TurnOnDoNotDisturb {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    setFocusOptionBytes -TargetFocusOptionBytes $focusOptionBytes.TurnOnDoNotDisturb -Enabled $Enabled
}

function setFocusOptionBytes {
    param(
        [Parameter(Mandatory=$true)]
        [byte[]]
        $TargetFocusOptionBytes,
        
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )
    
    CreateRegistryKeyIfMissing -RegistryKey $focusRegistryKey

    $newFocusOptionBytes = [byte[]](buildFocusOptionBytes -TargetFocusOptionBytes $TargetFocusOptionBytes -Enabled $Enabled)
    $numCheckedFocusOptions = 0x08 + ($newFocusOptionBytes.Length) # None = 0x08, One = 0x0b, Two = 0x0e, Three = 0x11, All = 0x14

    # Well-known constant values from inspecting behavior of Windows Settings via ProcMon
    $firstConstant8Bytes = (0x43, 0x42, 0x01, 0x00, 0x0a, 0x00, 0x2a, 0x06)
    $secondsConstant5Bytes = (0xa9, 0x06, 0x2a, 0x2b, 0x0e)
    $thirdConstan7Bytes = (0x43, 0x42, 0x01, 0x00, 0xc2, 0x0a, 0x01)
    $finalConstant4Bytes = (0x00, 0x00, 0x00, 0x00)
    
    $finalValue = $firstConstant8Bytes     # 8-bytes that never change
    $finalValue += getTimeStampBytes       # Time stamp bytes
    $finalValue += $secondsConstant5Bytes  # 5-bytes that never change
    $finalValue += $numCheckedFocusOptions # How many Focus options are checked
    $finalValue += $thirdConstan7Bytes     # 7-bytes that never change
    $finalValue += $newFocusOptionBytes    # 3-bytes per option checked, always starting with `c2`
    $finalValue += $finalConstant4Bytes    # Last 4-bytes are always constant
    $finalValue = [byte[]]$finalValue
    
    Set-ItemProperty -Path $focusRegistryKey -Name "Data" -Value $finalValue
}

function buildFocusOptionBytes {
    param(
        [Parameter(Mandatory=$true)]
        [byte[]]
        $TargetFocusOptionBytes,
        
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    $currentlyCheckedOptions = @{
        ShowTimerInTheClockApp = $false
        HideBadgesOnTaskbarApps = $false
        HideFlashingOnTaskbarApps = $false
        TurnOnDoNotDisturb = $false
    }

    # Need to inspect the existing registry value to see which options are checked/un-checked
    $currentRegistryValue = Get-ItemPropertyValue -Path $focusRegistryKey -Name "Data" # byte[]

    $selectedFocusOptions = [byte[]]$currentRegistryValue[24..($currentRegistryValue.Length - 5)]
    for ($cursor = 0; $cursor -lt $selectedFocusOptions.Length; $cursor += 3) {
        $selectedBytes = $selectedFocusOptions[$cursor..($cursor + 2)]
        
        if (!(Compare-Object $selectedBytes $focusOptionBytes.ShowTimerInTheClockApp -SyncWindow 0)) {
            $currentlyCheckedOptions.ShowTimerInTheClockApp = $true
        }

        if (!(Compare-Object $selectedBytes $focusOptionBytes.HideBadgesOnTaskbarApps -SyncWindow 0)) {
            $currentlyCheckedOptions.HideBadgesOnTaskbarApps = $true
        }

        if (!(Compare-Object $selectedBytes $focusOptionBytes.HideFlashingOnTaskbarApps -SyncWindow 0)) {
            $currentlyCheckedOptions.HideFlashingOnTaskbarApps = $true
        }

        if (!(Compare-Object $selectedBytes $focusOptionBytes.TurnOnDoNotDisturb -SyncWindow 0)) {
            $currentlyCheckedOptions.TurnOnDoNotDisturb = $true
        }
    }
    
    # Windows Settings always adds these in a particular order...
    # - ShowTimerInTheClockApp
    # - HideBadgesOnTaskbarApps
    # - HideFlashingOnTaskbarApps
    # - TurnOnDoNotDisturb
    $newFocusOptionBytes = @()

    if ((!(Compare-Object $TargetFocusOptionBytes $focusOptionBytes.ShowTimerInTheClockApp -SyncWindow 0) -and $Enabled) `
        -or ((Compare-Object $TargetFocusOptionBytes $focusOptionBytes.ShowTimerInTheClockApp -SyncWindow 0) -and $currentlyCheckedOptions.ShowTimerInTheClockApp)) {
        $newFocusOptionBytes += $focusOptionBytes.ShowTimerInTheClockApp
    }

    if ((!(Compare-Object $TargetFocusOptionBytes $focusOptionBytes.HideBadgesOnTaskbarApps -SyncWindow 0) -and $Enabled) `
        -or ((Compare-Object $TargetFocusOptionBytes $focusOptionBytes.HideBadgesOnTaskbarApps -SyncWindow 0) -and $currentlyCheckedOptions.HideBadgesOnTaskbarApps)) {
        $newFocusOptionBytes += $focusOptionBytes.HideBadgesOnTaskbarApps
    }

    if ((!(Compare-Object $TargetFocusOptionBytes $focusOptionBytes.HideFlashingOnTaskbarApps -SyncWindow 0) -and $Enabled) `
        -or ((Compare-Object $TargetFocusOptionBytes $focusOptionBytes.HideFlashingOnTaskbarApps -SyncWindow 0) -and $currentlyCheckedOptions.HideFlashingOnTaskbarApps)) {
        $newFocusOptionBytes += $focusOptionBytes.HideFlashingOnTaskbarApps
    }

    if ((!(Compare-Object $TargetFocusOptionBytes $focusOptionBytes.TurnOnDoNotDisturb -SyncWindow 0) -and $Enabled) `
        -or ((Compare-Object $TargetFocusOptionBytes $focusOptionBytes.TurnOnDoNotDisturb -SyncWindow 0) -and $currentlyCheckedOptions.TurnOnDoNotDisturb)) {
        $newFocusOptionBytes += $focusOptionBytes.TurnOnDoNotDisturb
    }

    return $newFocusOptionBytes
}

function getTimeStampBytes {
    $epochTime = [System.DateTimeOffset]::new((Get-Date)).ToUnixTimeSeconds()
    $timeStampBits = @()
    $timeStampBits += ($epochTime -band 0x7F -bor 0x80)
    $timeStampBits += (($epochTime -shr 7) -band 0x7F -bor 0x80)
    $timeStampBits += (($epochTime -shr 14) -band 0x7F -bor 0x80)
    return $timeStampBits
}

<#
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
#>
