#!/bin/bash

# ============================================================
# Luna ChatBot - Script de Instalação Automática para Termux
# ============================================================
# Autor: Diego Casagranda
# Versao: 3.1.1
# Licenca: GPLv3
# ============================================================

# Funcao para exibir banners
show_banner() {
    clear
    echo "============================================================"
    echo "                                                           "
    echo "     LUNA CHATBOT - ASSISTENTE PESSOAL PARA TERMUX         "
    echo "                    INSTALADOR AUTOMATICO                  "
    echo "                         v3.1.1                            "
    echo "                                                           "
    echo "============================================================"
    echo ""
}

# Funcao para exibir mensagens de progresso
print_status() {
    echo "[OK] $1"
}

print_info() {
    echo "[INFO] $1"
}

print_error() {
    echo "[ERRO] $1"
}

print_step() {
    echo ""
    echo ">>> $1"
    echo "----------------------------------------"
}

# Verificar se esta no Termux
check_termux() {
    print_step "Verificando ambiente"
    
    if [ ! -d "/data/data/com.termux/files" ]; then
        print_error "Este script foi desenvolvido para rodar no Termux."
        print_error "Baixe o Termux pelo F-Droid: https://f-droid.org/pt/packages/com.termux/"
        exit 1
    fi
    
    print_status "Ambiente Termux detectado"
}

# Atualizar pacotes
update_packages() {
    print_step "Atualizando pacotes do sistema"
    
    apt update -y && apt upgrade -y
    
    print_status "Pacotes atualizados"
}

# Instalar dependencias basicas
install_dependencies() {
    print_step "Instalando dependencias basicas"
    
    apt install openssh -y
    apt install bc -y
    apt install jq -y
    apt install curl -y
    apt install git -y
    apt install nmap -y
    apt install wget -y
    apt install python3 -y
    
    print_status "Dependencias basicas instaladas"
}

# Instalar bibliotecas adicionais
install_libraries() {
    print_step "Instalando bibliotecas adicionais"
    
    apt install libxml2 -y
    apt install libxslt -y
    apt install termux-api -y
    
    print_status "Bibliotecas adicionais instaladas"
}

# Instalar pacotes Python
install_python_packages() {
    print_step "Instalando pacotes Python"
    
    python -m pip install --upgrade pip
    pip install requests
    pip install beautifulsoup4
    pip install lxml
    pip install aiml
    pip install urllib3
    
    print_status "Pacotes Python instalados"
}

# Instalar Ollama
install_ollama() {
    print_step "Instalando Ollama"
    
    apt install ollama -y
    
    print_status "Ollama instalado"
}

# Baixar modelo e criar Luna
setup_ollama_model() {
    print_step "Configurando modelo Ollama"
    
    print_info "Baixando modelo qwen2.5:1.5b (pode levar alguns minutos)..."
    ollama pull qwen2.5:1.5b
    
    print_info "Criando arquivo Luna.Modelfile..."
    
    cat > Luna.Modelfile << 'EOF'
FROM qwen2.5:1.5b

PARAMETER temperature 0.7
PARAMETER top_p 0.9
PARAMETER top_k 50
PARAMETER repeat_penalty 1.1
PARAMETER num_predict 150
PARAMETER num_ctx 2048

SYSTEM """
Voce e uma assistente pessoal especialista em sobrevivencialismo, preparacao para emergencias,
bushcraft, primeiros socorros, e vida ao ar livre. Seja natural, conversacional e util.
Responda como uma pessoa normal, sem formalidades excessivas.
Use linguagem natural, ocasionalmente pode usar girias ou ser descontraido.
Seu foco e ajudar o usuario com dicas praticas de sobrevivencia, preparacao e seguranca.
Nao precisa se apresentar a cada resposta. Apenas responda diretamente o que foi perguntado.

Voce e uma especialista em sobrevivencialismo. Suas respostas devem ser:
- Curtas e diretas (maximo 2 linhas)
- Objetivas e praticas
- Sem enrolacao
- Sem se apresentar
- Sem cumprimentos desnecessarios
- Va direto ao ponto com a informacao solicitada

Exemplo de resposta ideal:
Pergunta: "Como fazer fogo?"
Resposta: "Use uma corda e uma madeira seca. Gire rapidamente ate formar brasa."

Nao explique demais. Seja precisa e util.
"""
EOF

    print_info "Criando modelo Luna..."
    ollama create luna -f Luna.Modelfile
    
    print_status "Modelo Ollama configurado"
}

