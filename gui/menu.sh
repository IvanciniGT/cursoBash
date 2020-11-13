#!/bin/bash

###
# *Funcion:
#   menu
#   
# *Descripción:
#   Genera un menu interactivo con los items especificados.
#   Al pulsar una opción se invoca una función suministrada de una lista.
# *Autor: Iván Osuna Ayuste
#    Linkedin: {https://www.linkedin.com/in/ivan-osuna-ayuste/}
#
# *Uso:
#    menu [args]
# 
# *Opciones:
#  -t, --title      text  Permite especificar el titulo del menu.
#  -o, --options    text  Permite especificar una lista con las opciones del menu.
#  -d, --default    text  Permite especificar el número de opción por defecto.
#  -e, --exit       int   Permite especificar el mensaje de la opción para salir.
#  -f, --functions  text  Lista con las funciones asociadas a cada opción del menu.
#  -h, --help             Muestra esta ayuda
####

source $(dirname $BASH_SOURCE)/super_read.sh
source $(dirname $BASH_SOURCE)/formatos.sh

function menu(){
    
    
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
    
    __opciones=${__opciones// /__espacio__}
    __opciones=${__opciones//|/ }
    __opciones=( $__opciones )

    local __funciones_separadas=( $__funciones )
        
    while [[ true ]]
    do
        # Mostrar valores
        clear
        titulo "${__titulo^^}"
        echo
        
        # IFS: Internal field separator=> espacio, tabulador y salto de linea
        #>>> oldIFS="$IFS"
        #>>> IFS="|"
        #>>> __opciones=( $__opciones )
    
        local __numero_opcion=1
        local __numero_opcion_defecto=0
        for __opcion in ${__opciones[@]}
        do
            local __item=" $__numero_opcion "
            local __texto_opcion=${__opcion//__espacio__/ }
            # Controlaba si la opción actual (texto) era el texto de la opción por defecto
            if [[ "$__texto_opcion" == "$__opcion_por_defecto" ]];then
                __item=$(fondo_amarillo $(gris "[$__numero_opcion]") )
                __numero_opcion_defecto=$__numero_opcion # Me guardo el número de opción
            else
                __item=$(amarillo "$__item")
            fi
            echo "  $__item   $__texto_opcion"
            let ++__numero_opcion
        done
        
        #>>> IFS="$oldIFS"
    
        echo
        echo "   $(amarillo 0)    $__opcion_salida"
        echo
        azul $(linea)
        let --__numero_opcion
        super_read -p "  Elija una opción" \
                   -d "$__numero_opcion_defecto" \
                   -v "^[0-$__numero_opcion]$" \
                   -e "   Debe introducir un número entre 0 y $__numero_opcion" \
                   -f "" \
                   -a 1 \
                   opcion_elegida
        if [[ $? > 0 ]]; then
            # Otra vez el menu
            read -n1 -p "$(negrita "$(rojo "   Pulse cualquier tecla para continuar...")")"
        elif (( $opcion_elegida > 0 )); then
            # Tenemos un valor bueno
            ${__funciones_separadas[$opcion_elegida]}
        else
           break # HA escrito un 0... quiere irse
        fi
    done
    # Aqui estoy ya fuera del while
    ${__funciones_separadas[0]}
}
