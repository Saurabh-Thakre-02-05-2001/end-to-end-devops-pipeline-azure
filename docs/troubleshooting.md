# Troubleshooting Guide

This document contains real issues faced during the implementation of the End-to-End DevOps CI/CD Pipeline project and the steps used to resolve them.

---

# Issue 1 — Jenkins Pipeline Groovy Compilation Error

## Problem

Pipeline failed before execution.

Error:

```text
org.codehaus.groovy.control.MultipleCompilationErrorsException:
unexpected char: '\' @ line 66
```

Pipeline Output:

```text
WorkflowScript:66 unexpected char: '\'
```

---

## Root Cause

Incorrect slash (`\`) formatting inside multi-line shell command in Jenkins pipeline.

Problematic syntax:

```groovy
sh ''' az storage blob upload \ --account-name ...
```

---

## Solution

Used proper multiline shell formatting.

Correct syntax:

```groovy
sh '''

az storage blob upload \
--account-name shopkartartefactstorage \
--container-name shopkart-artifacts \
--name shopkart-app.war \
--file target/shopkart-app.war \
--overwrite \
--auth-mode login

'''
```

---

## Result

Pipeline parsing completed successfully.

---

# Issue 2 — Azure CLI Login Error

## Problem

Azure Blob upload failed.

Error:

```text
ERROR: Please run 'az login' to setup account.
```

---

## Root Cause

Azure CLI session was not authenticated inside Jenkins Server VM.

---

## Solution

Login to Azure CLI.

Command:

```bash
az login
```

Verify login:

```bash
az account show
```

---

## Result

Azure subscription connected successfully.

---

# Issue 3 — DNS Resolution Error During Blob Upload

## Problem

Artifact upload to Azure Blob Storage failed.

Error:

```text
Failed to resolve
saurabhstorage123.blob.core.windows.net
```

---

## Root Cause

Incorrect Azure Storage Account name used in Jenkins pipeline.

Wrong value:

```text
saurabhstorage123
```

Actual storage account:

```text
shopkartartefactstorage
```

---

## Solution

Verified storage account.

Command:

```bash
az storage account list -o table
```

Updated Jenkins pipeline.

Correct configuration:

```bash
--account-name shopkartartefactstorage
```

---

## Result

DNS resolution issue resolved.

---

# Issue 4 — Azure Blob Permission Error

## Problem

Upload failed due to insufficient permissions.

Error:

```text
You do not have the required permissions needed to perform this operation.
```

Suggested roles:

```text
Storage Blob Data Owner
Storage Blob Data Contributor
Storage Blob Data Reader
```

---

## Root Cause

Logged-in Azure user did not have Blob Storage RBAC permissions.

---

## Solution

Verified active account.

Command:

```bash
az account show
```

Checked signed-in user.

Command:

```bash
az ad signed-in-user show --query id -o tsv
```

Assigned appropriate role in Azure IAM.

Required Role:

```text
Storage Blob Data Contributor
```

---

## Result

Azure Blob authentication issue resolved.

---

# Issue 5 — Azure Container Not Found Error

## Problem

Artifact upload failed.

Error:

```text
ContainerNotFound
```

Pipeline Output:

```text
ERROR:
The specified container does not exist.
```

---

## Root Cause

Azure Blob container was not created before upload.

---

## Solution

Created Blob Container inside Storage Account.

Container Name:

```text
shopkart-artifacts
```

Verified container existence.

Updated pipeline configuration.

```bash
--container-name shopkart-artifacts
```

---

## Result

Artifact uploaded successfully to Azure Blob Storage.

---

# Issue 6 — Nexus Artifact Upload Validation

## Problem

Needed verification that artifact upload was successful.

---

## Validation Commands

Pipeline Output:

```text
Uploading artifact shopkart-app.war started...
```

Successful upload log:

```text
Uploaded:
shopkart-0.0.1-SNAPSHOT.war
```

---

## Result

WAR artifact successfully stored in Nexus Repository.

---

# Issue 7 — Jenkins Service Validation

## Validation Command

```bash
systemctl status jenkins
```

Expected Result:

```text
active (running)
```

---

# Issue 8 — SonarQube Service Validation

## Validation

Access SonarQube Dashboard.

Browser:

```text
http://SERVER_IP:9000
```

Expected:

- Login Page
- Project Dashboard
- Successful Analysis
- Quality Gate Status

---

# Issue 9 — Nexus Service Validation

## Validation Command

```bash
systemctl status nexus
```

Expected:

```text
active (running)
```

Access Dashboard:

```text
http://SERVER_IP:8081
```

---

# Issue 10 — Tomcat Deployment Validation

## Validation

Access deployed application.

URL:

```text
http://TOMCAT_SERVER_IP:8080/shopkart-app
```

Expected Result:

Application deployed successfully.

---

# Final Successful Pipeline Outcome

Successfully achieved:

✅ GitHub Code Clone

✅ Maven Build

✅ Automated Testing

✅ SonarQube Analysis

✅ Quality Gate Validation

✅ WAR Artifact Packaging

✅ Tomcat Deployment

✅ Nexus Artifact Storage

✅ Azure Blob Storage Upload

✅ End-to-End Azure DevOps CI/CD Pipeline
