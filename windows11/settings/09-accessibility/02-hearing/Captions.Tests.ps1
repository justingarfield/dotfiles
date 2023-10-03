BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe "Set-CaptionStyle" {
    BeforeAll {
        Mock Set-ItemProperty { }
    }
    
    Context "When setting 'Caption style' to 'Default'" {
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CurrentSelectedTheme' to '{642F4BD2-475F-4802-9B13-95261896CB1C}'" {
            Set-CaptionStyle -CaptionStyleType Default
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CurrentSelectedTheme" `
                -and $Value -eq "{642F4BD2-475F-4802-9B13-95261896CB1C}"
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionColor' to '1'" {
            Set-CaptionStyle -CaptionStyleType Default
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionColor" `
                -and $Value -eq 1
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionOpacity' to '1'" {
            Set-CaptionStyle -CaptionStyleType Default
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionOpacity" `
                -and $Value -eq 1
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionSize' to '2'" {
            Set-CaptionStyle -CaptionStyleType Default
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionSize" `
                -and $Value -eq 2
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionFontStyle' to '4'" {
            Set-CaptionStyle -CaptionStyleType Default
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionFontStyle" `
                -and $Value -eq 4
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionEdgeEffect' to '1'" {
            Set-CaptionStyle -CaptionStyleType Default
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionEdgeEffect" `
                -and $Value -eq 1
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\BackgroundColor' to '2'" {
            Set-CaptionStyle -CaptionStyleType Default
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "BackgroundColor" `
                -and $Value -eq 2
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\BackgroundOpacity' to '2'" {
            Set-CaptionStyle -CaptionStyleType Default
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "BackgroundOpacity" `
                -and $Value -eq 2
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\RegionColor' to '2'" {
            Set-CaptionStyle -CaptionStyleType Default
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "RegionColor" `
                -and $Value -eq 2
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\RegionOpacity' to '4'" {
            Set-CaptionStyle -CaptionStyleType Default
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "RegionOpacity" `
                -and $Value -eq 4
            }
        }
    }

    Context "When setting 'Caption style' to 'WhiteOnBlack'" {
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CurrentSelectedTheme' to '{ADDF2B19-ED5E-4778-AFB2-3AE1C8EC8DB8}'" {
            Set-CaptionStyle -CaptionStyleType WhiteOnBlack
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CurrentSelectedTheme" `
                -and $Value -eq "{ADDF2B19-ED5E-4778-AFB2-3AE1C8EC8DB8}"
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionColor' to '1'" {
            Set-CaptionStyle -CaptionStyleType WhiteOnBlack
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionColor" `
                -and $Value -eq 1
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionOpacity' to '1'" {
            Set-CaptionStyle -CaptionStyleType WhiteOnBlack
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionOpacity" `
                -and $Value -eq 1
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionSize' to '2'" {
            Set-CaptionStyle -CaptionStyleType WhiteOnBlack
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionSize" `
                -and $Value -eq 2
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionFontStyle' to '4'" {
            Set-CaptionStyle -CaptionStyleType WhiteOnBlack
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionFontStyle" `
                -and $Value -eq 4
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionEdgeEffect' to '1'" {
            Set-CaptionStyle -CaptionStyleType WhiteOnBlack
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionEdgeEffect" `
                -and $Value -eq 1
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\BackgroundColor' to '2'" {
            Set-CaptionStyle -CaptionStyleType WhiteOnBlack
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "BackgroundColor" `
                -and $Value -eq 2
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\BackgroundOpacity' to '2'" {
            Set-CaptionStyle -CaptionStyleType WhiteOnBlack
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "BackgroundOpacity" `
                -and $Value -eq 2
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\RegionColor' to '2'" {
            Set-CaptionStyle -CaptionStyleType WhiteOnBlack
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "RegionColor" `
                -and $Value -eq 2
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\RegionOpacity' to '4'" {
            Set-CaptionStyle -CaptionStyleType WhiteOnBlack
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "RegionOpacity" `
                -and $Value -eq 4
            }
        }
    }

    Context "When setting 'Caption style' to 'SmallCaps'" {
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CurrentSelectedTheme' to '{BA209C4E-1A6C-49A2-8AE2-A02476F598BF}'" {
            Set-CaptionStyle -CaptionStyleType SmallCaps
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CurrentSelectedTheme" `
                -and $Value -eq "{BA209C4E-1A6C-49A2-8AE2-A02476F598BF}"
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionColor' to '1'" {
            Set-CaptionStyle -CaptionStyleType SmallCaps
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionColor" `
                -and $Value -eq 1
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionOpacity' to '1'" {
            Set-CaptionStyle -CaptionStyleType SmallCaps
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionOpacity" `
                -and $Value -eq 1
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionSize' to '2'" {
            Set-CaptionStyle -CaptionStyleType SmallCaps
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionSize" `
                -and $Value -eq 2
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionFontStyle' to '7'" {
            Set-CaptionStyle -CaptionStyleType SmallCaps
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionFontStyle" `
                -and $Value -eq 7
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionEdgeEffect' to '1'" {
            Set-CaptionStyle -CaptionStyleType SmallCaps
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionEdgeEffect" `
                -and $Value -eq 1
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\BackgroundColor' to '2'" {
            Set-CaptionStyle -CaptionStyleType SmallCaps
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "BackgroundColor" `
                -and $Value -eq 2
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\BackgroundOpacity' to '2'" {
            Set-CaptionStyle -CaptionStyleType SmallCaps
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "BackgroundOpacity" `
                -and $Value -eq 2
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\RegionColor' to '2'" {
            Set-CaptionStyle -CaptionStyleType SmallCaps
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "RegionColor" `
                -and $Value -eq 2
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\RegionOpacity' to '4'" {
            Set-CaptionStyle -CaptionStyleType SmallCaps
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "RegionOpacity" `
                -and $Value -eq 4
            }
        }
    }

    Context "When setting 'Caption style' to 'LargeText'" {
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CurrentSelectedTheme' to '{C9FC6A2C-D04B-41BB-BC5A-B764515C29FD}'" {
            Set-CaptionStyle -CaptionStyleType LargeText
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CurrentSelectedTheme" `
                -and $Value -eq "{C9FC6A2C-D04B-41BB-BC5A-B764515C29FD}"
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionColor' to '1'" {
            Set-CaptionStyle -CaptionStyleType LargeText
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionColor" `
                -and $Value -eq 1
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionOpacity' to '1'" {
            Set-CaptionStyle -CaptionStyleType LargeText
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionOpacity" `
                -and $Value -eq 1
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionSize' to '3'" {
            Set-CaptionStyle -CaptionStyleType LargeText
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionSize" `
                -and $Value -eq 3
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionFontStyle' to '4'" {
            Set-CaptionStyle -CaptionStyleType LargeText
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionFontStyle" `
                -and $Value -eq 4
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionEdgeEffect' to '1'" {
            Set-CaptionStyle -CaptionStyleType LargeText
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionEdgeEffect" `
                -and $Value -eq 1
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\BackgroundColor' to '2'" {
            Set-CaptionStyle -CaptionStyleType LargeText
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "BackgroundColor" `
                -and $Value -eq 2
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\BackgroundOpacity' to '2'" {
            Set-CaptionStyle -CaptionStyleType LargeText
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "BackgroundOpacity" `
                -and $Value -eq 2
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\RegionColor' to '2'" {
            Set-CaptionStyle -CaptionStyleType LargeText
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "RegionColor" `
                -and $Value -eq 2
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\RegionOpacity' to '4'" {
            Set-CaptionStyle -CaptionStyleType LargeText
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "RegionOpacity" `
                -and $Value -eq 4
            }
        }
    }
    
    Context "When setting 'Caption style' to 'YellowOnBlue'" {
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CurrentSelectedTheme' to '{DF834234-A0EF-4E2A-BB87-C40E5D1CFC8C}'" {
            Set-CaptionStyle -CaptionStyleType YellowOnBlue
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CurrentSelectedTheme" `
                -and $Value -eq "{DF834234-A0EF-4E2A-BB87-C40E5D1CFC8C}"
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionColor' to '6'" {
            Set-CaptionStyle -CaptionStyleType YellowOnBlue
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionColor" `
                -and $Value -eq 6
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionOpacity' to '1'" {
            Set-CaptionStyle -CaptionStyleType YellowOnBlue
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionOpacity" `
                -and $Value -eq 1
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionSize' to '2'" {
            Set-CaptionStyle -CaptionStyleType YellowOnBlue
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionSize" `
                -and $Value -eq 2
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionFontStyle' to '4'" {
            Set-CaptionStyle -CaptionStyleType YellowOnBlue
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionFontStyle" `
                -and $Value -eq 4
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\CaptionEdgeEffect' to '1'" {
            Set-CaptionStyle -CaptionStyleType YellowOnBlue
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "CaptionEdgeEffect" `
                -and $Value -eq 1
            }
        }

        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\BackgroundColor' to '5'" {
            Set-CaptionStyle -CaptionStyleType YellowOnBlue
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "BackgroundColor" `
                -and $Value -eq 5
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\BackgroundOpacity' to '1'" {
            Set-CaptionStyle -CaptionStyleType YellowOnBlue
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "BackgroundOpacity" `
                -and $Value -eq 1
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\RegionColor' to '2'" {
            Set-CaptionStyle -CaptionStyleType YellowOnBlue
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "RegionColor" `
                -and $Value -eq 2
            }
        }
        
        It "Should set 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning\RegionOpacity' to '4'" {
            Set-CaptionStyle -CaptionStyleType YellowOnBlue
            
            Should -Invoke Set-ItemProperty -Times 1 -Exactly -ParameterFilter {
                $Path -eq "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning" `
                -and $Name -eq "RegionOpacity" `
                -and $Value -eq 4
            }
        }
    }
}
