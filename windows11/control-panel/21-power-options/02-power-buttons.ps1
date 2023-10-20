# Control Panel -> Power Options -> Choose what the power buttons do


# Set-PowerButtonSetting -PowerSource PluggedIn -PowerOption Hibernate
# Set-SleepButtonSetting -PowerSource PluggedIn -PowerOption Hibernate

## Turn on fast startup (recommended) - This helps start your PC faster after shutdown. Restart isn't affected.
Set-FastStartup -Enabled $false

## Sleep - Show in Power menu
Set-ShowSleepInPowerMenu -Enabled $false

## Hibernate - Show in Power menu
Set-ShowHibernateInPowerMenu -Enabled $false

## Lock - Show in account picture menu
Set-ShowShutdownOptionsOnLockScreen -Enabled $false
