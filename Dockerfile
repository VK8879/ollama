# ----------- STAGE 1: Build ollama binary (skip this if using prebuilt binary) ----------
FROM debian:bookworm-slim as runtime

# Install required tools
RUN apt-get update && \
    apt-get install -y ca-certificates curl gnupg && \
    rm -rf /var/lib/apt/lists/*

# Download prebuilt Ollama binary
RUN curl -fsSL https://ollama.com/download/Ollama-linux -o /usr/bin/ollama && \
    chmod +x /usr/bin/ollama

# Create model directory
RUN mkdir -p /root/.ollama

# Pre-pull models
RUN ollama serve & \
    sleep 5 && \
    ollama pull llama3 && \
    ollama pull phi3 && \
    ollama pull gemma && \
    ollama pull codellama && \
    ollama pull mistral && \
    pkill ollama

# Expose port
EXPOSE 11434

# Default command
CMD ["ollama", "serve"]
