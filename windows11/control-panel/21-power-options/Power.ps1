# See: https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/configure-power-settings

# Source the required functions and helpers
. ..\..\common\Power.ps1
. .\JavaScriptTimerFrequencyTypes.ps1
. .\LinkStatePowerManagementTypes.ps1
. .\PowerModeTypes.ps1
. .\PowerOptionDurationTypes.ps1
. .\PowerOptionTypes.ps1
. .\PowerSavingModeTypes.ps1
. .\SlideShowSettingTypes.ps1
. .\VideoPlaybackQualityBiasTypes.ps1
. .\WakeTimerTypes.ps1
. .\WhenPlayingVideoTypes.ps1
. .\WhenSharingMediaTypes.ps1

# Note: Cannot use [[:xdigit:]] with .NET RegEx Engine for hex value matching
$CONST_REGEX_GUID = "[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}"
$CONST_REGEX_POWERSCHEMENAME = ".+"
$CONST_REGEX_POWERSCHEME_GUID_AND_NAME = "($CONST_REGEX_GUID)\s+\(($CONST_REGEX_POWERSCHEMENAME)\)"

function Get-PowerSchemes {
    $getPowerSchemesOutput = cmd /c "$powerCfgExe /LIST"

    $powerSchemes = @()

    $powerShemesMatch = $getPowerSchemesOutput | Select-String -Pattern $CONST_REGEX_POWERSCHEME_GUID_AND_NAME
    foreach ($match in $powerShemesMatch.Matches) {
        $powerSchemeGuid = $match.Groups[1].Value
        $powerSchemeName = $match.Groups[2].Value

        $powerSchemes += (@{
            Guid = $powerSchemeGuid
            Name = $powerSchemeName
        })
    }

    return $powerSchemes
}

function Get-ActivePowerScheme {
    $getActiveSchemeOutput = cmd /c "$powerCfgExe /GETACTIVESCHEME"

    $activePowerShemeMatch = $getActiveSchemeOutput | Select-String -Pattern $CONST_REGEX_POWERSCHEME_GUID_AND_NAME
    $activePowerSchemeGuid = $activePowerShemeMatch.Matches[0].Groups[1].Value
    $activePowerSchemeName = $activePowerShemeMatch.Matches[0].Groups[2].Value
    
    return @{
        Guid = $activePowerSchemeGuid
        Name = $activePowerSchemeName
    }
}

function DuplicatePowerScheme {
    param(
        [Parameter(Mandatory=$true)]
        [ValidatePowerSchemeExists()]
        [String]
        $NameOrGuid
    )
    
    $powerSchemeToDuplicate = $null
    if ($NameOrGuid -match $CONST_REGEX_GUID) {
        $powerSchemeToDuplicate = Get-PowerSchemes | Where-Object { $_.Guid -eq $NameOrGuid }
    } else {
        $powerSchemeToDuplicate = Get-PowerSchemes | Where-Object { $_.Name -eq $NameOrGuid }
    }

    $duplicatePowerSchemeOutput = cmd /c "$powerCfgExe /DUPLICATESCHEME $($powerSchemeToDuplicate.Guid)"

    $duplicatePowerShemeMatch = $duplicatePowerSchemeOutput | Select-String -Pattern $CONST_REGEX_POWERSCHEME_GUID_AND_NAME
    $duplicatePowerSchemeGuid = $duplicatePowerShemeMatch.Matches[0].Groups[1].Value
    $duplicatePowerSchemeName = $duplicatePowerShemeMatch.Matches[0].Groups[2].Value
    
    return @{
        Guid = $duplicatePowerSchemeGuid
        Name = $duplicatePowerSchemeName
    }
}

function Set-PowerSchemeNameAndDescription {
    param(
        [Parameter(Mandatory=$true)]
        [String]
        [ValidatePowerSchemeExists()]
        $NameOrGuid,

        [Parameter(Mandatory=$true)]
        [String]
        $Name,

        [String]
        $Description
    )
    
    $powerSchemeToModify = $null
    if ($NameOrGuid -match $CONST_REGEX_GUID) {
        $powerSchemeToModify = Get-PowerSchemes | Where-Object { $_.Guid -eq $NameOrGuid }
    } else {
        $powerSchemeToModify = Get-PowerSchemes | Where-Object { $_.Name -eq $NameOrGuid }
    }

    cmd /c "$powerCfgExe /CHANGENAME $($powerSchemeToModify.Guid) $Name $Description"
}

