# Usar una imagen base de Python ligera
FROM python:3.11-slim

# Establecer el directorio de trabajo
WORKDIR /app

# Instalar Poetry globalmente
RUN pip install poetry

# 1. Copiar y instalar dependencias
# Se copian los archivos de configuración de Poetry
COPY pyproject.toml poetry.lock /app/

# 2. Instalar las dependencias de producción (sin el entorno de proyecto)
# poetry install --no-root asegura que se instale solo lo necesario para el ambiente.
RUN poetry install --no-root

# Exponer el puerto de JupyterLab
EXPOSE 8888

# Comando para iniciar JupyterLab
# Usamos 'poetry run' para ejecutar jupyter-lab dentro del entorno virtual de Poetry.
CMD ["/bin/bash", "-c", "poetry run jupyter-lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root"]