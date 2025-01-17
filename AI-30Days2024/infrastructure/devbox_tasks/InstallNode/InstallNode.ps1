$ProgressPreference = "SilentlyContinue"
Install-Module -Name Microsoft.WinGet.Client -Force
Import-Module -Name Microsoft.WinGet.Client

Install-WinGetPackage -Id "OpenJS.NodeJS.LTS"
