
#***********************************************************************************************
#                                                                                              *
# file : CheckService.ps1                                                                      *
#                                                                                              *
# Version : 1.0                                                                                *
#                                                                                              *
# Date : 09/12/2024                                                                            *
#                                                                                              *
# Description : Check if liste of service is running or not, if stopped so start the service   *
#                                                                                              *    
#***********************************************************************************************

# ======================================================================================
#  VARIABLE DECLARATIONS                                                               
#=======================================================================================
#
# code exit initial
$ExitCode = 0


## #check if Directory is not present \COPY AND PASTE, YOUR LOGFILE
$LogDirectory = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\CheckService"

# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$logfilepath = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\CheckService\LogFile.txt"

# list service name do you want check \ MODIFY THE NAME SERVICE TO SUIT FOR YOU NEED
$listservices = "wuauserv","Spooler","Dhcp","Schedule"

#==================================================================================================================
# FUNCTION DECLARATION
#==================================================================================================================
#
# this function write-log, write informations of du script  in $logfilepath and $LogDirectory with date and hours 
function Write-log {
    param(
        [string]$Message,
        [string]$Event
    )
    
    if (!(Test-Path -Path $LogDirectory)) {
        New-Item -ItemType Directory -Path $LogDirectory -Force
    }
    if (!(Test-Path -Path $logfilepath)) {
        New-Item -ItemType File -Path $logfilepath -Force
    }

    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
}
    
# this FOREACH, check if for each Service is running or not, if not running so we start service, and write information in $logfilepath with the function Write-log
    foreach ($services in $listservices) {
        Try{
            $serviceStatus = get-service -Name $services

            if ($serviceStatus.Status -eq "Running") {
                $Message = "Service '$services' is already Running"
                Write-log -Event "INFO" -Message $Message
            }
            elseif ($serviceStatus.Status -eq "Stopped") {
                Start-Service -Name $services
                $Message = "Servce '$services' was stopped and now he's started"
                Write-log -Event "INFO" -Message $Message
            }
            else {
                $Message = " Service '$services' is an unknow state : $($serviceStatus.Status)"
                write-log -Event "WARNING" -Message $Message
            }
        }
        catch {
            $Message = "Service '$service' could not be found or started. Error: $_"
            Write-log -Message $Message -Event "ERROR"
        }
    }
#==================================================================================================================
# MAIN 
#==================================================================================================================
    exit $ExitCode++

    
#======================================================================================================================
# END OF SCRIPT
#======================================================================================================================
    