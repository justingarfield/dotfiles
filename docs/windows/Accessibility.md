# Settings -> Accessibility

Notes regarding Accessibility related settings.

## Mouse Pointer Style

## Mouse Pointer Size

Table of all the supported pointer sizes in the Windows 11 Settings UI, and the corresponding size values in the registry.

### `White` pointer style

| CursorSize | CursorBaseSize | CursorType |
|-|-|-|
|  1 | 32 | 0 |
|  2 | 48 | 3 |
|  3 | 64 | 3 |
|  4 | 80 | 3 |
|  5 | 96 | 3 |
|  6 | 112 | 3 |
|  7 | 128 | 3 |
|  8 | 144 | 3 |
|  9 | 160 | 3 |
| 10 | 176 | 3 |
| 11 | 192 | 3 |
| 12 | 208 | 3 |
| 13 | 224 | 3 |
| 14 | 240 | 3 |
| 15 | 256 | 3 |

### `Black` pointer style

| CursorSize | CursorBaseSize | CursorType |
|-|-|-|
|  1 | 32 | 1 |
|  2 | 48 | 4 |
|  3 | 64 | 4 |
|  4 | 80 | 4 |
|  5 | 96 | 4 |
|  6 | 112 | 4 |
|  7 | 128 | 4 |
|  8 | 144 | 4 |
|  9 | 160 | 4 |
| 10 | 176 | 4 |
| 11 | 192 | 4 |
| 12 | 208 | 4 |
| 13 | 224 | 4 |
| 14 | 240 | 4 |
| 15 | 256 | 4 |

### `Inverted` pointer style

| CursorSize | CursorBaseSize | CursorType |
|-|-|-|
|  1 | 32 | 2 |
|  2 | 48 | 5 |
|  3 | 64 | 5 |
|  4 | 80 | 5 |
|  5 | 96 | 5 |
|  6 | 112 | 5 |
|  7 | 128 | 5 |
|  8 | 144 | 5 |
|  9 | 160 | 5 |
| 10 | 176 | 5 |
| 11 | 192 | 5 |
| 12 | 208 | 5 |
| 13 | 224 | 5 |
| 14 | 240 | 5 |
| 15 | 256 | 5 |

### `Custom` pointer style

| CursorSize | CursorBaseSize | CursorType |
|-|-|-|
|  1 | 32 | 6 |
|  2 | 48 | 6 |
|  3 | 64 | 6 |
|  4 | 80 | 6 |
|  5 | 96 | 6 |
|  6 | 112 | 6 |
|  7 | 128 | 6 |
|  8 | 144 | 6 |
|  9 | 160 | 6 |
| 10 | 176 | 6 |
| 11 | 192 | 6 |
| 12 | 208 | 6 |
| 13 | 224 | 6 |
| 14 | 240 | 6 |
| 15 | 256 | 6 |

## Touch Indicator

### Off

| Registry Key | Value |
|-|-|
| `HKCU:\Control Panel\Cursors\ContactVisualization` | 0 |
| `HKCU:\Control Panel\Cursors\GestureVisualization` | 24 |

### On without darker and larger circle

| Registry Key | Value |
|-|-|
| `HKCU:\Control Panel\Cursors\ContactVisualization` | 1 |
| `HKCU:\Control Panel\Cursors\GestureVisualization` | 31 |

### On with darker and larger circle

| Registry Key | Value |
|-|-|
| `HKCU:\Control Panel\Cursors\ContactVisualization` | 2 |
| `HKCU:\Control Panel\Cursors\GestureVisualization` | 31 |
