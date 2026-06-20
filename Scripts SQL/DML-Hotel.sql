-- Población de datos para el sistema de gestión hotelera

-- hotel
insert into hotel (nombre, direccion, correo, telefono) values
('Hotel Real Intercontinental', 'Boulevard De Los Heroes, Avenida Sisimiles San Salvador', 
'contacto@hotelrealintercontinental.com', '2211-3333');

-- tipo_habitacion
insert into tipo_habitacion (nombre_tipo, descripcion, capacidad, precio_noche) values
('sencilla', 'habitación para una persona con cama individual', 1, 50.00),
('doble', 'habitación para dos personas con cama matrimonial', 2, 80.00),
('familiar', 'habitación amplia para grupo familiar', 4, 120.00),
('suite', 'habitación premium con sala y jacuzzi', 2, 180.00);

-- habitacion
insert into habitacion (piso, numero_habitacion, capacidad_maxima, estado_habitacion, id_hotel, id_tipo_habitacion) values
(1, '101', 1, 'disponible', 1, 1),
(1, '102', 1, 'disponible', 1, 1),
(1, '103', 2, 'ocupada', 1, 2),
(2, '201', 2, 'disponible', 1, 2),
(2, '202', 2, 'mantenimiento', 1, 2),
(2, '203', 4, 'disponible', 1, 3),
(3, '301', 4, 'ocupada', 1, 3),
(3, '302', 4, 'disponible', 1, 3),
(4, '401', 2, 'disponible', 1, 4),
(4, '402', 2, 'ocupada', 1, 4);

-- nombre_empleado
insert into nombre_empleado (nombre_empleado, apellido_empleado, correo_empleado, telefono_empleado, cargo) values
('carlos', 'ramírez', 'carlos.ramirez@hotelrealintercontinental.com', '7000-1001', 'recepcionista'),
('ana', 'martínez', 'ana.martinez@hotelrealintercontinental.com', '7000-1002', 'recepcionista'),
('jose', 'hernández', 'jose.hernandez@hotelrealintercontinental.com', '7000-1003', 'administrador'),
('maría', 'lópez', 'maria.lopez@hotelrealintercontinental.com', '7000-1004', 'cajera'),
('ricardo', 'pineda', 'ricardo.pineda@hotelrealintercontinental.com', '7000-1005', 'supervisor');

-- huesped
insert into huesped (dui, nombre_huesped, apellido_huesped, telefono_huesped, correo_huesped, direccion_huesped, fecha_registro) values
('01234567-8', 'michelle', 'hernández', '7500-0001', 'michelle.hernandez@gmail.com', 'san salvador', '2026-06-01'),
('12345678-9', 'diego', 'pérez', '7500-0002', 'diego.perez@gmail.com', 'soyapango', '2026-06-02'),
('23456789-0', 'valeria', 'ramirez', '7500-0003', 'valeria.ramirez@gmail.com', 'santa tecla', '2026-06-03'),
('34567890-1', 'fernando', 'morales', '7500-0004', 'fernando.morales@gmail.com', 'apopa', '2026-06-04'),
('45678901-2', 'paola', 'rivas', '7500-0005', 'paola.rivas@gmail.com', 'ilopango', '2026-06-05'),
('56789012-3', 'jacobo', 'flores', '7500-0006', 'jacobo.flores@gmail.com', 'mejicanos', '2026-06-06'),
('67890123-4', 'gabriela', 'torres', '7500-0007', 'gabriela.torres@gmail.com', 'antiguo cuscatlán', '2026-06-07'),
('78901234-5', 'kevin', 'mendoza', '7500-0008', 'kevin.mendoza@gmail.com', 'santa ana', '2026-06-08');

-- servicio
insert into servicio (nombre_servicio, descripcion, precio_base) values
('restaurante', 'consumo de alimentos y bebidas', 15.00),
('lavandería', 'servicio de lavado y planchado', 8.00),
('spa', 'servicio de relajación y masajes', 35.00),
('transporte', 'traslado desde o hacia el aeropuerto', 25.00),
('room service', 'servicio a la habitación', 12.00);

-- reservacion
insert into reservacion (fecha_entrada, fecha_salida, fecha_reserva, estado_reserva, id_habitacion, id_huesped, id_empleado) values
('2026-07-01', '2026-07-04', '2026-06-20 09:00:00', 'completada', 1, 1, 1),
('2026-07-03', '2026-07-06', '2026-06-21 10:30:00', 'completada', 3, 2, 2),
('2026-07-05', '2026-07-08', '2026-06-22 11:15:00', 'confirmada', 4, 3, 1),
('2026-07-10', '2026-07-12', '2026-06-25 14:20:00', 'pendiente', 6, 4, 3),
('2026-07-12', '2026-07-15', '2026-06-26 08:40:00', 'completada', 7, 5, 2),
('2026-07-16', '2026-07-18', '2026-06-28 15:10:00', 'cancelada', 9, 6, 1),
('2026-07-20', '2026-07-23', '2026-07-01 13:00:00', 'completada', 10, 7, 4),
('2026-07-24', '2026-07-26', '2026-07-02 16:30:00', 'confirmada', 2, 8, 5);

