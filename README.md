# ia-config

##  Setup rápido

Cole o comando abaixo na **raiz do repositório** para baixar as rules, salvá-las em `.cursor/rules/` e configurar o `root-path` automaticamente com o nome do diretório atual:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/fracto-dev/ia-config/main/install.sh) "$(basename "$PWD")"
```

> Esse comando:
> 1. Baixa os arquivos `.mdc` do repositório `fracto-dev/ia-config`
> 2. Salva em `.cursor/rules/`
> 3. Substitui `root-path` pelo nome da pasta atual em todos os arquivos

---

## 🔧 Configuração manual (após o setup)

Se precisar trocar o `root-path` depois, edite `.cursor/rules/_config.mdc` ou execute o script local:

```bash
cd .cursor && bash setup-rules.sh root-path <novo-root>
```
