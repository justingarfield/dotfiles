
# Source the required functions and helpers
# . ..\..\TimeAndDurationConstants.ps1

enum PowerOptionDurationTypes {
    Never = 0
    OneMinute = 60
    TwoMinutes = 120
    ThreeMinutes = 180
    FiveMinutes = 300
    TenMinutes = 600
    FifteenMinutes = 900
    TwentyMinutes = 1200
    TwentyFiveMinutes = 1500
    ThirtyMinutes = 1800
    FortyFiveMinutes = 2700
    OneHour = 3600
    TwoHours = 7200
    ThreeHours = 10800
    FourHours = 14400
    FiveHours = 18000
}

enum PowerModeTypes {
    BestPowerEfficiency = -1
    Balanced = 0
    BestPerformance = 1
}

function Blah {
    $AddACL = New-Object System.Security.AccessControl.RegistryAccessRule ("Domain Admins","FullControl","Allow")
    $owner = [System.Security.Principal.NTAccount]"Administrators"

    $keyCR = [Microsoft.Win32.Registry]::ClassesRoot.OpenSubKey("CLSID\{76A64158-CB41-11D1-8B02-00600806D9B6}",[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,[System.Security.AccessControl.RegistryRights]::takeownership)
    # Get a blank ACL since you don't have access and need ownership
    $aclCR = $keyCR.GetAccessControl([System.Security.AccessControl.AccessControlSections]::None)
    $aclCR.SetOwner($owner)
    $keyCR.SetAccessControl($aclCR)

    # Get the acl and modify it
    $aclCR = $keyCR.GetAccessControl()
    $aclCR.SetAccessRule($AddACL)
    $keyCR.SetAccessControl($aclCR)
    $keyCR.Close()
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

function Set-TurnOffScreenAfter {
    param(
        [Parameter(Mandatory=$true)]
        [PowerOptionDurationTypes]
        $PowerOptionDurationType
    )

    $powerOptionDurationTypeValue = [int]([PowerOptionDurationTypes]::$PowerOptionDurationType)

    $regKey = "SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes\381b4222-f694-41f0-9685-ff5bb260df2e\7516b95f-f776-4464-8c53-06167f40cc99\3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e"
    do {} until (Enable-Privilege SeTakeOwnershipPrivilege)
    $key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($regKey, 'ReadWriteSubTree', 'ChangePermissions')
    $acl = $key.GetAccessControl()

    $domain = $Env:USERDOMAIN
    $computerName = $Env:COMPUTERNAME
    if ($domain -eq $computerName) {
        $administratorsGroup = Get-LocalGroup -Name "Administrators"
        $rule = New-Object System.Security.AccessControl.RegistryAccessRule($administratorsGroup, "FullControl","Allow")
        $rule | Format-List
        $acl.SetAccessRule($rule)
    } else {
        $rule = New-Object System.Security.AccessControl.RegistryAccessRule("$domain\\Domain Admins","FullControl","Allow")
        $rule | Format-List
        $acl.SetAccessRule($rule)
    }
    
    $key.SetAccessControl($acl)

    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Power\User\PowerSchemes\381b4222-f694-41f0-9685-ff5bb260df2e\7516b95f-f776-4464-8c53-06167f40cc99\3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e" -Name "ACSettingIndex" -Value $powerOptionDurationTypeValue
}

function Set-PutDeviceToSleepAfter {
    param(
        [Parameter(Mandatory=$true)]
        [PowerOptionDurationTypes]
        $PowerOptionDurationType
    )

    $powerOptionDurationTypeValue = [int]([PowerOptionDurationTypes]::$PowerOptionDurationType)

    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Power\User\PowerSchemes\381b4222-f694-41f0-9685-ff5bb260df2e\238c9fa8-0aad-41ed-83f4-97be242c8f20\29f6c1db-86da-48c5-9fdb-f2b67b1f44da" -Name "ACSettingIndex" -Value $powerOptionDurationTypeValue
}

function Set-PowerMode {
    param(
        [Parameter(Mandatory=$true)]
        [PowerModeTypes]
        $PowerModeType
    )

    $powerModeTypeValue = "00000000-0000-0000-0000-000000000000" # Balanced
    switch ($PowerModeType) {
        BestPowerEfficiency { $powerModeTypeValue = "961cc777-2547-4f9d-8174-7d86181b8a7a" }
        Balanced { break }
        BestPerformance { $powerModeTypeValue = "ded574b5-45a0-4f42-8737-46345c09c238" }
    }

    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Power\User\PowerSchemes" -Name "ActiveOverlayAcPowerScheme" -Value $powerModeTypeValue
}
