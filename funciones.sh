function saluda(){
    echo HOLA $1!
}

#saluda "Ivan Osuna"

funcion_a_ejecutar="saluda \"Ivan Osuna\""

echo $funcion_a_ejecutar
eval $funcion_a_ejecutar
#==> saluda Ivan Osuna