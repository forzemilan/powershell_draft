#this script is using to get server spec and export to csv with readable format
$cre = get-credential domain\admin
#store your credential in varable cre
$target_server = (Get-Content 'C:\Users\xxx\Desktop\Server_list.csv')
#read server list from file
foreach ($i in $target_server)  {

get the server specs which you want to know
$OS = Gwmi win32_operatingsystem -ComputerName $i -Credential $cre | select-Property version 
$Memory = get-wmiobject Win32_ComputerSystem -ComputerName $i -Credential $cre | select -Property totalphysicalmemory
$cpu = gwmi -Class win32_processor -ComputerName $i -Credential $cre |select -Property name -Last 1
$cpucount =  gwmi -Class win32_processor -ComputerName $i -Credential $cre | select -Property deviceid -Last 1

#export above information to csv with readable formal
$wrapper = New-Object PSObject -Property @{ ServerName = $i; OS = $OS ;CPU = $cpu ; Memory = $Memory; cpu_count = $cpucount}
Export-Csv -InputObject $wrapper -Append -PathC:\Users\xxx\Desktop\Server_spec.csv -NoTypeInformation

}