-- estancia
insert into estancia (fecha_check_in, hora_check_in, fecha_check_out, hora_check_out, observaciones, id_reservacion) values
('2026-07-01', '14:00:00', '2026-07-04', '11:00:00', 'estancia finalizada sin inconvenientes', 1),
('2026-07-03', '15:00:00', '2026-07-06', '10:30:00', 'huésped solicitó salida temprana', 2),
('2026-07-12', '14:30:00', '2026-07-15', '11:15:00', 'se aplicó cargo por lavandería', 5),
('2026-07-20', '13:45:00', '2026-07-23', '10:45:00', 'factura pagada con tarjeta', 7);

-- consumo_servicio
insert into consumo_servicio (cantidad, precio_unitario, fecha_consumo, id_servicio, id_reservacion) values
(2, 15.00, '2026-07-02 19:30:00', 1, 1),
(1, 8.00, '2026-07-03 09:00:00', 2, 1),
(1, 35.00, '2026-07-04 18:00:00', 3, 2),
(3, 15.00, '2026-07-05 20:00:00', 1, 2),
(2, 8.00, '2026-07-13 10:00:00', 2, 5),
(1, 12.00, '2026-07-14 21:00:00', 5, 5),
(1, 25.00, '2026-07-21 08:00:00', 4, 7),
(2, 15.00, '2026-07-22 19:00:00', 1, 7);

-- factura
insert into factura (metodo_pago, estado_pago, fecha_emision, total_factura, id_reservacion, id_empleado) values
('efectivo', 'pagada', '2026-07-04 11:10:00', 188.00, 1, 4),
('tarjeta credito', 'pagada', '2026-07-06 10:40:00', 320.00, 2, 4),
('transferencia', 'pagada', '2026-07-15 11:20:00', 388.00, 5, 4),
('tarjeta debito', 'pagada', '2026-07-23 10:50:00', 595.00, 7, 4);

-- detalle_factura
insert into detalle_factura (descripcion, cantidad, valor_unitario, id_factura) values
('habitación sencilla por noche', 3, 50.00, 1),
('consumo restaurante', 2, 15.00, 1),
('servicio de lavandería', 1, 8.00, 1),

('habitación doble por noche', 3, 80.00, 2),
('servicio de spa', 1, 35.00, 2),
('consumo restaurante', 3, 15.00, 2),

('habitación familiar por noche', 3, 120.00, 3),
('servicio de lavandería', 2, 8.00, 3),
('room service', 1, 12.00, 3),

('suite por noche', 3, 180.00, 4),
('servicio de transporte', 1, 25.00, 4),
('consumo restaurante', 2, 15.00, 4);

-- población adicional 

-- nuevos huespedes
insert into huesped (
    dui,
    nombre_huesped,
    apellido_huesped,
    telefono_huesped,
    correo_huesped,
    direccion_huesped,
    fecha_registro
) values
('89012345-6', 'sofia', 'aguilar', '7500-0009', 'sofia.aguilar@gmail.com', 'san miguel', '2026-06-09'),
('90123456-7', 'daniel', 'castillo', '7500-0010', 'daniel.castillo@gmail.com', 'la libertad', '2026-06-10'),
('11223344-5', 'camila', 'reyes', '7500-0011', 'camila.reyes@gmail.com', 'sonsonate', '2026-06-11'),
('22334455-6', 'alex', 'guzman', '7500-0012', 'alex.guzman@gmail.com', 'cuscatancingo', '2026-06-12'),
('33445566-7', 'karla', 'ortiz', '7500-0013', 'karla.ortiz@gmail.com', 'san marcos', '2026-06-13'),
('44556677-8', 'ivan', 'ruiz', '7500-0014', 'ivan.ruiz@gmail.com', 'zacatecoluca', '2026-06-14'),
('55667788-9', 'natalia', 'mejia', '7500-0015', 'natalia.mejia@gmail.com', 'cojutepeque', '2026-06-15'),
('66778899-0', 'oscar', 'alvarado', '7500-0016', 'oscar.alvarado@gmail.com', 'ahuachapan', '2026-06-16'),
('77889900-1', 'diana', 'sorto', '7500-0017', 'diana.sorto@gmail.com', 'san vicente', '2026-06-17'),
('88990011-2', 'marvin', 'arias', '7500-0018', 'marvin.arias@gmail.com', 'chalatenango', '2026-06-18'),
('99001122-3', 'jessica', 'vargas', '7500-0019', 'jessica.vargas@gmail.com', 'usulutan', '2026-06-19'),
('10112233-4', 'edgar', 'rodriguez', '7500-0020', 'edgar.rodriguez@gmail.com', 'la union', '2026-06-20');


