#step 1:
#create one folder and name with date: "30-Jan-18"
#assign one path to store daily GPO backup:  "d:\GPObackup\30-Jan-18\"

$today = get-date
#tips: use commnd "$today.GetDateTimeFormats()" to list all date format in powershell
$foldername = $today.GetDateTimeFormats()[6] 
$path = "E:\GPO-Backup"+$foldername+"\"
new-item -ItemType Directory -Path $path

#step 2:
#backup GPO everyday and store in above path
backup-gpo -All -Path $path -Comment $foldername

#step 3: archive backup files.
$zip_path = "E:\GPO-Backup\"+$foldername
Compress-Archive -Path  $zip_path -CompressionLevel Optimal -DestinationPath $zip_path

#step 4: remove backup files. add parameter force since the backup folder is
#readonly
Remove-Item -Path $zip_path -Recurse -force
