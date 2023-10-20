. ..\..\common\Power.ps1

function Set-TurnOffScreenAfter {
    param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [PowerOptionDurationTypes]
        $PowerOptionDuration
    )

    $powerOptionDurationTypeValue = [int]([PowerOptionDurationTypes]::$PowerOptionDuration)

    # More-or-less just an alias to this call. Trying to stay aligned to Settings UI with naming and options.
    Set-TurnOffDisplayAfter -PowerSource $PowerSource -Minutes $powerOptionDurationTypeValue
}

function Set-PutDeviceToSleepAfter {
    param(
        [Parameter(Mandatory=$true)]
        [PowerSourceTypes]
        $PowerSource,

        [Parameter(Mandatory=$true)]
        [PowerOptionDurationTypes]
        $PowerOptionDurationType
    )

    $powerOptionDurationTypeValue = [int]([PowerOptionDurationTypes]::$PowerOptionDurationType)

    Set-SleepAfter -PowerSource $PowerSource -Minutes $powerOptionDurationTypeValue
}
