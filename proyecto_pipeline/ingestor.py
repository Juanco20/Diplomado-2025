from pathlib import Path
import shutil

# Ruta base del proyecto
BASE_DIR = Path(__file__).parent

# Directorios
LANDING = BASE_DIR / "landing"
BRONZE = BASE_DIR / "bronze"
BAD_DATA = BASE_DIR / "bad_data"

# Crear carpetas de salida si no existen
BRONZE.mkdir(exist_ok=True)
BAD_DATA.mkdir(exist_ok=True)

def process_files():
    for file in LANDING.iterdir():

        if file.is_file():

            # Archivo vacío
            if file.stat().st_size == 0:
                shutil.move(str(file), BAD_DATA / file.name)

            # CSV válido
            elif file.suffix == ".csv":
                shutil.move(str(file), BRONZE / file.name)

            # Cualquier otro archivo
            else:
                shutil.move(str(file), BAD_DATA / file.name)

if __name__ == "__main__":
    process_files()
