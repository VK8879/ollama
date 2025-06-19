#!/bin/bash

echo "🚀 Starting model download sequence..."

# Define your models
models=(
  "llama3"
  "llava:latest"
  "llama3:instruct"
  "gemma"
  "mistral"
  "mistral:instruct"
  "codellama"
  "codellama:instruct"
  "phi"
  "phi:instruct"
  "tinyllama"
)

# Pull each model using Ollama
for model in "${models[@]}"; do
  echo "⬇️ Pulling model: $model"
  ollama pull "$model"
done

echo "✅ All models pulled successfully. Launching Ollama..."

# Start the Ollama server
exec ollama serve
