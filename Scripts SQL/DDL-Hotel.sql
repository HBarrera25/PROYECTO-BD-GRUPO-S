-- Creación de la base de datos
create database sistema_reservas_hotel;

-- Creación de tablas con sus respectivas restricciones

create table hotel(
    id_hotel bigint generated always as identity,
    nombre varchar(100) not null,
    direccion varchar(200) not null,
    correo varchar(150) not null,
    telefono varchar(20) not null,

    constraint pk_hotel primary key(id_hotel),
    constraint uq_hotel_correo unique(correo),
    constraint ck_hotel_correo check(correo like '%@%.%')
);


create table tipo_habitacion(
    id_tipo_habitacion bigint generated always as identity,
    nombre_tipo varchar(80) not null,
    descripcion varchar(300),
    capacidad int not null,
    precio_noche numeric(10, 2) not null,

    constraint pk_tipo_habitacion primary key(id_tipo_habitacion),
    constraint uq_tipo_habitacion_nombre_tipo unique(nombre_tipo),
    constraint ck_tipo_habitacion_capacidad check(capacidad > 0),
    constraint ck_tipo_habitacion_precio check(precio_noche > 0)
);


create table habitacion(
    id_habitacion bigint generated always as identity,
    piso int not null,
    numero_habitacion varchar(10) not null,
    capacidad_maxima int not null,
    estado_habitacion varchar(20) not null default 'disponible',
    id_hotel bigint not null,
    id_tipo_habitacion bigint not null,

    constraint pk_habitacion primary key(id_habitacion),
    constraint uq_habitacion_numero_hotel unique(numero_habitacion, id_hotel),
    constraint fk_habitacion_hotel foreign key(id_hotel)
        references hotel (id_hotel)
        on delete restrict on update cascade,
    constraint fk_habitacion_tipo_habitacion foreign key(id_tipo_habitacion)
        references tipo_habitacion (id_tipo_habitacion)
        on delete restrict on update cascade,
    constraint ck_habitacion_piso check (piso >= 0),
    constraint ck_habitacion_capacidad_maxima check (capacidad_maxima > 0),
    constraint ck_habitacion_estado check (estado_habitacion in ('disponible', 'ocupada', 'mantenimiento', 'fuera de servicio'))
);


create table nombre_empleado(
    id_empleado bigint generated always as identity,
    nombre_empleado varchar(100) not null,
    apellido_empleado varchar(100) not null,
    correo_empleado varchar(150) not null,
    telefono_empleado varchar(20),
    cargo varchar(80) not null,

    constraint pk_nombre_empleado primary key(id_empleado),
    constraint uq_nombre_empleado_correo unique(correo_empleado),
    constraint ck_nombre_empleado_correo check(correo_empleado like '%@%.%')
);


create table huesped(
    id_huesped bigint generated always as identity,
    dui varchar(15) not null,
    nombre_huesped varchar(100) not null,
    apellido_huesped varchar(100) not null,
    telefono_huesped varchar(20),
    correo_huesped varchar(150) not null,
    direccion_huesped varchar(200),
    fecha_registro date not null default current_date,

    constraint pk_huesped primary key(id_huesped),
    constraint uq_huesped_dui unique(dui),
    constraint uq_huesped_correo unique(correo_huesped),
    constraint ck_huesped_correo check(correo_huesped like '%@%.%')
);


create table reservacion(
    id_reservacion bigint generated always as identity,
    fecha_entrada date not null,
    fecha_salida date not null,
    fecha_reserva timestamp not null default now(),
    estado_reserva varchar(20) not null default 'pendiente',
    id_habitacion bigint not null,
    id_huesped bigint not null,
    id_empleado bigint not null,

    constraint pk_reservacion primary key(id_reservacion),
    constraint fk_reservacion_habitacion foreign key(id_habitacion)
        references habitacion (id_habitacion)
        on delete restrict on update cascade,
    constraint fk_reservacion_huesped foreign key(id_huesped)
        references huesped (id_huesped)
        on delete restrict on update cascade,
    constraint fk_reservacion_empleado foreign key(id_empleado)
        references nombre_empleado (id_empleado)
        on delete restrict on update cascade,
    constraint ck_reservacion_estado check(estado_reserva in
        ('pendiente', 'confirmada', 'cancelada', 'completada')),
    constraint ck_reservacion_fechas check(fecha_salida > fecha_entrada),
    constraint ck_reservacion_fecha_valida check(fecha_entrada >= fecha_reserva::date)
);


