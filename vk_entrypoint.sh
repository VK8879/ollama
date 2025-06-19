FROM ollama/ollama:latest

# Set working directory
WORKDIR /app

# Copy the startup script
COPY vk_entrypoint.sh /app/vk_entrypoint.sh

# Make it executable
RUN chmod +x /app/vk_entrypoint.sh

# Start Ollama using the custom entrypoint
CMD ["/app/vk_entrypoint.sh"]
