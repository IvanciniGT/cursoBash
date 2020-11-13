
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
