# CheckService.ps1

## Description

This PowerShell script checks if a list of specified Windows services are running.  
If any service is stopped, the script will attempt to start it automatically.

It logs all actions and events (service status, restarts, errors, etc.) in a detailed log file.

---

## Features

- Checks the status of services defined in the `$listservices` variable.  
- Automatically starts services that are stopped.  
- Logs informative messages, warnings, and errors with timestamps.  
- Creates log directories and files automatically if they do not exist.

---

## Usage

1. **Modify the list of services**  
   Specify the service names to monitor in the `$listservices` variable.  
   Example:  
   ```powershell
   $listservices = "wuauserv", "Spooler", "Dhcp", "Schedule"
