#!/bin/bash
set -e

# ── config ────────────────────────────────────────────────
NAMESPACE="wordpress-app"
BACKUP_DIR="/tmp/db-backups"
GDRIVE_REMOTE="gdrive:"
KEEP_DAYS=7
# ─────────────────────────────────────────────────────────

mkdir -p "$BACKUP_DIR"

# find the running mariadb pod
DB_POD=$(kubectl get pod -n "$NAMESPACE" -l app=db -o jsonpath='{.items[0].metadata.name}')

if [ -z "$DB_POD" ]; then
  echo "ERROR: no running db pod found in namespace $NAMESPACE"
  exit 1
fi

echo "Using pod: $DB_POD"

# read credentials directly from the pod's env
DB_USER=$(kubectl exec -n "$NAMESPACE" "$DB_POD" -- printenv MYSQL_USER)
DB_PASSWORD=$(kubectl exec -n "$NAMESPACE" "$DB_POD" -- printenv MYSQL_PASSWORD)
DB_NAME=$(kubectl exec -n "$NAMESPACE" "$DB_POD" -- printenv MYSQL_DATABASE)

BACKUP_FILE="$BACKUP_DIR/backup-$(date +%Y%m%d-%H%M%S).sql.gz"

echo "Dumping database '$DB_NAME'..."
kubectl exec -n "$NAMESPACE" "$DB_POD" -- \
  mysqldump -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" | gzip > "$BACKUP_FILE"

echo "Uploading to Google Drive..."
rclone copy "$BACKUP_FILE" "$GDRIVE_REMOTE"

echo "Cleaning up local file..."
rm -f "$BACKUP_FILE"

echo "Removing backups older than $KEEP_DAYS days from Google Drive..."
rclone delete "$GDRIVE_REMOTE" --min-age "${KEEP_DAYS}d" --include "backup-*.sql.gz"

echo "Done."