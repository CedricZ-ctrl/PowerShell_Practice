#******************************************************************************************************************************
#                                                                                                                             *
# file : InventorySystem.ps1                                                                                                  *
#                                                                                                                             *
# Version : 1.0                                                                                                               *
#                                                                                                                             *
# Date : 09/12/2024                                                                                                           *
#                                                                                                                             *
# Description : pull inventory system Name Bios, Version of Bios, Name CPU, Socket CPU, NamePC,DomainName and model computer  *
#                                                                                                                             *
#******************************************************************************************************************************

# ======================================================================================
#  VARIABLE DECLARATIONS                                                               
#=======================================================================================
#
# code exit initial
$ExitCode = 0


# #check if Directory is not present \COPY AND PASTE, YOUR LOGFILE
$LogDirectory = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\InventorySystem\"

# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$logfilepath = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\InventorySystem\LogFile.txt"



#==================================================================================================================
# FUNCTION DECLARATION
#==================================================================================================================
#

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

    # add a message and event in your log
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
}

# this function retrive information system computer name,domaine name, name bios, version bios,name processor, socket processor and write informations in log with function write log
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

InventorySystem
exit $ExitCode++

#======================================================================================================================
# END OF SCRIPT
#======================================================================================================================