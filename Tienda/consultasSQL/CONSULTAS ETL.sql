/*
ARCHIVO 3: CONSULTAS PARA VISUAL STUDIO (OLE DB SOURCE)
Estas consultas extraen los datos del OLTP transformándolos para el DWH.
*/

-- =================================================================
-- BLOQUE 1: SUCURSALES
-- Explicación: Extraemos el ID tal cual para usarlo como PK en DWH.
-- Manejamos nulos en Latitud/Longitud.
-- =================================================================
SELECT 
    SucursalID,      -- Va directo a SucursalID en DWH
    NombreSucursal,
    Ciudad,
    ISNULL(Latitud, 0.0) AS Latitud,
    ISNULL(Longitud, 0.0) AS Longitud
FROM OLTP.Sucursales;

-- =================================================================
-- BLOQUE 2: EMPLEADOS
-- Explicación: Hacemos JOIN con Sucursales para traer el NOMBRE de la 
-- sucursal asignada, no el ID (Desnormalización solicitada).
-- =================================================================
SELECT 
    e.EmpleadoID,
    e.Nombre + ' ' + e.Apellido AS NombreCompleto,
    c.NombrePuesto AS Puesto,
    s.NombreSucursal AS SucursalAsignada -- Traemos el nombre, no el ID
FROM OLTP.Empleados e
JOIN OLTP.Cargo c ON e.PuestoID_FK = c.PuestoID
JOIN OLTP.Sucursales s ON e.SucursalID_FK = s.SucursalID;

-- =================================================================
-- BLOQUE 3: PRODUCTOS
-- Explicación: Traemos los nombres de Categoria y Proveedor.
-- =================================================================
SELECT 
    p.ProductoID,
    p.NombreProducto,
    c.NombreCategoria AS Categoria,   -- Nombre, no ID
    pr.NombreProveedor AS Proveedor,  -- Nombre, no ID
    p.PrecioVenta AS PrecioBase
FROM OLTP.Productos p
JOIN OLTP.Categorias c ON p.CategoriaID_FK = c.CategoriaID
JOIN OLTP.Proveedores pr ON p.ProveedorID_FK = pr.ProveedorID;

-- =================================================================
-- BLOQUE 4: HECHOS (VENTAS)
-- Explicación: Aquí está la lógica fuerte. Calculamos el Impuesto
-- a nivel de línea (15%) y convertimos el TipoPago de texto a ID.
-- =================================================================
SELECT 
    -- IDs para conectar con Dimensiones
    enc.SucursalID_FK AS SucursalID,
    enc.EmpleadoID_FK AS EmpleadoID,
    det.ProductoID_FK AS ProductoID,
    
    -- Transformar Texto a ID para TipoPago
    CASE enc.TipoPago
        WHEN 'Efectivo' THEN 1
        WHEN 'Tarjeta Crédito' THEN 2
        WHEN 'Tarjeta Débito' THEN 3
        ELSE 4 -- Desconocido
    END AS TipoPagoID,
    
    -- Fecha para conectar con Dim_Tiempo (se transformará en SSIS)
    enc.FechaHora,
    
    -- Métricas
    det.Cantidad,
    det.PrecioVentaUnitario AS PrecioUnitario,
    
    -- Cálculos Monetarios
    (det.Cantidad * det.PrecioVentaUnitario) AS SubTotalBruto,
    det.DescuentoAplicado AS Descuento,
    
    -- Cálculo del Impuesto (15% sobre el monto con descuento)
    CAST(((det.Cantidad * det.PrecioVentaUnitario) - det.DescuentoAplicado) * 0.15 AS DECIMAL(18,2)) AS Impuesto,
    
    -- Total Final = (Subtotal - Descuento) + Impuesto
    CAST(((det.Cantidad * det.PrecioVentaUnitario) - det.DescuentoAplicado) * 1.15 AS DECIMAL(18,2)) AS TotalFinal,
    
    -- Trazabilidad
    enc.FacturaID AS FacturaID_BK

FROM OLTP.FacturaDetalle det
JOIN OLTP.FacturaEncabezado enc ON det.FacturaID_FK = enc.FacturaID;