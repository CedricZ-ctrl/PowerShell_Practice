######################################################################################
#                                                                                    #
#file : RecoveryBookmarksFirefox.ps1                                                 #
#version : 1.0                                                                       #
#date : 12/06/2026                                                                   #
#                                                                                    #
# this script allow recoery booksmarks deleted after update firefox                   # 
#                                                                                    #
######################################################################################

#====================================================================================#
#           VARIABLE DECLARATIONS                                                    #
#====================================================================================#
# code exit initial
$ExitCode = 0

## #check if Directory is not present \COPY AND PASTE, YOUR LOGFILE
$LogDirectory = Join-Path -Path $env:ProgramData -ChildPath "LogsScriptPerso"

# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$logfilepath = Join-Path -Path $LogDirectory -ChildPath "RecoveryBookmark.log"

# add process you want check \MODIFY NAME PROCESS TO SUIT FOR YOU NEED
$NameProcess = "firefox" 

#path Env Mozilla firefox 
$PathProfilesFirefox = "AppData\Roaming\Mozilla\Firefox\Profiles"

#CurrentDate to compare lastWriteTime
$DateDay = (Get-Date).AddDays(-1)

function HeaderLog {
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    if (!(Test-Path -Path $LogDirectory)){
        New-Item -Path $LogDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    }
    Add-Content $LogFilePath -Value "============================================================="
    Add-Content $LogFilePath -Value "START SCRIPT: RecoveryBookMarksFireFox.ps1" -Force
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

function GetCurrentUserProfilePath {
    $username = (Get-CimInstance -class Win32_ComputerSystem).UserName
    $sid = (new-object security.principal.NTaccount($username)).Translate([security.principal.securityIdentifier]).Value
    $userprofile = Get-CimInstance -query "select * from win32_userprofile where sid='$sid'"
    $res = $userprofile.LocalPath
    return $res   
}

function CheckProcess  {
try {   
      $processrunning = (Get-Process -Name $NameProcess -ErrorAction SilentlyContinue | select ProcessName).ProcessName
      
        foreach ($process in $NameProcess) {

            if($processrunning -contains $process) {
            Stop-Process -Name $process
            $Message = "Process is running : $process stopped "
            Write-log -Event "INFO" -Message $Message

            } else {
            $Message = "Not found process $process "
            Write-log -Event "WARNING" -Message $Message
            }
        }
   
    } catch {
        $ExitCode = 1
        $Message = "failed to start $process, Exitcode $($ExitCode):$_"
        Write-log -Event "WARNING" -Message $Message
    }
}

# function TestPathUsers {
#     $UserProfilePath = GetCurrentUserProfilePath
#     $PathFirefoxUsers = Join-Path $UserProfilePath "$PathProfilesFirefox"

#     $Message = "The Path found is : $PathFirefoxUsers "
#     Write-log -Event "INFO" -Message $Message 
# }

function CheckProfilesDir {
    $UserProfilePath = GetCurrentUserProfilePath
    $PathFirefoxUsers = Join-Path $UserProfilePath $PathProfilesFirefox
    $ProfilesFirefox = Get-childItem -Path $PathFirefoxUsers -Directory | Sort-Object LastWriteTime -Descending 

    $Message = "the folder Recent Is : $($ProfilesFirefox[0].FullName)"
    Write-log -Event "INFO" -Message $Message 

    $Message = "the folder old is : $($ProfilesFirefox[-1].FullName)"
    Write-log -Event "INFO" -Message $Message 
    return $ProfilesFirefox[0], $ProfilesFirefox[-1]
}

function FoundFilePlaceSQLite {

    $ProfilesFirefox = CheckProfilesDir
    $ProfileFirefoxRecent = $ProfilesFirefox[0]
    $ProfileFirefoxOlder  = $ProfilesFirefox[-1]
    $FoundFileRecent = Join-Path $ProfileFirefoxRecent.FullName "places.sqlite"
    $FoundFileOlder = Join-Path $ProfileFirefoxOlder.FullName "places.sqlite"

    if (Test-Path $FoundFileRecent) {
        Rename-Item -Path $FoundFileRecent -NewName "places.sqlite.old" 
        $Message = "The $($ProfileFirefoxRecent.Name) has been rename to: places.sqlite.old "
        Write-log -Event "INFO" -Message $Message 

        if (Test-Path $FoundFileOlder) {
            Copy-Item -Path $FoundFileOlder -Destination $FoundFileRecent -Force 
            $Message = "The file Older has been copy/paste in $($ProfileFirefoxRecent.Name)"
            Write-log -Event "INFO" -Message $Message 
        
        } else {
        $Message = "Source File places.sqlite not found in $($ProfileFirefoxOlder.Name) copy aborted "
        Write-log -Event "ERROR" -Message $Message 
        }
    } else {
        $Message = "Target file places.sqlite not found in $($ProfileFirefoxRecent.Name) nothing to replace"
        Write-log -Event "WARNING" -Message $Message 
    }
}

HeaderLog
CheckProcess
FoundFilePlaceSQLite
EndLog



