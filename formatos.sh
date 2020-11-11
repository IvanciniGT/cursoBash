#!/bin/bash


nombre=Ivan
edad=42

nombre2=Rodrigo
edad2=3

printf "> %-20s %5s\n" NOMBRE EDAD;
printf "> %-20s %+5i\n" $nombre $edad; 
printf "> %-20s %+5i\n" $nombre2 $edad2;

#tput COMANDO QUE ME PERMITE MANEJAR ASPECTOS DE LA TERMINAL (interfaz gráfica)

echo $(tput cols)

for color_letra in {0..7}
do
    for color_fondo in {0..7}
    do
        printf $(tput setaf $color_letra)$(tput setab $color_fondo)HOLA$(tput sgr0)
    done
    echo ""
done


for color_letra in {0..7}
do
    for color_fondo in {0..7}
    do
        printf $(tput sgr 0 1)$(tput bold)$(tput setaf $color_letra)$(tput setab $color_fondo)HOLA$(tput sgr0)
    done
    echo ""
done
numero_ips=6
echo {1..$numero_ips}
echo $( eval echo {1..$numero_ips} )

echo {1..3}
