#******************************************************************************************************************************
#                                                                                                                             *
# file : GetEvent.ps1                                                                                                         *
#                                                                                                                             *
# Version : 1.0                                                                                                               *
#                                                                                                                             *
# Date : 26/04/2026                                                                                                           *
#                                                                                                                             *
# Description : this script get all logs in error for Application,Security,Setup and System                                   *
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
$logfilepath = Join-Path -Path $LogDirectory -ChildPath "GetEventError.log"
# array of LogName 
$FilterTypeLog = @("Application","Security","Setup","System")
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
    Add-Content $LogFilePath -Value "START SCRIPT: GetEventError.ps1" -Force
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

function GetLogError {
    $GetLog = (Get-WinEvent -FilterHashtable @{
        LogName = $FilterTypeLog
        Level = 2
        StartTime = (Get-Date).AddDays(-5)
    })

    foreach ($TypeLog in $GetLog) {
        try {
            $MessageClean = $TypeLog.Message -replace "`n|`r", " "
            $Message = "ID:$($TypeLog.ID) Source:$($TypeLog.ProviderName) -Message:$($MessageClean)"
            Write-log -Event "ERROR" -Message $Message
        }
        catch {
            $ExitCode = 1 
            $Message = "$_ : ExitCode : $($ExitCode) "
            Write-log -Event "ERROR" -Message $Message
        }
    }

    
}
#==================================================================================================================
# MAIN
#==================================================================================================================
HeaderLog
GetLogError
EndLog
