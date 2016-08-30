===================================================================================================================================
|                                                                                                                                 |
|  Installation :                                                                                                                 |
|                                                                                                                                 |
|  - Download the "TriageTool" directory, and place it in the root of the C drive                                                 |
|                                                                                                                                 |
|  - Open a command-line window (run-as administrator) and enter the following commands:                                          |
|      1) Powershell                                                                                                              |
|      2) Set-ExecutionPolicy Unrestricted                                                                                        |
|                                                                                                                                 |
|  - Run the Launch.bat file from C:\TriageTool to create the required folder structure and launch the program                    |
|                                                                                                                                 |
|=================================================================================================================================|
|                                                                                                                                 |
|  Changing the default save directory for reports :                                                                              |
|                                                                                                                                 |
|  The location where the report is created can be altered by changing the location listed in "C:\TriageTool\ReportLocation.txt"  |
|                                                                                                                                 |
|=================================================================================================================================|
|                                                                                                                                 |
|  Editing the Hash list :                                                                                                        |
|                                                                                                                                 |
|  Any hash values (MD5) that you want the tool to scan for can be added into the C:\TriageTool\HashList.txt" file                |
|  For this to scan correctly, and remain clear, each hash needs to be on a new line                                              |
|                                                                                                                                 |
|=================================================================================================================================|
|                                                                                                                                 |
|  Program functions :                                                                                                            |
|                                                                                                                                 |
|  - Runs in the background, and detects when a new device is connected                                                           |
|  - Outputs the following details about the newly connected device                                                               |
|      - The model of the device                                                                                                  |
|      - Its capacity                                                                                                             |
|      - The number of partitions                                                                                                 |
|      - The details of the partition(s), including its volume lable, format, total size, and free space                          |
|      - Whether there is an operating system (Windows 7) installed on it                                                         |
|      - The Operating system architecture (32/64 bit)                                                                            |
|      - Which (if any) web browsers are installed (Internet Explorer, Chrome, Firefox)                                           |
|      - What (if any) user accounts exist on the drive, and their last access time/date                                          |
|      - The full file path and hash value for any files that mach those in the HashList.txt file                                 |
|      - An overview of the files on the device, including:                                                                       |
|           - The total number of files                                                                                           |
|           - The number of images (.bmp, .jpg, .png, .psd)                                                                       |
|           - The number of videos (.avi, .mpg, .mp4, .wmv)                                                                       |
|           - The number of compressed files (.zip, .rar, .7z, .tar.gz)                                                           |
|           - The number of download files (.torrent, .part, .crdownload)                                                         |
|           - The number of files that do not fit into any of these categories                                                    |
|                                                                                                                                 |
|  The results of these scans are saved to a .html report, in the location defined in the ReportLocation.txt file.                |
|                                                                                                                                 |
|  The reports are sorted by the case number and evidence number (user provided) as well as a partition number                    |
|                                                                                                                                 |
|  For example, a scan of a drive with multiple partitions would generate the following generalised report structure :            |
|      - [ReportLocation]\ExampleCase\ExampleExhibit - Partition1.html                                                            |
|      - [ReportLocation]\ExampleCase\ExampleExhibit - Partition2.html                                                            |
|      - [ReportLocation]\ExampleCase\ExampleExhibit - Partition3.html                                                            |
|                                                                                                                                 |
===================================================================================================================================