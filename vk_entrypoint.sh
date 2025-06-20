#!/bin/bash

echo "🚀 Starting Ollama server in background..."
ollama serve &

# Wait until Ollama API is responsive
echo "⏳ Waiting for Ollama to be ready..."
until curl -s http://localhost:11434/api/tags > /dev/null; do
  sleep 1
done

echo "✅ Ollama is ready."

# Pull mistral only if not already installed
if ! ollama list | grep -q mistral; then
  echo "⬇️  Pulling 'mistral' model..."
  ollama pull mistral
else
  echo "✅ 'mistral' model already exists."
fi

# Bring Ollama server back to foreground
fg %1
