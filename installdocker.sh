#!/bin/bash

# Script para instalação limpa do Docker versão 28.1.1 e Docker Compose no Ubuntu
# Destinado a um droplet da DigitalOcean

# Exit em caso de erro
set -e

echo "Iniciando a instalação limpa do Docker versão 28.1.1 e Docker Compose..."

# 1. Remover qualquer instalação anterior do Docker
echo "Removendo instalações anteriores do Docker, se existirem..."
sudo apt-get remove -y docker docker-engine docker.io containerd runc docker-compose || true
sudo apt-get purge -y docker docker-engine docker.io containerd runc docker-compose || true
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
sudo rm -rf /usr/local/bin/docker-compose

# 2. Atualizar pacotes e instalar dependências
echo "Atualizando pacotes e instalando dependências..."
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# 3. Adicionar chave GPG do repositório oficial do Docker
echo "Adicionando chave GPG do Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 4. Configurar repositório do Docker
echo "Configurando repositório do Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. Atualizar pacotes novamente
sudo apt-get update

# 6. Instalar a versão específica do Docker (28.1.1)
echo "Instalando Docker versão 28.1.1..."
sudo apt-get install -y docker-ce=5:28.1.1-1~ubuntu.$(lsb_release -rs)~$(lsb_release -cs) \
    docker-ce-cli=5:28.1.1-1~ubuntu.$(lsb_release -rs)~$(lsb_release -cs) \
    containerd.io \
    docker-compose-plugin

# 7. Verificar a versão do Docker instalada
echo "Verificando a versão do Docker instalada..."
docker --version

# 8. Verificar a versão do Docker Compose instalada
echo "Verificando a versão do Docker Compose instalada..."
docker compose version

# 9. Adicionar o usuário atual ao grupo docker (para rodar comandos sem sudo)
echo "Adicionando usuário ao grupo docker..."
sudo usermod -aG docker $USER

# 10. Habilitar e iniciar o serviço Docker
echo "Habilitando e iniciando o serviço Docker..."
sudo systemctl enable docker
sudo systemctl start docker

# 11. Testar a instalação do Docker com uma imagem de teste
echo "Testando a instalação do Docker com a imagem hello-world..."
sudo docker run --rm hello-world

# 12. Testar o Docker Compose com um comando simples
echo "Testando o Docker Compose..."
docker compose version

echo "Instalação do Docker versão 28.1.1 e Docker Compose concluída com sucesso!"
echo "Por favor, faça logout e login novamente para usar o Docker e Docker Compose sem sudo."