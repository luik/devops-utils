#Import-Module ServerManager
#Add-WindowsFeature NET-WCF-HTTP-Activation45,NET-WCF-TCP-Activation45,NET-WCF-Pipe-Activation45
#Add-WindowsFeature Net-Framework-Features,Web-Server,Web-WebServer,Web-Common-Http,Web-Static-Content,Web-Default-Doc,Web-Dir-Browsing,Web-Http-Errors,Web-App-Dev,Web-Asp-Net,Web-Net-Ext,Web-ISAPI-Ext,Web-ISAPI-Filter,Web-Health,Web-Http-Logging,Web-Log-Libraries,Web-Request-Monitor,Web-Http-Tracing,Web-Security,Web-Basic-Auth,Web-Windows-Auth,Web-Filtering,Web-Digest-Auth,Web-Performance,Web-Stat-Compression,Web-Dyn-Compression,Web-Mgmt-Tools,Web-Mgmt-Console,Web-Mgmt-Compat,Web-Metabase,Application-Server,AS-Web-Support,AS-TCP-Port-Sharing,AS-WAS-Support, AS-HTTP-Activation,AS-TCP-Activation,AS-Named-Pipes,AS-Net-Framework,WAS,WAS-Process-Model,WAS-NET-Environment,WAS-Config-APIs,Web-Lgcy-Scripting,Windows-Identity-Foundation,Server-Media-Foundation,Xps-Viewer

#mkdir D:\tmp\
#(new-object System.Net.WebClient).DownloadFile('https://download.microsoft.com/download/4/2/A/42A19755-CBA5-4090-A6B8-8F7DA482114C/Windows8-RT-KB2771431-x64.msu','D:\tmp\Windows8-RT-KB2771431-x64.msu')
#D:\tmp\Windows8-RT-KB2771431-x64.msu

Import-Module ServerManager

Copy-Item -Path "$($ENV:SystemRoot)\System32\ServerManager.exe" `
    -Destination "$($ENV:SystemRoot)\System32\ServerManagerCmd.exe" -Force

Add-WindowsFeature NET-WCF-HTTP-Activation45,NET-WCF-TCP-Activation45,NET-WCF-Pipe-Activation45

Add-WindowsFeature Net-Framework-Features,Web-Server,Web-WebServer, `
    Web-Common-Http,Web-Static-Content,Web-Default-Doc,Web-Dir-Browsing, `
    Web-Http-Errors,Web-App-Dev,Web-Asp-Net,Web-Net-Ext,Web-ISAPI-Ext, `
    Web-ISAPI-Filter,Web-Health,Web-Http-Logging,Web-Log-Libraries,Web-Request-Monitor, `
    Web-Http-Tracing,Web-Security,Web-Basic-Auth,Web-Windows-Auth,Web-Filtering, `
    Web-Digest-Auth,Web-Performance,Web-Stat-Compression,Web-Dyn-Compression, `
    Web-Mgmt-Tools,Web-Mgmt-Console,Web-Mgmt-Compat,Web-Metabase,Application-Server, `
    AS-Web-Support,AS-TCP-Port-Sharing,AS-WAS-Support, AS-HTTP-Activation, `
    AS-TCP-Activation,AS-Named-Pipes,AS-Net-Framework,WAS,WAS-Process-Model, `
    WAS-NET-Environment,WAS-Config-APIs,Web-Lgcy-Scripting,Windows-Identity-Foundation, `
    Server-Media-Foundation,Xps-Viewer

Restart-Computer



