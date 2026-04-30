#!/usr/bin/env bash
# ============================================================
# install.sh — baixa as cursor rules e AGENTS.md, e cria
#              symlinks para compatibilidade com múltiplas IAs
# ============================================================
# Uso: bash <(curl -fsSL https://raw.githubusercontent.com/BillRizer/ia-config/main/install.sh) "<root-path>"
# Sem argumento: usa o nome do diretório atual.
# ============================================================

set -euo pipefail

BASE_URL="https://raw.githubusercontent.com/BillRizer/ia-config/main"
RULES_DEST=".cursor/rules"
ROOT="${1:-$(basename "$PWD")}"
PLACEHOLDER="root-path"

MDC_FILES=(
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

# ── 1. Cursor rules (.mdc) ───────────────────────────────────
echo "📥 Baixando cursor rules → $RULES_DEST"
mkdir -p "$RULES_DEST"

for file in "${MDC_FILES[@]}"; do
  curl -fsSL "$BASE_URL/rules/$file" -o "$RULES_DEST/$file"
  echo "  ✔ $file"
done

echo ""
echo "🔧 Substituindo '$PLACEHOLDER' → '$ROOT' ..."

if sed --version 2>/dev/null | grep -q GNU; then
  find "$RULES_DEST" -name "*.mdc" -exec sed -i "s|${PLACEHOLDER}|${ROOT}|g" {} \;
else
  find "$RULES_DEST" -name "*.mdc" -exec sed -i '' "s|${PLACEHOLDER}|${ROOT}|g" {} \;
fi

echo "✅ Cursor rules instaladas em $RULES_DEST"

# ── 2. AGENTS.md (fonte canônica universal) ──────────────────
echo ""
echo "📥 Baixando AGENTS.md ..."
curl -fsSL "$BASE_URL/AGENTS.md" -o "AGENTS.md"

if sed --version 2>/dev/null | grep -q GNU; then
  sed -i "s|${PLACEHOLDER}|${ROOT}|g" AGENTS.md
else
  sed -i '' "s|${PLACEHOLDER}|${ROOT}|g" AGENTS.md
fi

echo "  ✔ AGENTS.md  (fonte canônica)"

# ── 3. Symlinks para outras ferramentas ─────────────────────
echo ""
echo "🔗 Criando symlinks a partir de AGENTS.md ..."

_symlink() {
  local target="$1"
  local dir
  dir="$(dirname "$target")"
  [[ "$dir" != "." ]] && mkdir -p "$dir"

  if [[ -L "$target" ]]; then
    echo "  ↩ $target já existe (symlink) — ignorado"
  elif [[ -f "$target" ]]; then
    echo "  ⚠  $target já existe (arquivo real) — ignorado"
  else
    ln -s "$(pwd)/AGENTS.md" "$target"
    echo "  ✔ $target → AGENTS.md"
  fi
}

_symlink "GEMINI.md"                           # Gemini CLI / Antigravity
_symlink ".github/copilot-instructions.md"    # GitHub Copilot

# CLAUDE.md → arquivo próprio com @import nativo do Claude Code
CLAUDE_FILE="CLAUDE.md"
if [[ -L "$CLAUDE_FILE" || -f "$CLAUDE_FILE" ]]; then
  echo "  ↩ $CLAUDE_FILE já existe — ignorado"
else
  curl -fsSL "$BASE_URL/CLAUDE.md" -o "$CLAUDE_FILE"
  if sed --version 2>/dev/null | grep -q GNU; then
    sed -i "s|${PLACEHOLDER}|${ROOT}|g" "$CLAUDE_FILE"
  else
    sed -i '' "s|${PLACEHOLDER}|${ROOT}|g" "$CLAUDE_FILE"
  fi
  echo "  ✔ $CLAUDE_FILE  (@ import nativo Claude Code)"
fi

# ── 4. .gitignore ────────────────────────────────────────────
echo ""
GITIGNORE=".gitignore"

_add_ignore() {
  local entry="$1"
  if [[ -f "$GITIGNORE" ]]; then
    if grep -qxF "$entry" "$GITIGNORE"; then
      echo "  ℹ️  '$entry' já está no $GITIGNORE"
    else
      printf "\n%s\n" "$entry" >> "$GITIGNORE"
      echo "  📝 '$entry' adicionado ao $GITIGNORE"
    fi
  else
    printf "%s\n" "$entry" >> "$GITIGNORE"
    echo "  📝 $GITIGNORE criado com '$entry'"
  fi
}

echo "📝 Atualizando $GITIGNORE ..."
printf "\n# Cursor AI rules + IA context files (geradas pelo install.sh)\n" >> "$GITIGNORE"
_add_ignore ".cursor/"
_add_ignore "AGENTS.md"
_add_ignore "CLAUDE.md"
_add_ignore "GEMINI.md"
_add_ignore ".github/copilot-instructions.md"

echo ""
echo "🎉 Setup concluído! APP_ROOT = '$ROOT'"
echo ""
echo "   Cursor       → $RULES_DEST/*.mdc"
echo "   Codex        → AGENTS.md  (canônico)"
echo "   Claude Code  → CLAUDE.md  → AGENTS.md"
echo "   Gemini/Anti  → GEMINI.md  → AGENTS.md"
echo "   Copilot      → .github/copilot-instructions.md → AGENTS.md"
