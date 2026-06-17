-- TRIGGERS PARA EL SISTEMA DE GESTION HOTELERA
-- ============================================================
--TRIGGER DE VALIDACIÓN
-- Evita que una reservación se traslape con otra reservación
-- activa sobre la misma habitación.
--revisa antes de guardar, aborta si hay conflicto
CREATE OR REPLACE FUNCTION fn_validar_disponibilidad_habitacion()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_conflictos INT;
BEGIN
    IF NEW.fecha_entrada >= NEW.fecha_salida THEN
        RAISE EXCEPTION
            'La fecha de entrada (%) debe ser anterior a la fecha de salida (%).',
            NEW.fecha_entrada, NEW.fecha_salida;
    END IF;

    SELECT COUNT(*)
    INTO v_conflictos
    FROM reservacion
    WHERE id_habitacion = NEW.id_habitacion
      AND estado_reserva IN ('pendiente', 'confirmada')
      AND id_reservacion IS DISTINCT FROM NEW.id_reservacion
      AND NEW.fecha_entrada < fecha_salida
      AND NEW.fecha_salida  > fecha_entrada;

    IF v_conflictos > 0 THEN
        RAISE EXCEPTION
            'La habitación % ya tiene una reservación activa en ese rango de fechas (% a %).',
            NEW.id_habitacion, NEW.fecha_entrada, NEW.fecha_salida;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_validar_disponibilidad_habitacion
BEFORE INSERT OR UPDATE OF fecha_entrada, fecha_salida, id_habitacion
ON reservacion
FOR EACH ROW
EXECUTE FUNCTION fn_validar_disponibilidad_habitacion();

INSERT INTO reservacion (fecha_entrada, fecha_salida, estado_reserva, id_habitacion, id_huesped, id_empleado)
VALUES ('2026-07-06', '2026-07-09', 'pendiente', 4, 2, 1);

INSERT INTO reservacion (fecha_entrada, fecha_salida, estado_reserva, id_habitacion, id_huesped, id_empleado)
VALUES ('2026-07-09', '2026-07-11', 'pendiente', 4, 2, 1);

INSERT INTO reservacion (fecha_entrada, fecha_salida, estado_reserva, id_habitacion, id_huesped, id_empleado)
VALUES ('2026-07-10', '2026-07-08', 'pendiente', 4, 2, 1);

SELECT id_reservacion, fecha_entrada, fecha_salida, estado_reserva, id_habitacion
FROM reservacion
WHERE id_habitacion = 4
ORDER BY fecha_entrada;

-- ============================================================
--TRIGGER DE AUDITORÍA
-- Registra cada cambio de precio_noche en tipo_habitacion.
-- Equivalente directo al ejemplo de clase con film.rental_rate.

CREATE TABLE IF NOT EXISTS auditoria_precio_tipo_habitacion (
    id_auditoria       BIGINT GENERATED ALWAYS AS IDENTITY,
    id_tipo_habitacion BIGINT         NOT NULL,
    precio_anterior    NUMERIC(10,2),
    precio_nuevo       NUMERIC(10,2),
    fecha_cambio       TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    usuario_bd         TEXT           DEFAULT CURRENT_USER,

    CONSTRAINT pk_auditoria_precio_tipo_habitacion PRIMARY KEY (id_auditoria)
);

CREATE OR REPLACE FUNCTION fn_auditar_cambio_precio_habitacion()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.precio_noche IS DISTINCT FROM NEW.precio_noche THEN
        INSERT INTO auditoria_precio_tipo_habitacion (
            id_tipo_habitacion, precio_anterior, precio_nuevo
        )
        VALUES (
            OLD.id_tipo_habitacion, OLD.precio_noche, NEW.precio_noche
        );
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_auditar_cambio_precio_habitacion
AFTER UPDATE OF precio_noche
ON tipo_habitacion
FOR EACH ROW
EXECUTE FUNCTION fn_auditar_cambio_precio_habitacion();

UPDATE tipo_habitacion
SET precio_noche = precio_noche + 10.00
WHERE id_tipo_habitacion = 1;

