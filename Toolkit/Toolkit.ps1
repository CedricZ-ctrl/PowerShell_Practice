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


#Path LogDirectory\ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$LogDirectory ="B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\ToolKit"

# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
 $logfilepath = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\ToolKit\LogFile.txt"



#==================================================================================================================
# FUNCTION DECLARATION
#==================================================================================================================
#
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

    
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
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

SetDirectory 



#======================================================================================================================
# END OF SCRIPT
#======================================================================================================================
