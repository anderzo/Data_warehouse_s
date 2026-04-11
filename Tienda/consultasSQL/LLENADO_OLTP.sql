USE Supermercado_OLTP_Final; 
GO

SET NOCOUNT ON;

-- =============================================
-- 1. SUCURSALES (Datos Geográficos Reales)
-- =============================================
PRINT 'Insertando Sucursales...';
INSERT INTO OLTP.Sucursales (NombreSucursal, Direccion, Ciudad, Latitud, Longitud)
VALUES
('Sucursal TG1', 'Centro de Tegusigalpa', 'Tegucigalpa', 14.104954, -87.204245),
('Sucursal TG2', 'Blvr Fuerzas Aramdas', 'Tegucigalpa', 14.0852, -87.2181),
('Sucursal SP1', '7 calle SO', 'San Pedro Sula', 15.5002, -88.0246),
('Sucursal TG3', 'Blvr Santa Cristina', 'Tegucigalpa', 14.0725, -87.1921),
('Sucursal SP2', 'Ave Juan Pablo II', 'San Pedro Sula', 15.518067, -88.020791),
('Sucursal TG4', 'City Mall', 'Tegucigalpa', 14.062838, -87.219653),
('Sucursal LC1', 'AV Morazan', 'La Ceiba', 15.782125, -86.793827),
('Sucursal CG', 'Calle principal', 'Comayagua', 14.437349, -87.634424);
go

-- =============================================
-- 2. CATEGORÍAS (Estructura Jerárquica)
-- =============================================
PRINT 'Insertando Categorías...';
INSERT INTO OLTP.Categorias (CodigoCategoria, NombreCategoria, Descripcion, CategoriaPadreID)
VALUES 
('ALIM', 'Alimentos', 'Departamento de alimentos básicos y preparados', NULL),
('BEBI', 'Bebidas', 'Todas las bebidas, alcohólicas y no alcohólicas', NULL),
('CARN', 'Carnes y Embutidos', 'Carnes frescas y embutidos', NULL),
('LACT', 'Lácteos', 'Productos lacteaos', NULL),
('CONG', 'Congelados', 'Alimentos y comidas congeladas', NULL),
('FRVE', 'Frutas y Verduras', 'Frutas y verduras frescas', NULL),
('HIGI', 'Higiene Personal', 'Productos de cuidado personal', NULL),
('LIMP', 'Limpieza del Hogar', 'Detergentes y limpieza', NULL),
('BEBE', 'Cuidado del Bebé', 'Productos para bebés', NULL),
('MASC', 'Mascotas', 'Alimentos y accesorios para mascotas', NULL),
('FARM', 'Farmacia', 'Medicamentos y suplementos', NULL),
('HOG', 'Hogar y Cocina', 'Utensilios y organización del hogar', NULL),
('PAP', 'Papelería y Oficina', 'Artículos de papelería y oficina', NULL),
('TEC', 'Tecnología ', 'Electrónica de consumo pequeña', NULL);
-- Subcategorías (Simplificado para el ejemplo masivo)
DECLARE @ALIM INT, @BEBI INT, @CARN INT, @LACT INT, @CONG INT, @FRVE INT,
        @HIGI INT, @LIMP INT, @BEBE INT, @MASC INT, @FARM INT, @HOG INT, @PAP INT, @TEC INT;

SELECT @ALIM = CategoriaID FROM OLTP.Categorias WHERE CodigoCategoria='ALIM'
SELECT @CARN = CategoriaID FROM OLTP.Categorias WHERE CodigoCategoria='CARN'
SELECT @LACT = CategoriaID FROM OLTP.Categorias WHERE CodigoCategoria='LACT'
SELECT @CONG = CategoriaID FROM OLTP.Categorias WHERE CodigoCategoria='CONG'
SELECT @FRVE = CategoriaID FROM OLTP.Categorias WHERE CodigoCategoria='FRVE'
SELECT @HIGI = CategoriaID FROM OLTP.Categorias WHERE CodigoCategoria='HIGI'
SELECT @LIMP = CategoriaID FROM OLTP.Categorias WHERE CodigoCategoria='LIMP'
SELECT @BEBE = CategoriaID FROM OLTP.Categorias WHERE CodigoCategoria='BEBE'
SELECT @MASC = CategoriaID FROM OLTP.Categorias WHERE CodigoCategoria='MASC'
SELECT @FARM = CategoriaID FROM OLTP.Categorias WHERE CodigoCategoria='FARM'
SELECT @HOG = CategoriaID FROM OLTP.Categorias WHERE CodigoCategoria='HOG'
SELECT @PAP = CategoriaID FROM OLTP.Categorias WHERE CodigoCategoria='PAP'
SELECT @TEC = CategoriaID FROM OLTP.Categorias WHERE CodigoCategoria='TEC'

