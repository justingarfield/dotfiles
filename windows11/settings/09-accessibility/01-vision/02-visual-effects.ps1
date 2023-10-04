# Settings -> Accessibility -> Visual effects

# Source the required functions and helpers
. .\VisualEffects.ps1

## Always show scrollbars - Enable: 0, Disable: 1
Set-ItemProperty "HKCU:\Control Panel\Accessibility" "DynamicScrollbars" 1

## Transparency effects - Enable: 1, Disable: 0
# Note: If you turn on high contrast, it will disable transparency effects.
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "EnableTransparency" 1

## Animation effects
# TODO: https://www.elevenforum.com/t/turn-on-or-off-animation-effects-in-windows-11.1461/

## Dismiss notifications after this amount of time
Set-ItemProperty "HKCU:\Control Panel\Accessibility" "MessageDuration" 5
