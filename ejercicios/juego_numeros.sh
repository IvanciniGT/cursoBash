#!/bin/bash
source ../gui/super_read.sh

NUMERO_ALEATORIO=$(( $RANDOM%11 ))
#echo $NUMERO_ALEATORIO
intentos=3
echo Adivina un número entre el 0 y el 10
while [[ $intentos >0 ]]
do
    super_read \
        -p "Cuál crees" \
        -v "^[0-9]|10$" \
        -a=3 \
        -f "Solo puedes escribir un numero de 0 al 10" \
        -e "Eres un membrillo... Mejor dejalo" \
        numero
    if [[ $? > 0 ]];
    then
        exit 1
    fi
    if [[ $numero == $NUMERO_ALEATORIO ]];
    then
        echo HAS GANADO !!!!
        exit 0
    else
        echo ESE NO ERA
        let --intentos
    fi
done 
echo HAS PERDIDO !!!!
