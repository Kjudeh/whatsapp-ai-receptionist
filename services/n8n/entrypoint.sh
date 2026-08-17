#!/bin/sh
# Imports the preloaded receptionist workflow before starting n8n.
# Retries because Postgres may still be booting on a fresh template deploy.
# Import is idempotent: the workflow has a fixed ID, so re-imports overwrite
# rather than duplicate (a deployer's edits made in the n8n UI under the same
# workflow ID are overwritten on redeploy — documented in the README; save
# customizations as a duplicate workflow).

i=0
until n8n import:workflow --separate --input=/preloaded-workflows >/tmp/import.log 2>&1; do
  i=$((i+1))
  if [ "$i" -ge 12 ]; then
    echo "[receptionist] workflow import failed after $i attempts — import manually from /preloaded-workflows"
    cat /tmp/import.log
    break
  fi
  echo "[receptionist] import attempt $i failed (database not ready yet?), retrying in 5s..."
  sleep 5
done
[ "$i" -lt 12 ] && echo "[receptionist] preloaded workflow imported"

exec /docker-entrypoint.sh
