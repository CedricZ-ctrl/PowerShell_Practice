#***********************************************************************************************
#                                                                                              *
# file : CheckConfigWindows.ps1                                                                *
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
$LogDirectory = Join-Path -Path $env:ProgramData -ChildPath "LogsScriptPerso"

# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$logfilepath = Join-Path -Path $LogDirectory -ChildPath "CheckConfigWindows.log"

# list service name do you want check \ MODIFY THE NAME SERVICE TO SUIT FOR YOU NEED
$listservices = "wuauserv","Dhcp"

 #path destination file .json systeme configuration 
 $Pathconfig = "C:\Windows\Temp\"
 $Fileconfig = "$Pathconfig\InfoSystem.json"

 #array finish 
 $Report = @{}

#==================================================================================================================
# FUNCTION DECLARATION
#==================================================================================================================
#
function HeaderLog {
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    if (!(Test-Path -Path $LogDirectory)){
        New-Item -Path $LogDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    }
    Add-Content $LogFilePath -Value "============================================================="
    Add-Content $LogFilePath -Value "START SCRIPT: CheckConfigWindows.ps1" -Force
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
      $Report.SystemInfo = $infosystem 
    }

function GetIpAddress {
try {
    

    $NetInfo = Get-NetIPAddress | Where-Object  { $_.InterfaceAlias -like "Ethernet"}
    if ($NetInfo.InterfaceAlias -like "Ethernet") {
        $Message = "The interface  has an ethernet interface with the ip  $($NetInfo.IPAddress)"
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
    $Report.Network = $NetInfo.IPAddress
}


function GetStatusService {
    $ServicesStates = @{}
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
        $ServicesStates[$services] = $serviceStatus.Status
    }
    catch {
        $ExitCode = 1 
        $Message = "Service '$service' could not be found or started:$($ExitCode): Error occurred: $_"
        Write-log -Message $Message -Event "ERROR"
    }
}
    $Report.Services = $ServicesStates
    $Message = "The File 'InfoSystem.json' set in directory : C:\Windows\Temp"
    Write-log -Message $Message -Event "INFO"
}


#==================================================================================================================
# MAIN 
#==================================================================================================================
HeaderLog
try {
    InventorySystem 

GetIpAddress

GetStatusService

$Report | ConvertTo-Json -Depth 10 | Set-Content -Path $Fileconfig
}
catch {
    $ExitCode = 1 
    $Message = " Error occurred : $_"
    Write-log -Message $Message -Event "ERROR"
}
EndLog
#======================================================================================================================
# END OF SCRIPT
#======================================================================================================================
