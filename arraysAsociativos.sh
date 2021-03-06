# Associative arrays: Tabla de datos 2 columas: clave-valor

declare -A servicio1   # Crear un Array Asociativo
servicio1[nombre]="Servidor Web"
servicio1[ip]="192.168.1.1"
servicio1[puerto]="8080"

echo ${servicio1[ip]}

servicio1=( [nombre]="Servidor Email" [ip]="192.168.1.2" [puerto]=25 )
echo ${servicio1[puerto]}

campo="nombre"
echo ${servicio1[$campo]}

unset servicio1[puerto]
echo ${servicio1[puerto]}
echo ${servicio1[ip]}

echo Datos ---${servicio1[@]}
echo Claves ---${!servicio1[@]}

for clave in ${!servicio1[@]}
do
    echo $clave: ${servicio1["$clave"]}
done

servicio1["puerto auxiliar"]=89
echo +++${servicio1["puerto auxiliar"]}

echo Numero de elementos: ${#servicio1[@]}

# SERVICIOS
# 1º Tenemos una carpeta con muchos ficheros dentro... 
#        cada uno contiene informacion de un servicio 
# 2º Los ficheros los leemos al inicio del programa ---> Variables
# 3º Los ficheros solo sirven como almacenamiento persistente (CAMBIO)
#
# Servicio: Nombre IP Puerto
# 1 fichero llamado como el nombre del servicio.properties
#   ip=
#   puerto=
# --->En la carga vamos a tener un array asociativo: nombre del servicio
# ---> Dento 2 campos: IP y PUERTO
# Lista con todos los servicios
# Variables dentro de nuestro script GLOBALES ->> PREFIJO: SERVICIOS_listado= ()
#                                                          SERVICIOS_servicio1= ([]=)
#                                                          SERVICIOS_servicio2= ([]=)

echo $([[ -rw /opt ]])

# Esto NO ES UN ARRAY
variable="valor1 valor2 valor3"
echo $variable
for valor in $variable
do
    echo ___$valor
done
# Quiera eliminar el valor2 -> No puedo directamente
lista=( $variable )
echo ${lista[@]}
for valor in ${lista[@]}
do
    echo ++++$valor
done

unset lista[1]
lista[2]=VALOR3
echo ${lista[@]}
lista[2]=VALOR33
echo ${lista[@]}

listado=( valor1 valor2 valor3 )
echo ${listado[@]}

#declare -A "$nombre_variable"=( [ip]=192.168.1.1 [puerto]=8080 )



########################################
nombre_variable=cacatua
eval $nombre_variable=4

echo $nombre_variable     # cacatua
echo ${nombre_variable}   # cacatua
echo ${!nombre_variable}  # 4
echo $cacatua             # 4


##############
echo
echo
echo
declare -A mapa=([a]=192.168.1.1 [b]=8080)

echo ${mapa[a]}
echo ${mapa[b]}

nombre=mapa[a]
echo ${nombre}
echo ${!nombre}



nombre=SERVICIOS_servicio1[ip]
echo ${!nombre}
###################
eval "declare -A SERVICIOS_servicio1=( [ip]=127.0.0.1 [puerto]=8080 )"

servicio=servicio1
__ip=SERVICIOS_$servicio[ip]
echo ${!__ip}