SELECT * FROM auditoria_precio_tipo_habitacion ORDER BY fecha_cambio DESC;

-- ============================================================
-- TRIGGER PARA EVITAR BORRADO
-- Bloquea DELETE sobre servicios esenciales del hotel.
--intercepta antes de que se borre nada

CREATE OR REPLACE FUNCTION fn_evitar_borrado_servicio_esencial()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.nombre_servicio IN ('restaurante', 'room service') THEN
        RAISE EXCEPTION
            'No se puede eliminar el servicio "%" porque es un servicio esencial del hotel.',
            OLD.nombre_servicio;
    END IF;
    RETURN OLD;
END;
$$;

CREATE TRIGGER trg_evitar_borrado_servicio_esencial
BEFORE DELETE ON servicio
FOR EACH ROW
EXECUTE FUNCTION fn_evitar_borrado_servicio_esencial();

DELETE FROM servicio WHERE nombre_servicio = 'restaurante';

INSERT INTO servicio (nombre_servicio, descripcion, precio_base)
VALUES ('servicio de prueba', 'servicio temporal para probar el trigger', 5.00);

DELETE FROM servicio WHERE nombre_servicio = 'servicio de prueba';

SELECT id_servicio, nombre_servicio FROM servicio ORDER BY id_servicio;

-- ============================================================
-- TRIGGER DE ACTUALIZACIÓN AUTOMÁTICA DE ESTADO
-- Cuando se actualiza fecha_salida de una reservación y la
-- nueva fecha y el estado se cambia automáticamente a 'completada' sin intervención manual.
-- ajusta NEW.estado_reserva antes de persistir


CREATE OR REPLACE FUNCTION fn_auto_completar_reservacion()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.fecha_salida < CURRENT_DATE
       AND NEW.estado_reserva NOT IN ('cancelada', 'completada') THEN

        NEW.estado_reserva := 'completada';
        RAISE NOTICE
            'Reservación % marcada automáticamente como completada (fecha_salida % ya pasó).',
            NEW.id_reservacion, NEW.fecha_salida;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_auto_completar_reservacion
BEFORE INSERT OR UPDATE OF fecha_salida, estado_reserva
ON reservacion
FOR EACH ROW
EXECUTE FUNCTION fn_auto_completar_reservacion();

INSERT INTO reservacion (fecha_entrada, fecha_salida, estado_reserva, id_habitacion, id_huesped, id_empleado)
VALUES ('2025-01-01', '2025-01-05', 'confirmada', 1, 1, 1);

SELECT id_reservacion, fecha_entrada, fecha_salida, estado_reserva
FROM reservacion
WHERE fecha_salida = '2025-01-05';

-- ============================================================
-- TRIGGER DE AUDITORÍA COMPLETA DE RESERVACIONES
-- Registra INSERT, UPDATE y DELETE sobre la tabla reservacion
-- en una tabla de bitácora con tipo de operación,
-- valores anteriores y nuevos, timestamp y usuario.
-- registra evidencia después de que el cambio ocurrió
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

CREATE OR REPLACE FUNCTION fn_auditar_reservacion()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO auditoria_reservacion (operacion, id_reservacion, datos_antes, datos_despues)
        VALUES (
            'INSERT',
            NEW.id_reservacion,
            NULL,
            jsonb_build_object(
                'id_habitacion', NEW.id_habitacion,
                'id_huesped',    NEW.id_huesped,
                'fecha_entrada', NEW.fecha_entrada,
                'fecha_salida',  NEW.fecha_salida,
                'estado_reserva',NEW.estado_reserva
            )
        );

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO auditoria_reservacion (operacion, id_reservacion, datos_antes, datos_despues)
        VALUES (
            'UPDATE',
            NEW.id_reservacion,
            jsonb_build_object(
                'id_habitacion', OLD.id_habitacion,
                'fecha_entrada', OLD.fecha_entrada,
                'fecha_salida',  OLD.fecha_salida,
                'estado_reserva',OLD.estado_reserva
            ),
            jsonb_build_object(
                'id_habitacion', NEW.id_habitacion,
                'fecha_entrada', NEW.fecha_entrada,
                'fecha_salida',  NEW.fecha_salida,
                'estado_reserva',NEW.estado_reserva
            )
        );

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO auditoria_reservacion (operacion, id_reservacion, datos_antes, datos_despues)
        VALUES (
            'DELETE',
            OLD.id_reservacion,
            jsonb_build_object(
                'id_habitacion', OLD.id_habitacion,
                'fecha_entrada', OLD.fecha_entrada,
                'fecha_salida',  OLD.fecha_salida,
                'estado_reserva',OLD.estado_reserva
            ),
            NULL
        );
    END IF;
    RETURN COALESCE(NEW, OLD);
