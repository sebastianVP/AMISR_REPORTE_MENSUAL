# -*- coding: utf-8 -*-
import csv
import subprocess
import os

def obtener_datos_df(ruta_filtro):
    """Ejecuta el comando df -h y extrae la línea que corresponde a la ruta especificada."""
    resultado = subprocess.run(["df", "-h"], capture_output=True, text=True)
    
    for linea in resultado.stdout.splitlines():
        if ruta_filtro in linea:
            return linea.split()
    
    return None

def guardar_en_csv(nombre_archivo, datos):
    """Guarda los datos en un archivo CSV."""
    encabezados = ["Ruta", "Tamaño (GB)", "Usado (GB)", "Disponible (GB)", "Porcentaje Usado", "Punto de Montaje"]
    
    with open(nombre_archivo, mode='w', newline='') as archivo:
        escritor = csv.writer(archivo)
        escritor.writerow(encabezados)
        escritor.writerow(datos)

# Ruta que queremos filtrar en el df -h
ruta_filtro = "//192.168.10.20/data"

# Obtener la información del df -h
partes = obtener_datos_df(ruta_filtro)

if partes:

    output_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), "status_disco.csv")
    output_file2 = os.path.join("/home/soporte/Documents/DATASETS_CLASE","status_disco.csv")


    ruta = partes[0]
    tamano = partes[1][:-1]  # Eliminar la 'G'
    usado = partes[2][:-1]
    disponible = partes[3][:-1]
    porcentaje = partes[4]
    punto_montaje = partes[5]

    # Guardar en CSV
    guardar_en_csv(output_file, [ruta, tamano, usado, disponible, porcentaje, punto_montaje])
    guardar_en_csv(output_file2, [ruta, tamano, usado, disponible, porcentaje, punto_montaje])
    print("Datos guardados en status_disco.csv")
else:
    print(f"No se encontró información para la ruta {ruta_filtro}")
