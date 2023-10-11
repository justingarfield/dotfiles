. ..\..\Registry.ps1

$firstConstant8Bytes = (0x43, 0x42, 0x01, 0x00, 0x0a, 0x00, 0x2a, 0x06)
$secondsConstant5Bytes = (0xa9, 0x06, 0x2a, 0x2b, 0x0e)
$thirdConstan7Bytes = (0x43, 0x42, 0x01, 0x00, 0xc2, 0x0a, 0x01)
$finalConstant4Bytes = (0x00, 0x00, 0x00, 0x00)

$numSelectedFocusOptions = @{
    None = 0x08  # 8
    One = 0x0b   # 11
    Two = 0x0e   # 14
    Three = 0x11 # 17
    All = 0x14   # 20
}

$focusOptionBits = @{
    ShowTimerInTheClockApp = (0xc2, 0x14, 0x01)    # 194, 20, 1
    HideBadgesOnTaskbarApps = (0xc2, 0x1e, 0x01)   # 194, 30, 1
    HideFlashingOnTaskbarApps = (0xc2, 0x28, 0x01) # 194, 40, 1
    TurnOnDoNotDisturb = (0xc2, 0x32, 0x01)        # 194, 50, 1
}

$focusRegistryKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default`$windows.data.shell.focussessionactivetheme\windows.data.shell.focussessionactivetheme`${1b019365-25a5-4ff1-b50a-c155229afc8f}"

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

    CreateRegistryKeyIfMissing -RegistryKey $focusRegistryKey

    # Need to inspect the existing registry value to see which options are checked/un-checked
    $currentRegistryValue = Get-ItemPropertyValue -Path $focusRegistryKey -Name "Data" # byte[]
    
    # How many Focus options are currently checked
    $currentNumCheckedFocusOptions = $currentRegistryValue[16]

    # Currently checked Focus option values
    $selectedFocusOptions = [byte[]]$currentRegistryValue[24..($currentRegistryValue.Length - 5)]
    for ($cursor = 0; $cursor -lt $selectedFocusOptions.Length; $cursor += 3) {
        # Byte between "0xc2 (194)" and "0x01 (1)"
        $middleByte = $selectedFocusOptions[$cursor + 1]

        if ($focusOptionBits.ShowTimerInTheClockApp[1] -eq $middleByte) {
            Write-Host "Yes!"
        }
    }

    $finalFocusOptionBits = @()

    $finalValue = $firstConstant8Bytes            # 8-bytes that never change
    $finalValue += getTimeStampBytes              # Time stamp bytes
    $finalValue += $secondsConstant5Bytes         # 5-bytes that never change
    $finalValue += $currentNumCheckedFocusOptions # How many Focus options are checked
    $finalValue += $thirdConstan7Bytes            # 7-bytes that never change
    $finalValue += $finalFocusOptionBits          # 3-bytes per option checked, always starting with `c2`
    $finalValue += $finalConstant4Bytes           # Last 4-bytes are always constant

    # Set-ItemProperty -Path $focusRegistryKey -Name "Data" -Value $finalValue
}

function Set-HideBadgesOnTaskbarApps {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    Set-ItemProperty -Path $focusRegistryKey -Name "Data" -Value $finalValue
}

function Set-HideFlashingOnTaskbarApps {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    Set-ItemProperty $focusRegistryKey "Data" $finalValue
}

function Set-TurnOnDoNotDisturb {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    Set-ItemProperty $focusRegistryKey "Data" $finalValue
}

function getTimeStampBytes {
    $epochTime = [System.DateTimeOffset]::new((date)).ToUnixTimeSeconds()
    $timeStampBits = ($epochTime -band 0x7F -bor 0x80)
    $timeStampBits += (($epochTime -shr 7) -band 0x7F -bor 0x80)
    $timeStampBits += (($epochTime -shr 14) -band 0x7F -bor 0x80)
    return $timeStampBits
}

<#
function constructFinalValue {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $ShowTimerInTheClockApp,

        [Parameter(Mandatory=$true)]
        [bool]
        $HideBadgesOnTaskbarApps,

        [Parameter(Mandatory=$true)]
        [bool]
        $HideFlashingOnTaskbarApps,

        [Parameter(Mandatory=$true)]
        [bool]
        $TurnOnDoNotDisturb
    )
}
#>
