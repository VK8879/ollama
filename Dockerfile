FROM ollama/ollama:latest

# Set working directory
WORKDIR /app

# Copy the startup script
COPY entrypoint.sh /app/entrypoint.sh

# Make it executable
RUN chmod +x /app/entrypoint.sh

# Run Ollama serve, then pull models
CMD ["/app/entrypoint.sh"]
