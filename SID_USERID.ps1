
#Step 1: Domain User to SID

#This will give you a Domain User's SID

$objUser = New-Object System.Security.Principal.NTAccount("DOMAIN_NAME", "USER_NAME")
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$strSID.Value
#Step 2: SID to Domain User

#This will allow you to enter a SID and find the Domain User

$objSID = New-Object System.Security.Principal.SecurityIdentifier `
("ENTER-SID-HERE")
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
$objUser.Value
#Step 3: LOCAL USER to SID

$objUser = New-Object System.Security.Principal.NTAccount("LOCAL_USER_NAME")
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$strSID.Value

