#!/bin/bash

# Atualiza pacotes
sudo apt update

# Instala dependências
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Adiciona chave oficial Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Adiciona repositório Docker no APT
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualiza e instala docker-ce, docker-ce-cli e containerd
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Adiciona seu usuário ao grupo docker
sudo usermod -aG docker $USER

# Ativa e inicia o serviço docker
sudo systemctl enable docker
sudo systemctl start docker

echo "✅ Docker e Docker Compose instalados com sucesso!"
echo "⚠️ Lembre-se de fazer logout/login para que a permissão de usuário no grupo docker tenha efeito."
