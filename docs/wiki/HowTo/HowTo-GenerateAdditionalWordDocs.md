# How-to Guide: Generating Additional Word Documentation with Repository Automation

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Step-by-Step Instructions](#step-by-step-instructions)
  - [Step 1: Create a New Folder for Your Documentation](#step-1-create-a-new-folder-for-your-documentation)
  - [Step 2: Add a New JSON Object to the `WordDocumentation` Array](#step-2-add-a-new-json-object-to-the-worddocumentation-array)
  - [Step 3: Configure `filter` and `order`](#step-3-configure-filter-and-order)
  - [Step 4: Skip Exclusions (Optional)](#step-4-skip-exclusions-optional)
  - [Step 5: Run the Documentation Generation Script (Optional)](#step-5-run-the-documentation-generation-script-optional)
  - [Step 6: PR your branch, run pipeline on main](#step-6-pr-your-branch-run-pipeline-on-main)
  - [Step 6: Review the Generated Document and Celebrate](#step-6-review-the-generated-document-and-celebrate)
- [Tips and Best Practices](#tips-and-best-practices)
- [Summary](#summary)
- [FAQ](#faq)
- [References](#references)

## Introduction

This guide outlines the steps to generate additional Word documentation using the automation built into the repository. The configuration is managed through the `docs/.metadata/config.jsonc` file, where you define the structure, content, and order of the documents to be included.

## Prerequisites

- Ensure you have the ability to edit the `docs/.metadata/config.jsonc` file and raise the appropriate PRs.
- Familiarity with JSON syntax and the structure of your documentation files.

## Step-by-Step Instructions

### Step 1: Create a New Folder for Your Documentation

- Create a new folder under `docs/wiki/`, such as `docs/wiki/integrationspoc`.

**_Outcome:_** A dedicated folder is created to store the documentation files for your integration proof of concept (POC).

### Step 2: Add a New JSON Object to the `WordDocumentation` Array

- Open the `docs/.metadata/config.jsonc` file.
- Locate the `WordDocumentation` array.
- Add a new JSON object to the array for your documentation. The object should include the following keys:

  - **`title`**: The title of the Word document.
  - **`subtitle`**: The subtitle of the Word document.
  - **`author`**: The author(s) of the document.
  - **`filter`**: The path where your documentation files are located (e.g., `docs/wiki/integrationspoc/*`).
  - **`exclude`**: (Optional) Paths or files to exclude from the Word document.
  - **`order`**: The order in which the files should appear in the Word document, using relative paths.
  - **`template`**: The path to the Word document template to be used (e.g., `docs/.metadata/Insight_Template.docx`).

Example JSON object:

```jsonc
{
  "title": "Integration POC Documentation",
  "subtitle": "Technical Overview",
  "author": "Insight Cloud Platform Team",
  "filter": ["docs/wiki/integrationspoc/*"],
  "order": [
    "docs/wiki/integrationspoc/introduction.md",
    "docs/wiki/integrationspoc/architecture.md",
    "docs/wiki/integrationspoc/deployment.md",
    "docs/wiki/integrationspoc/configuration.md",
    "docs/wiki/integrationspoc/testing.md"
  ],
  "template": "docs/.metadata/Insight_Template.docx"
}
```

**_Outcome:_** A new configuration object is added to the `WordDocumentation` array, specifying the details of your new documentation.

### Step 3: Configure `filter` and `order`

- The **`filter`** key should point to the folder containing your documentation files (e.g., `docs/wiki/integrationspoc/*`).
- The **`order`** key should list the files in the exact order you want them to appear in the Word document. Always use relative paths.

**_Outcome:_** The filter and order are correctly configured, ensuring that your documentation files are included in the Word document in the specified sequence.

### Step 4: Skip Exclusions (Optional)

- If there are specific files you don't want to include in the Word document (e.g., `README.md`), you can add them to the **`exclude`** section.

**_Outcome:_** Unwanted files are excluded from the final Word document, if necessary.

### Step 5: Run the Documentation Generation Script (Optional)

- With the configuration in place, run the scripts provided in the repository to generate the Word document. Simply go to Run and Debug in VSCode (F5) and run `Convert Wiki to Word`. This will produce the word documents in the `docs/` top level folder.

> **Note**: Word Documents are `.gitignore`. Never upload word documents to a repo.

**_Outcome:_** The Word document is generated based on the configuration, using the specified template and including all the ordered files on local disk.

### Step 6: PR your branch, run pipeline on main

- After you PR your branch into main, the pipelines that build the solution include a `Generate Documentation` job. This, in both Azure DevOps and GitHub Actions, uploads the word documents into an artifact to be downloaded and consumed.

> **Note:** This ensures documentation for that point of time matches the other artifacts like infrastructure as code.

**_Outcome:_** The Word document is generated based on the configuration, using the specified template and including all the ordered files into a artifact.

### Step 6: Review the Generated Document and Celebrate

- Review the generated Word document to ensure everything is in order.
- Once confirmed, you can celebrate by heading to the pub!

**_Outcome:_** A fully generated Word document containing your integration POC documentation, ready for use.

## Tips and Best Practices

> - Ensure that the JSON syntax in `config.jsonc` is correct to avoid errors during the document generation process.
> - Regularly review the order of your documentation files to maintain a logical flow in the final Word document.

## Summary

By following these steps, you can efficiently generate additional Word documentation using the automation built into the repository, ensuring that your documentation is well-organized and formatted according to your needs.

## FAQ

- **Q:** What if my documentation doesn't appear in the correct order?
  **A:** Double-check the `order` array in the JSON configuration to ensure that the paths and filenames are correct and in the desired sequence.

## References

- [JSON Documentation](https://www.json.org/json-en.html)
- [Markdown Guide](https://www.markdownguide.org/)
