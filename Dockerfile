# Use official Ollama image
FROM ollama/ollama:latest

WORKDIR /app

# Copy your entrypoint script
COPY vk_entrypoint.sh .

# Make it executable
RUN chmod +x /app/vk_entrypoint.sh

# Use the script itself as the entrypoint
ENTRYPOINT ["/app/vk_entrypoint.sh"]
