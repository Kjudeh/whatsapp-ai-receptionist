# n8n — pinned by tag AND digest. Bumped only via reviewed PRs from the
# weekly upstream-check workflow. Build context is the repo root
# (RAILWAY_DOCKERFILE_PATH=services/n8n/Dockerfile).
FROM n8nio/n8n:2.45.4@sha256:80e23ced901f0e22597d4f3464e3aaf9d835372262ea6f08ef760d8ca35df25c

USER root
COPY workflows/ /preloaded-workflows/
COPY services/n8n/entrypoint.sh /entrypoint-receptionist.sh
RUN chmod 755 /entrypoint-receptionist.sh && chown -R node:node /preloaded-workflows
USER node

EXPOSE 5678
ENTRYPOINT ["tini", "--", "/entrypoint-receptionist.sh"]
