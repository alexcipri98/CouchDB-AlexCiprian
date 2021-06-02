#!/bin/bash
ulimit -n 32000
#Las siguientes líneas toman los valores deseados por el usuario
echo "Número de bases a insertar:"

read num

echo "--------------------------------------------------"

echo "Se añadirán $num bases de datos al sistema, ¿s/n?"
read boleano
echo "--------------------------------------------------"


#Comprobación de valores
if [[ "$num" -lt 0 ]]; then
	echo "error 1"
	exit 1 #Error en el numero de bases de datos
fi
aux1="s"
if [[ "$boleano" != "$aux1" ]]
then
	echo 'error 2'
	exit 2 #Error en el boleano
fi

#Creación de las bases de datos
url="http://admin:--------@--------/test"
contador=0
cat <<EOF> /tmp/userlist.csv
;test0000
EOF

#Inserción de 500 documentos
echo Añadir 500 documentos por bd, ¿s/n?
read boleano2
echo "--------------------------------------------------"

if [[ "$boleano2" = "$aux1" ]]; then
 contador2=0
 num2=500
 echo "Creando en bloque ${num2} documentos"
 json='{"docs":[]}'
 while [ "$contador2" -lt "$num2" ] 
 do
	json=$( jq -c '.docs += [{"name":"test"}]' <<< "${json}" )
	contador2=$((contador2 + 1))
 done <<< $json
fi

while [ "$contador" -lt "$num" ]
do
	aux=$(printf '%04d' $contador)
	newurl="$url$aux"
	if [[ "$contador" != 0 ]]; then
		cat <<EOF >> /tmp/userlist.csv
;test$aux
EOF
	fi
	#response=$(sudo curl -X PUT "$newurl")
	curl -X PUT "$newurl"
	contador=$((contador + 1))
	if [[ "$boleano2" = "$aux1" ]]; then
		# contador2=0
		# num2=500
		# json='{"docs":[{]}'
		# while [ "$contador2" -lt "$num2" ]
		# do
		#	json=$( jq -c '.docs += [{"name":"test"}]' <<< "${json}" )
		#	contador2=$((contador2 + 1))
		#done <<< $json
                #echo $json
		curl -o /dev/null -w '%{http_code}' -X POST "$newurl/_bulk_docs" -H "Content-Type: application/json" -d "${json}"
	fi
done

#############################
#Obtener todas las bds userlist
#500 por cada
##############################
echo "--------------------------------------------------"

./ejecucion.sh


echo "Se borraran $num bases de datos del sistema, ¿s/n?"

read boleano

echo "--------------------------------------------------"

if [[ "$boleano" != "$aux1" ]]
then
	echo 'no ha confirmado, se para la ejecución'
	exit 2 #Error en el boleano
fi

contador2=0
while [ "$contador2" -lt "$num" ]
do
	aux=$(printf '%04d' $contador2)
	newurl="$url$aux"
	#response=$(sudo curl -X PUT "$newurl")
	curl -X DELETE "$newurl"
	contador2=$((contador2 + 1))
done
echo "--------------------------------------------------"

echo "Sistema limpio"
