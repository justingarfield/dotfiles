function ShowSecurity {
    param(
        [System.Security.AccessControl.RegistrySecurity]
        $security
    )

    Write-Host "Current access rules:"
    Write-Host ""
    foreach($ar in $security.GetAccessRules($true, $true, [System.Security.Principal.NTAccount]))
    {
        Write-Host "        User: ", $ar.IdentityReference
        Write-Host "        Type: ", $ar.AccessControlType
        Write-Host "      Rights: ", $ar.RegistryRights
        Write-Host " Inheritance: ", $ar.InheritanceFlags
        Write-Host " Propagation: ", $ar.PropagationFlags
        Write-Host "   Inherited? ", $ar.IsInherited
        Write-Host ""
    }
}

function Enable-Privilege {
    param(
        $Privilege
    )

    $Definition = @'
using System;
using System.Runtime.InteropServices;

public class AdjPriv {
    [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
    internal static extern bool AdjustTokenPrivileges(IntPtr htok, bool disall, ref TokPriv1Luid newst, int len, IntPtr prev, IntPtr rele);
    
    [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
    internal static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr phtok);
    
    [DllImport("advapi32.dll", SetLastError = true)]
    internal static extern bool LookupPrivilegeValue(string host, string name,ref long pluid);
    
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    internal struct TokPriv1Luid {
        public int Count;
        public long Luid;
        public int Attr;
    }

    internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
    internal const int TOKEN_QUERY = 0x00000008;
    internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;

    public static bool EnablePrivilege(long processHandle, string privilege) {
        bool retVal;
        TokPriv1Luid tp;
        IntPtr hproc = new IntPtr(processHandle);
        IntPtr htok = IntPtr.Zero;
        retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
        tp.Count = 1;
        tp.Luid = 0;
        tp.Attr = SE_PRIVILEGE_ENABLED;
        retVal = LookupPrivilegeValue(null, privilege, ref tp.Luid);
        retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
        return retVal;
    }
}
'@
    $ProcessHandle = (Get-Process -id $pid).Handle
    $type = Add-Type $definition -PassThru
    $type[0]::EnablePrivilege($processHandle, $Privilege)
}

function New-RegistryAccessRule {
    param(
        # https://learn.microsoft.com/en-us/dotnet/api/system.security.principal.identityreference?view=net-7.0
        [PSObject]
        $Identity,

        # https://learn.microsoft.com/en-us/dotnet/api/system.security.accesscontrol.registryrights?view=net-7.0
        [PSObject]
        $RegistryRights,
        
        # https://learn.microsoft.com/en-us/dotnet/api/system.security.accesscontrol.inheritanceflags?view=net-7.0
        [PSObject]
        $InheritanceFlags,
        
        # https://learn.microsoft.com/en-us/dotnet/api/system.security.accesscontrol.propagationflags?view=net-7.0
        [PSObject]
        $PropagationFlags,

        # https://learn.microsoft.com/en-us/dotnet/api/system.security.accesscontrol.accesscontroltype?view=net-7.0
        [PSObject]
        $Type
    )

    process {
        if ($Identity -is [string]) {
            # Identity passed-in is a SID
            if ($Identity.StartsWith("S-")) {
                $Identity = [System.Security.Principal.SecurityIdentifier]$Identity
            
            # Identity passed-in is am Account Name
            } else {
                $Identity = [System.Security.Principal.NTAccount]$Identity
            }
        }
        if ($RegistryRights -is [string]) {
            $RegistryRights = [System.Security.AccessControl.RegistryRights]$RegistryRights
        }
        if ($InheritanceFlags -is [string]) {
            $InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]$InheritanceFlags
        }
        if ($PropagationFlags -is [string]) {
            $PropagationFlags = [System.Security.AccessControl.PropagationFlags]$PropagationFlags
        }
        if ($Type -is [string]) {
            $Type = [System.Security.AccessControl.AccessControlType]$Type
        }

        $registryAccessRule = New-Object -TypeName System.Security.AccessControl.RegistryAccessRule -ArgumentList $Identity, $RegistryRights, $InheritanceFlags, $PropagationFlags, $Type

        return $registryAccessRule
    }
}

try {
    do {} until (Enable-Privilege SeTakeOwnershipPrivilege)
} catch {
    Write-Host "Unable to adjust token privileges via Windows API Interop. Caught UnauthorizedAccessException: $_"
    $_.Exception
}

$registryKey = $null
try {
    $registryKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes", "ReadWriteSubTree", "TakeOwnership")
    $registryKeySecurityAcl = $registryKey.GetAccessControl([System.Security.AccessControl.AccessControlSections]::Owner)

    try {
        # Set Owner to the "Administrators" NTAccount
        $administratorsPrincipal = [System.Security.Principal.NTAccount]"Administrators"
        $registryKeySecurityAcl.SetOwner($administratorsPrincipal)
        $registryKey.SetAccessControl($registryKeySecurityAcl)
    } catch {
        Write-Host "Failed to change the owner on registry key. Caught UnauthorizedAccessException: $_"
        $_.Exception
    }
    
    try {
        # Add a "Full Control" Access Rule for Administrator
        $registryAccessRule = New-RegistryAccessRule "Administrators" "FullControl" "ContainerInherit" "None" "Allow"
        $registryKeySecurityAcl.AddAccessRule($registryAccessRule)
        $registryKey.SetAccessControl($registryKeySecurityAcl)
    } catch {
        Write-Host "Failed to add new access rule to registry key. Caught UnauthorizedAccessException: $_"
        $_.Exception
    }
    
    try {
        # Update the "When plugged in, turn off my screen after" duration setting
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes\381b4222-f694-41f0-9685-ff5bb260df2e\7516b95f-f776-4464-8c53-06167f40cc99\3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e" -Name "ACSettingIndex" -Value 300
    } catch {
        Write-Host "Failed to change value of registry key. Caught UnauthorizedAccessException: $_"
        $_.Exception
    }
    
    try {
        # Remove the "Full Control" Access Rule for Administrator
        $registryKeySecurityAcl.RemoveAccessRule($registryAccessRule)
        $registryKey.SetAccessControl($registryKeySecurityAcl)
    } catch {
        Write-Host "Failed to remove new access rule from registry key. Caught UnauthorizedAccessException: $_"
        $_.Exception
    }
    
    try {
        # Set Owner back to the "NT AUTHORITY\SYSTEM" SID
        $localSystemSID = [System.Security.Principal.SecurityIdentifier]::new([System.Security.Principal.WellKnownSidType]::LocalSystemSid, $null)
        $registryKeySecurityAcl.SetOwner($localSystemSID)
        $registryKey.SetAccessControl($registryKeySecurityAcl)
    } catch {
        Write-Host "Failed to change the owner back on registry key. Caught UnauthorizedAccessException: $_"
        $_.Exception
    }
} catch {
    Write-Host "Unable to open Registry sub-key and acquire access control list. Caught UnauthorizedAccessException: $_"
    $_.Exception
    
} finally {
    # Close the Registry Key
    if ($registryKey) {
        $registryKey.Close()
    }
}
