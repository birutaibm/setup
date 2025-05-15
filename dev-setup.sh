#!/bin/bash
# Script para configuração automatizada do Ubuntu 24.04
# Criado em: 14/05/2025

set -e  # Encerra o script se algum comando falhar

echo "Iniciando configuração do Ubuntu 24.04..."
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Atualizar o sistema
echo "Atualizando o sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar dependências básicas
echo "Instalando dependências básicas..."
sudo apt install -y curl wget git build-essential unzip

# Instalar as fontes Nerd Fonts para suportar os ícones
echo "Instalando fontes Nerd Fonts para suportar os ícones..."
mkdir -p ~/.local/share/fonts
# Usar subshell (comando entre parênteses) evita mudar o diretório onde todo o resto do script é executado
(
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
  chsh -s $(which fish)

  # Instalar Fisher (plugin manager para Fish)
  echo "Instalando Fisher..."
  fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"

  # Instalar ASDF
  echo "Instalando ASDF..."
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.0

  # Configurar o terminal para usar a fonte Nerd Font instalada
  if [ -d ~/.config/gnome-terminal ]; then
      # Para Gnome Terminal (Ubuntu padrão)
      PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')
      gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ font 'FiraCode Nerd Font 12'
      gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ use-system-font false
      echo "Terminal configurado para usar FiraCode Nerd Font"
  fi

  # Instalar plugin Node.js para ASDF
  echo "Instalando plugin Node.js para ASDF..."
  fish -c "source ~/.asdf/asdf.fish && asdf plugin add nodejs"
  fish -c "source ~/.asdf/asdf.fish && asdf install nodejs latest"
  fish -c "source ~/.asdf/asdf.fish && asdf global nodejs latest"

  # Instalar Tide (tema para Fish)
  echo "Instalando o tema Tide para Fish..."
  fish -c "fisher install IlanCosman/tide@v5"
)

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
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" -y
sudo apt update
sudo apt install -y code

# Configurar VS Code
echo "Configurando VS Code..."
mkdir -p ~/.config/Code/User/

# Copiar configurações do vscode
rsync -av --exclude 'extensions.txt' ./vscode/ ~/.config/Code/User/

# Instalar extensões do VS Code (assumindo que existe um arquivo extensions.txt no mesmo diretório)
if [ -f "$SCRIPT_DIR/vscode/extensions.txt" ]; then
  echo "Instalando extensões do VS Code..."
  cat ./extensions.txt | while read extension || [[ -n $extension ]]; do
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
