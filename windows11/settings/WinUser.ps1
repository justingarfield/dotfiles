#############################################################################################################
# This file houses the functionality to perform Interop calls to the WinUser.h related functions in Windows
#
# See https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-systemparametersinfow
# See https://stackoverflow.com/questions/63593930/how-to-call-a-win32-api-function-from-powershell
# See https://learn.microsoft.com/en-us/windows/win32/debug/system-error-codes
#
# Note: Only source this file in Helper files, don't source it in the higher-level 
#       scripts that are used to actually make the initial Settings calls.
#############################################################################################################

$systemWideParameters = @{
    # Accessibility
    SPI_SETCURSORS = 0x0057
    MYSTERY_VALUE = 0x2029 # Undocumented, but changes Cursor Size without a relog/reboot *shrug*

    # Input
    SPI_SETCONTACTVISUALIZATION = 0x2019
    SPI_SETGESTUREVISUALIZATION = 0x201B
}

Add-Type -TypeDefinition @"
    using System;
    using System.Diagnostics;
    using System.Runtime.InteropServices;

    public static class WinUser
    {
        [DllImport("user32.dll", SetLastError = true, EntryPoint = "SystemParametersInfo")]
        public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, uint pvParam, uint fWinIni);
    }
"@
