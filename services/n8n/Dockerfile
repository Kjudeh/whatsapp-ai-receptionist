# n8n — pinned by tag AND digest. Bumped only via reviewed PRs from the
# weekly upstream-check workflow. Build context is the repo root
# (RAILWAY_DOCKERFILE_PATH=services/n8n/Dockerfile).
FROM n8nio/n8n:2.49.5@sha256:c349b24d6e242b4ea14d75e6f1a90c50e348cf4b1c4512b4a0a50219ead6533d

USER root
COPY workflows/ /preloaded-workflows/
COPY services/n8n/entrypoint.sh /entrypoint-receptionist.sh
RUN chmod 755 /entrypoint-receptionist.sh && chown -R node:node /preloaded-workflows
USER node

EXPOSE 5678
ENTRYPOINT ["tini", "--", "/entrypoint-receptionist.sh"]
