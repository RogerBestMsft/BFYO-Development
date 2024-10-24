
# Write out debug information
$outputFilePath = "InstallSqlManStudio.txt"

# Define the content to be written to the file
$content = "File created $(Get-Date)."

# Write the content to the file
Set-Content -Path $outputFilePath -Value $content


# Define the URL of the file you want to download
$url = "https://aka.ms/ssmsfullsetup"

# Define the destination path where you want to save the file
$destination = "SSMS-Setup-ENU.exe"

# Download the file
Invoke-WebRequest -Uri $url -OutFile $destination


#https://aka.ms/ssmsfullsetup
.\SSMS-Setup-ENU.exe /quiet


$outputFilePath2 = "InstallSqlManStudio2.txt"

# Define the content to be written to the file
$content2 = "File created $(Get-Date)."

# Write the content to the file
Set-Content -Path $outputFilePath2 -Value $content2

$outputFilePath3 = "C:\Temp\Installsqlmanstudio3.txt"
$content3 = "Execution $(Get-Location)"
Set-Content -Path $outputFilePath3 -Value $content3