-- nuevas reservaciones
insert into reservacion (
    fecha_entrada,
    fecha_salida,
    fecha_reserva,
    estado_reserva,
    id_habitacion,
    id_huesped,
    id_empleado
) values
('2026-08-01', '2026-08-03', '2026-07-10 08:00:00', 'completada', 1, (select id_huesped from huesped where dui = '89012345-6'), 1),
('2026-08-04', '2026-08-06', '2026-07-10 09:00:00', 'completada', 2, (select id_huesped from huesped where dui = '90123456-7'), 2),
('2026-08-07', '2026-08-10', '2026-07-11 10:00:00', 'pendiente', 3, (select id_huesped from huesped where dui = '11223344-5'), 1),
('2026-08-11', '2026-08-14', '2026-07-12 11:00:00', 'completada', 4, (select id_huesped from huesped where dui = '22334455-6'), 2),
('2026-08-15', '2026-08-18', '2026-07-13 12:00:00', 'confirmada', 6, (select id_huesped from huesped where dui = '33445566-7'), 3),
('2026-08-19', '2026-08-22', '2026-07-14 13:00:00', 'completada', 7, (select id_huesped from huesped where dui = '44556677-8'), 2),
('2026-08-23', '2026-08-25', '2026-07-15 14:00:00', 'completada', 8, (select id_huesped from huesped where dui = '55667788-9'), 1),
('2026-08-26', '2026-08-29', '2026-07-16 15:00:00', 'pendiente', 9, (select id_huesped from huesped where dui = '66778899-0'), 4),
('2026-08-30', '2026-09-02', '2026-07-17 16:00:00', 'completada', 10, (select id_huesped from huesped where dui = '77889900-1'), 5),
('2026-09-03', '2026-09-05', '2026-07-18 17:00:00', 'confirmada', 1, (select id_huesped from huesped where dui = '88990011-2'), 1),
('2026-09-06', '2026-09-08', '2026-07-19 18:00:00', 'completada', 2, (select id_huesped from huesped where dui = '99001122-3'), 2),
('2026-09-09', '2026-09-12', '2026-07-20 19:00:00', 'pendiente', 4, (select id_huesped from huesped where dui = '10112233-4'), 3);


