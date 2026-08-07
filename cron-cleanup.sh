#!/bin/bash
# drop this into /etc/cron.daily/
# by default keeps 30 days

DB_PATH="/var/cache/ansible_logs/logs.db"
TABLE_NAME="task_logs"
DATE_COLUMN="timestamp"

# Verify the database file exists
if [ ! -f "$DB_PATH" ]; then
    echo "Error: Database file not found at $DB_PATH"
    exit 1
fi

# Execute the deletion query
# The SQLite datetime() function correctly parses the CURRENT_TIMESTAMP format
sqlite3 "$DB_PATH" "DELETE FROM $TABLE_NAME WHERE $DATE_COLUMN <= datetime('now', '-30 days');"

# Reclaim allocated but unused disk space
sqlite3 "$DB_PATH" "VACUUM;"

echo "Database cleanup completed."
