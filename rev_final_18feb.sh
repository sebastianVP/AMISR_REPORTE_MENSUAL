#!/bin/bash

# Verificar si el usuario ha proporcionado el mes y el año
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Uso: $0 <directorio> <año-mes>"
    echo "Ejemplo: $0 /ruta/al/directorio 2024-01"
    exit 1
fi

# Directorio a analizar (pasado como primer argumento)
DIRECTORIO="$1"

# Mes y año a procesar (pasado como segundo argumento)
MES_ANIO="$2"

DIAS_ATRAS=${3:-1}  # Si no se especifica, por defecto es 1 día atrás

# Prefijo basado en el mes y año proporcionado
PREFIJO="$MES_ANIO"

# Obtener la fecha del día deseado
FECHA_ANALIZAR=$(date -d "$DIAS_ATRAS days ago" +%Y-%m-%d)

# Archivo de salida con la fecha actual en el nombre
# SALIDA="reporte_directorios_desk_$(date +%Y-%m).csv"

# Archivo de salida con la fecha actual en el nombre
SALIDA="reporte_directorios_desk_2025.csv"

# Encabezado del CSV
echo "Fecha,Directorio,Tamano" > "$SALIDA"

#echo "📂 Procesando directorios en $DIRECTORIO que comienzan con '$PREFIJO'..."
#echo "---------------------------------------"

echo "📂 Procesando directorios en $DIRECTORIO para la fecha $FECHA_ANALIZAR..."
echo "---------------------------------------"



# Si el archivo no existe, generar datos desde el 01 de enero de 2025
if [ ! -f "$SALIDA" ]; then
    echo "🆕 Archivo de reporte no encontrado. Se generará desde 01 de enero de 2025 hasta $FECHA_ANALIZAR..."
    echo "Fecha,Directorio,Tamano" > "$SALIDA"
    
    # Definir fecha de inicio
    FECHA_INICIO="2025-01-01"
    
    while [[ "$FECHA_INICIO" < "$FECHA_ANALIZAR" ]] || [[ "$FECHA_INICIO" == "$FECHA_ANALIZAR" ]]; do
        echo "📅 Procesando fecha: $FECHA_INICIO..."
        
        for dir in "$DIRECTORIO"/*; do
            if [ -d "$dir" ]; then
                FECHA_CREACION=$(stat -c %y "$dir" | cut -d' ' -f1)
                if [[ "$FECHA_CREACION" == "$FECHA_INICIO" ]]; then
                    TAMANO=$(du -sh "$dir" | cut -f1)
                    echo "$FECHA_CREACION,$(basename "$dir"),$TAMANO" >> "$SALIDA"
                fi
            fi
        done
        
        FECHA_INICIO=$(date -d "$FECHA_INICIO + 1 day" +%Y-%m-%d)
    done
else
    echo "📂 Procesando directorios en $DIRECTORIO para la fecha $FECHA_ANALIZAR..."
    echo "-----------------------"

    # Obtener directorios creados en el mes y año especificados

    # for dir in "$DIRECTORIO"/"$PREFIJO"*; do
    for dir in "$DIRECTORIO"/*; do
        echo "$dir"
        if [ -d "$dir" ]; then
            # Obtener la fecha de creación (formato YYYY-MM-DD)
            FECHA_CREACION=$(stat -c %y "$dir" | cut -d' ' -f1)
            echo "$FECHA_CREACION"
            # Obtener el mes y año del directorio
            ##MES_DIRECTORIO=$(echo "$FECHA_CREACION" | cut -d'-' -f1,2 | tr -d '-')

            # Si el directorio es del mes y año especificados, procesarlo
            ##echo "$MES_DIRECTORIO"
            ##echo "$MES_ANIO"
            ##if [[ "$MES_DIRECTORIO" == "$MES_ANIO" ]]; then
            if [[ "$FECHA_CREACION" == "$FECHA_ANALIZAR" ]]; then
                # Obtener el tamaño del directorio
                TAMANO=$(du -sh "$dir" | cut -f1)

                # Guardar en el CSV
                echo "$FECHA_CREACION,$(basename "$dir"),$TAMANO" >> "$SALIDA"

                # Imprimir en pantalla el directorio procesado
                echo "📁 Directorio: $(basename "$dir") | Fecha: $FECHA_CREACION | Tamano: $TAMANO"
            fi
        fi
    done
fi

echo "---------------------------------------"
echo "✅ Reporte actualizado en: $SALIDA"
