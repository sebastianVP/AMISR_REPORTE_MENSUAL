# **REPOSITORIO PARA GENERAR UN REPORTE AUTOMATICO DE OPERACION MENSUAL DEL RADAR AMISR**

El objetivo de este repositorio es almacenar los codigos y scripts para generar el reporte de operacion mensual del radar AMISR-14.


Los programas mas importantes se encuentran en el siguiente directorio **/home/soporte/Documents/AMISR_REPORTE_MENSUAL**y son:

1. rev001_mensual_log.sh
Genera el reporte de fechas y carpetas

2. reporte_python_final.py
Lee el archivo csv generado por el bash y obtiene la horas por dia de datos.

3. Debemos tener un programa que se encargue de generar el reporte osea un informe con imagenes y graficos.
Este programa se llama **pendiente.py**


----


1. Se desarrolla un script en bash para generar un archivo csv. El formato del archivo csv contiene la informacion siguiente:
 * Fecha, direccion y tamano





# COMANDO PARA EJECUTAR

$ ./revision_final.sh  /media/soporte/Expansion/AMISR/2024 202501

El script final se llama: revision_manual.sh


* En el crontab hemos configurado para generar el archivo:

# GENERANDO REPORTE DE ADQUISICION DE DATOS
01 10 * * * export DISPLAY=:0 && /home/soporte/Documents/AMISR_REPORTE_MENSUAL/revision_mensual_log.sh /mnt/data_amisr 202502
# GENERANDO REPORTE DE HORAS
15 10 * * * export DISPLAY=:0 && /home/soporte/Documents/AMISR_REPORTE_MENSUAL/reporte_python.sh   

* Con este script generamos el archivo:
reporte_directorios_desk_202502.csv

* EL contenido es el siguiente:
```

Fecha,Directorio,Tamano
2025-01-10,20241231.005,13M
2025-01-23,20250123.001,27G
2025-01-23,20250123.002,1.4G
2025-01-23,20250123.003,330M
2025-01-23,20250123.004,31G
2025-01-24,20250123.005,35G
2025-01-24,20250124.001,25G
2025-01-24,20250124.002,1.1G
2025-01-24,20250124.003,1.4G
2025-01-24,20250124.004,337M
2025-01-24,20250124.005,31G
2025-01-25,20250124.006,35G
2025-01-25,20250125.001,27G
2025-01-25,20250125.002,1.4G
2025-01-25,20250125.003,345M
2025-01-25,20250125.004,59M
2025-01-26,20250125.005,35G
2025-01-26,20250126.001,27G
2025-01-26,20250126.002,1.4G
2025-01-26,20250126.003,352M
2025-01-26,20250126.004,31G
```


* Luego utilizamos un script de python para hacer la conversión a Tamaño por dia


