texto=fichero_12331234.ext

# Substrings en bash
fecha=${texto}  # Devuelve el texto completo
fecha=${texto:8:8}  # Devuelve una parte del texto
               #^ Cuántos quiero coger
             #^ El inicio de la extracción (Empieza en 0) 

# Eliminar prefijos
fecha=${texto#*_}  # Devuelve lo que encuentra a partir de un prefijo
fecha=${texto#*.}  # Devuelve lo que encuentra a partir de un prefijo
# Eliminar sufijo
fecha=${texto%.*}  # Devuelve lo que encuentra hasta un sufijo

fecha=${texto#*_}  # Devuelve lo que encuentra a partir de un prefijo
fecha=${fecha%.*}  # Devuelve lo que encuentra hasta un sufijo

texto=fichero_12331234.ext
fecha=${texto: -3:3}  # Devuelve los 3 ultimos caracteres

echo $fecha

####################################################
# ASIGNAR VALORES POR DEFECTO A UNA VARIABLE
####################################################

#variable=HOLA
#if [[ -z "$variable" ]]; then
#    variable2=defecto
#else
#    variable2=${variable}
#fi
variable2=${variable:-defecto}
echo $variable2


####################################################
# ARGUMENTOS
####################################################
# $1 -> Devuelve el primer argumento
# $2 -> Devuelve el segundo argumento
# ...
# $? -> Devuelve el codigo de salida anterior
# $# -> Devuelve el numero de argumentos que me han pasado
shift  # Se come el primer argumento
shift  # Se come el primer argumento
echo $1 $2 $? $#


while [[ $# > 0 ]]
do
    echo $1
    shift
done

#########################################
# Más cosas de textos: REEMPLAZAMIENTOS
#########################################

texto="HOLA AMIGO"
#directorio=${texto//[A ]/_}
nombre=PEPE
directorio=${texto//AMIGO/$nombre}
                #         ^ Carater de destino    
                #   ^ Caracteres que quiero que se reemplacen <<< REGEX
directorio=${directorio,,}   # A MINUSCULAS
directorio=${directorio^^}   # A MAYUSCULAS
echo $directorio

directorio="EsteDirectorio"
directorio=${directorio~~}   # INVERTIR CASE
echo $directorio


lista=( valor1 valor2 )
echo ${lista[1]}
echo -----  ${lista[@]}
for valor in ${lista[@]}
do
    echo ++++++++$valor
done