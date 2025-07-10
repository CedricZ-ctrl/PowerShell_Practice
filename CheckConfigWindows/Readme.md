# CheckConfigWindows.ps1

## Description

PowerShell administration script to check the general configuration of a Windows workstation:

- System inventory (BIOS, processor, model, domain)
- Check IP addresses on Ethernet interfaces
- Verify and automatically start critical services (DHCP, Windows Update)
- Generate a JSON report with collected information
- Full logging management in a dedicated log file

---

## Requirements

- Windows PowerShell (version 5.1 recommended or PowerShell Core)
- Administrator rights to run the script
- Write access configured for logs and JSON output files

---
