-- TRIGGERS PARA EL SISTEMA DE GESTION HOTELERA
-- ============================================================
-- TABLAS DE AUDITORÍA (ESTRUCTURA BASE)
-- ============================================================

-- Bitácora para registrar cambios de tarifas
CREATE TABLE IF NOT EXISTS auditoria_precio_tipo_habitacion (
    id_auditoria       BIGINT GENERATED ALWAYS AS IDENTITY,
    id_tipo_habitacion BIGINT         NOT NULL,
    precio_anterior    NUMERIC(10,2),
    precio_nuevo       NUMERIC(10,2),
    fecha_cambio       TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    usuario_bd         TEXT           DEFAULT CURRENT_USER,
    CONSTRAINT pk_auditoria_precio_tipo_habitacion PRIMARY KEY (id_auditoria)
);

-- Bitácora histórica para registrar movimientos DML en las reservas
CREATE TABLE IF NOT EXISTS auditoria_reservacion (
    id_auditoria   BIGINT GENERATED ALWAYS AS IDENTITY,
    operacion      TEXT        NOT NULL,   
    id_reservacion BIGINT,
    datos_antes    JSONB,                  
    datos_despues  JSONB,                  
    fecha_cambio   TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    usuario_bd     TEXT        DEFAULT CURRENT_USER,
    CONSTRAINT pk_auditoria_reservacion PRIMARY KEY (id_auditoria)
);

-- TRIGGER 1: TRIGGER DE VALIDACIÓN Y AUTO-COMPLETAR
-- Evita que una reservación se choque con otra reservación activa sobre la misma habitación 
-- auto-corrige fechas pasadas
-- revisa antes de guardar, aborta si hay conflicto o ajusta el estado
-- ============================================================

CREATE OR REPLACE FUNCTION fn_reservacion_before_ops()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_conflictos INT;
BEGIN
    -- Auto-completar: Si la fecha ya pasó y no está cancelada, se marca completada antes de guardar
    IF NEW.fecha_salida < CURRENT_DATE AND NEW.estado_reserva NOT IN ('cancelada', 'completada') THEN
        NEW.estado_reserva := 'completada';
    END IF;

    -- Validación de Traslape: Solo evalúa reservas que pretendan bloquear la habitación
    IF NEW.estado_reserva IN ('pendiente', 'confirmada') THEN
        SELECT COUNT(*)
        INTO v_conflictos
        FROM reservacion
        WHERE id_habitacion = NEW.id_habitacion
          AND estado_reserva IN ('pendiente', 'confirmada')
          AND id_reservacion IS DISTINCT FROM NEW.id_reservacion
          AND NEW.fecha_entrada < fecha_salida
          AND NEW.fecha_salida  > fecha_entrada;

        IF v_conflictos > 0 THEN
            RAISE EXCEPTION 'La habitación % ya tiene una reservación activa en el rango de fechas seleccionado (% a %).',
                NEW.id_habitacion, NEW.fecha_entrada, NEW.fecha_salida;
        END IF;
    END IF;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_reservacion_before
BEFORE INSERT OR UPDATE OF fecha_entrada, fecha_salida, id_habitacion, estado_reserva
ON reservacion
FOR EACH ROW
EXECUTE FUNCTION fn_reservacion_before_ops();

-- PRUEBA TRIGGER 1
-- VALIDAR TRASLAPE DE RESERVACIONES
-- DEBE GENERAR ERROR SI LA HABITACIÓN YA ESTÁ RESERVADA EN ESE PERÍODO

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
    '2026-07-02',
    '2026-07-03',
    NOW(),
    'confirmada',
    1,
    2,
    1
);


-- TRIGGER 2: TRIGGER DE CONTROL DE ESTADO DE HABITACIÓN Y AUDITORÍA
-- Sincroniza el estado real de la habitación si la reserva es para hoy
-- y respalda la evidencia completa de cambios en las reservas.
-- registra evidencia y altera la habitación después de que el cambio ocurrió
-- ============================================================

