--Consultas:

--Consulta 1: mostrar las habitaciones registradas:
select id_habitacion,
numero_habitacion,
piso,
capacidad_maxima,
estado_habitacion
from habitacion order by numero_habitacion;

--Consulta 2: reservacion, huesped, habitacion y empleado que realiza la reservacion
select r.id_reservacion,
initcap(concat(h.nombre_huesped, ' ', h.apellido_huesped)) as nombre_completo_huesped,
ha.numero_habitacion,
initcap(concat(e.nombre_empleado, ' ', e.apellido_empleado)) as nombre_completo_empleado,
r.fecha_entrada,
r.fecha_salida,
r.estado_reserva
from reservacion r
inner join huesped h
on r.id_huesped = h.id_huesped
inner join habitacion ha
on r.id_habitacion = ha.id_habitacion
inner join nombre_empleado e
on r.id_empleado = e.id_empleado
order by r.id_reservacion;

--Consulta 3: huesped con mas de una reservacion
select h.id_huesped,
initcap(concat(h.nombre_huesped, ' ', h.apellido_huesped)) as nombre_completo_huesped,
count(r.id_reservacion) as total_reservaciones
from huesped h
inner join reservacion r
on h.id_huesped = r.id_huesped
group by h.id_huesped, 
nombre_completo_huesped 
having count(r.id_reservacion) > 1
order by total_reservaciones desc;

--Consulta 4: habitaciones sin reservaciones
select ha.id_habitacion,
ha.numero_habitacion,
ha.piso,
ha.estado_habitacion
from habitacion ha
left join reservacion r
on ha.id_habitacion  = r.id_habitacion 
where r.id_reservacion is null order by ha.numero_habitacion;

--Consulta 5: huespedes que han gastado mas de 300 dolares en el hotel
select h.id_huesped,
initcap(concat(h.nombre_huesped, ' ', h.apellido_huesped)) as nombre_completo_huesped,
sum(f.total_factura) as total_gastado
from huesped h
inner join reservacion r
on h.id_huesped = r.id_huesped 
inner join factura f
on r.id_reservacion = f.id_reservacion 
group by h.id_huesped,
nombre_completo_huesped  
having sum(f.total_factura)>300
order by total_gastado desc;

--Consulta 6: facturas que se pasan del promedio general
select r.id_reservacion,
initcap(concat(h.nombre_huesped, ' ', h.apellido_huesped)) as nombre_completo_huesped,
f.total_factura
from reservacion r
inner join huesped h
on r.id_huesped = h.id_huesped
inner join factura f
on r.id_reservacion = f.id_reservacion
where f.total_factura > (select avg(total_factura) from factura)
order by f.total_factura desc;

--Consulta 7: detalle de factura
select f.id_factura,
initcap(concat(h.nombre_huesped, ' ', h.apellido_huesped)) as nombre_completo_huesped,
df.descripcion,
df.cantidad,
df.valor_unitario,
df.subtotal,
f.total_factura,
f.metodo_pago
from factura f
inner join reservacion r
on f.id_reservacion = r.id_reservacion
inner join huesped h
on r.id_huesped = h.id_huesped
inner join detalle_factura df
on f.id_factura = df.id_factura
order by f.id_factura,
df.id_detalle_factura;

--Consulta 8: cantidad de reservaciones por estado
select estado_reserva,
count(*) as total_reservaciones
from reservacion
group by estado_reserva
order by total_reservaciones desc;

--Consulta 9: servicios mas consumidos
select s.nombre_servicio,
sum(cs.cantidad) as cantidad_consumida,
sum(cs.subtotal) as total_generado
from servicio s
inner join consumo_servicio cs
on s.id_servicio = cs.id_servicio
group by s.nombre_servicio
order by cantidad_consumida desc;

--Consulta 10: ingresos totales por mes
select extract(month from fecha_emision) as mes,
sum(total_factura) as ingresos_totales
from factura
group by extract(month from fecha_emision)
order by mes;

--Consulta 11: promedio de gasto por huesped
select h.id_huesped,
initcap(concat(h.nombre_huesped, ' ', h.apellido_huesped)) as nombre_completo_huesped,
round(avg(f.total_factura),2) as promedio_gastado
from huesped h
inner join reservacion r
on h.id_huesped = r.id_huesped
inner join factura f
on r.id_reservacion = f.id_reservacion
group by h.id_huesped,
nombre_completo_huesped 
order by promedio_gastado desc;

--Consulta 12: duracion de cada reservacion en dias
select id_reservacion,
fecha_entrada,
fecha_salida,
fecha_salida - fecha_entrada as dias_estadia,
estado_reserva
from reservacion
order by dias_estadia desc;

-- Consulta 13: información de huéspedes
select
    initcap(concat(nombre_huesped, ' ', apellido_huesped)) as nombre_completo,
    upper(dui) as dui,
    lower(correo_huesped) as correo,
    coalesce(telefono_huesped, 'sin telefono') as telefono,
    length(direccion_huesped) as longitud_direccion,
    to_char(fecha_registro, 'DD/MM/YYYY') as fecha_registro
from huesped
order by nombre_huesped;

