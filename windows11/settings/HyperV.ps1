function VM-EnableNestedVirtualization([Parameter(mandatory=$true)][String] $VMName) {
    Set-VMProcessor -VMName $VMName -ExposeVirtualizationExtensions $True
}
