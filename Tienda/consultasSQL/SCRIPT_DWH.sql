/*
ARCHIVO 2: DATA WAREHOUSE (DWH) - Estructura Final
Cambio Clave: Las PKs de las dimensiones ahora son manuales (mismo ID que OLTP).
*/
USE master
GO
CREATE DATABASE Supermercado_DWH_Final;
GO
USE Supermercado_DWH_Final;
GO
CREATE SCHEMA DWH;
GO

-- =============================================
-- DIMENSIONES (Sin Identity en la PK)
-- =============================================

CREATE TABLE DWH.Dim_Tiempo (
    TiempoID INT PRIMARY KEY, -- YYYYMMDD
    FechaCompleta DATE,
    Anio INT,
    Mes INT,
    NombreMes VARCHAR(20),
    Dia INT,
    DiaSemana VARCHAR(20),
    EsFinDeSemana BIT
);

CREATE TABLE DWH.Dim_Sucursal (
    SucursalID INT PRIMARY KEY, -- Mismo ID que OLTP
    NombreSucursal VARCHAR(150),
    Ciudad VARCHAR(150),
    Latitud DECIMAL(10,6),
    Longitud DECIMAL(10,6)
);

CREATE TABLE DWH.Dim_Empleado (
    EmpleadoID INT PRIMARY KEY, -- Mismo ID que OLTP
    NombreCompleto VARCHAR(300),
    Puesto VARCHAR(50),
    SucursalAsignada VARCHAR(100) -- Traemos el nombre, no el ID
);

CREATE TABLE DWH.Dim_Producto (
    ProductoID INT PRIMARY KEY, -- Mismo ID que OLTP
    NombreProducto VARCHAR(150),
    Categoria VARCHAR(100), -- Nombre, no ID
    Proveedor VARCHAR(150), -- Nombre, no ID
    PrecioBase DECIMAL(10,2)
);

CREATE TABLE DWH.Dim_TipoPago (
    TipoPagoID INT PRIMARY KEY, -- Generado manualmente 1, 2, 3...
    MetodoPago VARCHAR(30)
);

-- =============================================
-- TABLA DE HECHOS
-- =============================================
CREATE TABLE DWH.Hechos_Ventas (
    ID BIGINT IDENTITY(1,1) PRIMARY KEY, -- ID interno del hecho
    
    -- Llaves Foráneas (Apuntan a los IDs del OLTP que ahora son PKs en Dim)
    TiempoID INT NOT NULL,
    SucursalID INT NOT NULL,
    ProductoID INT NOT NULL,
    EmpleadoID INT NOT NULL,
    TipoPagoID INT NOT NULL,
    
    -- Dimensiones Degeneradas
    FacturaID_BK INT, 
    
    -- Métricas
    Cantidad INT,
    PrecioUnitario DECIMAL(18,2),
    SubTotal DECIMAL(18,2),
    Descuento DECIMAL(18,2),
    Impuesto DECIMAL(18,2), -- Nuevo Campo Solicitado
    TotalFinal DECIMAL(18,2),
    
    FOREIGN KEY (TiempoID) REFERENCES DWH.Dim_Tiempo(TiempoID),
    FOREIGN KEY (SucursalID) REFERENCES DWH.Dim_Sucursal(SucursalID),
    FOREIGN KEY (ProductoID) REFERENCES DWH.Dim_Producto(ProductoID),
    FOREIGN KEY (EmpleadoID) REFERENCES DWH.Dim_Empleado(EmpleadoID),
    FOREIGN KEY (TipoPagoID) REFERENCES DWH.Dim_TipoPago(TipoPagoID)
);
GO

-- =============================================
-- LLENADO DE TIEMPO Y PAGO (Estáticos)
-- =============================================
-- (Ejecutar este bloque una sola vez)

-- 1. TIEMPO
SET LANGUAGE 'Spanish';
DECLARE @Fecha DATE = '2023-01-01', @Fin DATE = '2026-12-31';
WHILE @Fecha <= @Fin BEGIN
    INSERT INTO DWH.Dim_Tiempo VALUES (
        CAST(FORMAT(@Fecha,'yyyyMMdd') AS INT), @Fecha, YEAR(@Fecha), MONTH(@Fecha),
        DATENAME(MONTH,@Fecha), DAY(@Fecha), DATENAME(WEEKDAY,@Fecha),
        CASE WHEN DATEPART(WEEKDAY,@Fecha) IN (1,7) THEN 1 ELSE 0 END
    );
    SET @Fecha = DATEADD(DAY, 1, @Fecha);
END

-- 2. TIPO PAGO (Manual porque no hay tabla en OLTP, es un string)
INSERT INTO DWH.Dim_TipoPago VALUES 
(1, 'Efectivo'), (2, 'Tarjeta Crédito'), (3, 'Tarjeta Débito'), (4, 'Desconocido');
GO