param (
    [string] $devCenterConfigFolder = "",
    [string] $subscriptionId = "",
    [string] $projectConfigFolder = ""
)

# Interactive login to Azure
#az login

# Set the appropriate subscription 
az account set --subscription $subscriptionId

# Get all files in devcenter folder
$devCenterConfigFiles = Get-ChildItem -Path $devCenterConfigFolder -Name
# Deploy the DevCenter
#az deployment group create --resource-group $psObject.resourceGroupName --name "$($psObject.name)-deploy" --template-file "DevCenter\Primary.bicep" --parameters devCenterConfigObject=@$configurationFile
foreach ($dcConfig in $devCenterConfigFiles) {
    $currentConfig = Join-Path -Path $devCenterConfigFolder -ChildPath $devCenterConfigFiles #$dcConfig
    $devCenterInfo =  Get-Content -Raw -Path $currentConfig | ConvertFrom-Json
    # Get the DevCenter
    $devCenter = az devcenter admin devcenter show --name $devCenterInfo.name --resource-group $devCenterInfo.resourceGroupName | ConvertFrom-Json
    # Get all Projects
    $projects = az devcenter dev project list --dev-center-name $devCenter.name
    # Get all environments
    # Delete environments
    # Delete networks
    # Delete galleries
    foreach ($gallery in $devCenterInfo.galleries){
        az sig delete --resource-group $gallery.resourceGroupName --gallery-name $gallery.name
    }
    # Delete projects & rgs
    # Delete devcenters & rgs
    az devcenter admin devcenter delete --ids $devCenter.id
    az group delete --name $devCenter.resourceGroup
}
