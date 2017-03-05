mkdir D:\tmp\
(new-object System.Net.WebClient).DownloadFile('http://care.dlservice.microsoft.com/dl/download/3/D/7/3D713F30-C316-49B8-9CC0-E1BFC34B63A0/SharePointServer_x64_en-us.img','D:\tmp\SharePointServer_x64_en-us.img')
(new-object System.Net.WebClient).DownloadFile('https://download.microsoft.com/download/7/A/8/7A84E002-6512-4506-A812-CA66FF6766D9/officeserversp2013-kb2880552-fullfile-x64-en-us.exe','D:\tmp\officeserversp2013-kb2880552-fullfile-x64-en-us.exe')
D:\tmp\SharePointServer_x64_en-us.img
E:\splash.hta


start "Launch SharePoint preparation tool" "E:\prerequisiteinstaller.exe" /continue
