$iteration = 0
import-module Pscx
clear-host

#####################################
# Program configuration information #
#####################################

#Where the report is saved
$reportLocation = get-content C:\TriageTool\ReportLocation.txt

#Report Formatting
$a = "<style>"
$a = $a + "BODY{background-color:Lavender ;}"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:thistle}"
$a = $a + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:PaleGoldenrod}"
$a = $a + "</style>"

function Main
{
    ####################################
    # Scan Current Drive Configuration #
    ####################################
    $Drives = ""
    $Drives = get-wmiObject Win32_DiskDrive | select -property DeviceID
    $startCount = 0
    $newCount = 0
    foreach ($Drive in $Drives)
    {
        $startCount = $startCount + 1
        $newCount = $newCount + 1
    }
    
    ######################################
    # Wait for new drive to be connected #
    ######################################
    "Scanning for new device..."
    while ($startCount -ge $newCount)
    {
        $Drives = get-wmiObject Win32_DiskDrive | select -property DeviceID
        $newCount = 0
        foreach ($Drive in $Drives)
        {
            $newCount = $newCount + 1
        }
        start-sleep -s 5
    }
    clear-host
    write-host "New drive detected:"
    write-host ""
    
    ##################
    # Get drive info #
    ##################
    $DriveID = ""
    $DriveID = $Drive -replace "@{DeviceID=", "" -replace "}", ""  
    $diskSize = @{Label="Size (Gb)";expression={"{0:N2}" -f ($_.size/1GB)}}
    get-wmiObject Win32_DiskDrive | where {$_.deviceID -eq "$DriveID"} | select -property Model, Caption, $diskSize, Partitions
    
    ####################################
    # Get info from user : Case number #
    ####################################
    write-host ""
    $caseNo = ""
    $caseNo = Read-Host "Enter the case number : "
    
    write-host ""
    $evidenceID = ""
    $evidenceID = Read-Host "Enter the evidence ID number : "
    
    new-item -itemType directory -path "$($reportLocation)\$($caseNo)" -erroraction silentlycontinue
    
    ############################
    # Select partition to scan #
    ############################
    write-host ""
    $path = ""
    $path = read-host "Enter the partition letter (E.g. C:\) : "
    
    clear-host
    write-host ""
    write-host "Generating the triage report..."
    
    #Add heading information to report
    $newPath = ""
    $newPath = $path -replace ":", "" -replace "\\", ""
    $newPath = $newPath.ToUpper()
    
    ######################
    # Get partition info #
    ######################
    $partitions = ""
    $partitions = get-wmiObject Win32_DiskDrive | where {$_.deviceID -eq "$DriveID"} | select -property Partitions
    $partitions = $partitions -replace "@{Partitions=", "" -replace "}", ""
    $partitions = [int]$partitions
    
    while ($partitions -ne 0)
    {
        $partitions --
        
        $iteration = $iteration + 1
            
        ConvertTo-Html -Head $a -Body "<h1> Case Number : $CaseNo | Evidence ID : $EvidenceID</h1>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"

        #Add drive info to report
        get-wmiObject Win32_DiskDrive | where {$_.deviceID -eq "$DriveID"} | select -property Model, Caption, $diskSize, Partitions | ConvertTo-HTML -Body "<H2>Drive Details:</H2>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
        write-host ""
        write-host "Drive information recorded"
        start-sleep -s 1
    
        $freeSpace = @{Label="Free Space (Gb)";expression={"{0:N2}" -f ($_.TotalFreeSpace/1GB)}}
        $partitionSize = @{Label="Total Size (Gb)";expression={"{0:N2}" -f ($_.TotalSize/1GB)}}
        
        #Output partition info to report
        [System.IO.DriveInfo]::GetDrives() | where {$_.Name -eq "$Path" } | select -property Name, VolumeLabel, DriveFormat, $partitionSize, $freeSpace | ConvertTo-HTML -Body "<H2>Partition Details:</H2>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
        write-host ""
        write-host "Partition information recorded"
        start-sleep -s 1
        
        #################################
        # Test if partition contains OS #
        #################################
        $UsrsExst = test-path "$($Path)Users\"
        $WindwsExst = test-path "$($Path)Windows\"
        write-host ""
        write-host "OS detection completed"
        start-sleep -s 1
        
        if ($UsrsExst -eq 'true' -and $WindwsExst -eq 'true')
        {
            #########################
            # Run OS specific scans #
            #########################
            ConvertTo-Html -Body "<h2>Contains Operating System (Windows 7)? : Yes</h2>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
            
            #test if 32/64 bit
            $64bit = test-path "$($Path)Program Files (x86)"
            if ($64bit -eq 'true')
            {
                ConvertTo-Html -Body "<h2>32/64 bit? : 64 Bit</h2>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                
                #check for web browsers - 64 bit
                ConvertTo-Html -Body "<h2>Web browsers installed:</h2>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                
                $ieExst = test-path "$($Path)Program Files (x86)\Internet Explorer\iexplore.exe"
                $firefoxExst = test-path "$($Path)Program Files (x86)\Mozilla Firefox\Firefox.exe"
                $chromeExst = test-path "$($Path)Program Files (x86)\Google\Chrome\Application\Chrome.exe"
                
                if ($ieExst -eq 'true')
                {
                    ConvertTo-Html -Body "Internet Explorer Installed? : Yes" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                    ConvertTo-Html -Body "<br>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                }
                else
                {
                    ConvertTo-Html -Body "Internet Explorer Installed? : No" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                    ConvertTo-Html -Body "<br>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                }
                
                if ($firefoxExst -eq 'true')
                {
                    ConvertTo-Html -Body "Firefox Installed? : Yes" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                    ConvertTo-Html -Body "<br>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                }
                else
                {
                    ConvertTo-Html -Body "Firefox Installed? : No" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                    ConvertTo-Html -Body "<br>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                }
                
                if ($chromeExst -eq 'true')
                {
                    ConvertTo-Html -Body "Google Chrome Installed? : Yes" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                    ConvertTo-Html -Body "<br>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                }
                else
                {
                    ConvertTo-Html -Body "Google Chrome Installed? : No" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                    ConvertTo-Html -Body "<br>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                }
            }
            
            else
            {
                ConvertTo-Html -Body "<h2>32/64 bit? : 32 Bit</h2>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                
                #check for web browsers - 32 bit
                ConvertTo-Html -Body "<h2>Web browsers installed:</h2>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                
                $ieExst = test-path "$($Path)Program Files\Internet Explorer\iexplore.exe"
                $firefoxExst = test-path "$($Path)Program Files\Mozilla Firefox\Firefox.exe"
                $chromeExst = test-path "$($Path)Program Files\Google\Chrome\Application\Chrome.exe"
                
                if ($ieExst -eq 'true')
                {
                    ConvertTo-Html -Body "Internet Explorer Installed? : Yes" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                    ConvertTo-Html -Body "<br>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                }
                else
                {
                    ConvertTo-Html -Body "Internet Explorer Installed? : No" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                    ConvertTo-Html -Body "<br>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                }
                
                if ($firefoxExst -eq 'true')
                {
                    ConvertTo-Html -Body "Firefox Installed? : Yes" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                    ConvertTo-Html -Body "<br>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                }
                else
                {
                    ConvertTo-Html -Body "Firefox Installed? : No" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                    ConvertTo-Html -Body "<br>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                }
                
                if ($chromeExst -eq 'true')
                {
                    ConvertTo-Html -Body "Google Chrome Installed? : Yes" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                    ConvertTo-Html -Body "<br>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                }
                else
                {
                    ConvertTo-Html -Body "Google Chrome Installed? : No" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                    ConvertTo-Html -Body "<br>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                }
                
            }
            
            write-host ""
            write-host "Web browsers recorded"
            start-sleep -s 1
            
            #scan for usernames
            $UsrPath = "$($Path)Users"
            $Users = get-childitem $UsrPath -force | where {$_.PsIsContainer -eq 'false'} | select -property name, lastaccesstime | sort -descending -property lastaccesstime | ConvertTo-HTML -Body "<H2>Users:</H2>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
            write-host ""
            write-host "Usernames recorded"
            start-sleep -s 1

            #check for internet history

            
        }
        
        #######################################
        # Any tasks specific to non-OS drives #
        #######################################
        else
        {
            ConvertTo-Html -Body "<h2>Contains Operating System (Windows 7)? : No</h2>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
        }
        
        #########################
        # Perform general scans #
        #########################
        
        #Check for files stored in hash-list
        write-host ""
        write-host "Scanning for known files..."
        
        ConvertTo-Html -Body "<h2>Files from Hash List :</h2>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
        $hashList = get-content C:\TriageTool\HashList.txt
        $fileLoc = get-childitem "$path" -force -recurse -erroraction silentlycontinue -i *.* | where {!($_.Attributes -band [IO.FileAttributes]::ReparsePoint) } | select -property FullName
        $TotalFileCount = 0
        $DetectedFiles = 0
        
		$ImageCount = 0
		$VideoCount = 0
		$CompressedCount = 0
        $DownloadCount = 0
        $OtherCount = 0
        
        foreach ($Loc in $fileLoc)
        {
            $TotalFileCount = $TotalFileCount + 1
            $Loc = $loc -replace "@{FullName=", "" -replace "}", ""
            
            #count images
            if ($loc.Contains('.bmp'))
            {
                $ImageCount = $ImageCount + 1
            }
            elseif ($loc.Contains('.jpg'))
            {
                $ImageCount = $ImageCount + 1
            }
            elseif ($loc.Contains('.png'))
            {
                $ImageCount = $ImageCount + 1
            }
            elseif ($loc.Contains('.psd'))
            {
                $ImageCount = $ImageCount + 1
            }
            #count videos
            elseif ($loc.Contains('.avi'))
            {
                $VideoCount = $VideoCount + 1
            }
            elseif ($loc.Contains('.mp4'))
            {
                $VideoCount = $VideoCount + 1
            }
            elseif ($loc.Contains('.mpg'))
            {
                $VideoCount = $VideoCount + 1
            }
            elseif ($loc.Contains('.wmv'))
            {
                $VideoCount = $VideoCount + 1
            }
            #count compressed
            elseif ($loc.Contains('.zip'))
            {
                $CompressedCount = $CompressedCount + 1
            }
            elseif ($loc.Contains('.rar'))
            {
                $CompressedCount = $CompressedCount + 1
            }
            elseif ($loc.Contains('.7z'))
            {
                $CompressedCount = $CompressedCount + 1
            }
            elseif ($loc.Contains('.tar.gz'))
            {
                $CompressedCount = $CompressedCount + 1
            }
            #count downloads
            elseif ($loc.Contains('.torrent'))
            {
                $DownloadCount = $DownloadCount + 1
            }
            elseif ($loc.Contains('.part'))
            {
                $DownloadCount = $DownloadCount + 1
            }
            elseif ($loc.Contains('.crdownload'))
            {
                $DownloadCount = $DownloadCount + 1
            }
            else
            {
                $OtherCount = $OtherCount + 1
            }
            
            $fileHash = ""
            $fileHash = get-hash -literal $loc -erroraction silentlycontinue | select -property HashString
            $fileHash = $fileHash -replace "@{HashString=", "" -replace "}", ""
    
            foreach ($hash in $hashList)
            {
                if ($fileHash -eq $hash)
                {
                    $DetectedFiles = $DetectedFiles + 1
                    ConvertTo-Html -Body "File Path : $Loc" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                    ConvertTo-Html -Body "File Hash : $hash" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                    ConvertTo-Html -Body "<br>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
                }
            }
        }
        
        if ($DetectedFiles -eq '0')
        {
            ConvertTo-Html -Body "No known files detected on the device" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
        }
        
        write-host ""
        write-host "Known file scan completed"
        start-sleep -s 1
        
        #General file stats
        ConvertTo-Html -Body "<h2>General file stats :</h2>" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
        
        ConvertTo-Html -Body "Total Files on Device : $TotalFileCount" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
        ConvertTo-Html -Body "Total Images on Device (bmp, jpg, png, psd) : $ImageCount" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
        ConvertTo-Html -Body "Total Videos on Device (avi, mpg, mp4, wmv) : $VideoCount" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
        ConvertTo-Html -Body "Total Compressed on Device (zip, rar, 7z, tar.gz) : $CompressedCount" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
        ConvertTo-Html -Body "Total Download Files on Device (torrent, part, crdownload) : $DownloadCount" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
		ConvertTo-Html -Body "Total Remaining Files on Device : $OtherCount" >> "$($reportLocation)\$($caseNo)\$($EvidenceID) - Partition $($iteration).html"
		
        write-host ""
        write-host "General file scan completed"
        start-sleep -s 1
                
        #####################################
        # Test if other partitions on drive #
        #####################################
        if ($partitions -ne 0)
        {
            clear-host
            write-host "Report Generated"
            write-host ""
            $path = read-host "Enter the next partition letter: "
        }
    }
    
    ####################################################################
    # Test if user wants to leave program running in background or not #
    ####################################################################
    write-host ""
    "Report generated - Do you want the program to remain running"
    $continue = read-host "in the background (y/n)? : "
    if ($continue -eq 'y')
    {
        write-host ""
        read-host "press enter when you have disconnected the scanned drive..."
        $iteration = 0
        clear-host
        main
    }    
}
$iteration = 0
Main