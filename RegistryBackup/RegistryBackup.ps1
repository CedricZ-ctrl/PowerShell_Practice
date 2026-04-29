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

## #check if Directory is not present \COPY AND PASTE, YOUR LOGFILE
$LogDirectory = Join-Path -Path $env:ProgramData -ChildPath "LogsScriptPerso"

# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$logfilepath = Join-Path -Path $LogDirectory -ChildPath "RegistryBackup.log"


#path backup registry example 
$RegDir = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\RegistryBackup\Backup"
$RegFile = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\RegistryBackup\Backup\CPU-Z.reg"

#Set your path keyregistry if you need,here example CPU-Z
$REGEXPORT = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\CPUID CPU-Z_is1"


#==================================================================================================================
# FUNCTION DECLARATION
#==================================================================================================================
#
function HeaderLog {
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    if (!(Test-Path -Path $LogDirectory)){
        New-Item -Path $LogDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    }
    Add-Content $LogFilePath -Value "============================================================="
    Add-Content $LogFilePath -Value "START SCRIPT: RegistryBackup.ps1" -Force
    Add-Content $LogFilePath -Value "============================================================="
    Add-Content $LogFilePath -Value "Date : $($timestamp)"
    Add-Content $LogFilePath -Value "============================================================="
}
# this function write-log, write informations of du script  in $logfilepath and $LogDirectory with date and hours 
function Write-log {
    param(
        [string]$Message,
        [string]$Event
    )
    if (!(Test-Path -Path $LogDirectory)) {
        New-Item -Path $LogDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue | out-null
    }

    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
}

function EndLog {
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content $logfilepath -value "============================================================" 
    Add-Content $logfilepath -Value "END SCRIPT "
    Add-Content $logfilepath -Value "Date : $($timestamp):"
    Add-Content $logfilepath -Value "============================================================"
}
    

function ExportReg {
    try {
        if (!(Test-Path -Path $RegDir)) {
            New-Item -Path $RegDir -ItemType Directory -Force -ErrorAction SilentlyContinue | out-null
        }
        if (!(Test-Path $RegFile)){
        reg export $REGEXPORT $RegFile /y
        $Message ="the backup of the key registry $REGEXPORT save in : $RegDir"
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

            & reg import $RegFile
            $Message = "Registry restored from :$Regfile"
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
HeaderLog
switch ($Choice)
 {
    "Export" { ExportReg }
    "Import" { ImportReg }
    Default { Write-Host " invalid choice, exiting script"}
}
EndLog
#======================================================================================================================
# END OF SCRIPT
#======================================================================================================================