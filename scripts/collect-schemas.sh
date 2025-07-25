#!/bin/bash

set -euo pipefail

echo "Collecting OpenAPI schema files..."

schemas=()

for file in *-server.*; do
  if [ -f "$file" ]; then
    basename=$(basename "$file" | sed 's/-server\..*//')

    schemas+=("$basename")

    echo "Found schema: $basename (from $file)"
  fi
done

if [ -n "${GITHUB_OUTPUT:-}" ]; then
  echo "schemas=[$(printf '"%s",' "${schemas[@]}" | sed 's/,$//')]" >> "$GITHUB_OUTPUT"
fi

cat > schemas.json << EOF
{
  "schemas": [$(printf '"%s",' "${schemas[@]}" | sed 's/,$//')],
  "count": ${#schemas[@]}
}
EOF

echo "Schema collection completed. Found ${#schemas[@]} schemas."
echo "Matrix output: [$(printf '"%s",' "${schemas[@]}" | sed 's/,$//')]"
