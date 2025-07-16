#***********************************************************************************************
#                                                                                              *
# file : CreateTaskSchedule.ps1                                                                *
#                                                                                              *
# Version : 1.0                                                                                *
#                                                                                              *
# Date : 15/07/2025                                                                            *
#                                                                                              *
# Description : Create Task Schedule for reinitialise the file .ini for KeepassXC              *
#                                                                                              *    
#***********************************************************************************************

# ======================================================================================
#  VARIABLE DECLARATIONS                                                               
#=======================================================================================
#
# code exit initial
$ExitCode = 0

## #check if Directory is not present \COPY AND PASTE, YOUR LOGFILE
$LogDirectory = "C:\Users\user1\Desktop\Script\Logs"
# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$logfilepath = "$LogDirectory\Log_TaskSchedule.txt"
# date time 
$timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"

#==================================================================================================================
# FUNCTION DECLARATION
#==================================================================================================================
#
function HeaderLog {
    if (!(Test-Path -Path $LogDirectory)){
        New-Item -Path $LogDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    }
    Add-Content $LogFilePath -Value "============================================================="
    Add-Content $LogFilePath -Value "START SCRIPT: Set Task Schedule" -Force
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

function CreateTaskSchedule {
try {
    # this script it's just false, use the script you want 
    $ScriptToUse = "C:\Users\user1\Desktop\Script\Test_Task_Schedule.ps1"
    $TaskName = "Reinit file .ini KeePassXC"

    # this action use the program powershell.exe for launch your script 
    $Action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument $ScriptToUse

    # Trigger ? At Logon of user
    $Trigger = New-ScheduledTaskTrigger -AtLogOn

    # this parameters it's just for laptop 
    $Setting = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries 

    # Create the scheduled task object by combining the defined action, trigger, and settings.
    $InputObject = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Setting 

    # Save your task scheduled 
    Register-ScheduledTask -TaskName $TaskName -InputObject $InputObject -User "System" -ErrorAction SilentlyContinue
    $Message = "the Task scheduled $($TaskName) : Created "
    Write-log -Event "INFO" -Message $Message
}
catch {
    $ExitCode = 1 
    $Message = "an error occurred in function CreatTaskSchedule"
    Write-log -Event "INFO" -Message $Message
}
   
}

function CheckIfTaskScheduleisPresent {
try {
    $KeePassXCTask = Get-ScheduledTask -TaskName "*.ini*" 
    if ($KeePassXCTask -match "Reinit file .ini KeePassXC") {
        $Message = "TaskSchedule for Reinit the file .ini KeePassXC: Ready "
        Write-log -Event "INFO" -Message $Message
    }
    else {
        CreateTaskSchedule
        $Message = "TaskName Reinit file .ini KeePassXC not present, creating task schedule ongoing . . ."
        Write-log -Event "INFO" -Message $Message
    }
}catch{
    $ExitCode = 1 
    $Message = "an error occurred in function CheckIfTaskScheduleisPresent "
    Write-log -Event "INFO" -Message $Message
}
}
# ======================================================================================
# MAIN SCRIPT EXECUTION
# =======================================================================================
try {
    HeaderLog
    
    CreateTaskSchedule
    CheckIfTaskScheduleisPresent
    
    EndLog
}
catch {
    Write-log -Event "ERROR" -Message $_.Exception.Message
}