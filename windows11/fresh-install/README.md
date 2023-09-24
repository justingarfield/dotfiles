# fresh-install

The files in this folder were last tested 2023-09-24 against Windows 11 Pro 22H2 x64v2 ISO downloaded from [Microsoft's ISO download page](https://www.microsoft.com/software-download/windows11) _(not MSDN)_.

## Settings folder

Contains scripts that follow along with the current state of the Windows 11 Settings (`Win-key` + `I`).


## Night Light breakdown

A special thanks to [Ben N on StackOverflow](https://superuser.com/a/1209192) for posting the basis for getting this working in Windows 11 Pro 22H2.

The Microsoft Windows Team should go jump into oncoming traffic for creating this fantastic cluster-f**k.

Anyway...

### Registry Keys

There are two registry values for dealing with the Night light settings in Windows 11 22H2:

* The actual Night light settings get stored in the Registry as Hexidecimal in a `REG_BINARY` Value named `Data` under the Registry Key `HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.settings\windows.data.bluelightreduction.settings`.
* The toggle or On/Off value for the Night light functionality overall gets stored in the Registry as Hexidecimal in a `REG_BINARY` Value named `Data` under the Registry Key `HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.bluelightreductionstate\windows.data.bluelightreduction.bluelightreductionstate\Data`.

### Binary Value breakdown

In order to understand WTF is even remotely going on with the values being saved, we need to break this all out.

When you save your first settings for the Night light, you'll find that the registry values look something like:
`43,42,01,00,0a,02,01,00,2a,06,ae,eb,c2,a8,06,2a,2b,0e,23,43,42,01,00,02,01,ca,14,0e,04,00,ca,1e,0e,10,00,cf,28,d0,26,ca,32,0e,12,2e,2a,00,ca,3c,0e,06,2e,24,00,00,00,00,00`.

Good times, right? So easy to deciper...LOL! Let's break this shit down...

| What? | Example | Description |
|-|-|-|
| 10-constant bytes             | `43,42,01,00,0a,02,01,00,2a,06` | These first 10-bytes are always going to remain the same. Why not, right? Yay Windows! |
| Unix Timestamp bits 0-6       | `ae`                            | top bit 7 is always set |
| Unix Timestamp bits 7-13      | `eb`                            | top bit 7 is always set |
| Unix Timestamp bits 14-20     | `c2`                            | top bit 7 is always set |
| Unix Timestamp bits 21-27     | `a8`                            | top bit 7 is always set |
| Unix Timestamp bits 28-31     | `06`                            | top bit 7 is _NOT_ set |
| 3-constant bytes              | `2a,2b,0e`                      | These 3-bytes are always going to remain the same...lame! |
| Flag representing Schedule    | `1c`                            | `1c` = Off, `23` = Sunset to sunrise, `1e` = Set hours |
| 4-constant bytes              | `43,42,01,00`                   | These 4-bytes are always going to remain the same |
| Is Schedule enabled?          | `02,01`                         | Only gets added if Schedule enabled. Missing if not. Dumb. |
| | | |
| | | |
| | | |
| | | |
| 5-constant bytes              | `00,00,00,00,00`                | Why not? Right?? |
