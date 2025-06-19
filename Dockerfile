FROM ollama/ollama

# Copy the custom entrypoint script
COPY vk_entrypoint.sh /app/vk_entrypoint.sh

# Make the script executable
RUN chmod +x /app/vk_entrypoint.sh

# Set custom script as container entrypoint
ENTRYPOINT ["/app/vk_entrypoint.sh"]
