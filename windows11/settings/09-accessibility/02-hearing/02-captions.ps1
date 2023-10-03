# Settings -> Accessibility -> Captions

# Source the required Audio functions and helpers
. .\Captions.ps1

## "Live captions"
# Not sure how to handle this yet, as requires downloading assets to Enable initially
#Set-LiveCaptions -Enabled $false

## "Caption style" - Options: Default, WhiteOnBlack, SmallCaps, LargeText, YellowOnBlue
Set-CaptionStyle -CaptionStyleType Default
