# n8n — pinned by tag AND digest. Bumped only via reviewed PRs from the
# weekly upstream-check workflow. Build context is the repo root
# (RAILWAY_DOCKERFILE_PATH=services/n8n/Dockerfile).
FROM n8nio/n8n:1.123.97@sha256:563158a8b03e0dd7cd5f7ab256d00da533b543f8c219cdb4a7da7d0df13f99fc

USER root
COPY workflows/ /preloaded-workflows/
COPY services/n8n/entrypoint.sh /entrypoint-receptionist.sh
RUN chmod 755 /entrypoint-receptionist.sh && chown -R node:node /preloaded-workflows
USER node

EXPOSE 5678
ENTRYPOINT ["tini", "--", "/entrypoint-receptionist.sh"]
