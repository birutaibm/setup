#!/bin/bash
# Script para configuração automatizada do Ubuntu 24.04
# Criado em: 14/05/2025

set -e  # Encerra o script se algum comando falhar

echo "Iniciando configuração do Ubuntu 24.04..."
SCRIPT_DIR=$(pwd)

# Atualizar o sistema
echo "Atualizando o sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar dependências básicas
echo "Instalando dependências básicas..."
sudo apt install -y curl wget git build-essential unzip gpg apt-transport-https

# Instalar as fontes Nerd Fonts para suportar os ícones
echo "Instalando fontes Nerd Fonts para suportar os ícones..."
mkdir -p ~/.local/share/fonts
cd /tmp
# Baixar e instalar Fira Code Nerd Font (uma boa fonte para programação com ícones)
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
unzip -q FiraCode.zip -d ~/.local/share/fonts/FiraCode
# Atualizar cache de fontes
fc-cache -f

# Instalar Fish Shell
echo "Instalando Fish Shell..."
sudo apt-add-repository ppa:fish-shell/release-3 -y
sudo apt update
sudo apt install -y fish

# Definir Fish como shell padrão
echo "Configurando Fish como shell padrão..."
sudo chsh -s $(which fish) $USER

# Configurar o terminal para usar a fonte Nerd Font instalada
if [ -d ~/.config/gnome-terminal ]; then
    # Para Gnome Terminal (Ubuntu padrão)
    PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ font 'FiraCode Nerd Font 12'
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ use-system-font false
    echo "Terminal configurado para usar FiraCode Nerd Font"
fi

# Instalar ASDF
echo "Instalando ASDF..."
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.0
# Instalar plugin Node.js para ASDF
echo "Instalando plugin Node.js para ASDF..."
fish -c "source ~/.asdf/asdf.fish && asdf plugin add nodejs"
fish -c "source ~/.asdf/asdf.fish && asdf install nodejs latest"
fish -c "source ~/.asdf/asdf.fish && asdf global nodejs latest"

# Instalar Fisher (plugin manager para Fish)
echo "Instalando Fisher..."
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; fisher install jorgebucaran/fisher"
# Instalar Tide (tema para Fish)
echo "Instalando o tema Tide para Fish..."
fish -c "fisher install IlanCosman/tide@v5"

# Configurar Tide
mkdir -p ~/.config/fish
cat "$SCRIPT_DIR/fish/exported-tide-config.txt" "$SCRIPT_DIR/fish/asdf-config.txt" > ~/.config/fish/config.fish

# Instalar Docker
echo "Instalando Docker..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Configurar Docker para não precisar de sudo
echo "Configurando Docker para não precisar de sudo..."
sudo groupadd -f docker
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Instalar VS Code
echo "Instalando VS Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
sudo apt update
DEBIAN_FRONTEND=noninteractive sudo apt install -y code

# Configurar VS Code
echo "Configurando VS Code..."
mkdir -p ~/.config/Code/User/

# Copiar configurações do vscode
rsync -av --exclude 'extensions.txt' "$SCRIPT_DIR/vscode/" ~/.config/Code/User/

# Instalar extensões do VS Code (assumindo que existe um arquivo extensions.txt no mesmo diretório)
if [ -f "$SCRIPT_DIR/vscode/extensions.txt" ]; then
  echo "Instalando extensões do VS Code..."
  cat "$SCRIPT_DIR/vscode/extensions.txt" | while read extension || [[ -n $extension ]]; do
    if [ ! -z "$extension" ]; then
      code --install-extension "$extension" --force
    fi
  done
  echo "Extensões instaladas."
else
  echo "Arquivo extensions.txt não encontrado. Pulando essa etapa."
fi

echo "Configuração concluída!"
echo "Por favor, reinicie seu sistema para aplicar todas as alterações."
echo "Após reiniciar, o Fish já estará configurado como seu shell padrão."
