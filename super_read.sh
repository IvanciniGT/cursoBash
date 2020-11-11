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

function super_read_help(){
    echo 'Funcion super_read:'
    echo '  Extiende la funcionalidad de la funcion read incluida de forma' \
         'estandar en bash,'
    echo ' añadiendo las siguientes funcionalidades:'
    echo '    - Validación de la respuesta del usuario'
    echo '    - Ofrecer varios intentos hasta obtener una respuesta correcta'
    echo '    - Establecer un valor por defecto en la respuesta'
    echo 'Uso:'
    echo '   super_read [args] nombre_de_variable'
    echo ''
    echo '   Al igual que la funcion read, el valor introducido por el usuario ' \
         'se almacena en una variable con el nombre suministrado.'
    echo ''
    echo 'Argumentos:'
    echo ' -p, --prompt:             Permite especificar el mensaje que se muestra al usuario.'
    echo ' -d, --default-value:      Permite especificar el valor por defecto que se devuelve si el usuario'
    echo '                           no indica ninguno.'
    echo ' -v, --validation-pattern: Permite utilizar una expresión regular para validar el valor introducido'
    echo ' -a, --attemps:            Número de intentos permitidos al usuario para introducir un valor correcto'
    echo ' -f, --failure-message:    Mensaje a mostrar si el valor suministrado no es correcto'
    echo ' -e, --error-message:      Mensaje a mostrar si se supera el número de intentos'
}

function super_read(){
    source ./super_read.properties
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
             --help|-h)
                super_read_help
           ;;  
    
           *) # valor no procesado hasta ahora
                if [[ -v __nombre_variable ]];
                then
                    echo "Uso incorrecto de la funcion super_read. Argumento inválido: $1" >&2
                    #stdout -> Salida estandar. Si todo va bien
                    #stderr -> Salida de error. Si algo va mal--> &2
                    super_read_help
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
        __mensaje="$__mensaje[$__valor_por_defecto]: "
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
            echo $__mensaje_error
            let --__intentos
            #let __intentos-=1
            #let __intentos=$__intentos-1
        fi
    done
    # Si llego aqui es que no he conseguido un valor buen y se han superado los intentos permitidos
    echo $__mensaje_error_fatal >&2
    if [[ -v __nombre_variable ]]; then
        eval $__nombre_variable=""
    fi
    return 1
}
