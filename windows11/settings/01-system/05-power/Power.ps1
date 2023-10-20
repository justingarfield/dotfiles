# See: https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/configure-power-settings

# Source the required functions and helpers
. .\JavaScriptTimerFrequencyTypes.ps1
. .\LinkStatePowerManagementTypes.ps1
. .\PowerModeTypes.ps1
. .\PowerOptionDurationTypes.ps1
. .\PowerOptionTypes.ps1
. .\PowerSavingModeTypes.ps1
. .\PowerSourceTypes.ps1
. .\SlideShowSettingTypes.ps1
. .\ValidatePowerSchemeExistsAttribute.ps1
. .\VideoPlaybackQualityBiasTypes.ps1
. .\WakeTimerTypes.ps1
. .\WhenPlayingVideoTypes.ps1
. .\WhenSharingMediaTypes.ps1

<#
These are "Well-known GUIDs and SUB_GUIDs" dervied from "powercfg.exe /QUERY"

Note: Some systems may have more/less depending on hardware capabilities, laptop vs. desktop, etc. If you need to set
      a value that isn't here, either fork this repo and add your own to the list (then please open a PR); or you can
      call the less-friendly "Set-AcDcValue" function directly with the GUID / SUB_GUID required for your use-case.
#>
$powerCfgAliases = @{
    SUB_DISK = "0012ee47-9041-4b5d-9b77-535fba8b1442"                                   # Hard disk
    SUB_DISK_DISKIDLE = "6738e2c4-e8a5-4a42-b16a-e040e769756e"                          #   Turn off hard disk after
    SUB_CUSTOM_INTERNET_EXPLORER = "02f815b5-a5cf-4c84-bf20-649d1f75d3d8"               # Internet Explorer
    SUB_CUSTOM_INTERNET_EXPLORER_JS_TIMER_FREQ = "4c793e7d-a264-42e1-87d3-7a0d2f523ccd" #   JavaScript Timer Frequency
    SUB_CUSTOM_DESKTOP_BACKGROUND = "0d7dbae2-4294-402a-ba8e-26777e8488cd"              # Desktop background settings
    SUB_CUSTOM_DESKTOP_BACKGROUND_SLIDE_SHOW = "309dce9b-bef4-4119-9921-a851fb12f0f4"   #   Slide show
    SUB_CUSTOM_WIRELESS_ADAPTER = "19cbb8fa-5279-450e-9fac-8a3d5fedd0c1"                # Wireless Adapter Settings
    SUB_CUSTOM_WIRELESS_ADAPTER_POWER_SAVING = "12bbebe6-58d6-4636-95bb-3217ef867c1a"   #   Power Saving Mode
    SUB_SLEEP = "238c9fa8-0aad-41ed-83f4-97be242c8f20"                                  # Sleep
    SUB_SLEEP_STANDBYIDLE = "29f6c1db-86da-48c5-9fdb-f2b67b1f44da"                      #   Sleep after
    SUB_SLEEP_HYBRIDSLEEP = "94ac6d29-73ce-41a6-809f-6363ba21b47e"                      #   Allow hybrid sleep
    SUB_SLEEP_HIBERNATEIDLE = "9d7815a6-7ee4-497e-8888-515a05f02364"                    #   Hibernate after
    SUB_SLEEP_RTCWAKE = "bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d"                          #   Allow Wake Timers
    SUB_CUSTOM_USB = "2a737441-1930-4402-8d77-b2bebba308a3"                             # USB settings
    SUB_CUSTOM_USB_SELECTIVE_SUSPEND = "48e6b7a6-50f5-4782-a5d4-53bb8f07e226"           #   USB selective suspend setting
    SUB_BUTTONS = "4f971e89-eebd-4455-a8de-9e59040e7347"                                # Power buttons and lid
    SUB_BUTTONS_UIBUTTON_ACTION = "a7066653-8d6c-40a8-910e-a1f54b84c7e5"                #   Start menu power button (not sure if this does anything - need to test more)
    SUB_BUTTONS_CUSTOM_POWER_BUTTON = "7648efa3-dd9c-4e3e-b566-50f929386280"            #   not sure if this does anything - need to test more
    SUB_BUTTONS_CUSTOM_SLEEP_BUTTON = "96996bc0-ad50-47ec-923b-6f41874dd9eb"            #   not sure if this does anything - need to test more
    SUB_PCIEXPRESS = "501a4d13-42af-4429-9fd1-a8218c268e20"                             # PCI Express
    SUB_PCIEXPRESS_ASPM = "ee12f906-d277-404b-b6da-e5fa1a576df5"                        #   Link State Power Management
    SUB_PROCESSOR = "54533251-82be-4824-96c1-47b60b740d00"                              # Processor power management
    SUB_PROCESSOR_PROCTHROTTLEMIN = "893dee8e-2bef-41e0-89c6-b55d0929964c"              #   Minimum processor state
    SUB_PROCESSOR_PROCTHROTTLEMAX = "bc5038f7-23e0-4960-96da-33abaf5935ec"              #   Maximum processor state
    SUB_VIDEO = "7516b95f-f776-4464-8c53-06167f40cc99"                                  # Display
    SUB_VIDEO_VIDEOIDLE = "3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e"                        #   Turn off display after
    SUB_VIDEO_VIDEONORMALLEVEL = "aded5e82-b909-4619-9949-f5d71dac0bcb"                 #   Display brightness
    SUB_VIDEO_CUSTOM_DIMMED_BRIGHTNESS = "f1fbfde2-a960-4165-9f88-50667911ce96"         #   Dimmed display brightness
    SUB_VIDEO_ADAPTBRIGHT = "fbd9aa66-9553-4097-ba44-ed6e9d65eab8"                      #   Enable adaptive brightness
    SUB_MULTIMEDIA = "9596fb26-9850-41fd-ac3e-f7c3c00afd4b"                             # Multimedia settings
    SUB_MULTIMEDIA_WHENSHARINGMEDIA = "03680956-93bc-4294-bba6-4e0f09bb717f"            #   When sharing media
    SUB_MULTIMEDIA_PLAYBACKQUALBIAS = "10778347-1370-4ee0-8bbd-33bdacaade49"            #   Video playback quality bias
    SUB_MULTIMEDIA_WHENPLAYINGVIDEO = "34c7b99f-9a6d-4b3c-8dc7-b6693b78cef4"            #   When playing video
    
    # These will only show in UI / function on systems with Batteries (or UPS data links)
    SUB_BATTERY = "e73a048d-bf27-4f12-9731-8b2076e8891f"                                # Battery
    SUB_BATTERY_BATFLAGSCRIT = "5dbb7c9f-38e9-40d2-9749-4f8a0e9f640f"                   #   Critical battery notification
    SUB_BATTERY_BATACTIONCRIT = "637ea02f-bbcb-4015-8e2c-a1c7b9c0b546"                  #   Critical battery action
    SUB_BATTERY_BATLEVELLOW = "8183ba9a-e910-48da-8769-14ae6dc1170a"                    #   Low battery level
    SUB_BATTERY_BATLEVELCRIT = "9a66d8d7-4ff7-4ef9-b5a2-5a326ca2a469"                   #   Critical battery level
    SUB_BATTERY_BATFLAGSLOW = "bcded951-187b-4d05-bccc-f7e51960c258"                    #   Low battery notification
    SUB_BATTERY_BATACTIONLOW = "d8742dcb-3e6a-4b3c-b3fe-374623cdcf06"                   #   Low battery action
    SUB_BATTERY_CUSTOM_RESERVELEVEL = "f3c5027d-cd16-4930-aa6b-90db844a8f00"            #   Reserve battery level
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

function Set-SleepAfter {
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
    $powerCfgSettingGuid = $powerCfgAliases.SUB_SLEEP_STANDBYIDLE
    $powerCfgSettingIndex = $Minutes * 60 # Control Panel has user specify Minutes, but stores value as seconds

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

function Set-TurnOffDisplayAfter {
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

    $powerCfgSubGuid = $powerCfgAliases.SUB_VIDEO
    $powerCfgSettingGuid = $powerCfgAliases.SUB_VIDEO_VIDEOIDLE
    $powerCfgSettingIndex = $Minutes * 60 # Control Panel has user specify Minutes, but stores value as seconds

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
    $powerCfgSettingGuid = $powerCfgAliases.SUB_VIDEOSUB_MULTIMEDIA_PLAYBACKQUALBIAS_VIDEOIDLE
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