create table estancia(
    id_estancia bigint generated always as identity,
    fecha_check_in date not null,
    hora_check_in time not null,
    fecha_check_out date,
    hora_check_out time,
    observaciones text,
    id_reservacion bigint not null,

    constraint pk_estancia primary key(id_estancia),
    constraint uq_estancia_reservacion unique(id_reservacion),
    constraint fk_estancia_reservacion foreign key(id_reservacion)
        references reservacion (id_reservacion)
        on delete restrict on update cascade,
    constraint ck_estancia_fechas check(fecha_check_out >= fecha_check_in)

);


create table servicio(
    id_servicio bigint generated always as identity,
    nombre_servicio varchar(100) not null,
    descripcion varchar(300),
    precio_base numeric(10, 2) not null,

    constraint pk_servicio primary key(id_servicio),
    constraint uq_servicio_nombre unique(nombre_servicio),
    constraint ck_servicio_precio_base check(precio_base >= 0)
);


create table consumo_servicio(
    id_consumo bigint generated always as identity,
    cantidad int not null,
    precio_unitario numeric(10, 2) not null,
    fecha_consumo timestamp not null default now(),
    subtotal numeric(10, 2) generated always as (cantidad * precio_unitario) stored,
    id_servicio bigint not null,
    id_reservacion bigint not null,

    constraint pk_consumo_servicio primary key(id_consumo),
    constraint fk_consumo_servicio_servicio foreign key(id_servicio)
        references servicio (id_servicio)
        on delete restrict on update cascade,
    constraint fk_consumo_servicio_reservacion foreign key(id_reservacion)
        references reservacion (id_reservacion)
        on delete restrict on update cascade,
    constraint ck_consumo_servicio_cantidad check(cantidad > 0),
    constraint ck_consumo_servicio_precio check(precio_unitario >= 0)
);


create table factura(
    id_factura bigint generated always as identity,
    metodo_pago varchar(30) not null,
    estado_pago varchar(20) not null default 'pendiente',
    fecha_emision timestamp not null default now(),
    total_factura numeric(10, 2) not null default 0.00,
    id_reservacion bigint not null,
    id_empleado bigint not null,

    constraint pk_factura primary key(id_factura),
    constraint uq_factura_reservacion unique(id_reservacion),
    constraint fk_factura_reservacion foreign key(id_reservacion)
        references reservacion (id_reservacion)
        on delete restrict on update cascade,
    constraint fk_factura_empleado foreign key(id_empleado)
        references nombre_empleado (id_empleado)
        on delete restrict on update cascade,
    constraint ck_factura_metodo_pago check(metodo_pago in
        ('efectivo', 'tarjeta credito', 'tarjeta debito', 'transferencia')),
    constraint ck_factura_estado_pago check(estado_pago in ('pendiente', 'pagada', 'anulada')),
    constraint ck_factura_total check(total_factura >= 0)
);


create table detalle_factura(
    id_detalle_factura bigint generated always as identity,
    descripcion varchar(200) not null,
    cantidad int not null,
    valor_unitario numeric(10, 2)  not null,
    subtotal numeric(10, 2) generated always as (cantidad * valor_unitario) stored,
    id_factura bigint not null,

    constraint pk_detalle_factura primary key(id_detalle_factura),
    constraint fk_detalle_factura_factura foreign key(id_factura)
        references factura (id_factura)
        on delete cascade on update cascade,
    constraint ck_detalle_factura_cantidad check(cantidad > 0),
    constraint ck_detalle_factura_valor check(valor_unitario >= 0)
);