# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
  $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
  $newProcess.Arguments = $myInvocation.MyCommand.Definition;
  $newProcess.Verb = "runas";
  [System.Diagnostics.Process]::Start($newProcess);

  exit
}

Push-Location (Split-Path -parent "fresh-install")
$strarry = @("security-and-identity","wsl","privacy","devices-power-startup","explorer-taskbar-systray","default-apps")
$strarry | Where-Object {Test-Path "$_.ps1"} | ForEach-Object -process {Invoke-Expression ". .\$_.ps1"}
Pop-Location
