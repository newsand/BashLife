#!/bin/bash

# Atualiza os pacotes do sistema
echo "🔄 Atualizando pacotes..."
sudo apt update && sudo apt upgrade -y

# Instala dependências do Yarn
echo "🛠 Instalando dependências..."
sudo apt install curl -y

# Adiciona o repositório oficial do Yarn
echo "📦 Adicionando repositório do Yarn..."
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Atualiza os pacotes novamente
echo "🔄 Atualizando lista de pacotes..."
sudo apt update

# Instala o Yarn 1.22.19
echo "🚀 Instalando Yarn 1.22.19..."
sudo apt install --no-install-recommends yarn=1.22.19-1 -y

# Verifica a instalação
echo "✅ Verificando instalação..."
yarn -v

echo "🎉 Tudo pronto! Yarn 1.22.19 instalado com sucesso!"
