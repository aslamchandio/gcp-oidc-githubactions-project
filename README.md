# Enabling Keyless Authentication from GitHub Actions with OpenID Connect (OIDC) 

![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images-1/0_mzZELDcSxD2ACAWl.webp)

![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images-1/1_GitHub_Actions.max-2600x2600.jpg)

## Configuring OpenID Connect in Google Cloud Platform
Overview:

OpenID Connect (OIDC) allows your GitHub Actions workflows to access resources in Google Cloud Platform (GCP), without needing to store the GCP credentials as long-lived GitHub secrets.
This guide gives an overview of how to configure GCP to trust GitHub's OIDC as a federated identity, and includes a workflow example for the google-github-actions/auth action that uses tokens to authenticate to GCP and access resources.

## Step 1 — Create a repo on Github

gcp-oidc-terraform-gke-github (Private)


### References
- https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions
- https://github.com/google-github-actions/auth?tab=readme-ov-file#indirect-wif
- https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-google-cloud-platform


## Step 2 — Create OIDC Provider in GCP Cloud for Github Actions

### Step-01: 
- Create Service Account
```
gcloud iam service-accounts create terraform-oidc-gke-sac \
    --project "terraform-project-335577" \
    --description="Service Account For OIDC Github Actions for GKE" \
    --display-name="terraform-oidc-gke-sac"

gcloud iam service-accounts list

```
### Step-02: grant service account an IAM role on your project & resources
Note : In my case i am creating vpc, vm with custom service account & google kubernetes engine 
 

- Service Account Membership
```

gcloud projects add-iam-policy-binding terraform-project-335577 \
  --member="serviceAccount:terraform-oidc-gke-sac@terraform-project-335577.iam.gserviceaccount.com" \
  --role="roles/compute.admin"

gcloud projects add-iam-policy-binding terraform-project-335577 \
  --member="serviceAccount:terraform-oidc-gke-sac@terraform-project-335577.iam.gserviceaccount.com" \
  --role="roles/container.admin"

gcloud projects add-iam-policy-binding terraform-project-335577 \
  --member="serviceAccount:terraform-oidc-gke-sac@terraform-project-335577.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

gcloud projects add-iam-policy-binding terraform-project-335577 \
  --member="serviceAccount:terraform-oidc-gke-sac@terraform-project-335577.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountAdmin"

gcloud projects add-iam-policy-binding terraform-project-335577 \
  --member="serviceAccount:terraform-oidc-gke-sac@terraform-project-335577.iam.gserviceaccount.com" \
  --role="roles/iam.roleAdmin"


gcloud projects add-iam-policy-binding terraform-project-335577 \
  --member="serviceAccount:terraform-oidc-gke-sac@terraform-project-335577.iam.gserviceaccount.com" \
  --role="roles/resourcemanager.projectIamAdmin"


gcloud projects add-iam-policy-binding terraform-project-335577 \
  --member="serviceAccount:terraform-oidc-gke-sac@terraform-project-335577.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountTokenCreator"

gcloud projects add-iam-policy-binding terraform-project-335577 \
  --member="serviceAccount:terraform-oidc-gke-sac@terraform-project-335577.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser" 

```


- 
``` Service Account List

gcloud iam service-accounts get-iam-policy terraform-oidc-gke-sac@terraform-project-335577.iam.gserviceaccount.com --format=yaml


gcloud projects get-iam-policy terraform-project-335577   \
--flatten="bindings[].members" \
--format='table(bindings.role)' \
--filter="bindings.members:terraform-oidc-gke-sac@terraform-project-335577.iam.gserviceaccount.com" 

```

![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images-1/gcp-oidc2.jpg)


## Step 3 — Create a Workload Identity Pool
- Create a Workload Identity Pool

```


gcloud iam workload-identity-pools create POOL_ID \
    --location="global" \
    --description="DESCRIPTION" \
    --display-name="DISPLAY_NAME"

gcloud iam workload-identity-pools create github-actions-gke-pool \
    --project="terraform-project-335577" \
    --location="global" \
     --display-name="github-actions-gke-pool" \
    --description="An Identity Pool forGithub Action For GKE"

gcloud iam workload-identity-pools list --location="global"


```

## Step 4 —  Create a Workload Identity Provider in that pool
- Create a Workload Identity Provider

