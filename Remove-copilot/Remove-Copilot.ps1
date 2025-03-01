#******************************************************************************************************************************
#                                                                                                                             *
# file : Remove-copilot.ps1                                                                                                   *
#                                                                                                                             *
# Version : 1.0                                                                                                               *
#                                                                                                                             *
# Date : 18/01/2025                                                                                                           *
#                                                                                                                             *
# Description : this script remove "Copilot" on system windows, and in browser Edge                                           *
#                                                                                                                             *
#******************************************************************************************************************************

# ======================================================================================
#  VARIABLE DECLARATIONS                                                               
#=======================================================================================
#
# code exit initial
$ExitCode = 0


#Path LogDirectory\ MODIFY THE PATH TO SUIT  FOR YOUR NEED
$LogDirectory ="C:\ToolKit\UserData\Logs"

# Path LogFile \ MODIFY THE PATH TO SUIT  FOR YOUR NEED
 $logfilepath = "$LogDirectory\LogRemove-Copilot.txt"

# format date 
$timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"

#==================================================================================================================
# FUNCTION DECLARATION
#==================================================================================================================
#
#this function write-log, write informations of du script  in $logfilepath and $LogDirectory with date and hours 

function HeaderLog {
    if (!(Test-Path -Path $LogDirectory)) {
        New-Item -Path $LogDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue | out-null
    }
    Add-Content $logfilepath -value "============================================================" -force
    Add-content $logfilepath -Value "START SCRIPT" -force
    Add-Content $logfilepath -Value "Script Name : Remove-Copilot" -force    
    Add-Content $logfilepath -Value "============================================================"
    Add-Content $logfilepath -Value "Date : $($timestamp): " -force 
    Add-Content $logfilepath -Value "=============================================================" -force 
    
}

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

function CheckPathHKLM {

if (!(Test-Path -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsCopilot")){
    new-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsCopilot" -ea SilentlyContinue -Force | out-null
}

if(!(Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer")){
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Force | out-null
}
if (!(Test-Path -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced")){
    New-Item -Path "HKLM:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Force | out-null
   
}

Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsCopilot" -Name "TurnOffWindowsCopilot" -Value 1 -Force | out-null
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCopilotButton" -Value 0 -force | out-null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions" -Value 1 -Force | out-null 

$Message = "Registry Modifications Windows Copilot for All User"
Write-log -Event "INFO" -Message $Message


}
function DisableCopilotShell {
$FindCopilotFeatures = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Shell\Copilot\" -Name "CopilotDisabledReason" 
$FindCopilot = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Shell\Copilot\" -Name "IsCopilotAvailable"
$DisableCopilot = Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Shell\Copilot\" -Name "IsCopilotAvailable" -Value "1"
$DisableCopilotFeatures = Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Shell\Copilot\" -Name "CopilotDisabledReason" -Value "1"

try {
    if ($FindCopilot.IsCopilotAvailable -eq 0 ){

    $DisableCopilot 
    $Message = "The $($FindCopilot.PSChildname) Find ! we will set the value to 1"
    Write-log -Event "INFO" -Message $Message
        }
    if ($FindCopilotFeatures -match "FeatureIsDisabled") {

    $DisableCopilotFeatures
    $Message = "The $($FindCopilotFeatures.CopilotDisabledReason) Find ! we will set the value to null"
    Write-log -Event "INFO" -Message $Message
        }
    else {
    $Message = " the Value of IsCopilotAvailble is :$($FindCopilot.IsCopilotAvailable) and the CopilotFeatures is :$($FindCopilotFeatures.FindCopilotFeatures):"
    Write-log -Event "WARNING" -Message $Message
        }
}catch {
    $ExitCode = 1
    $Message = "An error occurred in function DisableCopilotShell: $($ExitCode): $_"
    Write-log -Event "ERROR" -Message $Message
}


}

function DisableCopilotWindows {
$FindCopilotWindows = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\WindowsCopilot" -Name AllowCopilotRuntime 
$DisableCopilotWindows = Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\WindowsCopilot" -Name AllowCopilotRuntime -Value "1"

try {
    if ($FindCopilotWindows.AllowCopilotRuntime -eq 0 ){

    $DisableCopilotWindows 
    $Message = "The $($FindCopilotWindows.PSChildname) Find ! we will set the value to 1"
    Write-log -Event "INFO" -Message $Message
    }
    else {
    $Message = " the Value of AllowCopilotRuntime is :$($FindCopilotWindows.AllowCopilotRuntime) "
    Write-log -Event "WARNING" -Message $Message
        }
}catch {
    $ExitCode = 1
    $Message = "An error occurred in function DisableCopilotWindows: $($ExitCode): $_"
    Write-log -Event "ERROR" -Message $Message
}

}

function DisableCopilotBingChat {

$FindCopilotBingChat = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Shell\Copilot\BingChat" -Name "IsUserEligible"
$DisableCopilotBingChat = Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Shell\Copilot\BingChat" -Name "IsUserEligible" -Value "1"

try {
    if ($FindCopilotBingChat.IsUserEligible -eq 0 ){

    $DisableCopilotBingChat
    $Message = "The $($FindCopilotBingChat.PSChildname) Find ! we will set the value to 1"
    Write-log -Event "INFO" -Message $Message
    }
    else {
    $Message = " the Value of AllowCopilotRuntime is :$($FindCopilotBingChat.IsUserEligible) "
    Write-log -Event "WARNING" -Message $Message
        }
}catch {
    $ExitCode = 1
    $Message = "An error occurred in function DisableCopilotBingChat: $($ExitCode): $_"
    Write-log -Event "ERROR" -Message $Message
}

}

function UninstallCopilot {

    
    $FindPackageCopilot = Get-AppxPackage -Name "Microsoft.Copilot"
    $UninstallCopilotPackage = Get-AppxPackage -AllUsers -Name "Microsoft.Copilot" | Remove-AppxPackage

try {

    if ($FindPackageCopilot.PackageFullName -match "Microsoft.Copilot_0.4.2.0_neutral__8wekyb3d8bbwe"){

        $UninstallCopilotPackage
        $Message = "The Package $($FindPackageCopilot) is found, we will uninstall this package"
        Write-log -Event "INFO" -Message $Message

        
    }   
    else {
        $Message = "The package $($FindPackageCopilot) not found "
        Write-log -Event "INFO" -Message $Message

    }
} catch{
    $ExitCode = 1
    $Message = "An error occurred in function UninstallCopilot: $($ExitCode): $_"
    Write-log -Event "ERROR" -Message $Message
    }
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

#==================================================================================================================
# MAIN 
#==================================================================================================================
HeaderLog
try{
CheckPathHKLM

DisableCopilotShell
DisableCopilotWindows
DisableCopilotBingChat

UninstallCopilot
EndLog

}catch{
    $ExitCode = 1
    $Message = "$_"
    Write-log -Event "ERROR" -Message $Message
}

