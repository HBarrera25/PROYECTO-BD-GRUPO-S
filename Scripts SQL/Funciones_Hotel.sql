-- ============================================================
-- FUNCION 1: TOTAL DE SERVICIOS CONSUMIDOS POR RESERVACION
-- Calcula el monto total de los servicios adicionales
-- consumidos durante una reservación específica.
-- Retorna:
-- Un valor numérico correspondiente a la suma de los
-- subtotales registrados en consumo_servicio.
-- ============================================================

CREATE OR REPLACE FUNCTION fn_total_servicios_reservacion(
    p_id_reservacion BIGINT
)
RETURNS NUMERIC(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total NUMERIC(10,2);
BEGIN
    SELECT COALESCE(SUM(subtotal),0)
    INTO v_total
    FROM consumo_servicio
    WHERE id_reservacion = p_id_reservacion;

    RETURN v_total;
END;
$$;

-- prueba funcion 1
SELECT fn_total_servicios_reservacion(1);


-- ============================================================
-- FUNCION 2: TOTAL DE HOSPEDAJE DE UNA RESERVACION
-- Calcula el costo del hospedaje de una reservación
-- multiplicando la cantidad de noches por el precio
-- de la habitación reservada.
-- Retorna:
-- El costo total del hospedaje.
-- ============================================================

CREATE OR REPLACE FUNCTION fn_total_hospedaje_reservacion(
    p_id_reservacion BIGINT
)
RETURNS NUMERIC(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total NUMERIC(10,2);
BEGIN
    SELECT (r.fecha_salida - r.fecha_entrada) * th.precio_noche
    INTO v_total
    FROM reservacion r
    INNER JOIN habitacion h
        ON r.id_habitacion = h.id_habitacion
    INNER JOIN tipo_habitacion th
        ON h.id_tipo_habitacion = th.id_tipo_habitacion
    WHERE r.id_reservacion = p_id_reservacion;

    RETURN COALESCE(v_total,0);
END;
$$;

-- prueba funcion 2
SELECT fn_total_hospedaje_reservacion(1);

-- ============================================================
-- FUNCION 3: TOTAL GENERAL DE UNA RESERVACION
-- Obtiene el costo total de una reservación sumando
-- el costo del hospedaje y los servicios consumidos.
-- Retorna:
-- El monto total a pagar por la reservación.
-- ============================================================

CREATE OR REPLACE FUNCTION fn_total_reservacion(
    p_id_reservacion BIGINT
)
RETURNS NUMERIC(10,2)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN fn_total_hospedaje_reservacion(p_id_reservacion)
         + fn_total_servicios_reservacion(p_id_reservacion);
END;
$$;

-- prueba funcion 3
SELECT fn_total_reservacion(1);

-- ============================================================
-- FUNCION 4: HABITACIONES POR ESTADO
-- Consulta las habitaciones filtradas según el estado
-- indicado por el usuario.
-- Retorna:
-- Un conjunto de registros con la información de las
-- habitaciones que coinciden con el estado solicitado.
-- ============================================================

CREATE OR REPLACE FUNCTION fn_habitaciones_por_estado(
    p_estado VARCHAR
)
RETURNS TABLE(
    id_habitacion BIGINT,
    numero_habitacion VARCHAR,
    piso INTEGER,
    capacidad_maxima INTEGER,
    estado_habitacion VARCHAR,
    tipo_habitacion VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT h.id_habitacion,
           h.numero_habitacion,
           h.piso,
           h.capacidad_maxima,
           h.estado_habitacion,
           th.nombre_tipo
    FROM habitacion h
    INNER JOIN tipo_habitacion th
        ON h.id_tipo_habitacion = th.id_tipo_habitacion
    WHERE h.estado_habitacion = p_estado
    ORDER BY h.piso, h.numero_habitacion;
END;
$$;

-- prueba funcion 4
SELECT *
FROM fn_habitaciones_por_estado('disponible');


-- ============================================================
-- FUNCION 5: FACTURACION POR HUESPED
-- Genera un reporte de facturación agrupado por huésped.
-- Retorna:
-- La cantidad de facturas y el monto total facturado
-- para cada huésped registrado en el sistema.
-- ============================================================

CREATE OR REPLACE FUNCTION fn_facturacion_por_huesped()
RETURNS TABLE(
    id_huesped BIGINT,
    huesped TEXT,
    total_facturas BIGINT,
    total_facturado NUMERIC(10,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT h.id_huesped,
           CONCAT(h.nombre_huesped,' ',h.apellido_huesped),
           COUNT(f.id_factura)::BIGINT,
           COALESCE(SUM(f.total_factura),0)::NUMERIC(10,2)
    FROM huesped h
    INNER JOIN reservacion r
        ON h.id_huesped = r.id_huesped
    INNER JOIN factura f
        ON r.id_reservacion = f.id_reservacion
    GROUP BY h.id_huesped,
             h.nombre_huesped,
             h.apellido_huesped
    ORDER BY total_facturado DESC;
END;
$$;

-- prueba funcion 5
SELECT *
FROM fn_facturacion_por_huesped();