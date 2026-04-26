#******************************************************************************************************************************
#                                                                                                                             *
# file : Toolkit.ps1                                                                                                          *
#                                                                                                                             *
# Version : 1.0                                                                                                               *
#                                                                                                                             *
# Date : 09/12/2024                                                                                                           *
#                                                                                                                             *
# Description : this script create an tree structure, Improvements to come                                                    *
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
$logfilepath = Join-Path -Path $LogDirectory -ChildPath "ToolKit.log"

#==================================================================================================================
# FUNCTION DECLARATION
#==================================================================================================================
function HeaderLog {
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    if (!(Test-Path -Path $LogDirectory)){
        New-Item -Path $LogDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    }
    Add-Content $LogFilePath -Value "============================================================="
    Add-Content $LogFilePath -Value "START SCRIPT: ToolKit.ps1" -Force
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
# this function create tree structure if latter don't created or if Directory is missing and  write informations in log with function write log
function SetDirectory () {
try {
    $Directory = @("C:\ToolKit",
                   "C:\ToolKit\UserData",
                   "C:\ToolKit\UserData\Documents",
                   "C:\ToolKit\UserData\Download",
                   "C:\ToolKit\UserData\Logs",
                   "C:\ToolKit\Scripts",
                   "C:\ToolKit\Backup")

                   # this directory is a test for tested the catch in try-catch, this error generate is a permissions denied on systeme 32 of windows
                    # "C:\Windows\System32\testdir") 

foreach ($dir in $Directory) {
        if (!(Test-Path -Path $dir)) {
            New-Item -Path $dir -ItemType Directory -ErrorAction Stop -Force
             New-Item -Path $dir -ItemType File -Name Readme.txt -ErrorAction Stop -Force

            $Message = "Creating missing directories : $dir "
            Write-log -Event "INFO" -Message $Message
        
    
        } else {
        $Message = "All directory already : $dir "
        Write-log -Event "INFO" -Message $Message
        
        }
    }
} catch {
    $ExitCode = 1
    $Message = "Failed during creating directory : $dir : Exitcode: $($ExitCode) : $_"
    Write-log -Event "WARNING" -Message $Message
        }
    }


#==================================================================================================================
# MAIN 
#==================================================================================================================


HeaderLog
try{

    SetDirectory
    EndLog
}
catch {
     $ExitCode = 1
     $Message = "$_"
     Write-log -Event "ERROR" -Message $Message
    
    
}

#======================================================================================================================
# END OF SCRIPT
#======================================================================================================================
