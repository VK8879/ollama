#!/bin/bash

echo "🧠 vk_entrypoint.sh started..."

# Clean up any previously half-downloaded models to avoid volume bloat
echo "🧹 Cleaning up old models (if any)..."
rm -rf /root/.ollama/models/*

# Start the Ollama server in the background
ollama serve &
sleep 5  # wait briefly for server to initialize

# Pull all required models
echo "⬇️ Pulling models..."
ollama pull llama3
ollama pull phi3
ollama pull codellama
ollama pull dolphin-mixtral
ollama pull gemma
ollama pull orca-mini
ollama pull qwen
ollama pull mistral
ollama pull openhermes
ollama pull stablelm-zephyr
ollama pull tinyllama

echo "✅ Model pulling complete. Ollama will now stay active."

# Bring Ollama server to foreground to keep container alive
fg
