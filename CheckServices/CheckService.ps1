
#######################################################################################
# Script : check_services_status.ps1
# Description : This script checks the status of specified services (wuauserv, Spooler, Dhcp).
#               If a service is stopped, it attempts to start it and logs the action.
#               If the service is already running, it logs that the service is running.
#               If the service is in an unknown state, it logs a warning.
# Author : Cédric Zapart
# Date Created : 30/11/2024
# Last Modified : N/A
# License : MIT (Optional - Adjust as needed)
# Version : 1.0
#######################################################################################

# The script monitors the status of a list of services (wuauserv, Spooler, Dhcp) and performs the following:
# - If the service is running, logs the status as "Running."
# - If the service is stopped, it starts the service and logs the action.
# - If the service is in an unknown state, logs a warning.
# All actions are logged into a specified log file with timestamps.

# Log generation and log path
#######################################################################################

function Write-log {
    param(
        [string]$Message,
        [string]$Event
    )
    # Path logs\ MODIFY THE PATH TO SUIT  FOR YOUR NEED
    $logfilepath = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\CheckServices\LogFile.txt"
    
    #check if path log is not present \COPY AND PASTE, YOUR LOGFILE
    if (!(Test-Path -Path "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\CheckServices")) {
        New-Item -ItemType Directory -Path "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\CheckServices" -Force
    }
    if (!(Test-Path -Path $logfilepath)) {
        New-Item -ItemType File -Path $logfilepath -Force
    }

    #Add a message and event in your log
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
}


# List of services to check
#######################################################################################

    $listservices = "wuauserv","Spooler","Dhcp"

    foreach ($services in $listservices) {
        Try{
            $serviceStatus = get-service -Name $services

            if ($serviceStatus.Status -eq "Running") {
                $Message = "Service '$services' is already Running"
                Write-log -Event "INFO" -Message $Message
            }
            elseif ($serviceStatus.Status -eq "Stopped") {
                Start-Service -Name $services
                $Message = "Servce '$services' was stopped and now he's started"
                Write-log -Event "INFO" -Message $Message
            }
            else {
                $Message = " Service '$services' is an unknow state : $($serviceStatus.Status)"
                write-log -Event "WARNING" -Message $Message
            }
        }
        catch {
            $Message = "Service '$service' could not be found or started. Error: $_"
            Write-log -Message $Message -Event "ERROR"
        }
    }
    exit 