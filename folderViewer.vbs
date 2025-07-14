Set objShell = CreateObject("Wscript.Shell")
objShell.Run "powershell.exe -ExecutionPolicy Bypass -File ""C:\My Script\folder-viewer\folderViewer.ps1""", 0, False