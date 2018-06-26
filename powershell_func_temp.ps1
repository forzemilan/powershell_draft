<#
.SYNOPSIS
this script is using to delete the expired event log which generated two monthes ago
0. the event log file should start with month word.  eg. "November day*.*"
1. first we get the current month int value (you can specific the basemonth value by using parameter -basemonth)
2. then we navigate to log location (you can specific the log file path by using parameter -loglocation
3. delete the expired event log which log name start with expired log date
.PARAMETER basemonth
Default: current month
.PARAMETER loglocation
Default: D:\TIM\powershell_test\test_file - Copy
.EXAMPLE
remove=dailyeventlog -basemonth 4 -loglocation path
#>
param (
    $baseMonth = (Get-Date).Month,
    $logLocation = 'D:\TIM\powershell_test\test_file - Copy\'
)


if ($baseMonth -eq 1) {
$expiredLogDate = 11
}
elseif ($baseMonth -eq 2){
$expiredLogDate = 12
}
else {
$expiredLogDate = $baseMonth - 2
}
$monthstring = Get-Date -Month $expiredLogDate -Format m
$monthstringindex = ($monthstring).IndexOf(' ')
$month_str = ($monthstring).Substring(0,$monthstringindex)


Write-host attmp to delete $month_str event log -ForegroundColor Yellow

$file_name = Get-ChildItem $logLocation 
foreach ($i in $file_name) {
if (($i.Name.StartsWith($month_str)))  {
Write-host $i.Name is deleting -ForegroundColor Green
Remove-Item -Path $i.PSPath
}
}
