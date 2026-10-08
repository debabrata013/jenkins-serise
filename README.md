# 🚀 Jenkins DevOps Series: Zero to Hero

Welcome to the **Jenkins DevOps Learning Series**! This repository documents a practical, hands-on journey of mastering **Jenkins**, **CI/CD pipelines**, **Docker containerization**, **Nginx reverse proxy setup**, **SSL security**, and **cloud infrastructure automation**.

Whether you're starting from scratch or looking to solidify your DevOps skills, this repository serves as a step-by-step guide and daily log of real-world implementations, challenges, and solutions.

---

## 📌 Series Overview

This series takes a **learning-by-doing** approach. Each day focuses on a specific production-grade DevOps topic, including complete configuration files, step-by-step guides, troubleshooting logs, and best practices.

### 🗺️ Series Roadmap & Progress

| Day | Topic / Focus Area | Key Highlights | Status |
| :---: | :--- | :--- | :---: |
| 🟢 **[Day 1](day-1/)** | **VPS Security & Jenkins Setup** | Docker Compose, Non-root Dev User, Nginx Reverse Proxy, Certbot SSL, Timezone Fix | ✅ Completed |
| 🔵 **Day 2** | *Jenkins Plugins & Credentials Management* | Secret management, SSH credentials, essential plugins | ⏳ Upcoming |
| 🔵 **Day 3** | *Freestyle Jobs & Scripted Pipelines* | Git SCM integration, Shell scripts, Build triggers | ⏳ Upcoming |
| 🔵 **Day 4** | *Declarative Jenkinsfile & Pipelines* | Stage breakdown, environment variables, post-build actions | ⏳ Upcoming |
| 🔵 **Day 5** | *Docker in Jenkins (DIND & Socket Binding)* | Building Docker images inside pipelines & pushing to registry | ⏳ Upcoming |
| 🔵 **Day 6** | *Webhook Automation & Multibranch Pipelines* | GitHub webhooks, PR builds, automated CI triggering | ⏳ Upcoming |
| 🔵 **Day 7** | *Production CD & Deployment Strategies* | Rolling updates, SSH deployment to remote servers, notifications | ⏳ Upcoming |

---

## 🛠️ Tech Stack & Tools

- **CI/CD Server:** Jenkins
- **Containerization:** Docker & Docker Compose
- **Web Server & Reverse Proxy:** Nginx
- **SSL / Security:** Certbot (Let's Encrypt), SSH Keys, Linux User Permissions
- **OS / Hosting:** Linux VPS (Ubuntu/Debian)
- **Version Control:** Git & GitHub

---

## 📂 Repository Structure

```text
.
├── README.md               # Main repository documentation & roadmap
├── DAY_TEMPLATE.md         # Template file for documenting daily logs
├── day-1/                  # Day 1: Jenkins & VPS setup
│   ├── docker-compose.yml  # Jenkins Docker Compose setup
│   ├── task.md             # Detailed breakdown of Day 1 work
│   └── README.md           # Day 1 summary log (based on template)
└── day-X/                  # Future daily challenges
```

---

## 📝 How to Use the Daily README Template

When creating a folder for a new day (e.g., `day-2/`), copy [`DAY_TEMPLATE.md`](file:///Users/debabrataprttnayak/devops%20recap/jenkins/DAY_TEMPLATE.md) into the new directory as `README.md`:

```bash
mkdir day-2
cp DAY_TEMPLATE.md day-2/README.md
```

Fill out each section as you work through the tasks!

---

## 🤝 Connect & Feedback

If you find this repository helpful or have suggestions for improvement, feel free to star ⭐ the repository or open an issue/PR!
