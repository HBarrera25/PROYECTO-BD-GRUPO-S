

-- REGISTRAR NUEVA RESERVACION
-- Inserta una reservacion validando que la habitacion exista
-- y que el huesped y empleado tambien existan.
-- Devuelve el id de la reservacion creada en p_id_reservacion.

CREATE OR REPLACE PROCEDURE sp_registrar_reservacion(
    IN  p_fecha_entrada  DATE,
    IN  p_fecha_salida   DATE,
    IN  p_id_habitacion  BIGINT,
    IN  p_id_huesped     BIGINT,
    IN  p_id_empleado    BIGINT,
    OUT p_id_reservacion BIGINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM habitacion WHERE id_habitacion = p_id_habitacion) THEN
        RAISE EXCEPTION 'La habitación % no existe.', p_id_habitacion;
END IF;

    IF NOT EXISTS (SELECT 1 FROM huesped WHERE id_huesped = p_id_huesped) THEN
        RAISE EXCEPTION 'El huésped % no existe.', p_id_huesped;
END IF;

    IF NOT EXISTS (SELECT 1 FROM nombre_empleado WHERE id_empleado = p_id_empleado) THEN
        RAISE EXCEPTION 'El empleado % no existe.', p_id_empleado;
END IF;

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
           p_fecha_entrada,
           p_fecha_salida,
           NOW(),
           'confirmada',
           p_id_habitacion,
           p_id_huesped,
           p_id_empleado
       )
    RETURNING id_reservacion INTO p_id_reservacion;

COMMIT;
END;
$$;

-- prueba procedimiento 1
CALL sp_registrar_reservacion('2026-09-01', '2026-09-04', 2, 1, 1, NULL);



-- PROCEDIMIENTO 2: REGISTRAR CHECK-IN
-- Crea la estancia asociada a una reservacion confirmada.


CREATE OR REPLACE PROCEDURE sp_registrar_checkin(
    IN p_id_reservacion BIGINT,
    IN p_observaciones  TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
v_estado VARCHAR(20);
BEGIN
SELECT estado_reserva INTO v_estado
FROM reservacion
WHERE id_reservacion = p_id_reservacion;

IF v_estado IS NULL THEN
        RAISE EXCEPTION 'La reservación % no existe.', p_id_reservacion;
END IF;

    IF v_estado <> 'confirmada' THEN
        RAISE EXCEPTION 'No se puede hacer check-in: la reservación % está en estado "%".',
            p_id_reservacion, v_estado;
END IF;

    IF EXISTS (SELECT 1 FROM estancia WHERE id_reservacion = p_id_reservacion) THEN
        RAISE EXCEPTION 'La reservación % ya tiene una estancia registrada.', p_id_reservacion;
END IF;

INSERT INTO estancia (
    fecha_check_in,
    hora_check_in,
    observaciones,
    id_reservacion
)
VALUES (
                   CURRENT_DATE,
                   CURRENT_TIME,
                   p_observaciones,
                   p_id_reservacion
       );

COMMIT;
END;
$$;

-- prueba procedimiento 2
CALL sp_registrar_checkin(3, 'Ingreso registrado por procedimiento almacenado');



-- PROCEDIMIENTO 3: REGISTRAR CHECK-OUT
-- Cierra la estancia y libera la habitacion (queda disponible).


CREATE OR REPLACE PROCEDURE sp_registrar_checkout(
    IN p_id_reservacion BIGINT
)
LANGUAGE plpgsql
AS $$
DECLARE
v_id_habitacion BIGINT;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM estancia WHERE id_reservacion = p_id_reservacion AND fecha_check_out IS NULL) THEN
        RAISE EXCEPTION 'No existe una estancia abierta para la reservación %.', p_id_reservacion;
END IF;

UPDATE estancia
SET fecha_check_out = CURRENT_DATE,
    hora_check_out  = CURRENT_TIME
WHERE id_reservacion = p_id_reservacion;

UPDATE reservacion
SET estado_reserva = 'completada'
WHERE id_reservacion = p_id_reservacion
    RETURNING id_habitacion INTO v_id_habitacion;

UPDATE habitacion
SET estado_habitacion = 'disponible'
WHERE id_habitacion = v_id_habitacion;

COMMIT;
END;
$$;

-- prueba procedimiento 3
CALL sp_registrar_checkout(3);

-- PROCEDIMIENTO 4: REGISTRAR CONSUMO DE SERVICIO
-- Inserta el consumo y, si ya existe factura pendiente para
-- la reservación, el trigger trg_actualizar_total_factura_consumo
-- (ya definido en Triggers_Hotel.sql) recalcula el total solo.

CREATE OR REPLACE PROCEDURE sp_registrar_consumo_servicio(
    IN p_id_reservacion BIGINT,
    IN p_id_servicio    BIGINT,
    IN p_cantidad       INT
)
LANGUAGE plpgsql
AS $$
DECLARE
v_precio_base NUMERIC(10,2);
BEGIN
    IF p_cantidad <= 0 THEN
        RAISE EXCEPTION 'La cantidad debe ser mayor a cero.';
END IF;

SELECT precio_base INTO v_precio_base
FROM servicio
WHERE id_servicio = p_id_servicio;

IF v_precio_base IS NULL THEN
        RAISE EXCEPTION 'El servicio % no existe.', p_id_servicio;
END IF;

    IF NOT EXISTS (SELECT 1 FROM reservacion WHERE id_reservacion = p_id_reservacion) THEN
        RAISE EXCEPTION 'La reservación % no existe.', p_id_reservacion;
END IF;

