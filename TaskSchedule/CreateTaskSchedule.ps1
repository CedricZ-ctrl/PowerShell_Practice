#******************************************************************************************************************************
#                                                                                                                             *
# file : CreateTaksSchedule.ps1                                                                                               *
#                                                                                                                             *
# Version : 1.0                                                                                                               *
#                                                                                                                             *
# Date : 01/03/2025                                                                                                           *
#                                                                                                                             *
# Description : this script create an TaskSchedule for running a script by examples                                           *
#                                                                                                                             *
#******************************************************************************************************************************

# =============================================================================================================================
#  VARIABLE DECLARATIONS                                                               
#==============================================================================================================================
#
# code exit initial
$ExitCode = 0

#Path LogDirectory\ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$LogDirectory ="B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\TaskSchedule"

# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
 $logfilepath = "$LogDirectory\LogTaskSchedule.txt"

# date time log 
$timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"

#===============================================================================================================================
# FUNCTION DECLARATION
#===============================================================================================================================
#

function HeaderLog {
    if (!(Test-Path -Path $LogDirectory)){
        New-Item -Path $LogDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    }
    Add-Content $LogFilePath -Value "============================================================="
    Add-Content $LogFilePath -Value "START SCRIPT: CreateTaskScheduel.ps1" -Force
    Add-Content $LogFilePath -Value "============================================================="
    Add-Content $LogFilePath -Value "Date : $($timestamp)"
    Add-Content $LogFilePath -Value "============================================================="
}
#this function write-log, write informations of du script  in $logfilepath and $LogDirectory with date and hours 
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
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
}

function EndLog {
    if (!(Test-Path -Path $LogDirectory)) {
        New-Item -Path $LogDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue | out-null
    }
    Add-Content $logfilepath -value "============================================================" 
    Add-Content $logfilepath -Value "END SCRIPT "
    Add-Content $logfilepath -Value "Date : $($timestamp):"
    Add-Content $logfilepath -Value "============================================================"
}

function CreateTaksSchedule {
    $ScriptToUse = "C:\Users\<USER>\ProgramData\Script\Script.ps1"

    # here choose you program you to want used, for example here it's PowerShell
    $Action =   New-ScheduledTaskAsction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument $ScriptToUse
    $Trigger = New-ScheduledTaskTrigger -AtLogOn 
    $Setting = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
    $InputObject = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Setting

    Register-ScheduledTask -TaskName "<give a name at your taskSchedule>" -InputObject $InputObject -User "System" -ErrorAction SilentlyContinue 
}
#===============================================================================================================================
# Main
#===============================================================================================================================
HeaderLog
try {
    CreateTaksSchedule
}
catch { 
   $ExitCode = 1
   $Message = "an error occurred $($ExitCode): $_ "
   Write-log -Event "ERROR" -Message $Message 
}
EndLog

#===============================================================================================================================
# END SCRIPT
#===============================================================================================================================

