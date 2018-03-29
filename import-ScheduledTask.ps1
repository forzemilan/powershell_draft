#step1:this script will get scheduledTask from one template server.
#step2:copy all related script files to target server local path
#step3:import the scheduledtask into servers which required same scheudledtask
as template server.
#********************************************************
#********************************************************
#this script is using to deploy same scheduledtask to servers which have same
#demand and same service

#Scheduledtask and scripts are in varable sharefolder
$sharefolder = "\\10.5.198.12\d$\TIM\ScheduledTask"
$local_path = "C:\Users\mcs_da_07\Desktop"
#step1
get-ScheduledTask -TaskName cleanup-out* | foreach {    
Export-ScheduledTask -TaskName $_.TaskName -TaskPath $_.TaskPath |
Out-File (Join-Path $sharefolder "$($_.TaskName).xml")       
}

#step2
Get-ChildItem $sharefolder | where {$_.name -like "*.ps1"} | foreach {
Copy-Item -Path $_.FullName -Destination $local_path
}

#step3
Get-ChildItem $sharefolder  | where {$_.name -like "*.xml"} | foreach {
Register-ScheduledTask -Xml (get-content $_.FullName | out-string) -TaskName $_.BaseName -User system  –Force
}
