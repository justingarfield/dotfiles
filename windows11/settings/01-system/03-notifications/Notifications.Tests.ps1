BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe "Set-ShowWelcomeExperienceAfterUpdates" {
    BeforeAll {
        Mock Set-ItemProperty { }
    }

    Context "When setting 'Show the Windows welcome experience after updates and when signed in to show what's new and suggested' to 'Unchecked'" {
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-310093Enabled' to '0'" {
            Set-ShowWelcomeExperienceAfterUpdates -Enabled $false
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
                -and $Name -eq "SubscribedContent-310093Enabled" `
                -and $Value -eq 0
            }
        }
    }

    Context "When setting 'Show the Windows welcome experience after updates and when signed in to show what's new and suggested' to 'Checked'" {
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-310093Enabled' to '1'" {
            Set-ShowWelcomeExperienceAfterUpdates -Enabled $true
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
                -and $Name -eq "SubscribedContent-310093Enabled" `
                -and $Value -eq 1
            }
        }
    }
}

Describe "Set-GetTipsAndSuggestions" {
    BeforeAll {
        Mock Set-ItemProperty { }
    }

    Context "When setting 'Get tips and suggestions when using Windows' to 'Unchecked'" {
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-338389Enabled' to '0'" {
            Set-GetTipsAndSuggestions -Enabled $false
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
                -and $Name -eq "SubscribedContent-338389Enabled" `
                -and $Value -eq 0
            }
        }
    }

    Context "When setting 'Get tips and suggestions when using Windows' to 'Checked'" {
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-338389Enabled' to '1'" {
            Set-GetTipsAndSuggestions -Enabled $true
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
                -and $Name -eq "SubscribedContent-338389Enabled" `
                -and $Value -eq 1
            }
        }
    }
}
