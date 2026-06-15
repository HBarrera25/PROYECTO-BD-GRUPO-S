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

