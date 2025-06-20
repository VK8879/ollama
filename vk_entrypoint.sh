#!/bin/bash

echo "🔄 Checking for mistral model..."

# Pull mistral only if not already installed
if ! ollama list | grep -q mistral; then
  echo "⬇️  Pulling 'mistral' model..."
  ollama pull mistral
else
  echo "✅ 'mistral' already available."
fi

echo "🚀 Starting Ollama..."
exec ollama serve
