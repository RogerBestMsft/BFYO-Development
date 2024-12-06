New-Item "c:\temp" -ItemType Directory
New-Item "c:\temp\diagnosticsuser.txt" -ItemType File

Add-Content -Path "c:\temp\diagnosticsuser.txt" -Value ${Get-Date}