# Convert-WikiMarkdowntoWord.ps1

Converts a set of Markdown files from a Wiki into a single Word document.

## Script

```powershell
./scripts/Convert-WikiMarkdowntoWord.ps1
```

## Description

This script aggregates Markdown files from specified Wiki directories, orders them using a metadata configuration file, and converts them into a Word document using a provided template. The final document is saved to a designated location.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------
WikiRootPath | @('./docs/wiki/') | Specifies the root paths to the Wiki directories containing Markdown files. Default is './docs/wiki/'.
OutputPath | ./docs/       | Defines the path where the output Word document will be saved. Default is './docs/'.
MetadataFile | ./docs/.metadata/config.jsonc | Specifies the path and filename for the metadata configuration file that defines the order of the Markdown files. Default is './docs/.metadata/config.jsonc'.
WhatIf | _null_        | _Not provided_
Confirm | _null_        | _Not provided_

## Examples

### Example 1

```powershell
.\Convert-WikiMarkdowntoWord.ps1 -WikiRootPath './docs/wiki/' -OutputPath './docs/' -MetadataFile './docs/.metadata/config.jsonc'
```

This example converts the Markdown files in './docs/wiki/' into a Word document and saves it in './docs/', using the order specified in './docs/.metadata/config.jsonc'. The document uses the configurations defined in the metadata file.
