#!/bin/bash

# MENU PRINCIPAL
#
#   1 . Gestión Servidores
#   2 . Gestión Servicios
#  [3]. Estado de los Sistemas
#  
#   0 . Salir 
# Qué deseas hacer? 

function mostrar_menu_principal(){
    
    echo MENU PRINCIPAL
    echo
    echo   1 . Gestión Servidores
    echo   2 . Gestión Servicios
    echo  [3]. Estado de los Sistemas
    echo  
    echo   0 . Salir 
    
}

function iniciar_programa(){
 
    mostrar_menu_principal
    
}

iniciar_programa