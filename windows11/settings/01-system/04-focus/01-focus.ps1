# Settings -> System -> Focus

# Source the required functions and helpers
. .\Focus.ps1

## Session duration
# Note: This currently gets reset to 30-minutes every time you leave the settings page, so it's kind-of pointless to 
# consider it a 'setting' that you can set-in-stone. This "might" be helpful if there's a way to automate clicking 
# "Start focus session" though.
# Set-SessionDuration 30

## Show the timer in the clock app
Set-ShowTimerInTheClockApp -Enabled $true

## Hide badges on taskbar apps
Set-HideBadgesOnTaskbarApps -Enabled $true

## Hide flashing on taskbar apps
Set-HideFlashingOnTaskbarApps -Enabled $true

## Turn on do not disturb
Set-TurnOnDoNotDisturb -Enabled $true
