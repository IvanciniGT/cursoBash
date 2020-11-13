#!/bin/bash

###
# *Funcion:
#   ayuda
#   
# *Descripción:
#   Genera la ayuda de una función desde el comentario anteriora la misma.
#
# *Autor: Iván Osuna Ayuste
#    Linkedin: {https://www.linkedin.com/in/ivan-osuna-ayuste/}
#
# *Uso:
#    ayuda <fichero> <nombre funcion>
# 
####

source $(dirname $BASH_SOURCE)/formatos.sh

function mostrar_ayuda(){
    local __fichero=$1
    local __funcion=$2
    local __ayuda
    local __ayuda_on=0
    local __linea
    
    
    while read -r __linea
    do
        case "$__linea" in
            \#\#\#\#*)
                __ayuda_on=0
            ;;
            \#\#\#*)
                __ayuda_on=1
                __ayuda=""
                continue  
            ;;
            function*${__funcion}*)
                echo -e "${__ayuda:2}"
                return 0
            ;;
        esac
        if [[ $__ayuda_on == 1 ]]
        then 
            __linea="${__linea#\# }"
            __linea="${__linea#\#}"
            if [[ "$__linea" =~ ^\* ]]
            then 
                __linea=$(negrita "$(azul "${__linea//\*}")")
            fi
            __ayuda="${__ayuda}\n$__linea"
        fi
    done < $__fichero
    return 1
}