# Win32 Errors

These are Win32 errors I've encountered thus-far using `DllImport` / Marshalling & Interop with `User32.dll` _(via `Marshal.GetLastWin32Error()`)_.

| Code         | Error                   | Description |
|-|-|-|
| 203 (0xCB)   | ERROR_ENVVAR_NOT_FOUND  | The system could not find the environment option that was entered. |
| 1439 (0x59F) | ERROR_INVALID_SPI_VALUE | Invalid system-wide (SPI_*) parameter. |
