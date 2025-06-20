FROM ollama/ollama

# Copy the entrypoint script from the repo root to the container's /app folder
COPY vk_entrypoint.sh /app/vk_entrypoint.sh

# Make the script executable
RUN chmod +x /app/vk_entrypoint.sh

# Use the script as the container's entrypoint
ENTRYPOINT ["/app/vk_entrypoint.sh"]
