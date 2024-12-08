function Write-log {
    param(
        [string]$Message,
        [string]$Event
    )
    # Path logs 
    $logfilepath = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\InventorySystem\LogFile.txt"
    
    #check if path log is not present
    if (!(Test-Path -Path "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\InventorySystem")) {
        New-Item -ItemType Directory -Path "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\InventorySystem" -Force
    }
    if (!(Test-Path -Path $logfilepath)) {
        New-Item -ItemType File -Path $logfilepath -Force
    }

    # Ajoute le message au fichier
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
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

    foreach ($key in $infosystem.Keys) {

    $Message  = "$key : $($infosystem[$key])   "
    Write-log -Event "Informations System" -Message $Message
    }
  } catch {
    Write-log -Event "ERROR" -Message "Error collecting system information : $_ "
  }
}

InventorySystem
