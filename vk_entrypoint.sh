#!/bin/bash

echo "🚀 Starting Ollama server in background..."
ollama serve &

# Wait until Ollama is ready by checking if list command works
echo "⏳ Waiting for Ollama to become ready..."
until ollama list > /dev/null 2>&1; do
  sleep 1
done

echo "✅ Ollama is ready."

# Pull mistral only if not already present
if ! ollama list | grep -q mistral; then
  echo "⬇️  Pulling 'mistral' model..."
  ollama pull mistral
else
  echo "✅ 'mistral' model already exists."
fi

# Keep Ollama server in foreground
fg %1
