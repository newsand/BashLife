#!/bin/bash

# Script para instalar UV (gerenciador de pacotes Python) e configurar Python 3.12.3
# Autor: Assistente AI
# Data: $(date)

set -e  # Exit on any error

echo "🐍 Instalando UV - Gerenciador de Pacotes Python"
echo "================================================"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar se o sistema é Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    print_error "Este script é específico para Linux. Sistema detectado: $OSTYPE"
    exit 1
fi

print_status "Verificando dependências..."

# Verificar se curl está instalado
if ! command -v curl &> /dev/null; then
    print_warning "curl não encontrado. Instalando..."
    sudo apt-get update && sudo apt-get install -y curl
fi

# Verificar se wget está instalado (backup para curl)
if ! command -v wget &> /dev/null; then
    print_warning "wget não encontrado. Instalando..."
    sudo apt-get update && sudo apt-get install -y wget
fi

print_status "Baixando e instalando UV..."

# Instalar UV usando o método oficial
if command -v curl &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
elif command -v wget &> /dev/null; then
    wget -qO- https://astral.sh/uv/install.sh | sh
else
    print_error "Nem curl nem wget estão disponíveis. Instale um deles primeiro."
    exit 1
fi

# Adicionar UV ao PATH se não estiver
if ! command -v uv &> /dev/null; then
    print_status "Adicionando UV ao PATH..."
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.local/bin:$PATH"
    
    # Verificar novamente
    if ! command -v uv &> /dev/null; then
        print_error "UV não foi instalado corretamente."
        exit 1
    fi
fi

print_success "UV instalado com sucesso!"

# Verificar versão do UV
print_status "Verificando versão do UV..."
uv --version

print_status "Instalando Python 3.12.3 com UV..."

# Instalar Python 3.12.3 usando UV
uv python install 3.12.3

# Definir Python 3.12.3 como padrão
print_status "Configurando Python 3.12.3 como padrão..."
uv python pin 3.12.3

print_success "Python 3.12.3 instalado e configurado como padrão!"

# Verificar instalação
print_status "Verificando instalação do Python..."
uv python list

print_status "Verificando versão do Python padrão..."
uv run python --version

print_success "Instalação do UV e Python 3.12.3 concluída com sucesso!"

# Criar projeto de teste
print_status "Criando projeto de teste Ptest..."

# Remover diretório se existir
if [ -d "Ptest" ]; then
    print_warning "Diretório Ptest já existe. Removendo..."
    rm -rf Ptest
fi

# Criar diretório do projeto
mkdir Ptest
cd Ptest

print_status "Inicializando projeto Python com UV..."
uv init --python 3.12.3

print_status "Criando arquivo de teste simples..."
cat > test_uv.py << 'EOF'
#!/usr/bin/env python3
"""
Script de teste para verificar se UV está funcionando corretamente
"""

import sys
import platform
from datetime import datetime

def main():
    print("🐍 Teste do UV - Gerenciador de Pacotes Python")
    print("=" * 50)u
    
    print(f"Versão do Python: {sys.version}")
    print(f"Plataforma: {platform.platform()}")
    print(f"Data/Hora: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    # Teste de importação de bibliotecas
    try:
        import requests
        print("✅ Biblioteca 'requests' disponível")
    except ImportError:
        print("❌ Biblioteca 'requests' não encontrada")
    
    try:
        import numpy
        print("✅ Biblioteca 'numpy' disponível")
    except ImportError:
        print("❌ Biblioteca 'numpy' não encontrada")
    
    print("\n🎉 Teste concluído! UV está funcionando corretamente.")

if __name__ == "__main__":
    main()
EOF

print_status "Adicionando algumas dependências de teste..."
uv add requests numpy

print_status "Executando teste..."
uv run python test_uv.py

print_success "Projeto de teste Ptest criado e executado com sucesso!"
print_status "Para usar o projeto Ptest:"
print_status "  cd Ptest"
print_status "  uv run python test_uv.py"
print_status "  uv add <package_name>  # para adicionar novas dependências"

print_success "🎉 Instalação e configuração do UV concluída com sucesso!"
print_status "UV está pronto para uso com Python 3.12.3!"
