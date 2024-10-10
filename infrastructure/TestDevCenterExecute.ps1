param (
    [string] $devCenterConfigFolder = "",
    [string] $subscriptionId = "",
    [string] $projectConfigFolder = ""
)


# Check az version
Write-Output "------- Azure Cli information -------"
Write-Output $(az version)

# Interactive login to Azure
#az login

# Set the appropriate subscription 
az account set --subscription $subscriptionId

# Get the Win365
$W365PRINCIPALID="$(az ad sp show --id 0af06dc6-e4b5-4f28-818e-e78e62d137a5 --query id --output tsv)" 

# Get all files in devcenter folder
$devCenterConfigFiles = Get-ChildItem -Path $devCenterConfigFolder -Name
# Deploy the DevCenter
#az deployment group create --resource-group $psObject.resourceGroupName --name "$($psObject.name)-deploy" --template-file "DevCenter\Primary.bicep" --parameters devCenterConfigObject=@$configurationFile
foreach ($dcConfig in $devCenterConfigFiles) {
    $currentConfig = Join-Path -Path $devCenterConfigFolder -ChildPath $dcConfig
    $psObject = Get-Content -Path $currentConfig -Raw | ConvertFrom-Json
    Write-Output $dcConfig
    az deployment sub create --location $psObject.location --name "$($psObject.name)-deploy" --template-file "DevCenter\Primary.bicep" --parameters devCenterConfigObject=@$currentConfig win365Id=$W365PRINCIPALID
}


$devProjectConfigFiles = Get-ChildItem -Path $projectConfigFolder -Name
# Deploy the DevCenter

foreach ($dpConfig in $devProjectConfigFiles) {
    $currentConfig = Join-Path -Path $projectConfigFolder -ChildPath $dpConfig
    $psObject = Get-Content -Path $currentConfig -Raw | ConvertFrom-Json
    Write-Output $dpConfig
    az deployment sub create --location $psObject.location --name "$($psObject.name)-deploy" --template-file "DevProject\Primary.bicep" --parameters devProjectConfigObject=@$currentConfig
}