# Install Kubectl
!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt autoclean -y
sudo apt install zip unzip wget net-tools vim nano htop tree telnet -y 
sudo apt install mysql-client-core-8.0 -y

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl 

# Install gcloud-auth-Plugin

sudo apt-get update -y
sudo apt-get install apt-transport-https ca-certificates gnupg curl -y
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

sudo apt-get update && sudo apt-get install google-cloud-cli -y

grep -rhE ^deb /etc/apt/sources.list* | grep "cloud-sdk"


sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin -y

gke-gcloud-auth-plugin --version


# https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke

# Install KubeColor

sudo wget https://github.com/hidetatz/kubecolor/releases/download/v0.0.25/kubecolor_0.0.25_Linux_x86_64.tar.gz
sudo tar zxv -f kubecolor_0.0.25_Linux_x86_64.tar.gz

echo "alias k=/home/aslam_acxtsolutions_site/" >> ~/.bashrc
echo "alias k=/home/aslam_acxtsolutions_site/kubecolor" >> ~/.bashrc

sudo rm -rf kubecolor_0.0.25_Linux_x86_64.tar.gz

# alias k=/home/aslam_acxtsolutions_site/
# alias k=/home/aslam_acxtsolutions_site/kubecolor