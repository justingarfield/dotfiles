# Control Panel -> Power Options -> Change plan settings -> Change advanced power settings



## Advanced settings dialog

### Hard disk -> Turn off hard disk after
Set-TurnOffHDDAfter -PowerSource PluggedIn -Minutes 20

### Internet Explorer -> JavaScript Timer Frequency
# Note: This is no longer used since IE is finally burning in Hell, feel free to not bother.
Set-JavaScriptTimerFrequency -PowerSource PluggedIn -JavaScriptTimerFrequency MaximumPerformance

### Desktop background settings -> Slide show
Set-DesktopBackgroundSettings -PowerSource PluggedIn -SlideShowSetting Paused

### Wireless Adapter Settings -> Power Saving Mode
Set-WirelessAdapterPowerSavingMode -PowerSource PluggedIn -PowerSavingMode MaximumPerformance

### Sleep -> Sleep after
# Note: I'm personally setting this under the "new" Power Settings section in the Win11 Settings window
# Set-SleepAfter -PowerSource PluggedIn -Minutes 0

### Sleep -> Hibernate after
Set-HibernateAfter -PowerSource PluggedIn -Minutes 0

### Sleep -> Allow Wake Timers
Set-AllowWakeTimers -PowerSource PluggedIn -WakeTimer Enable

### USB settings -> USB selective suspend setting
Set-UsbSelectiveSuspend -PowerSource PluggedIn -Enabled $true

### PCI Express -> Link State Power Management
Set-LinkStatePowerManagement -PowerSource PluggedIn -LinkStatePowerManagement ModeratePowerSavings

### Processor power management -> Minimum processor state
Set-MinimumProcessState -PowerSource PluggedIn -Percentage 5

### Processor power management -> Maximum processor state
Set-MaximumProcessState -PowerSource PluggedIn -Percentage 100

# Display -> Turn off display after
# Note: I'm personally setting this under the "new" Power Settings section in the Win11 Settings window
# Set-TurnOffDisplayAfter -PowerSource PluggedIn -Minutes 3

### Multimedia settings -> When sharing media
Set-WhenSharingMedia -PowerSource PluggedIn -WhenSharingMedia PreventIdlingToSleep

### Multimedia settings -> Video playback quality bias
Set-VideoPlaybackQualityBias -PowerSource PluggedIn -VideoPlaybackQualityBias VideoPlaybackPerformanceBias

### Multimedia settings -> When playing video
Set-WhenPlayingVideo -PowerSource PluggedIn -WhenPlayingVideo OptimizeVideoQuality
