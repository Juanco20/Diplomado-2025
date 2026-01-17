DROP TABLE IF EXISTS Trips;

SELECT
    TRY_CONVERT(datetime, tpep_pickup_datetime)  AS pickup_datetime,
    TRY_CONVERT(datetime, tpep_dropoff_datetime) AS dropoff_datetime,
    TRY_CONVERT(int, passenger_count)           AS passenger_count,
    TRY_CONVERT(float, total_amount)            AS total_amount
INTO Trips
FROM Staging_Trips;

ALTER TABLE Trips
ADD DurationMinutes AS
    DATEDIFF(MINUTE, pickup_datetime, dropoff_datetime);


SET STATISTICS IO, TIME ON;

SELECT *
FROM Trips
WHERE DurationMinutes = 0
  AND total_amount > 50;

CREATE NONCLUSTERED INDEX IX_Trips_Duration_Total
ON Trips (DurationMinutes, total_amount);

SET STATISTICS IO, TIME ON;

SELECT *
FROM Trips
WHERE DurationMinutes = 0
  AND total_amount > 50;

DROP INDEX IX_Trips_Duration_Total ON Trips;

ALTER TABLE Trips DROP COLUMN DurationMinutes;

ALTER TABLE Trips
ADD DurationMinutes AS
    DATEDIFF(MINUTE, pickup_datetime, dropoff_datetime) PERSISTED;

CREATE NONCLUSTERED INDEX IX_Trips_Duration_Total
ON Trips (DurationMinutes, total_amount);

SET STATISTICS IO, TIME ON;

SELECT *
FROM Trips
WHERE DurationMinutes = 0
  AND total_amount > 50;

SET STATISTICS IO, TIME ON;

SELECT *
FROM Trips
WHERE DurationMinutes = 0
  AND total_amount > 200;



