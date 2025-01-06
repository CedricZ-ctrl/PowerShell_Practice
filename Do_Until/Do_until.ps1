## Learning do-while and do-until


# #### DO - WHILE ####
# $count = 1 
# do {
#     Write-Output $count
#     $count++
# } while ($count -le 7) 


# #### DO - UNTIL ####
# $count = 2
# do {
#     Write-Output $count
#     $count++
# } until ($count -gt 7) 


# ### example with process windows in running ####
# ################################################### DO UNTIL ##################################################
# $processname =  "notepad++"

# do {
#     Write-Output "check if process $processname is running ....."
#     $process = get-process -ProcessName $processname -ErrorAction SilentlyContinue
#     Start-Sleep -Seconds 2

# } until ($process.Name -eq $processname)

# Write-Output "the process $processname is started now"

# ####################################################### DO WHILE #############################################
# $processname =  "notepad++"

# do {
#     Write-Output "check if process $processname is running ....."
#     $process = get-process -ProcessName $processname -ErrorAction SilentlyContinue
#     Start-Sleep -Seconds 2

# } while ($null -eq $process)

# Write-Output "the process $processname is started now"


# ####################################################### exercice chatgpt #############################################

# ############################################# Do-While
# # "je continue tant que c'est vrai",
# $password = "P@sSwOrd"

# do {
#    $usermdp = Read-Host "Veuillez saisir un mot de passe svp"



# } while ($usermdp -ne $password)

# Write-Output "Vous avez trouver le bon mot de passe "


# ############################################## Do-Until
# # "je continue tant que ce n'est pas vrai"
# $password = "P@sSwOrd"

# do {
#    $usermdp = Read-Host "Veuillez saisir un mot de passe svp"
#         if ($usermdp -ne $password) {
#         Write-Output "invalid mot de passe"
#         }



# } until ($usermdp -eq $password)

# Write-Output "Vous avez trouver le bon mot de passe "


######################################################## Do-until Service
 # "je continue tant que ce n'est pas vrai"

# $servicename=  "spooler"

# do {
#     Write-Output "check if service $servicename is running ....."
#     $service = get-service -Name $servicename -ErrorAction SilentlyContinue 
#     Write-Output " try in 5 seconds"
#     Start-Sleep -Seconds 5

# } until ($service.status -eq "Running")

# Write-Output "the service $servicename is started now"

######################################################## Do-while Service
# #"je continue tant que c'est vrai"


# $servicename=  "spooler"

# do {
#     Write-Output "check if service $servicename is running ....."
#     $service = get-service -Name $servicename -ErrorAction SilentlyContinue 
#     Write-Output " try in 5 seconds"
#     Start-Sleep -Seconds 5

# } while ($service.status -eq "stopped")

# Write-Output "the service $servicename is started now"

