-- 1. Crear tablas de prueba
CREATE TABLE #Clientes (ID int IDENTITY(1,1) PRIMARY KEY, Nombre CHAR(100));
CREATE TABLE #Productos (ID int IDENTITY(1,1) PRIMARY KEY, Producto CHAR(100));
CREATE TABLE #Ventas (ID int IDENTITY(1,1), ClienteID int, ProductoID int, Cantidad int);

-- 2. Insertar datos (Simulación de volumen)
-- Insertamos 2,000 Clientes
DECLARE @i int = 0;
WHILE @i < 2000 BEGIN
    INSERT INTO #Clientes VALUES ('Cliente ' + CAST(@i AS VARCHAR));
    SET @i = @i + 1;
END

-- Insertamos 500 Productos
SET @i = 0;
WHILE @i < 500 BEGIN
    INSERT INTO #Productos VALUES ('Producto ' + CAST(@i AS VARCHAR));
    SET @i = @i + 1;
END

-- Insertamos 5,000 Ventas (Relación Real)
-- Asignamos ventas aleatorias entre clientes y productos
SET @i = 0;
WHILE @i < 5000 BEGIN
    INSERT INTO #Ventas (ClienteID, ProductoID, Cantidad)
    VALUES (
        (ABS(CHECKSUM(NEWID())) % 2000) + 1, -- Cliente Random
        (ABS(CHECKSUM(NEWID())) % 500) + 1,  -- Producto Random
        1
    );
    SET @i = @i + 1;
END
 

-- 3. Consultas de prueba

SELECT COUNT(*) AS TotalClientes FROM #Clientes;
SELECT COUNT(*) AS TotalProductos FROM #Productos;
SELECT COUNT(*) AS TotalVentas FROM #Ventas;

SELECT * FROM #Ventas;

-- 4. Medición de rendimiento

-- 4. Medición de rendimiento

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
PRINT '--- Consultas de prueba ---'
SELECT c.Nombre, p.Producto
FROM #Clientes c, #Productos p
PRINT '--- Fin de la creación de tablas y datos de prueba ---'


SET STATISTICS IO ON;
SET STATISTICS TIME ON;
PRINT '--- Consultas de prueba ---'
SELECT v.ID,c.Nombre, p.Producto, v.Cantidad
FROM #Ventas v
INNER JOIN #Clientes c ON v.ClienteID=c.ID
INNER JOIN #Productos p ON v.ProductoID=p.ID
PRINT '--- Fin de la creación de tablas y datos de prueba ---'



SELECT c.Nombre, p.Producto
FROM #Clientes c, #Productos p
PRINT '--- Fin de la creacion y consulta de tablas de prueba ---';