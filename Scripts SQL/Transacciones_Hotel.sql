-- ============================================================
-- TRANSACCION 1: REGISTRAR NUEVA RESERVACION
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


-- ============================================================
-- TRANSACCION 2: REGISTRAR CHECK-IN
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


-- ============================================================
-- TRANSACCION 3: REGISTRAR CONSUMO DE SERVICIO
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


-- ============================================================
-- TRANSACCION 4: DEMOSTRACION DE ROLLBACK
-- ============================================================

BEGIN;

UPDATE habitacion
SET estado_habitacion = 'mantenimiento'
WHERE id_habitacion = 1;

ROLLBACK;


-- ============================================================
-- TRANSACCION 5: DEMOSTRACION DE SAVEPOINT
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


-- ============================================================
-- TRANSACCION 6: CANCELAR RESERVACION
-- ============================================================

BEGIN;

UPDATE reservacion
SET estado_reserva = 'cancelada'
WHERE id_reservacion = 8;

UPDATE habitacion
SET estado_habitacion = 'disponible'
WHERE id_habitacion = 2;

COMMIT;
