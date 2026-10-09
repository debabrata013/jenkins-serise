# 📅 Day 2: Bash Script Automation & Docker Containerization

---

## 🎯 1. Goal & Objective

Write a production-ready system diagnostics & health check Bash script and containerize it using Docker so it can be automatically executed inside a Jenkins CI/CD pipeline.

- [x] Create a Bash script (`script.sh`) that checks Disk Usage, Memory, and HTTP Endpoint health.
- [x] Create an Alpine-based lightweight `Dockerfile` to package the script.
- [x] Test single-execution mode (`--once`) and continuous monitoring daemon mode.
- [x] Configure environment variables (`APP_NAME`, `TARGET_URL`, `CHECK_INTERVAL`) to customize container runtime behavior.

---

## 🛠️ 2. How I Did It (Step-by-Step Implementation)

### Step 1: Writing the Diagnostics Script (`script.sh`)
The script checks disk space (`df -h`), memory usage (`free -m`), and pings a target URL via `curl` with color-coded terminal output.

```bash
#!/bin/bash
set -eo pipefail

APP_NAME="${APP_NAME:-DevOps Health Monitor}"
TARGET_URL="${TARGET_URL:-https://httpbin.org/status/200}"

# Run once with --once flag or loop as a service
if [ "$1" = "--once" ]; then
    monitor_system
else
    trap "exit 0" SIGINT SIGTERM
    while true; do monitor_system; sleep 5; done
fi
```

### Step 2: Creating the Dockerfile (`Dockerfile`)
Used Alpine Linux to keep the image footprint minimal (~15MB):

```dockerfile
FROM alpine:3.19

RUN apk add --no-cache bash curl procps
WORKDIR /app
COPY script.sh /app/script.sh
RUN chmod +x /app/script.sh

ENV APP_NAME="Jenkins DevOps Monitor" \
    TARGET_URL="https://httpbin.org/status/200" \
    CHECK_INTERVAL="5"

ENTRYPOINT ["/app/script.sh"]
```

### Step 3: Local Execution & Testing
Made the script executable and tested a single run:

```bash
chmod +x script.sh
./script.sh --once
```

---

## 🧠 3. Key Learnings & Concepts Covered

- **Bash Scripting Best Practices:** Using `set -eo pipefail` for strict error handling, handling system traps (`SIGINT`/`SIGTERM`), and setting default environment variables using `${VAR:-default}`.
- **Docker Image Optimization:** Multi-layer caching and using lightweight `alpine` base image with `--no-cache` for minimal security attack surface.
- **ENTRYPOINT vs CMD:** Using `ENTRYPOINT` so the container behaves directly like an executable CLI tool while still accepting arguments (like `--once`).

---

## ⚠️ 4. Challenges Faced & Solutions

| # | Challenge / Error | Root Cause | Solution |
| :-: | :--- | :--- | :--- |
| **1** | `free` command missing in bare Alpine | Default minimal Alpine image lacks `procps` utilities | Added `procps` package in `apk add --no-cache bash curl procps`. |
| **2** | Script didn't handle container stop signal | Default bash loops ignore `docker stop` (SIGTERM) | Added `trap "exit 0" SIGINT SIGTERM` to cleanly exit container on shutdown. |
| **3** | `curl` hanging on dead endpoint | Default `curl` waits indefinitely | Added `--max-time 5` flag to `curl` to set a 5-second connection timeout. |

---

## 🧪 5. Verification & Proof of Work

```text
===========================================
🚀 Starting DevOps Health Monitor
===========================================

[2026-10-09 07:10:05] Running Diagnostics...
💾 Disk Usage (/): 12%
🌐 Checking Endpoint: https://httpbin.org/status/200
✅ Endpoint Health: UP (HTTP 200)
```

---

## 📌 6. Useful Commands Cheat Sheet

```bash
# Build Docker image
docker build -t devops-monitor:v1 day-2/

# Run container once
docker run --rm devops-monitor:v1 --once

# Run container in background with custom target URL
docker run -d --name health-checker -e TARGET_URL="https://google.com" devops-monitor:v1
```
