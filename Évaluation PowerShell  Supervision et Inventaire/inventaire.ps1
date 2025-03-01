#******************************************************************************************************************************
#                                                                                                                             *
# file : inventaire.ps1                                                                                                       *
#                                                                                                                             *
# Version : 1.0                                                                                                               *
#                                                                                                                             *
# Date : 09/12/2024                                                                                                           *
#                                                                                                                             *
# Description : Evaluation scripting powershell                                                                               *
#                                                                                                                             *
#******************************************************************************************************************************

# ======================================================================================
#  VARIABLE DECLARATIONS                                                               
#=======================================================================================

#ExitCode init
$ExitCode = 0

#Directory Log
$LogDirectory = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\Évaluation PowerShell  Supervision et Inventaire"

#File Log
$LogFilepath = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\Évaluation PowerShell  Supervision et Inventaire\LogFile.txt"

#==================================================================================================================
# FUNCTION DECLARATION
#==================================================================================================================

# Wirte-log is an function for write log in $logfilepath an $LogDirectory
function Write-log {
    param(
        [string]$Message,
        [string]$Event
    )
    
    if (!(Test-Path -Path $LogDirectory )) {
        New-Item -ItemType Directory -Path $LogDirectory -Force
    }
    if (!(Test-Path -Path $LogFilepath)) {
        New-Item -ItemType File -Path $logfilepath -Force
    }

    # Add a message and event in your log
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $LogFilepath -Value "[$timestamp][$Event] $Message"
}


# this function asks the user which service they want to check, and start if the service is not running 
function ServiceUser {
    $servicename = Read-Host "Please enter service name to check the status"
    
    foreach ($service in $servicename) {
        try {
            $ServiceStatus = get-service -Name $service

            if($ServiceStatus.Status -eq "Running") {
                $Message = "The service $service is already running"
                Write-log -Event "INFO" -Message $Message
            }
            elseif ($ServiceStatus.Status -eq "Stopped") {
                Start-Service -Name $service
                $Message = "The Service $service was stopped and now he's started"
                Write-log -Event "INFO" -Message $Message
            }
            else {
                $Message = "The Service $service is an unknow state : $($ServiceStatus.Status)"
                Write-log -Event "WARNING" -Message $Message
            }
            
        }
        catch {
            $ExitCode = 1 
            $Message = "The service $service could not be found or started. Error:$($ExitCode): $_"
            Write-log -Event "WARNING" -Message $Message
        }
    }
}

####

function InventorySystem () {
    try {
        $infosystem = @{
    
            #Informations Bios
            NameBIOS = (Get-CimInstance -ClassName Win32_BIOS).Name
            VersionBios = (Get-CimInstance -ClassName Win32_BIOS).Version
    
            #Informations Processor and socket
            NameProc = (Get-CimInstance -ClassName Win32_Processor).Name
            Socketproc= (Get-CimInstance -ClassName Win32_Processor).SocketDesignation
    
            #informations System, computer name, domain allowed and model motherboard
            NamePC = (Get-CimInstance -ClassName Win32_ComputerSystem).Name
            DomainPC = (Get-CimInstance -ClassName Win32_ComputerSystem).Domain
            modelPC = (Get-CimInstance -ClassName Win32_ComputerSystem).Model
        }
        $Message = "=== Start Inventory ==="
        Write-log -Event "Start Inventory" -Message $Message
    
        foreach ($key in $infosystem.Keys) {
    
        $Message  = "$key : $($infosystem[$key])   "
        Write-log -Event "Informations System" -Message $Message
        }
      } catch {
        Write-log -Event "ERROR" -Message "Error collecting system information : $_ "
      }
    }
#==================================================================================================================
# MAIN 
#==================================================================================================================
ServiceUser 


InventorySystem


#======================================================================================================================
# END OF SCRIPT
#======================================================================================================================