#!/bin/bash

echo "🧠 vk_entrypoint.sh started..."

# Start the Ollama server in the background
ollama serve &
sleep 5  # give the server time to boot

# Pull all models (these now succeed because server is up)
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

# Bring Ollama server back to foreground so container stays alive
fg