### Choose what the power buttons do

function Set-PowerButtonSetting {
    param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [PowerOptionTypes]
        $PowerOption,

        [String]
        [ValidatePowerSchemeExists(AllowEmpty = $true)]
        $PowerSchemeNameOrGuid
    )

    $powerCfgValueIndex = $PowerSource -eq [PowerSourceTypes]::PluggedIn ? "/SETACVALUEINDEX" : "/SETDCVALUEINDEX"

    $powerCfgSchemeGuid = "SCHEME_CURRENT"
    if (![string]::IsNullOrEmpty($PowerSchemeNameOrGuid)) {

        $powerScheme = $null
        if ($PowerSchemeNameOrGuid -match $CONST_REGEX_GUID) {
            $powerScheme = Get-PowerSchemes | Where-Object { $_.Guid -eq $PowerSchemeNameOrGuid }
        } else {
            $powerScheme = Get-PowerSchemes | Where-Object { $_.Name -eq $PowerSchemeNameOrGuid }
        }

        $powerCfgSchemeGuid = $powerScheme.Guid
    }

    $powerCfgSubGuid = $powerCfgAliases.SUB_BUTTONS
    $powerCfgSettingGuid = $powerCfgAliases.SUB_BUTTONS_CUSTOM_POWER_BUTTON
    $powerCfgSettingIndex = [int]([PowerOptionTypes]::$PowerOption)

    Write-Host "$powerCfgExe $powerCfgValueIndex $powerCfgSchemeGuid $powerCfgSubGuid $powerCfgSettingGuid $powerCfgSettingIndex"
    cmd /c "$powerCfgExe $powerCfgValueIndex $powerCfgSchemeGuid $powerCfgSubGuid $powerCfgSettingGuid $powerCfgSettingIndex"
    cmd /c "$powerCfgExe /SETACTIVE $powerCfgSchemeGuid" # Control Panel calls this on Save, but not sure if it actually does anything?
}

function Set-SleepButtonSetting {
    param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [PowerOptionTypes]
        $PowerOption,

        [String]
        [ValidatePowerSchemeExists(AllowEmpty = $true)]
        $PowerSchemeNameOrGuid
    )

    $powerCfgValueIndex = $PowerSource -eq [PowerSourceTypes]::PluggedIn ? "/SETACVALUEINDEX" : "/SETDCVALUEINDEX"

    $powerCfgSchemeGuid = "SCHEME_CURRENT"
    if (![string]::IsNullOrEmpty($PowerSchemeNameOrGuid)) {
        $powerScheme = $null
        if ($PowerSchemeNameOrGuid -match $CONST_REGEX_GUID) {
            $powerScheme = Get-PowerSchemes | Where-Object { $_.Guid -eq $PowerSchemeNameOrGuid }
        } else {
            $powerScheme = Get-PowerSchemes | Where-Object { $_.Name -eq $PowerSchemeNameOrGuid }
        }

        $powerCfgSchemeGuid = $powerScheme.Guid
    }

    $powerCfgSubGuid = $powerCfgAliases.SUB_BUTTONS
    $powerCfgSettingGuid = $powerCfgAliases.SUB_BUTTONS_CUSTOM_SLEEP_BUTTON
    $powerCfgSettingIndex = [int]([PowerOptionTypes]::$PowerOption)

    Write-Host "$powerCfgExe $powerCfgValueIndex $powerCfgSchemeGuid $powerCfgSubGuid $powerCfgSettingGuid $powerCfgSettingIndex"
    cmd /c "$powerCfgExe $powerCfgValueIndex $powerCfgSchemeGuid $powerCfgSubGuid $powerCfgSettingGuid $powerCfgSettingIndex"
    cmd /c "$powerCfgExe /SETACTIVE $powerCfgSchemeGuid" # Control Panel calls this on Save, but not sure if it actually does anything?
}

function Set-FastStartup {
    Param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    $value = $Enabled ? 1 : 0

    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value $value
}

function Set-ShowSleepInPowerMenu {
    Param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    $value = $Enabled ? 1 : 0

    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowSleepOption" -Value $value
}

