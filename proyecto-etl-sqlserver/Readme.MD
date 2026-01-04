# 🐳 Proyecto ETL: SQL Server + Python Ingestion

Este proyecto despliega un entorno contenerizado que consiste en una base de datos **Microsoft SQL Server** y un servicio de **Python** que realiza una ingesta automática de datos al arrancar.

El objetivo es proporcionar una plantilla lista para usar que resuelva la configuración de drivers ODBC y la comunicación entre contenedores.

## 📋 Requisitos Previos

* [Docker](https://www.docker.com/products/docker-desktop) instalado.
* [Docker Compose](https://docs.docker.com/compose/install/) instalado.

## 🚀 Inicio Rápido

1.  **Construir y levantar los servicios:**
    Abre una terminal en la raíz del proyecto y ejecuta:

    ```bash
    docker compose up --build
    ```

2.  **¿Qué sucederá?**
    * Se descargará la imagen de SQL Server 2022.
    * Se construirá la imagen de Python instalando los drivers `msodbcsql17`.
    * **Esperar a la BD:** El contenedor de Python esperará automáticamente (gracias al `healthcheck`) a que SQL Server esté listo para aceptar conexiones.
    * **Ejecución:** Python creará la tabla `datos_prueba` e insertará un registro.
    * **Verificación:** Verás en la consola la impresión de los datos insertados.

3.  **Detener el entorno:**
    Para detener los contenedores presiona `Ctrl + C`. Para eliminar los contenedores y redes:

    ```bash
    docker compose down
    ```

---

## 📂 Estructura del Proyecto

```text
proyecto-etl-sqlserver/
├── app/
│   ├── Dockerfile         # Configuración de imagen Python + Drivers ODBC
│   ├── main.py            # Script de lógica de negocio (ETL)
│   └── requirements.txt   # Librerías Python (pandas, pyodbc)
├── docker-compose.yml     # Orquestador de servicios
└── README.md              # Documentación

```

## ⚙️ Configuración y Variables de Entorno

Las credenciales están definidas en el archivo `docker-compose.yml`.

| Variable | Valor por Defecto | Descripción |
| --- | --- | --- |
| `DB_HOST` | `db` | Nombre del servicio en la red de Docker. |
| `DB_USER` | `sa` | Usuario administrador de SQL Server. |
| `DB_PASS` | `TuPasswordFuerte123!` | **Importante:** SQL Server requiere contraseñas complejas (Mayúsculas, minúsculas, números). |
| `DB_NAME` | `master` | Base de datos por defecto. |

> **Nota:** Si cambias la contraseña en el servicio `db`, asegúrate de actualizarla también en las variables de entorno del servicio `ingesta`.

## 📡 Conexión Manual a la Base de Datos

Si deseas conectar una herramienta externa (como DBeaver, Azure Data Studio o SSMS) mientras el contenedor está corriendo, usa los siguientes parámetros:

* **Host:** `localhost` (o `127.0.0.1`)
* **Puerto:** `1433`
* **Usuario:** `sa`
* **Contraseña:** `TuPasswordFuerte123!`

## 🛠 Detalles Técnicos

### Healthcheck

El `docker-compose.yml` incluye un *healthcheck* en el servicio de base de datos. Esto previene el error común donde Python intenta conectarse antes de que la base de datos haya terminado de iniciarse.

### Drivers ODBC

El `Dockerfile` en la carpeta `app/` instala las librerías del sistema necesarias para `pyodbc` en Linux (Debian/Ubuntu), específicamente `unixodbc-dev` y `msodbcsql17`.

## 🧹 Limpieza de Datos

Los datos de la base de datos persisten en un volumen de Docker llamado `sql_data`. Si deseas reiniciar la base de datos desde cero (borrar todos los datos), ejecuta:

```bash
docker-compose down -v

```

*(La bandera `-v` elimina los volúmenes asociados).*

---

Desarrollado con ❤️ y Docker.