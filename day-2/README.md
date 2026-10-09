# 📅 Day 2: Bash Automation, Dockerization & Jenkins Poll SCM (2-Min Interval)

---

## 🎯 1. Goal & Objective

Write a system diagnostics & health check Bash script, package it with Docker, and set up a **Jenkins Freestyle Project** configured with **Poll SCM** to check for new Git commits every **2 minutes** (`H/2 * * * *`) and execute the script automatically.

- [x] Create a Bash script (`script.sh`) that checks Disk Usage, Memory, and HTTP Endpoint health (configured to run 5 iterations).
- [x] Create an execution script (`exe.sh`) to navigate directories and trigger execution inside Jenkins workspace.
- [x] Create an Alpine-based lightweight `Dockerfile` to package the script.
- [x] Configure Jenkins Freestyle Project with **Poll SCM** (`H/2 * * * *`) to auto-trigger builds on new code pushes.

---

## 🛠️ 2. How I Did It (Step-by-Step Implementation)

### Step 1: Writing the Diagnostics Script (`script.sh`)
The script checks system health in a 5-run loop:

```bash
#!/bin/bash
set -eo pipefail

APP_NAME="${APP_NAME:-DevOps Health Monitor}"
TARGET_URL="${TARGET_URL:-https://httpbin.org/status/200}"
CHECK_INTERVAL="${CHECK_INTERVAL:-2}"
MAX_RUNS="${MAX_RUNS:-5}"

for (( i=1; i<=MAX_RUNS; i++ )); do
    echo -e "\n--- Run ${i} of ${MAX_RUNS} ---"
    monitor_system
    if [ "$i" -lt "$MAX_RUNS" ]; then
        sleep "${CHECK_INTERVAL}"
    fi
done
```

### Step 2: Execution Script for Jenkins (`exe.sh`)
Created `day-2/exe.sh` to log directory paths, user ID, and run `script.sh`:

```bash
pwd
id 
ls
cd day-2
ls
./script.sh
```

### Step 3: Setting Up Jenkins Freestyle Project with Poll SCM (Every 2 Minutes)

1. **Create New Item:**
   - Go to Jenkins Dashboard ➔ **New Item**.
   - Enter name: `Jenkins-Day2-PollSCM` ➔ Select **Freestyle project** ➔ Click **OK**.

2. **Source Code Management (SCM):**
   - Select **Git**.
   - **Repository URL:** `https://github.com/your-username/jenkins-series.git`
   - **Branch Specifier:** `*/main` (or `*/master`).

3. **Configure Build Triggers (Poll SCM - 2 Min Interval):**
   - Check **Poll SCM** checkbox.
   - **Schedule:**
     ```cron
     H/2 * * * *
     ```
     *(This tells Jenkins to inspect the Git repository every 2 minutes for any new commits. If new code is found, a build triggers automatically!)*

4. **Add Build Step (Execute Shell):**
   - Scroll to **Build Steps** ➔ Click **Add build step** ➔ Select **Execute shell**.
   - Command:
     ```bash
     chmod +x day-2/exe.sh day-2/script.sh
     ./day-2/exe.sh
     ```

5. **Save & Test:**
   - Click **Save**.
   - Push a new commit to your GitHub repository.
   - Wait 1-2 minutes: Jenkins will detect the new commit via SCM polling and launch the build automatically!

---

## 🧠 3. Key Learnings & Concepts Covered

- **Poll SCM Syntax in Jenkins:** Understanding cron-based SCM polling. `H/2 * * * *` polls Git every 2 minutes while `H` distributes system load.
- **Poll SCM vs Webhooks:** Poll SCM asks the repository periodically ("Is there new code?"), whereas Webhooks allow GitHub to push real-time notifications to Jenkins.
- **Workspace Navigation in Freestyle Jobs:** Working relative to Jenkins `${WORKSPACE}` directory (`cd day-2 && ./script.sh`).
- **Looping & Signal Traps in Shell:** Managing finite iterations (`MAX_RUNS=5`) and cleanly handling container termination signals.

---

## ⚠️ 4. Challenges Faced & Solutions

| # | Challenge / Error | Root Cause | Solution |
| :-: | :--- | :--- | :--- |
| **1** | Jenkins build failed with `Permission denied` on `exe.sh` | File lacked execution permissions in Git repository | Added `chmod +x day-2/exe.sh day-2/script.sh` in Jenkins Execute Shell step. |
| **2** | Jenkins build kept polling but didn't trigger | No new commits pushed to Git repository | Poll SCM only triggers a build when git revision/commit hash changes. Pushed a test commit to verify. |
| **3** | `free` command missing in bare Alpine container | Minimal Alpine image lacks `procps` utilities | Added `procps` package in `apk add --no-cache bash curl procps`. |

---

## 🧪 5. Verification & Proof of Work

### Jenkins Console Output Log:
```text
Started by SCM change
Building in workspace /var/jenkins_home/workspace/Jenkins-Day2-PollSCM
 > git rev-parse --is-inside-work-tree # timeout=10
 > git fetch --tags --force --progress -- https://github.com/your-repo/jenkins-series.git +refs/heads/*:refs/remotes/origin/*
 > git checkout -f e3a7b89f
[Jenkins-Day2-PollSCM] $ /bin/sh -xe /tmp/jenkins12345.sh
+ chmod +x day-2/exe.sh day-2/script.sh
+ ./day-2/exe.sh
/var/jenkins_home/workspace/Jenkins-Day2-PollSCM
uid=1000(jenkins) gid=1000(jenkins) groups=1000(jenkins)
DAY_TEMPLATE.md README.md day-1 day-2

--- Run 1 of 5 ---
[2026-10-09 07:30:00] Running Diagnostics...
💾 Disk Usage (/): 14%
🌐 Checking Endpoint: https://httpbin.org/status/200
✅ Endpoint Health: UP (HTTP 200)

... (Runs 2 to 5) ...

🎉 Completed all 5 diagnostic runs!
Finished: SUCCESS
```

---

## 📌 6. Useful Commands Cheat Sheet

```bash
# Test script locally (5 runs)
./day-2/script.sh

# Run via execution helper
./day-2/exe.sh

# Test single run
./day-2/script.sh --once

# Build & run Docker container
docker build -t devops-monitor:v1 day-2/
docker run --rm devops-monitor:v1
```
