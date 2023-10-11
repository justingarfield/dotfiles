# Focus registry key values

## Registry Keys

There main registry value for dealing with the Focus settings in Windows 11 22H2:

* The actual Night light settings get stored in the Registry as Hexidecimal in a `REG_BINARY` Value named `Data` under the Registry Key `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.shell.focussessionactivetheme\windows.data.shell.focussessionactivetheme${1b019365-25a5-4ff1-b50a-c155229afc8f}`.

## Binary Values

In order to understand what is even remotely going on with the values being saved, we need to break this all out.

When you save your first settings for the Night light, you'll find that the registry values look something like:
`43,42,01,00,0a,00,2a,06,d0,a7,96,a9,06,2a,2b,0e,14,43,42,01,00,c2,0a,01,c2,14,01,c2,1e,01,c2,28,01,c2,32,01,00,00,00,00`.

| What? | Example | Description |
|-|-|-|
| 8-constant bytes          | `43,42,01,00,0a,00,2a,06` | 8-bytes that never change |
| Unix Timestamp bits 0-6   | `ae`                      | top bit 7 is always set |
| Unix Timestamp bits 7-13  | `eb`                      | top bit 7 is always set |
| Unix Timestamp bits 14-20 | `c2`                      | top bit 7 is always set |
| 5-constant bytes          | `a9,06,2a,2b,0e`          | 5-bytes that never change |
| 1-byte                    | `08`                      | How many Focus options were checked-off |
| 7-bytes                   | `43,42,01,00,c2,0a,01`    | 7-bytes that never change |
| 0 to 12-bytes             | `c2,14,01,c2,1e,01`       | 3-bytes per-checked option, always starting with `c2` and ending with `c1` |
| 4-constant bytes          | `00,00,00,00`             | Last 4-bytes are always constant |

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

### Remaining Binary Value Breakdown

| Scenario                | TBD  | Constant      | Schedule | TBD        | Constant | TBD           | Constant      | TBD           | Constant | Strength  |
|-|-|-|-|-|-|-|-|-|-|-|
| Timer | Badges | Flashing | DND | Registry Value |
|-|-|-|-|-|
|   |   |   |   | `b5,aa,96` | `08` | `00,00,00,00` |
| X | X | X | X | `d0,a7,96` | `14` | `c2,14,01,c2,1e,01,c2,28,01,c2,32,01,00,00,00,00` |
| X |   |   |   | `ed,ad,96` | `0b` | `c2,14,01,00,00,00,00` |
|   | X |   |   | `87,ae,96` | `0b` | `c2,1e,01,00,00,00,00` |
|   |   | X |   | `f6,ae,96` | `0b` | `c2,28,01,00,00,00,00` |
|   |   |   | X | `8f,af,96` | `0b` | `c2,32,01,00,00,00,00` |
| X | X |   |   | `c2,af,96` | `0e` | `c2,14,01,c2,1e,01,00,00,00,00` |
| X | X | X |   | `fc,af,96` | `11` | `c2,14,01,c2,1e,01,c2,28,01,00,00,00,00` |
|   | X | X |   | `b4,b0,96` | `0e` | `c2,1e,01,c2,28,01,00,00,00,00` |
|   | X | X | X | `ce,b0,96` | `11` | `c2,1e,01,c2,28,01,c2,32,01,00,00,00,00` |
| X |   | X |   | `c8,b1,96` | `0e` | `c2,14,01,c2,28,01,00,00,00,00` |
|   | X |   | X | `fa,b1,96` | `0e` | `c2,1e,01,c2,32,01,00,00,00,00` |
|   |   | X | X | `a5,b2,96` | `0e` | `c2,28,01,c2,32,01,00,00,00,00` |
| X |   |   | X | `ea,b2,96` | `0e` | `c2,14,01,c2,32,01,00,00,00,00` |
| X |   | X | X | `d1,b4,96` | `11` | `c2,14,01,c2,28,01,c2,32,01,00,00,00,00` |
| X | X |   | X | `8b,b5,96` | `11` | `c2,14,01,c2,1e,01,c2,32,01,00,00,00,00` |
