  #!/bin/bash

################################################################################
#
# Descrição:
#   Esqueleto de Script.
#   Script feito para gerar uma especie de casca de script,
#   facilitando na hora da criação de um script novo.
#   E eu não podia deixar de fazer uma referencia ao Esqueleto do He-man =)
#
################################################################################
#
# Uso:
#    ./esqueleto [OPÇÕES] <NOME_DO_SCRIPT>
#
#    OPÇÕES: - opcionais
#   -h, --help  Mostra essa mesma tela de ajuda
#
#    NOME_DO_SCRIPT - obrigatório
#    - Nome do script a ser criado
#
#   Ex.: ./esqueleto -h
#   Ex.: ./esqueleto dummy_script
#
################################################################################
#
# Autor: Frank Junior <frankcbjunior@gmail.com>
# Desde: 2013-12-24
# Versão: 5
#
################################################################################


################################################################################
# Configurações
# set:
# -e: se encontrar algum erro, termina a execução imediatamente
  set -e


################################################################################
# Variáveis - todas as variáveis ficam aqui

  nome_do_usuario=""
  email_do_usuario=""
  nome_do_script=""
  esqueleto_path=$(dirname "$0")

  mensagem_help="
Uso: $(basename "$0") [OPÇÕES] <NOME_DO_SCRIPT>

OPÇÕES: - opcionais
  -h, --help  Mostra essa mesma tela de ajuda

NOME_DO_SCRIPT - obrigatório
  - Nome do script a ser criado

Ex.: ./esqueleto -h
Ex.: ./esqueleto dummy_script
  "

################################################################################
# Utils - funções de utilidades

  param=$1 # parametro do script
  param="${param%.*}" # caso o usuário passe o parametro com alguma extensão, retire

  # códigos de retorno
  SUCESSO=0
  ERRO=1

  # debug = 0, desligado
  # debug = 1, ligado
  debug=1

  # ============================================
  # Função pra imprimir informação
  # ============================================
  _print_info(){
    local amarelo="\033[33m"
    local reset="\033[m"

    printf "${amarelo}$1${reset}\n"
  }

  # ============================================
  # Função pra imprimir mensagem de sucesso
  # ============================================
  _print_success(){
    local verde="\033[32m"
    local reset="\033[m"

    printf "${verde}$1${reset}\n"
  }

  # ============================================
  # Função pra imprimir erros
  # ============================================
  _print_error(){
    local vermelho="\033[31m"
    local reset="\033[m"

    printf "${vermelho}[ERROR] $1${reset}\n"
  }

  # ============================================
  # tratamento das excecoes de interrupções
  # ============================================
  _exception(){
    _print_error "Alguem me matou com um um 'kill -9'"
    exit "$ERRO"
  }

################################################################################
# Validações - regras de negocio até parametros

  # ============================================
  # tratamento de validacoes da criação do script
  #
  # $1 - nome do script novo
  # ============================================
  validacoes(){
    local nome_do_script=$1

    # verificando se o script já foi criado
    if [ -d "$nome_do_script" ]; then
      _print_error "Script já existe com esse nome"
      exit "$ERRO"
    fi

  }

################################################################################
# Funções do Script - funções próprias e específicas do script

  # ============================================
  # função que pega o nome do autor e o email
  # através das configurações do git.
  # ============================================
  pegar_autor_email_pelo_git(){
    # pegando as configurações do git para preencher o cabeçalho.
    if type git > /dev/null 2>&1;then
      email_do_usuario="$(git config user.email)"
      nome_do_usuario="$(git config user.name)"
    # se não tiver git instalado ,coloque o nome do usuario corrente no script,
    # e coloque um TODO no email
    else
      nome_do_usuario=$(whoami)
      email_do_usuario="TODO: email@email.com"
    fi
  }

  # ============================================
  # Função para criar o arquivo de script
  # ============================================
  init(){
    nome_do_diretorio="${nome_do_script%.sh}"
    local script='/modelos/script.sh'
    local data=$(date +%d-%m-%Y)

    # criando o diretorio do script
     mkdir "$nome_do_diretorio"

    # copiando o script modelo
    cp ${esqueleto_path}${script} "$nome_do_diretorio"

    cd "$nome_do_diretorio"

    # alterando os valores
    sed -i "s/%autor%/$nome_do_usuario/" script.sh
    sed -i "s/%email%/$email_do_usuario/" script.sh
    sed -i "s/%data%/$data/" script.sh

    # renomeando o modelo para o nome certo
    mv script.sh "$nome_do_script"
  }

  # ============================================
  # Função para criar o arquivo de manpage daquele script
  # ============================================
  create_manpage(){
    # removendo a extensão do arquivo
    local nome_da_manpage="${nome_do_script%.sh}"
    local manpage='/modelos/manpage.1'
    local manpage_dir='manpage'
    local data=$(date "+%d %b %Y")

    mkdir "$manpage_dir"
    cd ..

    cp ${esqueleto_path}${manpage} "${nome_do_diretorio}/${manpage_dir}"

    cd "${nome_do_diretorio}/${manpage_dir}"

    sed -i "s/@nome_do_script@/$nome_do_script/" "manpage.1"
    sed -i "s/@autor@/$nome_do_usuario/" "manpage.1"
    sed -i "s/@email@/$email_do_usuario/" "manpage.1"
    sed -i "s/@data@/$data/" "manpage.1"

    # renomeando a manpage para o nome certo
    mv "manpage.1" "${nome_da_manpage}.1"

    cd ..
  }

  # ============================================
  # Função Main
  #
  # Param $1Parametros passados pro script
  # ============================================
  main(){
    local parametro=$1
    while test -n "$parametro"
    do
      case "$parametro" in

        # mensagem de help
        -h | --help)
          _print_info "$mensagem_help"
          exit "$SUCESSO"
        ;;

        # se passar só o nome do script como parametro, ele cria sem git
        *)
          validacoes "$parametro"
          nome_do_script="$parametro.sh"
          pegar_autor_email_pelo_git
          init
          create_manpage
          _print_success "script $nome_do_script criado com sucesso"
          exit "$SUCESSO"
        ;;

      esac
      shift
    done

  }

################################################################################
# Main - execução do script

  # trata interrrupção do script em casos de ctrl + c (SIGINT) e kill (SIGTERM)
  trap _exception SIGINT SIGTERM

  # verifica se existe parametro.
  # se não existir, exibe o help.
  # se existir, chama o main
  if [ -z "$param" ]; then
    _print_info "$mensagem_help"
    exit "$SUCESSO"
  else
    main "$param"
  fi
