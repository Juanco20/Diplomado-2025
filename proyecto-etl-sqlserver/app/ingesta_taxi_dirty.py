import pyodbc
import pandas as pd
import time
import os

 

DB_NAME = 'master'
 
def get_connection():
    conn_str = (
        "Driver={ODBC Driver 18 for SQL Server};"
        "Server=localhost;"
        "Database=master;"
        "UID=sa;"
        "PWD=TuPasswordFuerte123!;"
        "TrustServerCertificate=yes;"
    )
    return pyodbc.connect(conn_str, autocommit=True)


 
def run_ingestion():
    print("--- 🚀 Iniciando Proceso ETL ---")
    
    # 1. Leer el CSV
    try:
        print("📂 Leyendo archivo CSV...")
        df = pd.read_csv('../datos/taxi_dirty.csv')
        print(f"✅ CSV cargado. Filas encontradas: {len(df)}")
    except Exception as e:
        print(f"❌ Error leyendo el CSV: {e}")
        return
 
    # 2. Conectar a BD
    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        print("✅ Conectado a SQL Server")
        
        # 3. Crear tabla (Borrarla si ya existe para evitar errores en pruebas)
        print("🛠  Creando tabla 'trips'...")
 
        cursor.execute("""
            DROP TABLE IF EXISTS Staging_Trips;           
 
            CREATE TABLE Staging_Trips (
                VendorID VARCHAR(50),
                tpep_pickup_datetime VARCHAR(50),
                tpep_dropoff_datetime VARCHAR(50),
                passenger_count VARCHAR(50),
                trip_distance VARCHAR(50),
                RatecodeID VARCHAR(50),
                store_and_fwd_flag VARCHAR(50),
                PULocationID VARCHAR(50),
                DOLocationID VARCHAR(50),
                payment_type VARCHAR(50),
                fare_amount VARCHAR(50),
                extra VARCHAR(50),
                mta_tax VARCHAR(50),
                tip_amount VARCHAR(50),
                tolls_amount VARCHAR(50),
                improvement_surcharge VARCHAR(50),
                total_amount VARCHAR(50),
                congestion_surcharge VARCHAR(50),
                airport_fee VARCHAR(50)
            );
        """)
        
        # 4. Insertar datos
        print("📥 Insertando datos en SQL Server...")
        df.columns = ["VendorID", "tpep_pickup_datetime", "tpep_dropoff_datetime", "passenger_count",
                      "trip_distance", "RatecodeID", "store_and_fwd_flag", "PULocationID",
                      "DOLocationID", "payment_type", "fare_amount", "extra", "mta_tax",
                      "tip_amount", "tolls_amount", "improvement_surcharge",
                      "total_amount", "congestion_surcharge", "airport_fee"]
        for index, row in df.iterrows():
            cursor.execute("""
                INSERT INTO Staging_Trips (
                    VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count,
                    trip_distance, RatecodeID, store_and_fwd_flag, PULocationID,
                    DOLocationID, payment_type, fare_amount, extra, mta_tax,
                    tip_amount, tolls_amount, improvement_surcharge,
                    total_amount, congestion_surcharge, airport_fee
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
           str(row.VendorID), str(row.tpep_pickup_datetime), str(row.tpep_dropoff_datetime), str(row.passenger_count),
           str(row.trip_distance), str(row.RatecodeID), str(row.store_and_fwd_flag), str(row.PULocationID),
           str(row.DOLocationID), str(row.payment_type), str(row.fare_amount), str(row.extra), str(row.mta_tax),
           str(row.tip_amount), str(row.tolls_amount), str(row.improvement_surcharge),
           str(row.total_amount), str(row.congestion_surcharge), str(row.airport_fee)
            )
 
        print(f"✨ ¡Éxito! Se insertaron {len(df)} registros.")
 
    except Exception as e:
        print(f"❌ Error en la base de datos: {e}")
    finally:
        if conn: conn.close()
 
if __name__ == "__main__":
    # Esperamos unos segundos extra para asegurar que SQL Server esté listo
    time.sleep(5)
    run_ingestion()