# Configurar arquivos de inicializacao
setup_bashrc() {
    print_step "Configurando inicializacao automatica (.bashrc)"
    
    BACKUP_BASHRC="$HOME/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"
    
    if [ -f "$HOME/.bashrc" ]; then
        cp "$HOME/.bashrc" "$BACKUP_BASHRC"
        print_info "Backup do .bashrc criado em: $BACKUP_BASHRC"
    fi
    
    cat >> "$HOME/.bashrc" << 'EOF'

# =========================================================
# LUNA CHATBOT - CONFIGURACOES AUTOMATICAS
# =========================================================

# SSHD
if ! pgrep -x "sshd" > /dev/null 2>&1; then
    nohup sshd > /dev/null 2>&1 &
    echo "[OK] SSH iniciado :8022"
fi

# OLLAMA SERVER
if ! pgrep -f "ollama serve" > /dev/null 2>&1; then
    export OLLAMA_NUM_PARALLEL=1
    export OLLAMA_MAX_LOADED_MODELS=1
    export OLLAMA_KEEP_ALIVE=-1
    nohup ollama serve > /dev/null 2>&1 &
    sleep 2
    echo "[OK] Ollama iniciado"
fi

# PRELOAD MODELO
if ! pgrep -f "ollama run luna" > /dev/null 2>&1; then
    (
        ollama run luna "oi" \
        > /dev/null 2>&1
    ) &
fi

# PERFORMANCE TERMUX
export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1
export TERM=xterm-256color

# CLEAN
clear

# INFO
echo "================================="
echo " Usuario : $(whoami)"
echo " Host     : $(hostname)"
echo " Shell    : $SHELL"
echo "================================="
echo

EOF
    
    print_status "Configuracoes adicionadas ao .bashrc"
}

# Configurar permissões dos scripts
setup_permissions() {
    print_step "Configurando permissoes dos scripts"
    
    if [ -f "biohack.sh" ]; then
        chmod +x biohack.sh
    fi
    
    if [ -f "clima.sh" ]; then
        chmod +x clima.sh
    fi
    
    if [ -f "disco.sh" ]; then
        chmod +x disco.sh
    fi
    
    if [ -f "dolar.sh" ]; then
        chmod +x dolar.sh
    fi
    
    if [ -f "gasolina.sh" ]; then
        chmod +x gasolina.sh
    fi
    
    if [ -f "hora.sh" ]; then
        chmod +x hora.sh
    fi
    
    if [ -f "ia.sh" ]; then
        chmod +x ia.sh
    fi
    
    if [ -f "info.sh" ]; then
        chmod +x info.sh
    fi
    
    if [ -f "limpa.sh" ]; then
        chmod +x limpa.sh
    fi
    
    if [ -f "myip.sh" ]; then
        chmod +x myip.sh
    fi
    
    if [ -f "ouro.sh" ]; then
        chmod +x ouro.sh
    fi
    
    if [ -f "petroleo.sh" ]; then
        chmod +x petroleo.sh
    fi
    
    if [ -f "prata.sh" ]; then
        chmod +x prata.sh
    fi
    
    if [ -f "scanrede.sh" ]; then
        chmod +x scanrede.sh
    fi
    
    if [ -f "time.sh" ]; then
        chmod +x time.sh
    fi
    
    print_status "Permissoes configuradas"
}

# Testar instalacao
test_installation() {
    print_step "Testando instalacao"
    
    # Testar Ollama
    if command -v ollama &> /dev/null; then
        print_status "Ollama: OK"
    else
        print_error "Ollama: Falhou"
    fi
    
    # Testar Python
    if command -v python3 &> /dev/null; then
        print_status "Python3: OK"
    else
        print_error "Python3: Falhou"
    fi
    
    # Testar modelo Luna
    print_info "Testando modelo Luna (pode levar alguns segundos)..."
    if ollama list | grep -q "luna"; then
        print_status "Modelo Luna: OK"
    else
        print_error "Modelo Luna: Falhou"
    fi
}

# Exibir instrucoes finais
show_final_instructions() {
    echo ""
    echo "============================================================"
    echo "                    INSTALACAO CONCLUIDA                    "
    echo "============================================================"
    echo ""
    echo "Para iniciar a Luna, execute:"
    echo "  python3 luna.py"
    echo ""
    echo "Comandos uteis:"
    echo "  ./clima.sh      - Ver clima atual"
    echo "  ./dolar.sh      - Cotacao do dolar"
    echo "  ./info.sh       - Painel resumido"
    echo "  ./hora.sh       - Horario, clima e bateria (com voz)"
    echo ""
    echo "Para que as configuracoes do .bashrc entrem em vigor:"
    echo "  source ~/.bashrc"
    echo ""
    echo "Ou simplesmente feche e reabra o Termux."
    echo ""
    echo "============================================================"
}

# Funcao principal
main() {
    show_banner
    
    print_info "Iniciando instalacao do Luna ChatBot v3.1.1"
    print_info "Este processo pode levar alguns minutos..."
    echo ""
    
    check_termux
    update_packages
    install_dependencies
    install_libraries
    install_python_packages
    install_ollama
    setup_ollama_model
    setup_bashrc
    setup_permissions
    test_installation
    show_final_instructions
}

# Executar script
main