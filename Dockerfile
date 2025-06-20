# Use Ollama base image
FROM ollama/ollama:latest

# Copy your custom entrypoint
COPY vk_entrypoint.sh /usr/bin/vk_entrypoint.sh
RUN chmod +x /usr/bin/vk_entrypoint.sh

# Run your script as the container start command
ENTRYPOINT ["/usr/bin/vk_entrypoint.sh"]
