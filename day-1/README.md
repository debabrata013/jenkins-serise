# 📅 Day 1: VPS Security & Jenkins Setup with Docker Compose, Nginx & SSL

---

## 🎯 1. Goal & Objective

Setting up a secure, production-ready DevOps environment on a VPS to host Jenkins using Docker Compose, reverse proxied with Nginx, secured with SSL via Let's Encrypt, and tuned to local timezone settings.

- [x] Create a non-root `dev` user with sudo and Docker access.
- [x] Deploy Jenkins using Docker Compose.
- [x] Configure Nginx reverse proxy with SSL (`jenkins.glausco.tech`).
- [x] Fix container timezone to Indian Standard Time (`Asia/Kolkata`).
- [x] Run a test freestyle job in Jenkins.

---

## 🛠️ 2. How I Did It (Step-by-Step Implementation)

### Step 1: User Creation & SSH Security
1. Created a separate `dev` user:
   ```bash
   sudo adduser dev
   sudo usermod -aG sudo dev
   ```
2. Configured SSH key-based authentication:
   ```bash
   mkdir -p /home/dev/.ssh
   nano /home/dev/.ssh/authorized_keys
   chmod 700 /home/dev/.ssh
   chmod 600 /home/dev/.ssh/authorized_keys
   chown -R dev:dev /home/dev/.ssh
   ```

### Step 2: Docker Access for Non-Root User
1. Added `dev` user to the `docker` group to fix `permission denied` on `docker ps`:
   ```bash
   sudo usermod -aG docker dev
   newgrp docker
   ```

### Step 3: Jenkins Deployment via Docker Compose
1. Configured `docker-compose.yml` with Jenkins LTS image and `TZ=Asia/Kolkata` timezone variable.
2. Started Jenkins container:
   ```bash
   docker compose up -d
   ```

### Step 4: Nginx Reverse Proxy & SSL Setup
1. Created Nginx site configuration `/etc/nginx/sites-available/jenkins.glausco.tech` pointing to `http://127.0.0.1:8080`.
2. Linked configuration using an absolute path symlink:
   ```bash
   sudo ln -s /etc/nginx/sites-available/jenkins.glausco.tech /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl reload nginx
   ```
3. Generated Let's Encrypt SSL certificate using Certbot:
   ```bash
   sudo certbot --nginx -d jenkins.glausco.tech
   ```

### Step 5: Jenkins Verification
1. Created a simple `Jenkins-Demo` freestyle project.
2. Configured a basic **Execute Shell** step to test build execution.

---

## 🧠 3. Key Learnings & Concepts Covered

- **Linux Administration & Security:** Managing non-root users, SSH key security, sudoers, and group permissions.
- **Docker Privileges:** Understanding socket permissions (`/var/run/docker.sock`) and applying `newgrp docker` without needing full system reboot.
- **Reverse Proxy Architecture:** Forwarding HTTPS requests from Nginx to Jenkins backend safely.
- **Container Environment Customization:** Setting `TZ=Asia/Kolkata` inside Docker containers to align server UI clocks.

---

## ⚠️ 4. Challenges Faced & Solutions

| # | Challenge / Error | Root Cause | Solution |
| :-: | :--- | :--- | :--- |
| **1** | `docker ps` gave `permission denied` | User `dev` was not in `docker` group | Ran `sudo usermod -aG docker dev` and refreshed session with `newgrp docker`. |
| **2** | Nginx: `Too many levels of symbolic links` | Symlink created using wrong relative path | Removed bad link and recreated with absolute paths (`ln -s /etc/nginx/sites-available/... /etc/nginx/sites-enabled/`). |
| **3** | Nginx syntax validation error on `nginx -t` | Extra closing bracket and invalid `proxy_pass` formatting | Corrected syntax in site block and validated using `nginx -t`. |
| **4** | Certbot error: `Permission denied` | Ran certbot as unprivileged user | Executed Certbot with `sudo certbot --nginx -d jenkins.glausco.tech`. |
| **5** | Jenkins UI displayed UTC time instead of IST | Default container timezone set to UTC | Added `TZ=Asia/Kolkata` to environment section in `docker-compose.yml` & recreated container. |

---

## 🧪 5. Verification & Proof of Work

```bash
# Verify Nginx status
sudo nginx -t
# Output: nginx: configuration file /etc/nginx/nginx.conf syntax is ok

# Verify Jenkins container
docker ps
# Output: Container jenkins running on port 8080 (Up and Healthy)
```

---

## 📌 6. Useful Commands Cheat Sheet

```bash
# Check Docker group session
newgrp docker

# Test Nginx syntax & reload
sudo nginx -t && sudo systemctl reload nginx

# Recreate Docker Compose services with new environment vars
docker compose up -d --force-recreate
```
