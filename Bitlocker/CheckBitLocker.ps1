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
$logfilepath = "$LogDirectory\LogFile.txt"

#Here it's a variable for tested the differents value of switch (line 61) just modify the variable with values next : 
# "EncryptionInProgress","FullyEncrypted" or "FullyDecrypted"
# don't forget change testdisk by statedisk to tested
$statedisk = "EncryptionInProgress" # fore exemple

#date time 
$timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"

#==================================================================================================================
# FUNCTION DECLARATION
#==================================================================================================================
function HeaderLog {
    if (!(Test-Path -Path $LogDirectory)){
        New-Item -Path $LogDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    }
    Add-Content $LogFilePath -Value "============================================================="
    Add-Content $LogFilePath -Value "START SCRIPT: CheckBitLocker.ps1" -Force
    Add-Content $LogFilePath -Value "============================================================="
    Add-Content $LogFilePath -Value "Date : $($timestamp)"
    Add-Content $LogFilePath -Value "============================================================="
}


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
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
}
function EndLog {
    if (!(Test-Path -Path $LogDirectory)) {
        New-Item -Path $LogDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue | out-null
    }
    Add-Content $logfilepath -value "============================================================" 
    Add-Content $logfilepath -Value "   END SCRIPT "
    Add-Content $logfilepath -Value "Date : $($timestamp):"
    Add-Content $logfilepath -Value "============================================================"
}

function testdisk ()   {    
    $checkstatus = (Get-BitLockerVolume -MountPoint "C:" | select VolumeStatus).VolumeStatus
    return $checkstatus
}

#==================================================================================================================
# MAIN 
#==================================================================================================================
HeaderLog 

switch (testdisk) {

"EncryptionInProgress" {
    $ExitCode = 2
    $Message = "The Disk is in progress encryption,ExitCode:$($ExitCode)"
    Write-log -Message $Message -Event "Warning"
}

"FullyEncrypted" {
    $ExitCode = 0
    $Message = "The Disk is Completly Crypted:$($ExitCode):"
    Write-log -Message $Message -Event "Success"

}

 "FullyDecrypted" {
    $ExitCode = 3
    $Message = "The disk is not encrypted ExitCode:$($ExitCode)"
    Write-log -Message $Message -Event "Error"
}

}

Endlog

exit

#======================================================================================================================
# END OF SCRIPT
#======================================================================================================================
