#!/bin/bash

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

# Start Ollama server
exec ollama serve
