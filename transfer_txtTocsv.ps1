$serverlist = (Get-Content D:\TIM\powershell_test\serverlist.txt)

foreach ($i in $serverlist) {

$server = $i.Split("`t")[0] 
$hotfix = $i.Split("`t")[1]
$wrapper = New-Object PSObject -Property @{ ServerName = $server; HotfixCount = $hotfix}
Export-Csv -InputObject $wrapper -Append -Path D:\TIM\powershell_test\serverlist.csv -NoTypeInformation
}


