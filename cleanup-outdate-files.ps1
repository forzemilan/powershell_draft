#change dir to target dir
cd "E:\ID_locked\"

#get last month string which match log files name
$today = get-date
$lastmonth_1 = $today.AddMonths(-1)
$lastmonth_2 = $lastmonth_1.GetDateTimeFormats()[6]
$lastmonth_3 = $lastmonth_2.Substring(3)

#delete last month log files
Get-ChildItem | ?{$_.BaseName -match $lastmonth_3} | Remove-Item

