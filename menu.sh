#!/bin/bash

function menu(){
    local __titulo
    local __opciones
    local __opcion_por_defecto
    
    # Lectura de los argumentos
    while [[ $# > 0 ]]
    do
        case "$1" in
          --title|-t|--title=*|-t=*)
            if [[ "$1" != *=* ]]; then 
                shift
                __titulo=$1
            else
                __titulo=${1#*=}
            fi 
           ;;
          --options|-o|--options=*|-o=*)
            if [[ "$1" != *=* ]]; then 
                shift
                __opciones=$1
            else
                __opciones=${1#*=}
            fi 
           ;;
          --default|-d|--default=*|-d=*)
            if [[ "$1" != *=* ]]; then 
                shift
                __opcion_por_defecto=$1
            else
                __opcion_por_defecto=${1#*=}
            fi 
           ;;
        *) # valor no procesado hasta ahora
            echo "Uso incorrecto de la funcion menu. Argumento inválido: $1" >&2
            return 1
           ;;
        esac
        shift
    done
    
    # Mostrar valores
    clear
    echo ${__titulo^^}
    echo
    __opciones=${__opciones// /__espacio__}
    __opciones=${__opciones//|/ }
    __opciones=( $__opciones )
    
    for __opcion in ${__opciones[@]}
    do
        echo "    ${__opcion//__espacio__/ }"
    done
}

NOMBRE_MENU="Menu principal"
OPCIONES_MENU="Gestión Servidores|Gestión Servicios|Estado de los Sistemas"
VALOR_POR_DEFECTO="Gestión Servidores"

menu --title "$NOMBRE_MENU" --options "$OPCIONES_MENU" --default "$VALOR_POR_DEFECTO"
