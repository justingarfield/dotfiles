function VM-EnableNestedVirtualization([Parameter(mandatory=$true)][String] $VMName) {
    Set-VMProcessor -VMName $VMName -ExposeVirtualizationExtensions $True
}

function ConvertTo-ByteArray-For-Registry {
    param (
        [string]
        $value
    )

    $commaSplitValues = $value.Split(',')
    $finalSplitValues = @()
    $commaSplitValues | ForEach-Object {
        $split = $_.Split(' ')
        if ($split) {
            $finalSplitValues += $_.Split(' ')
        } else {
            Write-Warning "Malformed input detected. Please check your input string."
            return
        }
    }

    $hexValues = $finalSplitValues.Split(',') | ForEach-Object { "0x$_"}
    return  ([byte[]]($hexValues))
}

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
