#!/bin/bash

source ../gui/menu.sh
source ../gui/formatos.sh

function cuenta(){
    for i in {1..5}
    do
        echo CUENTO: $i
        sleep 2
    done
    
}

lee() {
  tin=$(date +%s )
  while read -r linea 
  do
      echo "---$linea"
      tm=$(date +%s )
      if (( $tin + 5 < $tm))
      then
        echo TIMEOUT!!!
        exit 1
      fi
      
      
  done
  exit 0
}

(cuenta | lee )&

pid=$!
echo $pid
for i in {1..4}
do
    echo YO SIGO... 
    sleep 3
done

wait $pid
estado=$?
echo ESTADO: $estado 
[[ $estado == 0 ]] && echo GUAY || echo ERROR


 
coproc bar { cuenta ; }

sleep 1
read foo <&${bar[0]}
echo "1 $foo"
 
read foo <&${bar[0]}
echo "2 $foo"

wait $bar_PID
echo YA ACABO