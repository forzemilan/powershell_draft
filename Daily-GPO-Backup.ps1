#step 1:
#create one folder and name with date: "30-Jan-18"
#assign one path to store daily GPO backup:  "d:\GPObackup\30-Jan-18\"

$today = get-date
#tips: use commnd "$today.GetDateTimeFormats()" to list all date format in powershell
$foldername = $today.GetDateTimeFormats()[6] 
$path = "D:\TIM\"+$foldername+"\"
new-item -ItemType Directory -Path $path

#step 2:
#backup GPO everyday and store in above path
backup-gpo -All -Path $path -Comment $foldername

#step 3: archive backup files.
$log_folder = ' "E:\GPO-Backup\"+$foldername'
Compress-Archive -Path  $log_folder -CompressionLevel Optimal -DestinationPath $log_folder

#step 4: remove backup files.
Remove-Item -Path $log_folder -Recurse
