#!/bin/bash

echo "🧠 vk_entrypoint.sh started..."

# Start the Ollama server in the background
ollama serve &
sleep 5  # Give the server time to fully boot

# Full model list (14 total)
models=(
  llama3
  phi3
  codellama
  dolphin-mixtral
  gemma
  orca-mini
  qwen
  mistral
  openhermes
  stablelm-zephyr
  tinyllama
  llama2
  neural-chat
  openchat
)

echo "📦 Pulling Ollama models..."
for model in "${models[@]}"; do
  echo "→ Pulling $model"
  ollama pull "$model"
done

echo "✅ All models pulled successfully. Ollama will now stay active."

# Keep container alive
fg
