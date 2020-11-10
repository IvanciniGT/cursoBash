
###
#   SECUENCIA DE CARACTERES ----- MODIFICADOR DE OCURRENCIA
#     a     
#     A
#     aA     Literamente debe aparecer aA
#     [aA]   UNA de las DOS (Esto es como un o)
#     [a-z]
#     [a-zA-Z]
#     [0-9]
#     .      Cualquier caracter
#                                       NO PONER NADA => 1
#                                       ? => 0 o 1
#                                       * => De 0 a infinito
#                                       + => De 1 a infinito
#                                       {4} => 4 veces
#                                       {4,6} => De 4 a 6 veces
#                                       {,7} => Entre 0 y 7
#                                       {7,} => Al menos 7 veces

# ^ => Que comience por
# $ => Que acabe por
# | => Significa una 'o' 

texto='tal vez no'

patron="(si|no)$"

# Al mirar el patrón, se busca si el patón se encuentra en el texto o no
if [[ "$texto" =~ $patron ]]; then
    echo CUMPLE
else
    echo NO CUMPLE
fi