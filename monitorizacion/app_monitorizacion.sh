#!/bin/bash

source ../gui/menu.sh
source ../gui/formatos.sh
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
    verde " __   __  _______  __    _  ___   _______  _______  ______    ___   _______  _______ "
    verde "|  |_|  ||       ||  |  | ||   | |       ||       ||    _ |  |   | |       ||       | ®"
    verde "|       ||   _   ||   |_| ||   | |_     _||   _   ||   | ||  |   | |____   ||    ___|"
    verde "|       ||  | |  ||       ||   |   |   |  |  | |  ||   |_||_ |   |  ____|  ||   |___ "
    verde "|       ||  |_|  ||  _    ||   |   |   |  |  |_|  ||    __  ||   | | ______||    ___|"
    verde "| ||_|| ||       || | |   ||   |   |   |  |       ||   |  | ||   | | |_____ |   |___ "
    verde "|_|   |_||_______||_|  |__||___|   |___|  |_______||___|  |_||___| |_______||_______|"
    verde
    verde "Gracias por utilizar esta aplicación. Hasta pronto !"
    echo
}
function iniciar_programa(){
    menu_principal
}

iniciar_programa