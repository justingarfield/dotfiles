function CreateRegistryKeyIfMissing {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateScript(
            { $_.StartsWith("HKEY_CURRENT_USER\") -or $_.StartsWith("HKCU:\") },
            ErrorMessage = "Value {0} must start with 'HKEY_CURRENT_USER\' or 'HKCU:\'."
        )]
        [string]
        $RegistryKey
    )

    # Make everything work via HKCU:
    $RegistryKey = $RegistryKey.Replace("HKEY_CURRENT_USER", "HKCU:")

    try{  
        Get-Item -Path $RegistryKey -ErrorAction Stop | Out-Null
        # Write-Host "Registry Key already exists: $RegistryKey"
    }  
    catch [System.Management.Automation.ItemNotFoundException] {  
        Write-Host "Creating missing Registry Key: $RegistryKey"
        
        # -Force builds the full structure-out so we don't have to recursively do it
        New-Item -Path $RegistryKey -Force
    }
}

<#
# "VRROptimizeEnable=1;SwapEffectUpgradeEnable=0;"
function Update-MultiKey-Registry-Entry {
    param (
        [string]$Path,
        [string]$PropertyName,
        [string]$TargetKey,
        [string]$NewValue
    )

    if (!(Test-Path -Path $Path)) {
        Write-Log -Message $newLineOutput -Level Error
        Write-Error "Path '$Path' does not exist in Registry."
    }

    if (!(Get-ItemProperty -Path $Path -Name $PropertyName)) {
        Write-Error "PropertyName '$PropertyName' does not exist in Registry at path '$Path'."
    }

    $originalPropertyValue = Get-ItemPropertyValue -Path $Path -Name $PropertyName
    # $originalPropertyValueParts = $originalPropertyValue.Split(';')
    
    $targetKeyIndex = $originalPropertyValue.IndexOf($TargetKey)
    $targetKeyValueEndIndex = $originalPropertyValue.IndexOf(';', $targetKeyIndex)

    $replaced = $originalPropertyValue.Replace("$TargetKey=")

    Write-Host "originalPropertyValue is: $originalPropertyValue"
    # Write-Host "originalPropertyValueParts is: $originalPropertyValueParts"
    Write-Host "targetKeyIndex is: $targetKeyIndex"
    Write-Host "targetKeyValueEndIndex is: $targetKeyValueEndIndex"
    Write-Host "replace is: $replaced"
}
#>
