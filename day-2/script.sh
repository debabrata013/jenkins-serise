#!/bin/bash
set -eo pipefail

# Color codes for terminal formatting
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

APP_NAME="${APP_NAME:-DevOps Health Monitor}"
TARGET_URL="${TARGET_URL:-https://httpbin.org/status/200}"
CHECK_INTERVAL="${CHECK_INTERVAL:-2}"
MAX_RUNS="${MAX_RUNS:-5}"

# Handle argument flags
if [ "$1" = "--once" ]; then
    MAX_RUNS=1
elif [[ "$1" =~ ^[0-9]+$ ]]; then
    MAX_RUNS="$1"
fi

echo -e "${BLUE}===========================================${NC}"
echo -e "${GREEN}🚀 Starting ${APP_NAME} (${MAX_RUNS} runs)${NC}"
echo -e "${BLUE}===========================================${NC}"

monitor_system() {
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    echo -e "${YELLOW}[${TIMESTAMP}] Running Diagnostics...${NC}"
    
    # Disk Usage Check
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
    echo -e "💾 Disk Usage (/): ${DISK_USAGE}"
    
    # Memory Check
    if command -v free >/dev/null 2>&1; then
        MEM_USED=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
        echo -e "🧠 Memory Used: ${MEM_USED}"
    fi

    # Network / Health Check
    if command -v curl >/dev/null 2>&1; then
        echo -e "🌐 Checking Endpoint: ${TARGET_URL}"
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "${TARGET_URL}" || echo "FAILED")
        if [ "$HTTP_CODE" = "200" ]; then
            echo -e "${GREEN}✅ Endpoint Health: UP (HTTP ${HTTP_CODE})${NC}"
        else
            echo -e "${RED}❌ Endpoint Health: DOWN/UNREACHABLE (HTTP ${HTTP_CODE})${NC}"
        fi
    fi
}

trap "echo -e '\n${RED}Shutting down monitor service...${NC}'; exit 0" SIGINT SIGTERM

for (( i=1; i<=MAX_RUNS; i++ )); do
    echo -e "\n${BLUE}--- Run ${i} of ${MAX_RUNS} ---${NC}"
    monitor_system
    
    # Sleep between runs, except after the last run
    if [ "$i" -lt "$MAX_RUNS" ]; then
        echo -e "${BLUE}Sleeping for ${CHECK_INTERVAL}s...${NC}"
        sleep "${CHECK_INTERVAL}"
    fi
done

echo -e "\n${GREEN}🎉 Completed all ${MAX_RUNS} diagnostic runs!${NC}"
