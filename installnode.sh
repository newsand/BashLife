#!/bin/bash

# Atualiza os pacotes do sistema
echo "🔄 Atualizando pacotes..."
sudo apt update && sudo apt upgrade -y

# Instala dependências do NVM
echo "🛠 Instalando dependências..."
sudo apt install curl -y

# Baixa e instala o NVM
echo "🚀 Instalando NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash

# Recarrega o shell
echo "🔄 Recarregando shell..."
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Instala o Node.js 22
echo "📦 Instalando Node.js 22..."
nvm install 22
nvm alias default 22
nvm use 22

# Verifica a instalação
echo "✅ Verificando instalação..."
node -v && npm -v

echo "🎉 Tudo pronto! Node.js 22 instalado com sucesso!"
