# End-to-End DevOps Pipeline on Azure using Jenkins, SonarQube, Nexus, Tomcat & Azure Blob Storage

## Project Overview

This project demonstrates a complete **End-to-End DevOps CI/CD Pipeline implementation on Microsoft Azure** using industry-standard DevOps tools.

The objective of this project is to automate:

- Source Code Management
- Continuous Integration
- Code Compilation
- Automated Testing
- Static Code Analysis
- Quality Gate Validation
- Artifact Generation
- Application Deployment
- Artifact Repository Storage
- Cloud Blob Storage Upload

This pipeline uses multiple Azure Virtual Machines to simulate a real-world enterprise DevOps infrastructure.

---

## Architecture Diagram

```text
Developer
    |
    v
GitHub Repository
    |
    v
Jenkins Pipeline
    |
    +----------------------+
    |                      |
    v                      v
Maven Build          SonarQube Analysis
    |                      |
    +----------+-----------+
               |
               v
       Quality Gate Validation
               |
               v
         WAR Artifact Creation
               |
       +-------+--------+-------------+
       |                |             |
       v                v             v
 Tomcat Deployment   Nexus Repo   Azure Blob Storage
```

---

## Tech Stack

| Category | Technology |
|----------|-------------|
| Cloud Provider | Microsoft Azure |
| Operating System | Ubuntu Linux |
| CI/CD Tool | Jenkins |
| Source Control | Git / GitHub |
| Build Tool | Maven |
| Programming Language | Java 17 |
| Code Quality Tool | SonarQube |
| Repository Manager | Nexus Repository 3 |
| Deployment Server | Apache Tomcat |
| Artifact Storage | Azure Blob Storage |

---

## Azure Infrastructure Setup

Four Azure Virtual Machines were created for this project.

### Jenkins Server

Purpose:

- CI/CD Pipeline
- Build automation
- Code integration

Inbound Rule:

Allow Port:

```text
8080
```

---

### SonarQube Server

Purpose:

- Static Code Analysis
- Quality Gate Validation

Inbound Rule:

Allow Port:

```text
9000
```

---

### Tomcat Deployment Server

Purpose:

- WAR deployment
- Application hosting

Inbound Rule:

Allow Port:

```text
8080
```

---

### Nexus Repository Server

Purpose:

- Artifact Repository Storage

Inbound Rule:

Allow Port:

```text
8081
```

---

## Jenkins Server Setup

### Connect to Azure VM

Login using:

```bash
MobaXterm
```

Switch to root user.

```bash
sudo -i
```

---

### Install Required Packages

```bash
apt update

apt install git maven openjdk-17-jdk -y
```

---

### Install Jenkins

Create installation script.

File:

```text
jenkins-script.sh
```

Execute:

```bash
chmod +x jenkins-script.sh

./jenkins-script.sh
```

---

### Verify Jenkins Service

```bash
systemctl status jenkins
```

Expected:

```text
active (running)
```

---

### Access Jenkins Dashboard

Browser:

```text
http://JENKINS_PUBLIC_IP:8080
```

---

### Get Initial Admin Password

```bash
cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

## Jenkins Plugin Installation

Navigate:

```text
Manage Jenkins
→ Plugins
→ Available Plugins
```

Install:

- Git Plugin
- Maven Integration Plugin
- SonarQube Scanner Plugin
- Quality Gates Plugin
- Deploy To Container Plugin
- Nexus Artifact Uploader Plugin
- Config File Provider Plugin

Restart Jenkins after installation.

---

## Jenkins Global Tool Configuration

Navigate:

```text
Manage Jenkins
→ Global Tool Configuration
```

---

### Java Configuration

Add JDK.

Example:

```text
Name:
Java11
```

Disable:

```text
Install Automatically
```

JAVA_HOME:

```text
/usr/lib/jvm/java-11-openjdk-amd64
```

---

### Maven Configuration

Add Maven.

Example:

```text
Name:
Maven3
```

Enable:

```text
Install Automatically
```

---

## SonarQube Server Setup

Login to SonarQube VM.

Create:

```text
sonarqube-script.sh
```

Run:

```bash
chmod +x sonarqube-script.sh

./sonarqube-script.sh
```

---

### Verify SonarQube

Browser:

```text
http://SONAR_PUBLIC_IP:9000
```

Default Login:

```text
Username : admin
Password : admin
```

---

## Generate SonarQube Token

Navigate:

```text
Create Project
→ Manually
→ Enter Project Key
→ Setup
```

Generate Token.

Copy token securely.

---

## Configure SonarQube in Jenkins

Navigate:

```text
Manage Jenkins
→ System
→ SonarQube Installations
```

Provide:

- SonarQube Server Name
- SonarQube URL
- Authentication Token

Save configuration.

---

## Tomcat Deployment Server Setup

Login to deployment server.

Create:

```text
tomcat-script.sh
```

Run:

```bash
chmod +x tomcat-script.sh

