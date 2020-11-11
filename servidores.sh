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
    leer_fichero
} 

function capturar_datos_servidor(){
    local __nombre
    local __descripcion
    local __ips
    local __ip
    local __confirmacion
    local __id
    
    __id=$( uuidgen )
    
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
            __ips="$__ips$__ip "
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
           --default-value "s" \
           --exit-message "Opción no reconocida. Abortando..." \
           --failure-message="Debe introducir s o n." \
           __confirmacion
        
    if [[ "$__confirmacion" == "s" ]]; then
        reemplazar_fichero_servidores "$__id" "$__nombre" "$__descripcion" "$__ips"
    else
        echo no lo guardo
    fi
    read -n1 -p "Pulse una tecla para continuar..."
}

function reemplazar_fichero_servidores(){
    echo Guardando fichero...
    guardar_servidor "$@" >> $FICHERO_SERVIDORES
    echo Fichero guardado...
}

function guardar_servidor(){
    echo 
    echo [$1] 
    echo name=$2
    echo description=$3
    echo ips=$4
    echo last_boot_time=
    
}

function leer_fichero(){
    local __id
    local __nombre
    local __descripcion
    local __ips

    imprimir_servidor "ID" "NOMBRE" "DESCRIPCION" "IPS"

    while read -r linea
    do
         case "$linea" in
          name=*)
            __nombre=${linea#name=}
          ;;
          ips=*)
            __ips="${linea#ips=}"
          ;;
          description=*)
            __descripcion="${linea#description=}"
          ;;
          \[*\])
            # Imprimir los datos anteriores... Si los tengo
            if [[ -n "$__id" ]]; then
                imprimir_servidor "$__id" "$__nombre" "$__descripcion" "$__ips"
            fi
            __id=${linea#[}
            __id=${__id%]}
          ;;
          esac
    done < $FICHERO_SERVIDORES
    if [[ -n "$__id" ]]; then
        imprimir_servidor "$__id" "$__nombre" "$__descripcion" "$__ips"
    fi
    read -n1 -p "Pulsa para continuar..."
}

function imprimir_servidor(){
    local __ips=( $4 )
    local __numero_ips=${#__ips[@]}
    local __ancho=$( tput cols )
    local __ancho_descripcion=$__ancho
    let __ancho_descripcion-=88
    local __descripcion=$3
    
    __descripcion="${__descripcion:0:$__ancho_descripcion}..."
    printf "%-40s %-20s %20s   %-5s\n" "$1" "$2" "${__ips[0]}" "$__descripcion"
    for i in $( eval echo {1..$__numero_ips} )
    do
        printf "%-40s %-20s %20s   %-5s\n" "" "" "${__ips[$i]}" ""
    done
}

#ID                                      NOMBRE   IPs                    Descripcion
#6b9ebd21-7a07-4bd5-a869-53e008eb15e2    ivan     192.168.1.1 8.8.8.8    Lo que entre.... hasta el ancho de la pantalla
#6b9ebd21-7a07-4bd5-a869-53e008eb15e2    ivan     192.168.1.1 8.8.8.8    Lo que entre.... hasta el ancho de la pantalla