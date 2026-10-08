# 📅 Day [X]: [Title of the Topic]

---

## 🎯 1. Goal & Objective
> *Briefly state what you aimed to achieve today.*

- [ ] Primary Goal 1: *e.g., Set up Jenkins on VPS using Docker Compose*
- [ ] Primary Goal 2: *e.g., Configure Nginx Reverse Proxy with SSL*
- [ ] Primary Goal 3: *e.g., Test build executing a shell script*

---

## 🛠️ 2. How I Did It (Step-by-Step Implementation)

### Step 1: [Setup / Prerequisites]
*Describe the initial configuration or environment setup.*
```bash
# Example command
sudo useradd -m -s /bin/bash dev
```

### Step 2: [Core Implementation]
*Explain the main task executed (e.g., writing docker-compose, setting up Nginx).*
```yaml
# Add relevant config snippets if applicable
```

### Step 3: [Verification & Testing]
*Explain how you verified the setup worked.*
- Tested endpoint at: `http://localhost:8080` or `https://jenkins.yourdomain.com`
- Verified log outputs: `docker logs -f jenkins`

---

## 🧠 3. Key Learnings & Concepts Covered

- **[Concept 1]:** *e.g., Managing Linux user groups and permissions for Docker.*
- **[Concept 2]:** *e.g., Absolute vs Relative pathing when creating Nginx symlinks.*
- **[Concept 3]:** *e.g., Environment variables in Docker Compose (`TZ=Asia/Kolkata`).*

---

## ⚠️ 4. Challenges Faced & Solutions

| # | Challenge / Error | Root Cause | Solution |
| :-: | :--- | :--- | :--- |
| **1** | `Permission denied` when running `docker ps` | User not in `docker` group | Added user to group: `sudo usermod -aG docker dev` & ran `newgrp docker` |
| **2** | Nginx `Too many levels of symbolic links` | Symlink created with incorrect relative path | Removed invalid symlink and recreated with absolute path: `ln -s /etc/nginx/sites-available/x /etc/nginx/sites-enabled/` |
| **3** | Jenkins UI showing incorrect server time | Default container timezone set to UTC | Added `TZ=Asia/Kolkata` under `environment` in `docker-compose.yml` |

---

## 🧪 5. Verification & Proof of Work
*(Include screenshots, build log snippets, or status output verification here)*

```text
# Example build output log or verification status
[SUCCESS] Jenkins build #1 completed successfully.
```

---

## 📌 6. Useful Commands Cheat Sheet

```bash
# Quick commands used today
sudo nginx -t
sudo systemctl reload nginx
docker compose up -d
```
