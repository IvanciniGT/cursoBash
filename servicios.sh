#!/bin/bash

DIRECTORIO_SERVICIOS=./servicios
declare -a SERVICIOS_listado

function cargar_servicios(){
    if [[ -e $DIRECTORIO_SERVICIOS ]]; then
        # Ver si existe
        if [[ ! -d $DIRECTORIO_SERVICIOS ]]; then
            # -d Ver si es un directorio
            # -f Ver si es un fichero
            # -L Ver si es un enlace simbolico
            echo El programa no puede funcionar. Elimine o renombre el archivo $DIRECTORIO_SERVICIOS
            read -n1 -p "Pulse una tecla para continuar..."
            return 1
        else
            if [[ ! -r $DIRECTORIO_SERVICIOS || ! -w $DIRECTORIO_SERVICIOS ]]; then
                echo El programa no puede funcionar. Son requeridos permisos de lectura y escritura sobre el directorio $DIRECTORIO_SERVICIOS
                read -n1 -p "Pulse una tecla para continuar..."
                return 1
            fi
        fi
    else
        mkdir $DIRECTORIO_SERVICIOS
    fi
    ## Se que existe el directorio de servicios y que 
    #  tengo permisos para trabajar en el
    SERVICIOS_listado=$( ls $DIRECTORIO_SERVICIOS/*.properties )
    SERVICIOS_listado=( $SERVICIOS_listado )
    SERVICIOS_listado=( ${SERVICIOS_listado[@]%.properties} )
    SERVICIOS_listado=( ${SERVICIOS_listado[@]#*/*/} )
    #SERVICIOS_listado=${SERVICIOS_listado[@]#*/}
    #SERVICIOS_listado=( $( ls $DIRECTORIO_SERVICIOS ) )
    for servicio in ${SERVICIOS_listado[@]}
    do
        source $DIRECTORIO_SERVICIOS/${servicio}.properties
        eval "declare -A SERVICIOS_${servicio}=( [ip]=$ip [puerto]=$puerto )"
        #echo ${SERVICIOS_servicio1[@]}
    done
}

cargar_servicios

function menu_servicios(){
    menu --title "Gestión de servicios" \
         --options "Alta de servicio|Baja de servicio|Modificar servicio|Listado servicios" \
         --functions "echo alta_servicio baja_servicio modificar_servicio listar_servicios" \
         --default "Listado servicios" \
         --exit-option "Volver al menú principal"
}

function alta_servicio(){
    capturar_datos_servicio
} 
function baja_servicio(){
    obtener_id_servicio borrar_servicio
}  
function modificar_servicio(){
    obtener_id_servicio capturar_datos_servicio
}  
function listar_servicios(){
    leer_fichero
} 

function capturar_datos_servicio(){
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
       --prompt "Dame el nombre del servicio"\
       --attemps=3 \
       --validation-pattern="^[a-z][a-z0-9_-]*([.][a-z]([a-z0-9_-]*[a-z])?)*$" \
       --exit-message "No he conseguido determinar el nombre del servicio. Abortando..." \
       --failure-message="Debe introducir un nombre válido ( ej: serv-1.prod.es )." \
       __nombre
    if [[ $? > 0 ]]; then return 1;fi

    super_read \
       --prompt "Dame la descripción del servicio"\
       --attemps=3 \
       --validation-pattern="^.{1,50}$" \
       --exit-message "No he conseguido determinar la descripción del servicio. Abortando..." \
       --failure-message="Debe introducir una descripción válido ( Entre 1 y 50 caracteres )." \
       __descripcion
    if [[ $? > 0 ]]; then return 1;fi

    # IPs
    for i in {1..10}
    do
        super_read \
           --prompt "Dame una ip del servicio (Pulse ENTER si no quiere dar más IPs)"\
           --attemps=3 \
           --validation-pattern="^.{0}|(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4})$" \
           --exit-message "No he conseguido determinar una ip válida para el servicio. Abortando..." \
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
    echo "  Nombre del servicio: $__nombre"
    echo "  Descripción del servicio: $__descripcion"
    echo "  IPs del servicio: $__ips"
    echo
    super_read \
           --prompt "Quiere dar de alta este servicio"\
           --attemps=3 \
           --validation-pattern="^(s|n)$" \
           --default-value "s" \
           --exit-message "Opción no reconocida. Abortando..." \
           --failure-message="Debe introducir s o n." \
           __confirmacion
        
    if [[ "$__confirmacion" == "s" ]]; then
        if [[ -n "$1" ]]; then
            borrar_servicio "$1"
        fi
        reemplazar_fichero_servicios "$__id" "$__nombre" "$__descripcion" "$__ips"
    else
        echo no lo guardo
    fi
    read -n1 -p "Pulse una tecla para continuar..."
}

function reemplazar_fichero_servicios(){
    echo
}

function guardar_servicio(){
    echo 
    echo [$1] 
    echo name=$2
    echo description=$3
    echo ips=$4
    echo last_boot_time=
    
}

function leer_fichero(){
    echo
}

function imprimir_servicio(){
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

function obtener_id_servicio(){
    local __id_servicio
    
    for intentos in {1..3}
    do
        super_read \
           --prompt "Dame el ID del servicio o su nombre"\
           --attemps=1 \
           --validation-pattern="^([a-z][a-z0-9_-]*([.][a-z]([a-z0-9_-]*[a-z])?)*)|([a-z0-9]{8}-([a-z0-9]{4}-){3}[a-z0-9]{12})$" \
           --exit-message "" \
           --failure-message="Identificador o nombre de servicio incorrecto." \
           __id_servicio
        if [[ $? == 0 ]];then
            # Comprobar que el id de servicio existe ¿?
            local __ocurrencias=$(cat $FICHERO_servicios | grep -c "\[$__id_servicio\]")
            let __ocurrencias+=$(cat $FICHERO_servicios | grep -c "name=$__id_servicio")
            
            case "$__ocurrencias" in
              0)
                echo El servicio $__id_servicio NO se ha encontrado.
              ;;
              1)
                echo El servicio $__id_servicio se ha encontrado.
                $1 "$__id_servicio"
                return 0
              ;;
              *)
                echo El servicio $__id_servicio aparece varias veces. Revise su configuración.
              ;;
            esac
        fi
    done
    echo servicio no reconocido. Abortando... >&2
    return 1
}

function borrar_servicio(){ 
    echo
}