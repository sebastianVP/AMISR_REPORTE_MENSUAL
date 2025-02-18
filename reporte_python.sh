#!/bin/bash
# Obtener la ruta del script (directorio donde está ubicado)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

LOGFILE="$SCRIPT_DIR/LOGFILE_REPORTE_ON.txt"
/home/soporte/anaconda3/envs/schain3/bin/python3.8 /home/soporte/Documents/AMISR_REPORTE_MENSUAL/reporte_python.py > $LOGFILE