CREATE OR REPLACE FUNCTION fn_reservacion_after_ops()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    -- Control de Estado físico de la Habitación 
    IF TG_OP = 'INSERT' THEN
        IF NEW.estado_reserva = 'confirmada' AND CURRENT_DATE BETWEEN NEW.fecha_entrada AND NEW.fecha_salida THEN
            UPDATE habitacion SET estado_habitacion = 'ocupada' WHERE id_habitacion = NEW.id_habitacion;
        END IF;
    ELSIF TG_OP = 'UPDATE' THEN
        IF NEW.estado_reserva = 'confirmada' AND CURRENT_DATE BETWEEN NEW.fecha_entrada AND NEW.fecha_salida THEN
            UPDATE habitacion SET estado_habitacion = 'ocupada' WHERE id_habitacion = NEW.id_habitacion;
        ELSIF NEW.estado_reserva IN ('cancelada', 'completada') OR (NEW.estado_reserva = 'confirmada' AND CURRENT_DATE > NEW.fecha_salida) THEN
            UPDATE habitacion SET estado_habitacion = 'disponible' WHERE id_habitacion = NEW.id_habitacion;
        END IF;
    END IF;

    IF TG_OP = 'INSERT' THEN
        INSERT INTO auditoria_reservacion (operacion, id_reservacion, datos_antes, datos_despues)
        VALUES (
            'INSERT', NEW.id_reservacion, NULL,
            jsonb_build_object('id_habitacion', NEW.id_habitacion, 'id_huesped', NEW.id_huesped, 'fecha_entrada', NEW.fecha_entrada, 'fecha_salida', NEW.fecha_salida, 'estado_reserva', NEW.estado_reserva)
        );
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO auditoria_reservacion (operacion, id_reservacion, datos_antes, datos_despues)
        VALUES (
            'UPDATE', NEW.id_reservacion,
            jsonb_build_object('id_habitacion', OLD.id_habitacion, 'fecha_entrada', OLD.fecha_entrada, 'fecha_salida', OLD.fecha_salida, 'estado_reserva', OLD.estado_reserva),
            jsonb_build_object('id_habitacion', NEW.id_habitacion, 'fecha_entrada', NEW.fecha_entrada, 'fecha_salida', NEW.fecha_salida, 'estado_reserva', NEW.estado_reserva)
        );
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO auditoria_reservacion (operacion, id_reservacion, datos_antes, datos_despues)
        VALUES (
            'DELETE', OLD.id_reservacion,
            jsonb_build_object('id_habitacion', OLD.id_habitacion, 'fecha_entrada', OLD.fecha_entrada, 'fecha_salida', OLD.fecha_salida, 'estado_reserva', OLD.estado_reserva),
            NULL
        );
    END IF;

    RETURN COALESCE(NEW, OLD);
END;
$$;

CREATE OR REPLACE TRIGGER trg_reservacion_after
AFTER INSERT OR UPDATE OR DELETE
ON reservacion
FOR EACH ROW
EXECUTE FUNCTION fn_reservacion_after_ops();

-- PRUEBA TRIGGER 2
-- AUDITORÍA DE RESERVACIÓN Y ACTUALIZACIÓN DE ESTADO DE HABITACIÓN

UPDATE reservacion
SET estado_reserva = 'cancelada'
WHERE id_reservacion = 3;

SELECT *
FROM auditoria_reservacion
WHERE id_reservacion = 3
ORDER BY fecha_cambio DESC;

SELECT 
    r.id_reservacion,         
    h.id_habitacion,          
    h.numero_habitacion,      
    h.estado_habitacion       
FROM habitacion h
INNER JOIN reservacion r ON h.id_habitacion = r.id_habitacion
WHERE r.id_reservacion = 3;


-- TRIGGER 3: TRIGGER DE VALIDACIÓN DE PRECIO DE HABITACIÓN 
-- Asegura que ningún tipo de habitación se registre con tarifas inválidas o incorrectas.
-- valida antes de persistir el precio, aborta si no cumple la regla de negocio
-- ============================================================

CREATE OR REPLACE FUNCTION fn_validar_precio_tipo_habitacion()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.precio_noche <= 0 THEN
        RAISE EXCEPTION 'Error de negocio: El precio por noche de la habitación debe ser mayor a cero.';
    END IF;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_validar_precio_tipo_habitacion
BEFORE INSERT OR UPDATE OF precio_noche
ON tipo_habitacion
FOR EACH ROW
EXECUTE FUNCTION fn_validar_precio_tipo_habitacion();

-- PRUEBA TRIGGER 3
-- VALIDACIÓN DEL PRECIO DE UNA HABITACIÓN
-- DEBE GENERAR ERROR POR PRECIO INVÁLIDO

UPDATE tipo_habitacion
SET precio_noche = -25.00
WHERE id_tipo_habitacion = 1;


