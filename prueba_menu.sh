#!/bin/bash

source menu.sh

NOMBRE_MENU="Menu principal"
OPCIONES_MENU="Gestión Servidores|Gestión Servicios|Estado de los Sistemas"
FUNCIONES_MENU="salida servidores servicios estado"
VALOR_POR_DEFECTO="Gestión Servicios"
OPCION_SALIDA="Salir del programa"

function salida(){
    echo SALIDA
}
function servicios(){
    echo SERVICIOS
}
function servidores(){
    echo SERVIDORES
}
function estado(){
    echo ESTADO
}

menu --title "$NOMBRE_MENU" \
     --options "$OPCIONES_MENU" \
     --functions "$FUNCIONES_MENU" \
     --default "$VALOR_POR_DEFECTO" \
     --exit-option "$OPCION_SALIDA"
