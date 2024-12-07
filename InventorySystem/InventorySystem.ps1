
### pull informations Bios on system 

Get-CimInstance -ClassName Win32_BIOS 

### pull information processor and type Socket 
Get-CimInstance -ClassName Win32_Processor | Select-Object Name,SocketDesignation

#### pull information general on system 

Get-CimInstance -ClassName Win32_ComputerSystem 

####### pull information physical memory (RAM)
PS B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\InventorySystem> Get-CimInstance -ClassName Win32_PhysicalMemoryArray

Name             MemoryDevices                                MaxCapacity                                  Model
----             -------------                                -----------                                  -----
Bloc de mémoi... 4                                            134217728


PS B:\VSCode_Exercice\Exercices_Powershell\PowerShell_Practice\InventorySystem> Get-CimInstance -ClassName Win32_PhysicalMemoryLocation

GroupComponent                                              PartComponent                                    LocationWithinContainer PSComputerName
--------------                                              -------------                                    ----------------------- --------------
Win32_PhysicalMemoryArray (Tag = "Physical Memory Array 0") Win32_PhysicalMemory (Tag = "Physical Memory 0")
Win32_PhysicalMemoryArray (Tag = "Physical Memory Array 0") Win32_PhysicalMemory (Tag = "Physical Memory 1")
Win32_PhysicalMemoryArray (Tag = "Physical Memory Array 0") Win32_PhysicalMemory (Tag = "Physical Memory 2")
Win32_PhysicalMemoryArray (Tag = "Physical Memory Array 0") Win32_PhysicalMemory (Tag = "Physical Memory 3")
