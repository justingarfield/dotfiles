# Focus registry key values

## Registry Keys

There main registry value for dealing with the Focus settings in Windows 11 22H2:

* The actual Night light settings get stored in the Registry as Hexidecimal in a `REG_BINARY` Value named `Data` under the Registry Key `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.shell.focussessionactivetheme\windows.data.shell.focussessionactivetheme${1b019365-25a5-4ff1-b50a-c155229afc8f}`.

## Binary Values

In order to understand what is even remotely going on with the values being saved, we need to break this all out.

When you save your first settings for the Night light, you'll find that the registry values look something like:
`43,42,01,00,0a,00,2a,06,d0,a7,96,a9,06,2a,2b,0e,14,43,42,01,00,c2,0a,01,c2,14,01,c2,1e,01,c2,28,01,c2,32,01,00,00,00,00`.

**NOTE: This is still in-progress. I'm trying to decipher every combination of values and still have a few bits I'm unsure about. Stay tuned!**

| What? | Example | Description |
|-|-|-|
| 8-constant bytes             | `43,42,01,00,0a,00,2a,06` |  |

### Real example values

These are REAL registry key values taken as samples to figure out how the Focus binary values work in Windows 11 22H2.

| Timer | Badges | Flashing | DND | Registry Value |
|-|-|-|-|-|
|   |   |   |   | `43,42,01,00,0a,00,2a,06,b5,aa,96,a9,06,2a,2b,0e,08,43,42,01,00,c2,0a,01,00,00,00,00` |
| X | X | X | X | `43,42,01,00,0a,00,2a,06,d0,a7,96,a9,06,2a,2b,0e,14,43,42,01,00,c2,0a,01,c2,14,01,c2,1e,01,c2,28,01,c2,32,01,00,00,00,00` |
| X |   |   |   | `43,42,01,00,0a,00,2a,06,ed,ad,96,a9,06,2a,2b,0e,0b,43,42,01,00,c2,0a,01,c2,14,01,00,00,00,00` |
|   | X |   |   | `43,42,01,00,0a,00,2a,06,87,ae,96,a9,06,2a,2b,0e,0b,43,42,01,00,c2,0a,01,c2,1e,01,00,00,00,00` |
|   |   | X |   | `43,42,01,00,0a,00,2a,06,f6,ae,96,a9,06,2a,2b,0e,0b,43,42,01,00,c2,0a,01,c2,28,01,00,00,00,00` |
|   |   |   | X | `43,42,01,00,0a,00,2a,06,8f,af,96,a9,06,2a,2b,0e,0b,43,42,01,00,c2,0a,01,c2,32,01,00,00,00,00` |
| X | X |   |   | `43,42,01,00,0a,00,2a,06,c2,af,96,a9,06,2a,2b,0e,0e,43,42,01,00,c2,0a,01,c2,14,01,c2,1e,01,00,00,00,00` |
| X | X | X |   | `43,42,01,00,0a,00,2a,06,fc,af,96,a9,06,2a,2b,0e,11,43,42,01,00,c2,0a,01,c2,14,01,c2,1e,01,c2,28,01,00,00,00,00` |
|   | X | X |   | `43,42,01,00,0a,00,2a,06,b4,b0,96,a9,06,2a,2b,0e,0e,43,42,01,00,c2,0a,01,c2,1e,01,c2,28,01,00,00,00,00` |
|   | X | X | X | `43,42,01,00,0a,00,2a,06,ce,b0,96,a9,06,2a,2b,0e,11,43,42,01,00,c2,0a,01,c2,1e,01,c2,28,01,c2,32,01,00,00,00,00` |
| X |   | X |   | `43,42,01,00,0a,00,2a,06,c8,b1,96,a9,06,2a,2b,0e,0e,43,42,01,00,c2,0a,01,c2,14,01,c2,28,01,00,00,00,00` |
|   | X |   | X | `43,42,01,00,0a,00,2a,06,fa,b1,96,a9,06,2a,2b,0e,0e,43,42,01,00,c2,0a,01,c2,1e,01,c2,32,01,00,00,00,00` |
|   |   | X | X | `43,42,01,00,0a,00,2a,06,a5,b2,96,a9,06,2a,2b,0e,0e,43,42,01,00,c2,0a,01,c2,28,01,c2,32,01,00,00,00,00` |
| X |   |   | X | `43,42,01,00,0a,00,2a,06,ea,b2,96,a9,06,2a,2b,0e,0e,43,42,01,00,c2,0a,01,c2,14,01,c2,32,01,00,00,00,00` |
| X |   | X | X | `43,42,01,00,0a,00,2a,06,d1,b4,96,a9,06,2a,2b,0e,11,43,42,01,00,c2,0a,01,c2,14,01,c2,28,01,c2,32,01,00,00,00,00` |
| X | X |   | X | `43,42,01,00,0a,00,2a,06,8b,b5,96,a9,06,2a,2b,0e,11,43,42,01,00,c2,0a,01,c2,14,01,c2,1e,01,c2,32,01,00,00,00,00` |
|   |   |   |   | `` |
|   |   |   |   | `` |
|   |   |   |   | `` |
