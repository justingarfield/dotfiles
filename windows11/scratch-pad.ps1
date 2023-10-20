####################################################
# Just some random crap I've been toying around with
####################################################

function Set-TurnOffScreenAfter {
    param(
        [Parameter(Mandatory=$true)]
        [PowerOptionDurationTypes]
        $PowerOptionDurationType
    )

    $powerOptionDurationTypeValue = [int]([PowerOptionDurationTypes]::$PowerOptionDurationType)

    $regKey = "SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes\381b4222-f694-41f0-9685-ff5bb260df2e\7516b95f-f776-4464-8c53-06167f40cc99\3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e"
    do {} until (Enable-Privilege SeTakeOwnershipPrivilege)
    $key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($regKey, 'ReadWriteSubTree', 'ChangePermissions')
    $acl = $key.GetAccessControl()

    $domain = $Env:USERDOMAIN
    $computerName = $Env:COMPUTERNAME
    if ($domain -eq $computerName) {
        $administratorsGroup = Get-LocalGroup -Name "Administrators"
        $rule = New-Object System.Security.AccessControl.RegistryAccessRule($administratorsGroup, "FullControl","Allow")
        $rule | Format-List
        $acl.SetAccessRule($rule)
    } else {
        $rule = New-Object System.Security.AccessControl.RegistryAccessRule("$domain\\Domain Admins","FullControl","Allow")
        $rule | Format-List
        $acl.SetAccessRule($rule)
    }
    
    $key.SetAccessControl($acl)

    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Power\User\PowerSchemes\381b4222-f694-41f0-9685-ff5bb260df2e\7516b95f-f776-4464-8c53-06167f40cc99\3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e" -Name "ACSettingIndex" -Value $powerOptionDurationTypeValue
}

function Set-PutDeviceToSleepAfter {
    param(
        [Parameter(Mandatory=$true)]
        [PowerOptionDurationTypes]
        $PowerOptionDurationType
    )

    $powerOptionDurationTypeValue = [int]([PowerOptionDurationTypes]::$PowerOptionDurationType)

    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Power\User\PowerSchemes\381b4222-f694-41f0-9685-ff5bb260df2e\238c9fa8-0aad-41ed-83f4-97be242c8f20\29f6c1db-86da-48c5-9fdb-f2b67b1f44da" -Name "ACSettingIndex" -Value $powerOptionDurationTypeValue
}

function Set-PowerMode {
    param(
        [Parameter(Mandatory=$true)]
        [PowerModeTypes]
        $PowerModeType
    )

    $powerModeTypeValue = "00000000-0000-0000-0000-000000000000" # Balanced
    switch ($PowerModeType) {
        BestPowerEfficiency { $powerModeTypeValue = "961cc777-2547-4f9d-8174-7d86181b8a7a" }
        Balanced { break }
        BestPerformance { $powerModeTypeValue = "ded574b5-45a0-4f42-8737-46345c09c238" }
    }

    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Power\User\PowerSchemes" -Name "ActiveOverlayAcPowerScheme" -Value $powerModeTypeValue
}
