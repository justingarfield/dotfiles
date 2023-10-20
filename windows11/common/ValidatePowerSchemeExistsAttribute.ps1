class ValidatePowerSchemeExistsAttribute : System.Management.Automation.ValidateArgumentsAttribute {
    [bool]
    $AllowEmpty = $false

    [void]
    Validate(
        [object] $arguments,
        [System.Management.Automation.EngineIntrinsics] $engineIntrinsics
    )
    {
        $nameOrGuid = $arguments

        if ($this.AllowEmpty -and [string]::IsNullOrEmpty($nameOrGuid)) {
            return
        }

        $foundMatch = $false
        if ($nameOrGuid -match "[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}") {
            $foundMatch = Get-PowerSchemes | Where-Object { $_.Guid -eq $nameOrGuid }
        } else {
            $foundMatch = Get-PowerSchemes | Where-Object { $_.Name -eq $nameOrGuid }
        }

        if (!$foundMatch) {
            Throw "Power Scheme Name or Guid of '$nameOrGuid' not found."
        }
    }
}
