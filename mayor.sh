#!/bin/bash

function dame_numero(){
    read -p "Deme un numero: " numero
    echo $numero
}

function determinar_mayor(){
    #echo El primer numero es $num1
    #echo El segundo numero es $num2
    # Operadores de comparación textos:
    #   == = -> Equals
    #   != -> Not equals
    #   < -> Orden ASCII
    #   > -> ORDEN segun ASCII
    #   -z ==>>> [[ -z "$VAR" ]] => Que la variable esté vacia
    #   -n ==>>> [[ -n "$VAR" ]] => Que la variable NO esté vacia
    #   -v ==>>> [[ -v VAR ]] => Que la variable esté asignada
    #   ~= ===> [[ "$texto" =~ $patron ]] Si un texto cumple con un patrón
    # Operadores de comparación numérica:
    #   -eq -> Equals
    #   -ne -> Not equals
    #   -lt -> Litter than
    #   -gt -> Greater than
    #   -le -> <=
    #   -ge -> >=
#    if [[ $num1 -gt $num2 ]]; then
# Operadores con DOBLE PARENTESIS (())
    # ==
    # !=
    # > >=
    # < <=
    # + - * / % (resto de la division entera)
    # 13%3 -> 1
    if (( $1 > $2 )); then
        echo $1
    else
        echo $2
    fi
}

function determinar_mayor_de_tres(){
    casi_mayor=$(determinar_mayor $1 $2)
    mayor=$(determinar_mayor $casi_mayor $3)
    echo $mayor
}
num1=$(dame_numero)
num2=$(dame_numero)
num3=$(dame_numero)

el_mayor=$(determinar_mayor_de_tres $num1 $num2 $num3)
echo El numero mayor es $el_mayor