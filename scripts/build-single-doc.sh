#!/bin/bash

set -euo pipefail

SCHEMA_NAME="${1:-}"
OUTPUT_DIR="${2:-docs}"

if [ -z "$SCHEMA_NAME" ]; then
  echo "Error: Schema name is required"
  echo "Usage: $0 <schema_name> [output_dir]"
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
  echo "Error: Source file for schema '$SCHEMA_NAME' not found"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

OUTPUT_FILE="${OUTPUT_DIR}/${SCHEMA_NAME}.html"

echo "Building documentation for $SOURCE_FILE -> $OUTPUT_FILE"

redocly build-docs "$SOURCE_FILE" --output "$OUTPUT_FILE"

echo "Documentation build completed for $SCHEMA_NAME"
