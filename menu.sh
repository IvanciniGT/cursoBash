#!/bin/bash

function menu(){
    
    source ./super_read.sh
    
    local __titulo
    local __opciones
    local __opcion_por_defecto
    local __opcion_salida
    local __funciones
    
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
          --functions|-f|--functions=*|-f=*)
            if [[ "$1" != *=* ]]; then 
                shift
                __funciones=$1
            else
                __funciones=${1#*=}
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
            --exit-option|-e|--exit-option=*|-e=*)
            if [[ "$1" != *=* ]]; then 
                shift
                __opcion_salida=$1
            else
                __opcion_salida=${1#*=}
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
    
    # IFS: Internal field separator=> espacio, tabulador y salto de linea
    #>>> oldIFS="$IFS"
    #>>> IFS="|"
    #>>> __opciones=( $__opciones )

    numero_opcion=1
    numero_opcion_defecto=0
    for __opcion in ${__opciones[@]}
    do
        item=" $numero_opcion "
        texto_opcion=${__opcion//__espacio__/ }
        # Controlaba si la opción actual (texto) era el texto de la opción por defecto
        if [[ "$texto_opcion" == "$__opcion_por_defecto" ]];then
            item="[$numero_opcion]"
            numero_opcion_defecto=$numero_opcion # Me guardo el número de opción
        fi
        echo "  $item   $texto_opcion"
        let ++numero_opcion
    done
    
    #>>> IFS="$oldIFS"

    echo
    echo "   0    $__opcion_salida"
    echo

    let --numero_opcion
    super_read -p "Elija una opción" \
               -d "$numero_opcion_defecto" \
               -v "^[0-$numero_opcion]$" \
               -e "Debe introducir un número entre 0 y $numero_opcion" \
               -f "" \
               -a 1 \
               opcion_elegida
    if [[ $? > 0 ]];then
        # Otra vez el menu
        echo Mostaria otra vez el menu
    else
        # Tenemos un valor bueno
        __funciones_separadas=( $__funciones )
        ${__funciones_separadas[$opcion_elegida]}
    fi
}
