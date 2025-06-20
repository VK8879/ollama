#!/bin/bash

echo "🧠 Pulling models into Ollama..."

# Pull all models you want preinstalled
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

echo "✅ Model pulling complete. Starting Ollama server..."

# Start Ollama server
exec ollama serve
