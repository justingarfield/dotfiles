# Settings -> System -> Power

# Source the required functions and helpers
. .\Power.ps1

## When plugged in, turn off my screen after
# Set-TurnOffScreenAfter -PowerOptionDurationType FiveMinutes

## When plugged in, put my device to sleep after
# Set-PutDeviceToSleepAfter -PowerOptionDurationType Never

## Power mode
# Set-PowerMode -Enabled $true

### These are Control Panel-side settings

# Set-PowerButtonSetting -PowerSource PluggedIn -PowerOption DoNothing -PowerSchemeNameOrGuid $autoProvisionedScheme.Guid
# Set-SleepButtonSetting -PowerSource PluggedIn -PowerOption DoNothing -PowerSchemeNameOrGuid $autoProvisionedScheme.Guid
# Set-FastStartup
# Set-ShowSleepInPowerMenu
# Set-ShowHibernateInPowerMenu
# Set-ShowShutdownOptionsOnLockScreen

$autoProvisionedSchemeName = "WindowsDotFiles"
$autoProvisionedSchemeDescription = "WindowsDotFiles"
$powerSchemeToDuplicateName = "Balanced"

<#
$autoProvisionedScheme = Get-PowerSchemes | Where-Object { $_.Name -eq $autoProvisionedSchemeName }
if ($autoProvisionedScheme) {
    Write-Host "Found existing Power Scheme named '$autoProvisionedSchemeName'."
} else {
    Write-Host "Could not find Auto-Provisioned Power Scheme named '$autoProvisionedSchemeName'. Duplicating..."
    $autoProvisionedScheme = DuplicatePowerScheme -NameOrGuid $powerSchemeToDuplicateName
    Set-PowerSchemeNameAndDescription -NameOrGuid $autoProvisionedScheme.Guid -Name $autoProvisionedSchemeName -Description $autoProvisionedSchemeDescription
}
#>

# Set-PowerButtonSetting -PowerSource PluggedIn -PowerOption Hibernate
# Set-SleepButtonSetting -PowerSource PluggedIn -PowerOption DoNothing

Set-TurnOffHDDAfter -PowerSource PluggedIn -Minutes 20

Set-JavaScriptTimerFrequency -PowerSource PluggedIn -JavaScriptTimerFrequency MaximumPerformance

Set-DesktopBackgroundSettings -PowerSource PluggedIn -SlideShowSetting Paused

Set-WirelessAdapterPowerSavingMode -PowerSource PluggedIn -PowerSavingMode MaximumPerformance

Set-SleepAfter -PowerSource PluggedIn -Minutes 0

Set-HibernateAfter -PowerSource PluggedIn -Minutes 0

Set-AllowWakeTimers -PowerSource PluggedIn -WakeTimer Enable

Set-UsbSelectiveSuspend -PowerSource PluggedIn -Enabled $true

Set-LinkStatePowerManagement -PowerSource PluggedIn -LinkStatePowerManagement ModeratePowerSavings

Set-MinimumProcessState -PowerSource PluggedIn -Percentage 5

Set-MaximumProcessState -PowerSource PluggedIn -Percentage 100

Set-TurnOffDisplayAfter -PowerSource PluggedIn -Minutes 3

Set-WhenSharingMedia -PowerSource PluggedIn -WhenSharingMedia PreventIdlingToSleep

Set-VideoPlaybackQualityBias -PowerSource PluggedIn -VideoPlaybackQualityBias VideoPlaybackPerformanceBias

Set-WhenPlayingVideo -PowerSource PluggedIn -WhenPlayingVideo OptimizeVideoQuality
