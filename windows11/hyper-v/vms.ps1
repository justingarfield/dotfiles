function VM-EnableNestedVirtualization([Parameter(mandatory=$true)][String] $VMName) {
    Set-VMProcessor -VMName $VMName -ExposeVirtualizationExtensions $True
}

# Disable Location services
# Disable Find my device
# Disable diagnostic data
# Disable Inking & typing
# Disable Tailored experiences
# Disable Advertising ID
