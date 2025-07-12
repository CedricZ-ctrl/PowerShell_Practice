# RegistryBackup.ps1

## Description

This PowerShell script allows you to create a backup of a specified Windows registry key or restore it from a backup file.  
The script supports two main operations: **Export** (backup) and **Import** (restore).

All actions and events are logged with timestamps in a log file for traceability.

---

## Features

- Export (backup) a registry key to a `.reg` file.
- Import (restore) the registry key from an existing `.reg` backup file.
- Automatic creation of necessary directories and log files.
- Detailed logging of all operations, errors, and statuses.
- Interactive prompt to choose between Export and Import operations.

---

## Usage

1. **Modify paths if necessary**  
   Update the following variables in the script to match your environment:
   - `$LogDirectory` — directory where logs are saved.  
   - `$RegDir` — directory where registry backups are stored.  
   - `$RegFile` — full path to the `.reg` backup file.

2. **Run the script**  
   Launch the script in PowerShell.  
   You will be prompted to enter your choice:  
