**GENERACION DE REPORTE DE OPERACION AMISR-14**
---

**1. Comandos para conexion-Test:**

RECORDAR SIEMPRE EL COMANDO DE CONEXION SSH:
```
ssh -i /home/soporte/.ssh/id_rsa-umetops.txt   -oKexAlgorithms=+diffie-hellman-group1-sha1 umetops@10.10.40.121 -L 4901:localhost:80 -L 3950:dtc0:5900 -L 3941:dtc0:9000
```
password: amisr beam scan

Esta es la base de la conexion
UPDATE de  codigo en el archivo:

$nano  /home/soporte/Desktop/scripts/AMISR-REPORT/amisr_stats_v2.py:

En el metodo find_new_bz2:

# AGREGAR LAS SIGUIENTES LINEAS DE CODIGO
    ```
    #client.connect(hostname=hostname, port=22, username=username, password=password)
    host = "10.10.40.121"
    port = 22
    username = "umetops"
    private_key_path = "/home/soporte/.ssh/id_rsa-umetops.txt"
    passphrase = "amisr beam scan"  # Passphrase de la clave

    private_key = paramiko.RSAKey.from_private_key_file(private_key_path, password=passphrase)
    client.connect(hostname=host, port=port, username=username, pkey=private_key)
    ```

**2. Ejecucion de reporte- Comandos**

$ conda activate paramiko

$ cd /home/soporte/Desktop/scripts/AMISR-REPORT

Usar  los programas:

* amisr_stats_v2.py
* amisrReports.py

Actualizar las bases de datos:

$ python amisrReports.py  --read_write write  --startDate  2025/01/01 --endDate 2025/02/24 --panels_list all --dataType "volts rev"

Leer la base de datos y generar el reporte:

$python amisrReports.py  --read_write read  --startDate  2025/01/01 --endDate 2025/01/01 --panels_list all --dataType power --report_name "FEBRERO_2025"


