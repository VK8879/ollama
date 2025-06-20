#!/bin/bash

echo "🧠 vk_entrypoint.sh started..."

# Start Ollama server in background
ollama serve &
sleep 5

# Pull only core MVP models for SWARM
ollama pull llama3
ollama pull phi3
ollama pull mistral
ollama pull gemma
ollama pull codellama

echo "✅ Model pulling complete. Ollama will now stay active."

# Keep container alive
fg
