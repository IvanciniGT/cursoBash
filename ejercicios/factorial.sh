#!/bin/bash

function dame_numero(){
    read -p "Deme un numero: " numero
    echo $numero
}

# Factorial del un número
#  5! = 5x4x3x2x1
# Recursividad
#  5! = 5x4!
#  4! = 4x3!
#  3! = 3x2!
#  2! = 2x1!
#  1! = 1x0!
#  0! = 1
# factorial 5 -> 120
#      factorial 4 -> 24
#         factorial 3 -> 6
#            factorial 2 -> 2
#               factorial 1 -> 1
#                 factorial 0 -> 1
# STACK OVER FLOW ---> Desbordamiento de pila
# PILA: Estructura de datos MAS O MENOS igual que un ARRAY
#       Diferencia: En la pila, solo puedo poner cosas al final
#       Diferencia: En la pila, solo puedo sacar cosas del final
function factorial(){
    #$1 Numero del que me piden el factorial
    # let anterior=$1-1 Numero anterior
    #   (($1-1))
    if [[ $1 == 0 ]]; then
        echo 1
    else
        let anterior=$1-1
        resultado_subfactorial=$(factorial $anterior)
        let resultado=$resultado_subfactorial*$1
        echo $resultado
    fi
}

function factorial_metodo_2(){
    resultado=1
    numero=$1
    #while [[ numero -gt 0 ]]
    while (( numero != 0 ))
    do
        let resultado*=$numero #let resultado=$resultado*$numero
        let numero-=1          #let numero=$numero-1
    done
    echo $resultado
}
numero=$(dame_numero)
echo $(factorial $numero)
echo $(factorial_metodo_2 $numero)