./tomcat-script.sh
```

---

### Verify Tomcat

Browser:

```text
http://TOMCAT_PUBLIC_IP:8080
```

Expected:

```text
Apache Tomcat Dashboard
```

---

## Configure Tomcat Credentials in Jenkins

Navigate:

```text
Manage Jenkins
→ Credentials
```

Add:

```text
Username Password Credentials
```

Provide:

- Username
- Password
- ID

---

## Nexus Repository Setup

Login to Nexus VM.

Create:

```text
nexus-script.sh
```

Run:

```bash
chmod +x nexus-script.sh

./nexus-script.sh
```

---

### Verify Nexus

Browser:

```text
http://NEXUS_PUBLIC_IP:8081
```

---

### Get Nexus Admin Password

```bash
cat /opt/sonatype-work/nexus3/admin.password
```

---

## Create Nexus Hosted Repository

Navigate:

```text
Settings
→ Repositories
→ Create Repository
```

Choose:

```text
maven2(hosted)
```

Configuration:

| Field | Value |
|------|------|
| Name | Shopkart-Artefact |
| Version Policy | snapshot |
| Deployment Policy | Allow Redeploy |
| Blob Store | default |

Save repository.

---

## Azure Blob Storage Setup

Create:

- Storage Account
- Blob Container

Example:

```text
Storage Account:
shopkartartefactstorage
```

Container:

```text
shopkart-artifacts
```

---

## Jenkins Pipeline Flow

Pipeline performs:

### Stage 1 — Clone Code

Clone application source code from GitHub repository.

---

### Stage 2 — Compile Code

Compile project using Maven.

Command:

```bash
mvn compile
```

---

### Stage 3 — Test Code

Execute automated tests.

Command:

```bash
mvn test
```

---

### Stage 4 — SonarQube Analysis

Static code analysis execution.

Command:

```bash
mvn sonar:sonar
```

---

### Stage 5 — Quality Gate Validation

Wait for SonarQube Quality Gate result.

---

### Stage 6 — Package Application

Generate WAR artifact.

Command:

```bash
mvn clean package
```

---

### Stage 7 — Deploy to Tomcat

Deploy WAR package to Tomcat server.

---

### Stage 8 — Store Artifact in Nexus

Upload generated WAR to Nexus Repository.

---

### Stage 9 — Upload Artifact to Azure Blob Storage

Upload WAR file to Azure Blob Storage.

---

## Jenkins Pipeline (Jenkinsfile)

```groovy
pipeline {

    agent any

    tools {
        jdk "Java11"
        maven "Maven3"
    }

    stages {

        stage("Clone git code") {

            steps {

                git branch:"develop",
                url:"https://github.com/pradeepkaldate/Shopkart.git"

            }
        }

        stage("Compile code") {

            steps {

                sh "mvn compile"

            }
        }

        stage("Test code") {

            steps {

                sh "mvn test"

            }
        }

        stage('SonarQube Analysis') {

            steps {

                withSonarQubeEnv('SonarQube-Server') {

                    sh 'mvn sonar:sonar'

                }
            }
        }

        stage('Quality Gate') {

            steps {

                waitForQualityGate abortPipeline:false,
                credentialsId:'Sonar-token'

            }
        }

        stage('Package code') {

            steps {

                sh "mvn clean package"

            }
        }

        stage('Deploy on container') {

            steps {

                deploy adapters: [
                    tomcat9(
                        credentialsId:'Tomcat-creds',
                        url:'http://YOUR_TOMCAT_IP:8080'
                    )
                ],
                contextPath:'shopkart-app',
                war:'target/*.war'

            }
        }

        stage('Store artefact in nexus') {

            steps {

                nexusArtifactUploader(

                    artifacts:[[

                        artifactId:'shopkart',
                        classifier:'',
                        file:'target/shopkart-app.war',
                        type:'.war'

                    ]],

                    credentialsId:'Nexus-creds',
                    groupId:'com.springspartans',
                    nexusUrl:'YOUR_NEXUS_IP:8081',
                    nexusVersion:'nexus3',
                    protocol:'http',
                    repository:'Shopkart-Artefact',
                    version:'0.0.1-SNAPSHOT'
                )
            }
        }

        stage('Upload Artifact to Azure Blob') {

            steps {

                sh '''

                az storage blob upload \
                --account-name shopkartartefactstorage \
                --container-name shopkart-artifacts \
                --name shopkart-app.war \
                --file target/shopkart-app.war \
                --overwrite \
                --auth-mode login

                '''

            }
        }

    }
}
```

---

## Screenshots

Add screenshots inside:

```text
screenshots/
```

Recommended screenshots:

- Azure VM Creation
- Jenkins Dashboard
- Jenkins Successful Build
- SonarQube Analysis
- Quality Gate Passed
- Tomcat Deployment
- Nexus Upload
- Azure Blob Upload

---

## Project Outcome

Successfully implemented:

✅ Azure Multi-VM Infrastructure

✅ Jenkins CI/CD Pipeline

✅ Maven Build Automation

✅ SonarQube Static Analysis

✅ Quality Gate Validation

✅ WAR Artifact Generation

✅ Tomcat Deployment

✅ Nexus Artifact Repository

✅ Azure Blob Artifact Upload

✅ End-to-End Production-style DevOps Workflow
