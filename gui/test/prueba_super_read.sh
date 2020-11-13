#!/bin/bash

source ../super_read.sh

super_read -h

echo
echo

super_read \
   --default-value "si" \
   --attemps=3 \
   --validation-pattern="^(si|no)$" \
   --exit-message "No he conseguido determinar si desea reiniciar el servidor. Abortando..." \
   --failure-message="Debe contestar si o no." \
   --prompt="Reinicio el servidor" \
   reinicio 

echo Se ha introducido el valor: $reinicio