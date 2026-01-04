/* Creamos la tabla maestra de productos */CREATE TABLE Productos (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(100), -- Texto de hasta 100 caracteres   
    precio DECIMAL(10, 2), -- 10 dígitos en total, 2 decimales
    categoria VARCHAR(50)
);

/* Añadimos la columna de inventario */
ALTER TABLE Productos ADD stock INT;

/* Consultamos todos los productos */
SELECT * FROM Productos;

/* Elimina la tabla de pruebas totalmente */
CREATE TABLE Pruebas_Basura (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(100), -- Texto de hasta 100 caracteres    
    precio DECIMAL(10, 2), -- 10 dígitos en total, 2 decimales
    categoria VARCHAR(50)
);

DROP TABLE Pruebas_Basura;

/* Vacia la tabla de logs, pero la deja lista para recibir nuevos */

CREATE TABLE Logs_Errores (
    id_error INT PRIMARY KEY,
    nombre_error VARCHAR(100), -- Texto de hasta 100 caracteres    
    tipo_error DECIMAL(10, 2), -- 10 dígitos en total, 2 decimales
);


SELECT * FROM Logs_Errores;

TRUNCATE TABLE Logs_Errores;

INSERT INTO Productos (id_producto, nombre, precio, categoria, stock) VALUES
(1, 'Laptop Gamer X', 1200.00, 'Computación', 10),
(2, 'Mouse Óptico', 25.00, 'Accesorios', 50);

SELECT * FROM Productos;

/* Insertamos datos en Logs_Errores */
ALTER TABLE Logs_Errores DROP COLUMN tipo_error;    
ALTER TABLE Logs_Errores ADD tipo_error INT;

INSERT INTO Logs_Errores (id_error, nombre_error, tipo_error) VALUES
(1, 'Error de conexión', 1),
(2, 'Error de sintaxis SQL', 2);

SELECT * FROM Logs_Errores;

TRUNCATE TABLE Logs_Errores;

SELECT * FROM Logs_Errores;

/* Creamos un usuario limitado */
CREATE LOGIN usuario_juan
WITH PASSWORD = 'TuPasswordFuerte123!'
GO

/* Creamos un usuario limitado */
CREATE LOGIN usuario_pedro
WITH PASSWORD = 'TuPasswordFuerte123!'
GO

CREATE USER usuario_juan FOR LOGIN usuario_juan;
CREATE USER usuario_pedro FOR LOGIN usuario_pedro;

/*Modificar contraseñas de los usuarios*/
ALTER LOGIN usuario_juan 
WITH PASSWORD = 'UserJuan!';

ALTER LOGIN usuario_pedro
WITH PASSWORD = 'UserPedro!';


/* Juan solo puede mirar (SELECT), no tocar */
GRANT SELECT ON Productos TO usuario_juan;