#!/bin/bash

###
# *Funcion: 
#   super_read
#   
# *Descripción:
#   Extiende la funcionalidad de la funcion read incluida de forma
#   estandar en bash, añadiendo las siguientes funcionalidades:
#     - Validación de la respuesta del usuario.
#     - Ofrecer varios intentos hasta obtener una respuesta correcta.
#     - Establecer un valor por defecto en la respuesta.
#
# *Autor: Iván Osuna Ayuste
#    Linkedin: {https://www.linkedin.com/in/ivan-osuna-ayuste/}
#
# *Uso:
#    super_read [args] nombre_de_variable
# 
# *Opciones:
#  -p, --prompt              text  Permite especificar el mensaje que se muestra al usuario.
#  -d, --default-value       text  Permite especificar el valor por defecto que se devuelve
#                                  si el usuario no indica ninguno.
#  -v, --validation-pattern  text  Permite utilizar una expresión regular para validar el 
#                                  valor introducido.
#  -a, --attemps             int   Número de intentos permitidos al usuario para introducir
#                                  un valor correcto.
#  -f, --failure-message     text  Mensaje a mostrar si el valor suministrado no es correcto.
#  -e, --error-message       text  Mensaje a mostrar si se supera el número de intentos.
#  -h, --help                      Muestra esta ayuda
####
source $(dirname $BASH_SOURCE)/etc/super_read.properties
source $(dirname $BASH_SOURCE)/ayuda.sh

function super_read(){
    
    local __mensaje=""
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
                __mensaje="$1"
            else
               # -p="Dame la =edad" -> $1
                __mensaje="${1#*=}"
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
                __mensaje_error_fatal="$1"
            else
                __mensaje_error_fatal="${1#*=}"
            fi 
           ;;
           --failure-message|-f|--failure-message=*|-f=*)
            if [[ "$1" != *=* ]]; then 
                shift
                __mensaje_error="$1"
            else
                __mensaje_error="${1#*=}"
            fi 
           ;;  
             --help|-h)
                mostrar_ayuda $BASH_SOURCE super_read
                return 0
           ;;  
    
           *) # valor no procesado hasta ahora
                if [[ -v __nombre_variable ]];
                then
                    error_fatal "Uso incorrecto de la funcion super_read. Argumento inválido: $1" >&2
                    mostrar_ayuda $BASH_SOURCE super_read

                    return 1
                fi
                __nombre_variable=$1
           ;;
        esac
        shift
    done
    
    
    # Componemos el mensaje que se preguntará al usuario
        # Añadir El signo DOS PUNTOS y un espacion en blanco
    if [[ -n "$__mensaje" ]]; then
        __mensaje="$__mensaje: "
    fi
        # Añadir El VALOR POR DEFECTO, si me lo dan
    if [[ -n "$__valor_por_defecto" ]]; then
        local __valor_por_defecto_formateado="$(azul "[$__valor_por_defecto]" )"
        __mensaje="$__mensaje$__valor_por_defecto_formateado "
    fi
    
    while [[ $__intentos > 0 ]]
    do
        # Preguntando al usuario
        read -p "$__mensaje" __valor
            # Si no me da valor... tomo el valor por defecto
        if [[ -z "$__valor" ]]; then
            __valor=$__valor_por_defecto
        fi
            # Comprobar la validez del valor
        if [[ "$__valor" =~ $__patron ]];
        then
            # Si el valor es bueno
            if [[ -v __nombre_variable ]]; then
                eval "$__nombre_variable=\"$__valor\""
            else
                echo $__valor
            fi
            return 0
        else
            # Si el valor no es bueno
            let --__intentos
            if ((  $__intentos != 0 ))
            then
                error "$__mensaje_error"
            fi
            #let __intentos-=1
            #let __intentos=$__intentos-1
        fi
    done
    # Si llego aqui es que no he conseguido un valor buen y se han superado los intentos permitidos
    error_fatal "$__mensaje_error_fatal" >&2
    if [[ -v __nombre_variable ]]; then
        eval $__nombre_variable=""
    fi
    return 1
}
