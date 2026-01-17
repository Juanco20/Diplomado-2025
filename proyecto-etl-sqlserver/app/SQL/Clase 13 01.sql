SELECT COUNT (*) FROM TRIPS

SELECT TOP 10 * FROM TRIPS;

SELECT TOP 10 * FROM TRIPS ORDER BY trip_duration DESC;

SELECT vendedor_id, COUNT (*) AS trip

SELECT
vendor_id,
COUNT(*) AS trip_count,
AVG(trip_duration) AS avg_duration,
SUM(trip_duration) AS total_duration
FROM TRIPS
GROUP BY
vendor_id;


SELECT
vendor_id,
COUNT(*) AS trip_count,
AVG(trip_duration) AS avg_duration,
SUM(trip_duration) AS total_duration
FROM TRIPS
WHERE trip_duration > 1000
GROUP BY
vendor_id;

SELECT TOP 10
    id, 
    trip_duration,
    AVG(trip_duration) OVER() AS promedio_global
FROM trips;

SELECT AVG (trip_duration) AS promedio_global
FROM trips;

SELECT
    id, 
    trip_duration,
    AVG(trip_duration) OVER(PARTITION BY vendor_id) AS promedio_por_vendedor
    FROM trips;

SELECT TOP 10
    id, 
    trip_duration,
    trip_duration - AVG(trip_duration) OVER() AS diferencia_vs_global,
    (trip_duration-AVG(trip_duration) OVER() )/STDEV(trip_duration) OVER() AS z_valor,
    AVG(trip_duration) OVER() AS promedio_global,
    STDEV(trip_duration) OVER() AS desviacion_estandar_global
FROM trips;

SELECT TOP 10
    id, 
    trip_duration,
    CAST(trip_duration AS FLOAT) / SUM(trip_duration) OVER() * 100 AS pct_del_total
FROM trips;

SELECT TOP 10
    id, 
    COUNT(*) OVER(PARTITION BY vendor_id) AS total_filas_tabla
FROM trips
ORDER BY total_filas_tabla DESC;

SELECT TOP 10
    id, 
    trip_duration,
    MAX(trip_duration) OVER() AS record_global
FROM trips;


## HABILIDAD DE PARTICIONAR

SELECT TOP 10
    id, 
    vendor_id,
    trip_duration,
    AVG(trip_duration) OVER(PARTITION BY vendor_id) AS promedio_vendor
FROM trips;

SELECT TOP 10
    id, 
    vendor_id,
    COUNT(*) OVER(PARTITION BY vendor_id) AS total_viajes_vendor
FROM trips;

SELECT TOP 10
    id, 
    vendor_id,
    trip_duration,
    CAST(trip_duration AS FLOAT) / SUM(trip_duration) OVER(PARTITION BY vendor_id) * 100 AS pct_contribucion_vendor
FROM trips;

SELECT TOP 10
    id, 
    passenger_count,
    trip_duration,
    MAX(trip_duration) OVER(PARTITION BY passenger_count) AS max_duracion_grupo
FROM trips;

SELECT TOP 10
    id, 
    vendor_id,
    CAST(pickup_datetime AS DATE) AS dia,
    COUNT(*) OVER(PARTITION BY vendor_id, CAST(pickup_datetime AS DATE)) AS viajes_ese_dia_ese_vendor
FROM trips;

SELECT TOP 20
    id, 
    pickup_datetime,
    trip_duration,
    SUM (trip_duration) OVER(ORDER BY pickup_datetime) AS duracion_acumulada_historica
FROM trips
ORDER BY pickup_datetime DESC;

SELECT TOP 20
    id, 
    vendor_id,
    pickup_datetime,
    trip_duration,
    SUM(trip_duration) OVER(PARTITION BY vendor_id ORDER BY pickup_datetime) AS acumulado_vendor
FROM trips
ORDER BY pickup_datetime;

SELECT TOP 20
    pickup_datetime,
    trip_duration,
    MAX(trip_duration) OVER(ORDER BY pickup_datetime) AS maximo_hasta_ahora
FROM trips
ORDER BY pickup_datetime;

SELECT TOP 20
    id, 
    trip_duration,
    AVG(trip_duration) OVER(ORDER BY pickup_datetime) AS promedio_movil_historico
FROM trips;

## JERARQUIAS Y RANKINGS    

SELECT TOP 20
    id, 
    trip_duration,
    RANK() OVER(ORDER BY trip_duration DESC) AS ranking_global
FROM trips
ORDER BY trip_duration DESC;


SELECT TOP 20
    id, 
    vendor_id,
    trip_duration,
    ROW_NUMBER() OVER(ORDER BY trip_duration DESC) AS ranking_interno
FROM trips
ORDER BY trip_duration DESC;


SELECT TOP 20
    trip_duration,
    RANK() OVER(ORDER BY trip_duration DESC) AS rnk,
    DENSE_RANK() OVER(ORDER BY trip_duration DESC) AS dense_rnk,
    ROW_NUMBER() OVER(ORDER BY trip_duration DESC) AS row_num
FROM trips
ORDER BY trip_duration DESC;


