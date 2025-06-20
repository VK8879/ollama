# Use official Ollama base image
FROM ollama/ollama

# Set working directory
WORKDIR /app

# Copy the entrypoint script into the container
COPY vk_entrypoint.sh /app/vk_entrypoint.sh

# Make the script executable
RUN chmod +x /app/vk_entrypoint.sh

# Run the entrypoint script
ENTRYPOINT ["/app/vk_entrypoint.sh"]
