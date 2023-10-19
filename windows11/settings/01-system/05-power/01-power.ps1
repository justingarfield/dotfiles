# Settings -> System -> Power

# Source the required functions and helpers
. .\Power.ps1

## When plugged in, turn off my screen after
Set-TurnOffScreenAfter -PowerOptionDurationType FiveMinutes

## When plugged in, put my device to sleep after
# Set-PutDeviceToSleepAfter -PowerOptionDurationType Never

## Power mode
# Set-PowerMode -Enabled $true


### These are Control Panel side settings

Set-PowerButtonSetting -PowerSource PluggedIn -PowerOption DoNothing

Set-SleepButtonSetting -PowerSource PluggedIn -PowerOption DoNothing

Set-FastStartup

Set-ShowSleepInPowerMenu

Set-ShowHibernateInPowerMenu

Set-ShowShutdownOptionsOnLockScreen
