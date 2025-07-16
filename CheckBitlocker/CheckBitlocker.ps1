#****************************************************************************************
#                                                                                       *
# file : CheckBitlocker.ps1                                                             *
#                                                                                       *
# Version : 2.0                                                                         *
#                                                                                       *
# Date : 05/07/2025                                                                     *
#                                                                                       *
# Description : Check and enable BitLocker on C:, saving recovery key in a log file.   *
#                                                                                       *
#****************************************************************************************

# ======================================================================================
# VARIABLE DECLARATIONS                                                               
#=======================================================================================
#
# Directory and file log 
$LogDirectory = "C:\Users\<YourUser>\Desktop\Script\Logs"
$LogFilePath = "$LogDirectory\LogBitLocker.txt"
#
# Date today
$timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
#
# Path destination of "bitlocker-recovery" 
$outputPath = "C:\Windows\Temp\bitlocker-recovery.txt"

# ======================================================================================
# FUNCTION DECLARATIONS                                                               
# ======================================================================================

function HeaderLog {
    if (!(Test-Path -Path $LogDirectory)){
        New-Item -Path $LogDirectory -ItemType Directory -Force | Out-Null
    }
    Add-Content $LogFilePath -Value "============================================================="
    Add-Content $LogFilePath -Value "START SCRIPT: CheckBitLocker.ps1"
    Add-Content $LogFilePath -Value "============================================================="
    Add-Content $LogFilePath -Value "Date : $timestamp"
    Add-Content $LogFilePath -Value "============================================================="
}

function Write-Log {
    param([string]$Message, [string]$Event)
    Add-Content -Path $LogFilePath -Value "[$(Get-Date -Format 'dd/MM/yyyy-HH:mm:ss')][$Event] $Message"
}

function EndLog {
    Add-Content $LogFilePath -Value "============================================================"
    Add-Content $LogFilePath -Value "   END SCRIPT"
    Add-Content $LogFilePath -Value "Date : $(Get-Date -Format 'dd/MM/yyyy-HH:mm:ss')"
    Add-Content $LogFilePath -Value "============================================================"
}

function TestDisk {
    try {
        $disk = Get-BitLockerVolume -MountPoint "C:"

        if ($disk.VolumeStatus -eq "FullyDecrypted") {
            Write-Log -Event "INFO" -Message "The disk $($disk.MountPoint) is FullyDecrypted. Starting encryption."

            # Enable BitLocker encryption
            Enable-BitLocker -MountPoint $disk.MountPoint -EncryptionMethod XtsAes256 -UsedSpaceOnly -TpmProtector

            # Add recovery key protector
            $recoveryProtector = Add-BitLockerKeyProtector -MountPoint $disk.MountPoint -RecoveryPasswordProtector

            # Get list of protector 
            $ProtectorList = Get-BitLockerVolume -MountPoint $disk.MountPoint | Select-Object -ExpandProperty KeyProtector

            #Start-Sleep wait 3 seconds for get recoverypasswd
            Start-Sleep -Seconds 3
            
            $recoveryPassword = ($ProtectorList | Where-Object { $_.KeyProtectorType -eq 'RecoveryPassword'}).RecoveryPassword

            # Save recovery key
            "Disk: $($disk.MountPoint) -RecoveryKey: $recoveryPassword" | Add-Content -Path $outputPath -Encoding UTF8

            Write-Log -Event "INFO" -Message "Encryption started for $($disk.MountPoint). Recovery key saved in $outputPath"
        }
        else {
            Write-Log -Event "INFO" -Message "The disk $($disk.MountPoint) is already encrypted with status: $($disk.VolumeStatus)."
        }
    }
    catch {
        Write-Log -Event "ERROR" -Message $_.Exception.Message
    }
}

# ======================================================================================
# MAIN SCRIPT EXECUTION
# =======================================================================================
try {
    HeaderLog
    TestDisk
    EndLog
}
catch {
    Write-log -Event "ERROR" -Message $_.Exception.Message
}