######################################################################################
#                                                                                    #
#file : SetLayoutKeyboard.ps1                                                        #
#version : 1.0                                                                       #
#date : 04/11/2025                                                                   #
#                                                                                    #
#This script installs all the languages ​​that support needs,                          #
# during remote intervention, from different countries.                              # 
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
$logfilepath = Join-Path -Path $LogDirectory -ChildPath "ConfigLayout.log"

#ListLanguage 
$ListLang = @("fr-FR","en-US","it-IT")

function HeaderLog {
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    if (!(Test-Path -Path $LogDirectory)){
        New-Item -Path $LogDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    }
    Add-Content $LogFilePath -Value "============================================================="
    Add-Content $LogFilePath -Value "START SCRIPT: AddLayout.ps1" -Force
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

function GetListLang {
    try {
        $CurrentTag = Get-WinUserLanguageList
        $TagPresent = $CurrentTag.LanguageTag
        $Modified = $false

        foreach ($Lang in $ListLang) {
            if ($TagPresent -notcontains $Lang){
                $Message = "$Lang missed ->  add the $Lang"
                Write-log -Event "INFO" -Message $Message 
                $CurrentTag.Add($Lang)
                $Modified = $true 
            }
            else {
                $Message = "The $Lang is already installed"
                Write-log -Event "INFO" -Message $Message 
            }
            
        }
        if ($Modified){
            Set-WinUserLanguageList -LanguageList $CurrentTag -Force 
            $Message = "add language in system Done"
            Write-log -Event "INFO" -Message $Message 
        }
    }
    catch {
        $ExitCode = 1
        $Message = "$_"
        Write-log -Event "ERROR" -Message $Message
    }

}

##############################################################################################################
#MAIN
##############################################################################################################

try {
HeaderLog
GetListLang
EndLog  
}
catch {
   $ExitCode = 1
    $Message = "$_"
    Write-log -Event "ERROR" -Message $Message
}
