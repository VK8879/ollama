#!/bin/bash

# Start Ollama server in the background
ollama serve &

# Wait until the Ollama server is up
echo "Waiting for Ollama to start..."
until curl -s http://localhost:11434 > /dev/null; do
  sleep 1
done

echo "Ollama started. Pulling models..."

# Pull top models
ollama pull dbrx
ollama pull mixtral
ollama pull llama3:70b
ollama pull deepseek-coder
ollama pull openchat
ollama pull notus
ollama pull yi
ollama pull zephyr
ollama pull falcon
ollama pull phi3
ollama pull orca-mini

# Keep process alive
wait -n
