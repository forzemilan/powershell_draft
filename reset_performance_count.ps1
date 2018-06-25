#rebuild performance count 
lodctr /R
$service_status = get-service -name "winrm"
if ($service_status -eq 'stopped') {
Start-Service -name "winrm"
} 

