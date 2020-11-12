#!/bin/bash

source menu.sh
source servidores.sh
source servicios.sh


function menu_principal(){
    menu --title "Menu principal" \
         --options "Gestión Servidores|Gestión Servicios|Estado de los Sistemas" \
         --functions "salida menu_servidores menu_servicios menu_estado" \
         --default "Estado de los Sistemas" \
         --exit-option "Salir del programa"
}

function menu_estado(){
    menu --title "Estado de los Sistemas" \
         --options "Estado de los servidores|Estado de los servicios" \
         --functions "echo estado_servidores estado_servicios" \
         --default "Estado de los servidores" \
         --exit-option "Volver al menú principal"
}

function salida(){
    clear
    echo Gracias por utilizar esta aplicación. Hasta pronto !
}
function iniciar_programa(){
    menu_principal
}

iniciar_programa