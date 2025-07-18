#!/bin/bash

# CONFIG
GO_VERSION="1.22.4"
GO_TAR="go${GO_VERSION}.linux-amd64.tar.gz"
GO_URL="https://go.dev/dl/${GO_TAR}"
INSTALL_DIR="/usr/local"
PROFILE_FILE="$HOME/.bashrc"

# BAIXAR
echo "📥 Baixando Go $GO_VERSION..."
wget -q --show-progress "$GO_URL" -O "/tmp/$GO_TAR"

# REMOVER GO ANTIGO
echo "🧹 Removendo instalação anterior de Go em $INSTALL_DIR/go..."
sudo rm -rf "$INSTALL_DIR/go"

# INSTALAR
echo "📦 Instalando Go em $INSTALL_DIR..."
sudo tar -C "$INSTALL_DIR" -xzf "/tmp/$GO_TAR"

# CONFIGURAR PATH
if ! grep -q "/usr/local/go/bin" "$PROFILE_FILE"; then
  echo 'export PATH=$PATH:/usr/local/go/bin' >> "$PROFILE_FILE"
  echo "🔧 Adicionado Go ao PATH no $PROFILE_FILE"
fi

# APLICAR
echo "🔄 Recarregando PATH..."
source "$PROFILE_FILE"

# VERIFICAR
echo -e "\n✅ Go instalado com sucesso:"
go version
