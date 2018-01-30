$start_time = get-date
#enter your scirptblock between $start_time and $end_time
#use get-hotfix as example
Get-HotFix
$end_time = get-date
$run_time = ($end_time - $start_time).totalseconds
Write-Host ("Total Run time is: ($run_time) seconds") -ForegroundColor yellow
