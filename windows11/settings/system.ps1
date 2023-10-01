# Settings -> System


# Set Computer Name
(Get-WmiObject Win32_ComputerSystem).Rename("CHOZO") | Out-Null
