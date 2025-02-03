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

# Prefijo basado en el mes y año proporcionado
PREFIJO="$MES_ANIO"

# Archivo de salida con la fecha actual en el nombre
SALIDA="reporte_directorios_desk_$(date +%Y-%m).csv"

# Encabezado del CSV
echo "Fecha,Directorio,Tamano" > "$SALIDA"

echo "📂 Procesando directorios en $DIRECTORIO que comienzan con '$PREFIJO'..."
echo "---------------------------------------"

# Obtener directorios creados en el mes y año especificados
for dir in "$DIRECTORIO"/"$PREFIJO"*; do
    echo "$dir"
    if [ -d "$dir" ]; then
        # Obtener la fecha de creación (formato YYYY-MM-DD)
        FECHA_CREACION=$(stat -c %y "$dir" | cut -d' ' -f1)
        echo "$FECHA_CREACION"
        # Obtener el mes y año del directorio
        MES_DIRECTORIO=$(echo "$FECHA_CREACION" | cut -d'-' -f1,2 | tr -d '-')

        # Si el directorio es del mes y año especificados, procesarlo
        echo "$MES_DIRECTORIO"
        echo "$MES_ANIO"
        if [[ "$MES_DIRECTORIO" == "$MES_ANIO" ]]; then
            # Obtener el tamaño del directorio
            TAMANO=$(du -sh "$dir" | cut -f1)

            # Guardar en el CSV
            echo "$FECHA_CREACION,$(basename "$dir"),$TAMANO" >> "$SALIDA"

            # Imprimir en pantalla el directorio procesado
            echo "📁 Directorio: $(basename "$dir") | Fecha: $FECHA_CREACION | Tamano: $TAMANO"
        fi
    fi
done

echo "---------------------------------------"
echo "✅ Reporte generado en: $SALIDA"
