mkdir D:\tmp\
(new-object System.Net.WebClient).DownloadFile('https://download.microsoft.com/download/2/C/4/2C47A5C1-A1F3-4843-B9FE-84C0032C61EC/UcmaRuntimeSetup.exe','D:\tmp\UcmaRuntimeSetup.exe')
(new-object System.Net.WebClient).DownloadFile('http://care.dlservice.microsoft.com/dl/download/8/1/1/811B7C54-DA45-48AF-A912-0AA2B6FDA02C/Exchange-x64.exe', 'D:\tmp\Exchange-x64.exe')

D:\tmp\UcmaRuntimeSetup.exe

Add-WindowsFeature Server-Media-Foundation



