#!/bin/bash

mkdir -p eventos #veo si existe una carpeta llamada eventos si no existe se crea
cd eventos || exit

rm -f *.txt #impio archivos txt antiguos, para no llenar de cosas

start_time=$(date +%s.%N) #para medir el tiempo

# Tiempo inicial ficticio (segundos desde epoch)
current_time=$(date +%s)

# Variables para promedio
prev_time=0
sum_diff=0

# Genero los eventos aleatorios, son 1000 y toman valores de 0 a 10 de manera random
for i in $(seq -w 1 1000); do
    # Intervalo aleatorio entre 1 y 10 segundos
    delta=$(( RANDOM % 10 + 1 ))
    current_time=$(( current_time + delta ))

    # Timestamp legible
    timestamp=$(date -d @"$current_time" +"%Y-%m-%d %H:%M:%S")

    neutrinos=$(( RANDOM % 11 ))  # número aleatorio entre 0 y 10
    echo "$timestamp $neutrinos" > "$i.txt"

    # Calcular diferencia para promedio
    if [ $prev_time -ne 0 ]; then
        diff=$(( current_time - prev_time ))
        sum_diff=$(( sum_diff + diff ))
    fi
    prev_time=$current_time
done

cat *.txt > ../results.txt # voy agrupando los  archivos en uno solo

# para tener el tiempo promedio entre eventos, esto es porque estoy trabajando en windows y tiene problemas con una libreria :C
if [ 999 -ne 0 ]; then
    avg_time=$(echo "scale=2; $sum_diff / 999" | bc) # 999 diferencias entre 1000 eventos
else
    avg_time=0
fi

echo "Tiempo promedio entre eventos (s): $avg_time" > ../performance.txt

cd ..


git add eventos/*.txt
git commit -m "Eventos de neutrinos detectados"
git add simulate.sh results.txt performance.txt
git commit -m "Script funcional y resultados comprobados"
git push