-- INSERT SUBCATEGORIAS
INSERT INTO OLTP.Categorias (CodigoCategoria, NombreCategoria, Descripcion, CategoriaPadreID)
VALUES
-- Alimentos
('GRAN', 'Granos básicos', 'Arroz, frijoles entre otros', @ALIM),
('PAN', 'Panadería y Tortillas', 'Pan fresco y tortillas', @ALIM),

-- Bebidas
('JUG', 'Jugos', 'Jugos naturales y envasados', @BEBI),
('ALC', 'Bebidas Alcohólicas', 'Cervezas, vinos y licores', @BEBI),

-- Carnes y Embutidos
('POL', 'Pollo', 'Carne de pollo fresca', @CARN),
('RES', 'Res', 'Carne de res fresca', @CARN),
('CER', 'Cerdo', 'Carne de cerdo', @CARN),

-- Lácteos
('LEC', 'Leche', 'Leche pasteurizada y fresca', @LACT),
('YOG', 'Yogurt', 'Yogurts y bebidas lácteas', @LACT),
('QUE', 'Quesos', 'Quesos frescos y procesados', @LACT),

-- Congelados
('HEL', 'Helados', 'Helados y postres congelados', @CONG),

-- Frutas y Verduras
('FRU', 'Frutas', 'Frutas frescas', @FRVE),
('VER', 'Verduras', 'Verduras frescas', @FRVE),

-- Higiene Personal
('JAB', 'Jabones', 'Jabones en barra o líquidos', @HIGI),
('SHAM', 'Shampoo y Acondicionador', 'Productos para cabello', @HIGI),

-- Limpieza del Hogar
('DETE', 'Detergentes', 'Detergentes para ropa', @LIMP),
('CLOR', 'Cloro y desinfectantes', 'Productos desinfectantes', @LIMP),

-- Mascotas
('ALPE', 'Alimentos para Perros', 'Comida para perros', @MASC),
('ALGA', 'Alimentos para Gatos', 'Comida para gatos', @MASC),
('ACC', 'Accesorios', 'Correas, platos, juguetes', @MASC),

-- Farmacia 
('ANA', 'Analgésicos', 'Medicamentos de venta libre', @FARM),
('VIT', 'Vitaminas', 'Vitaminas y suplementos', @FARM),

-- Hogar y Cocina
('UTEN', 'Utensilios de Cocina', 'Sartenes, ollas, etc.', @HOG),
('ELEC', 'Electrodomésticos Pequeños', 'Licuadoras, batidoras, etc.', @HOG),

-- Papelería y Oficina
('CUAD', 'Cuadernos y Libros', 'Cuadernos y libros escolares', @PAP),
('LAP', 'Lápices y Bolígrafos', 'Material de escritura', @PAP),

-- Tecnología
('CARG', 'Cargadores', 'Cargadores para dispositivos', @TEC),
('AUD', 'Audífonos', 'Audífonos y auriculares', @TEC)
go

-- =============================================
-- 3. PROVEEDORES (Con Códigos Generados)
-- =============================================
INSERT INTO OLTP.Proveedores (CodigoProveedor, NombreProveedor, RTN)
VALUES
('PROV001', 'Cervecería Hondureña', '01011985012345'),
('PROV002', 'La Pradera S.A.', '01011990054321'),
('PROV003', 'Grupo Jaremar', '01011987123456'),
('PROV004', 'Lácteos de Honduras', '01011988098765'),
('PROV005', 'Alimentos Marinos S.A.', '01011992011223'),
('PROV006', 'Distribuidora La Colonia', '01011989033445'),
('PROV007', 'Café de Honduras', '01011986055667'),
('PROV008', 'Panadería Industrial S.A.', '01011987077889'),
('PROV009', 'Refrescos y Bebidas S.A.', '01011990099887'),
('PROV010', 'Industrias Lácteas La Pradera', '01011985044321'),
('PROV011', 'Azucarera Hondureña', '01011988011234'),
('PROV012', 'Embutidos La Fama', '01011989066778'),
('PROV013', 'Aceites y Grasas Tropicales', '01011991022334'),
('PROV014', 'Distribuidora Multi Alimentos', '01011992044556'),
('PROV015', 'Importadora Hondureña S.A.', '01011993066789');
go

