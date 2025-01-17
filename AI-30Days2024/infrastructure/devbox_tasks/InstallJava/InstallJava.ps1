$ProgressPreference = "SilentlyContinue"
Install-Module -Name Microsoft.WinGet.Client -Force
Import-Module -Name Microsoft.WinGet.Client

Install-WinGetPackage -Id "Microsoft.OpenJDK.17"

Install-WinGetPackage -Id "Microsoft.OpenJDK.21"