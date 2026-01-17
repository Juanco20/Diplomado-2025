import pandas as pd
import os

url = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2023-01.parquet"

print("Descargando Parquet oficial NYC Taxi...")
df = pd.read_parquet(url)

print("Filas totales:", len(df))

df = df.sample(n=1_000_000, random_state=42)

output_path = os.path.join("datos", "taxi_dirty.csv")
df.to_csv(output_path, index=False, header=False)

print("CSV generado:", output_path)
print("Columnas:", list(df.columns))