-- =============================================
-- 4. CARGOS Y EMPLEADOS
-- =============================================
INSERT INTO OLTP.Cargo(NombrePuesto, Descripcion)
VALUES
('Cajero', 'Responsable de caja y cobros'),
('Gerente', 'Responsable de la gestión de la sucursal'),
('Auxiliar de Ventas', 'Apoya en atención al cliente y reposición de productos');
go

INSERT INTO OLTP.Empleados (Nombre, Apellido, PuestoID_FK, SucursalID_FK, CorreoElectronico, FechaIngreso)
VALUES
-- Sucursal 1
('Ana', 'García', 1, 1, 'ana.garcia@empresa.com', '2022-03-15'),
('Luis', 'Martínez', 1, 1, 'luis.martinez@empresa.com', '2023-01-20'),
('Sofia', 'López', 3, 1, 'sofia.lopez@empresa.com', '2021-08-10'),
('Carlos', 'Rodríguez', 2, 1, 'carlos.rodriguez@empresa.com', '2019-05-12'),

-- Sucursal 2
('María', 'Hernández', 1, 2, 'maria.hernandez@empresa.com', '2022-06-18'),
('Jorge', 'Gómez', 1, 2, 'jorge.gomez@empresa.com', '2023-02-25'),
('Elena', 'Díaz', 3, 2, 'elena.diaz@empresa.com', '2021-11-30'),
('Roberto', 'Pérez', 2, 2, 'roberto.perez@empresa.com', '2020-04-08'),

-- Sucursal 3
('Carmen', 'Sánchez', 1, 3, 'carmen.sanchez@empresa.com', '2022-09-05'),
('Diego', 'Ramírez', 1, 3, 'diego.ramirez@empresa.com', '2023-03-12'),
('Patricia', 'Torres', 3, 3, 'patricia.torres@empresa.com', '2021-07-22'),
('Fernando', 'Flores', 2, 3, 'fernando.flores@empresa.com', '2018-10-15'),

-- Sucursal 4
('Gabriela', 'Ruiz', 1, 4, 'gabriela.ruiz@empresa.com', '2022-04-28'),
('Ricardo', 'Vargas', 1, 4, 'ricardo.vargas@empresa.com', '2023-05-17'),
('Isabel', 'Castro', 3, 4, 'isabel.castro@empresa.com', '2021-12-03'),
('Miguel', 'Reyes', 2, 4, 'miguel.reyes@empresa.com', '2019-08-20'),

-- Sucursal 5
('Andrea', 'Morales', 1, 5, 'andrea.morales@empresa.com', '2022-07-14'),
('Oscar', 'Ortega', 1, 5, 'oscar.ortega@empresa.com', '2023-04-09'),
('Laura', 'Guerrero', 3, 5, 'laura.guerrero@empresa.com', '2021-09-18'),
('José', 'Silva', 2, 5, 'jose.silva@empresa.com', '2020-01-25'),

-- Sucursal 6
('Daniela', 'Mendoza', 1, 6, 'daniela.mendoza@empresa.com', '2022-11-08'),
('Raúl', 'Rojas', 1, 6, 'raul.rojas@empresa.com', '2023-06-30'),
('Verónica', 'Navarro', 3, 6, 'veronica.navarro@empresa.com', '2021-05-12'),
('Francisco', 'Cortés', 2, 6, 'francisco.cortes@empresa.com', '2019-03-22'),

