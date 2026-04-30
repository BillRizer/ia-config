#!/usr/bin/env bash
# ============================================================
# install.sh — baixa as cursor rules e configura root-path
# ============================================================
# Uso: bash <(curl -fsSL https://raw.githubusercontent.com/BillRizer/ia-config/main/install.sh) "<root-path>"
# Sem argumento: usa o nome do diretório atual.
# ============================================================

set -euo pipefail

REPO_URL="https://raw.githubusercontent.com/BillRizer/ia-config/main/rules"
DEST=".cursor/rules"
ROOT="${1:-$(basename "$PWD")}"
PLACEHOLDER="root-path"

FILES=(
  "_config.mdc"
  "_index.mdc"
  "api-error-handling.mdc"
  "api-logging.mdc"
  "api-nestjs.mdc"
  "api-pagination.mdc"
  "api-webhooks.mdc"
  "naming.mdc"
  "performance.mdc"
  "security.mdc"
  "testing.mdc"
  "web-react.mdc"
  "worker-bullmq.mdc"
  "worker-email.mdc"
  "worker-rabbitmq.mdc"
)

echo "📥 Baixando cursor rules → $DEST"
mkdir -p "$DEST"

for file in "${FILES[@]}"; do
  curl -fsSL "$REPO_URL/$file" -o "$DEST/$file"
  echo "  ✔ $file"
done

echo ""
echo "🔧 Substituindo '$PLACEHOLDER' → '$ROOT' ..."

if sed --version 2>/dev/null | grep -q GNU; then
  find "$DEST" -name "*.mdc" -exec sed -i "s|${PLACEHOLDER}|${ROOT}|g" {} \;
else
  find "$DEST" -name "*.mdc" -exec sed -i '' "s|${PLACEHOLDER}|${ROOT}|g" {} \;
fi

echo "✅ Pronto! APP_ROOT = '$ROOT'"
echo ""
echo "Arquivos instalados em $DEST:"
ls "$DEST" | sed 's/^/  /'
