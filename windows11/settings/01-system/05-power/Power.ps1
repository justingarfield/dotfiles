# See: https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/configure-power-settings

# Source the required functions and helpers
. .\PowerModeTypes.ps1
. .\PowerOptionDurationTypes.ps1
. .\PowerOptionTypes.ps1
. .\PowerSourceTypes.ps1

$autoProvisionedSchemeName = "WindowsDotFiles"
$autoProvisionedSchemeDescription = "WindowsDotFiles"
$powerSchemeToDuplicateName = "Balanced"
$powerCfgAliases = @{
    SUB_BUTTONS = "4f971e89-eebd-4455-a8de-9e59040e7347"
    SUB_BUTTONS_UIBUTTON_ACTION = "a7066653-8d6c-40a8-910e-a1f54b84c7e5"
}

$powerCfgExe = Join-Path -Path $Env:windir -ChildPath "System32\powercfg.exe"

# Note: Cannot use [[:xdigit:]] with .NET RegEx Engine for hex value matching
$CONST_REGEX_GUID = "[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}"
$CONST_REGEX_POWERSCHEMENAME = ".+"
$CONST_REGEX_POWERSCHEME_GUID_AND_NAME = "($CONST_REGEX_GUID)\s+\(($CONST_REGEX_POWERSCHEMENAME)\)"

function Get-PowerSchemes {
    <#
        TODO: Not sure how to suppress output when called via UNC path, e.g.:

        '\\wsl.localhost\Ubuntu\home\jgarfield\src\justingarfield\dotfiles\windows11'
        CMD.EXE was started with the above path as the current directory.
        UNC paths are not supported.  Defaulting to Windows directory.
    #>
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
    <#
        TODO: Not sure how to suppress output when called via UNC path, e.g.:

        '\\wsl.localhost\Ubuntu\home\jgarfield\src\justingarfield\dotfiles\windows11'
        CMD.EXE was started with the above path as the current directory.
        UNC paths are not supported.  Defaulting to Windows directory.
    #>
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
        [String]
        $NameOrGuid
    )
    
    $powerSchemeToDuplicate = $null

    if ($NameOrGuid -match $CONST_REGEX_GUID) {
        $powerSchemeToDuplicate = Get-PowerSchemes | Where-Object { $_.Guid -eq $NameOrGuid }
    } else {
        $powerSchemeToDuplicate = Get-PowerSchemes | Where-Object { $_.Name -eq $NameOrGuid }
    }

    if ($powerSchemeToDuplicate) {
        <#
            TODO: Not sure how to suppress output when called via UNC path, e.g.:

            '\\wsl.localhost\Ubuntu\home\jgarfield\src\justingarfield\dotfiles\windows11'
            CMD.EXE was started with the above path as the current directory.
            UNC paths are not supported.  Defaulting to Windows directory.
        #>
        $duplicatePowerSchemeOutput = cmd /c "$powerCfgExe /DUPLICATESCHEME $($powerSchemeToDuplicate.Guid)"

        $duplicatePowerShemeMatch = $duplicatePowerSchemeOutput | Select-String -Pattern $CONST_REGEX_POWERSCHEME_GUID_AND_NAME
        $duplicatePowerSchemeGuid = $duplicatePowerShemeMatch.Matches[0].Groups[1].Value
        $duplicatePowerSchemeName = $duplicatePowerShemeMatch.Matches[0].Groups[2].Value
        
        return @{
            Guid = $duplicatePowerSchemeGuid
            Name = $duplicatePowerSchemeName
        }
    } else {
        Write-Warning "Could not find a Power Scheme Name or GUID of '$NameOrGuid' to duplicate."
    }
}

function Set-PowerSchemeNameAndDescription {
    param(
        [Parameter(Mandatory=$true)]
        [String]
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

    if ($powerSchemeToModify) {
        <#
            TODO: Not sure how to suppress output when called via UNC path, e.g.:

            '\\wsl.localhost\Ubuntu\home\jgarfield\src\justingarfield\dotfiles\windows11'
            CMD.EXE was started with the above path as the current directory.
            UNC paths are not supported.  Defaulting to Windows directory.
        #>
        cmd /c "$powerCfgExe /CHANGENAME $($powerSchemeToModify.Guid) $Name $Description"
    } else {
        Write-Warning "Could not find a Power Scheme Name or GUID of '$NameOrGuid' to modify."
    }
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
        $PowerSchemeNameOrGuid
    )

    $powerCfgValueIndex = $PowerSource -eq [PowerSourceTypes]::PluggedIn ? "/SETACVALUEINDEX" : "/SETDCVALUEINDEX"
    $powerCfgSchemeGuid = "SCHEME_CURRENT"
    $powerCfgSubGuid = ""
    $powerCfgSettingGuid = ""
    $powerCfgSettingIndex = [int]([PowerOptionTypes]::$PowerOption)

    <#
        TODO: Not sure how to suppress output when called via UNC path, e.g.:

        '\\wsl.localhost\Ubuntu\home\jgarfield\src\justingarfield\dotfiles\windows11'
        CMD.EXE was started with the above path as the current directory.
        UNC paths are not supported.  Defaulting to Windows directory.
    #>
    Write-Host "$powerCfgExe $powerCfgValueIndex $powerCfgSchemeGuid $powerCfgSubGuid $powerCfgSettingGuid $powerCfgSettingIndex"
    # cmd /c "$powerCfgExe $powerCfgValueIndex $powerCfgSchemeGuid $powerCfgSubGuid $powerCfgSettingGuid $powerCfgSettingIndex"
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
        $PowerSchemeNameOrGuid
    )
}

function Set-FastStartup {

}

function Set-ShowSleepInPowerMenu {

}

function Set-ShowHibernateInPowerMenu {

}

function Set-ShowShutdownOptionsOnLockScreen {

}
