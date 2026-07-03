#!/usr/bin/env bash

# ==============================================================================
# SCRIPT DE AUTOMAÇÃO DE AMBIENTE - CRM HEADLESS
# Alvo: Ubuntu (WSL2 / Linux Nativo)
# ==============================================================================

# Definição de cores para logs limpos no terminal
SET_GREEN='\033[0;32m'
SET_RED='\033[0;31m'
SET_CYAN='\033[0;36m'
SET_RESET='\033[0m'

log_info() {
    echo -e "${SET_CYAN}[INFO]${SET_RESET} $1"
}

log_success() {
    echo -e "${SET_GREEN}[SUCCESS]${SET_RESET} $1"
}

log_error() {
    echo -e "${SET_RED}[ERROR]${SET_RESET} $1"
}

# 1. Verificação de segurança: impede rodar como root via sudo diretamente
if [ "$EUID" -eq 0 ]; then
    log_error "Não rode este script com 'sudo'. Ele instalará ferramentas no escopo do seu usuário comum."
    exit 1
fi

log_info "Iniciando automação do setup de desenvolvimento corporativo..."

# 2. Atualização dos repositórios do sistema
log_info "Atualizando pacotes do sistema operacional via APT..."
sudo apt update && sudo apt upgrade -y

# 3. Instalação de dependências core indispensáveis
log_info "Instalando ferramentas essenciais de compilação e utilitários (unzip, curl, git)..."
sudo apt install -y curl git build-essential unzip

# 4. Instalação e configuração do FNM (Fast Node Manager) em Rust
if ! command -v fnm &> /dev/null; then
    log_info "Instalando FNM (Fast Node Manager)..."
    curl -fsSL https://fnm.vercel.app/install | bash
    
    # Injeta dinamicamente as variáveis do FNM no arquivo de perfil do Bash para persistência
    if ! grep -q "fnm env" ~/.bashrc; then
        echo 'export PATH="$HOME/.local/share/fnm:$PATH"' >> ~/.bashrc
        echo 'eval "`fnm env --use-on-cd`"' >> ~/.bashrc
    fi
    
    # Carrega o FNM imediatamente para a sessão atual do script
    export PATH="$HOME/.local/share/fnm:$PATH"
    eval "`fnm env --use-on-cd`"
else
    log_info "FNM já configurado no sistema."
fi

# 5. Provisionamento do Runtime Node.js na versão estável correta
log_info "Instalando e definindo Node.js v22 (LTS) como padrão do sistema..."
fnm install 22
fnm use 22
fnm default 22

# 6. Ativação estruturada do Corepack e gerenciador PNPM
log_info "Ativando Corepack e instalando versão estável do PNPM..."
corepack enable
corepack prepare pnpm@latest --activate

# 7. Validação final de sanidade do ambiente
echo "--------------------------------------------------"
log_success "Ambiente de Desenvolvimento Configurado com Sucesso!"
echo -e "Versão do Node:  ${SET_GREEN}$(node -v)${SET_RESET}"
echo -e "Versão do PNPM:  ${SET_GREEN}$(pnpm -v)${SET_RESET}"
echo "--------------------------------------------------"
log_info "ATENÇÃO: Para aplicar as alterações no seu terminal atual, execute: source ~/.bashrc"