# Settings -> System -> Display

## Multiple displays

### Extend / Duplicate these displays (Device specific)

### Make this my main display (Device specific)

### Remember window locations based on monitor connection - Enable: 0, Disable: 1 (Requires Sign-out or Reboot to take affect)
Set-ItemProperty "HKCU:\Control Panel\Desktop" "RestorePreviousStateRecalcBehavior" 0

### Minimize windows when a monitor is disconnected - Enable: 0, Disable: 1 (Requires Sign-out or Reboot to take affect)
Set-ItemProperty "HKCU:\Control Panel\Desktop" "MonitorRemovalRecalcBehavior" 0

### Ease cursor movement between displays - Enable: 1, Disable: 0 (Requires Sign-out or Reboot to take affect)
Set-ItemProperty "HKCU:\Control Panel\Cursors" "CursorDeadzoneJumpingSetting" 1

## Night light

## HDR (Device specific)

## Scale (Device specific)

## Display resolution (Device specific)

## Display orientation (Device specific)

## Advanced Display (Device specific)
# Not going to support this

## Graphics (Device specific)
# Not going to support this

### Default graphics settings

#### Hardware-accelerated GPU scheduling (Device specific) - Enable: 2, Disable: 1 (Requires Reboot to take affect)
# Note: Hardware-accelerated GPU scheduling requires a GPU that supports hardware acceleration, combined with a graphics driver that supports WDDM 2.7 or higher.
# Note: Personally sticking with OOTB defaults since each device is different
# Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDriver" "HwSchMode" 2

#### Variable refresh rate (Device specific)
# Note: Personally sticking with OOTB defaults since each device is different
# Need to change 'VRROptimizeEnable' in string - Enable: 1, Disable: 0
# Set-ItemProperty "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences" "DirectXUserGlobalSettings" 

#### Optimizations for windowed games (Device specific)
# Note: Personally sticking with OOTB defaults since each device is different
# Need to change 'SwapEffectUpgradeEnable' in string - Enable: 1, Disable: 0
# Set-ItemProperty "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences" "DirectXUserGlobalSettings" 
