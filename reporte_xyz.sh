#!/bin/bash

# Verifica que haya al menos un argumento (directorio base)
if [[ $# -lt 1 ]]; then
    echo "Uso: $0 <directorio_base> [dias_atras (opcional, por defecto 1)]"
    exit 1
fi

DIRECTORIO_BASE="$1"
DIAS_ATRAS="${2:-1}"  # Si no se proporciona, usa 1 día antes
HOY=$(date +%Y%m%d)
FECHA_LIMITE=$(date -d "$DIAS_ATRAS days ago" +%Y%m%d)
REPORTE="reporte_tamanos_$HOY.csv"

# Función para formatear tamaños
format_size() {
    local size=$1
    if ((size >= 1073741824)); then
        echo "$(bc <<< "scale=2; $size/1073741824")G"
    else
        echo "$(bc <<< "scale=2; $size/1048576")M"
    fi
}

# Si el reporte ya existe, carga los datos previos
declare -A EXISTENTES
if [[ -f "$REPORTE" ]]; then
    while IFS=, read -r fecha dir tamano; do
        EXISTENTES["$fecha|$dir"]="$tamano"
    done < <(tail -n +2 "$REPORTE")  # Omitir el encabezado
fi

echo "Fecha,Directorio,Tamaño" > "$REPORTE"

# Buscar directorios con el formato YYYYMMDD.NNN
for carpeta in "$DIRECTORIO_BASE"/*; do
    if [[ -d "$carpeta" ]]; then
        nombre=$(basename "$carpeta")  # Extraer solo el nombre de la carpeta
        fecha=${nombre%%.*}  # Obtener YYYYMMDD

        if [[ "$fecha" =~ ^[0-9]{8}$ ]] && [[ "$fecha" -le "$FECHA_LIMITE" ]]; then
            if [[ -n "${EXISTENTES["$fecha|$nombre"]}" ]]; then
                echo "$fecha,$nombre,${EXISTENTES["$fecha|$nombre"]}" >> "$REPORTE"
            else
                tamano_bytes=$(du -sb "$carpeta" | awk '{print $1}')
                tamano_formateado=$(format_size "$tamano_bytes")
                echo "$fecha,$nombre,$tamano_formateado" >> "$REPORTE"
            fi
        fi
    fi
done

echo "Reporte generado: $REPORTE"
