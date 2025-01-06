#******************************************************************************************************************************
#                                                                                                                             *
# file : FinishScript.ps1                                                                                                     *
#                                                                                                                             *
# Version : 1.0                                                                                                               *
#                                                                                                                             *
# Date : 29/12/2024                                                                                                           *
#                                                                                                                             *
# Description : this script create an tree structure, and check 2 rules in firewall, and check process, information sytem     *
#                                                                                                                             *
#******************************************************************************************************************************

# =============================================================================================================================
#  VARIABLE DECLARATIONS                                                                                                      *
#==============================================================================================================================
#
# code exit initial
$ExitCode = 0

#Path LogDirectory\ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$LogDirectory ="C:\ToolKit\UserData\Logs"

# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
 $LogFilePath = "C:\ToolKit\UserData\Logs\LogFile.txt"

#=============================================================================================================================
# FUNCTION DECLARATION                                                                                                       *
#=============================================================================================================================
#
#this function write-log, write informations of du script  in $logfilepath and $LogDirectory with date and hours
 function Write-log {
    param(
        [string]$Message,
        [string]$Event
    )

    if (!(Test-Path -Path $LogDirectory)) {
        New-Item -ItemType Directory -Path $LogDirectory -Force
    }
    if (!(Test-Path -Path $LogFilePath)) {
        New-Item -ItemType File -Path $LogFilePath -Force
    }

    
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $LogFilePath -Value "[$timestamp][$Event] $Message"
}

# this function create tree structure if latter don't created or if Directory is missing and  write informations in log with function write log
function SetDirectory () {
    try {
        $Directory = @("C:\ToolKit",
                       "C:\ToolKit\UserData",
                       "C:\ToolKit\UserData\Documents",
                       "C:\ToolKit\UserData\Download",
                       "C:\ToolKit\UserData\Logs",
                       "C:\ToolKit\Scripts",
                       "C:\ToolKit\Backup")
    
                       # this directory is a test for tested the catch in try-catch, this error generate is a permissions denied on systeme 32 of windows
                        # "C:\Windows\System32\testdir") 
    
    foreach ($dir in $Directory) {
            if (!(Test-Path -Path $dir)) {
                New-Item -Path $dir -ItemType Directory -ErrorAction Stop -Force
                 New-Item -Path $dir -ItemType File -Name Readme.txt -ErrorAction Stop -Force
    
                $Message = "Creating missing directories : $dir "
                Write-log -Event "INFO" -Message $Message
                }
        
            else {
            $Message = "All directory already : $dir "
            Write-log -Event "INFO" -Message $Message
                }
        }
    } catch {
        $ExitCode = 1
        $Message = "Failed during creating directory : $dir : Exitcode: $($ExitCode) : $_"
        Write-log -Event "WARNING" -Message $Message
            }
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
    }



function testdisk ()   {    
    $checkstatus = (Get-BitLockerVolume -MountPoint "C:" | select VolumeStatus).VolumeStatus
    return $checkstatus
    }

    $checkstatus = testdisk
    switch ($checkstatus.VolumeStatus) {

        "EncryptionInProgress" {
            $ExitCode = 2
            $Message = "The Disk is in progress encryption,ExitCode:$($ExitCode)"
            Write-log -Message $Message -Event "Warning"
        }
        
        "FullyEncrypted" {
            $ExitCode = 0
            $Message = "The Disk is Completly Crypted:$($ExitCode):"
            Write-log -Message $Message -Event "Success"
        
        }
        
         "FullyDecrypted" {
            $ExitCode = 3
            $Message = "The disk is not encrypted ExitCode:$($ExitCode)"
            Write-log -Message $Message -Event "Error"
        }
        
    }
        

    function CheckRuleRDP {
        try {
            $RuleRDP = Get-NetFirewallRule -Name "RemoteDesktop-UserMode-In-TCP" 
    
            if($RuleRDP.Enabled -eq "True"){
                Set-NetFirewallRule -Name $RuleRDP.Name -Enabled False
                $Message = "The Rule '$($RuleRDP.Name)' with for Description:'$($RuleRDP.DisplayGroup)' is Enable"
                Write-log -Event "INFO" -Message $Message
            }
            #blocked the loop
            $attempts0 = 0
    
            do {
            #Waiting 1
            Start-Sleep -Seconds 2
            #Update status Rule 
            $RuleRDP = Get-NetFirewallRule -Name "RemoteDesktop-UserMode-In-TCP" 
            #Increment tentative
            $attempts0 ++
            if($attempts0 -ge 5){
                $Message = "Failed to disable the rule '$($RuleRDP.Name)' after 5 attempts"
                Write-log -Event "ERROR" -Message $Message
                return
            }
                
    
            } while ($RuleRDP.Enabled -eq "True")
            $Message = "The Rule '$($RuleRDP.Name)' has ben successfully disabled"
            Write-log -Event "INFO" -Message $Message
    
        }
        catch {
            $ExitCode = 2 
            $Message = "An error occurred:$($ExitCode) ERRO:$_"
            Write-log -Event "ERROR" -Message $Message
        }
    }
    
    function CheckRuleSMB {
        try {
            $RuleSMB = Get-NetFirewallRule -Name "FPS-SMB-In-TCP"
    
            if ($RuleSMB.Enabled -eq "True") {
            Set-NetFireWallRule -Name $RuleSMB.Name -Enabled False
            $Message = "The Rule '$($RuleSMB.Name)' with for Description: '$($RuleSMB.DisplayGroup)' is Enable, "
            Write-log -Event "INFO" -Message $Message
            }
    
            #blocked the loop
            $attempts = 0 
    
            do { 
                # Waiting 2 seconds 
                Start-Sleep -Seconds 2 
                
                #update rule variable 
                $RuleSMB = Get-NetFirewallRule -Name "FPS-SMB-In-TCP"
                #increment tentative 
                $attempts ++
                
                if($attempts -ge 5) {
                    $Message = "Failed to disable the rule '$($RuleSMB.Name)' after 5 attempts"
                    Write-log -Event "ERROR" -Message $Message
                    return
                }
    
            } while ($RuleSMB.Enabled -eq "True")
            $Message = "The rule '$($RuleSMB.Name)' has been successfully disabled"
            Write-log -Event "INFO" -Message $Message
            
        }
        catch {
            $ExitCode = 1
            $Message = "An error occurred:$($ExitCode): ERRO:$_"
            Write-log -Event "ERROR" -Message $Message
        }
    }
#===============================================================================================================================
# MAIN                                                                                                                         *
#===============================================================================================================================   

# create several Tree Directory 
SetDirectory 
#get informations system
InventorySystem
#Check 2 rules in firewall 
CheckRuleRDP
CheckRuleSMB 
# check status Bitlocker
testdisk

#======================================================================================================================
# END OF SCRIPT
#======================================================================================================================
