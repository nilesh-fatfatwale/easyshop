# 🛍️ EasyShop - Modern E-commerce Platform

EasyShop is a modern, full-stack e-commerce platform built with Next.js 14, TypeScript, and MongoDB. It features a beautiful UI with Tailwind CSS, secure authentication, real-time cart updates, and a seamless shopping experience.

## 🏗️ Architecture Diagram
<img width="5553" height="2738" alt="Easyshop_Architecture" src="https://github.com/user-attachments/assets/a79b2f63-498e-4eaa-94ca-1a24c48fdbad" />

## ✨ Features
- 🎨 Modern and responsive UI with dark mode support
- 🔐 Secure JWT-based authentication
- 🛒 Real-time cart management with Redux
- 📱 Mobile-first design approach
- 🔍 Advanced product search and filtering
- 💳 Secure checkout process
- 📦 Multiple product categories
- 👤 User profiles and order history
- 🌙 Dark/Light theme support

## 🏗️ Architecture
EasyShop follows a three-tier architecture pattern:

### 1. Presentation Tier (Frontend)
- Next.js React Components
- Redux for State Management
- Tailwind CSS for Styling
- Client-side Routing
- Responsive UI Components

### 2. Application Tier (Backend)
- Next.js API Routes
- Business Logic
- Authentication & Authorization
- Request Validation
- Error Handling
- Data Processing

### 3. Data Tier (Database)
- MongoDB Database
- Mongoose ODM
- Data Models
- CRUD Operations
- Data Validation

### Key Features of the Architecture
- Separation of Concerns: Each tier has its specific responsibilities
- Scalability: Independent scaling of each tier
- Maintainability: Modular code organization
- Security: API routes handle authentication and data validation
- Performance: Server-side rendering and static generation
- Real-time Updates: Redux for state management

### Data Flow
- User interacts with React components
- Actions are dispatched to Redux store
- API clients make requests to Next.js API routes
- API routes process requests through middleware
- Business logic handles data operations
- Mongoose ODM interacts with MongoDB
- Response flows back through the tiers
 
