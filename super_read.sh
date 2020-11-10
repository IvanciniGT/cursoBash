#!/bin/bash

# Funcion para hacer una pregunta al usuario por consola
# read: Ya existe
# Queremos un read potenciado:
#   1º Controlar lo que escribe el usuario... que sea correcto
#       Ejemplo: Dame una IP para conectarme: patata
#       Ejemplo: Dame un email: patata
#   2º Límite en el número de intentos
#   3º Valor por defecto:
#       Máquina con la que conectarse: [localhost]: 

function super_read(){
    source ./super_read.properties
    local __mensaje
    local __nombre_variable
    local __valor_por_defecto
    local __patron
    local __intentos=$SUPERREAD_ATTEMPS
    local __mensaje_error_fatal=$SUPERREAD_EXIT_MESSAGE
    local __mensaje_error=$SUPERREAD_FAILURE_MESSAGE
    local __valor=""
    
    # Lectura de los argumentos $# ---> shift
    while [[ $# > 0 ]]
    do
        case "$1" in
           --prompt|-p|--prompt=*|-p=*)
            if [[ "$1" != *=* ]]; then 
               # -p ---> $1          "Dame la =edad" -> $2 -> $1
                shift
                __mensaje=$1
            else
               # -p="Dame la =edad" -> $1
                __mensaje=${1#*=}
            fi 
           ;;
          --default-value|-d|--default-value=*|-d=*)
            if [[ "$1" != *=* ]]; then 
                shift
                __valor_por_defecto=$1
            else
                __valor_por_defecto=${1#*=}
            fi 
           ;;
           --validation-pattern|-v|--validation-pattern=*|-v=*)
            if [[ "$1" != *=* ]]; then 
                shift
                __patron=$1
            else
                __patron=${1#*=}
            fi 
           ;;
           --attemps|-a|--attemps=*|-a=*)
            if [[ "$1" != *=* ]]; then 
                shift
                __intentos=$1
            else
                __intentos=${1#*=}
            fi 
           ;;           
           --exit-message|-e|--exit-message=*|-e=*)
            if [[ "$1" != *=* ]]; then 
                shift
                __mensaje_error_fatal=$1
            else
                __mensaje_error_fatal=${1#*=}
            fi 
           ;;
           --failure-message|-f|--failure-message=*|-f=*)
            if [[ "$1" != *=* ]]; then 
                shift
                __mensaje_error=$1
            else
                __mensaje_error=${1#*=}
            fi 
           ;;  
    
           *) # valor no procesado hasta ahora
                if [[ -v __nombre_variable ]];
                then
                    echo "Uso incorrecto del programa" >&2
                    #stdout -> Salida estandar. Si todo va bien
                    #stderr -> Salida de error. Si algo va mal--> &2
                    return 1
                fi
                __nombre_variable=$1
           ;;
        esac
        shift
    done
    
    
    # Componemos el mensaje que se preguntará al usuario
        # Añadir El signo DOS PUNTOS y un espacion en blanco
    __mensaje="$__mensaje: "
        # Añadir El VALOR POR DEFECTO, si me lo dan
    if [[ -n "$__valor_por_defecto" ]]; then
        __mensaje="$__mensaje[$__valor_por_defecto]: "
    fi
    
    # Preguntando al usuario
    read -p "$__mensaje" __valor
        # Si no me da valor... tomo el valor por defecto
    if [[ -z "$__valor" ]]; then
        __valor=$__valor_por_defecto
    fi
        # Comprobar la validez del valor
    if [[ "$__valor" =~ $__patron ]];
    then
        eval $__nombre_variable=$__valor
        return 0
    else
        eval $__nombre_variable=""
        echo El valor introducido no es correcto
        return 1
    fi
    
}
