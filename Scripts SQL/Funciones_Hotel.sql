-- ============================================================
-- FUNCION 1: TOTAL DE SERVICIOS CONSUMIDOS POR RESERVACION
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


-- ============================================================
-- FUNCION 2: TOTAL DE HOSPEDAJE DE UNA RESERVACION
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


-- ============================================================
-- FUNCION 3: TOTAL GENERAL DE UNA RESERVACION
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


-- ============================================================
-- FUNCION 4: HABITACIONES POR ESTADO
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


-- ============================================================
-- FUNCION 5: FACTURACION POR HUESPED
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