#!/bin/bash

echo "¿Nombre de la carga de trabajo?"

read nombrecarga

echo "--------------------------------------------------"


echo "¿Desea seguir adelante con la ejecución de la carga? ¿s/n?"
read respuesta

if [[ "$respuesta" != "s" ]]; then
	echo "No se ha realizado la ejecución"
	echo "--------------------------------------------------"
	exit 3
fi

echo "--------------------------------------------------"

echo "Ejecutando la carga de trabajo..."
aux=$(tsung -f /home/tsung/couchdb-load/carga/$nombrecarga start)

echo "--------------------------------------------------"


path="${aux: -35}"

cd "/$path"

/usr/lib/tsung/bin/tsung_stats.pl

#echo "Mostrando resultado..."

# firefox report.html

#echo "--------------------------------------------------"
