$progressPreference = 'silentlyContinue'
$latestWingetMsixBundleUri = $( Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest ).assets.browser_download_url | Where-Object { $_.EndsWith( ".msixbundle" ) }
$latestWingetMsixBundle = $latestWingetMsixBundleUri.Split("/")[-1]
Write-Information "Downloading winget to artifacts directory..."
Invoke-WebRequest -Uri $latestWingetMsixBundleUri -OutFile "./$latestWingetMsixBundle" 
Add-AppxPackage $latestWingetMsixBundle