New-Item "c:\temp" -ItemType Directory
New-Item "c:\temp\diagnostics.txt" -ItemType File

Add-Content -Path "c:\temp\diagnostics.txt" -Value ${Get-Date}