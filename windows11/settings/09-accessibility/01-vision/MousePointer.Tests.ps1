BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe "Set-MonoAudio" {
    BeforeAll {
        Mock Set-ItemProperty { }
        Mock Restart-WindowsService { }
    }

    Context "When setting 'Mono audio' to 'Off'" {
        It "Should set HKCU:\Software\Microsoft\Multimedia\Audio\AccessibilityMonoMixState to 0" {
            Set-MonoAudio -Enabled $false
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Multimedia\Audio" `
                -and $Name -eq "AccessibilityMonoMixState" `
                -and $Value -eq 0
            }
        }

        It "Should restart the Audiosrv (Windows Audio) Windows service" {
            Set-MonoAudio -Enabled $false

            Should -Invoke Restart-WindowsService -Times 1 -Exactly -ParameterFilter {
                $ServiceName -eq "Audiosrv"
            }
        }
    }

    Context "When setting 'Mono audio' to 'On'" {
        It "Should set HKCU:\Software\Microsoft\Multimedia\Audio\AccessibilityMonoMixState to 1" {
            Set-MonoAudio -Enabled $true
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Multimedia\Audio" `
                -and $Name -eq "AccessibilityMonoMixState" `
                -and $Value -eq 1
            }
        }

        It "Should restart the Audiosrv (Windows Audio) Windows service" {
            Set-MonoAudio -Enabled $true

            Should -Invoke Restart-WindowsService -Times 1 -Exactly -ParameterFilter {
                $ServiceName -eq "Audiosrv"
            }
        }
    }
}

Describe "Set-ScreenFlashAudioNotifications" {
    
    BeforeAll {
        Mock Set-ItemProperty { }
    }

    Context "When setting 'Flash my screen during audio notifications' to 'Never'" {
        It "Should set HKCU:\Control Panel\Accessibility\SoundSentry\WindowsEffect to 0" {
            Set-ScreenFlashAudioNotifications -AudioNotificationScreenFlashType Never
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Control Panel\Accessibility\SoundSentry" `
                -and $Name -eq "WindowsEffect" `
                -and $Value -eq 0
            }
        }
    }

    Context "When setting 'Flash my screen during audio notifications' to 'FlashTitleBar'" {
        It "Should set HKCU:\Control Panel\Accessibility\SoundSentry\WindowsEffect to 1" {
            Set-ScreenFlashAudioNotifications -AudioNotificationScreenFlashType FlashTitleBar
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Control Panel\Accessibility\SoundSentry" `
                -and $Name -eq "WindowsEffect" `
                -and $Value -eq 1
            }
        }
    }

    Context "When setting 'Flash my screen during audio notifications' to 'FlashActiveWindow'" {
        It "Should set HKCU:\Control Panel\Accessibility\SoundSentry\WindowsEffect to 1" {
            Set-ScreenFlashAudioNotifications -AudioNotificationScreenFlashType FlashActiveWindow
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Control Panel\Accessibility\SoundSentry" `
                -and $Name -eq "WindowsEffect" `
                -and $Value -eq 2
            }
        }
    }

    Context "When setting 'Flash my screen during audio notifications' to 'FlashEntireScreen'" {
        It "Should set HKCU:\Control Panel\Accessibility\SoundSentry\WindowsEffect to 1" {
            Set-ScreenFlashAudioNotifications -AudioNotificationScreenFlashType FlashEntireScreen
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Control Panel\Accessibility\SoundSentry" `
                -and $Name -eq "WindowsEffect" `
                -and $Value -eq 3
            }
        }
    }
}
