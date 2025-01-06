
#*********************************************************************************************************************
#                                                                                                                    *
# file : ApiGetAd.ps1                                                                                                *
#                                                                                                                    *
# Version : 1.0                                                                                                      *
#                                                                                                                    *
# Date : 21/12/2024                                                                                                  *
#                                                                                                                    *
# Description : Get information from API "https://jsonplaceholder.typicode.com/users" public free, for learning      *
#  manipulation data api, here it's just for integration of users from Api, in Active Directory, With "OU" company   *
#                                                                                                                    *
#*********************************************************************************************************************

# ======================================================================================
#  VARIABLE DECLARATIONS                                                               
#=======================================================================================
#
# code exit initial
$ExitCode = 0 

# #DIRECTORY LOGS FOR THIS SCRIPT   
$LogDirectory = "C:\Users\Administrateur\Desktop\RequestApiGit"

#PATH LOGFILE \MODIFY THE PATH IF YOU NEED
$LogFilePath = "$LogDirectory\LogApi.txt"

#==================================================================================================================
# FUNCTION DECLARATION
#==================================================================================================================
#
# this function write-log, write informations of du script  in $LogFilePath and $LogDirectory with date and hours 
function Write-log {
    param(
        [string]$Message,
        [string]$Event
    )
    if (!(Test-Path -Path $LogDirectory)) {
        New-Item -ItemType Directory -Path $LogDirectory -Force
    }
    if (!(Test-Path -Path $logfilepath)) {
        New-Item -ItemType File -Path $LogFilePath -Force
    }
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $LogFilePath -Value "[$timestamp][$Event] $Message"
}


#FUNCTION API FACTICE JSONPLACEHOLDER FOR EXAMPLE, GET A LIST USERS, WITH FILTER ON NAME,ID,ADDRESS,WEBSITE and CompanyName
function ApiGetJsonPlaceHolder {
    $responses = Invoke-RestMethod -Uri "https://jsonplaceholder.typicode.com/users" -Method Get 

try {
    
    foreach ($users in $responses) {

        $userId      = $users.id
        $userName    = $users.name
        $websiteuser = $users.website 
        $Address     = $users.address.city
        $companyName = $users.company.name
    
    
    Write-host "----------------------------------------------------------------------"
    Write-host "Id                   : $($users.id)"
    Write-host "Name                 : $($users.name)"
    Write-host "Address              : $($users.address.city)"
    Write-host "Company              : $($users.company.name)"
    Write-host "Website              : $($users.website)"
    Write-Host "----------------------------------------------------------------------"
    
    #delete space in username for samaccount 
    $ValidUserName = $userName -replace ' ',''

    #Limit character for username at 20 
    if ($ValidUserName.length -gt 20) {
        $ValidUserName = $ValidUserName.Substring(0,20)
    }
    #Check if UO is not  eqal CompanyName, then , create UO With CompanyName user  
    if (-not(Get-ADOrganizationalUnit -Filter "Name -eq '$companyName'")) {
        $Message = "OU $companyName is not present, creating OU ongoing "
        Write-log -Event "INFO" -Message $Message 

        New-ADOrganizationalUnit -Name $companyName -Path "DC=COMPTAAS,DC=lan"
        start-sleep -Seconds 2

    #Check if UO has been created 
    if (get-ADOrganizationalUnit -Filter "Name -eq '$companyName'") {
        $Message =  "OU $companyname created"
        Write-log -Event "INFO" -Message $Message
    }

    #Check if user is not already present in Active Directory 
    $UserAD = Get-ADuser -Filter {SamAccountName -like "$ValidUserName" } -Properties SamAccountName
    
    if (-not $UserAD) {
        New-ADUser -Name $userName -SamAccountName $ValidUserName -UserPrincipalName "$ValidUserName@COMPTAAS.lan" -Path "OU=$companyName,DC=COMPTAAS,DC=lan" -AccountPassword (ConvertTo-SecureString "password123!" -AsPlainText -Force) -Enabled $true
        start-sleep -Seconds 2
        
        $Message = "User $ValidUserName created and added in l'OU $companyName "
        Write-log -Event "INFO" -Message $Message
    }
     
     else {

        $Message = "User and company Not found "
        Write-log -Event "WARNING" -Message $Message
            }
    }

    }
    
    } catch {
        $ExitCode = 1
        $Message = "An error occured:$($ExitCode): $_ "
        Write-log -Event "ERROR" -Message $Message 
    }
}


ApiGetJsonPlaceHolder

