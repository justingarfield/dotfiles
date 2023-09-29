$private:systemRootCursors = "%SystemRoot%\cursors"
$private:appDataLocalCursors = "%LOCALAPPDATA%\Microsoft\Windows\Cursors"

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
    [int]$SchemeSource
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
        [int]$SchemeSource,
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
        $this.SchemeSource = $SchemeSource
        $this.SizeAll = $SizeAll
        $this.SizeNESW = $SizeNESW
        $this.SizeNS = $SizeNS
        $this.SizeNWSE = $SizeNWSE
        $this.SizeWE = $SizeWE
        $this.UpArrow = $UpArrow
        $this.Wait = $Wait
    }
}

$MousePointerStyles = @{
    White = [MousePointerStyle]::new(
        "Windows Aero",                         # Name
        "$systemRootCursors\aero_working.ani",  # AppStarting
        "$systemRootCursors\aero_arrow.cur",    # Arrow
        "",                                     # Crosshair ('Windows Aero' currently sets this to blank)
        0,                                      # CursorType
        "$systemRootCursors\aero_link.cur",     # Hand
        "$systemRootCursors\aero_helpsel.cur",  # Help
        "",                                     # IBeam ('Windows Aero' currently sets this to blank)
        "$systemRootCursors\aero_unavail.cur",  # No
        "$systemRootCursors\aero_pen.cur",      # NWPen
        2,                                      # SchemeSource
        "$systemRootCursors\aero_move.cur",     # SizeAll
        "$systemRootCursors\aero_nesw.cur",     # SizeNESW
        "$systemRootCursors\aero_ns.cur",       # SizeNS
        "$systemRootCursors\aero_nwse.cur",     # SizeNWSE
        "$systemRootCursors\aero_ew.cur",       # SizeWE
        "$systemRootCursors\aero_up.cur",       # UpArrow
        "$systemRootCursors\aero_busy.ani"      # Wait
    )

    Black = [MousePointerStyle]::new(
        "Windows Black",                        # Name
        "$systemRootCursors\wait_r.cur",        # AppStarting
        "$systemRootCursors\arrow_r.cur",       # Arrow
        "$systemRootCursors\cross_r.cur",       # Crosshair
        1,                                      # CursorType
        "",                                     # Hand ('Windows Black' currently sets this to blank)
        "$systemRootCursors\help_r.cur",        # Help
        "$systemRootCursors\beam_r.cur",        # IBeam
        "$systemRootCursors\no_r.cur",          # No
        "$systemRootCursors\pen_r.cur",         # NWPen
        2,                                      # SchemeSource
        "$systemRootCursors\move_r.cur",        # SizeAll
        "$systemRootCursors\size1_r.cur",       # SizeNESW
        "$systemRootCursors\size4_r.cur",       # SizeNS
        "$systemRootCursors\size2_r.cur",       # SizeNWSE
        "$systemRootCursors\size3_r.cur",       # SizeWE
        "$systemRootCursors\up_r.cur",          # UpArrow
        "$systemRootCursors\busy_r.cur"         # Wait
    )

    Inverted = [MousePointerStyle]::new(
        "Windows Inverted",                     # Name
        "$systemRootCursors\wait_i.cur",        # AppStarting
        "$systemRootCursors\arrow_i.cur",       # Arrow
        "$systemRootCursors\cross_i.cur",       # Crosshair
        2,                                      # CursorType
        "$systemRootCursors\aero_link_i.cur",   # Hand
        "$systemRootCursors\help_i.cur",        # Help
        "$systemRootCursors\beam_i.cur",        # IBeam
        "$systemRootCursors\no_i.cur",          # No
        "$systemRootCursors\pen_i.cur",         # NWPen
        2,                                      # SchemeSource
        "$systemRootCursors\move_i.cur",        # SizeAll
        "$systemRootCursors\size1_i.cur",       # SizeNESW
        "$systemRootCursors\size4_i.cur",       # SizeNS
        "$systemRootCursors\size2_i.cur",       # SizeNWSE
        "$systemRootCursors\size3_i.cur",       # SizeWE
        "$systemRootCursors\up_i.cur",          # UpArrow
        "$systemRootCursors\busy_i.cur"         # Wait
    )
}

function Set-MousePointerStyle {
    param(
        [MousePointerStyle]$MousePointerStyle
    )

    $registryPath = "HKCU:\Control Panel\Cursors"
    Set-ItemProperty -Path $registryPath -Name "(Default)" -Value $MousePointerStyle.Name
    Set-ItemProperty -Path $registryPath -Name "AppStarting" -Value $MousePointerStyle.AppStarting
    Set-ItemProperty -Path $registryPath -Name "Arrow" -Value $MousePointerStyle.Arrow
    Set-ItemProperty -Path $registryPath -Name "Crosshair" -Value $MousePointerStyle.Crosshair
    Set-ItemProperty -Path $registryPath -Name "Hand" -Value $MousePointerStyle.Hand
    Set-ItemProperty -Path $registryPath -Name "Help" -Value $MousePointerStyle.Help
    Set-ItemProperty -Path $registryPath -Name "IBeam" -Value $MousePointerStyle.IBeam
    Set-ItemProperty -Path $registryPath -Name "No" -Value $MousePointerStyle.No
    Set-ItemProperty -Path $registryPath -Name "NWPen" -Value $MousePointerStyle.NWPen
    Set-ItemProperty -Path $registryPath -Name "Scheme Source" -Value $MousePointerStyle.SchemeSource
    Set-ItemProperty -Path $registryPath -Name "SizeAll" -Value $MousePointerStyle.SizeAll
    Set-ItemProperty -Path $registryPath -Name "SizeNESW" -Value $MousePointerStyle.SizeNESW
    Set-ItemProperty -Path $registryPath -Name "SizeNS" -Value $MousePointerStyle.SizeNS
    Set-ItemProperty -Path $registryPath -Name "SizeNWSE" -Value $MousePointerStyle.SizeNWSE
    Set-ItemProperty -Path $registryPath -Name "SizeWE" -Value $MousePointerStyle.SizeWE
    Set-ItemProperty -Path $registryPath -Name "UpArrow" -Value $MousePointerStyle.UpArrow
    Set-ItemProperty -Path $registryPath -Name "Wait" -Value $MousePointerStyle.Wait

    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Accessibility" -Name "CursorType" -Value $MousePointerStyle.CursorType
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes" -Name "CurrentTheme" -Value "$appDataLocalCursors\Microsoft\Windows\Themes\Custom.theme"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\HighContrast" -Name "Pre-High Contrast Scheme" -Value "$appDataLocalCursors\Microsoft\Windows\Themes\Custom.theme"
}
