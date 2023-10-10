# Settings -> System -> Display

# Source the required functions and helpers
. .\MultipleDisplays.ps1

## Extend / Duplicate these displays (Device specific)
# Need to implement

## Make this my main display (Device specific)
# Need to implement

## Remember window locations based on monitor connection (Requires Sign-out or Reboot to take affect)
Set-RememberWindowLocations -Enabled $true

## Minimize windows when a monitor is disconnected (Requires Sign-out or Reboot to take affect)
Set-MinimizeWindowsOnDisconnect -Enabled $true

## Ease cursor movement between displays (Requires Sign-out or Reboot to take affect)
Set-EaseCursorMovement -Enabled $true
