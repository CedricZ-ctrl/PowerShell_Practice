#################### Check if hard disk is Encrypted ######################


# Creator : Zapart Cédric
# Date : 22/11/2024
# Target: check if hard disk is encrypted and generate a code error if disk is not encrypted.
##########################################################################################################################

# defined generate log and logpath 

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

#variable test
$statedisk = "FullyDecrypted"

#####
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
