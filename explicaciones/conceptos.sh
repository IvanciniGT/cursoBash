#!/bin/bash

# Comentar: ¿Cómo lo hace?
# Desde que se encuentra una almohadilla el 
# resto de linea se considera comentario

# Documentar: ¿Qué hace el código? y ¿Cómo se usa?

# VARIABLES: "REFERENCIA A" UN ESPACIO DE MEMORIA QUE SE RESERVA
VAR1=17
set VAR1=17

local VAR1=17 # Igual que las anteriores, pero se limita 
              # el scope de la variable

let VAR1=17   # Lo que ponemos detrás (como valor) va a ser interpretado

let VAR1=12+9
echo $VAR1

# Tipo de datos
#   String | Textos        <<<<<<<<<<<<
#   Enteros
#   Floats | Decimales
#   Lógicos
#   Ficheros
#   Arrays

read -p "Escribe aqui algo: " valor_capturado
echo Has escrito: $valor_capturado
