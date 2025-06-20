# Base image from Ollama
FROM ollama/ollama:latest

# Create working directory
WORKDIR /app

# Copy custom entrypoint
COPY vk_entrypoint.sh /app/entrypoint.sh

# Make sure it's executable
RUN chmod +x /app/entrypoint.sh

# Optional: expose port (Ollama defaults to 11434)
EXPOSE 11434

# Start the server using the custom entrypoint
CMD ["/app/entrypoint.sh"]
