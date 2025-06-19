FROM ollama/ollama

# Install curl (required for model preload)
RUN apt-get update && apt-get install -y curl

# Set working directory and copy entrypoint script
WORKDIR /app
COPY vk_entrypoint.sh /app/vk_entrypoint.sh
RUN chmod +x /app/vk_entrypoint.sh

# Set custom start command
CMD ["/app/vk_entrypoint.sh"]
