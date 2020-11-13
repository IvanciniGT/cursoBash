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
        #declare -A SERVICIOS_servicio1=( [ip]=192.168.1.1 [puerto]=8080 )
        eval "declare -g -A SERVICIOS_${servicio}=( [ip]=$ip [puerto]=$puerto )"
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
    titulo "Procesando alta de servicio"
    echo 
    capturar_datos_servicio
} 
function baja_servicio(){
    titulo "Procesando baja de servicio"
    echo 
    obtener_id_servicio borrar_servicio
}  
function modificar_servicio(){
    titulo "Procesando modificación de servicio"
    echo 
    obtener_id_servicio capturar_datos_servicio
}  
function listar_servicios(){
    titulo "Listado de servicios"
    echo 

    amarillo "$(imprimir_servicio SERVICIO IP PUERTO)"
    amarillo "$(linea)"
    for servicio in ${SERVICIOS_listado[@]}
    do
        local __ip=SERVICIOS_$servicio[ip]
        local __puerto=SERVICIOS_$servicio[puerto]
        imprimir_servicio "$servicio" "${!__ip}" "${!__puerto}"
    done 
    amarillo "$(linea)"

    pausa
} 

function capturar_datos_servicio(){
    local __nombre
    local __ip=""
    local __puerto=""
    
    echo
    
    if [[ -z "$1" ]]
    then
        super_read \
           --prompt "Dame el nombre del servicio"\
           --attemps=3 \
           --validation-pattern="^[a-z][a-z0-9_-]*([.][a-z]([a-z0-9_-]*[a-z])?)*$" \
           --exit-message "  No he conseguido determinar el nombre del servicio. Abortando..." \
           --failure-message="  Debe introducir un nombre válido ( ej: serv-1.prod.es )." \
           __nombre
        if [[ $? > 0 ]]; then return 1;fi
    else
        __nombre=$1
        local __ip=SERVICIOS_$1[ip]
        __ip=${!__ip}
        local __puerto=SERVICIOS_$1[puerto]
        __puerto=${!__puerto}
    fi

    super_read \
       --prompt "Dame la ip del servicio"\
       --attemps=3 \
       --validation-pattern="^(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4})$" \
       --exit-message "  No he conseguido determinar una ip válida para el servicio. Abortando..." \
       --failure-message="  Debe introducir una ip válida ( ejemplo: 192.168.1.1 )." \
       --default-value="$__ip" \
       __ip
    if [[ $? > 0 ]]; then return 1;fi

    super_read \
       --prompt "Dame el puerto del servicio"\
       --attemps=3 \
       --validation-pattern="^[0-9]{2,5}$" \
       --exit-message "  No he conseguido determinar un puerto válido para el servicio. Abortando..." \
       --failure-message="  Debe introducir un puerto válido ( ejemplo: 192.168.1.1 )." \
       --default-value="$__puerto" \
       __puerto
    if [[ $? > 0 ]]; then return 1;fi

    echo 
    amarillo "Datos introducidos:"
    amarillo "  Nombre del servicio: $__nombre"
    amarillo "  IP del servicio: $__ip"
    amarillo "  Puerto del servicio: $__puerto"
    echo
    super_read \
           --prompt "Quiere dar de alta este servicio"\
           --attemps=3 \
           --validation-pattern="^(s|n)$" \
           --default-value "s" \
           --exit-message "  Opción no reconocida. Abortando..." \
           --failure-message="  Debe introducir s o n." \
           __confirmacion
        
    echo
    if [[ "$__confirmacion" == "s" ]]; then
        reemplazar_fichero_servicio "$__nombre" "$__ip" "$__puerto"
    else
        echo
        fondo_azul " Operación anulada a petición del usuario "
    fi
    echo
    pausa
}

function reemplazar_fichero_servicio(){
    fondo_azul " Guardando servicio... "
    eval "declare -g -A SERVICIOS_${1}=( [ip]=$2 [puerto]=$3 )"
    if [[ ! ${SERVICIOS_listado[@]} =~ (^|[[:space:]])"$__nombre"($|[[:space:]]) ]]
    then
        SERVICIOS_listado+=("$1")
    fi
    echo "$(guardar_servicio $2 $3)" > $DIRECTORIO_SERVICIOS/$1.properties
    fondo_verde "   Servicio guardado   "
}

function guardar_servicio(){
    echo ip=$1
    echo puerto=$2
}

function imprimir_servicio(){
    printf "%-40s %-20s %10s\n" "$1" "$2" "$3"
}

#ID                                      NOMBRE   IPs                    Descripcion
#6b9ebd21-7a07-4bd5-a869-53e008eb15e2    ivan     192.168.1.1 8.8.8.8    Lo que entre.... hasta el ancho de la pantalla
#6b9ebd21-7a07-4bd5-a869-53e008eb15e2    ivan     192.168.1.1 8.8.8.8    Lo que entre.... hasta el ancho de la pantalla

function obtener_id_servicio(){
    local __nombre
    
    for intentos in {1..3}
    do
        super_read \
           --prompt "Dame el nombre del servicio"\
           --attemps=1 \
           --validation-pattern="^([a-z][a-z0-9_-]*([.][a-z]([a-z0-9_-]*[a-z])?)*)|([a-z0-9]{8}-([a-z0-9]{4}-){3}[a-z0-9]{12})$" \
           --exit-message="  Nombre de servicio incorrecto." \
           __nombre
        if [[ $? == 0 ]];then
            # Comprobar que el id de servicio existe ¿?
            if [[ ${SERVICIOS_listado[@]} =~ (^|[[:space:]])"$__nombre"($|[[:space:]]) ]]
            then
                verde "  El servicio $__nombre se ha encontrado."
                $1 "$__nombre"
                return 0
            else
                error "  El servicio $__nombre NO se ha encontrado."
            fi
        fi           
    done
    error "  Abortando..." >&2
    pausa
    return 1
}

function borrar_servicio(){ 
    echo
    echo $1
    fondo_azul " Borrando servicio... "
    local __ip=SERVICIOS_$1[ip]
    __ip=${!__ip}
    local __puerto=SERVICIOS_$1[puerto]
    __puerto=${!__puerto}

    rm $DIRECTORIO_SERVICIOS/$1.properties
    SERVICIOS_listado=( "${SERVICIOS_listado[@]/$1}" )
    
    fondo_verde "  Servicio eliminado  "
    echo
    titulo "Datos del servicio eliminado:"
    amarillo "Nombre: $1"
    amarillo "IP: $__ip"
    amarillo "Puerto: $__puerto"
    azul $(linea)
    echo 
    pausa

}