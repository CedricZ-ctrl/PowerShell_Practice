#***********************************************************************************************
#                                                                                              *
# file : CheckService.ps1                                                                      *
#                                                                                              *
# Version : 1.0                                                                                *
#                                                                                              *
# Date : 14/01/2025                                                                            *
#                                                                                              *
# Description : Check General configuration Windows                                            *   
#               check service DHCP,Windows Update if need restart latter.                      *
#               check settings Network                                                         *
#                                                                                              *    
#***********************************************************************************************

# ======================================================================================
#  VARIABLE DECLARATIONS                                                               
#=======================================================================================
#
# code exit initial
$ExitCode = 0


## #check if Directory is not present \COPY AND PASTE, YOUR LOGFILE
$LogDirectory = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\CheckConfigWindows"

# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$logfilepath = "$LogDirectory\LogFile.txt"

# list service name do you want check \ MODIFY THE NAME SERVICE TO SUIT FOR YOU NEED
$listservices = "wuauserv","Dhcp"

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
    Add-Content $LogFilePath -Value "START SCRIPT: ChecConfigWindows.ps1" -Force
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

        $script:NamePC = $infosystem.NamePC
    
        $Message = "=== Start Inventory ==="
        Write-log -Event "Start Inventory" -Message $Message
    
        # Here $infosystem.Keys get informations in $infosystem = @{NameBIOS,NameProc or Nampc and anymore}
        # .keys is just key value in hashtable of $infosystem
        foreach ($key in $infosystem.Keys) {
    
        $Message  = "$key : $($infosystem[$key])   "
        Write-log -Event "Informations System" -Message $Message
        }
      } catch {
        $ExitCode = 1
        $Message = "Error collecting system information : $_ "
        Write-log -Event "ERROR" -Message $Message
      }
    }

function GetIpAddress {
try {
    

    $NetInfo = Get-NetIPAddress | Where-Object  { $_.InterfaceAlias -like "Ether*et"}
    if ($NetInfo.InterfaceAlias -like "Ethernet") {
        $Message = "The $script:NamePC has an ethernet interface with the ip  $($NetInfo.IPAddress)"
        Write-log -Event "INFO" -Message $Message
    }
    else {
        $Message = "information unknow "
        Write-log -Event "WARNING" -Message $Message
    }
    
}
catch {
    $ExitCode = 1 
    $Message = "An error occurred : $($ExitCode): $_"
    Write-log -Event "ERROR" -Message $Message
}
}


function GetStatusService{
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
        $ExitCode = 1 
        $Message = "Service '$service' could not be found or started:$($ExitCode): Error occurred: $_"
        Write-log -Message $Message -Event "ERROR"
    }
}
}
#==================================================================================================================
# MAIN 
#==================================================================================================================
HeaderLog
try{
InventorySystem 

GetIpAddress

GetStatusService
}
EndLog
catch {
    $ExitCode = 1
    $Message = "$_"
    Write-log -Event "ERROR" -Message $Message
}
#======================================================================================================================
# END OF SCRIPT
#======================================================================================================================
