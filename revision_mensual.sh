#!/bin/bash

# Verificar si el usuario ha proporcionado los argumentos requeridos
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "❌ Uso incorrecto."
    echo "Uso: $0 <directorio> <año-mes> [días atrás]"
    echo "Ejemplo: $0 /ruta/al/directorio 2025-02 2"
    exit 1
fi

# Parámetros de entrada
DIRECTORIO="$1"
MES_ANIO="$2"
DIAS_ATRAS=${3:-1}  # Si no se especifica, por defecto es 1 día atrás

# Verificar si el directorio existe
if [ ! -d "$DIRECTORIO" ]; then
    echo "❌ ERROR: El directorio '$DIRECTORIO' no existe."
    exit 1
fi

# Contar la cantidad de subdirectorios
CANTIDAD_DIRS=$(find "$DIRECTORIO" -mindepth 1 -maxdepth 1 -type d | wc -l)

# Si no hay directorios, mostrar mensaje y salir
if [ "$CANTIDAD_DIRS" -eq 0 ]; then
    echo "📂 El directorio '$DIRECTORIO' contiene 0 subdirectorios. No se generará ningún reporte."
    exit 0
fi

# Obtener la fecha del día deseado
FECHA_ANALIZAR=$(date -d "$DIAS_ATRAS days ago" +%Y-%m-%d)

# Archivo de salida
SALIDA="$(pwd)/reporte_directorios_desk_${MES_ANIO}.csv"

# Si el archivo no existe, generar datos desde el 01 de enero de 2025
if [ ! -f "$SALIDA" ]; then
    echo "🆕 Archivo de reporte no encontrado. Se generará desde 01 de enero de 2025 hasta $FECHA_ANALIZAR..."
    echo "Fecha,Directorio,Tamano" > "$SALIDA"

    FECHA_INICIO="2025-01-01"
    
    while [[ "$FECHA_INICIO" < "$FECHA_ANALIZAR" ]] || [[ "$FECHA_INICIO" == "$FECHA_ANALIZAR" ]]; do
        echo "📅 Procesando fecha: $FECHA_INICIO..."

        for dir in "$DIRECTORIO"/*; do
            if [ -d "$dir" ]; then
                FECHA_CREACION=$(stat -c %y "$dir" | cut -d' ' -f1)
                if [[ "$FECHA_CREACION" == "$FECHA_INICIO" ]]; then
                    TAMANO=$(du -sh "$dir" | awk '{print $1}')
                    echo "$FECHA_CREACION,$(basename "$dir"),$TAMANO" >> "$SALIDA"
                    echo "✅ Agregado: $(basename "$dir") - Tamaño: $TAMANO"
                fi
            fi
        done
        
        FECHA_INICIO=$(date -d "$FECHA_INICIO + 1 day" +%Y-%m-%d)
    done
else
    echo "📂 Procesando directorios en $DIRECTORIO para la fecha $FECHA_ANALIZAR..."
    echo "---------------------------------------"

    for dir in "$DIRECTORIO"/*; do
        if [ -d "$dir" ]; then
            FECHA_CREACION=$(stat -c %y "$dir" | cut -d' ' -f1)
            if [[ "$FECHA_CREACION" == "$FECHA_ANALIZAR" ]]; then
                TAMANO=$(du -sh "$dir" | awk '{print $1}')
                echo "$FECHA_CREACION,$(basename "$dir"),$TAMANO" >> "$SALIDA"
                echo "✅ Agregado: $(basename "$dir") - Tamaño: $TAMANO"
            fi
        fi
    done
fi

echo "---------------------------------------"
echo "✅ Reporte actualizado en: $SALIDA"

