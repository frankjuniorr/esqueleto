#!/bin/bash

################################################################################
# Descrição:
#    TODO...
#
################################################################################
# Uso:
#    TODO..
#
################################################################################
# Dependencias:
# <app> [<link_para_download>] --> <breve_descrição>
# instalação: 'sudo apt-get install <app>'
################################################################################
# Autor: %autor% <%email%>
# Desde: %data%
# Versão: 1
################################################################################


################################################################################
# Configurações
# set:
# -e: se encontrar algum erro, termina a execução imediatamente
  set -e


################################################################################
# Variáveis - todas as variáveis ficam aqui

# as variaveis ficam aqui...

  # mensagem de help
    nome_do_script=$(basename "$0")

    mensagem_help="
  Uso: $nome_do_script [OPÇÕES] <NOME_DO_SCRIPT>

  Descrição: .....

  OPÇÕES: - opcionais
    -h, --help  Mostra essa mesma tela de ajuda

  PARAM - obrigatório
    - descrição do PARAM

  Ex.: ./$nome_do_script -h
  Ex.: ./$nome_do_script PARAM
  "


################################################################################
# Utils - funções de utilidades

  # códigos de retorno
  # [condig-style] constantes devem começar com 'readonly'
  readonly SUCESSO=0
  readonly ERRO=1

  # debug = 0, desligado
  # debug = 1, ligado
  debug=0

  # ============================================
  # Função pra imprimir informação
  # ============================================
  _print_info(){
    local amarelo="$(tput setaf 3 2>/dev/null || echo '\e[0;33m')"
    local reset="$(tput sgr 0 2>/dev/null || echo '\e[0m')"

    printf "${amarelo}$1${reset}\n"
  }

  # ============================================
  # Função pra imprimir mensagem de sucesso
  # ============================================
  _print_success(){
    local verde="$(tput setaf 2 2>/dev/null || echo '\e[0;32m')"
    local reset="$(tput sgr 0 2>/dev/null || echo '\e[0m')"

    printf "${verde}$1${reset}\n"
  }

  # ============================================
  # Função pra imprimir erros
  # ============================================
  _print_error(){
    local vermelho="$(tput setaf 1 2>/dev/null || echo '\e[0;31m')"
    local reset="$(tput sgr 0 2>/dev/null || echo '\e[0m')"

    printf "${vermelho}[ERROR] $1${reset}\n"
  }

  # ============================================
  # Função de debug
  # ============================================
  _debug_log(){
    if [ "$debug" = 1 ];then
       _print_info "[DEBUG] $*"
    fi
}

  # ============================================
  # tratamento das exceções de interrupções
  # ============================================
  _exception(){
    return "$ERRO"
  }

  # ============================================
  # Verificar se um pacote está instalado
  # $1 --> nome do pacote que deseja verificar
  # $2 --> mensagem de erro customizada (OPCIONAL)
  # ============================================
  _die(){
    local package=$1
    local custom_msg=$2

    if ! type $package > /dev/null 2>&1; then
      _print_error "$package is not installed"
      test ! -z "$custom_msg" && _print_error "$custom_msg"
      exit $ERRO
    fi
  }

################################################################################
# Validações - regras de negocio até parametros

  # ============================================
  # tratamento de validacoes
  # ============================================
  validacoes(){
    return "$SUCESSO"
  }

################################################################################
# Funções do Script - funções próprias e específicas do script

  # ============================================
  # Descrição da 'funcao_dummy'
  # ============================================
  funcao_dummy(){
    _print_info "Ola, meu nome eh $nome_do_script"
    echo
    _print_success "imprimindo mensagem de sucesso!"
    _print_error "imprimindo mensagem de erro!"
    _debug_log "mensagem de debug"
    exit "$SUCESSO"
  }

  # ============================================
  # Função Main
  # ============================================
  main(){
    funcao_dummy
  }

  # ============================================
  # Função que exibe o help
  # ============================================
  verifyHelp(){
    case "$1" in

      # mensagem de help
      -h | --help)
        _print_info "$mensagem_help"
        exit "$SUCESSO"
      ;;

    esac
  }

################################################################################
# Main - execução do script

  # trata interrrupção do script em casos de ctrl + c (SIGINT) e kill (SIGTERM)
  trap _exception SIGINT SIGTERM
  verifyHelp "$1"
  validacoes
  main "$1"

################################################################################
# FIM do Script =D
