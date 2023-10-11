$epochTime = [System.DateTimeOffset]::new((date)).ToUnixTimeSeconds()
Write-Host ($epochTime -band 0x7F -bor 0x80)
Write-Host (($epochTime -shr 7) -band 0x7F -bor 0x80)
Write-Host (($epochTime -shr 14) -band 0x7F -bor 0x80)
Write-Host (($epochTime -shr 21) -band 0x7F -bor 0x80)
Write-Host ($epochTime -shr 28)

$dto = [System.DateTimeOffset]::new(2023, 10, 11, 8, 24, 0, [TimeSpan]::Zero).ToUnixTimeSeconds();
Write-Host ($dto -band 0x7F -bor 0x80)
Write-Host (($dto -shr 7) -band 0x7F -bor 0x80)
Write-Host (($dto -shr 14) -band 0x7F -bor 0x80)
Write-Host (($dto -shr 21) -band 0x7F -bor 0x80)
Write-Host ($dto -shr 28)
