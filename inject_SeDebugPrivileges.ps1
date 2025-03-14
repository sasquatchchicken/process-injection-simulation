Write-Host "[+] Checking for SeDebugPrivilege..." -ForegroundColor Cyan

# Run whoami /priv and filter output properly
$privileges = whoami /priv | Select-String "SeDebugPrivilege"

if ($privileges -and ($privileges -match "Enabled")) {
    Write-Host "[+] SeDebugPrivilege detected and enabled! Injecting into SYSTEM process..." -ForegroundColor Green
    
    # Get the winlogon process
    $process = Get-Process -Name "winlogon" -ErrorAction SilentlyContinue
    if ($process) {
        $processId = $process.Id  # Renamed from $pid to avoid conflict with the automatic variable
        Write-Host "[+] Attaching to winlogon.exe (PID: $processId)" -ForegroundColor Yellow

        # Simulate shellcode injection (for testing purposes only)
        $code = [System.Text.Encoding]::UTF8.GetBytes("Insert_Malicious_Shellcode_Here")
        $processHandle = [System.Diagnostics.Process]::GetProcessById($processId).Handle  # Get the process handle

        # Allocate memory in the target process
        $memory = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($code.Length)
        Write-Host "[+] Allocated memory in target process at address: $($memory.ToString("X"))" -ForegroundColor Yellow

        # Copy shellcode into the allocated memory
        [System.Runtime.InteropServices.Marshal]::Copy($code, 0, $memory, $code.Length)
        Write-Host "[+] Copied shellcode into target process memory." -ForegroundColor Yellow

        # Simulate writing to the target process using the process handle
        Write-Host "[+] Using process handle to interact with target process..." -ForegroundColor Yellow
        Write-Host "[+] Process handle: $processHandle" -ForegroundColor Yellow

        # Simulate executing the shellcode (for demonstration purposes)
        Write-Host "[+] Simulating execution of shellcode in target process..." -ForegroundColor Green
        
        # Free the allocated memory (cleanup)
        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($memory)
        Write-Host "[+] Freed allocated memory in target process." -ForegroundColor Yellow

        Write-Host "[+] Payload injected into winlogon.exe!" -ForegroundColor Green
    } else {
        Write-Host "[!] winlogon.exe process not found." -ForegroundColor Red
    }
} else {
    Write-Host "[!] SeDebugPrivilege not enabled. Skipping injection." -ForegroundColor Red
}
