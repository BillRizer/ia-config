#!/usr/bin/env bash
# ============================================================
# setup-rules.sh — atualiza APP_ROOT em todas as rules
# ============================================================
# Uso: ./setup-rules.sh <root-atual> <novo-root>
# Exemplo: ./setup-rules.sh app-ts meu-projeto
#
# Executar a partir da raiz do monorepo.
# ============================================================

set -euo pipefail

OLD="${1:-}"
NEW="${2:-}"
RULES_DIR="./rules"

if [[ -z "$OLD" || -z "$NEW" ]]; then
  echo "❌ Uso: $0 <root-atual> <novo-root>"
  echo "   Exemplo: $0 app-ts meu-projeto"
  exit 1
fi

if [[ ! -d "$RULES_DIR" ]]; then
  echo "❌ Diretório $RULES_DIR não encontrado. Execute a partir da raiz do monorepo."
  exit 1
fi

echo "🔄 Substituindo '$OLD/' → '$NEW/' em $RULES_DIR/**/*.mdc ..."

# Compatível com macOS (BSD sed) e Linux (GNU sed)
if sed --version 2>/dev/null | grep -q GNU; then
  find "$RULES_DIR" -name "*.mdc" -exec sed -i "s|${OLD}/|${NEW}/|g" {} \;
else
  # macOS
  find "$RULES_DIR" -name "*.mdc" -exec sed -i '' "s|${OLD}/|${NEW}/|g" {} \;
fi

# Atualiza também o comentário no _config.mdc
if [[ -f "$RULES_DIR/_config.mdc" ]]; then
  if sed --version 2>/dev/null | grep -q GNU; then
    sed -i "s|APP_ROOT = \`${OLD}\`|APP_ROOT = \`${NEW}\`|g" "$RULES_DIR/_config.mdc"
  else
    sed -i '' "s|APP_ROOT = \`${OLD}\`|APP_ROOT = \`${NEW}\`|g" "$RULES_DIR/_config.mdc"
  fi
fi

echo "✅ Concluído! APP_ROOT: '$OLD' → '$NEW'"
echo ""
echo "Arquivos atualizados:"
grep -rl "${NEW}/" "$RULES_DIR" --include="*.mdc" | sort | sed 's/^/  /'
