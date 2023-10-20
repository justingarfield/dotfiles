# See: https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/configure-power-settings

# Source the required functions and helpers
. .\JavaScriptTimerFrequencyTypes.ps1
. .\PowerModeTypes.ps1
. .\PowerOptionDurationTypes.ps1
. .\PowerOptionTypes.ps1
. .\PowerSourceTypes.ps1
. .\SlideShowSettingTypes.ps1
. .\ValidatePowerSchemeExistsAttribute.ps1

$powerCfgAliases = @{
    SUB_DISK = "0012ee47-9041-4b5d-9b77-535fba8b1442"
    SUB_DISK_DISKIDLE = "6738e2c4-e8a5-4a42-b16a-e040e769756e"
    SUB_CUSTOM_INTERNET_EXPLORER = "02f815b5-a5cf-4c84-bf20-649d1f75d3d8"
    SUB_CUSTOM_INTERNET_EXPLORER_JS_TIMER_FREQ = "4c793e7d-a264-42e1-87d3-7a0d2f523ccd"
    SUB_CUSTOM_DESKTOP_BACKGROUND = "0d7dbae2-4294-402a-ba8e-26777e8488cd"
    SUB_CUSTOM_DESKTOP_BACKGROUND_SLIDE_SHOW = "309dce9b-bef4-4119-9921-a851fb12f0f4"
    SUB_BUTTONS = "4f971e89-eebd-4455-a8de-9e59040e7347"
    SUB_BUTTONS_UIBUTTON_ACTION = "a7066653-8d6c-40a8-910e-a1f54b84c7e5"
    SUB_BUTTONS_CUSTOM_POWER_BUTTON = "7648efa3-dd9c-4e3e-b566-50f929386280"
    SUB_BUTTONS_CUSTOM_SLEEP_BUTTON = "96996bc0-ad50-47ec-923b-6f41874dd9eb"
}

$powerCfgExe = Join-Path -Path $Env:windir -ChildPath "System32\powercfg.exe"

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

function Set-AcDcValue {
    Param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [String]
        $PowerCfgSubGuid,

        [Parameter(Mandatory=$true)]
        [String]
        $PowerCfgSettingGuid,

        [Parameter(Mandatory=$true)]
        [Int]
        $PowerCfgSettingIndex,

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

    Write-Host "$powerCfgExe $powerCfgValueIndex $powerCfgSchemeGuid $PowerCfgSubGuid $PowerCfgSettingGuid $PowerCfgSettingIndex"
    cmd /c "$powerCfgExe $powerCfgValueIndex $powerCfgSchemeGuid $PowerCfgSubGuid $PowerCfgSettingGuid $PowerCfgSettingIndex"
    cmd /c "$powerCfgExe /SETACTIVE $powerCfgSchemeGuid" # Control Panel calls this on Save, but not sure if it actually does anything?
}

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

}

function Set-ShowSleepInPowerMenu {

}

function Set-ShowHibernateInPowerMenu {

}

function Set-ShowShutdownOptionsOnLockScreen {

}

# Advanced Power Settings

function Set-TurnOffHDDAfter {
    Param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [ValidateRange(0, 71582788)]
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