-- nuevas estancias
insert into estancia (
    fecha_check_in,
    hora_check_in,
    fecha_check_out,
    hora_check_out,
    observaciones,
    id_reservacion
) values
('2026-08-01', '14:10:00', '2026-08-03', '11:00:00', 'estancia finalizada correctamente',
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-01' and id_huesped = (select id_huesped from huesped where dui = '89012345-6'))),

('2026-08-04', '14:30:00', '2026-08-06', '10:50:00', 'huésped solicitó factura electrónica',
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-04' and id_huesped = (select id_huesped from huesped where dui = '90123456-7'))),

('2026-08-11', '15:00:00', '2026-08-14', '11:20:00', 'sin observaciones',
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-11' and id_huesped = (select id_huesped from huesped where dui = '22334455-6'))),

('2026-08-19', '13:40:00', '2026-08-22', '10:30:00', 'se aplicó cargo por spa',
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-19' and id_huesped = (select id_huesped from huesped where dui = '44556677-8'))),

('2026-08-23', '14:15:00', '2026-08-25', '11:10:00', 'consumo en restaurante',
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-23' and id_huesped = (select id_huesped from huesped where dui = '55667788-9'))),

('2026-08-30', '15:20:00', '2026-09-02', '10:45:00', 'salida normal',
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-30' and id_huesped = (select id_huesped from huesped where dui = '77889900-1'))),

('2026-09-06', '14:00:00', '2026-09-08', '11:00:00', 'estancia finalizada sin inconvenientes',
    (select id_reservacion from reservacion where fecha_entrada = '2026-09-06' and id_huesped = (select id_huesped from huesped where dui = '99001122-3')));


-- nuevos consumos de servicio
insert into consumo_servicio (
    cantidad,
    precio_unitario,
    fecha_consumo,
    id_servicio,
    id_reservacion
) values
(1, 15.00, '2026-08-02 12:00:00', 1,
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-01' and id_huesped = (select id_huesped from huesped where dui = '89012345-6'))),

(2, 8.00, '2026-08-02 15:00:00', 2,
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-01' and id_huesped = (select id_huesped from huesped where dui = '89012345-6'))),

(1, 35.00, '2026-08-05 18:00:00', 3,
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-04' and id_huesped = (select id_huesped from huesped where dui = '90123456-7'))),

(1, 25.00, '2026-08-08 09:00:00', 4,
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-07' and id_huesped = (select id_huesped from huesped where dui = '11223344-5'))),

(2, 12.00, '2026-08-12 20:00:00', 5,
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-11' and id_huesped = (select id_huesped from huesped where dui = '22334455-6'))),

(3, 15.00, '2026-08-16 13:00:00', 1,
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-15' and id_huesped = (select id_huesped from huesped where dui = '33445566-7'))),

(1, 8.00, '2026-08-17 10:00:00', 2,
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-15' and id_huesped = (select id_huesped from huesped where dui = '33445566-7'))),

(1, 35.00, '2026-08-20 17:00:00', 3,
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-19' and id_huesped = (select id_huesped from huesped where dui = '44556677-8'))),

(2, 15.00, '2026-08-24 19:00:00', 1,
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-23' and id_huesped = (select id_huesped from huesped where dui = '55667788-9'))),

(1, 25.00, '2026-08-27 07:00:00', 4,
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-26' and id_huesped = (select id_huesped from huesped where dui = '66778899-0'))),

(1, 12.00, '2026-08-31 22:00:00', 5,
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-30' and id_huesped = (select id_huesped from huesped where dui = '77889900-1'))),

(1, 35.00, '2026-09-07 14:00:00', 3,
    (select id_reservacion from reservacion where fecha_entrada = '2026-09-06' and id_huesped = (select id_huesped from huesped where dui = '99001122-3')));


-- nuevas facturas
insert into factura (
    metodo_pago,
    estado_pago,
    fecha_emision,
    total_factura,
    id_reservacion,
    id_empleado
) values
('efectivo', 'pagada', '2026-08-03 11:10:00', 131.00,
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-01' and id_huesped = (select id_huesped from huesped where dui = '89012345-6')), 4),

('tarjeta credito', 'pagada', '2026-08-06 11:00:00', 135.00,
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-04' and id_huesped = (select id_huesped from huesped where dui = '90123456-7')), 4),

('transferencia', 'pagada', '2026-08-14 11:30:00', 264.00,
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-11' and id_huesped = (select id_huesped from huesped where dui = '22334455-6')), 4),

('tarjeta debito', 'pagada', '2026-08-22 10:40:00', 395.00,
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-19' and id_huesped = (select id_huesped from huesped where dui = '44556677-8')), 4),

('efectivo', 'pagada', '2026-08-25 11:15:00', 270.00,
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-23' and id_huesped = (select id_huesped from huesped where dui = '55667788-9')), 4),

('tarjeta credito', 'pagada', '2026-09-02 10:55:00', 552.00,
    (select id_reservacion from reservacion where fecha_entrada = '2026-08-30' and id_huesped = (select id_huesped from huesped where dui = '77889900-1')), 4),

('transferencia', 'pagada', '2026-09-08 11:05:00', 135.00,
    (select id_reservacion from reservacion where fecha_entrada = '2026-09-06' and id_huesped = (select id_huesped from huesped where dui = '99001122-3')), 4);


-- nuevos detalles de factura
insert into detalle_factura (
    descripcion,
    cantidad,
    valor_unitario,
    id_factura
) values
('habitación sencilla por noche', 2, 50.00,
    (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '89012345-6' and r.fecha_entrada = '2026-08-01')),
('consumo restaurante', 1, 15.00,
    (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '89012345-6' and r.fecha_entrada = '2026-08-01')),
('servicio de lavandería', 2, 8.00,
    (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '89012345-6' and r.fecha_entrada = '2026-08-01')),

('habitación sencilla por noche', 2, 50.00,
    (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '90123456-7' and r.fecha_entrada = '2026-08-04')),
('servicio de spa', 1, 35.00,
    (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '90123456-7' and r.fecha_entrada = '2026-08-04')),

('habitación doble por noche', 3, 80.00,
    (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '22334455-6' and r.fecha_entrada = '2026-08-11')),
('room service', 2, 12.00,
    (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '22334455-6' and r.fecha_entrada = '2026-08-11')),

('habitación familiar por noche', 3, 120.00,
    (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '44556677-8' and r.fecha_entrada = '2026-08-19')),
('servicio de spa', 1, 35.00,
    (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '44556677-8' and r.fecha_entrada = '2026-08-19')),

('habitación familiar por noche', 2, 120.00,
    (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '55667788-9' and r.fecha_entrada = '2026-08-23')),
('consumo restaurante', 2, 15.00,
    (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '55667788-9' and r.fecha_entrada = '2026-08-23')),

('suite por noche', 3, 180.00,
    (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '77889900-1' and r.fecha_entrada = '2026-08-30')),
('room service', 1, 12.00,
    (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '77889900-1' and r.fecha_entrada = '2026-08-30')),

('habitación sencilla por noche', 2, 50.00,
    (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '99001122-3' and r.fecha_entrada = '2026-09-06')),
('servicio de spa', 1, 35.00,
    (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '99001122-3' and r.fecha_entrada = '2026-09-06'));

-- población extra..

-- nuevos huéspedes
insert into huesped (
    dui,
    nombre_huesped,
    apellido_huesped,
    telefono_huesped,
    correo_huesped,
    direccion_huesped,
    fecha_registro
) values
('20223344-5', 'lucia', 'fernanda', '7500-0021', 'lucia.fernanda@gmail.com', 'san salvador', '2026-06-21'),
('21223344-6', 'mateo', 'delgado', '7500-0022', 'mateo.delgado@gmail.com', 'santa tecla', '2026-06-22'),
('22223344-7', 'renata', 'villatoro', '7500-0023', 'renata.villatoro@gmail.com', 'soyapango', '2026-06-23'),
('23223344-8', 'andres', 'bonilla', '7500-0024', 'andres.bonilla@gmail.com', 'ilopango', '2026-06-24'),
('24223344-9', 'fatima', 'escobar', '7500-0025', 'fatima.escobar@gmail.com', 'apopa', '2026-06-25'),
('25223344-0', 'sebastian', 'quintanilla', '7500-0026', 'sebastian.quintanilla@gmail.com', 'mejicanos', '2026-06-26'),
('26223344-1', 'maria', 'campos', '7500-0027', 'maria.campos@gmail.com', 'sonsonate', '2026-06-27'),
('27223344-2', 'emilio', 'ayala', '7500-0028', 'emilio.ayala@gmail.com', 'san miguel', '2026-06-28'),
('28223344-3', 'isabella', 'serrano', '7500-0029', 'isabella.serrano@gmail.com', 'santa ana', '2026-06-29'),
('29223344-4', 'rodrigo', 'calderon', '7500-0030', 'rodrigo.calderon@gmail.com', 'la libertad', '2026-06-30'),
('30223344-5', 'melissa', 'montoya', '7500-0031', 'melissa.montoya@gmail.com', 'chalatenango', '2026-07-01'),
('31223344-6', 'hector', 'moran', '7500-0032', 'hector.moran@gmail.com', 'usulutan', '2026-07-02'),
('32223344-7', 'alejandra', 'barahona', '7500-0033', 'alejandra.barahona@gmail.com', 'cojutepeque', '2026-07-03'),
('33223344-8', 'cristian', 'galdamez', '7500-0034', 'cristian.galdamez@gmail.com', 'zacatecoluca', '2026-07-04'),
('34223344-9', 'patricia', 'salazar', '7500-0035', 'patricia.salazar@gmail.com', 'ahuachapan', '2026-07-05'),
('35223344-0', 'raul', 'guardado', '7500-0036', 'raul.guardado@gmail.com', 'san vicente', '2026-07-06'),
('36223344-1', 'ximena', 'molina', '7500-0037', 'ximena.molina@gmail.com', 'la union', '2026-07-07'),
('37223344-2', 'manuel', 'ceron', '7500-0038', 'manuel.ceron@gmail.com', 'cuscatancingo', '2026-07-08'),
('38223344-3', 'elena', 'chavez', '7500-0039', 'elena.chavez@gmail.com', 'san marcos', '2026-07-09'),
('39223344-4', 'julio', 'menendez', '7500-0040', 'julio.menendez@gmail.com', 'antiguo cuscatlán', '2026-07-10');


-- nuevas reservaciones
insert into reservacion (
    fecha_entrada,
    fecha_salida,
    fecha_reserva,
    estado_reserva,
    id_habitacion,
    id_huesped,
    id_empleado
) values
('2026-09-15', '2026-09-18', '2026-08-01 08:00:00', 'completada', 3, (select id_huesped from huesped where dui = '20223344-5'), 1),
('2026-09-20', '2026-09-22', '2026-08-02 09:00:00', 'completada', 4, (select id_huesped from huesped where dui = '21223344-6'), 2),
('2026-09-23', '2026-09-26', '2026-08-03 10:00:00', 'completada', 6, (select id_huesped from huesped where dui = '22223344-7'), 3),
('2026-10-01', '2026-10-04', '2026-08-04 11:00:00', 'completada', 7, (select id_huesped from huesped where dui = '23223344-8'), 1),
('2026-10-05', '2026-10-07', '2026-08-05 12:00:00', 'completada', 8, (select id_huesped from huesped where dui = '24223344-9'), 2),
('2026-10-08', '2026-10-11', '2026-08-06 13:00:00', 'completada', 9, (select id_huesped from huesped where dui = '25223344-0'), 4),
('2026-10-12', '2026-10-14', '2026-08-07 14:00:00', 'completada', 10, (select id_huesped from huesped where dui = '26223344-1'), 5),
('2026-10-15', '2026-10-17', '2026-08-08 15:00:00', 'completada', 1, (select id_huesped from huesped where dui = '27223344-2'), 1),
('2026-10-18', '2026-10-21', '2026-08-09 16:00:00', 'completada', 2, (select id_huesped from huesped where dui = '28223344-3'), 2),
('2026-10-22', '2026-10-24', '2026-08-10 17:00:00', 'completada', 3, (select id_huesped from huesped where dui = '29223344-4'), 3),
('2026-10-25', '2026-10-28', '2026-08-11 18:00:00', 'completada', 4, (select id_huesped from huesped where dui = '30223344-5'), 4),
('2026-10-29', '2026-11-01', '2026-08-12 19:00:00', 'completada', 6, (select id_huesped from huesped where dui = '31223344-6'), 5),
('2026-11-03', '2026-11-05', '2026-08-13 08:30:00', 'confirmada', 7, (select id_huesped from huesped where dui = '32223344-7'), 1),
('2026-11-06', '2026-11-09', '2026-08-14 09:30:00', 'pendiente', 8, (select id_huesped from huesped where dui = '33223344-8'), 2),
('2026-11-10', '2026-11-13', '2026-08-15 10:30:00', 'confirmada', 9, (select id_huesped from huesped where dui = '34223344-9'), 3),
('2026-11-14', '2026-11-16', '2026-08-16 11:30:00', 'pendiente', 10, (select id_huesped from huesped where dui = '35223344-0'), 4),
('2026-11-17', '2026-11-19', '2026-08-17 12:30:00', 'cancelada', 1, (select id_huesped from huesped where dui = '36223344-1'), 5),
('2026-11-20', '2026-11-22', '2026-08-18 13:30:00', 'confirmada', 2, (select id_huesped from huesped where dui = '37223344-2'), 1),
('2026-11-23', '2026-11-26', '2026-08-19 14:30:00', 'pendiente', 3, (select id_huesped from huesped where dui = '38223344-3'), 2),
('2026-11-27', '2026-11-29', '2026-08-20 15:30:00', 'confirmada', 4, (select id_huesped from huesped where dui = '39223344-4'), 3);


-- nuevas estancias
insert into estancia (
    fecha_check_in,
    hora_check_in,
    fecha_check_out,
    hora_check_out,
    observaciones,
    id_reservacion
) values
('2026-09-15', '14:00:00', '2026-09-18', '11:00:00', 'estancia finalizada sin inconvenientes', (select id_reservacion from reservacion where fecha_entrada = '2026-09-15' and id_huesped = (select id_huesped from huesped where dui = '20223344-5'))),
('2026-09-20', '14:20:00', '2026-09-22', '10:50:00', 'huésped solicitó salida temprana', (select id_reservacion from reservacion where fecha_entrada = '2026-09-20' and id_huesped = (select id_huesped from huesped where dui = '21223344-6'))),
('2026-09-23', '15:00:00', '2026-09-26', '11:10:00', 'sin observaciones', (select id_reservacion from reservacion where fecha_entrada = '2026-09-23' and id_huesped = (select id_huesped from huesped where dui = '22223344-7'))),
('2026-10-01', '13:50:00', '2026-10-04', '10:40:00', 'factura solicitada por correo', (select id_reservacion from reservacion where fecha_entrada = '2026-10-01' and id_huesped = (select id_huesped from huesped where dui = '23223344-8'))),
('2026-10-05', '14:30:00', '2026-10-07', '11:00:00', 'estancia normal', (select id_reservacion from reservacion where fecha_entrada = '2026-10-05' and id_huesped = (select id_huesped from huesped where dui = '24223344-9'))),
('2026-10-08', '15:10:00', '2026-10-11', '11:20:00', 'huésped utilizó spa', (select id_reservacion from reservacion where fecha_entrada = '2026-10-08' and id_huesped = (select id_huesped from huesped where dui = '25223344-0'))),
('2026-10-12', '14:15:00', '2026-10-14', '10:45:00', 'salida sin inconvenientes', (select id_reservacion from reservacion where fecha_entrada = '2026-10-12' and id_huesped = (select id_huesped from huesped where dui = '26223344-1'))),
('2026-10-15', '14:00:00', '2026-10-17', '11:00:00', 'consumo en restaurante', (select id_reservacion from reservacion where fecha_entrada = '2026-10-15' and id_huesped = (select id_huesped from huesped where dui = '27223344-2'))),
('2026-10-18', '15:00:00', '2026-10-21', '10:30:00', 'se aplicó lavandería', (select id_reservacion from reservacion where fecha_entrada = '2026-10-18' and id_huesped = (select id_huesped from huesped where dui = '28223344-3'))),
('2026-10-22', '13:45:00', '2026-10-24', '11:15:00', 'estancia finalizada', (select id_reservacion from reservacion where fecha_entrada = '2026-10-22' and id_huesped = (select id_huesped from huesped where dui = '29223344-4'))),
('2026-10-25', '14:25:00', '2026-10-28', '10:55:00', 'huésped usó servicio de spa', (select id_reservacion from reservacion where fecha_entrada = '2026-10-25' and id_huesped = (select id_huesped from huesped where dui = '30223344-5'))),
('2026-10-29', '15:30:00', '2026-11-01', '11:00:00', 'se solicitó transporte', (select id_reservacion from reservacion where fecha_entrada = '2026-10-29' and id_huesped = (select id_huesped from huesped where dui = '31223344-6')));


-- nuevos consumos de servicio
insert into consumo_servicio (
    cantidad,
    precio_unitario,
    fecha_consumo,
    id_servicio,
    id_reservacion
) values
(2, 15.00, '2026-09-16 19:00:00', 1, (select id_reservacion from reservacion where fecha_entrada = '2026-09-15' and id_huesped = (select id_huesped from huesped where dui = '20223344-5'))),
(1, 8.00, '2026-09-17 09:00:00', 2, (select id_reservacion from reservacion where fecha_entrada = '2026-09-15' and id_huesped = (select id_huesped from huesped where dui = '20223344-5'))),
(1, 35.00, '2026-09-21 18:00:00', 3, (select id_reservacion from reservacion where fecha_entrada = '2026-09-20' and id_huesped = (select id_huesped from huesped where dui = '21223344-6'))),
(2, 12.00, '2026-09-24 21:00:00', 5, (select id_reservacion from reservacion where fecha_entrada = '2026-09-23' and id_huesped = (select id_huesped from huesped where dui = '22223344-7'))),
(1, 25.00, '2026-10-02 08:00:00', 4, (select id_reservacion from reservacion where fecha_entrada = '2026-10-01' and id_huesped = (select id_huesped from huesped where dui = '23223344-8'))),
(1, 15.00, '2026-10-03 19:30:00', 1, (select id_reservacion from reservacion where fecha_entrada = '2026-10-01' and id_huesped = (select id_huesped from huesped where dui = '23223344-8'))),
(2, 8.00, '2026-10-06 10:00:00', 2, (select id_reservacion from reservacion where fecha_entrada = '2026-10-05' and id_huesped = (select id_huesped from huesped where dui = '24223344-9'))),
(1, 35.00, '2026-10-09 17:00:00', 3, (select id_reservacion from reservacion where fecha_entrada = '2026-10-08' and id_huesped = (select id_huesped from huesped where dui = '25223344-0'))),
(2, 15.00, '2026-10-10 20:00:00', 1, (select id_reservacion from reservacion where fecha_entrada = '2026-10-08' and id_huesped = (select id_huesped from huesped where dui = '25223344-0'))),
(1, 25.00, '2026-10-13 07:30:00', 4, (select id_reservacion from reservacion where fecha_entrada = '2026-10-12' and id_huesped = (select id_huesped from huesped where dui = '26223344-1'))),
(1, 15.00, '2026-10-16 19:00:00', 1, (select id_reservacion from reservacion where fecha_entrada = '2026-10-15' and id_huesped = (select id_huesped from huesped where dui = '27223344-2'))),
(1, 8.00, '2026-10-19 09:30:00', 2, (select id_reservacion from reservacion where fecha_entrada = '2026-10-18' and id_huesped = (select id_huesped from huesped where dui = '28223344-3'))),
(1, 12.00, '2026-10-20 22:00:00', 5, (select id_reservacion from reservacion where fecha_entrada = '2026-10-18' and id_huesped = (select id_huesped from huesped where dui = '28223344-3'))),
(3, 15.00, '2026-10-23 20:00:00', 1, (select id_reservacion from reservacion where fecha_entrada = '2026-10-22' and id_huesped = (select id_huesped from huesped where dui = '29223344-4'))),
(2, 35.00, '2026-10-26 17:00:00', 3, (select id_reservacion from reservacion where fecha_entrada = '2026-10-25' and id_huesped = (select id_huesped from huesped where dui = '30223344-5'))),
(1, 25.00, '2026-10-30 08:30:00', 4, (select id_reservacion from reservacion where fecha_entrada = '2026-10-29' and id_huesped = (select id_huesped from huesped where dui = '31223344-6'))),
(1, 12.00, '2026-10-31 21:30:00', 5, (select id_reservacion from reservacion where fecha_entrada = '2026-10-29' and id_huesped = (select id_huesped from huesped where dui = '31223344-6')));


-- nuevas facturas
insert into factura (
    metodo_pago,
    estado_pago,
    fecha_emision,
    total_factura,
    id_reservacion,
    id_empleado
) values
('efectivo', 'pagada', '2026-09-18 11:10:00', 278.00, (select id_reservacion from reservacion where fecha_entrada = '2026-09-15' and id_huesped = (select id_huesped from huesped where dui = '20223344-5')), 4),
('tarjeta credito', 'pagada', '2026-09-22 10:50:00', 195.00, (select id_reservacion from reservacion where fecha_entrada = '2026-09-20' and id_huesped = (select id_huesped from huesped where dui = '21223344-6')), 4),
('transferencia', 'pagada', '2026-09-26 11:15:00', 384.00, (select id_reservacion from reservacion where fecha_entrada = '2026-09-23' and id_huesped = (select id_huesped from huesped where dui = '22223344-7')), 4),
('tarjeta debito', 'pagada', '2026-10-04 10:45:00', 400.00, (select id_reservacion from reservacion where fecha_entrada = '2026-10-01' and id_huesped = (select id_huesped from huesped where dui = '23223344-8')), 4),
('efectivo', 'pagada', '2026-10-07 11:05:00', 256.00, (select id_reservacion from reservacion where fecha_entrada = '2026-10-05' and id_huesped = (select id_huesped from huesped where dui = '24223344-9')), 4),
('tarjeta credito', 'pagada', '2026-10-11 11:20:00', 605.00, (select id_reservacion from reservacion where fecha_entrada = '2026-10-08' and id_huesped = (select id_huesped from huesped where dui = '25223344-0')), 4),
('transferencia', 'pagada', '2026-10-14 10:55:00', 385.00, (select id_reservacion from reservacion where fecha_entrada = '2026-10-12' and id_huesped = (select id_huesped from huesped where dui = '26223344-1')), 4),
('efectivo', 'pagada', '2026-10-17 11:00:00', 115.00, (select id_reservacion from reservacion where fecha_entrada = '2026-10-15' and id_huesped = (select id_huesped from huesped where dui = '27223344-2')), 4),
('tarjeta debito', 'pagada', '2026-10-21 10:30:00', 170.00, (select id_reservacion from reservacion where fecha_entrada = '2026-10-18' and id_huesped = (select id_huesped from huesped where dui = '28223344-3')), 4),
('transferencia', 'pagada', '2026-10-24 11:15:00', 205.00, (select id_reservacion from reservacion where fecha_entrada = '2026-10-22' and id_huesped = (select id_huesped from huesped where dui = '29223344-4')), 4),
('tarjeta credito', 'pagada', '2026-10-28 10:55:00', 310.00, (select id_reservacion from reservacion where fecha_entrada = '2026-10-25' and id_huesped = (select id_huesped from huesped where dui = '30223344-5')), 4),
('efectivo', 'pagada', '2026-11-01 11:00:00', 397.00, (select id_reservacion from reservacion where fecha_entrada = '2026-10-29' and id_huesped = (select id_huesped from huesped where dui = '31223344-6')), 4);


-- nuevos detalles de factura
insert into detalle_factura (
    descripcion,
    cantidad,
    valor_unitario,
    id_factura
) values
('habitación doble por noche', 3, 80.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '20223344-5' and r.fecha_entrada = '2026-09-15')),
('consumo restaurante', 2, 15.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '20223344-5' and r.fecha_entrada = '2026-09-15')),
('servicio de lavandería', 1, 8.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '20223344-5' and r.fecha_entrada = '2026-09-15')),

('habitación doble por noche', 2, 80.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '21223344-6' and r.fecha_entrada = '2026-09-20')),
('servicio de spa', 1, 35.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '21223344-6' and r.fecha_entrada = '2026-09-20')),

('habitación familiar por noche', 3, 120.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '22223344-7' and r.fecha_entrada = '2026-09-23')),
('room service', 2, 12.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '22223344-7' and r.fecha_entrada = '2026-09-23')),

('habitación familiar por noche', 3, 120.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '23223344-8' and r.fecha_entrada = '2026-10-01')),
('servicio de transporte', 1, 25.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '23223344-8' and r.fecha_entrada = '2026-10-01')),
('consumo restaurante', 1, 15.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '23223344-8' and r.fecha_entrada = '2026-10-01')),

('habitación familiar por noche', 2, 120.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '24223344-9' and r.fecha_entrada = '2026-10-05')),
('servicio de lavandería', 2, 8.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '24223344-9' and r.fecha_entrada = '2026-10-05')),

('suite por noche', 3, 180.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '25223344-0' and r.fecha_entrada = '2026-10-08')),
('servicio de spa', 1, 35.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '25223344-0' and r.fecha_entrada = '2026-10-08')),
('consumo restaurante', 2, 15.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '25223344-0' and r.fecha_entrada = '2026-10-08')),

('suite por noche', 2, 180.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '26223344-1' and r.fecha_entrada = '2026-10-12')),
('servicio de transporte', 1, 25.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '26223344-1' and r.fecha_entrada = '2026-10-12')),

('habitación sencilla por noche', 2, 50.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '27223344-2' and r.fecha_entrada = '2026-10-15')),
('consumo restaurante', 1, 15.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '27223344-2' and r.fecha_entrada = '2026-10-15')),

('habitación sencilla por noche', 3, 50.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '28223344-3' and r.fecha_entrada = '2026-10-18')),
('servicio de lavandería', 1, 8.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '28223344-3' and r.fecha_entrada = '2026-10-18')),
('room service', 1, 12.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '28223344-3' and r.fecha_entrada = '2026-10-18')),

('habitación doble por noche', 2, 80.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '29223344-4' and r.fecha_entrada = '2026-10-22')),
('consumo restaurante', 3, 15.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '29223344-4' and r.fecha_entrada = '2026-10-22')),

('habitación doble por noche', 3, 80.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '30223344-5' and r.fecha_entrada = '2026-10-25')),
('servicio de spa', 2, 35.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '30223344-5' and r.fecha_entrada = '2026-10-25')),

('habitación familiar por noche', 3, 120.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '31223344-6' and r.fecha_entrada = '2026-10-29')),
('servicio de transporte', 1, 25.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '31223344-6' and r.fecha_entrada = '2026-10-29')),
('room service', 1, 12.00, (select f.id_factura from factura f inner join reservacion r on f.id_reservacion = r.id_reservacion inner join huesped h on r.id_huesped = h.id_huesped where h.dui = '31223344-6' and r.fecha_entrada = '2026-10-29'));
