# Use official Ollama base image
FROM ollama/ollama:latest

# Copy entrypoint script into image
COPY vk_entrypoint.sh /app/vk_entrypoint.sh
RUN chmod +x /app/vk_entrypoint.sh

# Set the script as the default command
CMD ["/app/vk_entrypoint.sh"]
