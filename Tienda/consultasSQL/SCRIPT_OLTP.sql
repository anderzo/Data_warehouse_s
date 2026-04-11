/*
ARCHIVO 1: OLTP COMPLETO Y CORREGIDO
Ejecutar en: SQL Server Management Studio
*/

CREATE DATABASE Supermercado_OLTP_Final;
GO
USE Supermercado_OLTP_Final;
GO
CREATE SCHEMA OLTP;
GO

-- =============================================
-- 1. ESTRUCTURA DE TABLAS
-- =============================================

CREATE TABLE OLTP.Sucursales (
    SucursalID INT PRIMARY KEY IDENTITY(1,1),
    NombreSucursal VARCHAR(100) NOT NULL,
    Direccion VARCHAR(255),
    Ciudad VARCHAR(100),
    Latitud DECIMAL(10, 6),
    Longitud DECIMAL(10, 6)
);


CREATE TABLE OLTP.Categorias (
    CategoriaID INT PRIMARY KEY IDENTITY(1,1),
    CodigoCategoria VARCHAR(20), 
    NombreCategoria VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255),
    CategoriaPadreID INT NULL
);

CREATE TABLE OLTP.Proveedores (
    ProveedorID INT PRIMARY KEY IDENTITY(1,1),
    CodigoProveedor VARCHAR(20) NOT NULL,
    NombreProveedor VARCHAR(150) NOT NULL,
    RTN VARCHAR(20)
);

CREATE TABLE OLTP.Cargo(
    PuestoID INT PRIMARY KEY IDENTITY(1,1),
    NombrePuesto VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(255) NULL
);

CREATE TABLE OLTP.Empleados (
    EmpleadoID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    PuestoID_FK INT NOT NULL,
    SucursalID_FK INT NOT NULL,
    CorreoElectronico VARCHAR(100),
    FechaIngreso DATE,
    FOREIGN KEY (PuestoID_FK) REFERENCES OLTP.Cargo(PuestoID),
    FOREIGN KEY (SucursalID_FK) REFERENCES OLTP.Sucursales(SucursalID)
);

CREATE TABLE OLTP.Productos (
    ProductoID INT PRIMARY KEY IDENTITY(1,1),
    NombreProducto VARCHAR(150) NOT NULL,
    PrecioVenta DECIMAL(10, 2) NOT NULL,
    CategoriaID_FK INT,
    ProveedorID_FK INT,
    Stock INT DEFAULT 1000, -- Stock inicial alto para pruebas
    FOREIGN KEY (CategoriaID_FK) REFERENCES OLTP.Categorias(CategoriaID),
    FOREIGN KEY (ProveedorID_FK) REFERENCES OLTP.Proveedores(ProveedorID)
);

CREATE TABLE OLTP.Promociones (
    PromocionID INT PRIMARY KEY IDENTITY(1,1),
    NombrePromocion VARCHAR(100) NOT NULL,
    FechaInicio DATE,
    FechaFin DATE,
    TipoDescuento VARCHAR(50) -- 'Porcentaje', 'MontoFijo'
);

CREATE TABLE OLTP.Producto_Promocion (
    PromocionID_FK INT NOT NULL,
    ProductoID_FK INT NOT NULL,
    ValorDescuento DECIMAL(5, 2), -- Ej: 0.10 para 10%
    PRIMARY KEY (PromocionID_FK, ProductoID_FK), 
    FOREIGN KEY (PromocionID_FK) REFERENCES OLTP.Promociones(PromocionID),
    FOREIGN KEY (ProductoID_FK) REFERENCES OLTP.Productos(ProductoID)
);

-- Tablas Transaccionales
CREATE TABLE OLTP.FacturaEncabezado (
    FacturaID INT PRIMARY KEY IDENTITY(1,1),
    FechaHora DATETIME NOT NULL,
    EmpleadoID_FK INT,
    SucursalID_FK INT,
    TipoPago VARCHAR(30), 
    SubTotal DECIMAL(18,2), -- Nuevo campo para claridad
    Impuesto DECIMAL(18,2), -- Nuevo campo ISV
    DescuentoTotal DECIMAL(18,2),
    TotalFactura DECIMAL(18, 2),
    FOREIGN KEY (EmpleadoID_FK) REFERENCES OLTP.Empleados(EmpleadoID),
    FOREIGN KEY (SucursalID_FK) REFERENCES OLTP.Sucursales(SucursalID)
);

CREATE TABLE OLTP.FacturaDetalle (
    DetalleID INT PRIMARY KEY IDENTITY(1,1),
    FacturaID_FK INT NOT NULL,
    ProductoID_FK INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioVentaUnitario DECIMAL(10, 2) NOT NULL,
    DescuentoAplicado DECIMAL(10, 2) DEFAULT 0, -- Descuento por línea
    FOREIGN KEY (FacturaID_FK) REFERENCES OLTP.FacturaEncabezado(FacturaID),
    FOREIGN KEY (ProductoID_FK) REFERENCES OLTP.Productos(ProductoID)
);
GO

