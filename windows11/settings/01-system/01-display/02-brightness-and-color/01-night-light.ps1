# Settings -> System -> Display -> Night light

# Source the required functions and helpers
. .\NightLight.ps1

# Note: Night light isn't available if your device uses certain drivers (DisplayLink or Basic Display).
# Note: The Night Light feature requires the Connected Devices Platform Service to be enabled, running, and set to automatic.
Set-NightLight -Enabled $true

## Strength
Set-NightLightStrength -Value 50

## Schedule night light
