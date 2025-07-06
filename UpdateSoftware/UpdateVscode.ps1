#***********************************************************************************************
#                                                                                              *
# file : UpdateVscode.ps1                                                                      *
#                                                                                              *
# Version : 1.0                                                                                *
#                                                                                              *
# Date : 05/07/2025                                                                            *
#                                                                                              *
# Description : Download latest version of Visual studio code via link web                     *
#                                                                                              *    
#***********************************************************************************************

# ======================================================================================
#  VARIABLE DECLARATIONS                                                               
#=======================================================================================
#
# code exit initial
$ExitCode = 0
## #check if Directory is not present \COPY AND PASTE, YOUR LOGFILE
$LogDirectory = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\UpdateSoftware"
# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$logfilepath = "$LogDirectory\Log_UpdateVscode.txt"
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
    Add-Content $LogFilePath -Value "START SCRIPT: UpdateVscode " -Force
    Add-Content $LogFilePath -Value "Date : $($timestamp)"
    Add-Content $LogFilePath -Value "============================================================="
}
# this function write-log, write informations of du script  in $logfilepath and $LogDirectory with date and hours 
function Write-log {
    param(
        [string]$Message,
        [string]$Event
    )
    
    if (!(Test-Path  $LogDirectory)) {
        New-Item -ItemType Directory -Path $LogDirectory -Force
    }
    if (!(Test-Path  $logfilepath)) {
        New-Item -ItemType File -Path $logfilepath -Force
    }
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
}

function EndLog {
    if (!(Test-Path $LogDirectory)) {
        New-Item -Path $LogDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue | out-null
    }
    Add-Content $logfilepath -value "============================================================" 
    Add-Content $logfilepath -Value "END SCRIPT"
    Add-Content $logfilepath -Value "Date : $($timestamp):"
    Add-Content $logfilepath -Value "============================================================"
}

function CheckLatestVersion {
try {
    $PathDest = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\UpdateSoftware\VSCodeLatest\Versions"
    $OutFiLes = join-path -Path $PathDest -ChildPath "VSCodeSetup-x64-*.exe"
    $LatestVersion = (Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/vscode/releases/latest" -Headers @{ "User-Agent" = "PowerShell" }).tag_name
    $ExistingVersion = Get-ChildItem -Path $PathDest -Filter "VSCodeSetup-x64-$LatestVersion.exe" -ErrorAction SilentlyContinue

        if (!($ExistingVersion)){
            DownloadVSCode -Version $LatestVersion 
            $Message = "an version of vscode latest avaible, download running ..."
            Write-log -Event "INFO" -Message $Message
        }
        else {
            $Message = "The Version of VSCode is already present in directory $($OutFiLes)"
            Write-log -Event "INFO" -Message $Message
        }
    
} 
catch {
    $ExitCode = 1
    $Message ="ExitCode : $($ExitCode) with message : $_"
    Write-Log -event "ERROR" -Message $Message

}

}

function DownloadVSCode {
    param(
        [string]$Version
    )
try {
    $PathDest = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\UpdateSoftware\VSCodeLatest\Versions"

    if (!(Test-Path $PathDest)){
        new-Item -ItemType Directory -Path $PathDest -Force | out-null
        $Message = "The path $($PathDest) no exist, creating "
        Write-log -Event "INFO" -Message $Message
    } 
    else {
        $Message = "Directory $($PathDest) already present"
        Write-log -Event "INFO" -Message $Message
    }

        $OutFiLes = join-path -Path $PathDest -ChildPath "VSCodeSetup-x64-$Version.exe"
        $GetVsCodeLatest = Invoke-WebRequest -Uri https://update.code.visualstudio.com/latest/win32-x64/stable -OutFile $OutFiLes -UseBasicParsing
        

        if (Test-Path $OutFiLes) {
            $Message = "Download Succes ! "
            Write-Log -Event "SUCCES" -Message $Message
        }
        else {
            throw "Download failed, file not found at $OutFiles"
            $Message = "Download failed, file not found at $OutFiles"
            Write-log -Event "ERROR" -Message $Message
        }

    } catch {
        $ExitCode = 1
        $Message = "Error : $_ "
        Write-log -Event "Error" -Message $Message
    }
    
}
HeaderLog
CheckLatestVersion

EndLog