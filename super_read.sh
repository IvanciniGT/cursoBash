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
    local __mensaje=$1
    local __nombre_variable=$2
    local __valor_por_defecto=$3
    local __patron=$4
    local __valor=""
    
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

# REGEX : Expresión regular
# PATRON: Que el texto contenga solo numeros
# PATRON: Que el texto contenga solo letras
# PATRON: Que el texto pueda ser solo yes o no
# Verificar si un texto cumple o no con un patron

#super_read "Dame una IP" mi_ip "127.0.0.1" 
#super_read "Dame una máquina" mi_maquina "localhost"
super_read "Dame tu edad" mi_edad "18" "^[1-9][0-9]{,2}$"
super_read "Reinicio el servidor" reinicio "si" "^(si|no)$"

echo $mi_edad
echo $reinicio