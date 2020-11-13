function saluda(){
    echo HOLA $1!
}

#saluda "Ivan Osuna"

funcion_a_ejecutar="saluda \"Ivan Osuna\""

echo $funcion_a_ejecutar
eval $funcion_a_ejecutar
#==> saluda Ivan Osuna


function saluda(){
    echo HOLA $1 - $2!!!
}

saluda "IVAN OSUNA" \
                    Ayuste
        
saluda JERONIMO
saluda JORGES

function concatena (){
    return $1-$2
}

concatena Ivan Osuna

#return # Devuelve el CODIGO DE SALIDA DE EJECUCION DE MI PROGRAMA

        # 0 BIEN
        # No sea un 0 -> ERROR

function prueba(){
    echo HOLA
    return 0
    echo MAS HOLAS !!!
}
prueba

function suma(){
    let resultado=$1+$2
    echo $resultado
}

mi_variable=$(suma 1 3)
echo $mi_variable
