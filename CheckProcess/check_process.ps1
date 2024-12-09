#***************************************************************************************************************
#                                                                                                              *
# file : check_process.ps1                                                                                     *
#                                                                                                              *
# Version : 1.0                                                                                                *
#                                                                                                              *
# Date : 09/12/2024                                                                                            *
#                                                                                                              *
# Description : Check if this process is in running or stopped, and restart the process if stopped             *       
#                                                                                                              *
#***************************************************************************************************************

# ======================================================================================
#  VARIABLE DECLARATIONS                                                               
#=======================================================================================
#
# code exit initial
$ExitCode = 0

# #check if Directory is not present \COPY AND PASTE, YOUR LOGFILE
$LogDirectory = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\CheckProcess"

# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$logfilepath = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\CheckProcess\LogFile.txt"

# add process you want check \MODIFY NAME PROCESS TO SUIT FOR YOU NEED
$NameProcess = "PuTTY","Notepad++"

#==================================================================================================================
# FUNCTION DECLARATION
#==================================================================================================================
#
# this function write-log, write informations of du script  in $logfilepath and $LogDirectory with date and hours 
function Write-log {
    param(
        [string]$Message,
        [string]$Event
    )

    if (!(Test-Path -Path $LogDirectory)) {
        New-Item -ItemType Directory -Path $LogDirectory -Force
    }
    if (!(Test-Path -Path $logfilepath)) {
        New-Item -ItemType File -Path $logfilepath -Force
    }

    
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
}


#
# this function check if $NameProces is running or not, if not running so we start process, and write information in $logfilepath with the function Write-log
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
        Write-log -Event "WARNING" -Message $Message
    }
    }
}
}


#==================================================================================================================
# MAIN 
#==================================================================================================================

CheckProcess 

#======================================================================================================================
# END OF SCRIPT
#======================================================================================================================