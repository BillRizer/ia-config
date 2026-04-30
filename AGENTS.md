# AGENTS.md

> Lido por agentes de IA que não usam `.cursor/rules/` nativamente (Codex, Gemini, Copilot…).
> O Cursor usa `.cursor/rules/*.mdc` diretamente — este arquivo é ignorado por ele.

## APP_ROOT

```
APP_ROOT = `root-path`
```

## Regras e convenções do projeto

O índice completo de regras está em:

```
.cursor/rules/_index.mdc
```

Leia esse arquivo para entender quais regras se aplicam a cada contexto (`apps/api/**`, `apps/web/**`, etc.) e carregue os `.mdc` relevantes de `.cursor/rules/` conforme necessário.

