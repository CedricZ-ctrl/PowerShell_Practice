# CheckProcess.ps1

## Description

This PowerShell script checks if one or more specific processes are running on the machine.  
If any process is stopped, the script attempts to restart it automatically.

The script maintains a detailed log file that records all actions and events (process detection, restarts, errors, etc.).

---

## Features

- Checks the presence of processes defined in the `$NameProcess` variable.  
- Automatically starts stopped processes.  
- Handles errors with appropriate logging.  
- Automatically creates log folders and files if they do not exist.  
- Timestamped logs with event levels (`INFO`, `WARNING`, `ERROR`).

---

## Usage

1. **Modify the list of processes**  
   Set the names of the processes to monitor in the `$NameProcess` variable.  
   Example:  
   ```powershell
   $NameProcess = "PuTTY", "Notepad++"