```
gcloud iam workload-identity-pools providers create-oidc PROVIDER_ID \
    --project="terraform-project-335577" \
    --location="global" \
    --workload-identity-pool="POOL_ID" \
    --issuer-uri="ISSUER" \
    --allowed-audiences="AUDIENCE" \
    --attribute-mapping="MAPPINGS" \
    --attribute-condition="CONDITIONS"
    --jwk-json-path="JWK_JSON_PATH"


gcloud iam workload-identity-pools providers create-oidc github-gke-actions \
  --project="terraform-project-335577" \
  --location="global" \
  --workload-identity-pool="github-actions-gke-pool" \
  --display-name="My GitHub repo Provider for GKE" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository, attribute.aud=assertion.aud,attribute.repository_owner=assertion.repository_owner" \
  --attribute-condition="assertion.repository_owner == 'aslamchandio'" \
  --issuer-uri="https://token.actions.githubusercontent.com" 

    --attribute-mapping="google.subject=assertion.sub,
                      attribute.actor=assertion.actor,
                      attribute.aud=assertion.aud,
                      attribute.repository=assertion.repository,
                      attribute.repository_owner=assertion.repository_owner"

                      
  --attribute-condition="assertion.repository_owner == 'aslamchandio'" 

```
For --attribute-mapping

google.subject >>>> assertion.sub
attribute.actor >>>> assertion.actor
attribute.aud >>>> assertion.aud
attribute.repository >>>> assertion.repository
attribute.repository=assertion.repository
attribute.repository_owner=assertion.repository_owner

For --attribute-condition

assertion.repository_owner == 'aslamchandio'  (aslamchandio is a github owner account)

![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images-1/gcp-oidc1.jpg)


## Step 5 —  Allow authentications from the Workload Identity Pool to your Google Cloud Service Account

- Update this value to your GitHub repository.
```
export PROJECT_ID="terraform-project-335577"
export REPO="aslamchandio/gcp-oidc-terraform-gke-github"
export WORKLOAD_IDENTITY_POOL_ID="projects/276747595521/locations/global/workloadIdentityPools/github-actions-gke-pool"

```

- Note :
```

 username of github account : aslamchandio
 github repo name: github-actions-gke-pool

```

```

gcloud iam  service-accounts list

terraform-oidc-gke-sac@terraform-project-335577.iam.gserviceaccount.com

```

```

gcloud iam service-accounts add-iam-policy-binding "terraform-oidc-sa@${PROJECT_ID}.iam.gserviceaccount.com" \
  --project="${PROJECT_ID}" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/${WORKLOAD_IDENTITY_POOL_ID}/attribute.repository/${REPO}"

```

![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images-1/gcp-oidc.jpg)


## Step 6 —  Extract the Workload Identity Provider resource name

```
gcloud iam workload-identity-pools providers describe my-github-actions \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="my-github-actions-pool" \
  --format="value(name)"

projects/276747595521/locations/global/workloadIdentityPools/my-github-actions-pool/providers/my-github-actions 

WORKLOAD_IDENTITY_PROVIDER   projects/276747595521/locations/global/workloadIdentityPools/my-github-actions-pool/providers/my-github-actions 
SERVICE_ACCOUNT               terraform-oidc-gcp-sa@terraform-project-455409.iam.gserviceaccount.com

```

## Step 7 —  Use this value as the workload_identity_provider value in the GitHub Actions YAML
- cicd-gcp-prod-create.yml 
- cicd-gcp-prod-destroy.yml

Note: # Value from command: gcloud iam workload-identity-pools providers describe github-actions --workload-identity-pool="github-actions-pool" --location="global"

```
 # Value from command: gcloud iam workload-identity-pools providers describe github-actions --workload-identity-pool="github-actions-pool" --location="global"
          workload_identity_provider: '${{ secrets.WORKLOAD_IDENTITY_PROVIDER }}'
          create_credentials_file: true
          service_account: '${{ secrets.SERVICE_ACCOUNT }}'    
          token_format: "access_token"
          access_token_lifetime: "120s"

```

![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images-1/gcp-oidc3.jpg)

## Step 8 — Github Actions Files
- cicd-gcp-prod-create.yml  (For Creating GCP Resources)

name: vpc-gke-ci-prod-create
run-name: ${{ github.actor }} has triggered the pipeline for Terraform

on:
  push:
    branches:
      - 'prod'

defaults:
  run:
    shell: bash
    working-directory: ./gcp-vpc-gke-custom-module/root
permissions:
  contents: read