-- TRIGGER 4: TRIGGER DE AUDITORÍA DE PRECIOS
-- Registra cada cambio de precio_noche en tipo_habitacion.
-- registra evidencia después de que el cambio del precio fuera exitoso
-- ============================================================

CREATE OR REPLACE FUNCTION fn_auditar_cambio_precio_habitacion()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.precio_noche IS DISTINCT FROM NEW.precio_noche THEN
        INSERT INTO auditoria_precio_tipo_habitacion (id_tipo_habitacion, precio_anterior, precio_nuevo)
        VALUES (OLD.id_tipo_habitacion, OLD.precio_noche, NEW.precio_noche);
    END IF;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_auditar_cambio_precio_habitacion
AFTER UPDATE OF precio_noche
ON tipo_habitacion
FOR EACH ROW
EXECUTE FUNCTION fn_auditar_cambio_precio_habitacion();

-- PRUEBA TRIGGER 4
-- AUDITORÍA DE CAMBIO DE PRECIO DE HABITACIÓN

UPDATE tipo_habitacion
SET precio_noche = 55.00
WHERE id_tipo_habitacion = 1;

SELECT *
FROM auditoria_precio_tipo_habitacion
WHERE id_tipo_habitacion = 1
ORDER BY fecha_cambio DESC;


-- TRIGGER 5: TRIGGER PARA EVITAR BORRADO
-- Bloquea DELETE sobre servicios esenciales del hotel.
-- intercepta antes de que se borre nada de la tabla servicio
-- ============================================================

CREATE OR REPLACE FUNCTION fn_evitar_borrado_servicio_esencial()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.nombre_servicio IN ('restaurante', 'room service') THEN
        RAISE EXCEPTION 'Operación cancelada: El servicio "%" no se puede eliminar por ser esencial para la operación del hotel.', 
            OLD.nombre_servicio;
    END IF;
    RETURN OLD;
END;
$$;

CREATE OR REPLACE TRIGGER trg_evitar_borrado_servicio_esencial
BEFORE DELETE ON servicio
FOR EACH ROW
EXECUTE FUNCTION fn_evitar_borrado_servicio_esencial();

-- PRUEBA TRIGGER 5
-- EVITAR ELIMINACIÓN DE SERVICIOS ESENCIALES
-- DEBE GENERAR ERROR AL INTENTAR ELIMINAR EL SERVICIO

DELETE FROM servicio
WHERE nombre_servicio = 'restaurante';

-- TRIGGER 6: TRIGGER DE ACTUALIZACIÓN AUTOMÁTICA DE FACTURACIÓN
-- Recalcula de forma dinámica el total de la factura usando la función global del equipo cuando se altera un consumo de servicio.
-- sincroniza montos financieros tras cambios en la tabla consumo_servicio
-- ============================================================
CREATE OR REPLACE FUNCTION fn_actualizar_total_factura_servicio()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_res BIGINT;
    v_total  NUMERIC(10,2);
BEGIN
    IF TG_OP = 'DELETE' THEN
        v_id_res := OLD.id_reservacion;
    ELSE
        v_id_res := NEW.id_reservacion;
    END IF;

    -- Llamada exacta a la función maestra del grupo (Suma Hospedaje + Servicios)
    v_total := fn_total_reservacion(v_id_res);

    -- Lógica de protección: Solo impacta si la factura mantiene estado 'pendiente'
    UPDATE factura
    SET total_factura = v_total
    WHERE id_reservacion = v_id_res
      AND estado_pago = 'pendiente';

    RETURN COALESCE(NEW, OLD);
END;
$$;

CREATE OR REPLACE TRIGGER trg_actualizar_total_factura_consumo
AFTER INSERT OR UPDATE OR DELETE ON consumo_servicio
FOR EACH ROW
EXECUTE FUNCTION fn_actualizar_total_factura_servicio();

-- PRUEBA TRIGGER 6
-- ACTUALIZACIÓN AUTOMÁTICA DEL TOTAL DE FACTURA

UPDATE factura
SET estado_pago = 'pendiente'
WHERE id_reservacion = 1;

SELECT id_factura,
       id_reservacion,
       total_factura,
       estado_pago
FROM factura
WHERE id_reservacion = 1;

INSERT INTO consumo_servicio (
    cantidad,
    precio_unitario,
    fecha_consumo,
    id_servicio,
    id_reservacion
)
VALUES (
    1,
    12.00,
    NOW(),
    5,
    1
);

SELECT id_factura,
       id_reservacion,
       total_factura,
       estado_pago
FROM factura
WHERE id_reservacion = 1;