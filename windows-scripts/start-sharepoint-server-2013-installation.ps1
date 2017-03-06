mkdir D:\tmp\
(new-object System.Net.WebClient).DownloadFile('http://care.dlservice.microsoft.com/dl/download/3/D/7/3D713F30-C316-49B8-9CC0-E1BFC34B63A0/SharePointServer_x64_en-us.img','D:\tmp\SharePointServer_x64_en-us.img')
D:\tmp\SharePointServer_x64_en-us.img
E:\splash.hta


start "Launch SharePoint preparation tool" "E:\prerequisiteinstaller.exe" /continue

Add-PsSnapin Microsoft.SharePoint.PowerShell
$SearchService = Get-Credential $env:computername\Administrator
New-SPManagedAccount -Credential $SearchService

