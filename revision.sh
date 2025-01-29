#!/bin/bash

# Directorio a analizar (puedes cambiarlo o pasarlo como argumento)
DIRECTORIO="${1:-.}"

PREFIJO = "202501"

# Archivo de salida con la fecha actual en el nombre
SALIDA="reporte_directorios_$(date +%Y-%m).csv"

# Encabezado del CSV
echo "Fecha,Directorio,Tamaño" > "$SALIDA"

echo "📂 Procesando directorios en $DIRECTORIO que comienzan con '$PREFIJO'..."
echo "---------------------------------------"

# Obtener directorios creados en el mes actual
for dir in "$DIRECTORIO"/"$PREFIJO"*; do
    if [ -d "$dir" ]; then
        # Obtener la fecha de creación (formato YYYY-MM-DD)
        FECHA_CREACION=$(stat -c %y "$dir" | cut -d' ' -f1)

        # Obtener el mes y año actual
        MES_ACTUAL=$(date +%Y-%m)
        MES_DIRECTORIO=$(echo "$FECHA_CREACION" | cut -d'-' -f1,2)

        # Si el directorio es del mes actual, procesarlo
        if [[ "$MES_DIRECTORIO" == "$MES_ACTUAL" ]]; then
            # Obtener el tamaño del directorio
            TAMANO=$(du -sh "$dir" | cut -f1)

            # Guardar en el CSV
            echo "$FECHA_CREACION,$(basename "$dir"),$TAMANO" >> "$SALIDA"

            # Imprimir en pantalla el directorio procesado
            echo "📁 Directorio: $(basename "$dir") | Fecha: $FECHA_CREACION | Tamaño: $TAMANO"
        fi
    fi
done

echo "---------------------------------------"
echo "✅ Reporte generado en: $SALIDA"

