# Settings -> Accessibility -> Audio

# Source the required functions and helpers
. .\Audio.ps1

## "Mono audio"
# Note: If you turn on mono audio, it will disable the spatial sound setting.
Set-MonoAudio -Enabled $false

## "Flash my screen during audio notifications" - Options: Never, FlashTitleBar, FlashActiveWindow, FlashEntireScreen
Set-ScreenFlashAudioNotifications -AudioNotificationScreenFlashType Never
