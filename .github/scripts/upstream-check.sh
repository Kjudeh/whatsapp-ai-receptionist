#!/usr/bin/env bash
# Bumps pinned image tags+digests in the service Dockerfiles.
# Evolution API is capped at the v2.3.x line: v2.4.0+ requires Evolution
# Foundation license activation and must never be picked up automatically.
set -euo pipefail

hub="https://hub.docker.com/v2/repositories"

latest_tag() { # $1=repo $2=tag-regex
  curl -fsSL "$hub/$1/tags?page_size=100" \
    | jq -r '.results[].name' \
    | grep -E "$2" \
    | sort -V | tail -1
}

digest_for() { # $1=repo $2=tag
  curl -fsSL "$hub/$1/tags/$2" | jq -r '.digest'
}

n8n_tag=$(latest_tag "n8nio/n8n" '^[0-9]+\.[0-9]+\.[0-9]+$')
n8n_digest=$(digest_for "n8nio/n8n" "$n8n_tag")
sed -i -E "s|^FROM n8nio/n8n:.*|FROM n8nio/n8n:${n8n_tag}@${n8n_digest}|" services/n8n/Dockerfile

evo_tag=$(latest_tag "evoapicloud/evolution-api" '^v2\.3\.[0-9]+$')
evo_digest=$(digest_for "evoapicloud/evolution-api" "$evo_tag")
sed -i -E "s|^FROM evoapicloud/evolution-api:.*|FROM evoapicloud/evolution-api:${evo_tag}@${evo_digest}|" services/evolution/Dockerfile

echo "n8n: ${n8n_tag}@${n8n_digest}"
echo "evolution (2.3.x ceiling): ${evo_tag}@${evo_digest}"