## 📦 Project Structure
```
easyshop/
├── src/
│ ├── app/ # Next.js App Router pages
│ ├── components/ # Reusable React components
│ ├── lib/ # Utilities and configurations
│ │ ├── auth/ # Authentication logic
│ │ ├── db/ # Database configuration
│ │ └── features/ # Redux slices
│ ├── types/ # TypeScript type definitions
│ └── styles/ # Global styles and Tailwind config
├── public/ # Static assets
└── scripts/ # Database migration scripts
└── .db/ # Database migration data
└── kubernetes/ # kubernetes yaml files
└── terraform/ # terraform Infra with aws
└── Jenkinsfile # Jenkinsfile for CI
└── Dockerfile # Dockerfile for Image build
└── docker-compose.yml # run app via docker container
└── .... # Other files

```
## Project Deployment Flow:
![DevSecOps+GitOps](https://github.com/user-attachments/assets/aeea22ba-10e9-49cd-b7e8-bbdbf2c8ed03)



# 🚀 Getting Started
lets run the application via docker-compose to check everything works fine.

## Requirements
- Docker
- Docker-Compose 

## How to Use This Repository

1. **Clone the repository && Navigate to the folder:**

```bash
https://github.com/nilesh-fatfatwale/easyshop
cd easyshop
```
2. **Run the application :**

```bash
docker-compose up -d
```
if everything works fine let move on to build with eks cluster


# 🚀 Getting Started with EKS Cluster 

## 1] Creating Infrastructure:

### Requirements:
- Terraform
- AWS Account
- AWS Cli
- IAM Account Credentials

> [!NOTE]
> All required tools are installed and configured using the `install_tools.sh` script located in the `terraform` directory.
> 
> The script installs: : **Docker** | **Jenkins with java** | **Aws cli** | **Kubectl** | **Eksctl** | **Helm** |**Trivy** | **ingress-nginx-controller**
>
> If the script fails or something goes wrong, please install the tools manually.


1. **Clone the repository and navigate to the Terraform folder:**

```bash
https://github.com/nilesh-fatfatwale/easyshop
cd easyshop/terraform
```
2. **Install Terraform (Ubuntu/Debian):**

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```
3. **Install AWs Cli (Linux x86_64):**

```bash 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt-get install unzip
unzip -q awscliv2.zip
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update   
```
4. **Configure AWS credentials:**
```
aws configure 
```

```
Provide:
- AWS Access Key ID  
- AWS Secret Access Key  
- Default region name  
- Default output format 
```
> [!NOTE]
> Ensure the IAM user you use has sufficient permissions (for example, to manage the AWS resources that Terraform will create)

5. **Generate SSH key pair:**
Create a new SSH key pair that will be used to access the EC2 instance
```bash
ssh-keygen -f terra-key
```
<img width="1357" height="177" alt="SSH" src="https://github.com/user-attachments/assets/76ee1203-3cce-4bcd-b346-0786e5541f22" />


6. **Set private key permissions:**
Restrict the private key so that only the owner can read it
```bash
chmod 400 terra-key
```
7. **Initialize Terraform:**
Initialize the Terraform working directory and download the required providers and modules
```bash
terraform init
```
8. **Review the execution plan:**
Inspect the planned infrastructure changes before applying them
```bash
terraform plan
```
9) **Apply the configuration:**
Create the AWS infrastructure defined in the Terraform configuration
```bash
terraform apply --auto-approve
```
> [!IMPORTANT]
> This step provisions the AWS infrastructure (VPC, EKS, EC2, and related resources) in your AWS account

10) **SSH into the EC2 instance:**
Use the generated SSH key and the instance public IP to connect
```bash
ssh -i terra-key ubuntu@<public-ip>
```
> Replace <public-ip> with the public IPv4 address of the EC2 instance from the AWS console.

11) **Update kubeconfig for the EKS cluster:**
From any machine or bastion host with AWS CLI and kubectl configured, run
```bash
aws eks --region us-east-1 update-kubeconfig --name EasyShop-Cluster
```
> [!IMPORTANT]
> Ensure you are authenticated with valid AWS credentials (for example, using aws configure or an AWS profile) before running this command

12) **Verify EKS cluster access:**
Confirm that your kubectl context is pointing to the EKS cluster and that nodes are registered:
```bash
kubectl get nodes
```

## 2] Continuous integration:

### Requirements:
- Docker 
- Jenkins && Java 
- SonarQube
- Owasp
- Shared Library
- Trivy
- Some Plugins
- Credential : DockerHub , Gmail (smtp) , Sonarqube token , Github

> [!IMPORTANT]
> Docker, Jenkins (with Java), and Trivy are already installed as part of the infrastructure setup.

1. **Verify Jenkins service:**

```
sudo systemctl status jenkins
```
- If Jenkins is not running, enable and restart the service:

```bash
sudo systemctl enable jenkins
sudo systemctl restart jenkins
```
2. **Access Jenkins UI:** : `http://<public_IP>:8080`

3. **Get the initial admin password:**

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
- Use this password to log in and create the first admin user

4. **Install essential plugins:**

 - Go to: `Manage Jenkins → Plugins → Available plugins`
 - Search and install:
   - Docker Pipeline  
   - Pipeline View  
   - SonarQube Scanner  
   - OWASP Dependency-Check

<img width="1340" height="670" alt="image" src="https://github.com/user-attachments/assets/9e0ba157-e00d-48d1-96e0-eca63b255134" />

5. **Configure DockerHub and Gmail credentials:**

 - Go to: `Jenkins → Manage Jenkins → Credentials → (global) → Add Credentials`
 - Kind: `Username with password`
 - Add:
   - DockerHub credentials
   - Gmail credentials
   - Sonarqube credentials (after the sonar setup)
   - Github credentials

[Notes:] Use these IDs in your Jenkins pipeline for secure access to Gmail and DockerHub and SonarQube

6. **Install and configure SonarQube:**
   
```bash
docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community
```

 1. Open: `http://<public_ip>:9000`  
 2. Log in with default credentials: `admin / admin`  
 3. Go to: `Administration → Security → Users` and create a token for Jenkins  
 4. In Jenkins, add the token as a **Secret text** credential:  
    - `Manage Jenkins → Credentials → (global) → Add Credentials` → Kind: `Secret text`  
 5. Configure **SonarQube Scanner** tool:  
    - `Manage Jenkins → Tools → SonarQube Scanner`  
    - Name: `Sonar`  
    - Enable “Install automatically” and select a version
      <img width="1661" height="790" alt="SonarTool" src="https://github.com/user-attachments/assets/805b26b1-91ce-45c4-9fcf-a4b50fa17a2c" />
       
 6. Configure **SonarQube server**:  
    - `Manage Jenkins → Configure System → SonarQube servers`  
    - Name: `Sonar`  
    - Server URL: `http://<public_ip>:9000`  
    - Select the previously created SonarQube credential.
      <img width="1648" height="814" alt="SonarSystem" src="https://github.com/user-attachments/assets/71bbb818-8d74-41b0-8ab5-1dd2b6701f6f" />
      <img width="1920" height="1080" alt="Screenshot from 2025-12-14 10-59-35" src="https://github.com/user-attachments/assets/45fd915c-4e47-4b33-9220-2bf23dec64d1" />

7. **Configure Jenkins shared library:**
   
 - Go to: `Manage Jenkins → Configure System`
 - Scroll to **Global Pipeline Libraries** and add:
   - Name: `Shared`
   - Default version: `main`
   - Project repository URL: `https://github.com/<your-username>/jenkins-shared-libraries`
     <img width="1685" height="830" alt="SharedSetup1" src="https://github.com/user-attachments/assets/f635ae72-dad0-408b-b67e-450ffb881468" />
     <img width="1683" height="830" alt="SharedSetup2" src="https://github.com/user-attachments/assets/eda476b6-3a50-407d-a1fd-f67a5cbc78bf" />

 - Ensure the repository has the correct structure (for example, a `vars/` directory with Groovy scripts).

8. **Configure OWASP Dependency-Check**

 - Go to: `Manage Jenkins → Configure System → Tools`
 - Under **Dependency-Check installations**, add:
   - Name: `OWASP`
   - Install from GitHub (select an appropriate version)
     <img width="1672" height="824" alt="OWASPSetup" src="https://github.com/user-attachments/assets/027cdbf9-cb60-4b0a-8558-dd060b8ec4d0" />

> [!IMPORTANT]  
> Ensure the **OWASP Dependency-Check** Jenkins plugin is installed before configuring the tool.

9. **Email Setup (Jenkins):**
1. Global SMTP configuration
   `Jenkins → Manage Jenkins → Configure System.`
   Scroll to E-mail Notification:
   - SMTP server: `smtp.gmail.com`
   - Check Use SMTP Authentication
   - User Name: `your-email@gmail.com`
   - Password: Gmail App Password (2FA on).
   - Check Use SSL
   - SMTP Port: `465`
   - Reply-To Address: `your-email@gmail.com`
     Test configuration by sending test e-mail to verify
     
2. Extended E-mail Notification:
   - SMTP server: `smtp.gmail.com​​`
   - Default Recipients: `your-email@gmail.com`
   - Content type: `HTML` (text/html) (optional).
      
  
10. **Create the EasyShop pipeline**
1. *Easyshop CI:*
 - New Item → `Pipeline`
   - Name: `Easyshop CI`
   - Description: `EasyShop Application`
 - Enable **GitHub project** and set:
   - `https://github.com/nilesh-fatfatwale/easyshop`
 - In the **Pipeline** section:
   - Definition: `Pipeline script from SCM`
   - SCM: `Git`
   - Repository URL: `https://github.com/nilesh-fatfatwale/easyshop`
   - Branch: `main`
   - Script Path: `Jenkinsfile`.
     
 2. *Easyshop CD:*
 - New Item → `Pipeline`
    - Name: `Easyshop CD`
    - Description: `EasyShop Application`
  - Enable **GitHub project** and set:
    - `https://github.com/nilesh-fatfatwale/easyshop`
  - In the **Pipeline** section:
    - Definition: `Pipeline script from SCM`
    - SCM: `Git`
    - Repository URL: `https://github.com/nilesh-fatfatwale/easyshop`
    - Branch: `main`
    - Script Path: `GitOps/Jenkinsfile`.
      <img width="1891" height="1003" alt="DockerProcess" src="https://github.com/user-attachments/assets/124b40e4-5b5b-4cf0-b460-283dc2a75815" />

      <img width="1894" height="1007" alt="EasyshopCDProcess" src="https://github.com/user-attachments/assets/95673c5c-6d7d-4d9d-a9c6-1081ba2303a9" />

     
                 
## 3] Continuous Deployment

### Requirements
- kubectl  
- eksctl  
- Argo CD & Argo CD CLI  
- AWS CLI (configured)  
- cert-manager & domain name  
- NGINX Ingress Controller  
- Helm  
- Email notification

> [!IMPORTANT]
> kubectl, eksctl, and Helm are already installed during infra setup.

1. **Update kubeconfig:**
   
```
aws eks --region us-east-1 update-kubeconfig --name EasyShop-Cluster
```
2. **Argocd install:**
     1. Create Argo CD namespace:
         
         ```
         kubectl create namespace argocd
         ```
     2. Install Argo CD:
        
        ```
         kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
        ```
     3. Watch Argo CD pods:
        ```
        watch kubectl get pods -n argocd
        ```
3. **Argo CD CLI:**
     1. Install argocd CLI:
        ```
        sudo curl --silent --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.4.7/argocd-linux-amd64
        sudo chmod +x /usr/local/bin/argocd
        ```
     2. Check argocd services:
        ```
        kubectl get svc -n argocd
        ```
4. **Install NGINX Ingress Controller:**
     1. Add Helm repository
        
        ```
        helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
        helm repo update
        ```
      2. Install ingress controller
  
         ```
         helm install my-ingress-nginx ingress-nginx/ingress-nginx \
         --namespace ingress-nginx \
         --create-namespace \
         --set controller.enableSSLPassthrough=true
         ```
      3. check ingress service
         
         ```
         kubectl get service --namespace ingress-nginx my-ingress-nginx-controller
         ```
         <img width="1897" height="144" alt="NginxLoadbanlancer" src="https://github.com/user-attachments/assets/231b0f89-8b4f-4d11-9e5f-db1aedd85958" />

         
5. **update the dns names for argocd,easyshop,promithus and grafana:**
         Take ingress-nginx dns and put into domain
     <img width="1188" height="594" alt="Dns" src="https://github.com/user-attachments/assets/053175ef-a5bf-468b-83d8-33724bc44d3c" />

   
7. **SSL certificates (cert-manager + Let’s Encrypt):**
     1. Install cert-manager:
      
        ```
        kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml
        ```
     2. Wait for cert-manager to be ready:
      
        ```
        kubectl wait --for=condition=ready pod -l app.kubernetes.io/instance=cert-manager -n cert-manager --timeout=300s
        ```
     3. Clone the repository and navigate to the kubernetes folder:
        1. Clone the repository and navigate to the kubernetes folder
           ```bash
           https://github.com/nilesh-fatfatwale/easyshop
           cd easyshop/kubernetes
           ```
     4. configure Let’s Encrypt:
        1. Setup letsencrypt-issuer.yaml with your email (replace <your-email@example.com> with actual email).
        2. Apply Let's Encrypt issuer (update email in letsencrypt-issuer.yaml first)
           
           ```
           kubectl apply -f letsencrypt-issuer.yaml
           ```
           1. `kubectl get clusterissuer letsencrypt-staging`
           2. `kubectl get clusterissuer letsencrypt-prod`
        3. Update DNS and Access ArgoCD:
           1. Get the load balancer hostname
           ```
           # Get the load balancer hostname (External IP)
           kubectl get svc -n ingress-nginx
           ```
           2. Point domain argocd.yourdomain.com (replace with  actual domain) to this load balancer in DNS of  domain as a CNAME record

        4. Apply ArgoCD ingress with SSL:
           
           ```
           kubectl apply -f argocd-ingress.yaml
           ```
          - 1. `kubectl  get ing -n argocd`

    7. Verify SSL Certificate Creation:
       1. Check certificate request status
         ```
         kubectl get certificate -n argocd
         ```
       2. Check certificate details
         ```
         kubectl describe certificate argocd-server-tls -n argocd
         ```
      3. Check cert-manager logs if issues
         ```
         kubectl logs -n cert-manager deployment/cert-manager
         ```
      4. Verify the secret was created
         ```
         kubectl get secret argocd-server-tls -n argocd
         ```
         <img width="1890" height="523" alt="Certificate" src="https://github.com/user-attachments/assets/8a6e66d7-9fcd-43dc-a9d9-61d8b60bf22d" />


> [!NOTE]
> Let’s Encrypt may take 5–10 minutes to issue the certificate. A Pending status is normal during this time.

7. **Log in to Argo CD UI:**
     1. Access the argocd ui : `https://argocd.yourdomain.com/`
     2. Get initial admin password:
        ```
        kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
        ```
     3. Log in as `admin` and change the default password.
        <img width="1899" height="886" alt="ArgocdClusterAdd" src="https://github.com/user-attachments/assets/aae31a64-8b6e-41df-8737-97c0c7cb1511" />

         
8. **Register cluster & deploy app:**
     1. Login via CLI:
        
        ```
        argocd login argocd.yourdomain.com --username admin
        ```
     2. List clusters:
        ```
        argocd cluster list
        ```
     3. Check kubeconfig contexts:
        ```
        kubectl config get-contexts
        ```
     4.  Add cluster to Argo CD (replace `<CONTEXT>` and name as needed):
        ```
        argocd cluster add <CONTEXT> --name Easyshop-Cluster
        ```   
        <img width="1906" height="457" alt="Clusteradd" src="https://github.com/user-attachments/assets/fa685177-5f38-4154-b804-15b603ac81c7" />
        <img width="1920" height="1080" alt="Screenshot from 2025-12-14 09-33-19" src="https://github.com/user-attachments/assets/aa3c935e-b0df-4406-b603-964389f76977" />
        <img width="1920" height="1080" alt="Screenshot from 2025-12-14 09-32-35" src="https://github.com/user-attachments/assets/8987f705-d982-4f8a-bf8a-809f852bde3a" />

10. **Email alerts (Argo CD notifications):**
     1. Update the gmail username and password inside `secrets.yaml` file
     2. change the context inside `argocd-notifications-cm.yaml` file :  `argocdUrl: "<domain/IPaddress>" `
     3. replace email config and spec details inside `application-notification.yaml` file
     4. Setup: Integrating with Email
        
        ```
        kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/notifications_catalog/install.yaml
        ```
     5. Check notification controller logs:
        ```
        kubectl -n argocd logs deploy/argocd-notifications-controller --follow
        ```
11. **Deploy application via Argo CD UI:**
      - Create Application:
        - Application name: `easyshop`
        - Project: `default`
        - Repository URL: `https://github.com/nilesh-fatfatwale/easyshop`
        - Path: `<k8s manifests path>`
        - Cluster: `https://kubernetes.default.svc` (or which we added using cluster add)
        - Namespace: `easyshop`
      
## 4] Monitoring:

### Requirements
- Helm  
- Prometheus  
- Grafana  

1. **Install Prometheus & Grafana (kube-prometheus-stack):**
   
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
kubectl create namespace monitoring
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring
```
> [!NOTE]
> This command deploys Prometheus, Grafana, Alertmanager, and related monitoring components into the `monitoring` namespace

2. **Get Grafana admin password:**
```
kubectl get secret -n monitoring kube-prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

3. **Import the following dashboard IDs from Grafana.com:**
   - `19993`  
   - `14584`  
   - `15661`  

These IDs correspond to popular Kubernetes/Prometheus dashboards that work well with `kube-prometheus-stack`

## **Infrastructure Teardown (Terraform Destroy):**

```
terraform destroy --auto-approve
```
> [!NOTE]
> To clean up all the AWS resources created for EasyShop, run Terraform destroy from the `infra/` directory.


## 🚀 Final Output

<img width="1899" height="1015" alt="Application" src="https://github.com/user-attachments/assets/8f38ac97-dc89-43c4-ba08-57d298d82ab2" />

<img width="1902" height="1007" alt="Ordering" src="https://github.com/user-attachments/assets/d7e12964-a6c6-4d38-91d9-6082301a6b71" />

<img width="1905" height="995" alt="Order" src="https://github.com/user-attachments/assets/c1c40bbd-1bc7-41c9-86cc-d747c73d429c" />

<img width="1920" height="1080" alt="Screenshot from 2025-12-14 10-54-16" src="https://github.com/user-attachments/assets/43ac377a-f7a2-48be-8c3f-94e963a5dfc9" />


<img width="1899" height="1008" alt="Sonar" src="https://github.com/user-attachments/assets/3db99663-88ca-4a97-920a-8e5bfec09eac" />

<img width="1896" height="1006" alt="Sonar2" src="https://github.com/user-attachments/assets/b7ca4c6c-7f5b-4aeb-bdf9-bfed025112f2" />

<img width="1890" height="1011" alt="DependencyCheck" src="https://github.com/user-attachments/assets/213f7ade-0d94-41eb-be5d-7bcc4f55bd49" />

<img width="1900" height="1004" alt="Grafana" src="https://github.com/user-attachments/assets/a4add68f-e800-4490-8638-85ddc6a3b052" />

<img width="1898" height="1010" alt="Grafana2" src="https://github.com/user-attachments/assets/989e690d-5ee3-4eb0-ad15-74e90d60216c" />

<img width="1897" height="833" alt="GitOps" src="https://github.com/user-attachments/assets/fda9b398-bb48-47a5-8b5f-be4deb48293e" />

<img width="1903" height="1007" alt="Argocd" src="https://github.com/user-attachments/assets/0ea07e05-16e4-46c7-9ebe-cb4ab16040b0" />

<img width="1920" height="1015" alt="Screenshot from 2025-12-15 11-16-28" src="https://github.com/user-attachments/assets/af9c21c3-a3b8-465b-9258-8e2b0b47bdbc" />

<img width="1920" height="1015" alt="Screenshot from 2025-12-15 11-16-47" src="https://github.com/user-attachments/assets/329e04d0-28f1-4b17-a68a-d868d5e53078" />


## Contributions: Contributions are welcome — feel free to open issues or submit pull requests to improve this project.
