# GitOPS ArgoCD EKS Project

![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images/Main_Image.jpeg)

## What this does?
This repo along with https://github.com/aslamchandio/kubernetesmanifest.git creates a Jenkins pipeline with GitOps to deploy code into a Kubernetes cluster. CI part is done via Jenkins and CD part via ArgoCD (GitOps).

## Jenkins installation on Ubuntu 22.3-LTS

### References
- https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/
- https://www.jenkins.io/doc/book/installing/linux/#debianubuntu

### Step-01: 
- Update Ubuntu
```
sudo apt update -y
sudo apt upgrade -y
sudo apt autoclean -y
sudo apt install zip unzip git nano vim wget net-tools vim nano htop tree  -y

```
### Step-02:
- DEFAULT RULES
```

sudo ufw status verbose

sudo ufw default deny incoming
sudo ufw default allow outgoing


sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 8080

sudo ufw enable
sudo ufw status verbose

```

### Step-03:
- Update & Install Java JDK
```

sudo apt update
sudo apt install fontconfig openjdk-17-jre
java -version

```

### Step-04:
- Install Jenkins (Long Term Support release)
- A LTS (Long-Term Support) release is chosen every 12 weeks from the stream of regular releases as the stable release for that time period. It can be installed from the debian-stable apt repository.
```

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update 

sudo apt install Jenkins

sudo systemctl status jenkins

sudo systemctl enable Jenkins --now

ps -aux | grep jenkins

netstat -planet | grep 8080

```

### Step-05:
- Change Port of Jenkins 8080 to 8181:(if 8080 Port already runnning in your Network)
```

sudo systemctl edit jenkins --full

Environment="JENKINS_PORT=8080"   to    Environment="JENKINS_PORT=8181"

sudo systemctl restart jenkins

systemctl status jenkins

- change port in jenkins UI

Dashboard > Manage Jenkins > System >  

Jenkins Location > Jenkins URL > http://18.77.11.12:8080/  to   http://18.77.11.12:8181/

```

- Jenkins plugins:
- Install the following plugins for the demo.
```
Amazon EC2 plugin (No need to set up Configure Cloud after)
Docker plugin
Docker Pipeline
GitHub Integration Plugin
Parameterized trigger Plugin

```

### Step-05:
- Configure Credentials for DockerHub & Github for Jenkins
```


```

## Docker installation on Ubuntu 22.3-LTS

### Step-01: 
- Add Docker's official GPG key
```

sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

```

### Step-02: 
- Add the repository to Apt sources 
```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update

```

### Step-03: 
- Install Docker
```

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

- Enable Docker Service

systemctl status docker
sudo systemctl enable docker --now

sudo usermod -aG docker ubuntu

- Run `sudo chmod 666 /var/run/docker.sock` on the VM after Docker is installed.

```

## ArgoCD installation 

Install ArgoCD in your Kubernetes cluster following this link - https://argo-cd.readthedocs.io/en/stable/getting_started/

### Requirements

- Installed kubectl command-line tool.
- Have a kubeconfig file (default location is ~/.kube/config).
  CoreDNS. Can be enabled for microk8s by microk8s enable dns && microk8s stop && microk8s start
 
### Step-01:
- Install Argo CD on K8S
```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

This will create a new namespace, argocd, where Argo CD services and application resources will live.

```

### Access The Argo CD API Server
- Service Type Load Balancer
```

Change the argocd-server service type to LoadBalancer:

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

```

- Port Forwarding:
```

Kubectl port-forwarding can also be used to connect to the API server without exposing the service.

kubectl port-forward svc/argocd-server -n argocd 8080:443

```

### Step-02:
- ArgoCD install on Linux
```

curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

argocd admin initial-password -n argocd

This password must be only used for first time login. We strongly recommend you update the password using `argocd account update-password`.

argocd admin initial-password -n argocd

```

![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images/1-Argo1.jpg)
![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images/2-Argo2.jpg)

# Configurations on Jenkins

## Create a First PipeLine on Jenkins