-- Sucursal 7
('Teresa', 'Salazar', 1, 7, 'teresa.salazar@empresa.com', '2022-08-19'),
('Alberto', 'Delgado', 1, 7, 'alberto.delgado@empresa.com', '2023-07-11'),
('Monica', 'Herrera', 3, 7, 'monica.herrera@empresa.com', '2021-10-05'),
('Javier', 'Orozco', 2, 7, 'javier.orozco@empresa.com', '2020-02-14'),

-- Sucursal 8
('Rosa', 'Campos', 1, 8, 'rosa.campos@empresa.com', '2022-12-01'),
('Héctor', 'Juárez', 1, 8, 'hector.juarez@empresa.com', '2023-08-24'),
('Eduardo', 'Méndez', 3, 8, 'eduardo.mendez@empresa.com', '2021-04-16'),
('Margarita', 'Santos', 2, 8, 'margarita.santos@empresa.com', '2019-11-28');
go



-- =============================================
-- 5. PRODUCTOS (Masivos con Precios Variados)
-- =============================================

INSERT INTO OLTP.Productos (NombreProducto, PrecioVenta, CategoriaID_FK, ProveedorID_FK, Stock) VALUES

-- Bebidas Alcohólicas 
('Cerveza Salva Vida 12oz 6-pack', 120.00, 18, 1, 50),
('Cerveza Port Royal 12oz 6-pack', 125.00, 18, 1, 45),
('Ron Flor de Caña 4 años 750ml', 180.00, 18, 15, 25),

-- Jugos 
('Jugo Del Valle Naranja 1L', 35.00, 16, 9, 60),
('Jugo Del Valle Manzana 1L', 35.00, 16, 9, 55),
('Jugo Citríco Pulpy 1L', 38.00, 16, 9, 40),

-- Granos básicos
('Arroz Grano de Oro 5kg', 95.00, 15, 3, 80),
('Frijol Rojo Seda 2kg', 85.00, 15, 3, 70),
('Azúcar Morena 5kg', 65.00, 15, 11, 90),

-- Panadería 
('Pan Bimbo Blanco Grande', 42.00, 17, 8, 40),
('Tortillas de Harina 10un', 25.00, 17, 8, 35),

-- Carnes 
('Pechuga de Pollo 1kg', 85.00, 19, 2, 30),
('Muslos de Pollo 1kg', 65.00, 19, 2, 40),

-- Carnes 
('Filete de Res 1kg', 220.00, 20, 2, 20),
('Carne Molida de Res 1kg', 180.00, 20, 2, 25),

-- Carnes 
('Lomo de Cerdo 1kg', 120.00, 21, 12, 30),
('Chuleta de Cerdo 1kg', 110.00, 21, 12, 35),

-- Lácteos 
('Leche Sula Entera 1L', 28.00, 22, 4, 100),
('Leche Sula Deslactosada 1L', 32.00, 22, 4, 80),

-- Lácteos 
('Yogurt Sula Fresa 1L', 45.00, 23, 4, 60),
('Yogurt Sula Natural 1L', 42.00, 23, 4, 50),

-- Lácteos 
('Queso Seco La Pradera 500g', 75.00, 24, 10, 40),
('Queso Mozzarella 500g', 85.00, 24, 10, 35),

-- Congelados 
('Helado Sula Vainilla 1L', 65.00, 25, 4, 30),
('Helado Sula Chocolate 1L', 65.00, 25, 4, 25),

-- Frutas 
('Banano 1kg', 15.00, 26, 6, 50),
('Naranjas 1kg', 20.00, 26, 6, 45),

-- Verduras 
('Tomates 1kg', 25.00, 27, 6, 40),
('Cebollas 1kg', 18.00, 27, 6, 55),

-- Higiene 
('Jabón Protex 3un', 45.00, 28, 6, 70),
('Jabón Dove 3un', 55.00, 28, 6, 60),

-- Higiene 
('Shampoo Head & Shoulders 400ml', 120.00, 29, 6, 40),
('Acondicionador Pantene 400ml', 130.00, 29, 6, 35),

-- Limpieza 
('Detergente Ace 1kg', 65.00, 30, 6, 50),
('Detergente Ariel 1kg', 70.00, 30, 6, 45),

-- Limpieza 
('Cloro Clorox 1L', 25.00, 31, 6, 65),
('Desinfectante Fabuloso 1L', 30.00, 31, 6, 55),

