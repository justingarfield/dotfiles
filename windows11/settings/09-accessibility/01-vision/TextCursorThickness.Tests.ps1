BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe "Set-TextCursorThickness" {
    BeforeAll {
        Mock Set-ItemProperty { }
    }

    Context "When setting 'Text cursor thickness' to '1'" {
        It "Should set 'HKCU:\Control Panel\Desktop\CaretWidth' to '1'" {
            Set-TextCursorThickness -Thickness 1

            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Control Panel\Desktop" `
                -and $Name -eq "CaretWidth" `
                -and $Value -eq 1
            }
        }
    }

    Context "When setting 'Text cursor thickness' to '10'" {
        It "Should set 'HKCU:\Control Panel\Desktop\CaretWidth' to '10'" {
            Set-TextCursorThickness -Thickness 10

            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Control Panel\Desktop" `
                -and $Name -eq "CaretWidth" `
                -and $Value -eq 10
            }
        }
    }

    Context "When setting 'Text cursor thickness' to '20'" {
        It "Should set 'HKCU:\Control Panel\Desktop\CaretWidth' to '20'" {
            Set-TextCursorThickness -Thickness 20

            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Control Panel\Desktop" `
                -and $Name -eq "CaretWidth" `
                -and $Value -eq 20
            }
        }
    }
}
