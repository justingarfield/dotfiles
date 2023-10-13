
function Output-ByteArrayAsHexString {
    param(
        [Parameter(Mandatory=$true)]
        [byte[]]
        $Value
    )

    $Value | ForEach-Object { $string = $string + $_.ToString("x2") + ' ' }
    Write-Host $string
}

$byte = 0x08
Write-Host $byte.GetType()
Output-ByteArrayAsHexString $byte

$byte += 0x03
Write-Host $byte.GetType()
Output-ByteArrayAsHexString $byte

$byte += 3
Write-Host $byte.GetType()
Output-ByteArrayAsHexString $byte

$byte += 3
Write-Host $byte.GetType()
Output-ByteArrayAsHexString $byte


$byte += 3
Write-Host $byte.GetType()
Output-ByteArrayAsHexString $byte
