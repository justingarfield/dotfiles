#######################################################################################################################
# This file houses the functionality to change the "Mouse Pointer Style" under Accessibility -> Mouse pointer and touch
#
# # See https://devblogs.microsoft.com/scripting/use-powershell-to-change-the-mouse-pointer-scheme/
#######################################################################################################################

# Source the required functions and helpers
. .\MousePointerStyle.ps1
. ..\..\WinUser.ps1

$systemRootCursors = "%SystemRoot%\cursors"
$appDataLocalCursors = "$ENV:LOCALAPPDATA\Microsoft\Windows\Cursors"

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
        "$systemRootCursors\move_i.cur",        # SizeAll
        "$systemRootCursors\size1_i.cur",       # SizeNESW
        "$systemRootCursors\size4_i.cur",       # SizeNS
        "$systemRootCursors\size2_i.cur",       # SizeNWSE
        "$systemRootCursors\size3_i.cur",       # SizeWE
        "$systemRootCursors\up_i.cur",          # UpArrow
        "$systemRootCursors\busy_i.cur"         # Wait
    )

    Custom = [MousePointerStyle]::new(
        "Windows Aero",                         # Name
        "$appDataLocalCursors\busy_eoa.cur",    # AppStarting
        "$appDataLocalCursors\arrow_eoa.cur",   # Arrow
        "$appDataLocalCursors\cross_eoa.cur",   # Crosshair
        6,                                      # CursorType
        "$appDataLocalCursors\link_eoa.cur",    # Hand
        "$appDataLocalCursors\helpsel_eoa.cur", # Help
        "$appDataLocalCursors\ibeam_eoa.cur",   # IBeam
        "$appDataLocalCursors\unavail_eoa.cur", # No
        "$appDataLocalCursors\pen_eoa.cur",     # NWPen
        "$appDataLocalCursors\move_eoa.cur",    # SizeAll
        "$appDataLocalCursors\nesw_eoa.cur",    # SizeNESW
        "$appDataLocalCursors\ns_eoa.cur",      # SizeNS
        "$appDataLocalCursors\nwse_eoa.cur",    # SizeNWSE
        "$appDataLocalCursors\ew_eoa.cur",      # SizeWE
        "$appDataLocalCursors\up_eoa.cur",      # UpArrow
        "$appDataLocalCursors\wait_eoa.cur"     # Wait
    )
}

function Set-MousePointerStyle {
    param(
        [Parameter(Mandatory=$true)]
        [MousePointerStyle]
        $Style,
        
        [ValidateRange(1,15)]
        [int]
        $CursorSize = 1
    )
    
    if ($CursorSize -gt 1 -And $CursorType -ne 6) {
        $customStyle = $MousePointerStyles.Custom
        $customStyle.Name = $Style.Name
        $customStyle.CursorType = $Style.CursorType
        $Style = $customStyle
    }

    # CursorType gets +3 if there's a non-default Pointer Size involved..."No idea, I just work here."
    $cursorType = $Style.CursorType
    Write-Host "CursorSize: $CursorSize"
    Write-Host "cursorType A: $cursorType"
    if ($CursorSize -gt 1 -And $CursorType -ne 6) {
        $cursorType += 3
    }
    Write-Host "cursorType B: $cursorType"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Accessibility" -Name "CursorType" -Value $cursorType

    $registryPath = "HKCU:\Control Panel\Cursors"
    Set-ItemProperty -Path $registryPath -Name "(Default)" -Value $Style.Name
    Set-ItemProperty -Path $registryPath -Name "AppStarting" -Value $Style.AppStarting
    Set-ItemProperty -Path $registryPath -Name "Arrow" -Value $Style.Arrow
    Set-ItemProperty -Path $registryPath -Name "Crosshair" -Value $Style.Crosshair
    Set-ItemProperty -Path $registryPath -Name "Hand" -Value $Style.Hand
    Set-ItemProperty -Path $registryPath -Name "Help" -Value $Style.Help
    Set-ItemProperty -Path $registryPath -Name "IBeam" -Value $Style.IBeam
    Set-ItemProperty -Path $registryPath -Name "No" -Value $Style.No
    Set-ItemProperty -Path $registryPath -Name "NWPen" -Value $Style.NWPen

    # These two values are only set explicitly with 'Custom' Style / Pointer Size changes
    if ($CursorType -gt 2 -And $CursorType -lt 7) {
        Write-Host "appDataLocalCursors: $appDataLocalCursors"
        Set-ItemProperty -Path $registryPath -Name "Person" -Value "$appDataLocalCursors\person_eoa.cur"
        Set-ItemProperty -Path $registryPath -Name "Pin" -Value "$appDataLocalCursors\pin_eoa.cur"
    }

    # Currently always seems to get set to 2 no matter what
    Set-ItemProperty -Path $registryPath -Name "Scheme Source" -Value 2

    Set-ItemProperty -Path $registryPath -Name "SizeAll" -Value $Style.SizeAll
    Set-ItemProperty -Path $registryPath -Name "SizeNESW" -Value $Style.SizeNESW
    Set-ItemProperty -Path $registryPath -Name "SizeNS" -Value $Style.SizeNS
    Set-ItemProperty -Path $registryPath -Name "SizeNWSE" -Value $Style.SizeNWSE
    Set-ItemProperty -Path $registryPath -Name "SizeWE" -Value $Style.SizeWE
    Set-ItemProperty -Path $registryPath -Name "UpArrow" -Value $Style.UpArrow
    Set-ItemProperty -Path $registryPath -Name "Wait" -Value $Style.Wait

    # Deal with Cursor Sizes
    $cursorBaseSize = 16 + (16 * $CursorSize)
    
    Write-Host "cursorBaseSize: $cursorBaseSize"
    Set-ItemProperty -Path $registryPath -Name "CursorBaseSize" -Value $cursorBaseSize
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Accessibility" -Name "CursorSize" -Value $CursorSize

    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes" -Name "CurrentTheme" -Value "$appDataLocalCursors\Microsoft\Windows\Themes\Custom.theme"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\HighContrast" -Name "Pre-High Contrast Scheme" -Value "$appDataLocalCursors\Microsoft\Windows\Themes\Custom.theme"

    if (![WinUser]::SystemParametersInfo($systemWideParameters.SPI_SETCURSORS, 0, $null, 0)) {
        [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
    }
    
    # See https://stackoverflow.com/a/69687213
    if (![WinUser]::SystemParametersInfo($systemWideParameters.MYSTERY_VALUE, 0, $cursorBaseSize, 0x01)) {
        [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
    }
}

function Set-MousePointerSize {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateRange(1,15)]
        [int]$Size
    )

    Set-MousePointerStyle -Style $MousePointerStyles.Custom -CursorSize $Size
}
