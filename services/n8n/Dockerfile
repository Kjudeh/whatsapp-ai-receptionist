# n8n — pinned by tag AND digest. Bumped only via reviewed PRs from the
# weekly upstream-check workflow. Build context is the repo root
# (RAILWAY_DOCKERFILE_PATH=services/n8n/Dockerfile).
FROM n8nio/n8n:2.42.3@sha256:240eaa2a3d491adac5817aa4c3f1c521bb18ec79f6e448517158d5220ee0f37b

USER root
COPY workflows/ /preloaded-workflows/
COPY services/n8n/entrypoint.sh /entrypoint-receptionist.sh
RUN chmod 755 /entrypoint-receptionist.sh && chown -R node:node /preloaded-workflows
USER node

EXPOSE 5678
ENTRYPOINT ["tini", "--", "/entrypoint-receptionist.sh"]
