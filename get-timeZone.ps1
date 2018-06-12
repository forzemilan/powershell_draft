'''
Date: "China Standard Time"
Author: spookw@foxmail.com
'''



Get-Credential userID
#Command Get-Credential will pop up one window for you to enter password.

$serverlist = Get-Content ***\serverlist.txt
#get the server list on specific file path which include the server names


Invoke-Command -ComputerName $serverlist -ScriptBlock { 
try {
$get_time_zone = tzutil /g
#tzutil /g will get the local time zone information and store reulst in parameter $time_zone
$hostname = hostname
$time_zone = "China Standard Time"
#you can change time zone as your local time zone
if ($command -eq $time_zone){
write-host time zone on $hostname is $command
}
}catch{
write-host $Error -ForegroundColor Red
}
}