END;
$$;

CREATE TRIGGER trg_auditar_reservacion
AFTER INSERT OR UPDATE OR DELETE
ON reservacion
FOR EACH ROW
EXECUTE FUNCTION fn_auditar_reservacion();
INSERT INTO reservacion (fecha_entrada, fecha_salida, estado_reserva, id_habitacion, id_huesped, id_empleado)
VALUES ('2026-08-01', '2026-08-05', 'pendiente', 2, 1, 1);
UPDATE reservacion
SET estado_reserva = 'confirmada'
WHERE fecha_entrada = '2026-08-01' AND id_habitacion = 2;
SELECT operacion, id_reservacion, datos_antes, datos_despues, fecha_cambio, usuario_bd
FROM auditoria_reservacion
ORDER BY fecha_cambio DESC;

-- ============================================================
-- TRIGGER DE CONTROL DE CAPACIDAD POR TIPO DE HABITACION
-- Impide que se registren más habitaciones de un tipo de las.
-- La configuración del hotel permite (capacidad_maxima).
--valida antes de insertar la nueva habitación

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'tipo_habitacion'
          AND column_name = 'capacidad_maxima'
    ) THEN
        ALTER TABLE tipo_habitacion ADD COLUMN capacidad_maxima INT DEFAULT 10;
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION fn_controlar_capacidad_tipo_habitacion()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_capacidad_maxima INT;
    v_cantidad_actual  INT;
BEGIN
    SELECT capacidad_maxima
    INTO v_capacidad_maxima
    FROM tipo_habitacion
    WHERE id_tipo_habitacion = NEW.id_tipo_habitacion;
    
    IF v_capacidad_maxima IS NULL THEN
        RETURN NEW;
    END IF;
    SELECT COUNT(*)
    INTO v_cantidad_actual
    FROM habitacion
    WHERE id_tipo_habitacion = NEW.id_tipo_habitacion
      AND id_habitacion IS DISTINCT FROM NEW.id_habitacion;

    IF v_cantidad_actual >= v_capacidad_maxima THEN
        RAISE EXCEPTION
            'El tipo de habitación % ya alcanzó su capacidad máxima de % habitaciones (actualmente tiene %).',
            NEW.id_tipo_habitacion, v_capacidad_maxima, v_cantidad_actual;
    END IF;

    RETURN NEW;
END;
$$;
CREATE TRIGGER trg_controlar_capacidad_tipo_habitacion
BEFORE INSERT OR UPDATE OF id_tipo_habitacion
ON habitacion
FOR EACH ROW
EXECUTE FUNCTION fn_controlar_capacidad_tipo_habitacion();
UPDATE tipo_habitacion SET capacidad_maxima = 1 WHERE id_tipo_habitacion = 1;

INSERT INTO habitacion (numero_habitacion, piso, estado_habitacion, id_tipo_habitacion)

VALUES ('999', 9, 'disponible', 1);
UPDATE tipo_habitacion SET capacidad_maxima = 10 WHERE id_tipo_habitacion = 1;

INSERT INTO habitacion (numero_habitacion, piso, estado_habitacion, id_tipo_habitacion)
VALUES ('998', 9, 'disponible', 1);

SELECT id_habitacion, numero_habitacion, id_tipo_habitacion
FROM habitacion
ORDER BY id_habitacion DESC
LIMIT 5;
