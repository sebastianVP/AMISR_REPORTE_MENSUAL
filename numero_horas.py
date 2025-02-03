import pandas as pd
datos = pd.read_csv("reporte_tamanos_directorios.csv")

# Calcular la suma de las horas
suma_horas = datos["Horas"].sum()

# Mostrar el resultado
print(f"La suma total de horas de operación es: {suma_horas}")
