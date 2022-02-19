#!/bin/sh

BACKUP_FILE="/docker-entrypoint-initdb.d/backup.dump"
if [ -f "$BACKUP_FILE" ]; then
  pg_restore --verbose --clean --no-acl --no-owner -U "$POSTGRES_USER" -d "$POSTGRES_DB" "$BACKUP_FILE"
fi
exit
