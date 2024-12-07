#######################################################################################
# Script : check_process_and_kill.ps1
# Description : This script checks if specified processes are running or stopped.
#               It logs the status of each process into a log file.
#               If a process is found, it logs an info message; if not, it logs a warning.
#               Additionally, it can be modified to kill processes if needed.
# Author : Cédric Zapart
# Date Created : 01/12/2024
# Last Modified : N/A
#
#######################################################################################

# The script monitors processes ("PuTTY", "Notepad++" BUT you can define the processes to you want  ) to determine their running status.
# If a process is running, the script logs an info message.
# If a process is not running, the script logs a warning message.
# The script can be further extended to kill the processes if desired.

# Settings for logging
#######################################################################################


function Write-log {
    param(
        [string]$Message,
        [string]$Event
    )
    # Path logs
    $logfilepath = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\CheckProcess\LogFile.txt"
    
    #check if path log is not present
    if (!(Test-Path -Path "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\CheckProcess")) {
        New-Item -ItemType Directory -Path "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\CheckProcess" -Force
    }
    if (!(Test-Path -Path $logfilepath)) {
        New-Item -ItemType File -Path $logfilepath -Force
    }

    # Ajoute le message au fichier
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
}



$NameProcess = "PuTTY","Notepad++"

function CheckProcess () {
    
      $processrunning = (Get-Process -Name $NameProcess -ErrorAction SilentlyContinue | select ProcessName).ProcessName
      
    foreach ($process in $NameProcess) {

        if($processrunning -contains $process) {
    $Message = "Process is running : $process"
    Write-log -Event "INFO" -Message $Message

} else {
    
    $Message = "Not found $process, starting now ... "
    Write-log -Event "WARNING" -Message $Message
    
    try {
        Start-Process $process 
        Start-Sleep -Seconds 1 

        if(Get-Process $process -ErrorAction SilentlyContinue) {
        
            $Message = " The Process  $process has started ! "
            Write-log -Event "INFO" -Message $Message

        } else {

            $Message = "failed to start $process check exit code for more informations"
            Write-log -Event "WARNING" -Message $Message

         }

    } catch {
        $Message = "failed to start $process check exit code for more informations"
        write-loge -Event "WARNING" -Message $Message
    }
    }
}
}

CheckProcess 

exit 