function Set-ShowHibernateInPowerMenu {
    Param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    $value = $Enabled ? 1 : 0

    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Value $value
}

function Set-ShowShutdownOptionsOnLockScreen {
    Param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    $value = $Enabled ? 1 : 0

    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowLockOption" -Value $value
}

### Advanced Power Settings

function Set-TurnOffHDDAfter {
    Param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [ValidateRange(0, 71582788)]
        [Int]
        $Minutes,

        [String]
        [ValidatePowerSchemeExists(AllowEmpty = $true)]
        $PowerSchemeNameOrGuid
    )

    $powerCfgSubGuid = $powerCfgAliases.SUB_DISK
    $powerCfgSettingGuid = $powerCfgAliases.SUB_DISK_DISKIDLE
    $powerCfgSettingIndex = $Minutes * 60 # Control Panel has user specify Minutes, but stores value as seconds

    # Note: There are shortcuts using "/CHANGE [disk-timeout-ac|disk-timeout-dc]", but let's stay consistent
    Set-AcDcValue `
        -PowerSource $PowerSource `
        -PowerCfgSubGuid $powerCfgSubGuid `
        -PowerCfgSettingGuid $powerCfgSettingGuid `
        -PowerCfgSettingIndex $powerCfgSettingIndex `
        -PowerSchemeNameOrGuid $PowerSchemeNameOrGuid
}

function Set-JavaScriptTimerFrequency {
    Param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [JavaScriptTimerFrequencyTypes]
        $JavaScriptTimerFrequency,

        [String]
        [ValidatePowerSchemeExists(AllowEmpty = $true)]
        $PowerSchemeNameOrGuid
    )

    Write-Warning "Internet Explorer is now End-of-Life (EOL) and can burn in Hell. This setting will do nothing...but will still get set properly ;)"
    
    $powerCfgSubGuid = $powerCfgAliases.SUB_CUSTOM_INTERNET_EXPLORER
    $powerCfgSettingGuid = $powerCfgAliases.SUB_CUSTOM_INTERNET_EXPLORER_JS_TIMER_FREQ
    $powerCfgSettingIndex = [int]([JavaScriptTimerFrequencyTypes]::$JavaScriptTimerFrequency)

    Set-AcDcValue `
        -PowerSource $PowerSource `
        -PowerCfgSubGuid $powerCfgSubGuid `
        -PowerCfgSettingGuid $powerCfgSettingGuid `
        -PowerCfgSettingIndex $powerCfgSettingIndex `
        -PowerSchemeNameOrGuid $PowerSchemeNameOrGuid
}

function Set-DesktopBackgroundSettings {
    Param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [SlideShowSettingTypes]
        $SlideShowSetting,

        [String]
        [ValidatePowerSchemeExists(AllowEmpty = $true)]
        $PowerSchemeNameOrGuid
    )

    $powerCfgSubGuid = $powerCfgAliases.SUB_CUSTOM_DESKTOP_BACKGROUND
    $powerCfgSettingGuid = $powerCfgAliases.SUB_CUSTOM_DESKTOP_BACKGROUND_SLIDE_SHOW
    $powerCfgSettingIndex = [int]([SlideShowSettingTypes]::$SlideShowSetting)

    Set-AcDcValue `
        -PowerSource $PowerSource `
        -PowerCfgSubGuid $powerCfgSubGuid `
        -PowerCfgSettingGuid $powerCfgSettingGuid `
        -PowerCfgSettingIndex $powerCfgSettingIndex `
        -PowerSchemeNameOrGuid $PowerSchemeNameOrGuid
}

function Set-WirelessAdapterPowerSavingMode {
    Param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [PowerSavingModeTypes]
        $PowerSavingMode,

        [String]
        [ValidatePowerSchemeExists(AllowEmpty = $true)]
        $PowerSchemeNameOrGuid
    )

    $powerCfgSubGuid = $powerCfgAliases.SUB_CUSTOM_WIRELESS_ADAPTER
    $powerCfgSettingGuid = $powerCfgAliases.SUB_CUSTOM_WIRELESS_ADAPTER_POWER_SAVING
    $powerCfgSettingIndex = [int]([PowerSavingModeTypes]::$PowerSavingMode)

    Set-AcDcValue `
        -PowerSource $PowerSource `
        -PowerCfgSubGuid $powerCfgSubGuid `
        -PowerCfgSettingGuid $powerCfgSettingGuid `
        -PowerCfgSettingIndex $powerCfgSettingIndex `
        -PowerSchemeNameOrGuid $PowerSchemeNameOrGuid
}

