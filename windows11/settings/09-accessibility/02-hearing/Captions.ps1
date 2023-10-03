enum CaptionStyleTypes {
    Default = 0
    WhiteOnBlack = 1
    SmallCaps = 2
    LargeText = 3
    YellowOnBlue = 4
}

class CaptionStyle {
    [string]$CurrentSelectedTheme
    [int]$CaptionColor
    [int]$CaptionOpacity
    [int]$CaptionSize
    [int]$CaptionFontStyle
    [int]$CaptionEdgeEffect
    [int]$BackgroundColor
    [int]$BackgroundOpacity
    [int]$RegionColor
    [int]$RegionOpacity

    CaptionStyle(
        [string]$CurrentSelectedTheme,
        [int]$CaptionColor,
        [int]$CaptionOpacity,
        [int]$CaptionSize,
        [int]$CaptionFontStyle,
        [int]$CaptionEdgeEffect,
        [int]$BackgroundColor,
        [int]$BackgroundOpacity,
        [int]$RegionColor,
        [int]$RegionOpacity
    ) {
        $this.CurrentSelectedTheme = $CurrentSelectedTheme
        $this.CaptionColor = $CaptionColor
        $this.CaptionOpacity = $CaptionOpacity
        $this.CaptionSize = $CaptionSize
        $this.CaptionFontStyle = $CaptionFontStyle
        $this.CaptionEdgeEffect = $CaptionEdgeEffect
        $this.BackgroundColor = $BackgroundColor
        $this.BackgroundOpacity = $BackgroundOpacity
        $this.RegionColor = $RegionColor
        $this.RegionOpacity = $RegionOpacity
    }
}

$CaptionStyles = @{
    Default = [CaptionStyle]::new(
        "{642F4BD2-475F-4802-9B13-95261896CB1C}", # CurrentSelectedTheme
        1,                                        # CaptionColor
        1,                                        # CaptionOpacity
        2,                                        # CaptionSize
        4,                                        # CaptionFontStyle
        1,                                        # CaptionEdgeEffect
        2,                                        # BackgroundColor
        2,                                        # BackgroundOpacity
        2,                                        # RegionColor
        4                                         # RegionOpacity
    )

    WhiteOnBlack = [CaptionStyle]::new(
        "{ADDF2B19-ED5E-4778-AFB2-3AE1C8EC8DB8}", # CurrentSelectedTheme
        1,                                        # CaptionColor
        1,                                        # CaptionOpacity
        2,                                        # CaptionSize
        4,                                        # CaptionFontStyle
        1,                                        # CaptionEdgeEffect
        2,                                        # BackgroundColor
        2,                                        # BackgroundOpacity
        2,                                        # RegionColor
        4                                         # RegionOpacity
    )

    SmallCaps = [CaptionStyle]::new(
        "{BA209C4E-1A6C-49A2-8AE2-A02476F598BF}", # CurrentSelectedTheme
        1,                                        # CaptionColor
        1,                                        # CaptionOpacity
        2,                                        # CaptionSize
        7,                                        # CaptionFontStyle
        1,                                        # CaptionEdgeEffect
        2,                                        # BackgroundColor
        2,                                        # BackgroundOpacity
        2,                                        # RegionColor
        4                                         # RegionOpacity
    )

    LargeText = [CaptionStyle]::new(
        "{C9FC6A2C-D04B-41BB-BC5A-B764515C29FD}", # CurrentSelectedTheme
        1,                                        # CaptionColor
        1,                                        # CaptionOpacity
        3,                                        # CaptionSize
        4,                                        # CaptionFontStyle
        1,                                        # CaptionEdgeEffect
        2,                                        # BackgroundColor
        2,                                        # BackgroundOpacity
        2,                                        # RegionColor
        4                                         # RegionOpacity
    )

    YellowOnBlue = [CaptionStyle]::new(
        "{DF834234-A0EF-4E2A-BB87-C40E5D1CFC8C}", # CurrentSelectedTheme
        6,                                        # CaptionColor
        1,                                        # CaptionOpacity
        2,                                        # CaptionSize
        4,                                        # CaptionFontStyle
        1,                                        # CaptionEdgeEffect
        5,                                        # BackgroundColor
        1,                                        # BackgroundOpacity
        2,                                        # RegionColor
        4                                         # RegionOpacity
    )
}

function Set-LiveCaptions {
    param(
        [Parameter(Mandatory=$true)]
        [bool]
        $Enabled
    )

    $value = $Enabled ? 1 : 0

}

function Set-CaptionStyle {
    param(
        [Parameter(Mandatory=$true)]
        [CaptionStyleTypes]
        $CaptionStyleType
    )

    [CaptionStyle]$captionStyle = $null
    switch ($CaptionStyleType) {
        Default { $captionStyle = $CaptionStyles.Default }
        WhiteOnBlack { $captionStyle = $CaptionStyles.WhiteOnBlack }
        SmallCaps { $captionStyle = $CaptionStyles.SmallCaps }
        LargeText { $captionStyle = $CaptionStyles.LargeText }
        YellowOnBlue { $captionStyle = $CaptionStyles.YellowOnBlue }
    }

    $registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ClosedCaptioning"
    Set-ItemProperty -Path $registryPath -Name "CurrentSelectedTheme" -Value $captionStyle.CurrentSelectedTheme
    Set-ItemProperty -Path $registryPath -Name "CaptionColor" -Value $captionStyle.CaptionColor
    Set-ItemProperty -Path $registryPath -Name "CaptionOpacity" -Value $captionStyle.CaptionOpacity
    Set-ItemProperty -Path $registryPath -Name "CaptionSize" -Value $captionStyle.CaptionSize
    Set-ItemProperty -Path $registryPath -Name "CaptionFontStyle" -Value $captionStyle.CaptionFontStyle
    Set-ItemProperty -Path $registryPath -Name "CaptionEdgeEffect" -Value $captionStyle.CaptionEdgeEffect
    Set-ItemProperty -Path $registryPath -Name "BackgroundColor" -Value $captionStyle.BackgroundColor
    Set-ItemProperty -Path $registryPath -Name "BackgroundOpacity" -Value $captionStyle.BackgroundOpacity
    Set-ItemProperty -Path $registryPath -Name "RegionColor" -Value $captionStyle.RegionColor
    Set-ItemProperty -Path $registryPath -Name "RegionOpacity" -Value $captionStyle.RegionOpacity
}
