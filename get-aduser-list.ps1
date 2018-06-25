
$path = $env:USERPROFILE +"\desktop\$($(get-date).GetDateTimeFormats()[6]).csv"

$SearchBase = "OU=xxx,DC=company_name,DC=com"

#$GetAdminact = Get-Credential

#$ADServer = 'DC_server'

$AllADUsers = Get-ADUser -Filter *  -searchbase $SearchBase  -Properties enabled,DisplayName,SamAccountName,title,company,department,description,DistinguishedName |
Select @{Label = "Account Status";Expression = {if (($_.Enabled -eq 'TRUE')  ) {'Enabled'} Else {'Disabled'}}}, # the 'if statement# replaces $_.Enabled
@{Label = "Display Name";Expression = {$_.displayname}},
@{Label = "Logon Name";Expression = {$_.sAMAccountName}},
@{Label = "Job Title";Expression = {$_.Title}},
@{Label = "Company";Expression = {$_.company}},
@{Label = "Department";Expression = {$_.department}},
@{Label = "Description";Expression = {$_.description}},
@{Label = "OU";Expression = {$_.DistinguishedName}}| 

#Export CSV report

Export-Csv -Path $path -UseCulture -NoTypeInformation -encoding UTF8 
