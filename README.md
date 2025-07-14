# 🌒 Compact Folder Viewer

A compact, keyboard-friendly **PowerShell GUI** tool for browsing and launching files from a specified directory. Built with **WPF**, styled with hidden scrollbars and semi-bold file entries for a slick visual experience.

---

## 🔧 Features

- 🖥️ Custom window dimensions with auto-save config (`FolderViewer.cfg`)
- 📁 Lists files in groupings of 20 for visual clarity
- 🎯 Double-click or press `Enter` to launch any item
- 🧩 Hidden scrollbar `ListBox` styling for clean presentation
- 🗂 Persistent view window with topmost behavior
- 🖤 Minimal UI: black background, light gray text, drag-resizable, no noisy icons

---

## 🧪 Requirements

- Windows 10 or 11  
- PowerShell 5.x or later  
- .NET Framework assemblies (included by default)

---

## 🚀 Getting Started

```powershell
# Set your target folder
$folderPath = "C:\Path\To\Your\Files"

# Run the script
.\FolderViewer.ps1
