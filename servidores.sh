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
    obtener_id_servidor borrar_servidor
}  
function modificar_servidor(){
    obtener_id_servidor capturar_datos_servidor
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
    local __id=$1
    
    if [[ -z "$1" ]]; then 
        __id=$( uuidgen )
    fi
    
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
        if [[ -n "$1" ]]; then
            borrar_servidor "$1"
        fi
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

function obtener_id_servidor(){
    local __id_servidor
    
    for intentos in {1..3}
    do
        super_read \
           --prompt "Dame el ID del servidor o su nombre"\
           --attemps=1 \
           --validation-pattern="^([a-z][a-z0-9_-]*([.][a-z]([a-z0-9_-]*[a-z])?)*)|([a-z0-9]{8}-([a-z0-9]{4}-){3}[a-z0-9]{12})$" \
           --exit-message "" \
           --failure-message="Identificador o nombre de servidor incorrecto." \
           __id_servidor
        if [[ $? == 0 ]];then
            # Comprobar que el id de servidor existe ¿?
            local __ocurrencias=$(cat $FICHERO_SERVIDORES | grep -c "\[$__id_servidor\]")
            let __ocurrencias+=$(cat $FICHERO_SERVIDORES | grep -c "name=$__id_servidor")
            
            case "$__ocurrencias" in
              0)
                echo El servidor $__id_servidor NO se ha encontrado.
              ;;
              1)
                echo El servidor $__id_servidor se ha encontrado.
                $1 "$__id_servidor"
                return 0
              ;;
              *)
                echo El servidor $__id_servidor aparece varias veces. Revise su configuración.
              ;;
            esac
        fi
    done
    echo Servidor no reconocido. Abortando... >&2
    return 1
}

function borrar_servidor(){ # $1 nombre o id del servidor que quiero borrar
    local __a_borrar=0
    > servidor.tmp # Inicializar el fichero temporal
    > servidores.nuevo # Inicializar el fichero temporal
    while read -r linea
    do
        if [[ "$linea" =~ ^\[ ]]; then
            if [[ "$__a_borrar" == "1" ]]; then
                cat servidor.tmp > servidor.borrado
            else
                cat servidor.tmp >> servidores.nuevo
            fi
            > servidor.tmp
            __a_borrar=0
        fi

        echo $linea >> "servidor.tmp" # Información de 1 servidor

        if [[ "$linea" == "name=$1" || "$linea" == "[$1]" ]]; then
            __a_borrar=1
        fi
    done < $FICHERO_SERVIDORES
    
    if [[ "$__a_borrar" == "1" ]]; then
        cat servidor.tmp > servidor.borrado
    else
        cat servidor.tmp >> servidores.nuevo
    fi
    rm servidor.tmp
    rm $FICHERO_SERVIDORES
    mv servidores.nuevo $FICHERO_SERVIDORES
    
    echo El servidor ha sido eliminado sin problemas. Datos del servidor eliminado:
    cat servidor.borrado
    rm servidor.borrado
    echo 
    read -n1 -p "Pulse cualquier tecla para continuar... "
    
}