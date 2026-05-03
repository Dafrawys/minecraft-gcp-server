# 🚀 Production-Ready Minecraft Server on GCP (DevOps Project)

> Fully automated, cost-optimized Minecraft server deployment using Terraform, CI/CD, and cloud best practices.

---

## 🧠 Why this project?

This project demonstrates **real-world DevOps skills**, not just tutorials:

* Infrastructure as Code (Terraform)
* CI/CD pipeline integration
* Cloud networking (VPC, firewall, static IP)
* Cost optimization strategies
* Remote state management

👉 Built to simulate how production infrastructure is deployed and managed.

---

## 🏗️ Architecture

<p align="center">
  <img src="https://raw.githubusercontent.com/Dafrawys/minecraft-gcp-server/main/docs/images/gcp-minecraft-architecture.png" width="700"/>
</p>

### 🧩 Architecture Explanation

* Users connect via a **public static IP** over port `25565`
* Traffic flows through **VPC firewall rules**
* A **Compute Engine VM** runs the Minecraft server
* A **startup script** installs Java and launches the server
* Infrastructure is provisioned using **Terraform**
* **Terraform Cloud** manages remote state and execution
* **GitHub Actions** triggers deployments (CI/CD)

---

## ⚙️ Tech Stack

| Category   | Tools Used            |
| ---------- | --------------------- |
| IaC        | Terraform             |
| Cloud      | Google Cloud Platform |
| CI/CD      | GitHub Actions        |
| Scripting  | Bash                  |
| State Mgmt | Terraform Cloud       |

---

## 📁 Project Structure

```bash
.
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── versions.tf
├── scripts/
│   └── startup.sh
├── .github/workflows/
│   └── terraform.yml
├── .env.example
├── deploy.sh
└── README.md
```

---

## 🚀 Deployment

### 🔹 Option 1 — Terraform Cloud (Recommended)

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

---

### 🔹 Option 2 — Local Bash Deployment

```bash
cp .env.example .env
chmod +x deploy.sh
./deploy.sh
```

---

## 🔐 Environment Variables

Create a `.env` file:

```env
PROJECT_ID=your-project-id
REGION=us-central1
ZONE=us-central1-c
INSTANCE_NAME=mc-server
```

---

## 💸 Cost Optimization

This project is designed to **minimize cloud costs**:

* Uses lightweight VM (`e2-medium`)
* Auto-shutdown strategy (no idle cost)
* Manual destroy supported

```bash
terraform destroy
```

---

## 🔄 CI/CD Pipeline

* Push to GitHub triggers workflow
* GitHub Actions runs Terraform
* Terraform Cloud provisions infrastructure

```text
GitHub → Actions → Terraform Cloud → GCP
```

---

## 🧪 What this project proves

This isn’t just a script — it shows:

* ✅ You can design cloud architecture
* ✅ You understand networking (VPC, firewall)
* ✅ You use Terraform properly (remote state)
* ✅ You integrate CI/CD pipelines
* ✅ You think about cost and scalability

---

## 📈 Future Improvements

* Dockerize Minecraft server
* Add domain + DNS (Cloud DNS)
* Add monitoring (Prometheus + Grafana)
* Add autoscaling or scheduling
* Build web dashboard for server control

---

## ⚠️ Requirements

* GCP account with billing enabled
* Terraform installed
* GitHub account
* Terraform Cloud account

---

## 🧠 Key Learnings

* Infrastructure as Code in real environments
* Remote state & team workflows
* Cloud security basics
* Automation & CI/CD pipelines
* Debugging real deployment issues

---

## 👨‍💻 Author

Ahmed ElDafrawy

---

## ⭐ If you found this useful

Give the repo a star — it helps a lot!
