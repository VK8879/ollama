#!/bin/bash
ollama serve &

# Wait for Ollama API to come up
until curl -s http://localhost:11434 > /dev/null; do sleep 1; done

# Pull your models
for model in llama3 mixtral dbrx codellama openchat phoenix; do
  echo "Pulling $model..."
  ollama pull "$model"
done

# Keep the server running
wait -n
