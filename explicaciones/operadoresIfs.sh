#Operadores de comparación textos:
    #   == = -> Equals
    #   != -> Not equals
    #   < -> Orden ASCII
    #   > -> ORDEN segun ASCII
    #   -z ==>>> [[ -z "$VAR" ]] => Que la variable esté vacia
    #   -n ==>>> [[ -n "$VAR" ]] => Que la variable NO esté vacia
    #   -v ==>>> [[ -v VAR ]] => Que la variable esté asignada
    #   =~ ===> [[ "$texto" =~ $patron ]] Si un texto cumple con un patrón
   
# Operadores de comparación numérica:
    #   -eq -> Equals
    #   -ne -> Not equals
    #   -lt -> Litter than
    #   -gt -> Greater than
    #   -le -> <=
    #   -ge -> >=

# Operadores con DOBLE PARENTESIS (())
    # ==
    # !=
    # > >=
    # < <=
    # + - * / % (resto de la division entera)
    # 13%3 -> 1
    
# Operadores de ficheros
    # -d Ver si es un directorio
    # -f Ver si es un fichero
    # -L Ver si es un enlace simbolico

    # -r Permisos de lectura
    # -w Permisos de escritura
    # -x Permisos de ejecucion

    # -e Ver si existe un fichero o directorio

# CONDICIONALES
# Ejecutar un codigo pero solo bajo ciertas condiciones
variable=5
if [ $variable == 3 ]; then
   echo La variable vale 3
else
   echo La variable NO vale 3
fi