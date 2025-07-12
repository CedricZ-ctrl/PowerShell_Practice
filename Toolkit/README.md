# Toolkit.ps1

## Description

This PowerShell script creates a predefined directory tree structure on your system.  
It checks if each folder exists and creates any missing directories along with a default `Readme.txt` file in each.  
The script logs all actions and any errors encountered during execution.

---

## Features

- Creates a set of folders under `C:\ToolKit` including subfolders like `UserData`, `Scripts`, `Backup`, etc.
- Automatically adds a `Readme.txt` file to each created directory.
- Logs every creation attempt, success, or failure with timestamps and event levels.
- Handles errors gracefully using try-catch blocks, logging warnings if directory creation fails.

---

## Usage

1. **Modify folder paths if needed**  
   Adjust the `$Directory` array in the script to add, remove, or change the directories you want to create.

2. **Run the script with appropriate permissions**  
   Make sure to run the script with sufficient privileges to create folders on the system drive.

3. **Check logs**  
   Logs are saved in the folder specified by `$LogDirectory` and file `$logfilepath`. Review logs for success or error details.

---

## Logging

- Logs contain timestamped entries with event types such as `INFO`, `WARNING`, and `ERROR`.
- The script ensures the log folder and file exist or creates them if missing.

---

## Example Directory Structure Created

