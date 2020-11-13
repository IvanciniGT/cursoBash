#!/bin/bash

source ../ayuda.sh

###
# *Funcion:
#   prueba_ayuda
#
# *Descripción:
#   Muestra una ayuda automáticamente generada desde los comentarios
#   de un fichero.
#   El bloque que se muestra va desde la linea que comienza con: ### 
#   hasta la linea que comienza con ####, que estén situadas justo 
#   encima de la función suministrada.
#
# *Nota
#   Las lineas que comienzan por el símbolo * salen de color azul.
#
# *Autor: Iván Osuna Ayuste
#   Linkedin: https://www.linkedin.com/in/ivan-osuna-ayuste
# 
####
function prueba_ayuda(){
    echo No hago nada
}

mostrar_ayuda ./prueba_ayuda.sh prueba_ayuda
