# Use official Ollama base image
FROM ollama/ollama:latest

# Set working directory
WORKDIR /app

# Copy renamed entrypoint script into container
COPY vk_entrypoint.sh /app/vk_entrypoint.sh

# Make the script executable
RUN chmod +x /app/vk_entrypoint.sh

# Set custom entrypoint to start Ollama and pull models
CMD ["/app/vk_entrypoint.sh"]
