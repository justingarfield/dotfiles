# See: https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/configure-power-settings

. .\settings\01-system\05-power\PowerModeTypes.ps1
. .\settings\01-system\05-power\PowerOptionDurationTypes.ps1
. .\settings\01-system\05-power\PowerOptionTypes.ps1
. .\settings\01-system\05-power\PowerSourceTypes.ps1

$autoProvisionedSchemeName = "WindowsDotFiles"
$autoProvisionedSchemeDescription = "WindowsDotFiles"
$powerSchemeToDuplicateName = "Balanced"
$powerCfgAliases = @{
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

class ValidatePowerSchemeExistsAttribute : System.Management.Automation.ValidateArgumentsAttribute {
    
    [bool]
    $AllowEmpty = $false

    [void]
    Validate(
        [object] $arguments,
        [System.Management.Automation.EngineIntrinsics] $engineIntrinsics
    )
    {
        $nameOrGuid = $arguments

        if ($this.AllowEmpty -and [string]::IsNullOrEmpty($nameOrGuid)) {
            return
        }

        $foundMatch = $false
        if ($nameOrGuid -match "[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}") {
            $foundMatch = Get-PowerSchemes | Where-Object { $_.Guid -eq $nameOrGuid }
        } else {
            $foundMatch = Get-PowerSchemes | Where-Object { $_.Name -eq $nameOrGuid }
        }

        if (!$foundMatch) {
            Throw "Power Scheme Name or Guid of '$nameOrGuid' not found."
        }
    }
}

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

    <#
        TODO: Not sure how to suppress output when called via UNC path, e.g.:

        '\\wsl.localhost\Ubuntu\home\jgarfield\src\justingarfield\dotfiles\windows11'
        CMD.EXE was started with the above path as the current directory.
        UNC paths are not supported.  Defaulting to Windows directory.
    #>
    cmd /c "$powerCfgExe /CHANGENAME $($powerSchemeToModify.Guid) $Name $Description"
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
    if ($PowerSchemeNameOrGuid) {

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

    <#
        TODO: Not sure how to suppress output when called via UNC path, e.g.:

        '\\wsl.localhost\Ubuntu\home\jgarfield\src\justingarfield\dotfiles\windows11'
        CMD.EXE was started with the above path as the current directory.
        UNC paths are not supported.  Defaulting to Windows directory.
    #>
    Write-Host "$powerCfgExe $powerCfgValueIndex $powerCfgSchemeGuid $powerCfgSubGuid $powerCfgSettingGuid $powerCfgSettingIndex"
    cmd /c "$powerCfgExe $powerCfgValueIndex $powerCfgSchemeGuid $powerCfgSubGuid $powerCfgSettingGuid $powerCfgSettingIndex"
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
    if ($PowerSchemeNameOrGuid) {
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

    <#
        TODO: Not sure how to suppress output when called via UNC path, e.g.:

        '\\wsl.localhost\Ubuntu\home\jgarfield\src\justingarfield\dotfiles\windows11'
        CMD.EXE was started with the above path as the current directory.
        UNC paths are not supported.  Defaulting to Windows directory.
    #>
    Write-Host "$powerCfgExe $powerCfgValueIndex $powerCfgSchemeGuid $powerCfgSubGuid $powerCfgSettingGuid $powerCfgSettingIndex"
    cmd /c "$powerCfgExe $powerCfgValueIndex $powerCfgSchemeGuid $powerCfgSubGuid $powerCfgSettingGuid $powerCfgSettingIndex"
}

$autoProvisionedScheme = Get-PowerSchemes | Where-Object { $_.Name -eq $autoProvisionedSchemeName }
if ($autoProvisionedScheme) {
    Write-Host "Found existing Power Scheme named '$autoProvisionedSchemeName'."
} else {
    Write-Host "Could not find Auto-Provisioned Power Scheme named '$autoProvisionedSchemeName'. Duplicating..."
    $autoProvisionedScheme = DuplicatePowerScheme -NameOrGuid $powerSchemeToDuplicateName
    Set-PowerSchemeNameAndDescription -NameOrGuid $autoProvisionedScheme.Guid -Name $autoProvisionedSchemeName -Description $autoProvisionedSchemeDescription
}

Set-PowerButtonSetting -PowerSource PluggedIn -PowerOption DoNothing -PowerSchemeNameOrGuid $autoProvisionedScheme.Guid
Set-SleepButtonSetting -PowerSource PluggedIn -PowerOption DoNothing -PowerSchemeNameOrGuid $autoProvisionedScheme.Guid


<#
function Set-TurnOffScreenAfter {
    param(
        [Parameter(Mandatory=$true)]
        [PowerOptionDurationTypes]
        $PowerOptionDurationType
    )

    $powerOptionDurationTypeValue = [int]([PowerOptionDurationTypes]::$PowerOptionDurationType)

    $regKey = "SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes\381b4222-f694-41f0-9685-ff5bb260df2e\7516b95f-f776-4464-8c53-06167f40cc99\3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e"
    do {} until (Enable-Privilege SeTakeOwnershipPrivilege)
    $key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($regKey, 'ReadWriteSubTree', 'ChangePermissions')
    $acl = $key.GetAccessControl()

    $domain = $Env:USERDOMAIN
    $computerName = $Env:COMPUTERNAME
    if ($domain -eq $computerName) {
        $administratorsGroup = Get-LocalGroup -Name "Administrators"
        $rule = New-Object System.Security.AccessControl.RegistryAccessRule($administratorsGroup, "FullControl","Allow")
        $rule | Format-List
        $acl.SetAccessRule($rule)
    } else {
        $rule = New-Object System.Security.AccessControl.RegistryAccessRule("$domain\\Domain Admins","FullControl","Allow")
        $rule | Format-List
        $acl.SetAccessRule($rule)
    }
    
    $key.SetAccessControl($acl)

    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Power\User\PowerSchemes\381b4222-f694-41f0-9685-ff5bb260df2e\7516b95f-f776-4464-8c53-06167f40cc99\3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e" -Name "ACSettingIndex" -Value $powerOptionDurationTypeValue
}

function Set-PutDeviceToSleepAfter {
    param(
        [Parameter(Mandatory=$true)]
        [PowerOptionDurationTypes]
        $PowerOptionDurationType
    )

    $powerOptionDurationTypeValue = [int]([PowerOptionDurationTypes]::$PowerOptionDurationType)

    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Power\User\PowerSchemes\381b4222-f694-41f0-9685-ff5bb260df2e\238c9fa8-0aad-41ed-83f4-97be242c8f20\29f6c1db-86da-48c5-9fdb-f2b67b1f44da" -Name "ACSettingIndex" -Value $powerOptionDurationTypeValue
}

function Set-PowerMode {
    param(
        [Parameter(Mandatory=$true)]
        [PowerModeTypes]
        $PowerModeType
    )

    $powerModeTypeValue = "00000000-0000-0000-0000-000000000000" # Balanced
    switch ($PowerModeType) {
        BestPowerEfficiency { $powerModeTypeValue = "961cc777-2547-4f9d-8174-7d86181b8a7a" }
        Balanced { break }
        BestPerformance { $powerModeTypeValue = "ded574b5-45a0-4f42-8737-46345c09c238" }
    }

    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Power\User\PowerSchemes" -Name "ActiveOverlayAcPowerScheme" -Value $powerModeTypeValue
}
#>
