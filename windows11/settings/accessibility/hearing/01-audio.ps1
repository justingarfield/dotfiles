# Settings -> Accessibility -> Audio

# Source the required Audio functions and helpers
. .\Audio.ps1

## "Mono audio" - Enable: 1, Disable: 0
# Note: If you turn on mono audio, it will disable the spatial sound setting.
Set-MonoAudio -Enabled $false

## "Flash my screen during audio notifications" - Never: 0, Flash title bar of the active window: 1, Flash the active window: 2, Flash the entire screen: 3
# Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\SoundSentry" -Name "Flags" -Value 3
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\SoundSentry" -Name "WindowsEffect" -Value 0
