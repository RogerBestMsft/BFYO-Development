
# Define the URL of the file you want to download
$url = "https://aka.ms/ssmsfullsetup"

# Define the destination path where you want to save the file
$destination = "SSMS-Setup-ENU.exe"

# Download the file
Invoke-WebRequest -Uri $url -OutFile $destination


#https://aka.ms/ssmsfullsetup
.\SSMS-Setup-ENU.exe /quiet