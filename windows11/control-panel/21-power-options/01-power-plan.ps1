# Control Panel -> Power Options

# Source the required functions and helpers
. .\Power.ps1

$autoProvisionedSchemeName = "WindowsDotFiles"
$autoProvisionedSchemeDescription = "WindowsDotFiles"
$powerSchemeToDuplicateName = "Balanced"

<#
$autoProvisionedScheme = Get-PowerSchemes | Where-Object { $_.Name -eq $autoProvisionedSchemeName }
if ($autoProvisionedScheme) {
    Write-Host "Found existing Power Scheme named '$autoProvisionedSchemeName'."
} else {
    Write-Host "Could not find Auto-Provisioned Power Scheme named '$autoProvisionedSchemeName'. Duplicating..."
    $autoProvisionedScheme = Copy-PowerScheme -NameOrGuid $powerSchemeToDuplicateName
    Set-PowerSchemeNameAndDescription -NameOrGuid $autoProvisionedScheme.Guid -Name $autoProvisionedSchemeName -Description $autoProvisionedSchemeDescription
}
#>
