# CreateTaskSchedule.ps1

## Description

This PowerShell script creates a scheduled task that runs a specified PowerShell script at user logon.  
It automatically sets up the task action, trigger, and settings, then registers the task under the SYSTEM account.

---

## Features

- Creates a scheduled task to run a PowerShell script at user logon.
- Uses the SYSTEM account with highest privileges.
- Allows the task to start even if running on battery power.
- Logs script execution and any errors in a customizable log file.

---

## Usage

1. **Modify the script path**  
   Edit the `$ScriptToUse` variable in the script to point to the PowerShell script you want to schedule.  
   Example:  
   ```powershell
   $ScriptToUse = "C:\Users\YourUsername\ProgramData\Script\Script.ps1"
