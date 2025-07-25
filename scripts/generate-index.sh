#!/bin/bash

set -euo pipefail

DOCS_DIR="${1:-docs}"
TEMPLATE_FILE="${2:-templates/index.html}"
OUTPUT_FILE="${DOCS_DIR}/index.html"

if [ ! -f "$TEMPLATE_FILE" ]; then
  echo "Error: Template file '$TEMPLATE_FILE' not found"
  exit 1
fi

mkdir -p "$DOCS_DIR"

echo "Generating index.html from template using commit dates..."

api_links=""
for html_file in "${DOCS_DIR}"/*.html; do
  if [ -f "$html_file" ] && [ "$(basename "$html_file")" != "index.html" ]; then
    schema_name=$(basename "$html_file" .html)
    display_name="${schema_name^}"

    commit_date_var="COMMIT_DATE_${schema_name^^}"
    commit_date="${!commit_date_var:-}"

    if [ -n "$commit_date" ]; then
      last_updated_display="最終更新：${commit_date}"
    else
      last_updated_display="最終更新：不明"
    fi

    api_links+="            <li>"$'\n'
    api_links+="                <a href=\"${schema_name}.html\" class=\"api-link\">"$'\n'
    api_links+="                    <div class=\"api-item\">"$'\n'
    api_links+="                        ${display_name} Server API"$'\n'
    api_links+="                        <p class=\"api-last-updated\">${last_updated_display}</p>"$'\n'
    api_links+="                    </div>"$'\n'
    api_links+="                </a>"$'\n'
    api_links+="            </li>"$'\n'

    echo "  Added: ${display_name} Server API (${last_updated_display})"
  fi
done

cat "$TEMPLATE_FILE" | awk -v replacement="$api_links" '{gsub(/<!--{{API_LINKS}}-->/, replacement); print}' > "$OUTPUT_FILE"

echo "Generated $OUTPUT_FILE successfully"
