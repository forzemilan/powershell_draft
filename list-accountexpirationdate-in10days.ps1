'''
Title AccountExpirationscript
'''

$date1 = (get-date).AddDays(10)
$OU_location = "OU=ouname,DC=company,DC=com"
#display Account expirate in 10 days.
get-aduser -Filter * -SearchBase $OU_location -Properties accountexpirationdate | `
sort -Property accountexpirationdate | `
foreach {if ($_.accountexpirationdate -ne $null -and $_.accountexpirationdate -lt $date1) {
Write-Host $_.name`t,$_.accountexpirationdate`t,$_.UserPrincipalName -ForegroundColor Yellow
}

#close prompt window once recieve user order "Y/y"
$userAction = Read-Host "enter Y to close this window."
if ($userAction.ToLower() -eq "y") {
Get-Process powershell | where{$_.MainWindowTitle -eq "AccountExpirationscript"} | Stop-Process
}
