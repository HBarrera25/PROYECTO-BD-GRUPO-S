-- ============================================================
-- TRANSACCION 1: REGISTRAR NUEVA RESERVACION
-- descripción:
-- registra una nueva reservacion para un huesped,
-- asignando una habitacion disponible y el empleado
-- responsable del registro de la reservacion.
-- ============================================================

BEGIN;

INSERT INTO reservacion (
    fecha_entrada,
    fecha_salida,
    fecha_reserva,
    estado_reserva,
    id_habitacion,
    id_huesped,
    id_empleado
)
VALUES (
    '2026-08-01',
    '2026-08-05',
    NOW(),
    'confirmada',
    4,
    3,
    1
);

COMMIT;

-- prueba transaccion 1: verificar reservacion registrada
SELECT id_reservacion,
       fecha_entrada,
       fecha_salida,
       estado_reserva,
       id_habitacion,
       id_huesped,
       id_empleado
FROM reservacion
WHERE fecha_entrada = '2026-08-01'
  AND fecha_salida = '2026-08-05'
  AND id_huesped = 3;



-- ============================================================
-- TRANSACCION 2: REGISTRAR CHECK-IN
-- descripción:
-- registra el ingreso del huesped al hotel,
-- creando una estancia asociada a una reservacion
-- previamente confirmada.
-- ============================================================

BEGIN;

INSERT INTO estancia (
    fecha_check_in,
    hora_check_in,
    observaciones,
    id_reservacion
)
VALUES (
    CURRENT_DATE,
    CURRENT_TIME,
    'Ingreso normal',
    4
);

COMMIT;

-- prueba transaccion 2: verificar check-in registrado
SELECT id_estancia,
       fecha_check_in,
       hora_check_in,
       observaciones,
       id_reservacion
FROM estancia
WHERE id_reservacion = 4;


-- ============================================================
-- TRANSACCION 3: REGISTRAR CONSUMO DE SERVICIO´
-- descripción:
-- registra el consumo de un servicio adicional
-- durante la estancia del huesped, permitiendo
-- que posteriormente sea incluido en la factura.
-- ============================================================

BEGIN;

INSERT INTO consumo_servicio (
    cantidad,
    precio_unitario,
    fecha_consumo,
    id_servicio,
    id_reservacion
)
VALUES (
    2,
    15.00,
    NOW(),
    1,
    3
);

COMMIT;

-- prueba transaccion 3: verificar consumo de servicio registrado
SELECT id_consumo,
       cantidad,
       precio_unitario,
       subtotal,
       fecha_consumo,
       id_servicio,
       id_reservacion
FROM consumo_servicio
WHERE id_reservacion = 3
ORDER BY fecha_consumo desc;


-- ============================================================
-- TRANSACCION 4: DEMOSTRACION DE ROLLBACK
-- descripcion:
-- simula una modificacion sobre el estado de una
-- habitacion y posteriormente revierte los cambios
-- mediante rollback para mantener la integridad
-- de los datos.
-- ============================================================

BEGIN;

UPDATE habitacion
SET estado_habitacion = 'mantenimiento'
WHERE id_habitacion = 1;

ROLLBACK;

-- prueba transaccion 4: verificar rollback
-- la habitacion 1 no deberia quedar en mantenimiento
SELECT id_habitacion,
       numero_habitacion,
       estado_habitacion
FROM habitacion
WHERE id_habitacion = 1;


-- ============================================================
-- TRANSACCION 5: DEMOSTRACION DE SAVEPOINT
-- descripción:
-- muestra el uso de un punto de restauracion
-- dentro de una transaccion, permitiendo revertir
-- parcialmente cambios sin cancelar toda la operacion.
-- ============================================================

BEGIN;

UPDATE habitacion
SET estado_habitacion = 'mantenimiento'
WHERE id_habitacion = 2;

SAVEPOINT sp_habitacion;

UPDATE habitacion
SET estado_habitacion = 'fuera de servicio'
WHERE id_habitacion = 2;

ROLLBACK TO sp_habitacion;

COMMIT;

-- prueba transaccion 5: verificar savepoint
-- la habitacion 2 deberia quedar en mantenimiento,
-- no en fuera de servicio
SELECT id_habitacion,
       numero_habitacion,
       estado_habitacion
FROM habitacion
WHERE id_habitacion = 2;


-- ============================================================
-- TRANSACCION 6: CANCELAR RESERVACION
-- descripción:
-- actualiza el estado de una reservacion a
-- cancelada y libera la habitacion asociada,
-- dejandola nuevamente disponible para futuras
-- reservaciones.
-- ============================================================

BEGIN;

UPDATE reservacion
SET estado_reserva = 'cancelada'
WHERE id_reservacion = 8;

UPDATE habitacion
SET estado_habitacion = 'disponible'
WHERE id_habitacion = 2;

COMMIT;

-- prueba transaccion 6: verificar cancelacion de reservacion
-- y liberacion de habitacion
SELECT id_reservacion,
       estado_reserva
FROM reservacion
WHERE id_reservacion = 8;

SELECT id_habitacion,
       numero_habitacion,
       estado_habitacion
FROM habitacion
WHERE id_habitacion = 2;
