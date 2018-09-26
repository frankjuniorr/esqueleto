Esqueleto de Script.
===========

## Descrição

Script feito para gerar um arquivo-template, facilitando na hora da criação de um script novo.

## Estrutura

* O script cria um diretório com o nome que o usuário passou por parâmetro.
* Dentro do diretório ele cria outro diretório chamado "manpage", com um 'arquivo.1' dentro, servindo de modelo de manpage.
* Ainda na raiz, ele cria um script executável com o nome passado por parâmetro.
* O conteúdo do executável contém:
  * um cabeçalho com data, hora, autor, email.
  * funções de utilidade como debug, função de interrupção, imprimir colorido...
  * um modelo de help (-h ou --help).
  * Tudo dentro de um padrão de coding-style (que é inspirado no mesmo condig-style do [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh/wiki/Coding-style-guide))

## Dica

Crie um ``alias`` apontando para o script no ``~/.bashrc`` , tornando ele um comando do computador:

```bash
alias esqueleto="bash <path_para_o_script>"
```

## Uso
```bash
Ex.: esqueleto -h
Ex.: esqueleto new_script
```
