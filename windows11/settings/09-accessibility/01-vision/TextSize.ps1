function Set-TextSize {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateRange(100, 225)]
        [int]
        $Percent
    )
    
    Set-ItemProperty "HKCU:\Software\Microsoft\Accessibility" "TextScaleFactor" $Percent
}
