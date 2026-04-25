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
## #check if Directory is not present \COPY AND PASTE, YOUR LOGFILE
$LogDirectory = Join-Path -Path $env:ProgramData -ChildPath "LogsScriptPerso"

# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$logfilepath = Join-Path -Path $LogDirectory -ChildPath "CheckBitLocker.log"

# Path destination of "bitlocker-recovery" 
$outputPath = "C:\Windows\Temp\bitlocker-recovery.txt"

# ======================================================================================
# FUNCTION DECLARATIONS                                                               
# ======================================================================================

function HeaderLog {
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    if (!(Test-Path -Path $LogDirectory)){
        New-Item -Path $LogDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    }
    Add-Content $LogFilePath -Value "============================================================="
    Add-Content $LogFilePath -Value "START SCRIPT: CheckBitLocker.ps1" -Force
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
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content $logfilepath -value "============================================================" 
    Add-Content $logfilepath -Value "END SCRIPT "
    Add-Content $logfilepath -Value "Date : $($timestamp):"
    Add-Content $logfilepath -Value "============================================================"
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