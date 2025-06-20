FROM ollama/ollama:latest

WORKDIR /app

COPY vk_entrypoint.sh /app/vk_entrypoint.sh
RUN chmod +x /app/vk_entrypoint.sh

# Security & telemetry disabled via shared vars (SV_* or SEC_*)
ENV OLLAMA_HOST=0.0.0.0 \
    SEC_OLLAMA_ENABLE_TELEMETRY=false \
    SEC_LANGFLOW_ENABLE_TELEMETRY=false

ENTRYPOINT ["/app/vk_entrypoint.sh"]
