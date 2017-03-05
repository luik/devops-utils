New-ADUser -SamAccountName spadmin `
-Name "spadmin" `
-UserPrincipalName spadmin@domain.milkneko.com `
-AccountPassword (ConvertTo-SecureString -AsPlainText "Contrasena32!" -Force) `
-Enabled $true -PasswordNeverExpires $true `
-GivenName "sp"
-Surname "admin" `
-Path 'CN=Users,DC=domain,DC=milkneko,DC=com'


Add-ADGroupMember Administrators spadmin