-- Mascotas 
('Alimento para Perro Pedigree 3kg', 180.00, 32, 14, 30),
('Alimento para Perro Dog Chow 3kg', 170.00, 32, 14, 35),

-- Mascotas 
('Alimento para Gato Whiskas 1kg', 90.00, 33, 14, 25),
('Alimento para Gato Cat Chow 1kg', 85.00, 33, 14, 30),

-- Mascotas 
('Collar para Perro Mediano', 45.00, 34, 14, 20),
('Juguete para Gato', 35.00, 34, 14, 25),

-- Farmacia 
('Aspirina 500mg 10 tabletas', 25.00, 35, 6, 40),
('Acetaminofén 500mg 10 tabletas', 20.00, 35, 6, 50),

-- Farmacia 
('Vitamina C 500mg 30 tabletas', 45.00, 36, 6, 35),
('Multivitamínico Centrum 30 tabletas', 120.00, 36, 6, 25),

-- Hogar 
('Juego de Cuchillos 3pzs', 150.00, 37, 15, 15),
('Sartén Antiadherente 24cm', 200.00, 37, 15, 12),

-- Hogar 
('Licuadora Oster 3 velocidades', 450.00, 38, 15, 8),
('Batidora de Mano', 350.00, 38, 15, 10),

-- Papelería 
('Cuaderno Norma 100 hojas', 35.00, 39, 15, 60),
('Libro de Contabilidad', 80.00, 39, 15, 20),

-- Papelería 
('Lápices Mirado 12un', 25.00, 40, 15, 75),
('Bolígrafos Bic 10un', 30.00, 40, 15, 80),

-- Tecnología 
('Cargador iPhone Original', 250.00, 41, 15, 15),
('Cargador Samsung Tipo C', 180.00, 41, 15, 18),

-- Tecnología
('Audífonos Inalámbricos Bluetooth', 300.00, 42, 15, 12),
('Audífonos con Cable iPhone', 120.00, 42, 15, 20);
go

-- =============================================
-- 6. PROMOCIONES (Para cumplir requisito)
-- =============================================
INSERT INTO OLTP.Promociones (NombrePromocion, FechaInicio, FechaFin, TipoDescuento) VALUES
('Black Friday', '2025-11-01', '2024-11-29', 'Porcentaje'),
('Navidad 2024', '2025-12-01', '2024-12-31', 'Porcentaje'),
('Verano 2024', '2025-06-01', '2024-08-31', 'Porcentaje'),
('Vuelta a Clases', '2025-01-20', '2024-03-20', 'Porcentaje'),
('Día de la Madre', '2025-04-15', '2024-05-15', 'Porcentaje'),
('Semana Santa', '2025-05-15', '2024-06-30', 'Porcentaje'),
('Halloween', '2024-10-25', '2024-10-31', 'Porcentaje')
go

-- =============================================
-- 7. GENERACIÓN DE VENTAS (EL SCRIPT MODIFICADO)
-- =============================================
PRINT 'Creando Procedimiento de Ventas...';
GO

