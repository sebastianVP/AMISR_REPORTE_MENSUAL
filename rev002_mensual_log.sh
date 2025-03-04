#!/bin/bash

# Obtener la ruta del script (directorio donde está ubicado)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Verificar si el usuario ha proporcionado los argumentos requeridos
if [[ $# -lt 1 ]]; then
    echo "❌ Uso incorrecto." | tee -a "$LOG_FILE"
    echo "Uso: $0 <directorio_base> [días_atras (opcional, por defecto 1)]" | tee -a "$LOG_FILE"
    exit 1
fi

# Parámetros de entrada
DIRECTORIO_BASE="$1"
DIAS_ATRAS="${2:-1}"  # Si no se proporciona, usa 1 día antes
HOY=$(date +%Y%m%d)
FECHA_LIMITE=$(date -d "$DIAS_ATRAS days ago" +%Y%m%d)
REPORTE="$SCRIPT_DIR/reporte_directorios_2025.csv"
LOG_FILE="$SCRIPT_DIR/log_reporte_$(date +%Y-%m-%d).log"

# Iniciar log con fecha y hora
echo "🕒 Inicio de ejecución: $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"

# Verificar si el directorio existe
if [[ ! -d "$DIRECTORIO_BASE" ]]; then
    echo "❌ ERROR: El directorio '$DIRECTORIO_BASE' no existe." | tee -a "$LOG_FILE"
    exit 1
fi

# Función para formatear tamaños
format_size() {
    local size=$1
    if ((size >= 1073741824)); then
        echo "$(bc <<< "scale=2; $size/1073741824")G"
    else
        echo "$(bc <<< "scale=2; $size/1048576")M"
    fi
}

# Cargar datos previos si el reporte ya existe
declare -A EXISTENTES
if [[ -f "$REPORTE" ]]; then
    while IFS=, read -r fecha dir tamano; do
        EXISTENTES["$fecha|$dir"]="$tamano"
    done < <(tail -n +2 "$REPORTE")  # Omitir el encabezado
fi

if [[ ! -f "$REPORTE" ]]; then
    echo "Fecha,Directorio,Tamano" > "$REPORTE"
fi

# Obtener la última fecha registrada en el reporte
ULTIMA_FECHA=$(awk -F, 'NR > 1 {print $1}' "$REPORTE" | sort -r | head -n 1)

# Buscar directorios con el formato YYYYMMDD.NNN
echo "📂 Analizando directorios en '$DIRECTORIO_BASE' hasta la fecha $FECHA_LIMITE..." | tee -a "$LOG_FILE"
for carpeta in "$DIRECTORIO_BASE"/*; do
    if [[ -d "$carpeta" ]]; then
        nombre=$(basename "$carpeta")  # Extraer solo el nombre de la carpeta
        fecha=${nombre%%.*}  # Obtener YYYYMMDD

        if [[ "$fecha" =~ ^[0-9]{8}$ ]] && [[ "$fecha" -le "$FECHA_LIMITE" ]] && [[ "$fecha" -gt "$ULTIMA_FECHA" ]]; then
            if [[ -z "${EXISTENTES["$fecha|$nombre"]}" ]]; then
                tamano_bytes=$(du -sb "$carpeta" | awk '{print $1}')
                tamano_formateado=$(format_size "$tamano_bytes")
                echo "$fecha,$nombre,$tamano_formateado" >> "$REPORTE"
                echo "✅ Agregado: $nombre - Tamaño: $tamano_formateado" | tee -a "$LOG_FILE"
            fi
        fi
    fi
done

echo "---------------------------------------" | tee -a "$LOG_FILE"
echo "✅ Reporte generado: $REPORTE" | tee -a "$LOG_FILE"
echo "🕒 Fin de ejecución: $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"
