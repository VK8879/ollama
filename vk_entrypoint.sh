#!/bin/bash

echo "🧠 vk_entrypoint.sh started..."

# Start the Ollama server in the background
ollama serve &
sleep 5  # give the server time to boot

# Pull only essential models for Swarm MVP
ollama pull dolphin-mixtral    # 🧠 Master Agent
ollama pull mistral            # ⚙️  n8n logic / automations
ollama pull openhermes         # 💬 Natural UI (OpenWebUI)
ollama pull phi3               # 📱 WhatsApp quick chat + tasks
ollama pull llama3             # 🧠 Embedding + memory logic

echo "✅ Model pulling complete. Ollama will now stay active."

# Keep container alive
fg