CREATE OR ALTER PROCEDURE OLTP.GenerarVentasMasivas
    @CantidadFacturas INT = 1000
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @i INT = 1;
    
    PRINT 'Generando ' + CAST(@CantidadFacturas AS VARCHAR) + ' facturas con detalle...';

    WHILE @i <= @CantidadFacturas
    BEGIN
        -- A. DATOS DE ENCABEZADO
        DECLARE @Sucursal INT = (SELECT TOP 1 SucursalID FROM OLTP.Sucursales ORDER BY NEWID());
        -- Buscar empleado de esa sucursal
        DECLARE @Empleado INT = (SELECT TOP 1 EmpleadoID FROM OLTP.Empleados WHERE SucursalID_FK = @Sucursal ORDER BY NEWID());
        IF @Empleado IS NULL SET @Empleado = (SELECT TOP 1 EmpleadoID FROM OLTP.Empleados ORDER BY NEWID());
        
        -- Fecha aleatoria (últimos 2 años)
        DECLARE @Fecha DATETIME = DATEADD(DAY, -1 * (ABS(CHECKSUM(NEWID())) % 730), GETDATE());
        DECLARE @TipoPago VARCHAR(20) = (SELECT TOP 1 P FROM (VALUES ('Efectivo'), ('Tarjeta Crédito'), ('Tarjeta Débito')) AS T(P) ORDER BY NEWID());

        -- Insertar Encabezado Inicial (Con montos en 0)
        INSERT INTO OLTP.FacturaEncabezado (FechaHora, EmpleadoID_FK, SucursalID_FK, TipoPago, SubTotal, Impuesto, DescuentoTotal, TotalFactura)
        VALUES (@Fecha, @Empleado, @Sucursal, @TipoPago, 0, 0, 0, 0);
        
        DECLARE @IDFactura INT = SCOPE_IDENTITY();
        
        -- B. DATOS DE DETALLE (Productos)
        DECLARE @NumItems INT = (ABS(CHECKSUM(NEWID())) % 5) + 1; -- 1 a 5 productos por factura
        DECLARE @k INT = 1;
        
        -- Acumuladores para el Encabezado
        DECLARE @SumaSubTotal DECIMAL(18,2) = 0;
        DECLARE @SumaDescuento DECIMAL(18,2) = 0;
        
        WHILE @k <= @NumItems
        BEGIN
            DECLARE @ProdID INT, @Precio DECIMAL(10,2);
            -- Seleccionar producto al azar
            SELECT TOP 1 @ProdID = ProductoID, @Precio = PrecioVenta FROM OLTP.Productos ORDER BY NEWID();
            
            DECLARE @Cant INT = (ABS(CHECKSUM(NEWID())) % 5) + 1; -- 1 a 5 unidades
            
            -- Verificar si tiene promoción activa
            DECLARE @DescPorcentaje DECIMAL(5,2) = 0;
            SELECT @DescPorcentaje = ValorDescuento 
            FROM OLTP.Producto_Promocion 
            WHERE ProductoID_FK = @ProdID;
            
            -- Calcular montos de la línea
            DECLARE @MontoBrutoLinea DECIMAL(18,2) = @Precio * @Cant;
            DECLARE @MontoDescuentoLinea DECIMAL(18,2) = @MontoBrutoLinea * ISNULL(@DescPorcentaje, 0);
            
            -- Insertar Detalle (Incluyendo el campo DescuentoAplicado)
            INSERT INTO OLTP.FacturaDetalle (FacturaID_FK, ProductoID_FK, Cantidad, PrecioVentaUnitario, DescuentoAplicado)
            VALUES (@IDFactura, @ProdID, @Cant, @Precio, @MontoDescuentoLinea);
            
            -- Sumar a los acumuladores globales de la factura
            SET @SumaSubTotal = @SumaSubTotal + @MontoBrutoLinea;
            SET @SumaDescuento = @SumaDescuento + @MontoDescuentoLinea;
            
            -- Bajar Stock
            UPDATE OLTP.Productos SET Stock = Stock - @Cant WHERE ProductoID = @ProdID;
            
            SET @k = @k + 1;
        END
        
        -- C. ACTUALIZAR ENCABEZADO (Cálculo Final con Impuestos)
        DECLARE @SubTotalNeto DECIMAL(18,2) = @SumaSubTotal - @SumaDescuento;
        DECLARE @Impuesto DECIMAL(18,2) = @SubTotalNeto * 0.15; -- 15% ISV
        DECLARE @TotalFinal DECIMAL(18,2) = @SubTotalNeto + @Impuesto;
        
        UPDATE OLTP.FacturaEncabezado 
        SET SubTotal = @SumaSubTotal,
            DescuentoTotal = @SumaDescuento,
            Impuesto = @Impuesto,
            TotalFactura = @TotalFinal
        WHERE FacturaID = @IDFactura;
        
        SET @i = @i + 1;
    END
    PRINT 'Ventas Generadas Exitosamente.';
END;
GO

-- =============================================
-- 8. EJECUCIÓN FINAL
-- =============================================
-- Generar 2000 facturas para tener buen volumen de datos
EXEC OLTP.GenerarVentasMasivas @CantidadFacturas = 2000;
GO

-- Verificación
SELECT COUNT(*) AS TotalVentas FROM OLTP.FacturaEncabezado;
SELECT TOP 5 * FROM OLTP.FacturaEncabezado;
GO
