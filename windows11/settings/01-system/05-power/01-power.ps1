# Settings -> System -> Power

# Source the required functions and helpers
. .\Power.ps1

## When plugged in, turn off my screen after
Set-TurnOffScreenAfter -PowerOptionDurationType FiveMinutes

## When plugged in, put my device to sleep after
# Set-PutDeviceToSleepAfter -PowerOptionDurationType Never

## Power mode
# Set-PowerMode -Enabled $true
