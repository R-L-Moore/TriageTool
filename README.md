##Program functions:

-  Runs in the background, and detects when a new device (USB pen, Hard drive, SSD drive) is connected

-  Outputs the following details about the newly connected device;
  -  The model of the device
  -  Its capacity
  -  The number of partitions
  -  The details of the partition(s), including their volume lable, format, total size, and freespace
  -  Whether there is an operating system (Tested with Windows 7) installed on it
  -  The Operating system architecture (32/64bit)
  -  Which (if any) web browsers are installed (Internet Explorer, Chrome, Firefox)
  -  What (if any) user accounts exist on the drive, and their last access time/date
  -  The full file path and hash value for any files that match those in the Hash List.txt file
  -  An overview of the files on the device, including;
       -  The total number of files
       -  The number of images (.bmp, .jpg, .png, .psd)
       -  The number of videos (.avi, .mpg, .mp4, .wmv)
       -  The number of compressed files (.zip, .rar, .7z, .tar.gz)
       -  The number of download files (.torrent, .part, .crdownload)
       -  The number of files that do not fit into any of these categories

    The results of these scans are saved to a .html report, in the location defined in the ReportLocation.txt file.

    The reports are sorted by the case number and evidence number (user provided) as well as a partition number

    For example, a scan of a drive with multiple partitions would generate the following generalised report structure;
    
      -  [ReportLocation]\ExampleCase\ExampleExhibit-Partition1.html
      -  [ReportLocation]\ExampleCase\ExampleExhibit-Partition2.html
      -  [ReportLocation]\ExampleCase\ExampleExhibit-Partition3.html

##Usage:

To run the program, open the C:\TriageTool folder, and run Launch.bat

When the program launches, a command prompt will open with a message saying "Scanning for new device..."
This screen will not change until a new device is connected to the host machine.

When a new device is connected, the screen will update with "New drive detected", and an overview of the device.
The user is then prompted to enter a case number, Evidence ID number, and for the partition letter which Windows has allocated to the device

Once this information has been provided, the program will start to scan the device, and all details will be recorded in a .html file, in the location specified in the "ReportLocation.txt" file
The exact path for the report will be;
  -  [ReportLocation]\CaseNumber\ExhibitID-PartitionNumber.html

##Installation:

1.  Download the "TriageTool" as a zipfile

2.  Open the zip file, and browse through the folders, until you can see the folder named "TriageTool"

3.  Copy this folder to the root of the C drive. This will result in the following folder structure;
    C:\TriageTool\Pscx
  
4.  Open a command-line window (run-asadministrator) and enter the following commands;
       1. Powershell
       2. Set-ExecutionPolicy Unrestricted
      
5.  Close the command-line window

6.  If you want to specify an output location for the reports, this can be done by editing the "ReportLocation.txt" file in the following location;
    C:\TriageTool\

    If this file is not altered, the program will create a default output folder in the following location;
    C:\TriageTool\Reports

    This report location can be changed at any time by editing this file, but the program will need to be closed and reloaded for the change to take effect, and any reports created before this change would need to be moved to the new location

7.  By default, the HashList.txt file under C:\TriageTool is empty,and so the program will not scan for specific known files

    To enable the program to scan for known files, the relevant hash values (MD5) need to be added into this file, with each value being on its own line.

    These values do not need to be separated using any characters other than a new-line (nocommas,semi-colons,etc)

8.  Run the Launch.bat file from C:\TriageTool to create the required folder structure and launch the program
