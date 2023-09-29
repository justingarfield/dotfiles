# Set to empty string if using MS Account and not a Local User
$localUserFullName = "Justin Garfield"

Write-Host "Configuring System..." -ForegroundColor "Yellow"

## Set DisplayName for my account. Use only if you are not using a Microsoft Account
if ($localUserFullName) {
    $myIdentity=[System.Security.Principal.WindowsIdentity]::GetCurrent()
    $user = Get-WmiObject Win32_UserAccount | Where-Object {$_.Caption -eq $myIdentity.Name}
    $user.FullName = $localUserFullName
    $user.Put() | Out-Null
    Remove-Variable user
    Remove-Variable myIdentity
}
