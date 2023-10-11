BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe "Set-ShowTimerInTheClockApp" {
    BeforeAll {
        Mock Get-ItemPropertyValue { }
        Mock Set-ItemProperty { }
    }

    Context "When setting 'Enabled' to 'False'" {
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default`$windows.data.shell.focussessionactivetheme\windows.data.shell.focussessionactivetheme`${1b019365-25a5-4ff1-b50a-c155229afc8f}\Data'" {
            Set-ShowTimerInTheClockApp -Enabled $false
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default`$windows.data.shell.focussessionactivetheme\windows.data.shell.focussessionactivetheme`${1b019365-25a5-4ff1-b50a-c155229afc8f}" `
                -and $Name -eq "Data" `
                -and $Value -eq 1
            }
        }
    }

}

Describe "Set-HideBadgesOnTaskbarApps" {
    BeforeAll {
        Mock Set-ItemProperty { }
    }
}

Describe "Set-HideFlashingOnTaskbarApps" {
    BeforeAll {
        Mock Set-ItemProperty { }
    }
}

Describe "Set-TurnOnDoNotDisturb" {
    BeforeAll {
        Mock Set-ItemProperty { }
    }
}
