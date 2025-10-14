# How-to Guide: Merge Conflict Management Using VSCode

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Step-by-Step Instructions](#step-by-step-instructions)
  - [Step 1: Pull the Latest Changes from `Main` / `Default Branch`](#step-1-pull-the-latest-changes-from-main--default-branch)
  - [Step 2: Handle Merge Conflicts](#step-2-handle-merge-conflicts)
  - [Step 3: Commit and Push](#step-3-commit-and-push)
- [Tips and Best Practices](#tips-and-best-practices)
- [Summary](#summary)
- [FAQ](#faq)
- [References](#references)

## Introduction

This guide provides steps on how to manage and resolve merge conflicts in your branch using VSCode. Merge conflicts can occur when multiple people are working on the repository simultaneously or when automated documentation updates cause markdown files to have the same content in a different order. Resolving these conflicts in VSCode ensures a smooth and efficient workflow.

## Prerequisites

- Ensure you have VSCode installed and configured for your repository.
- Familiarity with basic Git commands and VSCode interface.

## Step-by-Step Instructions

### Step 1: Pull the Latest Changes from `Main` / `Default Branch`

- In your branch, open the terminal and run:

  ```sh
  git pull origin main
  ```

- This command pulls the latest changes from the `main` branch into your current branch.

- In the terminal, if a VIM window appears, exit by typing:

  ```sh
  :q!
  ```

**_Outcome:_** Your branch is now updated with the latest changes from `main`, and any conflicts will be highlighted.

### Step 2: Handle Merge Conflicts

- Navigate to the **Source Control** tab on the left-hand side (where you push changes).
- Under the "Merge Conflicts" heading, you'll see the files with conflicts.
- Right-click on each conflicting file and select one of the following options:
  - **Select All Incoming Changes**: Accepts all changes from `main`, overriding your branch's changes.
  - **Select All Current Changes**: Keeps your changes and ignores those from `main`.

> **Note**: Selecting all incoming changes is usually preferred, but you may need to honor your changes depending on the situation.

**_Outcome:_** The conflicts in the files are resolved, and your branch is ready for the next steps.

### Step 3: Commit and Push

- After resolving conflicts, commit and push your changes as usual in VSCode.

**_Outcome:_** Your branch is now merged with the latest changes from `main` and is free of conflicts.

## Tips and Best Practices

> - Always resolve merge conflicts in a timely manner to avoid disrupting the workflow.
> - Review the changes after resolving conflicts to ensure that no important updates were overwritten.

## Summary

By following these steps, you can effectively manage and resolve merge conflicts in your branch using VSCode, ensuring that your code remains up-to-date with the latest changes from the `main` branch.

## FAQ

- **Q:** What if I make a mistake while resolving conflicts?
  **A:** You can always reset your branch to the last commit and try resolving the conflicts again.

## References

- [Git Workflows by Atlassian](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
- [VSCode Documentation on Source Control](https://code.visualstudio.com/docs/editor/versioncontrol)
