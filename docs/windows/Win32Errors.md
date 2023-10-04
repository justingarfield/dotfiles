# Win32 Errors

These are Win32 errors I've encountered thus-far using `DllImport` / Marshalling & Interop with `User32.dll` _(via `Marshal.GetLastWin32Error()`)_.

| Code         | Error                   | Description |
|-|-|-|
| 3 (0x3)      | ERROR_PATH_NOT_FOUND    | The system cannot find the path specified. |
| 87 (0x57)    | ERROR_INVALID_PARAMETER | The parameter is incorrect.                |
| 203 (0xCB)   | ERROR_ENVVAR_NOT_FOUND  | The system could not find the environment option that was entered. |
| 1439 (0x59F) | ERROR_INVALID_SPI_VALUE | Invalid system-wide (SPI_*) parameter.     |
