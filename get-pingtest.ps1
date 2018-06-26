$server = Get-Content D:\TIM\DNS_CleanUp\discon_dns_records_1229.txt
$date = Get-Date -Format %M%d_%h%m%s
$date_str = $date.ToString()
foreach ($i in $server) {
write-host attempt to connect $i -ForegroundColor Yellow
if (!(Test-Connection -ComputerName $i -Count 1 -quiet )) {
Add-Content $i -path D:\TIM\DNS_CleanUp\discon_dns_records_$($date).txt
}
}
