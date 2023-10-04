# Settings -> Accessibility -> Mouse pointer and touch

# Source the required functions and helpers
. .\MousePointer.ps1
. .\TouchIndicator.ps1

## Mouse pointer style
Set-MousePointerStyle -Style $MousePointerStyles.White

## Size
Set-MousePointerSize -Size 6

## "Touch indicator" and "Make the circle darker and larger"
Set-TouchIndicator -Enabled $false -DarkerAndLargerCircle $false
