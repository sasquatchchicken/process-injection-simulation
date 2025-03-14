# process-injection-simulation
This document provides an explanation of how PowerShell can be used for enumeration, reconnaissance, and a process injection simulation. It demonstrates how threat actors can use PowerShell to gather critical system information, identify high-value targets, and simulate the injection of malicious code into a system process.

Before performing process injection, threat actors often conduct enumeration and reconnaissance to gather information about the target system.
To list all processes running in **Session 0**, which is typically reserved for system services and processes running as SYSTEM threat actors can use this to identify high-value targets for privilege escalation or persistence.
```
Get-WmiObject Win32_Process | Where-Object { $_.SessionId -eq 0 } | Select-Object ProcessId, Name
```
**Enumerate All Processes with Session IDs**

Threat actors can use this to map out the system's process hierarchy and identify processes running in different user sessions.
```
Get-WmiObject Win32_Process | Select-Object ProcessId, Name, SessionId
```

**Check User Privileges**

Threat actors can use this to determine if they have the necessary privileges to perform process injection. *Note* if it is disabled it can be enabled!
```
whoami /priv
```
This PowerShell script **inject_SeDebugPrivileges.ps1** is designed to simulate the process of injecting shellcode into a target process (e.g., winlogon.exe) on a Windows system. It checks for the SeDebugPrivilege which is required to interact with and manipulate other processes, and demonstrates how a threat actor might use this privilege to inject malicious code into a system process.

Security teams can use this script to simulate process injection attacks and test their defenses. This script can be used as a template to develop more sophisticated malware that performs malicious process injection. Researchers can study the script to understand how process injection works and develop countermeasures.

**example output** 

these outputs are run on different targets.
```
[+] Processes Running with SeDebugPrivilege:

ProcessId Name         ExecutablePath
--------- ----         --------------
     1440 lsass.exe
    12572 winlogon.exe C:\WINDOWS\System32\WinLogon.exe
     8208 explorer.exe C:\WINDOWS\Explorer.EXE
```
```
[+] Checking for SeDebugPrivilege...
[+] SeDebugPrivilege detected and enabled! Injecting into SYSTEM process...
[+] Attaching memory in target process at address: 28F1B4D2990
[+} Copied shellcode into target process memory.
[+] Using process handle to interact with target process...
[+] Process handle: 2604
[+] Simulating execution of shellcode in target process...
[+] Freed allocated memory in target process.
[+] Payload injected into winlogon.exe!
```
## This script is for educational and testing purposes only.  Not responsible for your actions.
