import pandas as pd
import re

# Cargar el archivo CSV
file_path = "reporte_directorios_2025-01.csv"  # Reemplaza con la ruta real
df = pd.read_csv(file_path)

# Función para convertir los valores de la columna Tamaño
def convertir_tamano(tamano):
    match = re.match(r"(\d+)([MG]?)", str(tamano))  # Extraer número y unidad
    if match:
        numero = int(match.group(1))
        unidad = match.group(2)
        if unidad == "M":
            return numero / 1000  # Convertir a GB
        return numero  # Si es G o no tiene unidad, mantener
    return 0  # Si no hay número, devolver 0

# Aplicar la conversión a la columna Tamaño
df["Tamano_GB"] = df["Tamano"].apply(convertir_tamano)

# Extraer el identificador del directorio por día (los primeros 8 caracteres del nombre del directorio)
df["Dia"] = df["Directorio"].astype(str).str[:8]

# Sumar los valores de Tamaño_GB por cada día
resultado = df.groupby("Dia")["Tamano_GB"].sum().reset_index()



# Aplicar la fórmula para obtener la cantidad de horas:
# Se multiplica el valor en GB por 94.3, se divide entre 24 y se establece 24 horas como máximo
resultado["Horas"] = (resultado["Tamano_GB"] * 94.3) / 24
resultado["Horas"] = resultado["Horas"].apply(lambda h: 24 if h >= 24 else h)

# Guardar el resultado en un archivo CSV
output_file = "reporte_tamanos_directorios.csv"
resultado.to_csv(output_file, index=False)

print(f"Reporte generado: {output_file}")
