#!/bin/bash

source ./super_read.sh

super_read -p "Reinicio el servidor" -d "si" -v "^(si|no)$" reinicio

super_read --prompt "Reinicio el servidor" --default-value "si" \
           --validation-pattern "^(si|no)$" reinicio 

super_read -d "si" \
   --prompt="Reinicio el servidor" \
   --attemps=3 \
   --exit-message "No he conseguido determinar si desea reiniciar el servidor. Abortando..." \
   --failure-message="Debe contestar si o no." \
   -a 2 \
   reinicio 

#CASO DE ERROR
super_read -p "Mensaje" "Mensaje2" var2
            
echo $mi_edad
echo $reinicio