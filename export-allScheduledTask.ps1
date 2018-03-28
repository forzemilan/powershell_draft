get-ScheduledTask | foreach {    
Export-ScheduledTask -TaskName $_.TaskName -TaskPath $_.TaskPath |
Out-File (Join-Path "\\fileserver\sharefolder" "$($_.TaskName).xml")         
}
