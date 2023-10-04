################################################################################
# Represents a Mouse Pointer Style as-per the Windows 11 Accessibilty Settings 
################################################################################

class MousePointerStyle {
    [string]$Name
    [string]$AppStarting
    [string]$Arrow
    [string]$Crosshair
    [int]$CursorType
    [string]$Hand
    [string]$Help
    [string]$IBeam
    [string]$No
    [string]$NWPen
    [string]$SizeAll
    [string]$SizeNESW
    [string]$SizeNS
    [string]$SizeNWSE
    [string]$SizeWE
    [string]$UpArrow
    [string]$Wait

    MousePointerStyle(
        [string]$Name,
        [string]$AppStarting,
        [string]$Arrow,
        [string]$Crosshair,
        [int]$CursorType,
        [string]$Hand,
        [string]$Help,
        [string]$IBeam,
        [string]$No,
        [string]$NWPen,
        [string]$SizeAll,
        [string]$SizeNESW,
        [string]$SizeNS,
        [string]$SizeNWSE,
        [string]$SizeWE,
        [string]$UpArrow,
        [string]$Wait
    ) {
        $this.Name = $Name
        $this.AppStarting = $AppStarting
        $this.Arrow = $Arrow
        $this.Crosshair = $Crosshair
        $this.CursorType = $CursorType
        $this.Hand = $Hand
        $this.Help = $Help
        $this.IBeam = $IBeam
        $this.No = $No
        $this.NWPen = $NWPen
        $this.SizeAll = $SizeAll
        $this.SizeNESW = $SizeNESW
        $this.SizeNS = $SizeNS
        $this.SizeNWSE = $SizeNWSE
        $this.SizeWE = $SizeWE
        $this.UpArrow = $UpArrow
        $this.Wait = $Wait
    }
}
