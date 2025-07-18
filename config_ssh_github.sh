#!/bin/bash

# Verifica se foi passado o nome da chave
if [ -z "$1" ]; then
  echo "Uso: ./config_ssh_github.sh NOME_DA_CHAVE"
  echo "Exemplo: ./config_ssh_github.sh github_ecdsa_key"
  exit 1
fi

KEY_NAME="$1"
KEY_PATH="$HOME/.ssh/$KEY_NAME"

# Verifica se o arquivo existe
if [ ! -f "$KEY_PATH" ]; then
  echo "Erro: chave '$KEY_PATH' não encontrada."
  exit 2
fi

# Inicia o agente ssh
eval "$(ssh-agent -s)"

# Adiciona a chave
ssh-add "$KEY_PATH"

# Cria/atualiza ~/.ssh/config
SSH_CONFIG="$HOME/.ssh/config"

# Garante que o arquivo existe
touch "$SSH_CONFIG"
chmod 600 "$SSH_CONFIG"

# Remove qualquer configuração anterior do github.com
sed -i '/^Host github.com$/,/^$/d' "$SSH_CONFIG"

# Adiciona nova configuração
cat <<EOL >> "$SSH_CONFIG"

Host github.com
  HostName github.com
  User git
  IdentityFile $KEY_PATH
  IdentitiesOnly yes
EOL

echo "[OK] Configuração SSH atualizada para '$KEY_PATH'."

# Testa conexão
echo "[TESTE] Testando conexão com GitHub..."
ssh -T git@github.com