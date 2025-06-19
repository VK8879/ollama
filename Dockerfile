# vk_custom_dockerfile
FROM golang:1.22 as build

WORKDIR /app

COPY . .

RUN make build

FROM debian:bookworm-slim as runtime

# Install required packages
RUN apt-get update && \
    apt-get install -y ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

# Copy the built binary
COPY --from=build /app/ollama /usr/bin/ollama

# Create models directory
RUN mkdir -p /root/.ollama

# Pre-pull top 5 models
RUN ollama serve & \
    sleep 5 && \
    ollama pull llama3 && \
    ollama pull phi3 && \
    ollama pull gemma && \
    ollama pull codellama && \
    ollama pull mistral && \
    pkill ollama

# Expose port
EXPOSE 11434

# Entry point
ENTRYPOINT ["/usr/bin/ollama"]
