# Settings -> System -> Power

# Important Note: Please see windows11\control-panel-21-power-options for more Power-related settings. At the time of 
#                 this writing, the Windows Team has barely migrated a majority of settings to the new Settings window.

# Source the required functions and helpers
. .\Power.ps1

## When plugged in, turn off my screen after
Set-TurnOffScreenAfter -PowerSource PluggedIn -PowerOptionDuration ThreeMinutes

## When plugged in, put my device to sleep after
Set-PutDeviceToSleepAfter -PowerSource PluggedIn -PowerOptionDuration Never

## Power mode
# Note: I have no fuggin' idea what this is really doing atm...Gets disabled if "Balanced Power Scheme" isn't selected in background
# Set-PowerMode -Enabled $true
