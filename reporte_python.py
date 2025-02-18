# -*- coding: utf-8 -*-
import pandas as pd
import re
import os

# Archivo de entrada
file_path = "reporte_directorios_desk_202502.csv"
# Archivo de salida

output_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), "reporte_tamanos_directorios.csv")

# Cargar el archivo CSV con los datos nuevos
df = pd.read_csv(file_path)

def convertir_tamano(tamano):
    match = re.match(r"(\d+)([MG]?)", str(tamano))  # Extraer número y unidad
    if match:
        numero = int(match.group(1))
        unidad = match.group(2)
        if unidad == "M":
            return numero / 1000  # Convertir a GB
        return numero  # Si es G o no tiene unidad, mantener
    return 0  # Si no hay número, devolver 0

df["Tamano_GB"] = df["Tamano"].apply(convertir_tamano)
df["Dia"] = df["Directorio"].astype(str).str[:8]

# Asegurar que la columna "Dia" es de tipo string
df["Dia"] = df["Dia"].astype(str)

# Sumar los valores de Tamaño_GB por cada día
resultado_nuevo = df.groupby("Dia")["Tamano_GB"].sum().reset_index()
resultado_nuevo["Horas"] = (resultado_nuevo["Tamano_GB"] * 24) / 94.3
resultado_nuevo["Horas"] = resultado_nuevo["Horas"].apply(lambda h: 24 if h >= 24 else h)

# Si el archivo de reporte ya existe, cargarlo y agregar solo los días nuevos
if os.path.exists(output_file):
    resultado_existente = pd.read_csv(output_file)
    resultado_existente["Dia"] = resultado_existente["Dia"].astype(str)  # Asegurar que "Dia" es string
    dias_existentes = set(resultado_existente["Dia"])
    resultado_nuevo = resultado_nuevo[~resultado_nuevo["Dia"].isin(dias_existentes)]
    resultado_final = pd.concat([resultado_existente, resultado_nuevo], ignore_index=True)
else:
    resultado_final = resultado_nuevo

# Guardar el resultado actualizado
resultado_final.to_csv(output_file, index=False)
print(f"Reporte actualizado: {output_file}")

