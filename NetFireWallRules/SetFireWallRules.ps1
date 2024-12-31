#******************************************************************************************************************************
#                                                                                                                             *
# file : SetFireWallRules.ps1                                                                                                 *                                                                                                     *
#                                                                                                                             *
# Version : 1.0                                                                                                               *
#                                                                                                                             *
# Date : 29/12/2024                                                                                                           *
#                                                                                                                             *
# Description : Set rules firewall block port 445 (SMB) and denied connection RDS on your machine                             *
#                                                                                                                             *
#******************************************************************************************************************************

# ======================================================================================
#  VARIABLE DECLARATIONS                                                               
#=======================================================================================
#
# code exit initial
$ExitCode = 0

#Path LogDirectory\ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$LogDirectory ="B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\NetFireWallRules"

# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$logfilepath = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\NetFireWallRules\LogFireWall.txt"

#==================================================================================================================
# FUNCTION DECLARATION
#==================================================================================================================
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
    if (!(Test-Path -Path $logfilepath)) {
        New-Item -ItemType File -Path $logfilepath -Force
    }

    
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
}


#*********************************
#                                *
# Check Rules Firewall           *
#                                *
#*********************************
function CheckRuleRDP {
    try {
        $RuleRDP = Get-NetFirewallRule -Name "RemoteDesktop-UserMode-In-TCP" 

        if($RuleRDP.Enabled -eq "True"){
            Set-NetFirewallRule -Name $RuleRDP.Name -Enabled False
            $Message = "The Rule '$($RuleRDP.Name)' with for Description:'$($RuleRDP.DisplayGroup)' is Enable"
            Write-log -Event "INFO" -Message $Message
        }


        #this latter, check le status of Rule
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

        
        # this latter, check le status of Rule
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


#=============================================================================================================
#MAIN
#
CheckRuleRDP
CheckRuleSMB 
#
#==============================================================================================================================
