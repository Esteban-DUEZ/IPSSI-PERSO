#!/bin/bash
# backup-db.sh
# Sauvegarde manuelle de la base PostgreSQL

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="/backup"
DB_NAME="${POSTGRES_DB:-todo}"
DB_USER="${POSTGRES_USER:-todo_user}"
DB_HOST="${POSTGRES_HOST:-db}"
DB_PASSWORD="${POSTGRES_PASSWORD:-ChangeMe123!}"

mkdir -p "$BACKUP_DIR"
export PGPASSWORD="$DB_PASSWORD"
pg_dump -h "$DB_HOST" -U "$DB_USER" "$DB_NAME" > "$BACKUP_DIR/db-backup-$DATE.sql"
echo "Backup terminé : $BACKUP_DIR/db-backup-$DATE.sql"
