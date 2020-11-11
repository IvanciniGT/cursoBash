#!/bin/bash

# Servidores: UN UNICO FICHERO : servidores.db
# Servicios:  PARA CADA SERVICIO UN FICHERO
FICHERO_SERVIDORES=./servidores.db
# Datos de un servidor:
# Nombre descriptivo
# Nombre de servidor
# IP(s)
# ID
# 
#
#[id]
#name=valor
#ips=ip1 ip2 ip3
#description=descripcion
#last_boot_time
#
#[id]
#name=valor
#ips=ip1 ip2 ip3
#description=descripcion
#last_boot_time
function menu_servidores(){
    menu --title "Gestión de servidores" \
         --options "Alta de servidor|Baja de servidor|Modificar Servidor|Listado servidores" \
         --functions "echo alta_servidor baja_servidor modificar_servidor listar_servidores" \
         --default "Listado servidores" \
         --exit-option "Volver al menú principal"
}

function alta_servidor(){
    capturar_datos_servidor
} 
function baja_servidor(){
    echo BAJA
}  
function modificar_servidor(){
    echo MODIFICAR
}  
function listar_servidores(){
    echo LISTAR
} 

function capturar_datos_servidor(){
    local __nombre
    local __descripcion
    local __ips
    local __ip
    local __confirmacion
    
    super_read \
       --prompt "Dame el nombre del servidor"\
       --attemps=3 \
       --validation-pattern="^[a-z][a-z0-9_-]*([.][a-z]([a-z0-9_-]*[a-z])?)*$" \
       --exit-message "No he conseguido determinar el nombre del servidor. Abortando..." \
       --failure-message="Debe introducir un nombre válido ( ej: serv-1.prod.es )." \
       __nombre
    if [[ $? > 0 ]]; then return 1;fi

    super_read \
       --prompt "Dame la descripción del servidor"\
       --attemps=3 \
       --validation-pattern="^.{1,50}$" \
       --exit-message "No he conseguido determinar la descripción del servidor. Abortando..." \
       --failure-message="Debe introducir una descripción válido ( Entre 1 y 50 caracteres )." \
       __descripcion
    if [[ $? > 0 ]]; then return 1;fi

    # IPs
    for i in {1..10}
    do
        super_read \
           --prompt "Dame una ip del servidor (Pulse ENTER si no quiere dar más IPs)"\
           --attemps=3 \
           --validation-pattern="^.{0}|(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4})$" \
           --exit-message "No he conseguido determinar una ip válida para el servidor. Abortando..." \
           --failure-message="Debe introducir una ip válida ( ejemplo: 192.168.1.1 )." \
           __ip
        if [[ $? > 0 ]]; then return 1;fi
        if [[ -z "$__ip" ]]; then
            break
        else
            __ips="$__ips $__ip"
        fi
    done
    
    echo 
    echo Datos introducidos:
    echo "  Nombre del servidor: $__nombre"
    echo "  Descripción del servidor: $__descripcion"
    echo "  IPs del servidor: $__ips"
    echo
    super_read \
           --prompt "Quiere dar de alta este servidor"\
           --attemps=3 \
           --validation-pattern="^(s|n)$" \
           --default-value "s"
           --exit-message "Opción no reconocida. Abortando..." \
           --failure-message="Debe introducir s o n." \
           __confirmacion
        
    if [[ "$__confirmacion" == "s" ]]; then
        echo lo guardo
    else
        echo no lo guardo
    fi
    read -n1 -p "Pulse una tecla para continuar"
}