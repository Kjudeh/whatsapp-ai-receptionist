# n8n — pinned by tag AND digest. Bumped only via reviewed PRs from the
# weekly upstream-check workflow. Build context is the repo root
# (RAILWAY_DOCKERFILE_PATH=services/n8n/Dockerfile).
FROM n8nio/n8n:2.38.4@sha256:5d9f0cc5672b83d438c465f718077af463828c15563a480ef5c7c5fdfa2eae9c

USER root
COPY workflows/ /preloaded-workflows/
COPY services/n8n/entrypoint.sh /entrypoint-receptionist.sh
RUN chmod 755 /entrypoint-receptionist.sh && chown -R node:node /preloaded-workflows
USER node

EXPOSE 5678
ENTRYPOINT ["tini", "--", "/entrypoint-receptionist.sh"]
