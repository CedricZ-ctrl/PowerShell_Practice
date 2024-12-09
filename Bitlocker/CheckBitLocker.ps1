#****************************************************************************************
#                                                                                       *
# file : CheckBitlocker.ps1                                                             *
#                                                                                       *
# Version : 1.0                                                                         *
#                                                                                       *
# Date : 09/12/2024                                                                     *
#                                                                                       *
# Description : Check Status of Disk system "C:" if encrypted or no                     *
#                                                                                       *
#****************************************************************************************

# ======================================================================================
#  VARIABLE DECLARATIONS                                                               
#=======================================================================================
# 
# code exit initial
$ExitCode = 0

# #check if Directory is not present \COPY AND PASTE, YOUR LOGFILE
$LogDirectory = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\Bitlocker\Logs_Bitlocker"

# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$logfilepath = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\Bitlocker\Logs_Bitlocker\LogFile.txt"

#variable for testing any state of disk in switch 
$statedisk = "EncryptionInProgress" # fore exemple

#==================================================================================================================
# FUNCTION DECLARATION
#==================================================================================================================
function Write-log {
    param(
        [string]$Message,
        [string]$Event
    )
    
    if (!(Test-Path -Path $LogDirectory )) {
        New-Item -ItemType Directory -Path $LogDirectory -Force
    }
    if (!(Test-Path -Path $logfilepath)) {
        New-Item -ItemType File -Path $logfilepath -Force
    }

    # Add a message and event in your log
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
}

#
function testdisk ()   {    
    $checkstatus = (Get-BitLockerVolume -MountPoint "C:" | select VolumeStatus).VolumeStatus
    return $checkstatus
}

#==================================================================================================================
# MAIN 
#==================================================================================================================


switch (testdisk) {

"EncryptionInProgress" {
    $ExitCode++
    $Message = "The Disk is in progress encryption,ExitCode:$($ExitCode)"
    Write-log -Message $Message -Event "Warning"
}

"FullyEncrypted" {
    $Message = "The Disk is Completly Crypted"
    Write-log -Message $Message -Event "Success"

}

 "FullyDecrypted" {
    $ExitCode++
    $Message = "The disk is not encrypted ExitCode:$($ExitCode)"
    Write-log -Message $Message -Event "Error"
}

}

exit $ExitCode++

#======================================================================================================================
# END OF SCRIPT
#======================================================================================================================