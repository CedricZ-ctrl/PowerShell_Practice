function Write-log {
    param(
        [string]$Message,
        [string]$Event
    )
    # Path logs\ MODIFY THE PATH TO SUIT  FOR YOUR NEED
    $logfilepath = "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\ToolKit\LogFile.txt"
    
    #check if path log is not present \COPY AND PASTE, YOUR LOGFILE
    if (!(Test-Path -Path "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\ToolKit")) {
        New-Item -ItemType Directory -Path "B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\CheckServices" -Force
    }
    if (!(Test-Path -Path $logfilepath)) {
        New-Item -ItemType File -Path $logfilepath -Force
    }

    #Add a message and event in your log
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
}

function SetDirectory () {

    $Directory = @("C:\ToolKit",
                   "C:\ToolKit\UserData",
                   "C:\ToolKit\UserData\Documents",
                   "C:\ToolKit\UserData\Download",
                   "C:\ToolKit\UserData\Logs",
                   "C:\ToolKit\Scripts",
                   "C:\ToolKit\Backup") 

    foreach ($dir in $Directory) {
        if (!(Test-Path -Path $dir)) {
            New-Item -Path $dir -ItemType Directory | New-Item -Path $dir -ItemType File -Name Readme.txt
            $Message = "directory $dir not present, creating $dir succes"
            Write-log -Event "INFO" -Message $Message
        }
    
    else {
        $Message = "All directory already "
        Write-log -Event "INFO" -Message $Message
    }
  }
}

SetDirectory 

exit 

