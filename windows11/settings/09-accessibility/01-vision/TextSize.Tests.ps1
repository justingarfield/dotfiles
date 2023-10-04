BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe "Set-TextSize" {
    BeforeAll {
        Mock Set-ItemProperty { }
    }

    Context "When setting 'Text size' to '100%'" {
        It "Should set 'HKCU:\Software\Microsoft\Accessibility\TextScaleFactor' to '100'" {
            Set-TextSize -Percent 100

            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Accessibility" `
                -and $Name -eq "TextScaleFactor" `
                -and $Value -eq 100
            }
        }
    }

    Context "When setting 'Text size' to '165%'" {
        It "Should set 'HKCU:\Software\Microsoft\Accessibility\TextScaleFactor' to '165'" {
            Set-TextSize -Percent 165

            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Accessibility" `
                -and $Name -eq "TextScaleFactor" `
                -and $Value -eq 165
            }
        }
    }

    Context "When setting 'Text size' to '225%'" {
        It "Should set 'HKCU:\Software\Microsoft\Accessibility\TextScaleFactor' to '225'" {
            Set-TextSize -Percent 225

            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Accessibility" `
                -and $Name -eq "TextScaleFactor" `
                -and $Value -eq 225
            }
        }
    }
}