INSERT INTO consumo_servicio (
    cantidad,
    precio_unitario,
    fecha_consumo,
    id_servicio,
    id_reservacion
)
VALUES (
           p_cantidad,
           v_precio_base,
           NOW(),
           p_id_servicio,
           p_id_reservacion
       );

COMMIT;
END;
$$;

-- prueba procedimiento 4
CALL sp_registrar_consumo_servicio(3, 1, 2);


-- PROCEDIMIENTO 5: GENERAR FACTURA DE UNA RESERVACION
-- Crea la factura usando las funciones ya existentes
-- (fn_total_reservacion) y agrega el detalle de hospedaje
-- y de cada servicio consumido.

CREATE OR REPLACE PROCEDURE sp_generar_factura(
    IN  p_id_reservacion BIGINT,
    IN  p_metodo_pago    VARCHAR,
    IN  p_id_empleado    BIGINT,
    OUT p_id_factura     BIGINT
)
LANGUAGE plpgsql
AS $$
DECLARE
v_total_hospedaje NUMERIC(10,2);
    v_noches          INT;
    v_precio_noche    NUMERIC(10,2);
    r_consumo         RECORD;
BEGIN
    IF EXISTS (SELECT 1 FROM factura WHERE id_reservacion = p_id_reservacion) THEN
        RAISE EXCEPTION 'La reservación % ya tiene una factura generada.', p_id_reservacion;
END IF;

    IF NOT EXISTS (SELECT 1 FROM nombre_empleado WHERE id_empleado = p_id_empleado) THEN
        RAISE EXCEPTION 'El empleado % no existe.', p_id_empleado;
END IF;

    -- Crear la factura con el total calculado por la función del grupo
INSERT INTO factura (
    metodo_pago,
    estado_pago,
    fecha_emision,
    total_factura,
    id_reservacion,
    id_empleado
)
VALUES (
           p_metodo_pago,
           'pendiente',
           NOW(),
           fn_total_reservacion(p_id_reservacion),
           p_id_reservacion,
           p_id_empleado
       )
    RETURNING id_factura INTO p_id_factura;

-- Detalle: hospedaje
SELECT (r.fecha_salida - r.fecha_entrada), th.precio_noche
INTO v_noches, v_precio_noche
FROM reservacion r
         INNER JOIN habitacion h ON r.id_habitacion = h.id_habitacion
         INNER JOIN tipo_habitacion th ON h.id_tipo_habitacion = th.id_tipo_habitacion
WHERE r.id_reservacion = p_id_reservacion;

INSERT INTO detalle_factura (descripcion, cantidad, valor_unitario, id_factura)
VALUES ('Hospedaje', v_noches, v_precio_noche, p_id_factura);

-- Detalle: cada servicio consumido
FOR r_consumo IN
SELECT s.nombre_servicio, cs.cantidad, cs.precio_unitario
FROM consumo_servicio cs
         INNER JOIN servicio s ON cs.id_servicio = s.id_servicio
WHERE cs.id_reservacion = p_id_reservacion
    LOOP
INSERT INTO detalle_factura (descripcion, cantidad, valor_unitario, id_factura)
VALUES (r_consumo.nombre_servicio, r_consumo.cantidad, r_consumo.precio_unitario, p_id_factura);
END LOOP;

COMMIT;
END;
$$;

-- prueba procedimiento 5
CALL sp_generar_factura(3, 'tarjeta credito', 1, NULL);

-- PROCEDIMIENTO 6: REGISTRAR PAGO DE FACTURA
-- Marca una factura como pagada, validando que no haya
-- sido pagada o anulada previamente.

CREATE OR REPLACE PROCEDURE sp_registrar_pago_factura(
    IN p_id_factura BIGINT
)
LANGUAGE plpgsql
AS $$
DECLARE
v_estado VARCHAR(20);
BEGIN
SELECT estado_pago INTO v_estado
FROM factura
WHERE id_factura = p_id_factura;

IF v_estado IS NULL THEN
        RAISE EXCEPTION 'La factura % no existe.', p_id_factura;
END IF;

    IF v_estado <> 'pendiente' THEN
        RAISE EXCEPTION 'La factura % no se puede pagar: estado actual "%".', p_id_factura, v_estado;
END IF;

UPDATE factura
SET estado_pago = 'pagada'
WHERE id_factura = p_id_factura;

COMMIT;
END;
$$;

-- prueba procedimiento 6
CALL sp_registrar_pago_factura(1);


-- PROCEDIMIENTO 7: CANCELAR RESERVACION
-- Cancela una reservación que no esté ya completada/cancelada
-- y libera la habitación si estaba marcada como ocupada
-- por dicha reservación.

CREATE OR REPLACE PROCEDURE sp_cancelar_reservacion(
    IN p_id_reservacion BIGINT
)
LANGUAGE plpgsql
AS $$
DECLARE
v_estado        VARCHAR(20);
    v_id_habitacion BIGINT;
BEGIN
SELECT estado_reserva, id_habitacion
INTO v_estado, v_id_habitacion
FROM reservacion
WHERE id_reservacion = p_id_reservacion;

IF v_estado IS NULL THEN
        RAISE EXCEPTION 'La reservación % no existe.', p_id_reservacion;
END IF;

    IF v_estado IN ('cancelada', 'completada') THEN
        RAISE EXCEPTION 'La reservación % ya está en estado "%" y no se puede cancelar.',
            p_id_reservacion, v_estado;
END IF;

UPDATE reservacion
SET estado_reserva = 'cancelada'
WHERE id_reservacion = p_id_reservacion;

UPDATE habitacion
SET estado_habitacion = 'disponible'
WHERE id_habitacion = v_id_habitacion
  AND estado_habitacion = 'ocupada';

COMMIT;
END;
$$;

-- prueba procedimiento 7
CALL sp_cancelar_reservacion(4);