FROM ollama/ollama

COPY vk_entrypoint.sh /app/vk_entrypoint.sh
RUN chmod +x /app/vk_entrypoint.sh

ENTRYPOINT ["/app/vk_entrypoint.sh"]
