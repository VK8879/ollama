#!/bin/bash

echo "[ollama] 🧠 Booting with Preload Script..."

# List of models to preload
models=("llama3" "mistral" "gemma" "phi")

# Preload each model
for model in "${models[@]}"
do
  echo "[ollama] 📦 Preloading model: $model"
  curl -s -X POST http://localhost:11434/api/pull -d "{\"name\": \"$model\"}" || echo "[ollama] ⚠️ Failed to preload $model"
done

# Start Ollama server
echo "[ollama] ✅ Starting Ollama server..."
exec ollama serve
