#######################################################################################
# Script : check_hard_disk_encryption.ps1
# Description : This script checks if the hard disk (C:) is encrypted using BitLocker.
#               It logs the status of the disk (Encrypted, Decrypted, or Encryption In Progress)
#               and generates an error code if the disk is not encrypted.
# Author : Cédric Zapart
# Date Created : 22/11/2024
# Last Modified : N/A
#######################################################################################

# The script checks the encryption status of the system drive (C:).
# It logs the status and increments an exit code depending on whether the disk is fully encrypted, 
# in the process of being encrypted, or fully decrypted.
# If the disk is not encrypted or in progress, it generates an error log.

# Log generation and log path
#######################################################################################

$ExitCode = 0
function Write-log {
    param(
        [string]$Message,
        [string]$Event
    )
    # Path logs
    $logfilepath = "B:\VSCode_Exercice\Logs_Bitlocker\LogFile.txt"
    
    #check if path log is not present
    if (!(Test-Path -Path "B:\VSCode_Exercice\Logs_Bitlocker")) {
        New-Item -ItemType Directory -Path "B:\VSCode_Exercice\Logs_Bitlocker" -Force
    }
    if (!(Test-Path -Path $logfilepath)) {
        New-Item -ItemType File -Path $logfilepath -Force
    }

    # Ajoute le message au fichier
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
}

#
function testdisk ()   {    
    $checkstatus = (Get-BitLockerVolume -MountPoint "C:" | select VolumeStatus).VolumeStatus
    return $checkstatus
}

#Test variable to simulate disk encryption status (For testing purposes)
$statedisk = "FullyDecrypted"


# Encryption status handling using switch-case
#######################################################################################
switch ($statedisk) {

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
    $Message = "Not informations for this disk,ExitCode:$($ExitCode)"
    Write-log -Message $Message -Event "Error"
}

}




# try {
# # this variable she's use for test any situation of return $checkstatus in conditions 
# #$crypted="EncryptionInProgress"

# if ((testdisk) -eq "FullyDecrypted")
#     {   
#         $Message = "CRITICAL :the disk is not encrypted please contact your administrator"
#         Write-log -Message $Message
#         throw $Message
#     }
#     ElseIF((testdisk) -eq "EncryptionInProgress")
#     {   
#         $Message = "WARNING:  the disk is in progress encryption "
#         Write-log -Message $Message
#         throw $Message
        
#     }
#     ElseIF ((testdisk) -eq "FullyEncrypted") {
#          Write-Output "Your disk is encrypted"       
#     }
# } catch {
#     $errormessage = "Error detected : $_"
#     Write-Output $errormessage
#     Write-log -Message $Message
# }