jobs:
  deploy-prod:
    runs-on: ubuntu-latest
    # These permissions are needed too interact with GitHub's OIDC Token endpoint. New
    permissions:
      contents: read
      id-token: write       
    steps:
      - name: "Checkout"
        uses: 'actions/checkout@v4'

      - name: Configure GCP credentials
        id: auth
        uses: google-github-actions/auth@v2
        with:
          # Value from command: gcloud iam workload-identity-pools providers describe github-actions --workload-identity-pool="github-actions-pool" --location="global"
          workload_identity_provider: '${{ secrets.WORKLOAD_IDENTITY_PROVIDER }}'
          create_credentials_file: true
          service_account: '${{ secrets.SERVICE_ACCOUNT }}'    
          token_format: "access_token"
          access_token_lifetime: "120s"
          
      - name: Echo stuff
        run: printenv
      - name: Setup Terraform with specified version on the runner
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.11.0
          terraform_wrapper: true
             
      # Initialize a new or existing Terraform working directory by creating initial files, loading any remote state, downloading mo
      - name: Terraform init
        id: init
        run: terraform init
      
      # Checks that all Terraform configuration files adhere to a canonical format
      - name: Terraform Format
        id: fmt
        run:  terraform fmt -recursive -write=true 

      # Validate Code
      - name: Terraform validate
        id: validate
        run: terraform validate

      # Generates an execution plan for Terraform
      - name: Terraform plan
        id: plan
        run: terraform plan 
        continue-on-error: true

      - name: Terraform Plan Status
        if: steps.plan.outcome == 'failure'
        run: exit 1

      # On push to "main", build or change infrastructure according to Terraform configuration files
      # Note: It is recommended to set up a required "strict" status check in your repository for "Terraform Cloud". See the documentation on "strict" required status checks for more information: https://help.github.com/en/github/administering-a-repository/types-of-required-status-checks
      - name: Terraform Apply
        run: terraform apply -auto-approve  
      
```

- cicd-gcp-prod-destroy.yml (For Destroying GCP Resources)

name: vpc-gke-ci-prod-destroy
run-name: ${{ github.actor }} has triggered the pipeline for terraform

on:
  push:
    branches:
      - 'prod'

defaults:
  run:
    shell: bash
    working-directory: ./gcp-vpc-gke-custom-module/root
permissions:
  contents: read
jobs:
  destroy-dev:
    runs-on: ubuntu-latest
    # These permissions are needed too interact with GitHub's OIDC Token endpoint. New
    permissions:
      contents: read
      id-token: write
    steps:
      - name: "Checkout"
        uses: 'actions/checkout@v4'

      - name: Configure GCP credentials
        id: auth
        uses: google-github-actions/auth@v2
        with:
          # Value from command: gcloud iam workload-identity-pools providers describe github-actions --workload-identity-pool="github-actions-pool" --location="global"
          workload_identity_provider: '${{ secrets.WORKLOAD_IDENTITY_PROVIDER }}'
          create_credentials_file: true
          service_account: '${{ secrets.SERVICE_ACCOUNT }}'   
          token_format: "access_token"
          access_token_lifetime: "120s"
          
      - name: Echo stuff
        run: printenv
      - name: Setup Terraform with specified version on the runner
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.11.0

      # Terraform init    
      - name: Terraform init
        id: init
        run: terraform init
      
      # Destroy All Resources   
      - name: Terraform Destroy
        id : destroy
        run: terraform destroy -auto-approve 


```


- Update provider.tf file for remote terraform.tfstate & locking

```

# Terraform Settings Block
terraform {
  required_version = "~> 1.11.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.28.0"
    }
  }
}

terraform {
  backend "gcs" {
    bucket = "aslam-tfstate-bucket"
    prefix = "dev/fully-pvt-gke-cluster-cm-cidr"
  }
}


```


![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images-1/gcp-oidc4.jpg)

## Step 9 — Create Folders in local Repo in Hierarchical way 

![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images-1/gcp-oidc5.jpg)

1- Under aws-oidc-terraform-github repo create folder .github
2- under .github folder create workflows folder
3- under workflows folder create Github action files.

## Step 10 — Create .gitignore file in terraform main folder 

```

.terraform/
.terraform.lock.hcl
**/creds.json
**/zzz.txt
**/.DS_Store

```


## Step 11 —  Push Terraform Code & Github Action files into Remote Repo

![App Screenshot](https://github.com/aslamchandio/random-resources/blob/main/images-1/gcp-oidc6.jpg)

bellow commands used in above images

```

git add .

git status

git commit -m "6th Commit for GKE Code"

git push -u origin main 

```


### References
- https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions
- https://github.com/google-github-actions/auth?tab=readme-ov-file#indirect-wif
- https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-google-cloud-platform









