function Set-HibernateAfter {
    Param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [ValidateRange(0, 71582788)]
        [Int]
        $Minutes,

        [String]
        [ValidatePowerSchemeExists(AllowEmpty = $true)]
        $PowerSchemeNameOrGuid
    )

    $powerCfgSubGuid = $powerCfgAliases.SUB_SLEEP
    $powerCfgSettingGuid = $powerCfgAliases.SUB_SLEEP_HIBERNATEIDLE
    $powerCfgSettingIndex = $Minutes * 60 # Control Panel has user specify Minutes, but stores value as seconds

    Set-AcDcValue `
        -PowerSource $PowerSource `
        -PowerCfgSubGuid $powerCfgSubGuid `
        -PowerCfgSettingGuid $powerCfgSettingGuid `
        -PowerCfgSettingIndex $powerCfgSettingIndex `
        -PowerSchemeNameOrGuid $PowerSchemeNameOrGuid
}

function Set-AllowWakeTimers {
    Param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [WakeTimerTypes]
        $WakeTimer,

        [String]
        [ValidatePowerSchemeExists(AllowEmpty = $true)]
        $PowerSchemeNameOrGuid
    )

    $powerCfgSubGuid = $powerCfgAliases.SUB_SLEEP
    $powerCfgSettingGuid = $powerCfgAliases.SUB_SLEEP_RTCWAKE
    $powerCfgSettingIndex = [int]([WakeTimerTypes]::$WakeTimer)

    Set-AcDcValue `
        -PowerSource $PowerSource `
        -PowerCfgSubGuid $powerCfgSubGuid `
        -PowerCfgSettingGuid $powerCfgSettingGuid `
        -PowerCfgSettingIndex $powerCfgSettingIndex `
        -PowerSchemeNameOrGuid $PowerSchemeNameOrGuid
}

function Set-UsbSelectiveSuspend {
    Param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled,

        [String]
        [ValidatePowerSchemeExists(AllowEmpty = $true)]
        $PowerSchemeNameOrGuid
    )

    $powerCfgSubGuid = $powerCfgAliases.SUB_CUSTOM_USB
    $powerCfgSettingGuid = $powerCfgAliases.SUB_CUSTOM_USB_SELECTIVE_SUSPEND
    $powerCfgSettingIndex = $Enabled ? 1 : 0

    Set-AcDcValue `
        -PowerSource $PowerSource `
        -PowerCfgSubGuid $powerCfgSubGuid `
        -PowerCfgSettingGuid $powerCfgSettingGuid `
        -PowerCfgSettingIndex $powerCfgSettingIndex `
        -PowerSchemeNameOrGuid $PowerSchemeNameOrGuid
}

function Set-LinkStatePowerManagement {
    Param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [LinkStatePowerManagementTypes]
        $LinkStatePowerManagement,

        [String]
        [ValidatePowerSchemeExists(AllowEmpty = $true)]
        $PowerSchemeNameOrGuid
    )

    $powerCfgSubGuid = $powerCfgAliases.SUB_PCIEXPRESS
    $powerCfgSettingGuid = $powerCfgAliases.SUB_PCIEXPRESS_ASPM
    $powerCfgSettingIndex = [int]([LinkStatePowerManagementTypes]::$LinkStatePowerManagement)

    Set-AcDcValue `
        -PowerSource $PowerSource `
        -PowerCfgSubGuid $powerCfgSubGuid `
        -PowerCfgSettingGuid $powerCfgSettingGuid `
        -PowerCfgSettingIndex $powerCfgSettingIndex `
        -PowerSchemeNameOrGuid $PowerSchemeNameOrGuid
}

