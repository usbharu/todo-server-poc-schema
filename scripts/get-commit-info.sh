#!/bin/bash

set -euo pipefail

SCHEMA_NAME="${1:-}"

if [ -z "$SCHEMA_NAME" ]; then
  echo "Error: Schema name is required" >&2
  echo "Usage: $0 <schema_name>" >&2
  exit 1
fi

SOURCE_FILE=""
for file in "${SCHEMA_NAME}-server."*; do
  if [ -f "$file" ]; then
    SOURCE_FILE="$file"
    break
  fi
done

if [ -z "$SOURCE_FILE" ]; then
  echo "Error: Source file for schema '$SCHEMA_NAME' not found" >&2
  exit 1
fi

LAST_COMMIT_DATE=$(git log -1 --follow --format="%ci" -- "$SOURCE_FILE" | cut -d' ' -f1,2 | cut -d':' -f1,2)

echo "$LAST_COMMIT_DATE"
