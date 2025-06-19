# Use the official Ollama base image
FROM ollama/ollama:latest

# Set working directory
WORKDIR /app

# Pull top models during build
RUN ollama pull dbrx && \
    ollama pull mixtral && \
    ollama pull llama3:70b && \
    ollama pull deepseek-coder && \
    ollama pull openchat && \
    ollama pull notus && \
    ollama pull yi && \
    ollama pull zephyr && \
    ollama pull falcon && \
    ollama pull phi3 && \
    ollama pull orca-mini

# Optional: Start Ollama with a default model (you can change this)
CMD ["ollama", "serve"]
