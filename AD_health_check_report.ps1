#AD health check
    write-host log in with domain admin
    $cred = get-credential
#2.1  Domain Controller List
    write-host get dc server list
    import-module ActiveDirectory
    $ADInfo = Get-ADDomain
    $ADDomainReadOnlyReplicaDirectoryServers = $ADInfo.ReadOnlyReplicaDirectoryServers
    $ADDomainReplicaDirectoryServers = $ADInfo.ReplicaDirectoryServers
    $DomainControllers = $ADDomainReadOnlyReplicaDirectoryServers + ` $ADDomainReplicaDirectoryServers 
    
#2.2  Domain Controller UAC check
    
Get-ADComputer -SearchBase "OU=Domain Controllers,DC=AIA,DC=BIZ" -Filter * -Properties useraccountcontrol | 

Select @{Label = "useraccountcontrol";Expression = {if (($_.useraccountcontrol -eq '532480' -or $_.useraccountcontrol -eq '83890176')  ) {'correct'} Else {'warnning'}}},name

#2.3  Domain Controller Disk Capacity
    #use the domain\administrator

    $query = "select * from win32_logicaldisk where drivetype = '3'"
    foreach ($server in $DomainControllers){
        "Servername - " + $server 
        $disks = gwmi -query $query -credential $cred -computername $server
            foreach ($disk in $disks){
            "deviveID - " + $disk.deviceid
            "Freesieze(mB) - " + ($disk.freespace/1mb)
            "usage(%) - " + ($disk.freespace/$disk.size*100)
            }
    }
#2.4  Domain Controller DNS Checks

    Resolve-DnsName -Name $DomainControllers -Type A

#2.5  Domain Controller Advertising

    $svcs = "kdc","Dfs"  #please adjust the services name 
    Get-Service -name $svcs -ComputerName $DomainControllers | Sort Machinename | Format-Table -group @{Name="Computername";Expression={$_.Machinename.toUpper()}} -Property Name,Displayname,Status

#2.6  Domain Controller Default Shares
    Get-WmiObject -Class Win32_Share -ComputerName $DomainControllers -credential $cred | ?{$_.description -eq "Default share"} | sort ComputerName | Format-Table -Group @{Name="Computername";Expression={$_.computername.toupper()}} -Property name,path,description 

#2.7  Domain DFS Referral Configuration
    

#2.8  Domain Functional Level
     # Get Domain Functional Level 
     Get-ADDomain | fl Name,DomainMode
     # Get Forest Functional Level
     Get-ADForest | fl Name,ForestMode 
#2.9  Domain FSMO Checks
    NETDOM /QUERY FSMO

#2.10 Domain Group Policy Checks
    Import-Module grouppolicy

    #iii. Unlinked Policies Check  result issue   this command will cost long time
    Get-GPO -All | 
     %{ 
         If ( $_ | Get-GPOReport -ReportType XML | Select-String -NotMatch "<LinksTo>" )
          {
              Write-Host $_.DisplayName
             }
      }
#2.11 Inactive Accounts Check
    Import-Module activedirectory
    Search-ADAccount -accountinactive -usersonly | ft name,sid,lastlogondate
    Search-ADAccount -accountinactive -computersonly | ft distinguishedname,lastlogondate

#2.12 Domain Controller OS Version

    Get-CimInstance Win32_OperatingSystem -ComputerName $servers | Select-Object Caption, Version, ServicePackMajorVersion, OSArchitecture, CSName, WindowsDirectory


#2.13 Replication Error Check
    
    repadmin /showrepl * /csv | ConvertFrom-Csv | Out-GridView  

#2.14 Sites and Subnets Checks
    #i Non associated Subnet Check
    # This check searches for subnets not associated with a site in the Active Directory. Subnets not linked to a site will be unable to redirect clients to the closest domain controller.
    $subnet_without_site = Get-ADReplicationSubnet -Filter *  | ?{$_.site -eq $null}

    #ii  Empty Site Check
    # This check searches for sites in the Active Directory which do not have any subnets assigned. Sites without subnets will not be used by clients for authentication.
    #### version 0
     #$site_has_subnets = Get-ADReplicationSubnet -Filter *  | ?{$_.site -ne $null} | select -Property site | ForEach-Object -Process { (($_.site.tostring() -split ',')[0] -split '=')[1]} | sort -Unique
     #$site_baseline = Get-ADReplicationSite -Filter * | select -Property name | ForEach-Object -Process { $_.name.tostring()} | sort -Unique
     #Compare-Object $site_baseline $site_has_subnets
    ####  version 1
     Get-ADReplicationSite -Filter * -Properties * | ?{$_.subnets -eq $null}

    #iii. Default First Site Name Check
    # This check ensures that the Default-First-Site-Name site has been removed. This site should be renamed or removed to ensure that subnets are not incorrectly assigned to this site.
    Get-ADReplicationSite -Identity "Default-First-Site-Name"

    #iv. Default IP Site Link Check
    # This check ensures that the DEFAULTIPSITELINK site link has been removed. This link should be renamed or removed to ensure that sites are not incorrectly linked by this site link

    #v. Orphaned Server Check
    # The forest is queried for orphaned site server objects which can remain after demoting domain controllers. These objects may need to be manually deleted from AD Sites and Services for one or more demoted domain controllers
    Get-ADReplicationSite -Filter * -Properties * |select -Property CN,InterSiteTopologyGenerator

    #vi. Overlapping Subnet Check
    #The forest is checked for overlapping subnets. If subnets overlap, then computers may be directed to multiple sites.

    #**********The following changes should be made:

    #**********Subnets which are not linked to a site should be removed if they are no longer valid or associated with a site.
    #**********Orphaned objects were found, which should be checked and removed if they are not valid servers.
    #**********Overlapping subnets were detected. These subnets should be checked and the incorrect subnet removed.

#2.17 Domain Controller Time Service Check


#2.18 Domain Controller WINS Checks


        

