# Write out configuration to devbox....

$TestFile = "C:\Temp\AAA.txt"
New-Item -Path $TestFile -ItemType File 
Set-Content -Path $TestFile -Value $(Winget --version)
Set-Content -Path $TestFile -Value "============================"
Set-Content -Path $TestFile -Value $(git --version)
Set-Content -Path $TestFile -Value "============================"
Set-Content -Path $TestFile -Value $(java -version)
Set-Content -Path $TestFile -Value "============================"
Set-Content -Path $TestFile -Value $(az --version)
Set-Content -Path $TestFile -Value "============================"
Set-Content -Path $TestFile -Value $(node -v)
Set-Content -Path $TestFile -Value "============================"
Set-Content -Path $TestFile -Value $(npm -v)