# Proyecto de Desarrollo de Datos (Nivel 0 - Profesional)

Este repositorio contiene la estructura y el entorno de desarrollo listos para usar en el diplomado. Hemos configurado un ambiente profesional utilizando **Docker Compose** y **Poetry** para garantizar la **reproducibilidad** total de su entorno.

## ⚙️ Herramientas Clave en este Entorno

| Herramienta | Función |
| :--- | :--- |
| **Docker Compose** | Orquestación: Permite construir y levantar el entorno completo (imagen, contenedor, puertos, volúmenes) con un solo comando. |
| **Poetry** | Dependencias: Gestiona las librerías de Python. Asegura que todos utilicemos las versiones exactas listadas en `pyproject.toml`. |
| **JupyterLab** | IDE: Entorno de trabajo principal donde escribirá y ejecutará su código. |

## 🐳 Estructura del Repositorio

| Archivo/Carpeta | Propósito |
| :--- | :--- |
| `Datos/` | Almacena los datasets de entrada (datos crudos). |
| `Cuadernos/` | Contiene los archivos de desarrollo (`.ipynb`). |
| `Dockerfile` | La receta de la imagen: Instrucciones para instalar Python, Poetry y las librerías. |
| `pyproject.toml` | Lista de dependencias del proyecto que Poetry gestiona. |
| `docker-compose.yml` | El plano de la orquestación: Define cómo construir la imagen (`Dockerfile`) y cómo iniciar el contenedor. |
| `setup_docker_jupyter.sh` | (Obsoleto): Reemplazado por el comando único `docker compose up --build`. |

---

## 🚀 Guía de Inicio Rápido (Con Docker Compose)

Asumiendo que tiene Docker Desktop instalado y ejecutándose:

### Paso 1: Ir a la Carpeta del Proyecto

Abra su terminal y navegue al directorio raíz del proyecto:

```bash
cd data-dev-test
````

### Paso 2: Iniciar y Construir el Entorno

Este comando realiza tres acciones en una: (1) Construye la imagen, (2) Crea y (3) Ejecuta el contenedor de JupyterLab, mapeando el puerto `8888` y sincronizando su carpeta.

```bash
# Usa 'up' para iniciar y '--build' para compilar el Dockerfile primero
# Este comando es el moderno: 'docker compose' (sin guion)
sudo docker compose up --build -d
```

*Si el comando fue exitoso, el contenedor ahora se llama `jupyter-dev-env` y está corriendo.*

### Paso 3: Obtener el Token de Acceso

El servicio puede tardar unos segundos en generar el token. Use el comando `logs` para capturarlo:

```bash
# Usa el comando moderno: 'docker compose' (sin guion)
sudo docker compose logs jupyterlab
```

*Busque la URL que comienza con `http://0.0.0.0:8888/lab?token=...`*

Copie esa URL en su navegador. Dentro de JupyterLab, verá sus carpetas `Datos/` y `Cuadernos/`.

-----

### 🛑 Detener el Entorno

Para apagar el servicio de JupyterLab y liberar el puerto 8888:

```bash
# Usa el comando moderno: 'docker compose' (sin guion)
sudo docker compose down
```
**TOKEN DE ACCESO**: diplomado_2025