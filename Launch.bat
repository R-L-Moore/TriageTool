mkdir C:\Windows\System32\WindowsPowerShell\v1.0\Modules\Pscx

xcopy C:\TriageTool\Pscx C:\Windows\System32\WindowsPowerShell\v1.0\Modules\Pscx /E /Q /Y /I

cls

C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -file "C:\TriageTool\code.ps1"