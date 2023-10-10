BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe "Set-RememberWindowLocations" {
    BeforeAll {
        Mock Set-ItemProperty { }
    }

    Context "When setting 'Remember window locations based on monitor connection' to 'Unchecked'" {
        It "Should set HKCU:\Control Panel\Desktop\RestorePreviousStateRecalcBehavior to 1" {
            Set-RememberWindowLocations -Enabled $false
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Control Panel\Desktop" `
                -and $Name -eq "RestorePreviousStateRecalcBehavior" `
                -and $Value -eq 1
            }
        }
    }

    Context "When setting 'Remember window locations based on monitor connection' to 'Checked'" {
        It "Should set HKCU:\Control Panel\Desktop\RestorePreviousStateRecalcBehavior to 0" {
            Set-RememberWindowLocations -Enabled $true
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Control Panel\Desktop" `
                -and $Name -eq "RestorePreviousStateRecalcBehavior" `
                -and $Value -eq 0
            }
        }
    }
}

Describe "Set-MinimizeWindowsOnDisconnect" {
    BeforeAll {
        Mock Set-ItemProperty { }
    }

    Context "When setting 'Minimize windows when a monitor is disconnected' to 'Unchecked'" {
        It "Should set HKCU:\Control Panel\Desktop\MonitorRemovalRecalcBehavior to 1" {
            Set-MinimizeWindowsOnDisconnect -Enabled $false
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Control Panel\Desktop" `
                -and $Name -eq "MonitorRemovalRecalcBehavior" `
                -and $Value -eq 1
            }
        }
    }

    Context "When setting 'Minimize windows when a monitor is disconnected' to 'Checked'" {
        It "Should set HKCU:\Control Panel\Desktop\MonitorRemovalRecalcBehavior to 0" {
            Set-MinimizeWindowsOnDisconnect -Enabled $true
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Control Panel\Desktop" `
                -and $Name -eq "MonitorRemovalRecalcBehavior" `
                -and $Value -eq 0
            }
        }
    }
}

Describe "Set-EaseCursorMovement" {
    BeforeAll {
        Mock Set-ItemProperty { }
    }

    Context "When setting 'Ease cursor movement between displays' to 'Unchecked'" {
        It "Should set HKCU:\Control Panel\Cursors\CursorDeadzoneJumpingSetting to 0" {
            Set-EaseCursorMovement -Enabled $false
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Control Panel\Cursors" `
                -and $Name -eq "CursorDeadzoneJumpingSetting" `
                -and $Value -eq 0
            }
        }
    }

    Context "When setting 'Ease cursor movement between displays' to 'Checked'" {
        It "Should set HKCU:\Control Panel\Cursors\CursorDeadzoneJumpingSetting to 1" {
            Set-EaseCursorMovement -Enabled $true
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Control Panel\Cursors" `
                -and $Name -eq "CursorDeadzoneJumpingSetting" `
                -and $Value -eq 1
            }
        }
    }
}
