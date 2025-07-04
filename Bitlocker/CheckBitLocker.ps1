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

function checkBitlockerV1  {   
try {
    $checkstatus = Get-BitLockerVolume | Where-Object {$_.VolumeStatus -like "FullyDecrypted"}
    
    foreach ($State in $checkstatus){
        if ($State.VolumeStatus -eq "FullyDecrypted"){

            $Message = "the disk $($State.MountPoint) : is $($State.VolumeStatus)"
            Write-log -Event "INFO" -Message $Message
            Start-sleep -Seconds 5
            
            $ActiveBitlocker = Enable-BitLocker -MountPoint $State.MountPoint -EncryptionMethod XtsAes256 -UsedSpaceOnly -TpmProtector
            $RecoveryKey = Add-BitLockerKeyProtector -MountPoint $State.MountPoint -RecoveryPasswordProtector
            $RecoveryPass = $RecoveryKey.RecoveryPasswd
            $mountRaw = $State.MountPoint
            $mountSafe = $mountRaw -replace ':','-'
            $outputPath = "C:\Windows\tmp\bitlocker-recovery-$mountSafe.txt" 

            $RecoveryPass | Out-File -FilePath $outputPath -Encoding  utf8

            $Message = "Encryption started for $($State.MountPoint). Recovery Key saved in $outputPath"
            Write-log -Event "INFO" -Message $Message
        }
        else {
            $Message = "Encryption started for $($State.MountPoint). Recovery key saved in $outputPath"
            Write-log -Event "INFO" -Message $Message
        }
    }
    
}
catch {
    $Message = " :$_"
    Write-log -Event "ERROR" -Message $Message
} 
    
}

function EnableBitlocker {

}


#==================================================================================================================
# MAIN 
#==================================================================================================================
HeaderLog 
checkBitlockerV1
Endlog


#======================================================================================================================
# END OF SCRIPT
#======================================================================================================================
