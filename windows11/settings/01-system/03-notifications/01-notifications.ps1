# Settings -> System -> Notifications

# Source the required functions and helpers
. .\Notifications.ps1

## Notifications

# Probably going to need to dig into...
# C:\Windows\System32\SettingsHandlers_Notifications.dll 
#    and/or 
# C:\Windows\System32\NotificationController.dll

## Do not disturb

## Turn on do not disturb automatically

## Set priority notifications

## Focus
# Note: This is now just a shortcut to Settings -> System -> Focus

## Notifications from apps and other senders

## Additional settings

### Show the Windows welcome experience after updates and when signed in to show what's new and suggested
Set-ShowWelcomeExperienceAfterUpdates -Enabled $false

### Get tips and suggestions when using Windows
Set-GetTipsAndSuggestions -Enabled $false
