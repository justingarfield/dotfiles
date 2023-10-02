# Settings -> Accessibility -> Mouse pointer and touch

# Source the required functions and helpers
. .\MousePointerAndTouch.ps1

## Mouse pointer style
Set-MousePointerStyle -Style $MousePointerStyles.White -CursorSize 6

## Size
# Set-MousePointerSize -Size 6

## "Touch indicator" and "Make the circle darker and larger"
Set-TouchIndicator -Enabled $false -DarkerAndLargerCircle $false
