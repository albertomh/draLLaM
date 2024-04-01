# Container for an ollama-powered embeddings service.
#
# (c) 2024 Alberto Morón Hernández

FROM ollama/ollama:0.1.30

# NB. COPY is relative to build context (project directory). Meaning ollama-specific files
# must be temporarily copied to the build context before the container image can be built.
# Take this step on the local filesystem, separate from this Dockerfile.
COPY .ollama/models/ /root/.ollama/models/

ENV OLLAMA_HOST=0.0.0.0
EXPOSE 11434

WORKDIR /bin/

ENTRYPOINT ["ollama"]
CMD ["serve"]
