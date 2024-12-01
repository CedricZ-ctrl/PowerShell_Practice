


function Write-log {
    param(
        [string]$Message,
        [string]$Event
    )
    # Path logs
    $logfilepath = "B:\VSCode_Exercice\Exercices_Powershell\CheckServices\LogFile.txt"
    
    #check if path log is not present
    if (!(Test-Path -Path "B:\VSCode_Exercice\Exercices_Powershell\CheckServices")) {
        New-Item -ItemType Directory -Path "B:\VSCode_Exercice\Exercices_Powershell\CheckServices" -Force
    }
    if (!(Test-Path -Path $logfilepath)) {
        New-Item -ItemType File -Path $logfilepath -Force
    }

    # Ajoute le message au fichier
    $timestamp = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    Add-Content -Path $logfilepath -Value "[$timestamp][$Event] $Message"
}

    $listservices = "wuauserv","Spooler","Dhcp"

    foreach ($services in $listservices) {
        Try{
            $serviceStatus = get-service -Name $listservices 

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
            $Message = "Service '$service' could not be found or started. Error: $_"
            Write-log -Message $Message -Event "ERROR"
        }
    }