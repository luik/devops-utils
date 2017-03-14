New-ADUser -SamAccountName spadmin `
-Name "spadmin" `
-UserPrincipalName spadmin@domain.milkneko.com `
-AccountPassword (ConvertTo-SecureString -AsPlainText "Contrasena32!" -Force) `
-Enabled $true -PasswordNeverExpires $true `
-GivenName "sp"
-Surname "admin" `
-Path 'CN=Users,DC=domain,DC=milkneko,DC=com'

Add-ADGroupMember Administrators spadmin


New-ADUser -SamAccountName sqlserveradmin `
-Name "sqlserveradmin" `
-UserPrincipalName sqlserveradmin@domain.milkneko.com `
-AccountPassword (ConvertTo-SecureString -AsPlainText "Contrasena32!" -Force) `
-Enabled $true -PasswordNeverExpires $true `
-GivenName "sqlserver"
-Surname "admin" `
-Path 'CN=Users,DC=domain,DC=milkneko,DC=com'

Add-ADGroupMember Administrators sqlserveradmin


New-ADUser -SamAccountName exchangeadmin `
-Name "exchangeadmin" `
-UserPrincipalName exchangeadmin@domain.milkneko.com `
-AccountPassword (ConvertTo-SecureString -AsPlainText "Contrasena32!" -Force) `
-Enabled $true -PasswordNeverExpires $true `
-GivenName "exchange"
-Surname "admin" `
-Path 'CN=Users,DC=domain,DC=milkneko,DC=com'

Add-ADGroupMember Administrators exchangeadmin

