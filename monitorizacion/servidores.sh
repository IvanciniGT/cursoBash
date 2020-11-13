#!/bin/bash

FICHERO_SERVIDORES=./servidores/servidores.db

function menu_servidores(){
    menu --title "Gestión de servidores" \
         --options "Alta de servidor|Baja de servidor|Modificar Servidor|Listado servidores" \
         --functions "echo alta_servidor baja_servidor modificar_servidor listar_servidores" \
         --default "Listado servidores" \
         --exit-option "Volver al menú principal"
}

function alta_servidor(){
    titulo "Procesando alta de servidor"
    echo 
    capturar_datos_servidor
} 
function baja_servidor(){
    titulo "Procesando baja de servidor"
    echo 
    obtener_id_servidor borrar_servidor
}  
function modificar_servidor(){
    titulo "Procesando modificación de servidor"
    echo 
    obtener_id_servidor capturar_datos_servidor
}  
function listar_servidores(){
    titulo "Listado de servidores"
    echo 
    leer_fichero
} 

function capturar_datos_servidor(){
    local __nombre
    local __descripcion
    local __ips
    local __ip
    local __confirmacion
    local __id=$1
    local __nuevo=""
    local __nueva=""
    
    if [[ -z "$1" ]]; then 
        __id=$( uuidgen )
    else
        __nuevo=" nuevo"
        __nueva=" nuevo"
    fi
    echo
    super_read \
       --prompt "Dame el$__nuevo nombre del servidor"\
       --attemps=3 \
       --validation-pattern="^[a-z][a-z0-9_-]*([.][a-z]([a-z0-9_-]*[a-z])?)*$" \
       --exit-message "  No he conseguido determinar el nombre del servidor. Abortando..." \
       --failure-message="  Debe introducir un nombre válido ( ej: serv-1.prod.es )." \
       __nombre
    if [[ $? > 0 ]]; then return 1;fi

    super_read \
       --prompt "Dame la$__nueva descripción del servidor"\
       --attemps=3 \
       --validation-pattern="^.{1,50}$" \
       --exit-message "  No he conseguido determinar la descripción del servidor. Abortando..." \
       --failure-message="  Debe introducir una descripción válido ( Entre 1 y 50 caracteres )." \
       __descripcion
    if [[ $? > 0 ]]; then return 1;fi

    # IPs
    echo 
    echo Ahora introduzca de una en una las direcciones IP del servidor. 
    echo Cuanto termine simplemente pulse ENTER.
    for i in {1..10}
    do
        super_read \
           --prompt "IP del servidor"\
           --attemps=3 \
           --validation-pattern="^.{0}|(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4})$" \
           --exit-message "  No he conseguido determinar una ip válida para el servidor. Abortando..." \
           --failure-message="  Debe introducir una ip válida ( ejemplo: 192.168.1.1 )." \
           __ip
        if [[ $? > 0 ]]; then return 1;fi
        if [[ -z "$__ip" ]]; then
            break
        else
            __ips="$__ips$__ip "
        fi
    done
    
    echo 
    amarillo "Datos introducidos:"
    amarillo "  Nombre$__nuevo del servidor: $__nombre"
    amarillo "  Descripción$__nuevo del servidor: $__descripcion"
    amarillo "  IPs del servidor: $__ips"
    echo
    super_read \
           --prompt "Quiere dar de alta este servidor"\
           --attemps=3 \
           --validation-pattern="^(s|n)$" \
           --default-value "s" \
           --exit-message "  Opción no reconocida. Abortando..." \
           --failure-message="  Debe introducir s o n." \
           __confirmacion
        
    if [[ "$__confirmacion" == "s" ]]; then
        if [[ -n "$1" ]]; then
            borrado=$(borrar_servidor_silencioso "$1")
        fi
        reemplazar_fichero_servidores "$__id" "$__nombre" "$__descripcion" "$__ips"
    else
        echo
        fondo_azul " Operación anulada a petición del usuario "
    fi
    pausa
}

function reemplazar_fichero_servidores(){
    echo
    fondo_azul " Guardando servidor... "
    guardar_servidor "$@" >> $FICHERO_SERVIDORES
    fondo_verde "   Servidor guardado   "
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
    amarillo "$(imprimir_servidor "ID" "NOMBRE" "DESCRIPCION" "IPS")"
    amarillo "$(linea)"
    while read -r linea
    do
        # [id]
        # name=valor
        # ips=ip1 ip2 ip3
        # description=descripcion
        # last_boot_time
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
    amarillo "$(linea)"
    pausa
}

function imprimir_servidor(){
    local __ips=( $4 )
    local __numero_ips=${#__ips[@]}
    local __ancho=$( tput cols )
    local __ancho_descripcion=$__ancho
    let __ancho_descripcion-=69
    local __descripcion=$3

    __descripcion="${__descripcion:0:$__ancho_descripcion}..."
    printf "%-37s %-15s %15s   %-5s\n" "$1" "$2" "${__ips[0]}" "$__descripcion"
    for i in $( eval echo {1..$__numero_ips} )
    do
        [[ -z "${__ips[$i]}" ]] && continue
        printf "%-37s %-15s %15s   %-5s\n" "" "" "${__ips[$i]}" ""
    done
}

#ID                                      NOMBRE   IPs                    Descripcion
#6b9ebd21-7a07-4bd5-a869-53e008eb15e2    ivan     192.168.1.1 8.8.8.8    Lo que entre.... hasta el ancho de la pantalla
#6b9ebd21-7a07-4bd5-a869-53e008eb15e2    ivan     192.168.1.1 8.8.8.8    Lo que entre.... hasta el ancho de la pantalla

function obtener_id_servidor(){
    local __id_servidor
    
    echo
    for intentos in {1..3}
    do
        super_read \
           --prompt "Dame el ID del servidor o su nombre"\
           --attemps=1 \
           --validation-pattern="^([a-z][a-z0-9_-]*([.][a-z]([a-z0-9_-]*[a-z])?)*)|([a-z0-9]{8}-([a-z0-9]{4}-){3}[a-z0-9]{12})$" \
           --exit-message="  Identificador o nombre de servidor incorrecto." \
           __id_servidor
        if [[ $? == 0 ]];then
            # Comprobar que el id de servidor existe ¿?
            local __ocurrencias=$(cat $FICHERO_SERVIDORES | grep -c "\[$__id_servidor\]")
            let __ocurrencias+=$(cat $FICHERO_SERVIDORES | grep -c "name=$__id_servidor")
            
            case "$__ocurrencias" in
              0)
                rojo " El servidor $__id_servidor NO se ha encontrado."
              ;;
              1)
                verde " El servidor $__id_servidor se ha encontrado."
                echo
                $1 "$__id_servidor"
                return 0
              ;;
              *)
                rojo " El servidor $__id_servidor aparece varias veces. Revise su configuración."
              ;;
            esac
        fi
    done
    rojo "Servidor no reconocido. Abortando..." >&2
    return 1
}

function borrar_servidor(){ # $1 nombre o id del servidor que quiero borrar
    fondo_azul " Borrando servidor... "
    local datos=$(borrar_servidor_silencioso $1)
    fondo_verde "  Servidor eliminado  "
    echo
    titulo "Datos del servidor eliminado:"
    amarillo "$datos"
    azul $(linea)
    echo 
    pausa
    
}


function borrar_servidor_silencioso(){ # $1 nombre o id del servidor que quiero borrar
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
    
    cat servidor.borrado
    rm servidor.borrado
}