### Step-01: 
- Pipeline
```
Definition : Pipeline Script from SCM
SCM : Git

Repository URL : https://github.com/aslamchandio/project-app.git

Branch Specifier : Change */master to   */main


```

- First Repo : (Dockerfile,Jenkinsfile & app)

### References
- https://github.com/aslamchandio/project-app.git


### Dockerfile
```
FROM nginx
COPY  app  /usr/share/nginx/html

```
### app folder
- app (any code in app folder)
```

```

### Jenkinsfile
- Code
```
node {
    def app

    stage('Clone repository') {
      

        checkout scm
    }

    stage('Build image') {
  
       app = docker.build("aslam24/project-app")                  # Change Repo File
    }

    stage('Test image') {
  

        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        
        docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
            app.push("${env.BUILD_NUMBER}")
        }
    }
    
    stage('Trigger ManifestUpdate') {
                echo "triggering updatemanifestjob"
                build job: 'updatemanifest', parameters: [string(name: 'DOCKERTAG', value: env.BUILD_NUMBER)]
        }
}

```

## Create a Second PipeLine on Jenkins

### Step-01: 
- Pipeline
```

Name : updatemanifest > Pipeline

This project is parameterized    add parameter as string

Name: DOCKERTAG
Default Value: latest

Pipeline


Repository URL : https://github.com/aslamchandio/kubernetesmanifest.git

Branch Specifier : Change */master to   */main

Definition : Pipeline Script from SCM
SCM : Git

```

- Second Repo : (Jenkinsfile & deployment.yaml)

### References
- https://github.com/aslamchandio/kubernetesmanifest.git


### Jenkinsfile
- Code
```
node {
    def app

    stage('Clone repository') {
      

        checkout scm
    }

    stage('Update GIT') {
            script {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        //def encodedPassword = URLEncoder.encode("$GIT_PASSWORD",'UTF-8')
                        sh "git config user.email aslam.chandio03@gmail.com"
                        sh "git config user.name Aslam Chandio"
                        //sh "git switch master"
                        sh "cat deployment.yaml"
                        sh "sed -i 's+aslam24/project-repo.*+aslam24/project-repo:${DOCKERTAG}+g' deployment.yaml"
                        sh "cat deployment.yaml"
                        sh "git add ."
                        sh "git commit -m 'Done by Jenkins Job changemanifest: ${env.BUILD_NUMBER}'"
                        sh "git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/kubernetesmanifest.git HEAD:main"
      }
    }
  }
}
}


```
![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images/3-Jenkins1.jpg)
![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images/4-Jenkins2.jpg)

### deployment.yaml
- Code - Deployment & LoadBalancer Service  Manifest
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: firt-deployment
  labels:
    app:  first-deployment

spec:  
  replicas: 3
  selector:
    matchLabels:
      app: first-deployment
      
  template:
    metadata:
      name: first-deployment
      labels:
        app: first-deployment
    spec:
      containers:
        - name: first-deployment
          image: aslam24/project-app:latest
          ports:
            - containerPort: 80
                        

apiVersion: v1 
kind: Service
metadata: 
  name: deployment-lb-service
  labels:
    app: deployment-lb-service

spec:
  type: LoadBalancer
  selector:
    app: first-deployment
  ports:
    - name: http
      port: 80
      targetPort: 80

```

##  Automatic WebHook  
- on Github
...

aslamchandio /project-app   (repo on Github)

setting > Webhooks 

Payload URL : http://18.77.11.12:8080/github-webhook/  or  http://jenkins.chandiolab.site:8080/github-webhook/

Content type : application/json

Which events would you like to trigger this webhook? : just the push event.

active 


## Automatic WebHook
- on Jenkins
...

buildimage > pipeline > Build Triggers  >  GitHub hook trigger for GITScm polling ( check it)

...

![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images/7-web-hook.jpg)
![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images/8-web-hook-jenkin.jpg)

## Kubernetes Cluster Configurations

![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images/5-K8S-1.jpg)
![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images/6-K8S-2.jpg)

## App Access from domain name

![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images/9-App-1.jpg)








































