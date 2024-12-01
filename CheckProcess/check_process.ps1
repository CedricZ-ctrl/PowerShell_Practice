####### script powershell check process and kill process specified ###############

######
#settings logs
#######


function Write-log {
    param(
        [string]$Message,
        [string]$Event
    )
    # Path logs
    $logfilepath = "B:\VSCode_Exercice\Exercices_Powershell\CheckProcess\LogFile.txt"
    
    #check if path log is not present
    if (!(Test-Path -Path "B:\VSCode_Exercice\Exercices_Powershell\CheckProcess")) {
        New-Item -ItemType Directory -Path "B:\VSCode_Exercice\Exercices_Powershell\CheckProcess" -Force
    }
    if (!(Test-Path -Path $logfilepath)) {
        New-Item -ItemType File -Path $logfilepath -Force
    }

    # Ajoute le message au fichier
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
}


$NameProcess = "PuTTY","Notepad++"

function CheckProcess () {
    
      $processrunning = (Get-Process -Name $NameProcess -ErrorAction SilentlyContinue | select ProcessName).ProcessName
      return $processrunning
}

$foundprocess = CheckProcess
if ($foundprocess) {
    foreach ($process in $foundprocess) {
    $Message = "Process trouve : $process"
    Write-log -Event "INFO" -Message $Message
}
} else {
    $Message = "Not found Process"
    Write-log -Event "WARNING" -Message $Message
}



# switch (CheckProcess) {

#     "notepad++"{
#         $Message = "Notepad found in process windows"
#         Write-log -Event "INFO" -Message $Message

#     }
#     "putty"{
#         $Message = "Putty found in process windows"
#         Write-log -Event "INFO" -Message $Message

#     }
#     default {
#         $Message = "Putty and Notepad++,not found process in list"
#         Write-log -Event "WARNING" -Message $Message
#     }
# }
