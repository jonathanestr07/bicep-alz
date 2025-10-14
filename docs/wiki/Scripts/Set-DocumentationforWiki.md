# Set-DocumentationforWiki.ps1

This script replaces specific strings in draw.io files and exports them to PNG format.

## Script

```powershell
./scripts/Set-DocumentationforWiki.ps1
```

### Notes

Requires PowerShell 7.0.0 or higher.

## Description

The script takes a source folder and a destination folder as input parameters. It searches for draw.io files in the source folder, replaces specific strings in the XML content of each file, and saves the modified XML content back to the draw.io file. It then exports the draw.io file to PNG format using the draw.io CLI.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------
sourceDrawingsFolder | ./docs/drawings/ | The path to the folder containing the draw.io files. Defaults to "./docs/drawings/".
destinationDrawingsFolder | ./docs/wiki/.media/ | The path to the folder where the modified draw.io files and PNG files will be saved. Defaults to "./docs/wiki/.media/".
WikiRootPath | ./docs/wiki/  | The root path of the wiki files to be updated. Defaults to "./docs/wiki/".
pathtodrawioWindows | C:\Program Files\draw.io\draw.io.exe | The path to the draw.io executable on Windows. Defaults to "C:\Program Files\draw.io\draw.io.exe".
MetadataFile | ./docs/.metadata/config.jsonc | The path to the metadata configuration file. Defaults to "./docs/.metadata/config.jsonc".
WhatIf | _null_        | _Not provided_
Confirm | _null_        | _Not provided_

## Examples

### Example 1

```powershell
.\Set-DocumentationforWiki.ps1 -sourceDrawingsFolder "C:\DrawioFiles" -destinationDrawingsFolder "C:\ModifiedDrawioFiles"
```

This example runs the script, replacing the specified strings in the draw.io files found in the "C:\DrawioFiles" folder and saves the modified files and PNG files in the "C:\ModifiedDrawioFiles" folder.
