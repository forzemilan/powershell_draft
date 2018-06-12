$serverlist = Import-Csv D:\20171227\dnsrecord.txt
#please replace file path to your server list file (include hostname and IP address)
$domain = 'example.com'
#replace $domain to your company domain name

foreach ($i in $serverlist){

Write-Host Adding $i.hostname with $i.ip -ForegroundColor Yellow

try{
 Add-DnsServerResourceRecord -ZoneName $domain -A -Name $i.hostname -IPv4Address $i.ip -ErrorAction stop  -CreatePtr -WhatIf 
 #you can remove -CreatePtr when you only need forwarder resolved.
 Write-Host Adding $i.hostname done. -ForegroundColor Green}
catch{
Write-Host $Error[0] -ForegroundColor Red}

}


#when you confirm the script is working fine on your prod, then you can remove
#-WhatIF and run it again.
