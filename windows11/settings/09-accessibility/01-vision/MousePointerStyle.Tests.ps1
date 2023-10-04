BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe "Constructor" {
    Context "Normal instantiation" {
        It "Should set all properties" {
            $mousePointerStyle = [MousePointerStyle]::new(
                "Mouse Pointer Style Name", # Name
                "appstarting.cur",          # AppStarting
                "arrow.cur",                # Arrow
                "crosshair.cur",            # Crosshair
                3,                          # CursorType
                "hand.cur",                 # Hand
                "help.cur",                 # Help
                "ibeam.cur",                # IBeam
                "no.cur",                   # No
                "nwpen.cur",                # NWPen
                "sizeall.cur",              # SizeAll
                "sizenesw.cur",             # SizeNESW
                "sizens.cur",               # SizeNS
                "sizenwse.cur",             # SizeNWSE
                "sizewe.cur",               # SizeWE
                "uparrow.cur",              # UpArrow
                "wait.ani"                  # Wait
            )

            $mousePointerStyle.Name | Should -Be "Mouse Pointer Style Name"
            $mousePointerStyle.AppStarting | Should -Be "appstarting.cur"
            $mousePointerStyle.Arrow | Should -Be "arrow.cur"
            $mousePointerStyle.Crosshair | Should -Be "crosshair.cur"
            $mousePointerStyle.CursorType | Should -Be 3
            $mousePointerStyle.Hand | Should -Be "hand.cur"
            $mousePointerStyle.Help | Should -Be "help.cur"
            $mousePointerStyle.IBeam | Should -Be "ibeam.cur"
            $mousePointerStyle.No | Should -Be "no.cur"
            $mousePointerStyle.NWPen | Should -Be "nwpen.cur"
            $mousePointerStyle.SizeAll | Should -Be "sizeall.cur"
            $mousePointerStyle.SizeNESW | Should -Be "sizenesw.cur"
            $mousePointerStyle.SizeNS | Should -Be "sizens.cur"
            $mousePointerStyle.SizeNWSE | Should -Be "sizenwse.cur"
            $mousePointerStyle.SizeWE | Should -Be "sizewe.cur"
            $mousePointerStyle.UpArrow | Should -Be "uparrow.cur"
            $mousePointerStyle.Wait | Should -Be "wait.ani"
        }
    }
}
