#******************************************************************************************************************************
#                                                                                                                             *
# file : RegistryBackup.ps1                                                                                                  *
#                                                                                                                             *
# Version : 1.0                                                                                                               *
#                                                                                                                             *
# Date : 18/12/2024                                                                                                           *
#                                                                                                                             *
# Description : The goal of this script is create a registry backup of you choice
#                                                                                                                             *
#******************************************************************************************************************************

# ======================================================================================
#  VARIABLE DECLARATIONS                                                               
#=======================================================================================
#
# code exit initial
$ExitCode = 0

# #check if Directory is not present \COPY AND PASTE, YOUR LOGFILE
$LogDirectory = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\RegistryBackup\"

# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$logfilepath = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\RegistryBackup\LogFile.txt"

#path backup registry 
$RegFile = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\RegistryBackup\Notepad.reg"

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

    # add a message and event in your log
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
}


function ExportReg {
    try {
        if (!(Test-Path -Path $RegFile)) {

         # choose the key registry you need 
        reg export HKLM\SOFTWARE\Microsoft\Notepad $RegFile
        $Message ="the backup of the key registry $RegFile is create"
        Write-log -Event "INFO" -Message $Message
    }
    else {
        $Message ="Backup Registry already present"
        Write-log -Event "INFO" -Message $Message
    }
}
 catch {
        $ExitCode = 1
        $Message ="an error occured in creating $RegFile : $($ExitCode): $_"
        Write-log -Event "WARNING" -Message $Message
        }
    }



function ImportReg {
    try {
        if (Test-Path -Path $RegFile) {
           reg import $RegFile
            $Message = "Registry restored from : $RegFile"
            Write-log -Event "INFO" -Message $Message
        }
        else {
            $Message ="Backup File registry not found in: $RegFile "
            Write-log -Event "ERROR" -Message $Message
        }
    }
    catch {
        $ExitCode = 2
        $Message ="An error occurred in restoring the registry : $($ExitCode): $_ "
        Write-log -Event "WARNING" -Message $Message
    } 
}

$Choice = Read-Host "What do you want ? Import or Export ?"



#==================================================================================================================
# MAIN 
#==================================================================================================================
switch ($Choice)
 {
    "Export" { ExportReg }
    "Import" { ImportReg }
    Default { Write-Host " invalid choice, exiting script"}
}

#======================================================================================================================
# END OF SCRIPT
#======================================================================================================================