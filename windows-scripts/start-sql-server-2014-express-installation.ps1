mkdir D:\tmp\
(new-object System.Net.WebClient).DownloadFile('https://download.microsoft.com/download/E/A/E/EAE6F7FC-767A-4038-A954-49B8B05D04EB/ExpressAdv%2064BIT/SQLEXPRADV_x64_ENU.exe','D:\tmp\SQLEXPRADV_x64_ENU.exe')
(new-object System.Net.WebClient).DownloadFile('https://download.microsoft.com/download/9/3/3/933EA6DD-58C5-4B78-8BEC-2DF389C72BE0/SSMS-Setup-ENU.exe','D:\tmp\SSMS-Setup-ENU.exe')
D:\tmp\SQLEXPRADV_x64_ENU.exe