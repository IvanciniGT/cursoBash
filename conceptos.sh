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

function saluda(){
    echo HOLA $1 - $2!!!
}

saluda "IVAN OSUNA" \
                    Ayuste
        
saluda JERONIMO
saluda JORGES

#function concatena (){
#    return $1-$2
#}

#concatena Ivan Osuna

#return # Devuelve el CODIGO DE SALIDA DE EJECUCION DE MI PROGRAMA

        # 0 BIEN
        # No sea un 0 -> ERROR

function prueba(){
    echo HOLA
    return 0
    echo MAS HOLAS !!!
}
prueba

function suma(){
    let resultado=$1+$2
    echo $resultado
}

mi_variable=$(suma 1 3)
echo $mi_variable

# CONDICIONALES
# Ejecutar un codigo pero solo bajo ciertas condiciones
variable=5
if [ $variable == 3 ]; then
   echo La variable vale 3
else
   echo La variable NO vale 3
fi