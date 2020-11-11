#!/bin/bash

source menu.sh
source servidores.sh


function menu_principal(){
    menu --title "Menu principal" \
         --options "Gestión Servidores|Gestión Servicios|Estado de los Sistemas" \
         --functions "salida menu_servidores menu_servicios menu_estado" \
         --default "Estado de los Sistemas" \
         --exit-option "Salir del programa"
}


function menu_servicios(){
    menu --title "Gestión de servicios" \
         --options "Alta de servicio|Baja de servicio|Modificar servicio|Listado servicios" \
         --functions "echo alta_servicio baja_servicio modificar_servicio listar_servicios" \
         --default "Listado servicios" \
         --exit-option "Volver al menú principal"
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