function Set-MinimumProcessState {
    Param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [ValidateRange(0, 100)]
        [Int]
        $Percentage,

        [String]
        [ValidatePowerSchemeExists(AllowEmpty = $true)]
        $PowerSchemeNameOrGuid
    )

    $powerCfgSubGuid = $powerCfgAliases.SUB_PROCESSOR
    $powerCfgSettingGuid = $powerCfgAliases.SUB_PROCESSOR_PROCTHROTTLEMIN
    $powerCfgSettingIndex = $Percentage

    Set-AcDcValue `
        -PowerSource $PowerSource `
        -PowerCfgSubGuid $powerCfgSubGuid `
        -PowerCfgSettingGuid $powerCfgSettingGuid `
        -PowerCfgSettingIndex $powerCfgSettingIndex `
        -PowerSchemeNameOrGuid $PowerSchemeNameOrGuid
}

function Set-MaximumProcessState {
    Param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [ValidateRange(0, 100)]
        [Int]
        $Percentage,

        [String]
        [ValidatePowerSchemeExists(AllowEmpty = $true)]
        $PowerSchemeNameOrGuid
    )

    $powerCfgSubGuid = $powerCfgAliases.SUB_PROCESSOR
    $powerCfgSettingGuid = $powerCfgAliases.SUB_PROCESSOR_PROCTHROTTLEMAX
    $powerCfgSettingIndex = $Percentage

    Set-AcDcValue `
        -PowerSource $PowerSource `
        -PowerCfgSubGuid $powerCfgSubGuid `
        -PowerCfgSettingGuid $powerCfgSettingGuid `
        -PowerCfgSettingIndex $powerCfgSettingIndex `
        -PowerSchemeNameOrGuid $PowerSchemeNameOrGuid
}

function Set-WhenSharingMedia {
    Param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [WhenSharingMediaTypes]
        $WhenSharingMedia,

        [String]
        [ValidatePowerSchemeExists(AllowEmpty = $true)]
        $PowerSchemeNameOrGuid
    )

    $powerCfgSubGuid = $powerCfgAliases.SUB_MULTIMEDIA
    $powerCfgSettingGuid = $powerCfgAliases.SUB_MULTIMEDIA_WHENSHARINGMEDIA
    $powerCfgSettingIndex = [int]([WhenSharingMediaTypes]::$WhenSharingMedia)

    Set-AcDcValue `
        -PowerSource $PowerSource `
        -PowerCfgSubGuid $powerCfgSubGuid `
        -PowerCfgSettingGuid $powerCfgSettingGuid `
        -PowerCfgSettingIndex $powerCfgSettingIndex `
        -PowerSchemeNameOrGuid $PowerSchemeNameOrGuid
}

function Set-VideoPlaybackQualityBias {
    Param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [VideoPlaybackQualityBiasTypes]
        $VideoPlaybackQualityBias,

        [String]
        [ValidatePowerSchemeExists(AllowEmpty = $true)]
        $PowerSchemeNameOrGuid
    )

    $powerCfgSubGuid = $powerCfgAliases.SUB_MULTIMEDIA
    $powerCfgSettingGuid = $powerCfgAliases.SUB_MULTIMEDIA_PLAYBACKQUALBIAS
    $powerCfgSettingIndex = [int]([VideoPlaybackQualityBiasTypes]::$VideoPlaybackQualityBias)

    Set-AcDcValue `
        -PowerSource $PowerSource `
        -PowerCfgSubGuid $powerCfgSubGuid `
        -PowerCfgSettingGuid $powerCfgSettingGuid `
        -PowerCfgSettingIndex $powerCfgSettingIndex `
        -PowerSchemeNameOrGuid $PowerSchemeNameOrGuid
}

function Set-WhenPlayingVideo {
    Param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [WhenPlayingVideoTypes]
        $WhenPlayingVideo,

        [String]
        [ValidatePowerSchemeExists(AllowEmpty = $true)]
        $PowerSchemeNameOrGuid
    )

    $powerCfgSubGuid = $powerCfgAliases.SUB_MULTIMEDIA
    $powerCfgSettingGuid = $powerCfgAliases.SUB_MULTIMEDIA_WHENPLAYINGVIDEO
    $powerCfgSettingIndex = [int]([WhenPlayingVideoTypes]::$WhenPlayingVideo)

    Set-AcDcValue `
        -PowerSource $PowerSource `
        -PowerCfgSubGuid $powerCfgSubGuid `
        -PowerCfgSettingGuid $powerCfgSettingGuid `
        -PowerCfgSettingIndex $powerCfgSettingIndex `
        -PowerSchemeNameOrGuid $PowerSchemeNameOrGuid
}
