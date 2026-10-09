# Use a lightweight Alpine Linux base image
FROM alpine:3.19

# Install dependencies (bash, curl, procps for memory stats)
RUN apk add --no-cache bash curl procps

# Set working directory inside container
WORKDIR /app

# Copy the bash script into the image
COPY script.sh /app/script.sh

# Grant execution permissions to the script
RUN chmod +x /app/script.sh

# Set default environment variables (can be overridden at runtime)
ENV APP_NAME="Jenkins DevOps Monitor" \
    TARGET_URL="https://httpbin.org/status/200" \
    CHECK_INTERVAL="5"

# Run the container using ENTRYPOINT
ENTRYPOINT ["/app/script.sh"]
