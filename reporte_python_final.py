# -*- coding: utf-8 -*-
import pandas as pd
import re
import os

# Archivo de entrada
file_path = "reporte_directorios_2025.csv"
# Archivo de salida
output_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), "reporte_tamanos_directorios.csv")

# Cargar el archivo CSV con los datos nuevos
df = pd.read_csv(file_path)

def convertir_tamano(tamano):
    match = re.match(r"([\d.]+)([MG]?)", str(tamano))  # Extraer número (incluye decimales) y unidad
    if match:
        numero = float(match.group(1))  # Convertir correctamente a float
        unidad = match.group(2)
        if unidad == "M":
            return numero / 1024  # Convertir MB a GB correctamente
        return numero  # Si es G o no tiene unidad, mantener en GB
    return 0  # Si no hay número, devolver 0

df["Tamano_GB"] = df["Tamano"].apply(convertir_tamano).round(3)
df["Dia"] = df["Fecha"].astype(str)  # Usar la columna Fecha para agrupar

# Sumar los valores de Tamaño_GB por cada día
resultado_nuevo = df.groupby("Dia")["Tamano_GB"].sum().reset_index()
resultado_nuevo["Horas"] = ((resultado_nuevo["Tamano_GB"] * 24.0) / 94.3).round(2)


# Si el archivo de reporte ya existe, cargarlo y agregar solo los días nuevos
if os.path.exists(output_file):
    resultado_existente = pd.read_csv(output_file)
    resultado_existente["Dia"] = resultado_existente["Dia"].astype(str)
    dias_existentes = set(resultado_existente["Dia"])
    resultado_nuevo = resultado_nuevo[~resultado_nuevo["Dia"].isin(dias_existentes)]
    resultado_final = pd.concat([resultado_existente, resultado_nuevo], ignore_index=True)
else:
    resultado_final = resultado_nuevo

# Guardar el resultado actualizado
#resultado_final.to_csv(output_file, index=False)

# Guardar el resultado actualizado con solo 2 decimales en todas las columnas flotantes
resultado_final.to_csv(output_file, index=False, float_format="%.2f")


print(f"✅ Reporte actualizado: {output_file}")
