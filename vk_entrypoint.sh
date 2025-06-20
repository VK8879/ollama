#!/bin/bash

echo "🚀 Starting Ollama server in background..."
ollama serve &

# Wait until Ollama API is responsive
echo "⏳ Waiting for Ollama to become ready..."
until curl -s http://localhost:11434/api/tags > /dev/null; do
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

# Keep Ollama running in foreground
fg %1
