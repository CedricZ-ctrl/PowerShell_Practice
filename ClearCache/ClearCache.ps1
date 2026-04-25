#***********************************************************************************************
#                                                                                              *
# file : ClearCache.ps1                                                                        *
#                                                                                              *
# Version : 1.0                                                                                *
#                                                                                              *
# Date : 14/01/2025                                                                            *
#                                                                                              *
# Description : ClearCache SystemComputer                                                      *
#                                                                                              *    
#***********************************************************************************************

# ======================================================================================
#  VARIABLE DECLARATIONS                                                               
#=======================================================================================
#
# code exit initial
$ExitCode = 0

## #check if Directory is not present \COPY AND PASTE, YOUR LOGFILE
$LogDirectory = Join-Path -Path $env:ProgramData -ChildPath "LogsScriptPerso"

# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$logfilepath = Join-Path -Path $LogDirectory -ChildPath "LogClearCache.log"

# list service name do you want check \ MODIFY THE NAME SERVICE TO SUIT FOR YOU NEED
$PathTemp = @("C:\Windows\Temp","$env:TEMP")

#==================================================================================================================
# FUNCTION DECLARATION
#==================================================================================================================
#

function HeaderLog {
    if (!(Test-Path -Path $LogDirectory)){
        New-Item -Path $LogDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    }
    Add-Content $LogFilePath -Value "============================================================="
    Add-Content $LogFilePath -Value "START SCRIPT: ClearCache.ps1" -Force
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
    Add-Content $logfilepath -value "============================================================" 
    Add-Content $logfilepath -Value "END SCRIPT "
    Add-Content $logfilepath -Value "Date : $($timestamp):"
    Add-Content $logfilepath -Value "============================================================"
}

function GetInfoContentDirectory {
    try {
        foreach ($Path in $PathTemp) {
            if (Test-Path $Path) {
                $CountItem = Get-ChildItem -Path $Path -Recurse | Measure-Object | Select-Object -ExpandProperty Count
                $Message = "Us have found :$($CountItem) item in the path  $Path"
                Write-log -Event "INFO" -Message $Message

                Remove-Item -Path $Path -Recurse -ErrorAction SilentlyContinue 
                $Message = "$($CountItem) deleted in the path $Path "
                Write-log -Event "INFO" -Message $Message
            }
            else {
                $Message = "The path $Path doesn't exists"
                Write-log -Event "WARNING" -Message $Message
            }
        }
    }
    catch {
        $ExitCode = 1
        $Message = "$_"
        Write-log -Event "ERROR" -Message $Message
    }
}

#==================================================================================================================
# MAIN 
#==================================================================================================================

try{
    HeaderLog
    GetInfoContentDirectory
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