SELECT TOP 20
    id,
    trip_duration,
    NTILE(10) OVER(ORDER BY trip_duration) AS decil
FROM trips
ORDER BY pickup_datetime;


SELECT TOP 20
    id,
    vendor_id,
    pickup_datetime,
    ROW_NUMBER() OVER(PARTITION BY vendor_id ORDER BY pickup_datetime DESC) AS orden_inverso
FROM trips
ORDER BY vendor_id, pickup_datetime;


SELECT TOP 10
    id,
    ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS duplicado_check
FROM trips;



SELECT TOP 10
    vendor_id,
    pickup_datetime,
    trip_duration,
    LAG(trip_duration, 2) OVER(PARTITION BY vendor_id ORDER BY pickup_datetime) AS duracion_anterior
FROM trips
ORDER BY vendor_id, pickup_datetime;


SELECT TOP 10
    vendor_id,
    trip_duration,
    trip_duration - LAG(trip_duration) OVER(PARTITION BY vendor_id ORDER BY pickup_datetime) AS delta
FROM trips
ORDER BY vendor_id, pickup_datetime;



SELECT TOP 10
    vendor_id,
    pickup_datetime,
    LAG(dropoff_datetime) OVER(PARTITION BY vendor_id ORDER BY pickup_datetime) AS dropoff_previo,
    DATEDIFF(minute, 
        LAG(dropoff_datetime) OVER(PARTITION BY vendor_id ORDER BY pickup_datetime),
        pickup_datetime
    ) AS minutos_descanso
FROM trips
ORDER BY vendor_id, pickup_datetime;



SELECT TOP 10
    vendor_id,
    trip_duration,
    LEAD(trip_duration) OVER(PARTITION BY vendor_id ORDER BY pickup_datetime) AS siguiente_duracion
FROM trips
ORDER BY vendor_id, pickup_datetime;



SELECT TOP 10
    pickup_datetime,
    trip_duration,
    FIRST_VALUE(trip_duration) OVER(PARTITION BY CAST(pickup_datetime AS DATE) ORDER BY pickup_datetime) AS primera_duracion_dia
FROM trips
ORDER BY vendor_id, pickup_datetime;

## (CTES)

WITH DatosLimpios AS (
    SELECT id, vendor_id, trip_duration 
    FROM trips 
    WHERE trip_duration IS NOT NULL AND trip_duration > 0
)
SELECT TOP 10 * FROM DatosLimpios;


    WITH ResumenDiario AS (
        SELECT CAST(pickup_datetime AS DATE) AS Fecha, SUM(trip_duration) AS Total
        FROM trips
        GROUP BY CAST(pickup_datetime AS DATE)
    )
    SELECT * FROM ResumenDiario ORDER BY Fecha;

    WITH ResumenDiario AS (
        SELECT CAST(pickup_datetime AS DATE) AS Fecha, COUNT(*) AS CantidadViajes
        FROM trips
        GROUP BY CAST(pickup_datetime AS DATE)
    )
    SELECT 
        Fecha, 
        CantidadViajes, 
        RANK() OVER(ORDER BY CantidadViajes DESC) AS RankingDia
    FROM ResumenDiario;



WITH RankingCalculado AS (
    SELECT id, vendor_id, ROW_NUMBER() OVER(PARTITION BY vendor_id ORDER BY trip_duration DESC) AS rn
    FROM trips
)
SELECT * FROM RankingCalculado WHERE rn = 1;

WITH Paso1 AS (
    SELECT id, trip_duration FROM trips WHERE trip_duration > 100
),
Paso2 AS (
    SELECT id, trip_duration * 2 AS duracion_doble FROM Paso1
)
SELECT TOP 5 * FROM Paso2;






WITH DataLimpia AS (
    SELECT 
        vendor_id, 
        CAST(pickup_datetime AS DATE) AS Fecha,
        trip_duration
    FROM trips
    WHERE trip_duration > 0
)




### SOLUCION RETO FINAL

WITH DatosLimpios AS (
    SELECT
        CAST(pickup_datetime AS DATE) AS fecha,
        trip_duration
    FROM trips
    WHERE trip_duration IS NOT NULL
      AND trip_duration > 0
),

ResumenMensual AS (
    SELECT
        YEAR(fecha) AS año,
        MONTH(fecha) AS mes,
        SUM(trip_duration) AS total_mes
    FROM DatosLimpios
    GROUP BY YEAR(fecha), MONTH(fecha)
),

ConCrecimiento AS (
    SELECT
        año,
        mes,
        total_mes,
        LAG(total_mes) OVER(ORDER BY año, mes) AS mes_anterior,
        total_mes - LAG(total_mes) OVER(ORDER BY año, mes) AS crecimiento
    FROM ResumenMensual
),

Final AS (
    SELECT
        año,
        mes,
        total_mes,
        mes_anterior,
        crecimiento,
        SUM(total_mes) OVER(PARTITION BY año ORDER BY mes) AS acumulado_anual
    FROM ConCrecimiento
)

SELECT
    año,
    mes,
    total_mes,
    mes_anterior,
    crecimiento,
    acumulado_anual
FROM Final
ORDER BY año, mes;
