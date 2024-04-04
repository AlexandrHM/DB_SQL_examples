--
-- PostgreSQL database dump
--

-- Dumped from database version 10.14 (Ubuntu 10.14-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 12.18 (Ubuntu 12.18-0ubuntu0.20.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;


--
-- Name: EXTENSION dblink; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';


--
-- Name: actualizar1(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar1() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

delete from det_update du where du.id_programadas in (select pp.id_programadas from programadas pp inner join det_update2 du on du.id_programadas=pp.id_programadas); 

return new;
END;
$$;


ALTER FUNCTION public.actualizar1() OWNER TO postgres;

--
-- Name: actualizar2(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar2() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

update det_update du set status=1 where du.id_programadas in (select du.id_programadas from det_update inner join det_update2 d2 on du.id_programadas=d2.id_programadas);
return new;
END;
$$;


ALTER FUNCTION public.actualizar2() OWNER TO postgres;

--
-- Name: actualizar_leq(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar_leq() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

update leq l set status=4 where l.id_leq in (select l.id_leq from leq qinner join programadas p on l.id_leq=p.id_leq); 

return new;
END;
$$;


ALTER FUNCTION public.actualizar_leq() OWNER TO postgres;

--
-- Name: cancelar_programada(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cancelar_programada() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

update programadas p set status=2 where p.id_programadas in (select p.id_programadas from programadas inner join det_programadas dp on p.id_programadas=dp.id_programadas); 

return new;
END;
$$;


ALTER FUNCTION public.cancelar_programada() OWNER TO postgres;

--
-- Name: insertar_leq1(integer, integer, integer, integer, integer, integer, integer, date, time without time zone, integer, integer, integer, integer, integer, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_leq1(integer, integer, integer, integer, integer, integer, integer, date, time without time zone, integer, integer, integer, integer, integer, text, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
    DECLARE 
    regresar integer;
    id integer;
    BEGIN

INSERT INTO leq VALUES(default,default,
$1,$2,$3,$4,$5,$6,$7,$8,$9,
$10,$11,$12,$13,default,$14,$15,default,$16) RETURNING id_leq INTO regresar;

select id_leq INTO id from leq where id_leq=regresar;
 


RETURN id;

END;

$_$;


ALTER FUNCTION public.insertar_leq1(integer, integer, integer, integer, integer, integer, integer, date, time without time zone, integer, integer, integer, integer, integer, text, integer) OWNER TO postgres;

--
-- Name: status(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.status() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
x int;
y int;
BEGIN
x:=1;
y:=0;

IF new.status=y THEN
update usuario set status=y where id_medico=new.id_medico;
ELSIF new.status=x THEN
update usuario set status=x where id_medico=new.id_medico;
END IF;

RETURN NEW;
END
$$;


ALTER FUNCTION public.status() OWNER TO postgres;

--
-- Name: update1(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update1() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

update programadas p set status=1 where p.id_programadas in (select p.id_programadas from programadas inner join det_update du on p.id_programadas=du.id_programadas); 

return new;
END;
$$;


ALTER FUNCTION public.update1() OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: estados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estados (
    id_estado integer NOT NULL,
    clave text NOT NULL,
    descripcion_estado text NOT NULL,
    id_nacionalidades integer,
    abrev text NOT NULL,
    activo boolean DEFAULT true
);


ALTER TABLE public.estados OWNER TO postgres;

--
-- Name: nacionalidades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nacionalidades (
    id_nacionalidad integer NOT NULL,
    descripcion_nacionalidad text NOT NULL,
    clave_nacionalidad text NOT NULL
);


ALTER TABLE public.nacionalidades OWNER TO postgres;

--
-- Name: paciente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paciente (
    id_paciente integer NOT NULL,
    nombre_paciente text NOT NULL,
    apellido_paterno text NOT NULL,
    apellido_materno text NOT NULL,
    edad integer NOT NULL,
    sexo text NOT NULL,
    numero_afiliacion text NOT NULL,
    fecha_nacimiento date NOT NULL,
    fecha_ingreso date NOT NULL,
    cp integer NOT NULL,
    telefono text NOT NULL,
    domicilio text NOT NULL,
    id_nivel integer,
    id_nacionalidad integer,
    id_estado integer,
    id_localidad integer,
    id_municipio integer,
    curp text
);


ALTER TABLE public.paciente OWNER TO postgres;

--
-- Name: buscar_paciente; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.buscar_paciente AS
 SELECT e.descripcion_estado,
    n.descripcion_nacionalidad,
    p.id_paciente,
    p.nombre_paciente,
    p.apellido_paterno,
    p.apellido_materno,
    p.edad,
    p.sexo,
    p.numero_afiliacion,
    p.fecha_nacimiento,
    p.fecha_ingreso,
    p.cp,
    p.telefono,
    p.domicilio,
    p.id_nivel,
    p.id_nacionalidad,
    p.id_estado,
    p.id_localidad,
    p.id_municipio
   FROM ((public.nacionalidades n
     JOIN public.paciente p ON ((p.id_nacionalidad = n.id_nacionalidad)))
     JOIN public.estados e ON ((p.id_estado = e.id_estado)));


ALTER TABLE public.buscar_paciente OWNER TO postgres;

--
-- Name: localidades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.localidades (
    id_localidad integer NOT NULL,
    id_municipio integer,
    clave text,
    descripcion_localidad text,
    latitud text,
    longitud text,
    altitud text,
    carta text,
    ambito text,
    poblacion integer,
    masculino integer,
    femenino integer,
    viviendas integer,
    lat numeric(10,7),
    lng numeric(10,7),
    activo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.localidades OWNER TO postgres;

--
-- Name: municipios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.municipios (
    id_municipio integer NOT NULL,
    id_estado integer,
    clave text NOT NULL,
    descripcion_municipio text NOT NULL,
    activo boolean DEFAULT true
);


ALTER TABLE public.municipios OWNER TO postgres;

--
-- Name: buscar_paciente1; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.buscar_paciente1 AS
 SELECT p.id_paciente,
    m.descripcion_municipio,
    l.descripcion_localidad
   FROM ((public.municipios m
     JOIN public.paciente p ON ((m.id_municipio = p.id_municipio)))
     JOIN public.localidades l ON ((p.id_localidad = l.id_localidad)));


ALTER TABLE public.buscar_paciente1 OWNER TO postgres;

--
-- Name: cirugia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cirugia (
    id_cirugia integer NOT NULL,
    descripcion_cirugia text,
    id_especialidad integer,
    id_tecnica integer
);


ALTER TABLE public.cirugia OWNER TO postgres;

--
-- Name: cirugia_id_cirugia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cirugia_id_cirugia_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cirugia_id_cirugia_seq OWNER TO postgres;

--
-- Name: cirugia_id_cirugia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cirugia_id_cirugia_seq OWNED BY public.cirugia.id_cirugia;


--
-- Name: det_instrumentos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.det_instrumentos (
    cns_instrumento integer NOT NULL,
    id_instrumento integer,
    descripcion_det_instrumentos text NOT NULL,
    cantidad_unidad integer NOT NULL
);


ALTER TABLE public.det_instrumentos OWNER TO postgres;

--
-- Name: det_instrumentos_cns_instrumento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.det_instrumentos_cns_instrumento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.det_instrumentos_cns_instrumento_seq OWNER TO postgres;

--
-- Name: det_instrumentos_cns_instrumento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.det_instrumentos_cns_instrumento_seq OWNED BY public.det_instrumentos.cns_instrumento;


--
-- Name: det_instrumentos_leq; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.det_instrumentos_leq (
    cns_det_instrumentos_leq integer NOT NULL,
    cns_instrumento integer,
    id_leq integer,
    status integer DEFAULT 0,
    CONSTRAINT det_instrumentos_leq_status_check CHECK ((status <= 2))
);


ALTER TABLE public.det_instrumentos_leq OWNER TO postgres;

--
-- Name: det_instrumentos_leq_cns_det_instrumentos_leq_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.det_instrumentos_leq_cns_det_instrumentos_leq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.det_instrumentos_leq_cns_det_instrumentos_leq_seq OWNER TO postgres;

--
-- Name: det_instrumentos_leq_cns_det_instrumentos_leq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.det_instrumentos_leq_cns_det_instrumentos_leq_seq OWNED BY public.det_instrumentos_leq.cns_det_instrumentos_leq;


--
-- Name: det_programadas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.det_programadas (
    id_programadas integer NOT NULL,
    cns integer NOT NULL,
    id_motivo integer
);


ALTER TABLE public.det_programadas OWNER TO postgres;

--
-- Name: det_programadas_cns_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.det_programadas_cns_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.det_programadas_cns_seq OWNER TO postgres;

--
-- Name: det_programadas_cns_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.det_programadas_cns_seq OWNED BY public.det_programadas.cns;


--
-- Name: det_sangre_leq; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.det_sangre_leq (
    cns_det_sangre_leq integer NOT NULL,
    id_leq integer NOT NULL,
    id_sangre integer NOT NULL,
    cantidad integer,
    status integer DEFAULT 0,
    comentario text,
    CONSTRAINT det_sangre_leq_status_check CHECK ((status <= 2))
);


ALTER TABLE public.det_sangre_leq OWNER TO postgres;

--
-- Name: det_sangre_leq_cns_det_sangre_leq_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.det_sangre_leq_cns_det_sangre_leq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.det_sangre_leq_cns_det_sangre_leq_seq OWNER TO postgres;

--
-- Name: det_sangre_leq_cns_det_sangre_leq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.det_sangre_leq_cns_det_sangre_leq_seq OWNED BY public.det_sangre_leq.cns_det_sangre_leq;


--
-- Name: det_update; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.det_update (
    id_programadas integer NOT NULL,
    cns integer NOT NULL,
    fecha_cirugia date,
    hora_cirugia time without time zone
);


ALTER TABLE public.det_update OWNER TO postgres;

--
-- Name: det_update_cns_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.det_update_cns_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.det_update_cns_seq OWNER TO postgres;

--
-- Name: det_update_cns_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.det_update_cns_seq OWNED BY public.det_update.cns;


--
-- Name: especialidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.especialidad (
    id_especialidad integer NOT NULL,
    descripcion_especialidad text,
    id_quirofano integer
);


ALTER TABLE public.especialidad OWNER TO postgres;

--
-- Name: especialidad_id_especialidad_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.especialidad_id_especialidad_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.especialidad_id_especialidad_seq OWNER TO postgres;

--
-- Name: especialidad_id_especialidad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.especialidad_id_especialidad_seq OWNED BY public.especialidad.id_especialidad;


--
-- Name: institucion_procedencia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.institucion_procedencia (
    id_institucion integer NOT NULL,
    descripcion_institucion text,
    rfc text,
    domicilio_fiscal text,
    CONSTRAINT descripcion_institucion CHECK ((descripcion_institucion ~ '^[a-zA-Z0-9 ]+$'::text))
);


ALTER TABLE public.institucion_procedencia OWNER TO postgres;

--
-- Name: institucion_procedencia_id_institucion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.institucion_procedencia_id_institucion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.institucion_procedencia_id_institucion_seq OWNER TO postgres;

--
-- Name: institucion_procedencia_id_institucion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.institucion_procedencia_id_institucion_seq OWNED BY public.institucion_procedencia.id_institucion;


--
-- Name: instrumentos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrumentos (
    id_instrumento integer NOT NULL,
    descripcion_instrumento text NOT NULL,
    cantida_total integer DEFAULT 0 NOT NULL,
    id_vitrina integer,
    id_seccion integer
);


ALTER TABLE public.instrumentos OWNER TO postgres;

--
-- Name: instrumentos_id_instrumento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instrumentos_id_instrumento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instrumentos_id_instrumento_seq OWNER TO postgres;

--
-- Name: instrumentos_id_instrumento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instrumentos_id_instrumento_seq OWNED BY public.instrumentos.id_instrumento;


--
-- Name: sec_folio; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sec_folio
    START WITH 100
    INCREMENT BY 1
    MINVALUE 100
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sec_folio OWNER TO postgres;

--
-- Name: leq; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leq (
    id_leq integer NOT NULL,
    fecha_solicitud date DEFAULT now(),
    id_tipo_anestesia integer,
    id_institucion integer,
    id_prioridad_clinica integer,
    id_tipo_cirugia integer,
    id_paciente integer,
    id_medico integer,
    id_cirugia integer,
    fecha_cirugia date,
    hora_cirugia time without time zone,
    id_anestesiologo integer,
    id_quirofano integer,
    radiologia integer,
    biopsia integer,
    status integer DEFAULT 0,
    tipo_leq integer NOT NULL,
    diagnostico text,
    folio integer DEFAULT nextval('public.sec_folio'::regclass),
    pedido_sangre integer NOT NULL
);


ALTER TABLE public.leq OWNER TO postgres;

--
-- Name: leq_id_leq_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.leq_id_leq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.leq_id_leq_seq OWNER TO postgres;

--
-- Name: leq_id_leq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.leq_id_leq_seq OWNED BY public.leq.id_leq;


--
-- Name: medicamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medicamento (
    id_medicamento integer NOT NULL,
    clave_medicamento text,
    nombre_medicamento text,
    id_tabulador integer
);


ALTER TABLE public.medicamento OWNER TO postgres;

--
-- Name: medicamento_id_medicamento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.medicamento_id_medicamento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medicamento_id_medicamento_seq OWNER TO postgres;

--
-- Name: medicamento_id_medicamento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.medicamento_id_medicamento_seq OWNED BY public.medicamento.id_medicamento;


--
-- Name: medico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medico (
    id_medico integer NOT NULL,
    nombre_medico text NOT NULL,
    apellido_paterno_medico text NOT NULL,
    apellido_materno_medico text NOT NULL,
    sexo text NOT NULL,
    id_especialidad integer,
    status integer DEFAULT 1
);


ALTER TABLE public.medico OWNER TO postgres;

--
-- Name: medico_id_medico_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.medico_id_medico_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medico_id_medico_seq OWNER TO postgres;

--
-- Name: medico_id_medico_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.medico_id_medico_seq OWNED BY public.medico.id_medico;


--
-- Name: motivos_cancelacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.motivos_cancelacion (
    id_motivos integer NOT NULL,
    descripcion_motivos text
);


ALTER TABLE public.motivos_cancelacion OWNER TO postgres;

--
-- Name: motivos_cancelacion_id_motivos_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.motivos_cancelacion_id_motivos_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.motivos_cancelacion_id_motivos_seq OWNER TO postgres;

--
-- Name: motivos_cancelacion_id_motivos_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.motivos_cancelacion_id_motivos_seq OWNED BY public.motivos_cancelacion.id_motivos;


--
-- Name: nivel_socioeconomico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nivel_socioeconomico (
    id_nivel integer NOT NULL,
    descripcion_nivel text
);


ALTER TABLE public.nivel_socioeconomico OWNER TO postgres;

--
-- Name: nivel_socioeconomico_id_nivel_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nivel_socioeconomico_id_nivel_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nivel_socioeconomico_id_nivel_seq OWNER TO postgres;

--
-- Name: nivel_socioeconomico_id_nivel_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nivel_socioeconomico_id_nivel_seq OWNED BY public.nivel_socioeconomico.id_nivel;


--
-- Name: paciente_id_paciente_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.paciente_id_paciente_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.paciente_id_paciente_seq OWNER TO postgres;

--
-- Name: paciente_id_paciente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.paciente_id_paciente_seq OWNED BY public.paciente.id_paciente;


--
-- Name: prioridad_clinica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prioridad_clinica (
    id_prioridad_clinica integer NOT NULL,
    descripcion_prioridad text
);


ALTER TABLE public.prioridad_clinica OWNER TO postgres;

--
-- Name: prioridad_clinica_id_prioridad_clinica_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.prioridad_clinica_id_prioridad_clinica_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.prioridad_clinica_id_prioridad_clinica_seq OWNER TO postgres;

--
-- Name: prioridad_clinica_id_prioridad_clinica_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.prioridad_clinica_id_prioridad_clinica_seq OWNED BY public.prioridad_clinica.id_prioridad_clinica;


--
-- Name: programadas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.programadas (
    id_programadas integer NOT NULL,
    folio integer NOT NULL,
    id_leq integer NOT NULL,
    fecha_solicitud_leq date DEFAULT now(),
    fecha_cirugia date DEFAULT now(),
    hora_cirugia time without time zone,
    id_tipo_anestesia integer,
    id_institucion integer,
    id_prioridad_clinica integer,
    id_tipo_cirugia integer,
    id_paciente integer,
    id_medico integer,
    qx_proyectada integer,
    id_anestesiologo integer,
    id_quirofano integer,
    especialidad integer,
    radiologia integer,
    biopsia integer,
    toto text,
    rxrx text,
    hd text,
    tipo_leq integer NOT NULL,
    diagnostico text,
    valoraciones integer,
    tipo_urgencia integer,
    status integer DEFAULT 0
);


ALTER TABLE public.programadas OWNER TO postgres;

--
-- Name: programadas_id_programadas_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.programadas_id_programadas_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.programadas_id_programadas_seq OWNER TO postgres;

--
-- Name: programadas_id_programadas_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.programadas_id_programadas_seq OWNED BY public.programadas.id_programadas;


--
-- Name: quirofano; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quirofano (
    id_quirofano integer NOT NULL,
    descripcion_quirofano text
);


ALTER TABLE public.quirofano OWNER TO postgres;

--
-- Name: quirofano_id_quirofano_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quirofano_id_quirofano_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quirofano_id_quirofano_seq OWNER TO postgres;

--
-- Name: quirofano_id_quirofano_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quirofano_id_quirofano_seq OWNED BY public.quirofano.id_quirofano;


--
-- Name: rp1; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.rp1 AS
 SELECT pp.id_leq,
    pp.folio,
    ((((p.nombre_paciente || ' '::text) || p.apellido_paterno) || ' '::text) || p.apellido_materno) AS nombre_paciente_completo,
    p.edad,
    p.sexo
   FROM (public.programadas pp
     JOIN public.paciente p ON ((p.id_paciente = pp.id_paciente)));


ALTER TABLE public.rp1 OWNER TO postgres;

--
-- Name: rp2; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.rp2 AS
 SELECT pp.id_leq,
    pp.hora_cirugia,
    pp.fecha_cirugia,
    q.descripcion_quirofano
   FROM (public.programadas pp
     JOIN public.quirofano q ON ((q.id_quirofano = pp.id_quirofano)));


ALTER TABLE public.rp2 OWNER TO postgres;

--
-- Name: urgencia_cirugia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.urgencia_cirugia (
    id_urgencia integer NOT NULL,
    descripcion_urgencia text
);


ALTER TABLE public.urgencia_cirugia OWNER TO postgres;

--
-- Name: rp3; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.rp3 AS
 SELECT pp.id_leq,
    u.descripcion_urgencia,
    pp.diagnostico,
    c.descripcion_cirugia,
    ((((m.nombre_medico || ' '::text) || m.apellido_paterno_medico) || ' '::text) || m.apellido_materno_medico) AS nombre_medico_completo
   FROM (((public.programadas pp
     JOIN public.medico m ON ((pp.id_medico = m.id_medico)))
     JOIN public.cirugia c ON ((c.id_cirugia = pp.qx_proyectada)))
     JOIN public.urgencia_cirugia u ON ((u.id_urgencia = pp.tipo_urgencia)));


ALTER TABLE public.rp3 OWNER TO postgres;

--
-- Name: rp4; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.rp4 AS
 SELECT pp.id_leq,
    pp.rxrx,
    pp.toto,
    pp.hd,
    pp.status,
    e.descripcion_especialidad,
    ((((m.nombre_medico || ' '::text) || m.apellido_paterno_medico) || ' '::text) || m.apellido_materno_medico) AS nombre_anestesiologo_completo
   FROM ((public.programadas pp
     JOIN public.medico m ON ((pp.id_anestesiologo = m.id_medico)))
     JOIN public.especialidad e ON ((pp.especialidad = e.id_especialidad)));


ALTER TABLE public.rp4 OWNER TO postgres;

--
-- Name: reporte_1; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.reporte_1 AS
 SELECT r1.folio,
    r1.nombre_paciente_completo,
    r1.edad,
    r1.sexo,
    r2.hora_cirugia,
    r2.fecha_cirugia,
    r2.descripcion_quirofano,
    r3.descripcion_urgencia,
    r3.diagnostico,
    r3.descripcion_cirugia,
    r4.descripcion_especialidad,
    r3.nombre_medico_completo,
    r4.rxrx,
    r4.toto,
    r4.hd,
    r4.status,
    r4.nombre_anestesiologo_completo
   FROM (((public.rp1 r1
     JOIN public.rp2 r2 ON ((r1.id_leq = r2.id_leq)))
     JOIN public.rp3 r3 ON ((r1.id_leq = r3.id_leq)))
     JOIN public.rp4 r4 ON ((r1.id_leq = r4.id_leq)));


ALTER TABLE public.reporte_1 OWNER TO postgres;

--
-- Name: rol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rol (
    id_rol integer NOT NULL,
    descripcion_rol text
);


ALTER TABLE public.rol OWNER TO postgres;

--
-- Name: sangre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sangre (
    id_sangre integer NOT NULL,
    grupo text NOT NULL,
    factor text NOT NULL
);


ALTER TABLE public.sangre OWNER TO postgres;

--
-- Name: sangre_id_sangre_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sangre_id_sangre_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sangre_id_sangre_seq OWNER TO postgres;

--
-- Name: sangre_id_sangre_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sangre_id_sangre_seq OWNED BY public.sangre.id_sangre;


--
-- Name: seccion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seccion (
    id_seccion integer NOT NULL,
    seccion text NOT NULL
);


ALTER TABLE public.seccion OWNER TO postgres;

--
-- Name: seccion_id_seccion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seccion_id_seccion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seccion_id_seccion_seq OWNER TO postgres;

--
-- Name: seccion_id_seccion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seccion_id_seccion_seq OWNED BY public.seccion.id_seccion;


--
-- Name: tabulador; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tabulador (
    id_tabulador integer NOT NULL,
    descripcion_tabulador text
);


ALTER TABLE public.tabulador OWNER TO postgres;

--
-- Name: tabulador_id_tabulador_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tabulador_id_tabulador_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tabulador_id_tabulador_seq OWNER TO postgres;

--
-- Name: tabulador_id_tabulador_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tabulador_id_tabulador_seq OWNED BY public.tabulador.id_tabulador;


--
-- Name: tecnica_cirugia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tecnica_cirugia (
    id_tecnica integer NOT NULL,
    descripcion_tecnica text
);


ALTER TABLE public.tecnica_cirugia OWNER TO postgres;

--
-- Name: tecnica_cirugia_id_tecnica_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tecnica_cirugia_id_tecnica_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tecnica_cirugia_id_tecnica_seq OWNER TO postgres;

--
-- Name: tecnica_cirugia_id_tecnica_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tecnica_cirugia_id_tecnica_seq OWNED BY public.tecnica_cirugia.id_tecnica;


--
-- Name: tipo_anestesia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_anestesia (
    id_tipo_anestesia integer NOT NULL,
    descripcion_tipo_anestesia text
);


ALTER TABLE public.tipo_anestesia OWNER TO postgres;

--
-- Name: tipo_anestesia_id_tipo_anestesia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipo_anestesia_id_tipo_anestesia_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipo_anestesia_id_tipo_anestesia_seq OWNER TO postgres;

--
-- Name: tipo_anestesia_id_tipo_anestesia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_anestesia_id_tipo_anestesia_seq OWNED BY public.tipo_anestesia.id_tipo_anestesia;


--
-- Name: tipo_cirugia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_cirugia (
    id_tipo_cirugia integer NOT NULL,
    descripcion_tipo_cirugia text
);


ALTER TABLE public.tipo_cirugia OWNER TO postgres;

--
-- Name: tipo_cirugia_id_tipo_cirugia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tipo_cirugia_id_tipo_cirugia_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipo_cirugia_id_tipo_cirugia_seq OWNER TO postgres;

--
-- Name: tipo_cirugia_id_tipo_cirugia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tipo_cirugia_id_tipo_cirugia_seq OWNED BY public.tipo_cirugia.id_tipo_cirugia;


--
-- Name: urgencia_cirugia_id_urgencia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.urgencia_cirugia_id_urgencia_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.urgencia_cirugia_id_urgencia_seq OWNER TO postgres;

--
-- Name: urgencia_cirugia_id_urgencia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.urgencia_cirugia_id_urgencia_seq OWNED BY public.urgencia_cirugia.id_urgencia;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    id_usuario integer NOT NULL,
    nombre_usuario text,
    password text,
    telefono text,
    correo text,
    id_medico integer,
    id_rol integer,
    status integer DEFAULT 1
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_id_usuario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_id_usuario_seq OWNER TO postgres;

--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_id_usuario_seq OWNED BY public.usuario.id_usuario;


--
-- Name: v_materiales; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_materiales AS
 SELECT dil.id_leq,
    di.descripcion_det_instrumentos
   FROM ((public.det_instrumentos di
     JOIN public.det_instrumentos_leq dil ON ((di.cns_instrumento = dil.cns_instrumento)))
     JOIN public.leq l ON ((dil.id_leq = l.id_leq)));


ALTER TABLE public.v_materiales OWNER TO postgres;

--
-- Name: v_sangre_leq; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_sangre_leq AS
 SELECT l.pedido_sangre,
    dsl.id_leq,
    s.grupo,
    s.factor,
    dsl.cantidad
   FROM ((public.sangre s
     JOIN public.det_sangre_leq dsl ON ((s.id_sangre = dsl.id_sangre)))
     JOIN public.leq l ON ((dsl.id_leq = l.id_leq)))
  WHERE ((l.pedido_sangre = 1) OR (l.pedido_sangre = 0));


ALTER TABLE public.v_sangre_leq OWNER TO postgres;

--
-- Name: vista1; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vista1 AS
 SELECT l.pedido_sangre,
    l.fecha_solicitud,
    l.fecha_cirugia,
    l.hora_cirugia,
    l.biopsia,
    l.radiologia,
    l.folio,
    l.diagnostico,
    l.id_leq,
    tc.descripcion_tipo_cirugia,
    q.descripcion_quirofano
   FROM ((public.tipo_cirugia tc
     JOIN public.leq l ON ((tc.id_tipo_cirugia = l.id_tipo_cirugia)))
     JOIN public.quirofano q ON ((l.id_quirofano = q.id_quirofano)));


ALTER TABLE public.vista1 OWNER TO postgres;

--
-- Name: vista2; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vista2 AS
 SELECT l.id_leq,
    m.nombre_medico,
    m.apellido_paterno_medico,
    m.apellido_materno_medico,
    c.descripcion_cirugia
   FROM ((public.medico m
     JOIN public.leq l ON ((m.id_medico = l.id_medico)))
     JOIN public.cirugia c ON ((l.id_cirugia = c.id_cirugia)));


ALTER TABLE public.vista2 OWNER TO postgres;

--
-- Name: vista3; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vista3 AS
 SELECT l.id_leq,
    p.nombre_paciente,
    p.apellido_paterno,
    p.apellido_materno,
    p.fecha_nacimiento,
    p.edad,
    p.sexo,
    p.telefono,
    p.domicilio,
    pc.descripcion_prioridad,
    p.numero_afiliacion
   FROM ((public.paciente p
     JOIN public.leq l ON ((l.id_paciente = p.id_paciente)))
     JOIN public.prioridad_clinica pc ON ((l.id_prioridad_clinica = pc.id_prioridad_clinica)));


ALTER TABLE public.vista3 OWNER TO postgres;

--
-- Name: vista4; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vista4 AS
 SELECT l.id_leq,
    ip.descripcion_institucion,
    ta.descripcion_tipo_anestesia
   FROM ((public.institucion_procedencia ip
     JOIN public.leq l ON ((ip.id_institucion = l.id_institucion)))
     JOIN public.tipo_anestesia ta ON ((l.id_tipo_anestesia = ta.id_tipo_anestesia)));


ALTER TABLE public.vista4 OWNER TO postgres;

--
-- Name: vista5; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vista5 AS
 SELECT l.id_leq,
    a.nombre_medico AS nombre_anestesiologo,
    a.apellido_paterno_medico AS apellido_paterno_anestesiologo,
    a.apellido_materno_medico AS apellido_materno_anestesiologo
   FROM (public.medico a
     JOIN public.leq l ON ((a.id_medico = l.id_anestesiologo)));


ALTER TABLE public.vista5 OWNER TO postgres;

--
-- Name: vitrinas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vitrinas (
    id_vitrina integer NOT NULL,
    descripcion_vitrina text NOT NULL
);


ALTER TABLE public.vitrinas OWNER TO postgres;

--
-- Name: vitrinas_id_vitrina_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vitrinas_id_vitrina_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vitrinas_id_vitrina_seq OWNER TO postgres;

--
-- Name: vitrinas_id_vitrina_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vitrinas_id_vitrina_seq OWNED BY public.vitrinas.id_vitrina;


--
-- Name: cirugia id_cirugia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia ALTER COLUMN id_cirugia SET DEFAULT nextval('public.cirugia_id_cirugia_seq'::regclass);


--
-- Name: det_instrumentos cns_instrumento; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_instrumentos ALTER COLUMN cns_instrumento SET DEFAULT nextval('public.det_instrumentos_cns_instrumento_seq'::regclass);


--
-- Name: det_instrumentos_leq cns_det_instrumentos_leq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_instrumentos_leq ALTER COLUMN cns_det_instrumentos_leq SET DEFAULT nextval('public.det_instrumentos_leq_cns_det_instrumentos_leq_seq'::regclass);


--
-- Name: det_programadas cns; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_programadas ALTER COLUMN cns SET DEFAULT nextval('public.det_programadas_cns_seq'::regclass);


--
-- Name: det_sangre_leq cns_det_sangre_leq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_sangre_leq ALTER COLUMN cns_det_sangre_leq SET DEFAULT nextval('public.det_sangre_leq_cns_det_sangre_leq_seq'::regclass);


--
-- Name: det_update cns; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_update ALTER COLUMN cns SET DEFAULT nextval('public.det_update_cns_seq'::regclass);


--
-- Name: especialidad id_especialidad; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialidad ALTER COLUMN id_especialidad SET DEFAULT nextval('public.especialidad_id_especialidad_seq'::regclass);


--
-- Name: institucion_procedencia id_institucion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.institucion_procedencia ALTER COLUMN id_institucion SET DEFAULT nextval('public.institucion_procedencia_id_institucion_seq'::regclass);


--
-- Name: instrumentos id_instrumento; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos ALTER COLUMN id_instrumento SET DEFAULT nextval('public.instrumentos_id_instrumento_seq'::regclass);


--
-- Name: leq id_leq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leq ALTER COLUMN id_leq SET DEFAULT nextval('public.leq_id_leq_seq'::regclass);


--
-- Name: medicamento id_medicamento; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicamento ALTER COLUMN id_medicamento SET DEFAULT nextval('public.medicamento_id_medicamento_seq'::regclass);


--
-- Name: medico id_medico; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medico ALTER COLUMN id_medico SET DEFAULT nextval('public.medico_id_medico_seq'::regclass);


--
-- Name: motivos_cancelacion id_motivos; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motivos_cancelacion ALTER COLUMN id_motivos SET DEFAULT nextval('public.motivos_cancelacion_id_motivos_seq'::regclass);


--
-- Name: nivel_socioeconomico id_nivel; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nivel_socioeconomico ALTER COLUMN id_nivel SET DEFAULT nextval('public.nivel_socioeconomico_id_nivel_seq'::regclass);


--
-- Name: paciente id_paciente; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paciente ALTER COLUMN id_paciente SET DEFAULT nextval('public.paciente_id_paciente_seq'::regclass);


--
-- Name: prioridad_clinica id_prioridad_clinica; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prioridad_clinica ALTER COLUMN id_prioridad_clinica SET DEFAULT nextval('public.prioridad_clinica_id_prioridad_clinica_seq'::regclass);


--
-- Name: programadas id_programadas; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programadas ALTER COLUMN id_programadas SET DEFAULT nextval('public.programadas_id_programadas_seq'::regclass);


--
-- Name: quirofano id_quirofano; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quirofano ALTER COLUMN id_quirofano SET DEFAULT nextval('public.quirofano_id_quirofano_seq'::regclass);


--
-- Name: sangre id_sangre; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sangre ALTER COLUMN id_sangre SET DEFAULT nextval('public.sangre_id_sangre_seq'::regclass);


--
-- Name: seccion id_seccion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seccion ALTER COLUMN id_seccion SET DEFAULT nextval('public.seccion_id_seccion_seq'::regclass);


--
-- Name: tabulador id_tabulador; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tabulador ALTER COLUMN id_tabulador SET DEFAULT nextval('public.tabulador_id_tabulador_seq'::regclass);


--
-- Name: tecnica_cirugia id_tecnica; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tecnica_cirugia ALTER COLUMN id_tecnica SET DEFAULT nextval('public.tecnica_cirugia_id_tecnica_seq'::regclass);


--
-- Name: tipo_anestesia id_tipo_anestesia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_anestesia ALTER COLUMN id_tipo_anestesia SET DEFAULT nextval('public.tipo_anestesia_id_tipo_anestesia_seq'::regclass);


--
-- Name: tipo_cirugia id_tipo_cirugia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_cirugia ALTER COLUMN id_tipo_cirugia SET DEFAULT nextval('public.tipo_cirugia_id_tipo_cirugia_seq'::regclass);


--
-- Name: urgencia_cirugia id_urgencia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.urgencia_cirugia ALTER COLUMN id_urgencia SET DEFAULT nextval('public.urgencia_cirugia_id_urgencia_seq'::regclass);


--
-- Name: usuario id_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuario_id_usuario_seq'::regclass);


--
-- Name: vitrinas id_vitrina; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vitrinas ALTER COLUMN id_vitrina SET DEFAULT nextval('public.vitrinas_id_vitrina_seq'::regclass);


--
-- Data for Name: cirugia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cirugia (id_cirugia, descripcion_cirugia, id_especialidad, id_tecnica) FROM stdin;
2	Endoarteriectom¡a de la car¢tida	10	1
3	Cirug¡a de cataratas	8	1
4	Colecistectom¡a	9	2
5	Bypass de arteria coronaria	10	1
6	Hemorroidectom¡a	9	1
7	Histerectom¡a	1	1
8	Histeroscopia	2	1
9	Mastectom¡a	2	1
10	Prostatectom¡a	9	1
11	Amigdalectom¡a	11	1
12	Neuroendoscopia	3	1
1	APENDICECTOM¡A	9	1
\.


--
-- Data for Name: det_instrumentos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.det_instrumentos (cns_instrumento, id_instrumento, descripcion_det_instrumentos, cantidad_unidad) FROM stdin;
1	1	GASAS S/ TRAMA.	1
2	2	RI¥ONES METµLICOS 100 ML. GERMANY  88139.7	1
3	2	PINZAS ALLIS CHICAS MILTEX 16-6	2
4	2	CAMPOS SENCILLOS.	4
5	3	RI¥ON METµLICOS 500 CC GERMANY 88139.25	1
6	3	VASO DE 160 CC	1
7	3	GASAS SIN TRAMA	5
8	4	BUDIDERA CHICA CON TAPA	1
9	4	RI¥ON DE 500CC GERMANY 88-139-25	1
10	4	RI¥ON DE 250CC S/R	1
11	1	RIÑONES METÁLICOS 100 ML. GERMANY  88139.7	2
12	1	CAMPOS SENCILLOS.	7
13	1	ISOPOS 	4
14	3	PINZA FORESTER CHICA RECTA MILTEX 7-604	1
15	11	MANIVELAS C/3 PZAS S/R	1
16	11	MANIVELAS C/2 PZAS S/R	1
17	6	LEBRILLO HONDO S/R	1
18	6	VASO DE 300CC S/R	1
19	6	VASO DE 160CC S/R	1
20	7	LEBRILLO HONDO DE ACERO INOXIDABLE  S/R	1
21	7	RIÑON DE ACERO INOXIDABLE DE 500 ML\t88.139.25	1
22	7	RIÑON DE ACERO INOXIDABLE DE 100ML\t88.139.17	1
23	7	PINZAS HALSTED CURVA\tMILTEX7.4	1
24	7	PINZA KELLY RECTA \tMILTEX 7.36	1
25	7	PINZA KELLY RECTA \tMIXTEL 7.44	1
26	7	PORTA AGUJA  MAYO CHICO \tMILTEX 8.42	1
27	7	PINZA FORESTER CHICA RECTA \tMILTEX16-1700/18	1
28	7	PINZA DE DISECCIÓN  ADS0N C/D\tZEPF 6-120	1
29	7	MANGO DE BISTURI # 3\tMILTEX 4-7	1
30	8	CHAROLA DE MAYO ACERO INOXIDABLE CHICA\tS/R	1
31	8	RIÑON DE ACERO INOXIDABLE DE 100 ML\tS/R	1
32	8	MANGO DE BISTURI # 3\tMILTEX 4-7	1
33	8	PINZAS DE BACKAUS\tMILTEX 7-506	2
34	8	PINZAS DE HALSTED CURVAS\tMIKTEX 7-4	2
35	8	PINZA DE CRILLE CURVA\tMILTEX 7-44	1
36	8	PORTAAGUJA DE MAYO  HEGAR MEDIANO\tMILTEX 8-46	1
37	8	SEPARADOR DE WHITLANER CHICO\tMILTEX 11-608	1
38	8	SEPARADOR DE SENN MILLER\tMILTEX 11-76	1
39	8	PINZAS DE DISECCION C/D\tMILTEX 6-46	1
40	8	SEP DE FARABEUF\tS/R	1
41	9	CHAROLA DE MAYO ACERO INOXIDABLE CHICA\tS/R	1
42	9	RIÑON DE ACERO INOXIDABLE DE 100ML \t88.139.17	1
43	9	MANGO DE BISTURI # 3 \tZEPF06-103-00	1
44	9	PINZAS DE BABCKAUS MEDIANAS\tMILTEX7.506	2
45	9	PINZAS DE HALSTED CURVAS\tMIKTEX 7-4	2
46	9	PINZA DE CRILLE CURVA\tNMILTEX 7-44	1
47	9	PORTAAGUJA DE HEGAR CHICO\tMIKTEZ 8-42	1
48	9	SEPARADOR DE WHITLANER CHICO\tMILTEX 11-608	1
49	9	SEPARADOR DE SENN MILLER\tS/R	1
50	9	PINZA DE DISECCION C/D CHICA\tMIKTEX 6-44	2
51	9	SEP DE FARABEUT\tGERMANY 11-110	1
\.


--
-- Data for Name: det_instrumentos_leq; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.det_instrumentos_leq (cns_det_instrumentos_leq, cns_instrumento, id_leq, status) FROM stdin;
\.


--
-- Data for Name: det_programadas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.det_programadas (id_programadas, cns, id_motivo) FROM stdin;
6	33	6
7	34	4
5	37	4
10	38	3
11	39	4
8	40	3
\.


--
-- Data for Name: det_sangre_leq; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.det_sangre_leq (cns_det_sangre_leq, id_leq, id_sangre, cantidad, status, comentario) FROM stdin;
\.


--
-- Data for Name: det_update; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.det_update (id_programadas, cns, fecha_cirugia, hora_cirugia) FROM stdin;
\.


--
-- Data for Name: especialidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.especialidad (id_especialidad, descripcion_especialidad, id_quirofano) FROM stdin;
1	GINECOLOGIA	1
2	ONCOLOGIA	1
3	NEUROLOGIA	1
4	CARDIOLOGIA	1
5	TRAUMATOLOGIA	2
6	NEFROLOGIA	3
7	UROLOGIA	2
8	OFTALMOLOGIA	3
10	DINAMICA SANGUINEA	5
11	ANESTESIOLOGO	5
9	MEDICINA INTERNA	1
13	 CARDIOLOGIA INTERVENSIONISTA	1
14	MEDICO CIRUJANO	1
\.


--
-- Data for Name: estados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estados (id_estado, clave, descripcion_estado, id_nacionalidades, abrev, activo) FROM stdin;
1	01	Aguascalientes	1	Ags.	t
2	02	Baja California	1	BC	t
3	03	Baja California Sur	1	BCS	t
4	04	Campeche	1	Camp.	t
5	05	Coahuila de Zaragoza	1	Coah.	t
6	06	Colima	1	Col.	t
7	07	Chiapas	1	Chis.	t
8	08	Chihuahua	1	Chih.	t
9	09	Ciudad de M‚xico	1	CDMX	t
10	10	Durango	1	Dgo.	t
11	11	Guanajuato	1	Gto.	t
12	12	Guerrero	1	Gro.	t
13	13	Hidalgo	1	Hgo.	t
14	14	Jalisco	1	Jal.	t
15	15	M‚xico	1	Mex.	t
16	16	Michoac n de Ocampo	1	Mich.	t
17	17	Morelos	1	Mor.	t
18	18	Nayarit	1	Nay.	t
19	19	Nuevo Le¢n	1	NL	t
20	20	Oaxaca	1	Oax.	t
21	21	Puebla	1	Pue.	t
22	22	Quer‚taro	1	Qro.	t
23	23	Quintana Roo	1	Q. Roo	t
24	24	San Luis Potos¡	1	SLP	t
25	25	Sinaloa	1	Sin.	t
26	26	Sonora	1	Son.	t
27	27	Tabasco	1	Tab.	t
28	28	Tamaulipas	1	Tamps.	t
29	29	Tlaxcala	1	Tlax.	t
30	30	Veracruz de Ignacio de la Llave	1	Ver.	t
31	31	Yucat n	1	Yuc.	t
32	32	Zacatecas	1	Zac.	t
\.


--
-- Data for Name: institucion_procedencia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.institucion_procedencia (id_institucion, descripcion_institucion, rfc, domicilio_fiscal) FROM stdin;
3	PEMEX	RFC-DE-PEMEX	DOM-FISCAL-DE-PEMEX
2	IMSS	RFC-DE-IMMS	DOM-FISCAL-DE-IMMS
1	ISSSTE	RFC-DE-ISSSTE	DOM-FISCAL-DE-ISSSTE
6	OTRAS	RFC-DE-OTRAS	DOM-FISCAL-DE-OTRAS
4	SEGURO POPULAR	RFC-DE-SEGURO POPULAR	DOM-FISCAL-DE-SEGURO POPULAR
\.


--
-- Data for Name: instrumentos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrumentos (id_instrumento, descripcion_instrumento, cantida_total, id_vitrina, id_seccion) FROM stdin;
1	EQUIPOS LAVADO MECANICO C/2 PIEZAS	2	1	1
2	INSTALACIàN DE SONDA FOLEY  C/3 PIEZAS	7	1	1
3	ASEOS COMPLETOS C/3 PIEZAS 	7	1	2
4	BUDINERAS CON TAPA	3	1	2
5	EQUIPO DE BLOQUEO C/3	0	5	1
6	LEBRILLOS HONDOS 	0	1	3
7	SET DE HEMODINAMIA C/10 PZAS	0	1	4
8	SET DE MARCAPASO DEFINITIVO #1 C/14 PZAS	0	1	4
9	SET DE MARCAPASO DEFINITIVO #2 C/14 PZAS	0	1	4
10	VASO DE 300 ML	0	1	3
11	MANIVELAS CON 2 PIEZAS 	0	1	3
12	PINZAS ALLIS MEDIANAS C/5 PIEZAS	0	2	1
13	PINZAS ALLIS LARGAS C/5 PIEZAS	0	2	1
14	PINZAS ADAIR C/4 PIEZAS	0	2	1
15	PINZA FORESTER  CURVA LARGA 	0	2	1
16	DE PINZAS FORESTER RECTA LARGA	0	2	1
17	PINZAS BACKO LARGA C/2 PIEZAS	0	2	1
18	PINZAS ROCHESTER OSHNER MEDIANAS C/3 PIEZAS	0	2	1
19	PINZAS ROCHESTER  PEAN MEDIANAS C/3 PIEZAS	0	2	1
20	PINZAS LOWER  LARGAS C/2 PIEZAS	0	2	1
21	PINZAS LOWER  MEDIANAS C/5 PIEZAS	0	2	1
22	PINZAS MIXTER LARGAS C/5 PIEZAS	0	2	1
23	PINZAS SAWTELL MEDIANAS C/3 PIEZAS	0	2	1
24	PORTA AGUJA FINOCHETO	0	2	1
25	PORTA AGUJA DE  MAYO HEGAR LARGO 	0	2	1
26	PORTA AGUJA DE HEGAR MEDIANO  	0	2	1
27	PORTA AGUJA DE HEGAR CHICO	0	2	1
28	PORTA AGUJA VASCULAR LARGO 	0	2	1
29	PORTA AGUJA VASCULAR MEDIANO	0	2	1
30	PORTA AGUJA  VASCULAR CHICO 	0	2	1
31	PINZAS HALSTED CURVAS C/10 PIEZAS	0	2	1
32	PINZAS HALSTED RECTAS C/10	0	2	1
33	PINZAS KELLI CURVAS CON 5 PIEZAS	0	2	1
34	PINZAS KELLI RECTAS CON 5 PIEZAS	0	2	1
35	PINZAS BACKAUS PEDIATRICAS C/5 PIEZAS	0	2	1
36	PINZAS BACKAUS MEDIANAS C/5 PIEZAS	0	2	1
37	PINZAS COCHER CURVA  C/5 PIEZAS	0	2	1
38	PINZAS COCHER RECTA  C/3 PIEZAS	0	2	1
39	PINZA CLAMP INTESTINAL	0	2	1
40	PINZA PARA BIOPSIA PARA PÓLIPO NASAL 	0	2	1
41	PINZAS DISECCION ADSON C/ D Y S/D C/2 PIEZAS	0	2	2
42	PINZA DE DISECCIÓN MARTI C/2 PIEZAS	0	2	2
43	PINZAS DE DISECCIÓN S/D Y C/D CHICAS C/2 PIEZAS	0	2	2
44	PINZA DE DISECCIÓN MEDIANA S/D C/1 C/U	0	2	2
45	PINZA DE DISECCIÓN LARGA S/D C/1 C/U	0	2	2
46	PINZA DE DISECCIÓN EXTRA LARGA S/D C/1 C/U	0	2	2
47	PINZA DE DISECCIÓN LARGA S/D Y C/D C/2 C/U	0	2	2
48	PINZAS POOTS SMTIH S/D Y C/D  MEDIANAS C/2 C/U	0	2	2
49	DISECCIÓN POOTS SMITH S/D LARGA C/1 PEZA	0	2	2
50	PINZA DISECCIÓN BAYONETA MEDIANA	0	2	2
51	PINZAS DE DISECCION VASCULAR MEDIANA C/1 PIEZA	0	2	2
52	PINZAS DE DISECCION VASCULAR LARGA C/1 PIEZA	0	2	2
53	MANGO DE BISTURY 4L 	0	2	2
54	MANGO DE BISTURY 3L 	0	2	2
55	MANGO DE BISTURY NO. 7	0	2	2
56	MANGO DE BISTURY NO. 4	0	2	2
57	MANGO DE BISTURY 3	0	2	2
58	CANULAS DE FRAZIER NO. 12 	0	2	2
59	CANULA DE FRAZIER NO. 11	0	2	2
60	CANULA DE FRAZIER NO. 10	0	2	2
61	CÁNULA DE POOL	0	2	2
62	CANULAS YANKAUER	0	2	2
63	TROCAR N°12	0	2	2
\.


--
-- Data for Name: leq; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leq (id_leq, fecha_solicitud, id_tipo_anestesia, id_institucion, id_prioridad_clinica, id_tipo_cirugia, id_paciente, id_medico, id_cirugia, fecha_cirugia, hora_cirugia, id_anestesiologo, id_quirofano, radiologia, biopsia, status, tipo_leq, diagnostico, folio, pedido_sangre) FROM stdin;
66	2024-03-15	1	1	1	1	1	12	5	2024-11-28	10:00:00	13	3	1	1	1	1		444	3
67	2024-03-15	2	2	2	2	3	12	12	2024-11-15	10:00:00	13	4	1	1	1	1		445	2
\.


--
-- Data for Name: localidades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.localidades (id_localidad, id_municipio, clave, descripcion_localidad, latitud, longitud, altitud, carta, ambito, poblacion, masculino, femenino, viviendas, lat, lng, activo) FROM stdin;
34053	81	0001	Acacoyagua	152027.475	0924028.622	0081	D15B31	U	7515	3664	3851	1808	15.3409653	-92.6746172	t
34054	81	0002	Los Amates	152050.067	0924139.051	0058	D15B31	R	527	282	245	137	15.3472408	-92.6941808	t
34055	81	0003	Arvin	151922.103	0924059.464	0053	D15B31	R	27	15	12	7	15.3228064	-92.6831844	t
34056	81	0006	Los Cacaos	152321.885	0923921.994	0420	D15B32	R	845	415	430	174	15.3894125	-92.6561094	t
34057	81	0007	El Casta¤o	152010.350	0924248.990	0050	D15B31	R	395	188	207	88	15.3362083	-92.7136083	t
34058	81	0009	Constituci¢n	152325.757	0924432.281	0193	D15B31	R	444	236	208	86	15.3904881	-92.7423003	t
34059	81	0010	Costa Rica	152744.198	0924135.342	1032	D15B31	R	6	0	0	1	15.4622772	-92.6931506	t
34060	81	0012	Las Golondrinas	152556.865	0923914.927	0861	D15B32	R	358	191	167	77	15.4324625	-92.6541464	t
34061	81	0014	Hidalgo	152052.243	0924436.275	0037	D15B31	R	1209	593	616	302	15.3478453	-92.7434097	t
34062	81	0015	Huisisil Uno	152257.463	0924321.467	0079	D15B31	R	71	36	35	15	15.3826286	-92.7226297	t
34063	81	0017	Jalapa	152116.316	0924053.274	0073	D15B31	R	849	435	414	186	15.3545322	-92.6814650	t
34064	81	0019	Magnolia	152355.694	0923906.868	0470	D15B32	R	110	54	56	21	15.3988039	-92.6519078	t
34065	81	0020	Las Nubes	152329.458	0923726.261	0903	D15B32	R	0	0	0	0	15.3915161	-92.6239614	t
34066	81	0021	Nueva Libertad	152425.009	0924219.620	0248	D15B31	R	801	425	376	161	15.4069469	-92.7054500	t
34067	81	0023	Playa In‚s Secci¢n Uno	151953.890	0923929.250	0081	D15B32	R	0	0	0	0	15.3316361	-92.6581250	t
34068	81	0024	Emiliano Zapata (Puerto Arturo)	152412.968	0924104.395	0369	D15B31	R	9	0	0	2	15.4036022	-92.6845542	t
34069	81	0025	Rancho Bonito	152431.244	0923940.109	0545	D15B32	R	0	0	0	0	15.4086789	-92.6611414	t
34070	81	0026	Rosario Zacatonal	152719.208	0923750.537	0979	D15B32	R	127	72	55	27	15.4553356	-92.6307047	t
34071	81	0027	Buena Voluntad	152042.936	0924124.483	0060	D15B31	R	114	66	48	27	15.3452600	-92.6901342	t
34072	81	0028	Cintalapa	152041.663	0924112.091	0065	D15B31	R	1	0	0	1	15.3449064	-92.6866919	t
34073	81	0030	San Carlos	152255.247	0924049.261	0150	D15B31	R	4	0	0	1	15.3820131	-92.6803503	t
34074	81	0031	San Jos‚	152344.497	0923940.270	0399	D15B32	R	0	0	0	0	15.3956936	-92.6611861	t
34075	81	0033	El éltimo Jal¢n	152303.904	0924348.398	0180	D15B31	R	1	0	0	1	15.3844178	-92.7301106	t
34076	81	0034	Los Jazmines Dos	152136.858	0923925.949	0119	D15B32	R	7	0	0	2	15.3602383	-92.6572081	t
34077	81	0036	El Tajuko	152135.359	0923959.865	0101	D15B32	R	7	0	0	2	15.3598219	-92.6666292	t
34078	81	0037	Tizapa	152157.099	0923836.202	0139	D15B32	R	0	0	0	0	15.3658608	-92.6433894	t
34079	81	0038	El Tumbador	152015.364	0924401.120	0024	D15B31	R	127	60	67	29	15.3376011	-92.7336444	t
34080	81	0039	La Violeta	152418.954	0924319.395	0324	D15B31	R	98	57	41	20	15.4052650	-92.7220542	t
34081	81	0040	Palestina	152621.735	0923901.983	1017	D15B32	R	1	0	0	1	15.4393708	-92.6505508	t
34082	81	0045	Buenavista	152759.783	0923940.747	1659	D15B32	R	40	19	21	8	15.4666064	-92.6613186	t
34083	81	0047	Laguna Arenal	152746.953	0924127.903	1072	D15B31	R	39	17	22	7	15.4630425	-92.6910842	t
34084	81	0048	Caballo Blanco	152729.816	0924350.399	1117	D15B31	R	36	18	18	6	15.4582822	-92.7306664	t
34085	81	0050	San Antonio	152501.177	0924318.669	0410	D15B31	R	7	0	0	1	15.4169936	-92.7218525	t
34086	81	0052	El Pensamiento	152659.832	0924445.048	0619	D15B31	R	0	0	0	0	15.4499533	-92.7458467	t
34087	81	0058	El Encuentro	152255.349	0924040.122	0137	D15B31	R	14	0	0	2	15.3820414	-92.6778117	t
34088	81	0060	La Vieja Libertad	152531.133	0924126.821	0783	D15B31	R	22	13	9	5	15.4253147	-92.6907836	t
34089	81	0061	San Vicente Joval	152333.082	0924023.419	0268	D15B31	R	9	0	0	2	15.3925228	-92.6731719	t
34090	81	0062	Nueva Reforma	152608.525	0924459.651	0484	D15B31	R	347	192	155	61	15.4357014	-92.7499031	t
34091	81	0063	Monte Video	152449.125	0924424.343	0543	D15B31	R	0	0	0	0	15.4136458	-92.7400953	t
34092	81	0064	Mar¡a Esther Zuno de Echeverr¡a	152422.395	0924341.878	0384	D15B31	R	354	175	179	71	15.4062208	-92.7282994	t
34093	81	0067	San Marcos	151954.337	0924120.867	0061	D15B31	R	4	0	0	1	15.3317603	-92.6891297	t
34094	81	0068	Bolivia	152238.451	0923918.530	0158	D15B32	R	0	0	0	0	15.3773475	-92.6551472	t
34095	81	0071	San Isidro	151948.920	0924059.814	0060	D15B31	R	7	0	0	2	15.3302556	-92.6832817	t
34096	81	0073	Betania	152202.702	0924404.312	0042	D15B31	R	6	0	0	2	15.3674172	-92.7345311	t
34097	81	0079	Las Cruces	152745.916	0923914.231	1364	D15B32	R	58	26	32	10	15.4627544	-92.6539531	t
34098	81	0080	Morioka	152208.945	0924002.495	0099	D15B31	R	1	0	0	1	15.3691514	-92.6673597	t
34099	81	0083	La Fortuna	152439.277	0923931.435	0646	D15B32	R	33	19	14	5	15.4109103	-92.6587319	t
34100	81	0085	Soledad	152429.515	0923956.785	0430	D15B32	R	1	0	0	1	15.4081986	-92.6657736	t
34101	81	0086	Palomeque	152438.988	0923857.012	0816	D15B32	R	0	0	0	0	15.4108300	-92.6491700	t
34102	81	0087	Buenos Aires	152542.145	0924048.844	0608	D15B31	R	49	27	22	8	15.4283736	-92.6802344	t
34103	81	0088	Sat‚lite Morelia	152308.940	0923955.588	0293	D15B32	R	138	72	66	29	15.3858167	-92.6654411	t
34104	81	0089	Santa Rosa	152446.294	0924422.639	0544	D15B31	R	1	0	0	1	15.4128594	-92.7396219	t
34105	81	0090	Jard¡n de Oro	152539.480	0924441.831	0443	D15B31	R	0	0	0	0	15.4276333	-92.7449531	t
34106	81	0091	Lagunas	152901.477	0924036.511	1777	D15B31	R	93	58	35	15	15.4837436	-92.6768086	t
34107	81	0092	La Patria	152512.896	0924324.684	0434	D15B31	R	2	0	0	1	15.4202489	-92.7235233	t
34108	81	0094	Diez de Abril (Texcoco)	152708.390	0924429.230	0722	D15B31	R	52	23	29	13	15.4523306	-92.7414528	t
34109	81	0101	Tres Hermanos	152143.112	0924330.689	0048	D15B31	R	2	0	0	1	15.3619756	-92.7251914	t
34110	81	0106	Buenos Aires	152332.965	0924341.445	0239	D15B31	R	7	0	0	2	15.3924903	-92.7281792	t
34111	81	0108	El Aguacate	152152.590	0924317.750	0054	D15B31	R	62	33	29	12	15.3646083	-92.7215972	t
34112	81	0109	Huisisil Dos	152326.816	0924322.328	0193	D15B31	R	60	33	27	13	15.3907822	-92.7228689	t
34113	81	0110	El Retiro	152247.294	0924338.678	0069	D15B31	R	5	0	0	1	15.3798039	-92.7274106	t
34114	81	0111	Las Delicias	152207.240	0924413.519	0043	D15B31	R	17	5	12	5	15.3686778	-92.7370886	t
34115	81	0113	Flor del Carmen Uno	152130.016	0924240.139	0078	D15B31	R	115	59	56	26	15.3583378	-92.7111497	t
34116	81	0114	Reforma (Parada Bonanza)	152153.598	0924348.173	0057	D15B31	R	2	0	0	1	15.3648883	-92.7300481	t
34117	81	0115	Delicias	152226.142	0924356.817	0049	D15B31	R	2	0	0	1	15.3739283	-92.7324492	t
34118	81	0116	San Pedro	152035.166	0923942.508	0089	D15B32	R	96	48	48	25	15.3431017	-92.6618078	t
34119	81	0118	San Marcos Uno	152103.574	0924142.678	0066	D15B31	R	116	57	59	21	15.3509928	-92.6951883	t
34120	81	0119	Callej¢n del Para¡so	152123.206	0924314.742	0050	D15B31	R	63	27	36	16	15.3564461	-92.7207617	t
34121	81	0122	Luis Donaldo Colosio Murrieta	152140.248	0923922.920	0121	D15B32	R	12	6	6	3	15.3611800	-92.6563667	t
34122	81	0123	Las Cadenas	152738.816	0923909.012	1386	D15B32	R	8	0	0	2	15.4607822	-92.6525033	t
34123	81	0124	V¡ctor Manuel Castillo (Espa¤a)	152511.631	0924348.352	0374	D15B31	R	4	0	0	1	15.4198975	-92.7300978	t
34124	81	0125	Madre Vieja	152538.752	0924534.347	0708	D15B31	R	0	0	0	0	15.4274311	-92.7595408	t
34125	81	0127	Nuevo Cintalapa Dos (Berl¡n)	152617.681	0924534.759	0594	D15B31	R	23	13	10	5	15.4382447	-92.7596553	t
34126	81	0129	Candelaria	152656.583	0924431.600	0643	D15B31	R	0	0	0	0	15.4490508	-92.7421111	t
34127	81	0130	Los Andes de Zapata	152245.601	0923755.691	0403	D15B32	R	118	59	59	27	15.3793336	-92.6321364	t
34128	81	0131	Las Brisas	152043.112	0924114.174	0065	D15B31	R	73	38	35	17	15.3453089	-92.6872706	t
34129	81	0132	Nueva Jalapa	152054.378	0924114.237	0064	D15B31	R	64	31	33	15	15.3484383	-92.6872881	t
34130	81	0134	Las Limas	152042.739	0924214.233	0080	D15B31	R	97	48	49	20	15.3452053	-92.7039536	t
34131	81	0140	El Camionero	152146.089	0924328.680	0049	D15B31	R	7	0	0	2	15.3628025	-92.7246333	t
34132	81	0141	Monte de Oro	152503.730	0924407.582	0485	D15B31	R	0	0	0	0	15.4177028	-92.7354394	t
34133	81	0142	La Primavera	152220.582	0924305.375	0062	D15B31	R	6	0	0	1	15.3723839	-92.7181597	t
34134	81	0144	El Delirio (El Recuerdo)	152318.339	0924303.319	0180	D15B31	R	4	0	0	1	15.3884275	-92.7175886	t
34135	81	0146	El Porvenir	152331.204	0924128.212	0201	D15B31	R	0	0	0	0	15.3920011	-92.6911700	t
34136	81	0147	Las Brisas	152233.914	0924310.606	0077	D15B31	R	3	0	0	1	15.3760872	-92.7196128	t
34137	81	0148	Renacimiento	151939.215	0924109.028	0057	D15B31	R	0	0	0	0	15.3275597	-92.6858411	t
34138	81	0151	Chicol	152150.246	0924035.669	0081	D15B31	R	2	0	0	1	15.3639572	-92.6765747	t
34139	81	0152	Desv¡o el Pataste	152219.741	0924457.289	0040	D15B31	R	17	7	10	3	15.3721503	-92.7492469	t
34140	81	0153	El Arenal	152250.200	0924145.968	0108	D15B31	R	0	0	0	0	15.3806111	-92.6961022	t
34141	81	0154	El Desenga¤o	152146.011	0924255.478	0056	D15B31	R	0	0	0	0	15.3627808	-92.7154106	t
34142	81	0156	Los Cocos	152122.830	0923939.248	0106	D15B32	R	0	0	0	0	15.3563417	-92.6609022	t
34143	81	0159	Quince de Septiembre	152139.536	0923917.441	0122	D15B32	R	167	78	89	34	15.3609822	-92.6548447	t
34144	81	0161	La Esperanza	152214.474	0924252.909	0064	D15B31	R	4	0	0	1	15.3706872	-92.7146969	t
34145	81	0163	El Regalo de Dios	152137.496	0923821.532	0160	D15B32	R	5	0	0	1	15.3604156	-92.6393144	t
34146	81	0164	Las Tomas	152215.588	0924334.193	0052	D15B31	R	14	6	8	4	15.3709967	-92.7261647	t
34147	81	0165	La Argentina	152204.836	0924429.627	0040	D15B31	R	78	41	37	18	15.3680100	-92.7415631	t
34148	81	0166	Monterrey	152342.230	0924145.087	0191	D15B31	R	30	17	13	5	15.3950639	-92.6958575	t
34149	81	0167	La Argentina	152454.370	0924137.347	0597	D15B31	R	3	0	0	1	15.4151028	-92.6937075	t
34150	81	0168	Bethel	152320.331	0924413.738	0173	D15B31	R	1	0	0	1	15.3889808	-92.7371494	t
34151	81	0169	Nueva Alianza	152507.751	0924314.643	0406	D15B31	R	6	0	0	1	15.4188197	-92.7207342	t
34152	81	0170	Buenavista	152446.378	0924155.668	0429	D15B31	R	0	0	0	0	15.4128828	-92.6987967	t
34153	81	0171	Los Cacaos	152508.004	0924006.996	0429	D15B31	R	0	0	0	0	15.4188900	-92.6686100	t
34154	81	0172	Las Chicharras	152644.988	0924429.004	0710	D15B31	R	0	0	0	0	15.4458300	-92.7413900	t
34155	81	0174	Las Dalias	152204.064	0924303.780	0062	D15B31	R	11	0	0	2	15.3677956	-92.7177167	t
34156	81	0175	Flor del Carmen Dos	152257.388	0924151.737	0110	D15B31	R	0	0	0	0	15.3826078	-92.6977047	t
34157	81	0176	Galeana	152532.013	0923831.520	0843	D15B32	R	0	0	0	0	15.4255592	-92.6420889	t
34158	81	0177	La Gloria	152524.636	0923849.440	0698	D15B32	R	1	0	0	1	15.4235100	-92.6470667	t
34159	81	0178	La Gloria	152120.382	0924013.697	0100	D15B31	R	0	0	0	0	15.3556617	-92.6704714	t
34160	81	0180	La Hermosura	152339.008	0924150.553	0208	D15B31	R	2	0	0	1	15.3941689	-92.6973758	t
34161	81	0181	La Lomita	152246.946	0924227.601	0090	D15B31	R	9	6	3	3	15.3797072	-92.7076669	t
34162	81	0182	Los Mangos	152202.986	0924331.907	0050	D15B31	R	10	0	0	2	15.3674961	-92.7255297	t
34163	81	0183	El Nopal (Parada el Mirador)	152216.327	0924434.179	0039	D15B31	R	3	0	0	1	15.3712019	-92.7428275	t
34164	81	0184	Nopales	152256.224	0924435.144	0088	D15B31	R	0	0	0	0	15.3822844	-92.7430956	t
34165	81	0185	La Nueva Esperanza	152255.826	0924228.878	0095	D15B31	R	32	20	12	9	15.3821739	-92.7080217	t
34166	81	0186	Santuario	152118.322	0924015.416	0098	D15B31	R	0	0	0	0	15.3550894	-92.6709489	t
34167	81	0187	Playa In‚s Secci¢n Dos	152014.930	0923952.390	0080	D15B32	R	21	9	12	5	15.3374806	-92.6645528	t
34168	81	0188	Rancho Escondido	152234.153	0924443.670	0037	D15B31	R	4	0	0	1	15.3761536	-92.7454639	t
34169	81	0189	El Recuerdo	152132.605	0923930.511	0114	D15B32	R	2	0	0	1	15.3590569	-92.6584753	t
34170	81	0190	Sakura	152212.088	0923922.741	0109	D15B32	R	3	0	0	1	15.3700244	-92.6563169	t
34171	81	0191	San Enrique	152141.757	0923826.560	0150	D15B32	R	8	0	0	1	15.3615992	-92.6407111	t
34172	81	0192	San Ger¢nimo	152816.739	0924045.659	1542	D15B31	R	0	0	0	0	15.4713164	-92.6793497	t
34173	81	0193	Alonso Morales	152237.886	0924450.494	0035	D15B31	R	3	0	0	1	15.3771906	-92.7473594	t
34174	81	0194	Benedicto Gonz lez	152520.134	0924347.952	0370	D15B31	R	0	0	0	0	15.4222594	-92.7299867	t
34175	81	0195	Edmundo M‚ndez	152520.823	0924353.635	0382	D15B31	R	0	0	0	0	15.4224508	-92.7315653	t
34176	81	0196	Juan Aguilar	152742.158	0924242.293	1420	D15B31	R	0	0	0	0	15.4617106	-92.7117481	t
34177	81	0197	Julia Tom s Nolasco	152518.540	0923938.686	0594	D15B32	R	0	0	0	0	15.4218167	-92.6607461	t
34178	81	0198	Luis Dur n P‚rez	152258.443	0924429.362	0092	D15B31	R	0	0	0	0	15.3829008	-92.7414894	t
34179	81	0199	La Vaca	152208.456	0924320.007	0059	D15B31	R	3	0	0	2	15.3690156	-92.7222242	t
34180	81	0200	San Benito	152008.686	0924004.607	0069	D15B31	R	5	0	0	1	15.3357461	-92.6679464	t
34181	81	0202	La Cadena	152206.517	0924148.614	0118	D15B31	R	135	72	63	27	15.3684769	-92.6968372	t
34182	81	0203	Viejo Soconusco	152225.746	0924057.444	0155	D15B31	R	32	18	14	10	15.3738183	-92.6826233	t
34183	81	0204	Santa Anita	152122.361	0923956.900	0098	D15B32	R	6	0	0	1	15.3562114	-92.6658056	t
34184	81	0205	Solo Dios	152119.235	0924014.130	0100	D15B31	R	3	0	0	1	15.3553431	-92.6705917	t
34185	81	0206	Magnolia	152232.968	0923951.329	0123	D15B32	R	26	13	13	6	15.3758244	-92.6642581	t
34186	81	0207	Santa Anita	152118.873	0923959.402	0103	D15B32	R	158	83	75	29	15.3552425	-92.6665006	t
34187	81	0208	Las Palmas	152529.535	0924505.957	0609	D15B31	R	10	0	0	1	15.4248708	-92.7516547	t
34188	81	0209	El Tesoro	152527.180	0924426.450	0427	D15B31	R	7	0	0	1	15.4242167	-92.7406806	t
34189	81	0210	El Pedregal	152521.388	0924414.382	0396	D15B31	R	2	0	0	1	15.4226078	-92.7373283	t
34190	81	0211	Ninguno [Ram¢n Mart¡nez]	152134.379	0923938.529	0098	D15B32	R	0	0	0	0	15.3595497	-92.6607025	t
34191	81	0212	Rancho Escondido	152245.540	0924218.720	0085	D15B31	R	0	0	0	0	15.3793167	-92.7052000	t
34192	81	0213	Las Truchas	152231.699	0924236.856	0082	D15B31	R	8	0	0	2	15.3754719	-92.7102378	t
34193	81	0214	El Clavel	152211.013	0924314.849	0060	D15B31	R	3	0	0	1	15.3697258	-92.7207914	t
34194	81	0215	El Naranjo	152214.056	0924301.293	0063	D15B31	R	5	0	0	1	15.3705711	-92.7170258	t
34195	81	0216	San Gabriel	152151.441	0924252.160	0057	D15B31	R	10	0	0	2	15.3642892	-92.7144889	t
34196	81	0217	El Rosario	152239.864	0924349.103	0061	D15B31	R	3	0	0	1	15.3777400	-92.7303064	t
34197	81	0218	3 Garc¡as	152242.211	0924339.741	0077	D15B31	R	8	0	0	1	15.3783919	-92.7277058	t
34198	81	0219	El Delirio	152236.029	0924335.649	0072	D15B31	R	12	3	9	3	15.3766747	-92.7265692	t
34199	81	0220	3 Hermanos	152219.978	0924342.278	0050	D15B31	R	10	0	0	1	15.3722161	-92.7284106	t
34200	82	0001	Acala	163306.025	0924827.030	0403	E15D61	U	13889	6900	6989	3457	16.5516736	-92.8075083	t
34201	82	0002	Adolfo L¢pez Mateos	163630.534	0925335.210	0420	E15D61	R	507	273	234	118	16.6084817	-92.8931139	t
34202	82	0011	Agua Dulce (Buenos Aires)	163029.367	0925103.739	0501	E15D61	R	40	24	16	8	16.5081575	-92.8510386	t
34203	82	0026	T¡o Cha¡n	163457.953	0925214.072	0408	E15D61	R	4	0	0	1	16.5827647	-92.8705756	t
34204	82	0030	Nandamuju	163530.164	0925247.458	0401	E15D61	R	2	0	0	1	16.5917122	-92.8798494	t
34205	82	0035	Plan del Higo	163406.283	0924932.014	0506	E15D61	R	20	12	8	11	16.5684119	-92.8255594	t
34206	82	0045	El Recreo	163430.769	0925125.574	0404	E15D61	R	28	15	13	7	16.5752136	-92.8571039	t
34207	82	0048	El Paquesch	163324.267	0924936.136	0403	E15D61	R	202	90	112	44	16.5567408	-92.8267044	t
34208	82	0049	Rizo de Oro	163036.965	0925302.186	0476	E15D61	R	241	112	129	63	16.5102681	-92.8839406	t
34209	82	0050	El Rosarito	163242.959	0924743.835	0420	E15D61	R	215	116	99	48	16.5452664	-92.7955097	t
34210	82	0060	San Jos‚ Nichi	163607.992	0924426.016	0521	E15D61	R	0	0	0	0	16.6022200	-92.7405600	t
34211	82	0063	San Pedro Nichi	163432.645	0924706.590	0479	E15D61	R	72	38	34	14	16.5757347	-92.7851639	t
34212	82	0064	Santa Elena	163027.785	0925316.879	0478	E15D61	R	0	0	0	0	16.5077181	-92.8880219	t
34213	82	0070	Uni¢n Buenavista	162912.356	0924909.881	0538	E15D71	R	1847	916	931	458	16.4867656	-92.8194114	t
34214	82	0102	Lagartero	163321.211	0924646.487	0413	E15D61	R	32	18	14	4	16.5558919	-92.7795797	t
34215	82	0104	La Primavera	162646.802	0924606.418	0420	E15D71	R	0	0	0	0	16.4463339	-92.7684494	t
34216	82	0105	Puerto M‚xico	163246.355	0924848.353	0439	E15D61	R	9	0	0	2	16.5462097	-92.8134314	t
34217	82	0106	R¡o Lim¢n	163337.032	0925003.390	0400	E15D61	R	0	0	0	0	16.5602867	-92.8342750	t
34218	82	0107	San Antonio (Agua Clara)	163136.540	0924701.671	0412	E15D61	R	73	41	32	15	16.5268167	-92.7837975	t
34219	82	0109	San Juan	163012.299	0924513.343	0412	E15D61	R	0	0	0	0	16.5034164	-92.7537064	t
34220	82	0110	San Luis el Bajo	162834.789	0924502.900	0413	E15D71	R	0	0	0	0	16.4763303	-92.7508056	t
34221	82	0111	San Luis el Alto	162852.164	0924439.481	0420	E15D71	R	9	0	0	2	16.4811567	-92.7443003	t
34222	82	0112	Lucio Blanco	162742.104	0924514.193	0419	E15D71	R	5	0	0	1	16.4616956	-92.7539425	t
34223	82	0113	Santa Cruz	163111.798	0924603.467	0440	E15D61	R	7	0	0	1	16.5199439	-92.7676297	t
34224	82	0115	Tierra Blanca	163014.948	0925146.315	0496	E15D61	R	5	0	0	2	16.5041522	-92.8628653	t
34225	82	0116	Tierra Brava	163059.909	0925211.192	0491	E15D61	R	9	0	0	2	16.5166414	-92.8697756	t
34226	82	0117	El Calero	163031.389	0924547.930	0427	E15D61	R	1	0	0	1	16.5087192	-92.7633139	t
34227	82	0118	El Triunfo de Tila	163610.426	0925338.434	0402	E15D61	R	1	0	0	1	16.6028961	-92.8940094	t
34228	82	0154	Los Laureles	163637.258	0925316.769	0428	E15D61	R	5	0	0	1	16.6103494	-92.8879914	t
34229	82	0157	Cupijamo	163303.586	0924706.198	0410	E15D61	R	6	0	0	1	16.5509961	-92.7850550	t
34230	82	0161	El Chorreadero	163032.256	0924832.489	0445	E15D61	R	0	0	0	0	16.5089600	-92.8090247	t
34231	82	0171	Los µngeles	162918.911	0924520.062	0418	E15D71	R	1	0	0	1	16.4885864	-92.7555728	t
34232	82	0172	La Herradura	162944.696	0924531.448	0426	E15D71	R	11	6	5	3	16.4957489	-92.7587356	t
34233	82	0176	El Amatal	162717.171	0924600.251	0410	E15D71	R	4	0	0	2	16.4547697	-92.7667364	t
34234	82	0177	Nanchi Verde	162753.367	0924744.679	0501	E15D71	R	0	0	0	0	16.4648242	-92.7957442	t
34235	82	0178	La Aurora Nueva	162705.259	0924804.284	0507	E15D71	R	5	0	0	1	16.4514608	-92.8011900	t
34236	82	0179	Santo Tom s	162636.502	0924711.098	0500	E15D71	R	2	0	0	1	16.4434728	-92.7864161	t
34237	82	0191	La Angostura (El Porvenir)	162454.331	0924602.283	0484	E15D71	R	13	0	0	2	16.4150919	-92.7673008	t
34238	82	0193	La Angostura	162506.540	0924547.867	0460	E15D71	R	0	0	0	0	16.4184833	-92.7632964	t
34239	82	0194	San Jos‚ de Jes£s	162642.115	0924846.622	0562	E15D71	R	90	50	40	22	16.4450319	-92.8129506	t
34240	82	0200	Nandayapa	163318.719	0924633.749	0402	E15D61	R	17	0	0	2	16.5551997	-92.7760414	t
34241	82	0201	El Chilar	163425.420	0924811.542	0479	E15D61	R	92	51	41	20	16.5737278	-92.8032061	t
34242	82	0203	La Esperanza	163416.270	0925057.880	0405	E15D61	R	1	0	0	1	16.5711861	-92.8494111	t
34243	82	0205	Las Margaritas	163502.710	0925225.090	0413	E15D61	R	2	0	0	1	16.5840861	-92.8736361	t
34244	82	0206	Los µngeles	163521.770	0925239.530	0404	E15D61	R	24	10	14	5	16.5893806	-92.8776472	t
34245	82	0207	El Rosario	163526.575	0925243.485	0405	E15D61	R	9	6	3	3	16.5907153	-92.8787458	t
34246	82	0209	Las Mercedes	163729.917	0925432.442	0437	E15D61	R	7	3	4	3	16.6249769	-92.9090117	t
34247	82	0210	Las Minas	163852.054	0925153.281	0761	E15D61	R	59	30	29	12	16.6477928	-92.8648003	t
34248	82	0212	Nandayapa	163817.178	0925450.358	0428	E15D61	R	23	11	12	6	16.6381050	-92.9139883	t
34249	82	0216	Las Casitas	162949.398	0924845.857	0497	E15D71	R	8	0	0	2	16.4970550	-92.8127381	t
34250	82	0221	Jes£s Carrizito	162907.393	0924724.035	0519	E15D71	R	2	0	0	1	16.4853869	-92.7900097	t
34251	82	0223	San Bernardo	162633.524	0924646.880	0462	E15D71	R	0	0	0	0	16.4426456	-92.7796889	t
34252	82	0224	San Joaqu¡n	162628.520	0924623.194	0464	E15D71	R	2	0	0	1	16.4412556	-92.7731094	t
34253	82	0225	San Fernando	162633.891	0924614.683	0442	E15D71	R	6	0	0	1	16.4427475	-92.7707453	t
34254	82	0226	El Azufre	162625.292	0924548.496	0434	E15D71	R	7	0	0	1	16.4403589	-92.7634711	t
34255	82	0227	El Baj¡o	162544.952	0924516.420	0414	E15D71	R	2	0	0	1	16.4291533	-92.7545611	t
34256	82	0234	Los Gavilanes	162701.025	0924710.932	0449	E15D71	R	6	0	0	2	16.4502847	-92.7863700	t
34257	82	0235	La Aurora Vieja	162705.127	0924725.344	0464	E15D71	R	0	0	0	0	16.4514242	-92.7903733	t
34258	82	0241	El Zapote Uno	163417.731	0924900.455	0425	E15D61	R	0	0	0	0	16.5715919	-92.8167931	t
34259	82	0242	El Zapote Dos	163458.993	0924913.515	0448	E15D61	R	0	0	0	0	16.5830536	-92.8204208	t
34260	82	0258	Los Cocos	163412.703	0925117.505	0419	E15D61	R	0	0	0	0	16.5701953	-92.8548625	t
34261	82	0259	Las Palmeras	163411.110	0925113.857	0413	E15D61	R	0	0	0	0	16.5697528	-92.8538492	t
34262	82	0265	Las Margaritas	163457.009	0925206.177	0408	E15D61	R	8	0	0	1	16.5825025	-92.8683825	t
34263	82	0266	Nueva Esperanza	163501.246	0925146.503	0414	E15D61	R	0	0	0	0	16.5836794	-92.8629175	t
34264	82	0268	La Providencia	163817.807	0925432.791	0419	E15D61	R	0	0	0	0	16.6382797	-92.9091086	t
34265	82	0275	El Ni¤o	162721.844	0924725.925	0446	E15D71	R	0	0	0	0	16.4560678	-92.7905347	t
34266	82	0277	El Para¡so	162817.051	0924740.509	0500	E15D71	R	3	0	0	1	16.4714031	-92.7945858	t
34267	82	0278	El Recuerdo	162822.899	0924758.518	0520	E15D71	R	0	0	0	0	16.4730275	-92.7995883	t
34268	82	0279	El Porvenir	162739.645	0924706.618	0449	E15D71	R	0	0	0	0	16.4610125	-92.7851717	t
34269	82	0283	El Sauce	162721.689	0924739.921	0462	E15D71	R	1	0	0	1	16.4560247	-92.7944225	t
34270	82	0292	San Jos‚ de los Planes	162737.452	0924927.497	0537	E15D71	R	11	6	5	4	16.4604033	-92.8243047	t
34271	82	0293	Santa Rosa	163657.522	0925120.364	0633	E15D61	R	181	91	90	32	16.6159783	-92.8556567	t
34272	82	0297	Bel‚n	163340.728	0924719.067	0478	E15D61	R	187	90	97	37	16.5613133	-92.7886297	t
34273	82	0302	La Libertad	162835.871	0924835.000	0543	E15D71	R	2	0	0	1	16.4766308	-92.8097222	t
34274	82	0308	El Barejonal	163226.244	0924915.463	0420	E15D61	R	0	0	0	0	16.5406233	-92.8209619	t
34275	82	0310	La Ceiba	163620.580	0925325.273	0419	E15D61	R	3	0	0	1	16.6057167	-92.8903536	t
34276	82	0322	Frontera de Grijalva	163048.484	0925053.096	0480	E15D61	R	76	43	33	21	16.5134678	-92.8480822	t
34277	82	0324	Guadalupe de los Llanos	162936.690	0924826.073	0499	E15D71	R	0	0	0	0	16.4935250	-92.8072425	t
34278	82	0333	El Favorito	163146.118	0924943.872	0431	E15D61	R	2	0	0	1	16.5294772	-92.8288533	t
34279	82	0335	Mar¡a del Carmen Flores	163039.134	0925058.026	0503	E15D61	R	5	0	0	1	16.5108706	-92.8494517	t
34280	82	0338	Miriam P‚rez	163029.905	0925105.572	0503	E15D61	R	16	8	8	5	16.5083069	-92.8515478	t
34281	82	0341	El Monte	163233.945	0924837.915	0432	E15D61	R	0	0	0	0	16.5427625	-92.8105319	t
34282	82	0342	Los Nopales	162758.556	0924755.345	0501	E15D71	R	3	0	0	1	16.4662656	-92.7987069	t
34283	82	0348	Solo Dios	162854.542	0924844.473	0527	E15D71	R	0	0	0	0	16.4818172	-92.8123536	t
34284	82	0350	Rafael Coello	163421.762	0924620.115	0462	E15D61	R	14	0	0	2	16.5727117	-92.7722542	t
34285	82	0353	El Recuerdo	163051.706	0925055.877	0480	E15D61	R	6	0	0	1	16.5143628	-92.8488547	t
34286	82	0356	El Azufre	162648.984	0924726.988	0464	E15D71	R	0	0	0	0	16.4469400	-92.7908300	t
34287	82	0357	San Judas Tadeo	163056.844	0925054.822	0481	E15D61	R	0	0	0	0	16.5157900	-92.8485617	t
34288	82	0358	San Vicente	162934.277	0925001.690	0480	E15D71	R	0	0	0	0	16.4928547	-92.8338028	t
34289	82	0361	Esperanza	163505.898	0925222.790	0405	E15D61	R	0	0	0	0	16.5849717	-92.8729972	t
34290	82	0369	El Tesoro	162726.836	0924510.443	0408	E15D71	R	0	0	0	0	16.4574544	-92.7529008	t
34291	82	0371	El Desenga¤o	162837.434	0924837.232	0541	E15D71	R	0	0	0	0	16.4770650	-92.8103422	t
34292	82	0372	El Girasol	162955.786	0925139.072	0501	E15D71	R	1	0	0	1	16.4988294	-92.8608533	t
34293	82	0376	Mat¡as	163308.439	0924956.582	0401	E15D61	R	9	0	0	2	16.5523442	-92.8323839	t
34294	82	0377	El Porvenir	162527.510	0924510.321	0428	E15D71	R	7	0	0	1	16.4243083	-92.7528669	t
34295	82	0380	La Rocallosa	163252.632	0924832.183	0399	E15D61	R	5	0	0	1	16.5479533	-92.8089397	t
34296	82	0381	Monte Sina¡	162655.500	0924813.646	0520	E15D71	R	55	26	29	12	16.4487500	-92.8037906	t
34297	82	0386	Santa Isabel	162652.719	0924744.366	0495	E15D71	R	0	0	0	0	16.4479775	-92.7956572	t
34298	82	0388	Tres Hermanos	162715.294	0924746.810	0480	E15D71	R	0	0	0	0	16.4542483	-92.7963361	t
34299	82	0389	Veracruz	162646.928	0924605.701	0420	E15D71	R	0	0	0	0	16.4463689	-92.7682503	t
34300	82	0390	Villa Aurora	162939.791	0924928.706	0501	E15D71	R	0	0	0	0	16.4943864	-92.8246406	t
34301	82	0391	Hern ndez Rodr¡guez	162956.723	0925147.044	0500	E15D71	R	39	16	23	11	16.4990897	-92.8630678	t
34302	82	0392	Humberto Serrano	162928.505	0925106.238	0500	E15D71	R	23	15	8	3	16.4912514	-92.8517328	t
34303	82	0394	Ciro P‚rez M‚ndez	162946.153	0924946.237	0491	E15D71	R	0	0	0	0	16.4961536	-92.8295103	t
34304	82	0396	Guadalupe Robles C.	162711.302	0924822.252	0489	E15D71	R	1	0	0	1	16.4531394	-92.8061811	t
34305	82	0397	Manuel Cruz Matambu	163007.309	0924952.782	0480	E15D61	R	0	0	0	0	16.5020303	-92.8313283	t
34306	82	0398	Agua Dulce	163009.883	0925006.753	0480	E15D61	R	0	0	0	0	16.5027453	-92.8352092	t
34307	82	0399	Agua Dulce San Isidro	162949.504	0924919.703	0500	E15D71	R	0	0	0	0	16.4970844	-92.8221397	t
34308	82	0402	San Jos‚ de Jes£s Dos	162702.285	0924818.896	0501	E15D71	R	8	0	0	1	16.4506347	-92.8052489	t
34309	82	0403	Los Sauces	162815.223	0925016.943	0516	E15D71	R	4	0	0	1	16.4708953	-92.8380397	t
34310	82	0405	Jes£s Molano Ruiz	162935.875	0924959.395	0480	E15D71	R	0	0	0	0	16.4932986	-92.8331653	t
34311	82	0406	Jorge Molina Ord¢¤ez	162947.703	0924955.750	0475	E15D71	R	0	0	0	0	16.4965842	-92.8321528	t
34312	82	0407	Vicente	162938.626	0924948.695	0482	E15D71	R	0	0	0	0	16.4940628	-92.8301931	t
34313	82	0409	Monte de los Olivos	163129.072	0925025.900	0480	E15D61	R	199	108	91	37	16.5247422	-92.8405278	t
34314	82	0410	Nuevo Altamira	163752.760	0925444.270	0449	E15D61	R	94	41	53	23	16.6313222	-92.9122972	t
34315	82	0411	Roberto Albores Guill‚n	163252.427	0924848.818	0418	E15D61	R	172	92	80	49	16.5478964	-92.8135606	t
34316	82	0412	San Pedro Pedernal	163133.307	0924536.168	0441	E15D61	R	140	68	72	20	16.5259186	-92.7600467	t
34317	82	0413	Nueva Libertad	163448.789	0925128.869	0423	E15D61	R	46	26	20	10	16.5802192	-92.8580192	t
34318	82	0414	Quinta Guadalupe	163341.705	0924957.917	0406	E15D61	R	1	0	0	1	16.5615847	-92.8327547	t
34319	82	0415	Camino Pintado	163635.308	0925332.141	0418	E15D61	R	4	0	0	1	16.6098078	-92.8922614	t
34320	82	0418	El Cerrito	162908.026	0925049.263	0520	E15D71	R	4	0	0	1	16.4855628	-92.8470175	t
34321	82	0419	El Crucero	162955.254	0925145.379	0500	E15D71	R	3	0	0	1	16.4986817	-92.8626053	t
34322	82	0420	El Nacimiento	163209.250	0924719.800	0409	E15D61	R	0	0	0	0	16.5359028	-92.7888333	t
34323	82	0421	El Rosario	163011.250	0925150.786	0496	E15D61	R	9	0	0	2	16.5031250	-92.8641072	t
34324	82	0422	Jos‚ Mar¡a Morelos y Pav¢n II	163144.150	0924713.169	0420	E15D61	R	8	6	2	3	16.5289306	-92.7869914	t
34325	82	0423	Las Orqu¡deas	162947.392	0925136.149	0520	E15D71	R	0	0	0	0	16.4964978	-92.8600414	t
34326	82	0424	San Francisco	163234.696	0924904.536	0411	E15D61	R	1	0	0	1	16.5429711	-92.8179267	t
34327	82	0427	El Triunfo	163030.228	0924537.172	0410	E15D61	R	0	0	0	0	16.5083967	-92.7603256	t
34328	82	0431	Piedra del Tigre	163359.890	0924833.140	0461	E15D61	R	26	12	14	8	16.5666361	-92.8092056	t
34329	82	0434	El Centenario	163326.275	0924721.664	0415	E15D61	R	10	4	6	3	16.5572986	-92.7893511	t
34330	82	0435	Real de Guadalupe	163539.739	0925245.888	0409	E15D61	R	2	0	0	1	16.5943719	-92.8794133	t
34331	82	0436	Mar¡a de Candelaria	163113.174	0925038.651	0446	E15D61	R	0	0	0	0	16.5203261	-92.8440697	t
34332	82	0437	Nuevo Laredo los Manguitos	163117.763	0924856.352	0428	E15D61	R	17	13	4	5	16.5216008	-92.8156533	t
34333	82	0439	El Refugio	163539.462	0925252.547	0405	E15D61	R	0	0	0	0	16.5942950	-92.8812631	t
34334	82	0440	La Candelaria	163532.427	0925251.664	0396	E15D61	R	0	0	0	0	16.5923408	-92.8810178	t
34335	82	0467	Los Nopales	162937.500	0924826.050	0500	E15D71	R	0	0	0	0	16.4937500	-92.8072361	t
34336	82	0468	San Carlos	162945.694	0925138.295	0520	E15D71	R	0	0	0	0	16.4960261	-92.8606375	t
34337	82	0469	San Antonio	162921.789	0924512.811	0415	E15D71	R	0	0	0	0	16.4893858	-92.7535586	t
34338	83	0001	Acapetahua	151658.216	0924120.875	0031	D15B31	U	6194	3102	3092	1621	15.2828378	-92.6891319	t
34339	83	0004	El Amatillo	151316.884	0925318.028	0002	D15B41	R	10	7	3	3	15.2213567	-92.8883411	t
34340	83	0005	El Arenal	151025.321	0924156.810	0007	D15B41	R	1157	565	592	299	15.1737003	-92.6991139	t
34341	83	0006	Barra Zacapulco	151141.564	0925303.724	0009	D15B41	R	385	197	188	102	15.1948789	-92.8843678	t
34342	83	0007	Barrio Nuevo	151435.763	0924129.872	0018	D15B41	R	561	288	273	135	15.2432675	-92.6916311	t
34343	83	0008	Berl¡n	151534.455	0924558.185	0011	D15B31	R	9	0	0	1	15.2595708	-92.7661625	t
34344	83	0011	Colombia	151402.649	0923922.852	0021	D15B42	R	431	217	214	126	15.2340692	-92.6563478	t
34345	83	0012	Consuelo Ulapa	152305.320	0924735.881	0026	D15B31	R	1937	942	995	466	15.3848111	-92.7933003	t
34346	83	0016	Esther Zuno	151544.566	0924156.614	0023	D15B31	R	0	0	0	0	15.2623794	-92.6990594	t
34347	83	0017	Embarcadero las Garzas	151212.527	0924851.448	0006	D15B41	R	19	7	12	6	15.2034797	-92.8142911	t
34348	83	0018	El Herrado	151310.529	0925258.316	0006	D15B41	R	88	46	42	25	15.2195914	-92.8828656	t
34349	83	0019	La Ilse	152259.016	0924747.004	0023	D15B31	R	2	0	0	1	15.3830600	-92.7963900	t
34350	83	0021	Laguna Seca	151749.480	0924227.777	0028	D15B31	R	96	50	46	24	15.2970778	-92.7077158	t
34351	83	0022	Luis Espinoza	151124.954	0924128.595	0006	D15B41	R	602	310	292	171	15.1902650	-92.6912764	t
34352	83	0023	El Madronal	151654.640	0924228.908	0023	D15B31	R	594	308	286	144	15.2818444	-92.7080300	t
34353	83	0024	Mariano Matamoros	151522.045	0924417.864	0013	D15B31	R	776	380	396	187	15.2561236	-92.7382956	t
34354	83	0026	Mactumatz  (La Granja)	151725.908	0924208.415	0029	D15B31	R	6	0	0	1	15.2905300	-92.7023375	t
34355	83	0028	Once de Marzo	151629.672	0924212.690	0024	D15B31	R	181	93	88	47	15.2749089	-92.7035250	t
34356	83	0029	La Palma	151023.334	0925012.824	0005	D15B41	R	678	346	332	174	15.1731483	-92.8368956	t
34357	83	0030	El Pataste	152147.455	0924515.395	0030	D15B31	R	21	9	12	6	15.3631819	-92.7542764	t
34358	83	0035	El Progreso	151013.171	0924219.894	0007	D15B41	R	6	0	0	1	15.1703253	-92.7055261	t
34359	83	0037	Embarcadero R¡o Arriba	150908.615	0924319.442	0010	D15B41	R	79	44	35	25	15.1523931	-92.7220672	t
34360	83	0042	San Jos‚	151237.990	0924158.223	0010	D15B41	R	91	52	39	25	15.2105528	-92.6995064	t
34361	83	0046	Soconusco	151855.500	0924337.564	0029	D15B31	U	2502	1187	1315	684	15.3154167	-92.7271011	t
34362	83	0052	Las Garzas	151303.943	0924751.752	0010	D15B41	R	186	104	82	47	15.2177619	-92.7977089	t
34363	83	0054	Los Cocos	152101.591	0924700.154	0015	D15B31	R	0	0	0	0	15.3504419	-92.7833761	t
34364	83	0059	La Batalla	151929.675	0924415.031	0023	D15B31	R	2	0	0	1	15.3249097	-92.7375086	t
34365	83	0061	Las Murallas	151600.461	0925049.807	0003	D15B31	R	212	118	94	47	15.2667947	-92.8471686	t
34366	83	0062	El Progreso	151414.759	0925006.114	0010	D15B41	R	97	45	52	20	15.2374331	-92.8350317	t
34367	83	0065	San Cayetano	151027.445	0924236.717	0008	D15B41	R	1	0	0	1	15.1742903	-92.7101992	t
34368	83	0066	Esperanza los Coquitos	150852.833	0925008.406	0004	D15B41	R	16	11	5	4	15.1480092	-92.8356683	t
34369	83	0067	San Juan	152028.388	0924709.679	0015	D15B31	R	16	7	9	5	15.3412189	-92.7860219	t
34370	83	0068	Jiquilpan (Estaci¢n Bonanza)	152027.930	0924450.073	0027	D15B31	R	1119	543	576	297	15.3410917	-92.7472425	t
34371	83	0073	R¡o Arriba	151203.721	0924104.800	0007	D15B41	R	387	197	190	90	15.2010336	-92.6846667	t
34372	83	0074	La Nueva Esperanza	151156.505	0924014.704	0009	D15B41	R	302	155	147	69	15.1990292	-92.6707511	t
34373	83	0076	La Concepci¢n	150407.258	0924519.618	0004	D15B41	R	0	0	0	0	15.0686828	-92.7554494	t
34374	83	0077	El Para¡so	150510.577	0924655.532	0005	D15B41	R	4	0	0	1	15.0862714	-92.7820922	t
34375	83	0081	Absal¢n Castellanos Dom¡nguez	151541.721	0924808.791	0010	D15B31	R	481	242	239	105	15.2615892	-92.8024419	t
34376	83	0083	El Corosal	151836.022	0924615.686	0016	D15B31	R	35	20	15	10	15.3100061	-92.7710239	t
34377	83	0084	Las Cruces	151655.158	0924402.285	0021	D15B31	R	603	316	287	141	15.2819883	-92.7339681	t
34378	83	0085	El Chilar	151622.921	0924935.762	0006	D15B31	R	101	50	51	22	15.2730336	-92.8266006	t
34379	83	0087	Sin Igual Fracci¢n Uno	151453.981	0924048.731	0024	D15B41	R	5	0	0	1	15.2483281	-92.6802031	t
34380	83	0091	El Jard¡n	151723.067	0924607.780	0014	D15B31	R	17	9	8	4	15.2897408	-92.7688278	t
34381	83	0093	Las Lauras	151030.805	0924503.390	0008	D15B41	R	393	218	175	111	15.1752236	-92.7509417	t
34382	83	0094	Ignacio Allende	151321.896	0925011.558	0001	D15B41	R	12	7	5	4	15.2227489	-92.8365439	t
34383	83	0096	Las Mercedes	151429.654	0924646.106	0010	D15B41	R	298	145	153	69	15.2415706	-92.7794739	t
34384	83	0097	Nahualapa	151930.710	0924458.656	0019	D15B31	R	6	0	0	1	15.3251972	-92.7496267	t
34385	83	0100	Panzacola	150653.000	0924530.000	0010	D15B41	R	0	0	0	0	15.1147222	-92.7583333	t
34386	83	0101	La Pozona	152059.394	0924457.319	0026	D15B31	R	93	50	43	28	15.3498317	-92.7492553	t
34387	83	0102	La Providencia	151804.289	0924448.920	0019	D15B31	R	0	0	0	0	15.3011914	-92.7469222	t
34388	83	0103	Quince de Abril	151458.515	0925122.063	0002	D15B41	R	237	118	119	55	15.2495875	-92.8561286	t
34389	83	0104	Rosalinda	151758.972	0924546.912	0015	D15B31	R	1	0	0	1	15.2997144	-92.7630311	t
34390	83	0111	Santa Rosa	151259.516	0924519.047	0010	D15B41	R	19	8	11	3	15.2165322	-92.7552908	t
34391	83	0114	Zacualpita	151623.159	0924007.948	0042	D15B31	R	151	76	75	38	15.2730997	-92.6688744	t
34392	83	0116	Tokio	151742.671	0924205.559	0030	D15B31	R	3	0	0	2	15.2951864	-92.7015442	t
34393	83	0117	La Herradura	152246.284	0924622.833	0023	D15B31	R	8	0	0	2	15.3795233	-92.7730092	t
34394	83	0120	Veinte de Abril	151636.112	0924734.660	0011	D15B31	R	512	262	250	119	15.2766978	-92.7929611	t
34395	83	0122	Vuelta Lim¢n	152003.817	0924555.729	0022	D15B31	R	14	8	6	3	15.3343936	-92.7654803	t
34396	83	0123	La Alianza	151617.461	0924601.025	0012	D15B31	R	4	0	0	1	15.2715169	-92.7669514	t
34397	83	0129	Barra por Siete	150543.008	0924731.992	0005	D15B41	R	0	0	0	0	15.0952800	-92.7922200	t
34398	83	0130	El Laurelar	150615.728	0924759.596	0001	D15B41	R	2	0	0	1	15.1043689	-92.7998878	t
34399	83	0139	Las Morenas	151414.307	0924548.008	0011	D15B41	R	157	83	74	37	15.2373075	-92.7633356	t
34400	83	0140	La Lupe	151035.384	0925217.145	0011	D15B41	R	144	67	77	29	15.1764956	-92.8714292	t
34401	83	0141	El Camp¢n	151205.898	0925152.157	0008	D15B41	R	0	0	0	0	15.2016383	-92.8644881	t
34402	83	0142	San Jos‚ Aguajal	151518.525	0924955.522	0003	D15B31	R	257	133	124	50	15.2551458	-92.8320894	t
34403	83	0143	Limoncitos (San Juan de los Lagos)	151635.664	0925125.240	0002	D15B31	R	30	16	14	7	15.2765733	-92.8570111	t
34404	83	0144	Los Placeres	151750.823	0924700.639	0013	D15B31	R	23	11	12	5	15.2974508	-92.7835108	t
34405	83	0149	La Lupita	151746.215	0924042.239	0039	D15B31	R	7	0	0	1	15.2961708	-92.6783997	t
34406	83	0152	Paso de Londres	151719.322	0924153.808	0030	D15B31	R	25	13	12	8	15.2887006	-92.6982800	t
34407	83	0159	Santa Teresita	151731.448	0924041.182	0037	D15B31	R	1	0	0	1	15.2920689	-92.6781061	t
34408	83	0164	Santa Isabel la Libertad	151419.002	0924218.410	0019	D15B41	R	3	0	0	1	15.2386117	-92.7051139	t
34409	83	0166	El Carmen	151522.168	0924221.965	0021	D15B31	R	6	0	0	1	15.2561578	-92.7061014	t
34410	83	0167	Esther Fracci¢n 4 (San Jos‚)	151452.163	0924233.283	0020	D15B41	R	1	0	0	1	15.2478231	-92.7092453	t
34411	83	0168	San Hip¢lito	151514.355	0924252.115	0021	D15B31	R	0	0	0	0	15.2539875	-92.7144764	t
34412	83	0169	El Para¡so	151736.273	0924315.380	0024	D15B31	R	42	19	23	11	15.2934092	-92.7209389	t
34413	83	0170	Santa Cristina	151556.237	0924230.212	0024	D15B31	R	2	0	0	1	15.2656214	-92.7083922	t
34414	83	0172	San Miguel	151713.901	0924052.167	0035	D15B31	R	0	0	0	0	15.2871947	-92.6811575	t
34415	83	0175	Tres Hermanos	151458.975	0924141.328	0020	D15B41	R	0	0	0	0	15.2497153	-92.6948133	t
34416	83	0179	Santo Domingo	151358.996	0924109.496	0017	D15B41	R	1	0	0	1	15.2330544	-92.6859711	t
34417	83	0187	Brisas Espinal	151252.906	0924055.946	0013	D15B41	R	4	0	0	1	15.2146961	-92.6822072	t
34418	83	0188	Los µngeles	151101.862	0924218.606	0007	D15B41	R	4	0	0	1	15.1838506	-92.7051683	t
34419	83	0190	La Vega	151240.060	0924133.455	0013	D15B41	R	4	0	0	1	15.2111278	-92.6926264	t
34420	83	0191	Los Placeres	150911.087	0924256.364	0009	D15B41	R	2	0	0	1	15.1530797	-92.7156567	t
34421	83	0194	R¡o Negro	151221.256	0924339.367	0008	D15B41	R	381	205	176	97	15.2059044	-92.7276019	t
34422	83	0211	San Isidro	151320.060	0924421.027	0012	D15B41	R	52	32	20	14	15.2222389	-92.7391742	t
34423	83	0215	Papaturral	151433.836	0924242.343	0020	D15B41	R	0	0	0	0	15.2427322	-92.7117619	t
34424	83	0224	La Joya	151328.286	0924507.560	0012	D15B41	R	4	0	0	1	15.2245239	-92.7521000	t
34425	83	0228	La Esperanza	151307.001	0924630.362	0010	D15B41	R	62	30	32	14	15.2186114	-92.7751006	t
34426	83	0230	Las Morenas	151222.600	0924645.664	0009	D15B41	R	2	0	0	1	15.2062778	-92.7793511	t
34427	83	0232	Las Cruces	151419.752	0924313.904	0018	D15B41	R	5	0	0	1	15.2388200	-92.7205289	t
34428	83	0233	El Relicario	151308.430	0924025.727	0008	D15B41	R	0	0	0	0	15.2190083	-92.6738131	t
34429	83	0234	Santa Clara	151220.325	0924606.430	0009	D15B41	R	6	0	0	2	15.2056458	-92.7684528	t
34430	83	0236	Las Mercedes	151529.533	0924116.931	0024	D15B31	R	21	10	11	5	15.2582036	-92.6880364	t
34431	83	0239	La Vainilla	151655.983	0924637.123	0013	D15B31	R	240	147	93	6	15.2822175	-92.7769786	t
34432	83	0248	Zacapulco	151402.636	0924201.610	0018	D15B41	R	3	0	0	1	15.2340656	-92.7004472	t
34433	83	0253	Santo Domingo	151228.380	0924705.630	0010	D15B41	R	2	0	0	1	15.2078833	-92.7848972	t
34434	83	0265	El Manguito	152045.459	0924601.494	0023	D15B31	R	2	0	0	1	15.3459608	-92.7670817	t
34435	83	0267	La Victoria	151849.098	0924556.576	0018	D15B31	R	5	0	0	1	15.3136383	-92.7657156	t
34436	83	0268	Jiquilpan (Rancho Quemado)	151910.630	0924817.574	0013	D15B31	R	541	262	279	123	15.3196194	-92.8048817	t
34437	83	0274	Las Dorias	152242.996	0924725.008	0020	D15B31	R	4	0	0	1	15.3786100	-92.7902800	t
34438	83	0275	Santa Lorena	152303.470	0924749.283	0023	D15B31	R	10	6	4	3	15.3842972	-92.7970231	t
34439	83	0276	Yoreme	152237.606	0924517.129	0031	D15B31	R	0	0	0	0	15.3771128	-92.7547581	t
34440	83	0277	El Fort¡n	152222.225	0924518.543	0035	D15B31	R	7	6	1	4	15.3728403	-92.7551508	t
34441	83	0279	San Jos‚ Media Luna	151848.142	0924601.636	0017	D15B31	R	5	0	0	1	15.3133728	-92.7671211	t
34442	83	0287	El Chincuyo	150924.135	0924256.468	0009	D15B41	R	0	0	0	0	15.1567042	-92.7156856	t
34443	83	0290	La Valdiviana	151205.776	0924553.087	0008	D15B41	R	4	0	0	1	15.2016044	-92.7647464	t
34444	83	0293	El Diamante	151616.980	0924141.398	0025	D15B31	R	11	0	0	2	15.2713833	-92.6948328	t
34445	83	0296	Pur‚pecha	151746.071	0924102.166	0034	D15B31	R	7	0	0	1	15.2961308	-92.6839350	t
34446	83	0297	San Bernardino	151959.963	0924509.688	0024	D15B31	R	21	10	11	5	15.3333231	-92.7526911	t
34447	83	0299	5 Hermanos	151720.004	0924650.016	0015	D15B31	R	5	0	0	1	15.2888900	-92.7805600	t
34448	83	0300	La Joya	151754.392	0924506.003	0018	D15B31	R	0	0	0	0	15.2984422	-92.7516675	t
34449	83	0301	Los Gonz lez	151741.729	0924136.973	0030	D15B31	R	0	0	0	0	15.2949247	-92.6936036	t
34450	83	0305	Los Cocos	151824.951	0924425.298	0022	D15B31	R	39	19	20	11	15.3069308	-92.7403606	t
34451	83	0306	El Respingo	151832.369	0924406.982	0024	D15B31	R	34	19	15	8	15.3089914	-92.7352728	t
34452	83	0319	La Curri	151223.140	0924719.370	0010	D15B41	R	7	0	0	2	15.2064278	-92.7887139	t
34453	83	0325	La Islona (La Escondida)	150917.273	0925002.025	0005	D15B41	R	1	0	0	1	15.1547981	-92.8338958	t
34454	83	0326	Scorpio (La Mona)	151143.592	0925315.233	0009	D15B41	R	0	0	0	0	15.1954422	-92.8875647	t
34455	83	0327	Las Gardenias	150814.247	0924954.435	-007	D15B41	R	4	0	0	2	15.1372908	-92.8317875	t
34456	83	0333	Esmeralda	151633.819	0924455.949	0013	D15B31	R	14	6	8	3	15.2760608	-92.7488747	t
34457	83	0334	Papaturro	151811.235	0924924.255	0008	D15B31	R	0	0	0	0	15.3031208	-92.8234042	t
34458	83	0335	El Para¡so	151819.242	0924941.966	0006	D15B31	R	5	0	0	1	15.3053450	-92.8283239	t
34459	83	0336	El Huasteco	151800.773	0924934.439	0007	D15B31	R	2	0	0	1	15.3002147	-92.8262331	t
34460	83	0337	Las Gardenias	151741.627	0925012.769	0004	D15B31	R	17	10	7	4	15.2948964	-92.8368803	t
34461	83	0338	El Jazm¡n	151800.075	0924937.322	0007	D15B31	R	8	0	0	1	15.3000208	-92.8270339	t
34462	83	0339	La Laguna	151745.308	0925011.699	0004	D15B31	R	8	0	0	2	15.2959189	-92.8365831	t
34463	83	0340	Los Cascabeles	151725.371	0924927.316	0008	D15B31	R	4	0	0	1	15.2903808	-92.8242544	t
34464	83	0341	Chapala	151832.391	0924753.447	0012	D15B31	R	82	42	40	18	15.3089975	-92.7981797	t
34465	83	0344	Nu¤ez	151705.693	0924734.757	0012	D15B31	R	193	113	80	50	15.2849147	-92.7929881	t
34466	83	0347	Las Delicias	151422.057	0924841.188	0006	D15B41	R	22	8	14	6	15.2394603	-92.8114411	t
34467	83	0348	El Potrillo	151926.093	0924540.784	0020	D15B31	R	2	0	0	2	15.3239147	-92.7613289	t
34468	83	0350	Emiliano Zapata Salazar	151445.699	0924742.172	0010	D15B41	R	108	52	56	22	15.2460275	-92.7950478	t
34469	83	0360	El Coco	151829.041	0924831.490	0010	D15B31	R	5	0	0	1	15.3080669	-92.8087472	t
34470	83	0367	El Otate	152112.461	0924545.959	0022	D15B31	R	2	0	0	1	15.3534614	-92.7627664	t
34471	83	0370	El Abanico	151917.610	0924512.329	0016	D15B31	R	5	0	0	1	15.3215583	-92.7534247	t
34472	83	0371	Argentina	151356.630	0924843.490	0005	D15B41	R	6	0	0	1	15.2323972	-92.8120806	t
34473	83	0372	La Ceiba	152155.023	0924559.891	0019	D15B31	R	16	6	10	3	15.3652842	-92.7666364	t
34474	83	0373	Bal£n Can n	151254.964	0924609.749	0010	D15B41	R	2	0	0	1	15.2152678	-92.7693747	t
34475	83	0375	Las Brisas	151709.450	0924930.009	0008	D15B31	R	1	0	0	1	15.2859583	-92.8250025	t
34476	83	0376	Los Cerritos	151220.447	0924454.536	0009	D15B41	R	120	68	52	34	15.2056797	-92.7484822	t
34477	83	0377	Centauro del Norte	151322.006	0923901.858	0011	D15B42	R	85	41	44	22	15.2227794	-92.6505161	t
34478	83	0378	Los Cocos	151818.527	0924952.581	0005	D15B31	R	7	0	0	2	15.3051464	-92.8312725	t
34479	83	0380	El Desenga¤o	151748.488	0925021.612	0004	D15B31	R	5	0	0	1	15.2968022	-92.8393367	t
34480	83	0381	El Desenga¤o	151816.590	0925025.794	0006	D15B31	R	10	5	5	3	15.3046083	-92.8404983	t
34481	83	0382	Doble B	151319.702	0924144.802	0019	D15B41	R	0	0	0	0	15.2221394	-92.6957783	t
34482	83	0383	Emilia	151620.583	0924535.540	0012	D15B31	R	31	19	12	6	15.2723842	-92.7598722	t
34483	83	0384	Sin Pensar	151800.805	0925005.865	0004	D15B31	R	3	0	0	1	15.3002236	-92.8349625	t
34484	83	0386	La Esperanza	151738.261	0924913.506	0009	D15B31	R	3	0	0	1	15.2939614	-92.8204183	t
34485	83	0387	Las Flores	151828.008	0925012.012	0008	D15B31	R	1	0	0	1	15.3077800	-92.8366700	t
34486	83	0388	Las Flores	151834.257	0924955.640	0005	D15B31	R	4	0	0	1	15.3095158	-92.8321222	t
34487	83	0389	La Fortuna	151236.905	0924640.193	0009	D15B41	R	6	0	0	1	15.2102514	-92.7778314	t
34488	83	0392	Lagunilla	152233.040	0924806.304	0013	D15B31	R	5	0	0	2	15.3758444	-92.8017511	t
34489	83	0393	Las Lomas	151823.058	0924857.430	0009	D15B31	R	0	0	0	0	15.3064050	-92.8159528	t
34490	83	0394	Las Lomas	152119.850	0924820.714	0008	D15B31	R	40	28	12	18	15.3555139	-92.8057539	t
34491	83	0396	Las Maravillas	151816.339	0925031.837	0007	D15B31	R	6	0	0	1	15.3045386	-92.8421769	t
34492	83	0398	El Nacimiento	151901.592	0925014.012	0008	D15B31	R	1	0	0	1	15.3171089	-92.8372256	t
34493	83	0400	El Para¡so	151859.243	0925018.838	0009	D15B31	R	6	0	0	1	15.3164564	-92.8385661	t
34494	83	0401	La Primavera	151851.492	0924855.978	0008	D15B31	R	2	0	0	1	15.3143033	-92.8155494	t
34495	83	0403	El Recuerdo	151715.070	0924557.784	0015	D15B31	R	7	0	0	2	15.2875194	-92.7660511	t
34496	83	0405	El Regalo	151809.806	0925025.894	0005	D15B31	R	3	0	0	1	15.3027239	-92.8405261	t
34497	83	0406	El Roble	151834.101	0924933.344	0006	D15B31	R	4	0	0	1	15.3094725	-92.8259289	t
34498	83	0407	El Rosario	151848.080	0924827.535	0010	D15B31	R	5	0	0	1	15.3133556	-92.8076486	t
34499	83	0408	El Rub¡	151846.747	0924945.700	0005	D15B31	R	6	0	0	1	15.3129853	-92.8293611	t
34500	83	0409	Zacapulco	151233.392	0924056.335	0010	D15B41	R	6	0	0	1	15.2092756	-92.6823153	t
34501	83	0410	San Francisco	151853.252	0924934.475	0006	D15B31	R	2	0	0	1	15.3147922	-92.8262431	t
34502	83	0413	San Juan	151631.312	0924631.212	0013	D15B31	R	9	5	4	3	15.2753644	-92.7753367	t
34503	83	0414	San Juan	152303.447	0924608.075	0038	D15B31	R	0	0	0	0	15.3842908	-92.7689097	t
34504	83	0415	San Miguel	151324.265	0924059.232	0015	D15B41	R	2	0	0	1	15.2234069	-92.6831200	t
34505	83	0416	San Pedro	151244.683	0924554.101	0010	D15B41	R	7	0	0	1	15.2124119	-92.7650281	t
34506	83	0418	Santa Elena (La Esperanza)	151743.115	0925042.094	0004	D15B31	R	164	81	83	34	15.2953097	-92.8450261	t
34507	83	0420	Santa Rosa	151755.557	0924855.454	0010	D15B31	R	4	0	0	1	15.2987658	-92.8154039	t
34508	83	0421	Alma Nazar Escobar	151912.469	0925019.574	0008	D15B31	R	5	0	0	1	15.3201303	-92.8387706	t
34509	83	0422	El Texanito	151902.216	0924919.131	0007	D15B31	R	1	0	0	1	15.3172822	-92.8219808	t
34510	83	0425	El Vergel	151626.188	0924033.967	0039	D15B31	R	0	0	0	0	15.2739411	-92.6761019	t
34511	83	0426	El Vergel	151846.048	0925023.823	0009	D15B31	R	3	0	0	1	15.3127911	-92.8399508	t
34512	83	0428	El Desenga¤o	151556.192	0924128.452	0032	D15B31	R	0	0	0	0	15.2656089	-92.6912367	t
34513	83	0429	La Esmeralda	151559.288	0924103.673	0041	D15B31	R	213	110	103	48	15.2664689	-92.6843536	t
34514	83	0430	Francisco Villa	152100.321	0924641.355	0018	D15B31	R	183	89	94	47	15.3500892	-92.7781542	t
34515	83	0431	San Juan Platanillo	151755.946	0924308.584	0025	D15B31	R	12	6	6	3	15.2988739	-92.7190511	t
34516	83	0432	El Afortunado	151751.251	0924948.278	0006	D15B31	R	0	0	0	0	15.2975697	-92.8300772	t
34517	83	0433	El Almendro	151423.621	0923914.917	0027	D15B42	R	12	8	4	3	15.2398947	-92.6541436	t
34518	83	0434	Benito Ju rez	150913.045	0924311.454	0010	D15B41	R	134	71	63	34	15.1536236	-92.7198483	t
34519	83	0435	La Ceiba	151108.520	0924126.422	0005	D15B41	R	7	0	0	1	15.1857000	-92.6906728	t
34520	83	0436	Los Cocos	151309.216	0923913.181	0008	D15B42	R	7	0	0	1	15.2192267	-92.6536614	t
34521	83	0437	El Diamante	151807.383	0924842.709	0010	D15B31	R	9	0	0	2	15.3020508	-92.8118636	t
34522	83	0438	El Diamante	151750.660	0924953.305	0006	D15B31	R	6	0	0	1	15.2974056	-92.8314736	t
34523	83	0439	Dos Hermanos	152235.064	0924528.549	0030	D15B31	R	32	11	21	9	15.3764067	-92.7579303	t
34524	83	0440	La Fortuna	151807.473	0925015.120	0004	D15B31	R	5	0	0	1	15.3020758	-92.8375333	t
34525	83	0441	Las Garzas	151320.176	0923929.437	0007	D15B42	R	3	0	0	1	15.2222711	-92.6581769	t
34526	83	0442	Guadalupe	151409.644	0923846.840	0028	D15B42	R	4	0	0	1	15.2360122	-92.6463444	t
34527	83	0443	El Invierno	151814.662	0924113.312	0035	D15B31	R	0	0	0	0	15.3040728	-92.6870311	t
34528	83	0444	Jiquilpan (Nuevo Milenio)	151957.554	0924421.489	0022	D15B31	R	32	15	17	8	15.3326539	-92.7393025	t
34529	83	0445	La Loma	151550.352	0924110.957	0031	D15B31	R	4	0	0	1	15.2639867	-92.6863769	t
34530	83	0447	Lupita Dos	151759.616	0924052.951	0037	D15B31	R	3	0	0	1	15.2998933	-92.6813753	t
34531	83	0448	El Mangal	151434.158	0923852.576	0067	D15B42	R	2	0	0	1	15.2428217	-92.6479378	t
34532	83	0449	Los Mangos	151342.160	0924007.367	0010	D15B41	R	2	0	0	1	15.2283778	-92.6687131	t
34533	83	0450	Maricarmen	151813.677	0924242.178	0029	D15B31	R	27	17	10	8	15.3037992	-92.7117161	t
34534	83	0451	Las Mercedes	151617.496	0924121.172	0032	D15B31	R	4	0	0	1	15.2715267	-92.6892144	t
34535	83	0452	El Mirador	151446.673	0923841.251	0076	D15B42	R	0	0	0	0	15.2462981	-92.6447919	t
34536	83	0453	Los Nogales	151725.397	0924859.860	0009	D15B31	R	2	0	0	1	15.2903881	-92.8166278	t
34537	83	0454	Palo Blanco	151436.451	0924417.926	0017	D15B41	R	238	115	123	60	15.2434586	-92.7383128	t
34538	83	0455	Paloma Blanca	151740.427	0924357.613	0021	D15B31	R	414	210	204	86	15.2945631	-92.7326703	t
34539	83	0456	Pampas del Silencio	151440.761	0923946.476	0025	D15B42	R	5	0	0	1	15.2446558	-92.6629100	t
34540	83	0457	La Pampita	151838.685	0924307.728	0029	D15B31	R	43	24	19	12	15.3107458	-92.7188133	t
34541	83	0458	Para¡so	151634.555	0924041.635	0041	D15B31	R	3	0	0	1	15.2762653	-92.6782319	t
34542	83	0459	El Para¡so	151717.439	0924621.248	0013	D15B31	R	4	0	0	1	15.2881775	-92.7725689	t
34543	83	0460	El Porvenir	151319.504	0923908.467	0009	D15B42	R	17	10	7	3	15.2220844	-92.6523519	t
34544	83	0461	Quince de Junio Dos	151423.025	0924938.072	0008	D15B41	R	76	38	38	20	15.2397292	-92.8272422	t
34545	83	0463	El Recuerdo	152250.514	0924801.786	0017	D15B31	R	4	0	0	1	15.3806983	-92.8004961	t
34546	83	0464	Relicario	151525.793	0924121.294	0022	D15B31	R	0	0	0	0	15.2571647	-92.6892483	t
34547	83	0465	San Marcos	151749.722	0924100.515	0035	D15B31	R	0	0	0	0	15.2971450	-92.6834764	t
34548	83	0466	Uni¢n las Magdalenas	151510.484	0924033.251	0031	D15B31	R	47	22	25	8	15.2529122	-92.6759031	t
34549	83	0467	San Antonio	151615.195	0924046.521	0041	D15B31	R	3	0	0	1	15.2708875	-92.6795892	t
34550	83	0468	San Antonio	151755.505	0924056.108	0036	D15B31	R	0	0	0	0	15.2987514	-92.6822522	t
34551	83	0469	San Antonio	151305.417	0923917.905	0006	D15B42	R	0	0	0	0	15.2181714	-92.6549736	t
34552	83	0470	San Antonio	151406.300	0923849.000	0027	D15B42	R	11	0	0	1	15.2350833	-92.6469444	t
34553	83	0471	La Luz (San Esteban)	151406.580	0924825.650	0010	D15B41	R	8	0	0	2	15.2351611	-92.8071250	t
34554	83	0472	San Fernando	151544.778	0924116.848	0029	D15B31	R	4	0	0	1	15.2624383	-92.6880133	t
34555	83	0473	San Manuel	152158.494	0924800.533	0009	D15B31	R	12	0	0	1	15.3662483	-92.8001481	t
34556	83	0475	San Rafael	151618.872	0924124.201	0032	D15B31	R	0	0	0	0	15.2719089	-92.6900558	t
34557	83	0476	San Rafael	151430.495	0923938.724	0022	D15B42	R	2	0	0	1	15.2418042	-92.6607567	t
34558	83	0477	Santa Teresita	151812.251	0925003.374	0004	D15B31	R	1	0	0	1	15.3034031	-92.8342706	t
34559	83	0478	Mi Ranchito	152222.472	0924810.196	0011	D15B31	R	2	0	0	1	15.3729089	-92.8028322	t
34560	83	0479	Santo Domingo	151402.089	0924050.227	0014	D15B41	R	3	0	0	1	15.2339136	-92.6806186	t
34561	83	0481	µngel Mat¡as	151440.141	0924915.646	0006	D15B41	R	0	0	0	0	15.2444836	-92.8210128	t
34562	83	0483	El B£caro	151212.836	0923945.077	0007	D15B42	R	2	0	0	1	15.2035656	-92.6625214	t
34563	83	0484	Gilberto Santos Vera	151607.397	0924111.323	0031	D15B31	R	0	0	0	0	15.2687214	-92.6864786	t
34564	83	0485	Guillermina Gardu¤o	151736.946	0924104.214	0032	D15B31	R	0	0	0	0	15.2935961	-92.6845039	t
34565	83	0486	Jos‚ Manuel L¢pez M.	151509.922	0924144.072	0019	D15B31	R	0	0	0	0	15.2527561	-92.6955756	t
34566	83	0487	Mart¡n Cruz del Porte	151431.812	0923911.635	0036	D15B42	R	4	0	0	1	15.2421700	-92.6532319	t
34567	83	0488	Sin Igual Fracci¢n Dos	151454.930	0924044.118	0025	D15B41	R	1	0	0	1	15.2485917	-92.6789217	t
34568	83	0490	Solo Dios	151340.575	0924843.588	0005	D15B41	R	5	0	0	1	15.2279375	-92.8121078	t
34569	83	0491	Tres Hermanos	152243.269	0924807.321	0015	D15B31	R	2	0	0	1	15.3786858	-92.8020336	t
34570	83	0492	Tres Hermanos	151730.773	0924905.772	0009	D15B31	R	1	0	0	1	15.2918814	-92.8182700	t
34571	83	0493	El Vergel	151627.381	0924008.344	0043	D15B31	R	0	0	0	0	15.2742725	-92.6689844	t
34572	83	0494	Zacatonal	151436.148	0924609.420	0011	D15B41	R	152	72	80	30	15.2433744	-92.7692833	t
34573	83	0495	Los Pinos	151409.216	0924107.455	0018	D15B41	R	5	0	0	1	15.2358933	-92.6854042	t
34574	83	0497	El Rosario	151502.162	0924756.439	0009	D15B31	R	7	0	0	2	15.2506006	-92.7990108	t
34575	83	0499	Nueva Reforma	151228.422	0924651.676	0009	D15B41	R	8	0	0	1	15.2078950	-92.7810211	t
34576	83	0500	El Radicario	150709.011	0924850.919	0003	D15B41	R	7	0	0	1	15.1191697	-92.8141442	t
34577	83	0501	Vallarta	151232.200	0924535.010	0009	D15B41	R	12	5	7	3	15.2089444	-92.7597250	t
34578	83	0502	Fracci¢n Do¤a Mar¡a	151553.448	0924455.690	0011	D15B31	R	295	159	136	70	15.2648467	-92.7488028	t
34579	83	0503	La Soledad	151611.525	0924552.981	0011	D15B31	R	82	46	36	20	15.2698681	-92.7647169	t
34580	83	0504	Cinco de Mayo	152129.951	0924728.911	0010	D15B31	R	0	0	0	0	15.3583197	-92.7913642	t
34581	83	0505	La Meseta	151645.966	0924903.587	0008	D15B31	R	3	0	0	1	15.2794350	-92.8176631	t
34582	83	0506	San Diego	152126.603	0924725.630	0011	D15B31	R	0	0	0	0	15.3573897	-92.7904528	t
34583	83	0507	Ojo de Agua	151516.530	0925156.074	0000	D15B31	R	0	0	0	0	15.2545917	-92.8655761	t
34584	83	0508	La Trinidad	151920.255	0924513.850	0017	D15B31	R	6	0	0	2	15.3222931	-92.7538472	t
34585	83	0509	Los Laureles	152022.836	0924615.382	0020	D15B31	R	67	36	31	16	15.3396767	-92.7709394	t
34586	83	0510	El Trebol	152314.741	0924751.942	0023	D15B31	R	9	0	0	2	15.3874281	-92.7977617	t
34587	83	0511	El Naranjo	151007.900	0924147.256	0006	D15B41	R	98	46	52	20	15.1688611	-92.6964600	t
34588	83	0512	Laguna Seca II	151742.251	0924247.669	0027	D15B31	R	37	20	17	7	15.2950697	-92.7132414	t
34589	83	0513	Pan de Palo	151611.307	0924330.603	0020	D15B31	R	136	62	74	34	15.2698075	-92.7251675	t
34590	83	0514	Santa Cecilia	151530.079	0924747.431	0010	D15B31	R	14	7	7	3	15.2583553	-92.7965086	t
34591	83	0515	Fracci¢n Bola de Oro	151213.698	0924140.292	0009	D15B41	R	0	0	0	0	15.2038050	-92.6945256	t
34592	83	0516	Arenas del Vado	151138.600	0924005.794	0007	D15B41	R	0	0	0	0	15.1940556	-92.6682761	t
34593	83	0517	Corozal los Laureles	151755.284	0924729.051	0013	D15B31	R	0	0	0	0	15.2986900	-92.7914031	t
34594	84	0001	Altamirano	164409.313	0920218.937	1242	E15D63	U	9200	4547	4653	2060	16.7359203	-92.0385936	t
34595	84	0002	Aguascalientes Dos	163249.981	0914622.820	1321	E15D64	R	21	10	11	7	16.5472169	-91.7730056	t
34596	84	0003	Tierra y Libertad	163536.446	0914603.229	0964	E15D64	R	9	4	5	3	16.5934572	-91.7675636	t
34597	84	0004	Belisario Dom¡nguez	163838.929	0914429.335	1037	E15D64	R	827	418	409	161	16.6441469	-91.7414819	t
34598	84	0006	Bello Para¡so	163350.051	0914355.570	1242	E15D64	R	0	0	0	0	16.5639031	-91.7321028	t
34599	84	0009	Carmen Laguna	164125.524	0915620.707	1199	E15D64	R	54	27	27	18	16.6904233	-91.9390853	t
34600	84	0010	Nueva Codicia	164821.759	0915556.079	0962	E15D54	R	108	54	54	36	16.8060442	-91.9322442	t
34601	84	0014	Delicias Pach n	163708.800	0914714.326	0805	E15D64	R	30	16	14	4	16.6191111	-91.7873128	t
34602	84	0015	Lindavista (El Encanto)	163727.387	0915245.335	1393	E15D64	R	21	0	0	2	16.6242742	-91.8792597	t
34603	84	0017	La Florida	163829.020	0915911.522	1241	E15D64	R	374	195	179	58	16.6413944	-91.9865339	t
34604	84	0019	La Grandeza	164236.851	0914713.260	1425	E15D64	R	402	210	192	66	16.7102364	-91.7870167	t
34605	84	0023	La Esperanza	164353.229	0915855.912	1262	E15D64	R	20	8	12	5	16.7314525	-91.9821978	t
34606	84	0024	Guadalupe Chitultic	164418.691	0915922.368	1282	E15D64	R	9	0	0	1	16.7385253	-91.9895467	t
34607	84	0027	Guadalupe Victoria	163313.407	0914636.608	1251	E15D64	R	225	109	116	54	16.5537242	-91.7768356	t
34608	84	0030	Jalisco	164447.245	0920100.920	1242	E15D63	R	451	221	230	93	16.7464569	-92.0169222	t
34609	84	0031	Joaqu¡n Miguel Guti‚rrez (Rancho Mateo)	164905.744	0920202.914	1001	E15D53	R	567	289	278	120	16.8182622	-92.0341428	t
34610	84	0032	La Laguna	164132.587	0915655.002	1210	E15D64	R	1222	612	610	286	16.6923853	-91.9486117	t
34611	84	0034	Nuevo L zaro C rdenas	164238.587	0915226.330	1212	E15D64	R	99	49	50	33	16.7107186	-91.8739806	t
34612	84	0037	Luis Espinoza	163516.628	0913719.057	0814	E15D65	R	771	382	389	134	16.5879522	-91.6219603	t
34613	84	0043	Nueva Virginia	163253.005	0914307.248	1235	E15D64	R	390	194	196	60	16.5480569	-91.7186800	t
34614	84	0047	Gabino Barrera (Pamala)	164411.900	0915929.938	1262	E15D64	R	87	43	44	17	16.7366389	-91.9916494	t
34615	84	0050	Nuevo Progreso	163909.920	0914536.401	1005	E15D64	R	153	77	76	51	16.6527556	-91.7601114	t
34616	84	0053	Puebla Viejo	163853.587	0915659.648	1315	E15D64	R	81	41	40	27	16.6482186	-91.9499022	t
34617	84	0054	Puerto Rico	163637.276	0915226.291	1401	E15D64	R	826	401	425	177	16.6103544	-91.8739697	t
34618	84	0058	Carmen Rusia	163442.083	0915017.618	1272	E15D64	R	557	261	296	82	16.5783564	-91.8382272	t
34619	84	0065	San Jos‚ Bel‚n	163408.653	0914900.485	1337	E15D64	R	0	0	0	0	16.5690703	-91.8168014	t
34620	84	0068	San Juan	164647.193	0920301.599	1204	E15D53	R	18	9	9	6	16.7797758	-92.0504442	t
34621	84	0069	San Juan del R¡o	163702.179	0914348.638	0707	E15D64	R	42	21	21	14	16.6172719	-91.7301772	t
34622	84	0072	Santa Cecilia	164814.917	0915803.103	1049	E15D54	R	84	39	45	19	16.8041436	-91.9675286	t
34623	84	0073	Santa Elena de la Cruz	164343.099	0920527.299	1240	E15D63	R	48	27	21	11	16.7286386	-92.0909164	t
34624	84	0078	El Triunfo	164028.339	0914519.972	1308	E15D64	R	556	279	277	111	16.6745386	-91.7555478	t
34625	84	0081	Venustiano Carranza	164015.129	0914903.760	1002	E15D64	R	792	403	389	172	16.6708692	-91.8177111	t
34626	84	0089	Onilja	164511.477	0920545.283	1599	E15D53	R	117	52	65	20	16.7531881	-92.0959119	t
34627	84	0093	Santa Cruz	164245.448	0915245.133	1206	E15D64	R	45	21	24	9	16.7126244	-91.8792036	t
34628	84	0095	Nuestro Se¤or de Esquipulas	164725.815	0920058.439	1303	E15D53	R	0	0	0	0	16.7905042	-92.0162331	t
34629	84	0101	California	164410.768	0914807.007	1487	E15D64	R	33	17	16	11	16.7363244	-91.8019464	t
34630	84	0104	Campo Virgen (El Paraje)	164150.472	0915056.752	1220	E15D64	R	23	14	9	4	16.6973533	-91.8490978	t
34631	84	0119	Gabino Barrera (Nuevo Centro)	164126.658	0920049.096	1193	E15D63	R	49	24	25	13	16.6907383	-92.0136378	t
34632	84	0126	San Luis	164410.047	0920628.796	1218	E15D63	R	20	12	8	4	16.7361242	-92.1079989	t
34633	84	0132	Saltillo	163903.094	0915010.217	0735	E15D64	R	227	126	101	46	16.6508594	-91.8361714	t
34634	84	0135	El Rosario	164304.588	0915404.952	1237	E15D64	R	52	24	28	10	16.7179411	-91.9013756	t
34635	84	0138	Francisco Villa	163656.574	0914547.924	0704	E15D64	R	30	15	15	10	16.6157150	-91.7633122	t
34636	84	0146	San Francisco	163609.370	0914405.649	0833	E15D64	R	603	312	291	69	16.6026028	-91.7349025	t
34637	84	0147	Los Bamb£es	163633.443	0914329.049	0744	E15D64	R	303	166	137	61	16.6092897	-91.7247358	t
34638	84	0150	Nueve de Febrero	163601.779	0914212.612	0860	E15D64	R	24	12	12	8	16.6004942	-91.7035033	t
34639	84	0151	El Horizonte	164049.558	0914716.124	1031	E15D64	R	22	11	11	3	16.6804328	-91.7878122	t
34640	84	0152	Villahermosa	163548.696	0914200.239	0893	E15D64	R	15	10	5	3	16.5968600	-91.7000664	t
34641	84	0154	Palestina	163043.235	0914556.444	1402	E15D64	R	95	49	46	16	16.5120097	-91.7656789	t
34642	84	0158	San Luis Potos¡	163615.893	0913845.511	0730	E15D65	R	642	319	323	109	16.6044147	-91.6459753	t
34643	84	0160	El Oriente	163253.917	0913806.305	0632	E15D65	R	22	11	11	3	16.5483103	-91.6350847	t
34644	84	0164	Candelaria	163457.487	0915035.347	1292	E15D64	R	217	101	116	37	16.5826353	-91.8431519	t
34645	84	0167	El Nance	163658.766	0915738.660	1271	E15D64	R	264	139	125	44	16.6163239	-91.9607389	t
34646	84	0171	El Cipr‚s	164246.091	0915250.352	1201	E15D64	R	31	19	12	6	16.7128031	-91.8806533	t
34647	84	0172	Emiliano Zapata	164102.850	0914715.354	1221	E15D64	R	219	112	107	39	16.6841250	-91.7875983	t
34648	84	0176	El Limonal	163917.140	0914532.262	1062	E15D64	R	48	27	21	9	16.6547611	-91.7589617	t
34649	84	0181	Nueva Galilea	163729.483	0914642.000	0750	E15D64	R	351	175	176	58	16.6248564	-91.7783333	t
34650	84	0182	Nuevo San Carlos	164139.936	0915804.760	1209	E15D64	R	560	291	269	131	16.6944267	-91.9679889	t
34651	84	0185	Puebla Nuevo	163830.815	0915609.926	1330	E15D64	R	225	112	113	75	16.6418931	-91.9360906	t
34652	84	0186	San Marcos	163743.218	0914309.879	1139	E15D64	R	511	274	237	90	16.6286717	-91.7194108	t
34653	84	0190	Sociedad la Victoria	164045.735	0914936.387	1138	E15D64	R	256	132	124	41	16.6793708	-91.8267742	t
34654	84	0193	El Venadito	164343.760	0915828.290	1259	E15D64	R	8	0	0	2	16.7288222	-91.9745250	t
34655	84	0201	Nueva Galilea	164413.074	0920638.122	1216	E15D63	R	76	34	42	10	16.7369650	-92.1105894	t
34656	84	0203	Nueva Esperanza	164351.003	0920612.790	1222	E15D63	R	65	30	35	10	16.7308342	-92.1035528	t
34657	84	0204	Plan de Ayala	164321.294	0920341.736	1242	E15D63	R	24	12	12	8	16.7225817	-92.0615933	t
34658	84	0209	El Banco	164204.668	0920232.397	1267	E15D63	R	0	0	0	0	16.7012967	-92.0423325	t
34659	84	0210	Poblado Nuevo Altamirano	164209.612	0920229.695	1264	E15D63	R	64	34	30	15	16.7026700	-92.0415819	t
34660	84	0217	El Parrandero (Casa Blanca)	164224.346	0920235.292	1258	E15D63	R	0	0	0	0	16.7067628	-92.0431367	t
34661	84	0220	El Peric¢n	164747.406	0920152.492	1201	E15D53	R	0	0	0	0	16.7965017	-92.0312478	t
34662	84	0221	Emiliano Zapata	164904.763	0920244.808	1002	E15D53	R	49	27	22	9	16.8179897	-92.0457800	t
34663	84	0225	Morelia (Vict¢rico Rodolfo Grajales)	164326.345	0915808.742	1246	E15D64	R	1156	604	552	231	16.7239847	-91.9690950	t
34664	84	0226	Rancho Nuevo	164255.616	0915253.993	1207	E15D64	R	23	12	11	5	16.7154489	-91.8816647	t
34665	84	0229	Santo Tom s los Cimientos	164422.339	0915748.000	1448	E15D64	R	68	37	31	15	16.7395386	-91.9633333	t
34666	84	0231	Pusila	163606.142	0914729.274	1235	E15D64	R	371	185	186	56	16.6017061	-91.7914650	t
34667	84	0232	Solo Dios	164226.421	0915156.476	1206	E15D64	R	0	0	0	0	16.7073392	-91.8656878	t
34668	84	0235	San Juan	163806.946	0915248.485	1401	E15D64	R	12	6	6	3	16.6352628	-91.8801347	t
34669	84	0245	Brasil	163738.809	0914910.184	0925	E15D64	R	6	0	0	2	16.6274469	-91.8194956	t
34670	84	0246	Getzeman¡	163100.604	0914632.587	1477	E15D64	R	38	18	20	8	16.5168344	-91.7757186	t
34671	84	0247	Nuevo Tulip n	163055.778	0914546.585	1385	E15D64	R	7	0	0	2	16.5154939	-91.7629403	t
34672	84	0251	La Esperanza	164451.165	0914730.288	1377	E15D64	R	17	10	7	4	16.7475458	-91.7917467	t
34673	84	0256	Santa Rosa	163545.478	0914523.170	0866	E15D64	R	25	12	13	4	16.5959661	-91.7564361	t
34674	84	0257	El Nuevo Jard¡n	163529.696	0914524.947	0904	E15D64	R	166	94	72	27	16.5915822	-91.7569297	t
34675	84	0261	El Arbolito	163017.775	0914539.829	1440	E15D64	R	45	26	19	6	16.5049375	-91.7610636	t
34676	84	0264	Lindavista	163924.277	0914530.204	1114	E15D64	R	6	0	0	1	16.6567436	-91.7583900	t
34677	84	0266	San Jos‚ la Libertad	163352.269	0913932.678	1119	E15D65	R	27	15	12	4	16.5645192	-91.6590772	t
34678	84	0267	El Oriente (Ca¤ada de µlvarez)	163322.194	0913854.355	0861	E15D65	R	42	24	18	6	16.5561650	-91.6484319	t
34679	84	0269	El Zapotal	163250.041	0913756.321	0630	E15D65	R	22	11	11	3	16.5472336	-91.6323114	t
34680	84	0277	Flor de Mayo	163231.380	0913822.690	0685	E15D65	R	25	9	16	5	16.5420500	-91.6396361	t
34681	84	0278	Fracci¢n Quinta el Oriente	163301.965	0913723.606	0626	E15D65	R	23	7	16	4	16.5505458	-91.6232239	t
34682	84	0279	Santa Ana	163154.483	0913652.182	0527	E15D65	R	17	5	12	3	16.5318008	-91.6144950	t
34683	84	0280	San Jos‚ el Oriente	163234.995	0913702.831	0554	E15D65	R	86	39	47	12	16.5430542	-91.6174531	t
34684	84	0281	San Juan del Bosque	163238.514	0913643.902	0609	E15D65	R	36	15	21	6	16.5440317	-91.6121950	t
34685	84	0282	Chenchoj la Cumbre	164700.694	0915512.611	1318	E15D54	R	64	33	31	10	16.7835261	-91.9201697	t
34686	84	0287	La Central	164438.260	0920720.073	1224	E15D63	R	6	0	0	2	16.7439611	-92.1222425	t
34687	84	0288	San Antonio la Pimienta	164446.439	0920704.251	1290	E15D63	R	15	8	7	4	16.7462331	-92.1178475	t
34688	84	0289	San Miguel Chiptic	163711.345	0915928.053	1260	E15D64	R	454	230	224	94	16.6198181	-91.9911258	t
34689	84	0290	San Isidro	163434.805	0915446.697	1487	E15D64	R	27	14	13	9	16.5763347	-91.9129714	t
34690	84	0291	Agua Escondida el Ocotal	163527.031	0913556.899	0676	E15D65	R	169	83	86	31	16.5908419	-91.5991386	t
34691	84	0292	Agua Escondida las Esperanzas	163455.804	0913600.003	0690	E15D65	R	149	78	71	32	16.5821678	-91.6000008	t
34692	84	0293	Agua Escondida la Florinda	163524.188	0913352.521	0347	E15D65	R	147	75	72	26	16.5900522	-91.5645892	t
34693	84	0294	Agua Escondida (Rancho Alegre)	163450.579	0913422.347	0910	E15D65	R	96	48	48	15	16.5807164	-91.5728742	t
34694	84	0296	Las Maravillas	163803.991	0914540.511	0821	E15D64	R	8	0	0	2	16.6344419	-91.7612531	t
34695	84	0298	Laguna el Para¡so	164247.759	0915251.966	1202	E15D64	R	24	12	12	4	16.7132664	-91.8811017	t
34696	84	0303	Italia	163745.715	0915239.763	1420	E15D64	R	0	0	0	0	16.6293653	-91.8777119	t
34697	84	0305	San Isidro	164304.203	0915418.388	1236	E15D64	R	31	14	17	6	16.7178342	-91.9051078	t
34698	84	0311	Linda Vista	163402.935	0914548.026	1271	E15D64	R	12	0	0	2	16.5674819	-91.7633406	t
34699	84	0314	Tres de Mayo	163608.172	0914606.405	0864	E15D64	R	6	0	0	2	16.6022700	-91.7684458	t
34700	84	0317	R¡o Am‚rica	163516.291	0914115.258	1116	E15D64	R	0	0	0	0	16.5878586	-91.6875717	t
34701	84	0325	Las Perlas	164758.285	0920051.827	1281	E15D53	R	83	44	39	17	16.7995236	-92.0143964	t
34702	84	0327	San Jos‚ Bel‚n 2da. Secci¢n	163315.012	0914945.012	1260	E15D64	R	0	0	0	0	16.5541700	-91.8291700	t
34703	84	0329	Villaflores	163312.617	0913757.604	0745	E15D65	R	4	0	0	1	16.5535047	-91.6326678	t
34704	84	0330	Guadalupe	163312.582	0913755.605	0737	E15D65	R	0	0	0	0	16.5534950	-91.6321125	t
34705	84	0342	El Caracol	163236.771	0913826.678	0705	E15D65	R	11	0	0	2	16.5435475	-91.6407439	t
34706	84	0343	El Naranjo	163231.393	0913804.959	0586	E15D65	R	21	0	0	2	16.5420536	-91.6347108	t
34707	84	0351	Aguascalientes	164329.822	0915742.331	1253	E15D64	R	30	15	15	10	16.7249506	-91.9617586	t
34708	84	0352	Primera Ampliaci¢n de Luis Espinosa	163302.873	0913829.241	0738	E15D65	R	0	0	0	0	16.5507981	-91.6414558	t
34709	84	0353	Anexo Monterrey	163919.565	0914636.867	0850	E15D64	R	40	13	27	5	16.6554347	-91.7769075	t
34710	84	0354	Anexo Santa Rita	163302.137	0914245.332	1233	E15D64	R	133	67	66	24	16.5505936	-91.7125922	t
34711	84	0355	Cuauht‚moc	164150.129	0920204.282	1270	E15D63	R	84	42	42	28	16.6972581	-92.0345228	t
34712	84	0356	Diez de Abril	164004.858	0920106.604	1196	E15D63	R	105	53	52	35	16.6680161	-92.0185011	t
34713	84	0357	Diez de Mayo	164024.676	0915224.394	0914	E15D64	R	99	50	49	33	16.6735211	-91.8734428	t
34714	84	0359	Lindavista	164158.179	0915837.608	1211	E15D64	R	74	39	35	16	16.6994942	-91.9771133	t
34715	84	0360	Lucio Caba¤as	163918.961	0915057.314	0822	E15D64	R	39	19	20	13	16.6552669	-91.8492539	t
34716	84	0361	Nueva Esperanza	163840.365	0920030.005	1233	E15D63	R	162	81	81	54	16.6445458	-92.0083347	t
34717	84	0362	La Nueva Reforma	164138.985	0920119.447	1243	E15D63	R	126	63	63	42	16.6941625	-92.0220686	t
34718	84	0364	Nuevo Jerusal‚n	163653.406	0915811.169	1261	E15D64	R	66	33	33	14	16.6148350	-91.9697692	t
34719	84	0365	Nuevo Joaqu¡n Miguel Guti‚rrez	164729.519	0920218.661	1220	E15D53	R	56	29	27	14	16.7915331	-92.0385169	t
34720	84	0366	El Ocotal	164100.570	0915409.963	1062	E15D64	R	123	61	62	20	16.6834917	-91.9027675	t
34721	84	0367	Ocho de Marzo	164121.939	0915018.214	1222	E15D64	R	99	50	49	33	16.6894275	-91.8383928	t
34722	84	0368	Ocho de Octubre	164045.987	0914721.289	1029	E15D64	R	90	45	45	30	16.6794408	-91.7892469	t
34723	84	0369	Primero de Mayo	163731.333	0914740.045	0791	E15D64	R	30	15	15	10	16.6253703	-91.7944569	t
34724	84	0370	Nueva Revoluci¢n	164153.677	0915202.206	0981	E15D64	R	282	141	141	94	16.6982436	-91.8672794	t
34725	84	0371	San Antonio Monterrey	163932.636	0914628.843	0915	E15D64	R	64	41	23	15	16.6590656	-91.7746786	t
34726	84	0372	San Luis Potos¡ Dos	163535.255	0914021.052	1227	E15D64	R	87	47	40	12	16.5931264	-91.6725144	t
34727	84	0373	San Pedro Guerrero	163841.436	0914927.698	0765	E15D64	R	123	62	61	41	16.6448433	-91.8243606	t
34728	84	0374	Sinaloa	163343.920	0913922.305	1040	E15D65	R	41	27	14	6	16.5622000	-91.6561958	t
34729	84	0375	Tierra y Libertad	164032.254	0914657.801	0944	E15D64	R	105	57	48	20	16.6756261	-91.7827225	t
34730	84	0376	Santa Margarita	164850.004	0920119.992	1087	E15D53	R	19	8	11	3	16.8138900	-92.0222200	t
34731	84	0377	12 de Octubre	164301.251	0920257.142	1247	E15D63	R	105	59	46	15	16.7170142	-92.0492061	t
34732	84	0378	El Camalote	163205.950	0913752.926	0741	E15D65	R	0	0	0	0	16.5349861	-91.6313683	t
34733	84	0379	El Jord n	163153.025	0913747.671	0678	E15D65	R	0	0	0	0	16.5313958	-91.6299086	t
34734	84	0380	Monterrey	163211.366	0913833.476	0947	E15D65	R	0	0	0	0	16.5364906	-91.6426322	t
34735	84	0381	7 de Enero	164235.311	0915403.338	0982	E15D64	R	93	47	46	31	16.7098086	-91.9009272	t
34736	84	0382	Buenavista	164243.190	0915657.909	1225	E15D64	R	27	13	14	9	16.7119972	-91.9494192	t
34737	84	0383	Campo Alegre	164246.940	0915830.239	1170	E15D64	R	12	6	6	4	16.7130389	-91.9750664	t
34738	84	0384	El Calvario	163118.577	0914351.560	1257	E15D64	R	52	27	25	9	16.5218269	-91.7309889	t
34739	84	0385	El Carmen	164244.528	0915245.050	1203	E15D64	R	14	7	7	4	16.7123689	-91.8791806	t
34740	84	0386	El Carmen	163245.613	0914259.194	1229	E15D64	R	0	0	0	0	16.5460036	-91.7164428	t
34741	84	0387	La Trinidad	164245.132	0915241.078	1214	E15D64	R	76	38	38	12	16.7125367	-91.8780772	t
34742	84	0388	Las Flores	164243.710	0915244.134	1201	E15D64	R	4	0	0	1	16.7121417	-91.8789261	t
34743	84	0389	Los Tres Hermanos	164249.995	0915251.793	1203	E15D64	R	11	0	0	2	16.7138875	-91.8810536	t
34744	84	0390	Primero de Enero	163852.705	0915034.921	0834	E15D64	R	15	7	8	5	16.6479736	-91.8430336	t
34745	84	0391	Rancho Alegre	164243.678	0915243.126	1201	E15D64	R	11	0	0	2	16.7121328	-91.8786461	t
34746	84	0392	San Isidro	163202.907	0914444.591	1301	E15D64	R	3	0	0	1	16.5341408	-91.7457197	t
34747	84	0393	Tierra y Libertad	163726.216	0915957.089	1258	E15D64	R	0	0	0	0	16.6239489	-91.9991914	t
34748	84	0394	Anexo Nueva Delicias	163657.406	0914721.153	0859	E15D64	R	48	24	24	16	16.6159461	-91.7892092	t
34749	84	0395	Maderas de Altamirano [Aserradero]	164232.719	0920236.170	1257	E15D63	R	0	0	0	0	16.7090886	-92.0433806	t
34750	84	0396	Santa Cruz [Aserradero]	164259.480	0920303.098	1247	E15D63	R	0	0	0	0	16.7165222	-92.0508606	t
34751	84	0397	Bello Para¡so	163337.071	0914355.285	1242	E15D64	R	0	0	0	0	16.5602975	-91.7320236	t
34752	84	0398	El Palomar	164235.458	0920234.216	1258	E15D63	R	0	0	0	0	16.7098494	-92.0428378	t
34753	84	0399	Emiliano Zapata	164236.170	0915650.733	1220	E15D64	R	51	25	26	17	16.7100472	-91.9474258	t
34754	84	0400	Las Nubes	164309.285	0920317.124	1245	E15D63	R	50	22	28	7	16.7192458	-92.0547567	t
34755	84	0401	Los Olivos	163231.636	0913743.463	0559	E15D65	R	0	0	0	0	16.5421211	-91.6287397	t
34756	84	0402	Puyija	164219.076	0920345.775	1271	E15D63	R	14	0	0	2	16.7052989	-92.0627153	t
34757	84	0403	Santa Rosa las Flores	164251.883	0920307.118	1261	E15D63	R	12	6	6	3	16.7144119	-92.0519772	t
34758	84	0404	Santa Rosita	164353.721	0920249.639	1240	E15D63	R	21	0	0	2	16.7315892	-92.0471219	t
34759	84	0405	Villa Para¡so	164228.649	0920233.855	1258	E15D63	R	3	0	0	1	16.7079581	-92.0427375	t
34760	84	0406	Unidad Habitacional 11 CINE	164249.633	0920241.995	1260	E15D63	R	81	45	36	23	16.7137869	-92.0449986	t
34761	84	0407	El Conejito	165030.289	0920146.226	0996	E15D53	R	24	14	10	4	16.8417469	-92.0295072	t
34762	84	0408	Montecristo	164149.326	0915052.535	1220	E15D64	R	10	0	0	2	16.6970350	-91.8479264	t
34763	84	0409	San Caralampio	164129.384	0915029.480	1221	E15D64	R	59	28	31	12	16.6914956	-91.8415222	t
34764	84	0410	Poza Rica	164348.633	0920310.571	1234	E15D63	R	42	21	21	11	16.7301758	-92.0529364	t
34765	84	0411	Villa Jerusal‚n	164307.870	0920245.183	1260	E15D63	R	4	0	0	1	16.7188528	-92.0458842	t
34766	84	0412	Santa Lucia	164402.013	0920622.593	1229	E15D63	R	34	20	14	5	16.7338925	-92.1062758	t
34767	84	0413	Los Gavilanes	164224.219	0920410.085	1342	E15D63	R	13	5	8	3	16.7067275	-92.0694681	t
34768	84	0414	19 de Diciembre	164211.979	0920212.633	1260	E15D63	R	0	0	0	0	16.7033275	-92.0368425	t
34769	84	0415	Nuevo Jord n	163634.300	0915639.100	1376	E15D64	R	0	0	0	0	16.6095278	-91.9441944	t
34770	84	0416	Flor de Mayo	163105.242	0914437.165	1299	E15D64	R	0	0	0	0	16.5181228	-91.7436569	t
34771	84	0417	Nazaret	162953.561	0914553.952	1783	E15D74	R	0	0	0	0	16.4982114	-91.7649867	t
34772	84	0418	Nueva Delicias	163704.261	0914716.223	0823	E15D64	R	0	0	0	0	16.6178503	-91.7878397	t
34773	84	0419	Bello Para¡so	164244.758	0915246.014	1203	E15D64	R	0	0	0	0	16.7124328	-91.8794483	t
34774	84	0420	San Antonio las Delicias Pach n	163718.910	0914651.661	0773	E15D64	R	0	0	0	0	16.6219194	-91.7810169	t
34775	84	0421	Buena Vista	163652.491	0914738.116	0901	E15D64	R	0	0	0	0	16.6145808	-91.7939211	t
34776	84	0422	Nuevo Centro Getzeman¡	163040.960	0914607.941	1437	E15D64	R	0	0	0	0	16.5113778	-91.7688725	t
34777	85	0001	Amat n	172222.254	0924908.843	0788	E15D31	U	3947	1995	1952	928	17.3728483	-92.8191231	t
34778	85	0002	Adolfo L¢pez Mateos	172938.388	0925331.013	0111	E15D31	R	220	117	103	42	17.4939967	-92.8919481	t
34779	85	0005	Berl¡n	171713.991	0925029.594	0994	E15D31	R	120	62	58	24	17.2872197	-92.8415539	t
34780	85	0009	El Caj¢n	172420.338	0925053.518	0834	E15D31	R	0	0	0	0	17.4056494	-92.8481994	t
34781	85	0011	El Calvario	171855.029	0925101.404	0802	E15D31	R	851	432	419	152	17.3152858	-92.8503900	t
34782	85	0020	Carmen Jucuma	172347.237	0925437.237	0477	E15D31	R	278	125	153	52	17.3964547	-92.9103436	t
34783	85	0021	Cerro del Zapotal	172425.847	0925417.193	0682	E15D31	R	10	6	4	3	17.4071797	-92.9047758	t
34784	85	0022	Tierra Morada	172106.727	0924851.970	0492	E15D31	R	88	50	38	16	17.3518686	-92.8144361	t
34785	85	0023	El Cerrito Puyacatengo	172511.076	0925338.895	0472	E15D31	R	34	20	14	7	17.4197433	-92.8941375	t
34786	85	0024	Constituci¢n	172721.120	0925245.286	0445	E15D31	R	212	119	93	41	17.4558667	-92.8792461	t
34787	85	0026	El Chinal	172843.272	0925205.026	0465	E15D31	R	64	33	31	11	17.4786867	-92.8680628	t
34788	85	0029	Emiliano Zapata	172007.297	0924556.959	0638	E15D31	R	266	131	135	46	17.3353603	-92.7658219	t
34789	85	0030	Escal¢n	172222.601	0924947.571	0684	E15D31	R	14	0	0	1	17.3729447	-92.8298808	t
34790	85	0032	La Esperanza	171847.180	0924759.945	0697	E15D31	R	552	272	280	106	17.3131056	-92.7999847	t
34791	85	0033	Esquipulas	172114.554	0924615.638	0345	E15D31	R	174	87	87	29	17.3540428	-92.7710106	t
34792	85	0036	Estrella	171713.264	0924840.610	0504	E15D31	R	13	0	0	1	17.2870178	-92.8112806	t
34793	85	0040	Francisco I. Madero	172626.458	0925505.572	0501	E15D31	R	588	305	283	119	17.4406828	-92.9182144	t
34794	85	0041	Guadalupe Victoria	172207.870	0925219.891	0375	E15D31	R	682	334	348	142	17.3688528	-92.8721919	t
34795	85	0047	El Lim¢n	171832.087	0924910.243	0578	E15D31	R	497	238	259	97	17.3089131	-92.8195119	t
34796	85	0048	Lindavista	172423.267	0924857.230	0535	E15D31	R	102	57	45	25	17.4064631	-92.8158972	t
34797	85	0050	Congregaci¢n la Loma 2da. Secci¢n	172247.650	0924739.924	0673	E15D31	R	261	143	118	66	17.3799028	-92.7944233	t
34798	85	0055	Mazatl n	172456.606	0925326.093	0611	E15D31	R	15	7	8	3	17.4157239	-92.8905814	t
34799	85	0056	Miguel Hidalgo	172820.526	0925441.918	0324	E15D31	R	154	89	65	25	17.4723683	-92.9116439	t
34800	85	0057	El Mirador (Berl¡n)	171701.660	0925038.676	0951	E15D31	R	312	163	149	56	17.2837944	-92.8440767	t
34801	85	0058	Monterrey	172430.393	0925309.967	0691	E15D31	R	18	9	9	3	17.4084425	-92.8861019	t
34802	85	0059	Morelia	172126.721	0924617.016	0247	E15D31	R	383	197	186	77	17.3574225	-92.7713933	t
34803	85	0061	El Naranjo 2da. Secci¢n	172307.294	0924754.347	0597	E15D31	R	295	135	160	75	17.3853594	-92.7984297	t
34804	85	0067	El Porvenir Tres Picos	172024.564	0925205.164	0811	E15D31	R	580	286	294	115	17.3401567	-92.8681011	t
34805	85	0069	San Jos‚ Puyacatengo	172600.014	0925350.579	0566	E15D31	R	183	100	83	32	17.4333372	-92.8973831	t
34806	85	0072	Rancho Alegre	172435.466	0925310.587	0678	E15D31	R	20	12	8	4	17.4098517	-92.8862742	t
34807	85	0074	El Recibimiento	172322.491	0924946.654	0964	E15D31	R	6	0	0	2	17.3895808	-92.8296261	t
34808	85	0075	Reforma y Planada	172313.675	0925158.137	0426	E15D31	R	1156	592	564	243	17.3871319	-92.8661492	t
34809	85	0077	El Remolino	172048.407	0925035.109	0339	E15D31	R	93	47	46	18	17.3467797	-92.8430858	t
34810	85	0081	Rosario 1ra. Secci¢n	172526.752	0925506.133	0502	E15D31	R	107	54	53	18	17.4240978	-92.9183703	t
34811	85	0088	San Antonio Tres Picos	171918.809	0925148.703	0763	E15D31	R	929	483	446	181	17.3218914	-92.8635286	t
34812	85	0091	San Fernando	171715.857	0924903.585	0523	E15D31	R	146	74	72	23	17.2877381	-92.8176625	t
34813	85	0094	San Jos‚ (Bartolo)	172317.206	0925408.492	0450	E15D31	R	21	9	12	4	17.3881128	-92.9023589	t
34814	85	0096	Sonora	172443.978	0925208.024	0548	E15D31	R	177	90	87	29	17.4122161	-92.8688956	t
34815	85	0098	San Lorenzo	172229.173	0925512.483	0557	E15D31	R	690	339	351	130	17.3747703	-92.9201342	t
34816	85	0102	San Sebasti n	172422.820	0924949.116	0841	E15D31	R	78	39	39	17	17.4063389	-92.8303100	t
34817	85	0103	Santa Cruz el Azufre	172726.719	0925530.049	0480	E15D31	R	179	87	92	35	17.4574219	-92.9250136	t
34818	85	0105	Sumidero	172213.699	0924818.933	0527	E15D31	R	51	31	20	14	17.3704719	-92.8052592	t
34819	85	0113	Valent¡n de la Sierra	172520.917	0925157.660	0649	E15D31	R	128	61	67	26	17.4224769	-92.8660167	t
34820	85	0114	Villaflores	172449.199	0925326.718	0626	E15D31	R	0	0	0	0	17.4136664	-92.8907550	t
34821	85	0115	Villa Luz	172400.492	0925245.591	0618	E15D31	R	116	60	56	18	17.4001367	-92.8793308	t
34822	85	0116	Nanchital	172423.554	0925239.620	0812	E15D31	R	92	41	51	16	17.4065428	-92.8776722	t
34823	85	0118	Chaspa	172328.079	0924925.073	0823	E15D31	R	106	59	47	23	17.3911331	-92.8236314	t
34824	85	0120	Flor del R¡o	172230.534	0924607.126	0056	E15D31	R	129	66	63	25	17.3751483	-92.7686461	t
34825	85	0121	El Retiro	172045.726	0924527.728	0462	E15D31	R	227	117	110	48	17.3460350	-92.7577022	t
34826	85	0122	Los Olivares	172122.033	0924600.311	0237	E15D31	R	130	63	67	28	17.3561203	-92.7667531	t
34827	85	0123	Acapulco	172448.292	0925140.666	0862	E15D31	R	65	30	35	12	17.4134144	-92.8612961	t
34828	85	0125	El Para¡so	172709.636	0925342.699	0422	E15D31	R	33	17	16	7	17.4526767	-92.8951942	t
34829	85	0137	San Antonio	172605.840	0925152.032	0439	E15D31	R	14	0	0	2	17.4349556	-92.8644533	t
34830	85	0144	La Concordia	172937.176	0925303.302	0210	E15D31	R	4	0	0	1	17.4936600	-92.8842506	t
34831	85	0146	San Jos‚ la Loma	172753.835	0925258.369	0445	E15D31	R	87	47	40	14	17.4649542	-92.8828803	t
34832	85	0150	Rosario 2da. Secci¢n	172553.722	0925442.155	0634	E15D31	R	97	52	45	14	17.4315894	-92.9117097	t
34833	85	0153	Esmeralda	172813.008	0925106.012	0631	E15D31	R	0	0	0	0	17.4702800	-92.8516700	t
34834	85	0154	Lindavista (Palestina)	172155.008	0925505.016	0420	E15D31	R	23	10	13	3	17.3652800	-92.9180600	t
34835	85	0157	Zapotal	172109.000	0924819.008	0491	E15D31	R	0	0	0	0	17.3525000	-92.8052800	t
34836	85	0158	Escal¢n 1ra. Fracci¢n (El Baril)	172319.260	0925045.602	0800	E15D31	R	256	131	125	49	17.3886833	-92.8460006	t
34837	85	0160	El Platanar	172122.918	0924808.317	0285	E15D31	R	38	19	19	9	17.3563661	-92.8023103	t
34838	85	0161	Piedra Redonda	172343.371	0924714.271	0511	E15D31	R	0	0	0	0	17.3953808	-92.7872975	t
34839	85	0164	San Jos‚ Buenavista	172116.194	0925121.890	0567	E15D31	R	204	99	105	40	17.3544983	-92.8560806	t
34840	85	0165	La Gloria	172134.992	0925230.000	0646	E15D31	R	0	0	0	0	17.3597200	-92.8750000	t
34841	85	0167	El Naranjo 1ra.	172120.660	0925037.373	0477	E15D31	R	0	0	0	0	17.3557389	-92.8437147	t
34842	85	0169	Piedra Blanca	171926.110	0925030.851	0913	E15D31	R	384	188	196	66	17.3239194	-92.8419031	t
34843	85	0170	Nuevo Ter n	171948.922	0925137.858	0650	E15D31	R	215	109	106	40	17.3302561	-92.8605161	t
34844	85	0171	Arroyo Seco	171930.192	0924844.019	0388	E15D31	R	66	33	33	12	17.3250533	-92.8122275	t
34845	85	0172	Buenos Aires (Limoncito)	171908.592	0924942.994	0748	E15D31	R	81	38	43	16	17.3190533	-92.8286094	t
34846	85	0173	Las Gardenias	172131.190	0924918.234	0628	E15D31	R	15	0	0	2	17.3586639	-92.8217317	t
34847	85	0175	Lonch‚n	171822.023	0924940.628	0728	E15D31	R	39	19	20	11	17.3061175	-92.8279522	t
34848	85	0178	Nueva Estrella	171743.451	0924906.534	0589	E15D31	R	167	88	79	34	17.2954031	-92.8184817	t
34849	85	0179	Francisco Villa	171920.789	0924930.866	0738	E15D31	R	201	106	95	35	17.3224414	-92.8252406	t
34850	85	0180	San Andr‚s	171939.000	0924603.000	0581	E15D31	R	149	86	63	27	17.3275000	-92.7675000	t
34851	85	0182	Cerro Blanco	172018.459	0925000.009	0327	E15D31	R	317	156	161	50	17.3384608	-92.8333358	t
34852	85	0183	Tres Hermanos	172239.420	0924923.043	0924	E15D31	R	1	0	0	1	17.3776167	-92.8230675	t
34853	85	0184	Las Delicias	172319.325	0924923.783	0864	E15D31	R	0	0	0	0	17.3887014	-92.8232731	t
34854	85	0187	San Carlos	172921.094	0925221.133	0259	E15D31	R	0	0	0	0	17.4891928	-92.8725369	t
34855	85	0188	San Antonio	172524.735	0925221.533	0562	E15D31	R	0	0	0	0	17.4235375	-92.8726481	t
34856	85	0190	Morelos	172409.464	0925340.074	0698	E15D31	R	41	18	23	7	17.4026289	-92.8944650	t
34857	85	0193	La Maravilla	172432.959	0925301.134	0557	E15D31	R	13	0	0	2	17.4091553	-92.8836483	t
34858	85	0195	La Guadalupe	172906.136	0925201.204	0422	E15D31	R	22	13	9	3	17.4850378	-92.8670011	t
34859	85	0197	San Lorenzo	172914.727	0925233.189	0287	E15D31	R	9	0	0	1	17.4874242	-92.8758858	t
34860	85	0198	San Felipe	172927.996	0925227.012	0401	E15D31	R	6	0	0	1	17.4911100	-92.8741700	t
34861	85	0199	Cuatro Milpas	172838.465	0925210.601	0459	E15D31	R	0	0	0	0	17.4773514	-92.8696114	t
34862	85	0201	El Carmen	173018.000	0925230.000	0509	E15D21	R	0	0	0	0	17.5050000	-92.8750000	t
34863	85	0202	Primavera	172417.185	0925306.454	0624	E15D31	R	42	20	22	7	17.4047736	-92.8851261	t
34864	85	0204	La Selva	171743.186	0924745.519	1098	E15D31	R	8	0	0	2	17.2953294	-92.7959775	t
34865	85	0207	Anexo las Margaritas (San Mart¡n)	171748.498	0925008.593	0944	E15D31	R	132	61	71	22	17.2968050	-92.8357203	t
34866	85	0209	El Carmen	172312.984	0924815.012	0363	E15D31	R	76	42	34	15	17.3869400	-92.8041700	t
34867	85	0210	El Santuario	172346.080	0925257.716	0592	E15D31	R	10	5	5	3	17.3961333	-92.8826989	t
34868	85	0213	Cerro Colorado	172116.846	0924847.998	0438	E15D31	R	16	8	8	4	17.3546794	-92.8133328	t
34869	85	0214	La Planada (El Palmar)	172038.004	0924740.992	0264	E15D31	R	0	0	0	0	17.3438900	-92.7947200	t
34870	85	0215	La Granja	172042.312	0925100.987	0409	E15D31	R	42	18	24	11	17.3450867	-92.8502742	t
34871	85	0216	Buenavista	172047.229	0925129.335	0580	E15D31	R	218	110	108	44	17.3464525	-92.8581486	t
34872	85	0217	Esquipulas	172357.349	0925242.864	0630	E15D31	R	20	6	14	3	17.3992636	-92.8785733	t
34873	85	0219	La Loma 1ra. Secci¢n	172231.142	0924736.840	0592	E15D31	R	153	86	67	37	17.3753172	-92.7935667	t
34874	85	0220	Nuevo San Lorenzo (La Choza)	172242.311	0924956.320	0728	E15D31	R	200	110	90	41	17.3784197	-92.8323111	t
34875	85	0221	Pueblo Nuevo de la Nueva Constituci¢n	172250.212	0925121.643	0486	E15D31	R	72	41	31	12	17.3806144	-92.8560119	t
34876	85	0222	Santa Cruz	172341.766	0925239.870	0528	E15D31	R	12	6	6	3	17.3949350	-92.8777417	t
34877	85	0223	La Esmeralda	172437.285	0925407.555	0575	E15D31	R	4	0	0	1	17.4103569	-92.9020986	t
34878	85	0225	Adolfo L¢pez Mateos	172918.642	0925342.727	0119	E15D31	R	14	0	0	2	17.4885117	-92.8952019	t
34879	85	0226	Primavera (El Suspiro)	172411.366	0925305.850	0597	E15D31	R	10	0	0	1	17.4031572	-92.8849583	t
34880	85	0230	San Marcos	172858.008	0925245.012	0280	E15D31	R	0	0	0	0	17.4827800	-92.8791700	t
34881	85	0233	San Pedro	172422.530	0925258.365	0679	E15D31	R	4	0	0	1	17.4062583	-92.8828792	t
34882	85	0235	Nuevo Arenal 2da. Secci¢n (La Esperanza)	172822.126	0925255.084	0256	E15D31	R	2	0	0	1	17.4728128	-92.8819678	t
34883	85	0236	La Lomita	172105.069	0925050.801	0471	E15D31	R	62	30	32	15	17.3514081	-92.8474447	t
34884	85	0237	Los M‚ndez	172100.507	0925022.461	0383	E15D31	R	87	50	37	19	17.3501408	-92.8395725	t
34885	85	0238	La Estrella (Miguel Alamilla)	172849.917	0925344.876	0129	E15D31	R	11	7	4	3	17.4805325	-92.8957989	t
34886	85	0239	El Bel‚n	172114.846	0924558.685	0257	E15D31	R	67	32	35	16	17.3541239	-92.7663014	t
34887	85	0240	El Lim¢n 2da. Secci¢n	171831.013	0924949.935	0800	E15D31	R	23	10	13	6	17.3086147	-92.8305375	t
34888	85	0241	Nueva York	172117.613	0924637.358	0475	E15D31	R	66	38	28	14	17.3548925	-92.7770439	t
34889	85	0242	La Candelaria	172342.093	0925326.911	0500	E15D31	R	38	20	18	6	17.3950258	-92.8908086	t
34890	85	0243	La Maravilla	172436.475	0925228.173	0741	E15D31	R	16	7	9	3	17.4101319	-92.8744925	t
34891	85	0244	Nuevo Arenal 1ra. Secci¢n	172915.097	0925350.459	0109	E15D31	R	106	50	56	23	17.4875269	-92.8973497	t
34892	85	0245	Rosario Tercera Secci¢n	172507.533	0925459.016	0469	E15D31	R	92	41	51	15	17.4187592	-92.9163933	t
34893	85	0246	Anexo Amat n	172202.291	0924921.981	0771	E15D31	R	11	6	5	3	17.3673031	-92.8227725	t
34894	85	0247	Francisco I. Madero Ampliaci¢n	172710.607	0925429.766	0253	E15D31	R	31	17	14	8	17.4529464	-92.9082683	t
34895	85	0248	Linda Vista Arroyo Grande	172424.755	0924807.254	0163	E15D31	R	73	38	35	17	17.4068764	-92.8020150	t
34896	85	0249	Morelia 2da. Secci¢n	172128.063	0924619.828	0255	E15D31	R	223	111	112	36	17.3577953	-92.7721744	t
34897	85	0250	Morelos los Ch vez	172323.910	0924705.436	0499	E15D31	R	64	34	30	17	17.3899750	-92.7848433	t
34898	85	0251	Nuevo Acapulco	172708.346	0925400.884	0325	E15D31	R	55	28	27	10	17.4523183	-92.9002456	t
34899	85	0252	El Porvenir Tres Picos 2da. Secci¢n	172019.847	0925207.305	0810	E15D31	R	197	96	101	32	17.3388464	-92.8686958	t
34900	85	0253	San Andr‚s Tres Picos	171928.083	0925158.464	0848	E15D31	R	70	28	42	14	17.3244675	-92.8662400	t
34901	85	0254	Anexo la Loma	172229.812	0924722.250	0583	E15D31	R	90	49	41	18	17.3749478	-92.7895139	t
34902	85	0255	Benito Ju rez	171934.028	0925145.603	0739	E15D31	R	0	0	0	0	17.3261189	-92.8626675	t
34903	85	0256	El Para¡so	172537.304	0925234.040	0438	E15D31	R	34	15	19	5	17.4270289	-92.8761222	t
34904	85	0257	Valent¡n de la Sierra (Secci¢n Buenavista)	172513.663	0925114.956	0888	E15D31	R	39	21	18	10	17.4204619	-92.8541544	t
34905	85	0258	Benito Ju rez	171926.648	0925142.681	0715	E15D31	R	257	132	125	45	17.3240689	-92.8618558	t
34906	85	0259	Los Hern ndez	172858.659	0925451.836	0351	E15D31	R	49	23	26	7	17.4829608	-92.9143989	t
34907	85	0260	Cerro Azul (Rancho)	172329.228	0925337.971	0421	E15D31	R	18	7	11	3	17.3914522	-92.8938808	t
34908	85	0261	San Sebasti n 2da. Secci¢n	172418.974	0924942.121	0846	E15D31	R	61	27	34	11	17.4052706	-92.8283669	t
34909	85	0262	Lindavista 1ra. Secci¢n	172354.774	0924837.735	0427	E15D31	R	100	55	45	21	17.3985483	-92.8104819	t
34910	85	0263	San Miguel Tres Picos	171934.700	0925136.319	0682	E15D31	R	213	116	97	43	17.3263056	-92.8600886	t
34911	85	0264	Lindavista 2da. Secci¢n	172346.190	0924837.890	0498	E15D31	R	0	0	0	0	17.3961639	-92.8105250	t
34912	85	0265	Vida Mejor	171926.297	0925148.907	0765	E15D31	R	0	0	0	0	17.3239714	-92.8635853	t
34913	85	0266	La Loma el Llano	172242.037	0924713.450	0638	E15D31	R	0	0	0	0	17.3783436	-92.7870694	t
34914	86	0001	Amatenango de la Frontera	152606.038	0920654.568	0870	D15B33	U	781	369	412	172	15.4350106	-92.1151578	t
34915	86	0002	Aguacatillo	153559.045	0920154.175	1126	D15B23	R	439	208	231	96	15.5997347	-92.0317153	t
34916	86	0003	Barrio Nuevo	152622.517	0920659.463	0875	D15B33	R	155	76	79	34	15.4395881	-92.1165175	t
34917	86	0004	Buenavista	153701.310	0920333.669	1082	D15B23	R	428	223	205	109	15.6170306	-92.0593525	t
34918	86	0006	Carrizalito	152426.034	0920808.209	1283	D15B33	R	126	58	68	23	15.4072317	-92.1356136	t
34919	86	0009	Cerro Ca¤¢n	153754.147	0920028.791	0698	D15B23	R	24	14	10	7	15.6317075	-92.0079975	t
34920	86	0010	Cinco de Mayo	153648.212	0920637.908	1006	D15B23	R	89	43	46	15	15.6133922	-92.1105300	t
34921	86	0011	Chiquisbil	152635.077	0920810.587	1517	D15B33	R	285	136	149	48	15.4430769	-92.1362742	t
34922	86	0012	Escobillal	153215.326	0920825.247	1288	D15B23	R	366	168	198	59	15.5375906	-92.1403464	t
34923	86	0013	Francisco I. Madero	153052.615	0920520.298	1543	D15B23	R	740	350	390	149	15.5146153	-92.0889717	t
34924	86	0014	Guadalupe Victoria	153626.186	0920352.545	1224	D15B23	R	1541	743	798	405	15.6072739	-92.0645958	t
34925	86	0015	Hoja Blanca	153347.761	0920206.310	1281	D15B23	R	85	47	38	17	15.5632669	-92.0350861	t
34926	86	0016	Huixquilar	153648.853	0920407.179	1282	D15B23	R	302	154	148	78	15.6135703	-92.0686608	t
34927	86	0017	Sabinalito	152458.614	0920834.938	0959	D15B33	R	338	166	172	54	15.4162817	-92.1430383	t
34928	86	0018	La Laguna	153509.996	0920449.008	1125	D15B23	R	14	0	0	2	15.5861100	-92.0802800	t
34929	86	0019	El Lim¢n	152520.271	0920725.752	0903	D15B33	R	126	69	57	22	15.4222975	-92.1238200	t
34930	86	0021	Las Mar¡as	153223.046	0920300.748	1209	D15B23	R	182	89	93	32	15.5397350	-92.0502078	t
34931	86	0022	La Mesilla	153304.943	0920943.406	1456	D15B23	R	48	21	27	9	15.5513731	-92.1620572	t
34932	86	0023	M‚xico Nuevo	152745.840	0920635.837	0942	D15B33	R	126	64	62	28	15.4627333	-92.1099547	t
34933	86	0024	Los Mezcales	153528.154	0920200.414	1479	D15B23	R	43	21	22	8	15.5911539	-92.0334483	t
34934	86	0025	Mira Morelia	153455.067	0920126.166	1759	D15B23	R	134	70	64	28	15.5819631	-92.0239350	t
34935	86	0026	La Monta¤a	153421.325	0921117.539	1526	D15B23	R	560	264	296	93	15.5725903	-92.1882053	t
34936	86	0027	Monte Florido	153143.174	0920449.131	1324	D15B23	R	0	0	0	0	15.5286594	-92.0803142	t
34937	86	0028	Monte Ord¢¤ez	153350.433	0921029.343	1477	D15B23	R	519	255	264	99	15.5640092	-92.1748175	t
34938	86	0029	Monte Verde	153752.260	0920526.670	0802	D15B23	R	357	178	179	76	15.6311833	-92.0907417	t
34939	86	0030	Monumento los Pilatos	153155.147	0920309.528	1465	D15B23	R	30	14	16	3	15.5319853	-92.0526467	t
34940	86	0031	Naranjal	152948.935	0920525.497	1063	D15B33	R	199	108	91	38	15.4969264	-92.0904158	t
34941	86	0032	Nueva Am‚rica	152817.383	0920519.446	1703	D15B33	R	177	92	85	33	15.4714953	-92.0887350	t
34942	86	0033	Nueva Morelia	153659.621	0920840.347	0659	D15B23	R	1032	502	530	232	15.6165614	-92.1445408	t
34943	86	0034	Nuevo Amatenango	153032.310	0920634.960	0861	D15B23	R	1594	769	825	353	15.5089750	-92.1097111	t
34944	86	0036	Ojo de Agua	153617.143	0920324.469	1173	D15B23	R	390	188	202	90	15.6047619	-92.0567969	t
34945	86	0037	Ojo de Agua las Cruces	153506.826	0920211.240	1446	D15B23	R	382	185	197	78	15.5852294	-92.0364556	t
34946	86	0038	El Pacayal	153552.934	0920228.809	1037	D15B23	U	3045	1500	1545	750	15.5980372	-92.0413358	t
34947	86	0039	Pacayalito	153546.778	0920534.111	0885	D15B23	R	725	354	371	157	15.5963272	-92.0928086	t
34948	86	0040	Pe¤a Bermeja	153805.050	0920409.840	0953	D15B23	R	117	59	58	24	15.6347361	-92.0694000	t
34949	86	0041	El Pino	152800.524	0920524.087	1442	D15B33	R	133	73	60	26	15.4668122	-92.0900242	t
34950	86	0042	Plan Grande	153558.137	0920131.305	1213	D15B23	R	345	157	188	78	15.5994825	-92.0253625	t
34951	86	0043	Platanillo	152841.968	0920544.806	1621	D15B33	R	153	77	76	30	15.4783244	-92.0957794	t
34952	86	0044	Potrerillo	153751.348	0920112.531	0713	D15B23	R	2062	1003	1059	522	15.6309300	-92.0201475	t
34953	86	0045	Nueva Providencia	153614.882	0920108.756	1041	D15B23	R	498	251	247	101	15.6041339	-92.0190989	t
34954	86	0046	La Pureza	153452.836	0921003.986	0730	D15B23	R	181	91	90	37	15.5813433	-92.1677739	t
34955	86	0047	Nuevo Bel‚n	152931.134	0920545.049	1269	D15B33	R	196	89	107	32	15.4919817	-92.0958469	t
34956	86	0048	Regadillo	153404.369	0920852.194	0692	D15B23	R	273	128	145	62	15.5678803	-92.1478317	t
34957	86	0049	La Rinconada	153011.749	0920443.268	1625	D15B23	R	426	219	207	80	15.5032636	-92.0786856	t
34958	86	0050	R¡o Guerrero	153458.150	0920928.069	0683	D15B23	R	939	449	490	211	15.5828194	-92.1577969	t
34959	86	0051	San Jer¢nimo	153813.271	0920313.288	0729	D15B23	R	189	89	100	45	15.6370197	-92.0536911	t
34960	86	0053	Sonora	153238.200	0920846.278	1121	D15B23	R	156	82	74	31	15.5439444	-92.1461883	t
34961	86	0054	Tapitzal  N£mero Dos	153416.872	0920907.479	0695	D15B23	R	407	197	210	80	15.5713533	-92.1520775	t
34962	86	0055	Veinte de Noviembre	153343.575	0920438.828	1014	D15B23	R	954	482	472	169	15.5621042	-92.0774522	t
34963	86	0056	Zacatonal	153425.946	0921047.829	1169	D15B23	R	118	59	59	26	15.5738739	-92.1799525	t
34964	86	0058	La Carpa San Jos‚ Obrero	153652.241	0920351.772	1185	D15B23	R	54	30	24	16	15.6145114	-92.0643811	t
34965	86	0059	Flor de Mayo	153549.228	0920558.124	0855	D15B23	R	268	131	137	64	15.5970078	-92.0994789	t
34966	86	0060	Santo Domingo	153729.043	0920513.367	0814	D15B23	R	30	13	17	6	15.6247342	-92.0870464	t
34967	86	0061	La Jushtalada	153640.889	0920534.848	0981	D15B23	R	0	0	0	0	15.6113581	-92.0930133	t
34968	86	0063	La Lagunita	152913.780	0920607.980	1463	D15B33	R	389	192	197	65	15.4871611	-92.1022167	t
34969	86	0064	Granadillal	152925.599	0920509.662	1347	D15B33	R	8	0	0	2	15.4904442	-92.0860172	t
34970	86	0065	El Tabl¢n Chiquito (Desv¡o los Ram¡rez)	152842.620	0920702.500	0820	D15B33	R	48	26	22	7	15.4785056	-92.1173611	t
34971	86	0067	El Zapote	153213.743	0920911.292	1293	D15B23	R	74	39	35	13	15.5371508	-92.1531367	t
34972	86	0069	San Vicente	153133.255	0920635.021	0853	D15B23	R	7	4	3	3	15.5259042	-92.1097281	t
34973	86	0071	Santa Isabel	153111.304	0920525.142	1461	D15B23	R	2	0	0	1	15.5198067	-92.0903172	t
34974	86	0072	San Jos‚	152717.568	0920625.770	0868	D15B33	R	145	70	75	26	15.4548800	-92.1071583	t
34975	86	0074	Palestina	153203.219	0920700.016	0890	D15B23	R	313	155	158	62	15.5342275	-92.1166711	t
34976	86	0075	Huntaj	153229.449	0920723.390	0728	D15B23	R	0	0	0	0	15.5415136	-92.1231639	t
34977	86	0076	Santa Ana	153313.886	0920426.951	0961	D15B23	R	16	7	9	3	15.5538572	-92.0741531	t
34978	86	0077	El Chorro	153201.061	0920316.769	1498	D15B23	R	44	23	21	11	15.5336281	-92.0546581	t
34979	86	0078	El Retiro	153250.655	0920332.994	1082	D15B23	R	271	143	128	45	15.5474042	-92.0591650	t
34980	86	0079	El Zapotal	153656.958	0920044.619	0781	D15B23	R	357	173	184	87	15.6158217	-92.0123942	t
34981	86	0080	El Ba¤adero	153223.958	0920914.919	1159	D15B23	R	118	55	63	21	15.5399883	-92.1541442	t
34982	86	0082	San Antonio la Junta	153350.314	0920411.018	1122	D15B23	R	17	8	9	4	15.5639761	-92.0697272	t
34983	86	0085	Granadillal Guanajuato	153719.546	0920747.084	0723	D15B23	R	208	105	103	37	15.6220961	-92.1297456	t
34984	86	0086	Vueltaminas	153744.905	0915941.264	0718	D15B24	R	30	14	16	6	15.6291403	-91.9947956	t
34985	86	0087	Las Grutas	153610.185	0920752.252	0703	D15B23	R	39	20	19	9	15.6028292	-92.1311811	t
34986	86	0088	El Relicario	153348.200	0920533.161	0912	D15B23	R	23	15	8	5	15.5633889	-92.0925447	t
34987	86	0089	Nuevo Florida No. 11	153304.369	0920553.845	1279	D15B23	R	7	0	0	2	15.5512136	-92.0982903	t
34988	86	0090	Villa Hidalgo	153639.349	0920211.169	0873	D15B23	R	299	145	154	68	15.6109303	-92.0364358	t
34989	86	0094	Altamirano	153519.703	0920236.713	1212	D15B23	R	277	133	144	65	15.5888064	-92.0435314	t
34990	86	0095	Bienestar Social	153607.304	0920636.183	0772	D15B23	R	110	52	58	30	15.6020289	-92.1100508	t
34991	86	0097	Caracol	152750.781	0920659.543	0810	D15B33	R	37	17	20	7	15.4641058	-92.1165397	t
34992	86	0098	Nueva Victoria	153230.743	0920716.017	0770	D15B23	R	284	144	140	50	15.5418731	-92.1211158	t
34993	86	0099	Nueva Libertad	153611.331	0920649.628	0746	D15B23	R	264	124	140	48	15.6031475	-92.1137856	t
34994	86	0101	San Marcos	153709.177	0920405.129	1259	D15B23	R	69	39	30	16	15.6192158	-92.0680914	t
34995	86	0108	Zacualp n	153453.316	0921137.081	1262	D15B23	R	35	20	15	5	15.5814767	-92.1936336	t
34996	86	0109	Nueva Esperanza	153329.618	0920423.721	1008	D15B23	R	0	0	0	0	15.5582272	-92.0732558	t
34997	86	0110	San Jos‚ de los Pozos	153152.973	0920346.936	1927	D15B23	R	31	13	18	7	15.5313814	-92.0630378	t
34998	86	0111	Coyegual	153540.115	0920404.334	1252	D15B23	R	0	0	0	0	15.5944764	-92.0678706	t
34999	86	0114	Granadillal Uno	153734.436	0920830.582	0664	D15B23	R	147	65	82	30	15.6262322	-92.1418283	t
35000	86	0115	Ojo de Agua el Sabino	153654.670	0920018.328	0840	D15B23	R	57	26	31	13	15.6151861	-92.0050911	t
35001	86	0116	Barrio Nuevo	153722.987	0920038.418	0708	D15B23	R	41	22	19	6	15.6230519	-92.0106717	t
35002	86	0117	Nueva Esperanza	153501.338	0920237.122	1367	D15B23	R	96	50	46	21	15.5837050	-92.0436450	t
35003	86	0118	El Progreso	153538.841	0920237.003	1082	D15B23	R	290	134	156	67	15.5941225	-92.0436119	t
35004	86	0119	Nuevo Ocotal	153407.617	0920656.322	0809	D15B23	R	76	35	41	14	15.5687825	-92.1156450	t
35005	86	0120	Calera	153224.657	0920819.545	1240	D15B23	R	76	40	36	12	15.5401825	-92.1387625	t
35006	86	0122	Agua Escondida	153327.409	0921102.917	2130	D15B23	R	34	17	17	5	15.5576136	-92.1841436	t
35007	86	0123	San Cristobalito	153727.124	0920142.586	0724	D15B23	R	34	17	17	8	15.6242011	-92.0284961	t
35008	86	0124	Nueva Esperanza	153350.187	0920837.081	0729	D15B23	R	67	28	39	13	15.5639408	-92.1436336	t
35009	86	0126	Guadalupe	153217.486	0920522.291	1204	D15B23	R	4	0	0	1	15.5381906	-92.0895253	t
35010	86	0128	El Macoyal	153547.524	0920442.756	1164	D15B23	R	0	0	0	0	15.5965344	-92.0785433	t
35011	86	0129	Miguel Hidalgo	153047.179	0920544.430	1482	D15B23	R	767	371	396	148	15.5131053	-92.0956750	t
35012	86	0132	Potrerillo	153820.595	0920051.261	0686	D15B23	R	0	0	0	0	15.6390542	-92.0142392	t
35013	86	0133	Nuevo Recuerdo	153300.357	0920741.651	0711	D15B23	R	395	196	199	81	15.5500992	-92.1282364	t
35014	86	0136	Nogales	152815.576	0920656.445	0772	D15B33	R	93	43	50	16	15.4709933	-92.1156792	t
35015	86	0137	Altamirano	152600.952	0920830.344	1709	D15B33	R	83	39	44	15	15.4335978	-92.1417622	t
35016	86	0138	Los µngeles	153414.949	0920716.436	0787	D15B23	R	140	69	71	24	15.5708192	-92.1212322	t
35017	86	0139	Buenos Aires	152801.350	0920659.255	0879	D15B33	R	40	20	20	5	15.4670417	-92.1164597	t
35018	86	0140	Las Cruces	153440.278	0920230.276	1614	D15B23	R	55	27	28	16	15.5778550	-92.0417433	t
35019	86	0141	La Despedida	153359.626	0920625.670	0825	D15B23	R	7	0	0	1	15.5665628	-92.1071306	t
35020	86	0142	Guanajuatillo	153701.058	0920602.521	0894	D15B23	R	8	0	0	2	15.6169606	-92.1007003	t
35021	86	0143	Guadalupe	153054.106	0920644.314	0900	D15B23	R	26	13	13	3	15.5150294	-92.1123094	t
35022	86	0144	El Nancito	153737.440	0920056.421	0721	D15B23	R	134	61	73	30	15.6270667	-92.0156725	t
35023	86	0145	Loma Bonita	153152.740	0920554.347	1262	D15B23	R	4	0	0	1	15.5313167	-92.0984297	t
35024	86	0146	La Playa	153451.130	0920938.918	0683	D15B23	R	102	46	56	19	15.5808694	-92.1608106	t
35025	86	0147	Pueblo Nuevo	153321.584	0920826.066	0708	D15B23	R	7	0	0	1	15.5559956	-92.1405739	t
35026	86	0148	Rancho Alegre	153106.018	0920621.997	1100	D15B23	R	18	12	6	3	15.5183383	-92.1061103	t
35027	86	0149	San Mart¡n	153601.846	0920619.194	0799	D15B23	R	62	31	31	10	15.6005128	-92.1053317	t
35028	86	0150	Nueva Independencia	152753.443	0920613.759	1085	D15B33	R	17	9	8	3	15.4648453	-92.1038219	t
35029	86	0151	Ojo de Agua (El Mango)	153625.992	0920726.004	0900	D15B23	R	0	0	0	0	15.6072200	-92.1238900	t
35030	86	0152	Vado Real	152803.457	0920631.580	1037	D15B33	R	54	28	26	10	15.4676269	-92.1087722	t
35031	86	0153	San Isidro	153506.000	0920251.000	1325	D15B23	R	3	0	0	1	15.5850000	-92.0475000	t
35032	86	0154	Nueva Palestina	153202.539	0920623.062	1075	D15B23	R	4	0	0	1	15.5340386	-92.1064061	t
35033	86	0156	Loma Real	153732.413	0920807.044	0700	D15B23	R	26	12	14	6	15.6256703	-92.1352900	t
35034	86	0157	El Zapotal	153000.019	0920556.371	0964	D15B23	R	177	89	88	36	15.5000053	-92.0989919	t
35035	86	0158	Nuevo Michoac n	153642.230	0920844.680	0667	D15B23	R	0	0	0	0	15.6117306	-92.1457444	t
35036	87	0001	Amatenango del Valle	163142.605	0922607.766	1810	E15D62	U	4661	2194	2467	1120	16.5285014	-92.4354906	t
35037	87	0006	La Granada	163209.616	0922637.181	1820	E15D62	R	6	0	0	1	16.5360044	-92.4436614	t
35038	87	0012	El Madronal	163044.123	0922612.632	1830	E15D62	R	550	253	297	118	16.5122564	-92.4368422	t
35039	87	0013	La Merced	163255.024	0922023.207	2378	E15D62	R	217	115	102	39	16.5486178	-92.3397797	t
35040	87	0019	El Rosario	163020.852	0922125.178	2160	E15D62	R	4	0	0	1	16.5057922	-92.3569939	t
35041	87	0023	San Antonio Buenavista	163203.826	0922040.393	2252	E15D62	R	104	46	58	17	16.5343961	-92.3445536	t
35042	87	0028	San Miguel el Alto	162942.124	0922132.541	2281	E15D72	R	138	72	66	25	16.4950344	-92.3590392	t
35043	87	0034	San Vicente la Piedra	163306.527	0922311.084	2347	E15D62	R	144	66	78	26	16.5518131	-92.3864122	t
35044	87	0036	Tulanca	163039.990	0922219.950	2086	E15D62	R	119	56	63	18	16.5111083	-92.3722083	t
35045	87	0037	Uni¢n Buenavista	163128.725	0922224.029	2187	E15D62	R	161	75	86	28	16.5246458	-92.3733414	t
35046	87	0038	Yalchit n	163350.488	0922507.870	2199	E15D62	R	5	0	0	1	16.5640244	-92.4188528	t
35047	87	0042	San Gregorio	163145.776	0922123.843	2280	E15D62	R	185	87	98	39	16.5293822	-92.3566231	t
35048	87	0052	Benito Ju rez	162850.129	0922550.180	1739	E15D72	R	188	89	99	32	16.4805914	-92.4306056	t
35049	87	0058	La Gloria	163012.151	0922535.082	1802	E15D62	R	13	4	9	3	16.5033753	-92.4264117	t
35050	87	0059	San Jos‚ la Florecilla	163136.525	0922000.780	2288	E15D62	R	25	11	14	7	16.5268125	-92.3335500	t
35051	87	0060	San Nicol s	163120.433	0922507.018	1913	E15D62	R	12	0	0	2	16.5223425	-92.4186161	t
35052	87	0061	Cruz Quemada	163003.189	0922010.100	2344	E15D62	R	54	31	23	11	16.5008858	-92.3361389	t
35053	87	0062	Candelaria Buenavista	162913.493	0921914.782	2445	E15D73	R	53	27	26	12	16.4870814	-92.3207728	t
35054	87	0064	Rancho Nuevo	162855.241	0922106.292	2144	E15D72	R	180	94	86	43	16.4820114	-92.3517478	t
35055	87	0065	Santa Anita	162855.173	0922023.539	2322	E15D72	R	31	18	13	6	16.4819925	-92.3398719	t
35056	87	0066	San Caralampio Chav¡n	162716.410	0922834.984	0893	E15D72	R	456	231	225	101	16.4545583	-92.4763844	t
35057	87	0068	San Caralampio	162938.667	0922103.159	2192	E15D72	R	124	57	67	21	16.4940742	-92.3508775	t
35058	87	0069	San Ram¢n Buenavista	162825.383	0922009.512	2271	E15D72	R	74	35	39	15	16.4737175	-92.3359756	t
35059	87	0070	San Jos‚ la Reforma	162807.046	0922053.845	2118	E15D72	R	177	93	84	39	16.4686239	-92.3482903	t
35060	87	0072	San Juan del R¡o	162802.659	0921916.231	2278	E15D73	R	38	21	17	11	16.4674053	-92.3211753	t
35061	87	0073	Santiago Buenavista	162923.728	0922016.811	2368	E15D72	R	0	0	0	0	16.4899244	-92.3380031	t
35062	87	0075	San Salvador Buenavista	162907.433	0922001.581	2380	E15D72	R	30	15	15	6	16.4853981	-92.3337725	t
35063	87	0077	San Sebasti n	163014.073	0922007.991	2293	E15D62	R	22	11	11	5	16.5039092	-92.3355531	t
35064	87	0079	Rosario Tzontehuitz	163312.692	0922703.130	1941	E15D62	R	1	0	0	1	16.5535256	-92.4508694	t
35065	87	0081	San Agust¡n	163014.798	0921858.858	2260	E15D63	R	4	0	0	1	16.5041106	-92.3163494	t
35066	87	0082	San Jos‚ Yojul£n	162823.217	0921915.918	2305	E15D73	R	95	52	43	21	16.4731158	-92.3210883	t
35067	87	0084	Guadalupe Porvenir	162834.839	0921932.789	2346	E15D73	R	45	20	25	8	16.4763442	-92.3257747	t
35068	87	0086	Morelia	163038.194	0922008.824	2241	E15D62	R	0	0	0	0	16.5106094	-92.3357844	t
35069	87	0087	San Isidro	163153.133	0922027.585	2242	E15D62	R	9	6	3	4	16.5314258	-92.3409958	t
35070	87	0088	San Jos‚ Cruz Quemada	163035.683	0921954.044	2245	E15D63	R	22	8	14	8	16.5099119	-92.3316789	t
35071	87	0089	Campo Alegre	163032.887	0922218.040	2081	E15D62	R	70	36	34	14	16.5091353	-92.3716778	t
35072	87	0090	Manzanillo	163010.300	0921923.010	2320	E15D63	R	39	19	20	6	16.5028611	-92.3230583	t
35073	87	0091	Rancho Viejo	163027.608	0922208.162	2085	E15D62	R	3	0	0	1	16.5076689	-92.3689339	t
35074	87	0092	San Caralampio Dos	162751.734	0921855.708	2246	E15D73	R	85	41	44	14	16.4643706	-92.3154744	t
35075	87	0093	San Carlos	162952.296	0922018.938	2336	E15D72	R	23	12	11	6	16.4978600	-92.3385939	t
35076	87	0094	La Tejonera	163236.669	0922236.841	2238	E15D62	R	56	26	30	7	16.5435192	-92.3769003	t
35077	87	0095	La Ca¤ada	163156.000	0922645.000	1797	E15D62	R	4	0	0	1	16.5322222	-92.4458333	t
35078	87	0096	Los Cipreses	162958.937	0922017.208	2318	E15D72	R	32	17	15	8	16.4997047	-92.3381133	t
35079	87	0097	Pie del Cerro	163154.122	0922539.175	1851	E15D62	R	12	5	7	3	16.5317006	-92.4275486	t
35080	87	0098	Campo Grande	163033.776	0922300.189	2078	E15D62	R	29	14	15	5	16.5093822	-92.3833858	t
35081	87	0099	Mar¡a Cristina	162953.680	0922115.643	2187	E15D72	R	37	17	20	8	16.4982444	-92.3543453	t
35082	87	0100	El Para¡so	163026.314	0921956.169	2234	E15D63	R	46	19	27	13	16.5073094	-92.3322692	t
35083	87	0101	Nuevo Jerusal‚n	162843.491	0922055.828	2127	E15D72	R	35	16	19	7	16.4787475	-92.3488411	t
35084	87	0102	San Juan del R¡o II	162800.871	0921926.167	2259	E15D73	R	78	40	38	18	16.4669086	-92.3239353	t
35085	87	0103	Monte Sina¡	162853.527	0921939.718	2378	E15D73	R	68	35	33	16	16.4815353	-92.3276994	t
35086	87	0104	San Pedro las Flores	163343.652	0922038.579	2358	E15D62	R	42	22	20	7	16.5621256	-92.3440497	t
35087	87	0105	San Jos‚ la Ventana	163211.503	0922239.773	2250	E15D62	R	44	22	22	8	16.5365286	-92.3777147	t
35088	87	0106	San Isidro Lindavista	162926.334	0921926.718	2431	E15D73	R	49	25	24	9	16.4906483	-92.3240883	t
35089	87	0107	Rancho Alegre	162838.347	0921929.759	2341	E15D73	R	21	8	13	3	16.4773186	-92.3249331	t
35090	87	0108	El Rosario II	163032.417	0922124.554	2168	E15D62	R	0	0	0	0	16.5090047	-92.3568206	t
35091	87	0109	Nuevo Poblado el Sacrificio	163033.580	0922238.480	2098	E15D62	R	0	0	0	0	16.5093278	-92.3773556	t
35092	87	0110	San Fernando las Flores	163346.116	0922040.229	2359	E15D62	R	0	0	0	0	16.5628100	-92.3445081	t
35093	87	0111	San Isidro las Cuevas	163317.021	0922023.661	2402	E15D62	R	0	0	0	0	16.5547281	-92.3399058	t
35094	88	0001	Jaltenango de la Paz (Angel Albino Corzo)	155221.520	0924330.287	0635	D15B11	U	10427	5042	5385	2292	15.8726444	-92.7250797	t
35095	88	0005	Las Chicharras	154414.917	0923840.937	1260	D15B22	R	0	0	0	0	15.7374769	-92.6447047	t
35096	88	0007	Francisco I. Madero	154929.137	0924105.469	0661	D15B11	R	1819	942	877	387	15.8247603	-92.6848525	t
35097	88	0008	Guadalupe Victoria (Yerbasanta)	154911.123	0924313.672	0680	D15B11	R	172	80	92	32	15.8197564	-92.7204644	t
35098	88	0010	Libertad del Pajal	154645.506	0923933.092	0776	D15B12	R	597	291	306	121	15.7793072	-92.6591922	t
35099	88	0011	Liquid mbar	154424.460	0924510.560	1096	D15B21	R	28	11	17	5	15.7401278	-92.7529333	t
35100	88	0013	Monte Grande	154520.175	0924503.050	0957	D15B11	R	106	50	56	24	15.7556042	-92.7508472	t
35101	88	0014	Nueva Colombia	154148.870	0924315.180	1359	D15B21	R	1568	784	784	300	15.6969083	-92.7208833	t
35102	88	0015	Nueva Independencia	154023.081	0923435.116	0847	D15B22	R	1283	637	646	246	15.6730781	-92.5764211	t
35103	88	0016	Nueva Palestina	154824.129	0924502.747	0734	D15B11	U	3475	1772	1703	695	15.8067025	-92.7507631	t
35104	88	0017	San Marcos Ojo de Agua	154617.244	0923914.981	0793	D15B12	R	0	0	0	0	15.7714567	-92.6541614	t
35105	88	0020	Plan de Ayutla	154224.739	0923424.375	0826	D15B22	R	483	255	228	94	15.7068719	-92.5734375	t
35106	88	0023	Quer‚taro	155014.122	0924528.188	0671	D15B11	R	2203	1124	1079	414	15.8372561	-92.7578300	t
35107	88	0025	Salvador Urbina	154651.546	0924859.874	0828	D15B11	R	553	308	245	92	15.7809850	-92.8166317	t
35108	88	0026	San Francisco	155059.602	0924215.292	0640	D15B11	R	265	142	123	58	15.8498894	-92.7042478	t
35109	88	0034	La Victoria	154534.234	0923637.867	1049	D15B12	R	0	0	0	0	15.7595094	-92.6105186	t
35110	88	0037	Flor de Mayo	153812.590	0923523.130	1103	D15B22	R	7	0	0	1	15.6368306	-92.5897583	t
35111	88	0043	Tierra Blanca (Peque¤eces)	154807.205	0924802.677	0775	D15B11	R	22	11	11	3	15.8020014	-92.8007436	t
35112	88	0047	La Tarraya	154059.856	0923132.286	1522	D15B22	R	16	9	7	5	15.6832933	-92.5256350	t
35113	88	0051	Espa¤a	153830.853	0923532.010	1060	D15B22	R	17	8	9	3	15.6419036	-92.5922250	t
35114	88	0052	Los Jazmines	154444.988	0923937.008	1082	D15B22	R	0	0	0	0	15.7458300	-92.6602800	t
35115	88	0058	La Mesita	154829.599	0923802.393	0896	D15B12	R	18	10	8	5	15.8082219	-92.6339981	t
35116	88	0063	La Guardian¡a	155127.035	0924437.766	0632	D15B11	R	3	0	0	1	15.8575097	-92.7438239	t
35117	88	0064	Sayula	154502.205	0923834.017	1017	D15B12	R	0	0	0	0	15.7506125	-92.6427825	t
35118	88	0066	Las Perlas	154452.084	0924231.965	0994	D15B21	R	0	0	0	0	15.7478011	-92.7088792	t
35119	88	0077	Montebello Altamira	154545.123	0923832.440	0914	D15B12	R	410	218	192	72	15.7625342	-92.6423444	t
35120	88	0080	El Porvenir	154622.605	0924438.215	0820	D15B11	R	59	29	30	9	15.7729458	-92.7439486	t
35121	88	0081	Prusia	154257.930	0924738.340	1038	D15B21	R	18	7	11	5	15.7160917	-92.7939833	t
35122	88	0092	Argentina	153831.508	0923601.471	1102	D15B22	R	92	51	41	14	15.6420856	-92.6004086	t
35123	88	0094	El Puerto (El Ce¤ido)	153723.672	0923454.289	1498	D15B22	R	8	0	0	2	15.6232422	-92.5817469	t
35124	88	0095	Santiago	153822.255	0923521.661	1085	D15B22	R	4	0	0	1	15.6395153	-92.5893503	t
35125	88	0098	Buenavista	153810.271	0923557.829	1268	D15B22	R	25	15	10	3	15.6361864	-92.5993969	t
35126	88	0099	Los Patios	154154.512	0923201.437	1133	D15B22	R	0	0	0	0	15.6984756	-92.5337325	t
35127	88	0100	Magnolia	154020.733	0923220.367	1482	D15B22	R	0	0	0	0	15.6724258	-92.5389908	t
35128	88	0101	Tres Estrellas	154030.087	0923314.291	1093	D15B22	R	1	0	0	1	15.6750242	-92.5539697	t
35129	88	0102	Solo Dios	153732.804	0923342.120	1482	D15B22	R	13	0	0	2	15.6257789	-92.5617000	t
35130	88	0104	La Lagunilla	153819.949	0923317.702	1630	D15B22	R	2	0	0	1	15.6388747	-92.5549172	t
35131	88	0105	El Suspiro	154129.004	0923109.012	1224	D15B22	R	0	0	0	0	15.6913900	-92.5191700	t
35132	88	0106	Buenavista	153954.396	0923257.786	1463	D15B22	R	0	0	0	0	15.6651100	-92.5493850	t
35133	88	0129	Santa Mar¡a	155219.217	0924124.920	0620	D15B11	R	11	4	7	3	15.8720047	-92.6902556	t
35134	88	0134	Chiquinillal	154729.900	0923952.871	0721	D15B12	R	233	114	119	47	15.7916389	-92.6646864	t
35135	88	0135	El Achotal	154525.253	0924151.663	0920	D15B11	R	0	0	0	0	15.7570147	-92.6976842	t
35136	88	0136	Las Delicias	154447.450	0924217.286	1156	D15B21	R	0	0	0	0	15.7465139	-92.7048017	t
35137	88	0137	El Per£	154507.341	0924229.751	0983	D15B11	R	1	0	0	1	15.7520392	-92.7082642	t
35138	88	0140	El Retiro	154411.036	0923952.693	1284	D15B22	R	37	22	15	9	15.7363989	-92.6646369	t
35139	88	0141	La Paz	154659.833	0923747.809	0831	D15B12	R	524	283	241	94	15.7832869	-92.6299469	t
35140	88	0142	Medio D¡a	154354.270	0924252.820	1339	D15B21	R	0	0	0	0	15.7317417	-92.7146722	t
35141	88	0143	El Progreso	154542.983	0924156.062	0987	D15B11	R	4	0	0	1	15.7619397	-92.6989061	t
35142	88	0144	Rancho Bonito	154538.950	0924422.413	0980	D15B11	R	0	0	0	0	15.7608194	-92.7395592	t
35143	88	0145	El Mirasol	154519.823	0924341.028	1048	D15B11	R	16	0	0	1	15.7555064	-92.7280633	t
35144	88	0146	Las Brisas	154459.027	0924313.005	1309	D15B21	R	4	0	0	1	15.7497297	-92.7202792	t
35145	88	0147	Berl¡n	154507.209	0924232.399	0985	D15B11	R	0	0	0	0	15.7520025	-92.7089997	t
35146	88	0149	Rancho Bonito	154934.586	0924249.043	0667	D15B11	R	0	0	0	0	15.8262739	-92.7136231	t
35147	88	0150	Arroyo Dulce	154941.622	0924253.280	0657	D15B11	R	0	0	0	0	15.8282283	-92.7148000	t
35148	88	0151	Monte Verde	154658.566	0924311.224	0932	D15B11	R	2	0	0	1	15.7829350	-92.7197844	t
35149	88	0152	Ciro Jovel Ch vez	154656.971	0924322.055	0903	D15B11	R	0	0	0	0	15.7824919	-92.7227931	t
35150	88	0154	Las Palmas	155002.251	0924309.815	0661	D15B11	R	0	0	0	0	15.8339586	-92.7193931	t
35151	88	0155	Los µngeles	153849.057	0923333.569	1552	D15B22	R	0	0	0	0	15.6469603	-92.5593247	t
35152	88	0156	Las Brisas	154105.293	0923122.110	1470	D15B22	R	12	7	5	3	15.6848036	-92.5228083	t
35153	88	0157	San Antonio	153817.487	0923546.819	1231	D15B22	R	25	13	12	4	15.6381908	-92.5963386	t
35154	88	0158	Siete de Octubre	154323.020	0924731.970	1104	D15B21	R	136	78	58	22	15.7230611	-92.7922139	t
35155	88	0159	Los Laureles	154522.536	0924646.404	1392	D15B11	R	1	0	0	1	15.7562600	-92.7795567	t
35156	88	0160	El Potrero (El Arroy¢n)	154613.001	0924518.389	0894	D15B11	R	9	8	1	3	15.7702781	-92.7551081	t
35157	88	0161	Guadalajara	154719.047	0924535.696	0882	D15B11	R	0	0	0	0	15.7886242	-92.7599156	t
35158	88	0162	El Corchal	154608.587	0924615.279	1022	D15B11	R	1	0	0	1	15.7690519	-92.7709108	t
35159	88	0163	Venecia	154557.092	0924624.607	1094	D15B11	R	0	0	0	0	15.7658589	-92.7735019	t
35160	88	0164	La Cruz	154445.280	0924532.770	1060	D15B21	R	0	0	0	0	15.7459111	-92.7591028	t
35161	88	0167	Mezcalapa	154248.562	0924217.687	1617	D15B21	R	0	0	0	0	15.7134894	-92.7049131	t
35162	88	0170	El Retiro	154046.390	0924425.050	1511	D15B21	R	0	0	0	0	15.6795528	-92.7402917	t
35163	88	0182	Brisas de Campo	154334.263	0923413.291	1076	D15B22	R	0	0	0	0	15.7261842	-92.5703586	t
35164	88	0186	Santa Rita	154123.540	0924809.950	1277	D15B21	R	242	115	127	41	15.6898722	-92.8027639	t
35165	88	0187	Buenavista	154455.098	0924656.454	1426	D15B21	R	0	0	0	0	15.7486383	-92.7823483	t
35166	88	0188	El Triunfo	153924.900	0924832.500	1976	D15B21	R	0	0	0	0	15.6569167	-92.8090278	t
35167	88	0190	El Rosario	155201.589	0924141.604	0621	D15B11	R	4	0	0	1	15.8671081	-92.6948900	t
35168	88	0191	El Placer	155204.599	0924119.257	0621	D15B11	R	0	0	0	0	15.8679442	-92.6886825	t
35169	88	0193	El Mangal	155253.600	0924106.733	0600	D15B11	R	0	0	0	0	15.8815556	-92.6852036	t
35170	88	0195	Ojo de Agua	155036.613	0923854.767	1354	D15B12	R	5	0	0	2	15.8435036	-92.6485464	t
35171	88	0561	Elpidio Ram¡rez	155216.812	0924223.270	0605	D15B11	R	1	0	0	1	15.8713367	-92.7064639	t
35172	88	0563	David Aguilar	155119.904	0924257.297	0656	D15B11	R	0	0	0	0	15.8555289	-92.7159158	t
35173	88	0564	Luis G. Hern ndez A.	155147.150	0924224.683	0619	D15B11	R	0	0	0	0	15.8630972	-92.7068564	t
35174	88	0566	Jos‚ Jim‚nez V zquez	155054.740	0924300.640	0664	D15B11	R	0	0	0	0	15.8485389	-92.7168444	t
35175	88	0568	Playa Larga	155046.660	0924300.090	0692	D15B11	R	0	0	0	0	15.8462944	-92.7166917	t
35176	88	0569	Agapito P‚rez	155018.378	0924210.526	0641	D15B11	R	0	0	0	0	15.8384383	-92.7029239	t
35177	88	0572	El Pajarillo	154704.384	0924156.660	0879	D15B11	R	0	0	0	0	15.7845511	-92.6990722	t
35178	88	0574	Las Nubes	154654.573	0924350.464	0979	D15B11	R	4	0	0	1	15.7818258	-92.7306844	t
35179	88	0575	Manuel Albores	154616.994	0924715.933	1320	D15B11	R	10	0	0	2	15.7713872	-92.7877592	t
35180	88	0576	Manuel L¢pez	154614.751	0924629.824	1048	D15B11	R	1	0	0	1	15.7707642	-92.7749511	t
35181	88	0577	El Recuerdo (Segundo Venecia)	154456.236	0924626.735	1290	D15B21	R	0	0	0	0	15.7489544	-92.7740931	t
35182	88	0578	El Progreso	154546.040	0924400.848	0896	D15B11	R	37	18	19	7	15.7627889	-92.7335689	t
35183	88	0579	Agua Escondida	154451.783	0924321.207	1370	D15B21	R	0	0	0	0	15.7477175	-92.7225575	t
35184	88	0580	Los Capulines	154541.296	0924323.442	1001	D15B11	R	0	0	0	0	15.7614711	-92.7231783	t
35185	88	0581	Nueva Italia	154610.774	0924419.986	0904	D15B11	R	0	0	0	0	15.7696594	-92.7388850	t
35186	88	0584	San Antonio Buenavista	154604.008	0924300.012	1468	D15B11	R	0	0	0	0	15.7677800	-92.7166700	t
35187	88	0586	Villahermosa	154513.359	0924329.201	1083	D15B11	R	0	0	0	0	15.7537108	-92.7247781	t
35188	88	0587	La Loma	154527.137	0924327.170	1112	D15B11	R	0	0	0	0	15.7575381	-92.7242139	t
35189	88	0588	Buenos Aires	154425.540	0924318.720	1492	D15B21	R	0	0	0	0	15.7404278	-92.7218667	t
35190	88	0589	San Antonio	154308.070	0924527.530	1331	D15B21	R	0	0	0	0	15.7189083	-92.7576472	t
35191	88	0590	El Casta¤o	154100.640	0924505.550	1568	D15B21	R	0	0	0	0	15.6835111	-92.7515417	t
35192	88	0591	San Mart¡n	154305.890	0924851.680	1312	D15B21	R	0	0	0	0	15.7183028	-92.8143556	t
35193	88	0592	El Talism n	154140.080	0924409.350	1256	D15B21	R	0	0	0	0	15.6944667	-92.7359306	t
35194	88	0594	Las Vegas	154123.342	0924331.129	1221	D15B21	R	0	0	0	0	15.6898172	-92.7253136	t
35195	88	0595	Las Maravillas	154459.409	0924712.216	1380	D15B21	R	14	8	6	5	15.7498358	-92.7867267	t
35196	88	0596	Palo Gordo	153947.988	0924904.008	2064	D15B21	R	0	0	0	0	15.6633300	-92.8177800	t
35197	88	0597	Nuevo Progreso	154605.312	0923845.430	0901	D15B12	R	134	66	68	26	15.7681422	-92.6459528	t
35198	88	0598	Pacayal	154407.396	0923901.506	1257	D15B22	R	0	0	0	0	15.7353878	-92.6504183	t
35199	88	0599	Dos Hermanos	154516.473	0923830.220	0952	D15B12	R	5	0	0	1	15.7545758	-92.6417278	t
35200	88	0600	Rancho Bonito	154413.925	0923811.687	1226	D15B22	R	0	0	0	0	15.7372014	-92.6365797	t
35201	88	0601	La Providencia	154524.859	0923609.988	1163	D15B12	R	0	0	0	0	15.7569053	-92.6027744	t
35202	88	0608	La Florida	154341.560	0923434.600	1166	D15B22	R	0	0	0	0	15.7282111	-92.5762778	t
35203	88	0609	Santana	154410.087	0923419.440	1298	D15B22	R	0	0	0	0	15.7361353	-92.5720667	t
35204	88	0610	Las Nubes	154420.563	0923355.710	1486	D15B22	R	0	0	0	0	15.7390453	-92.5654750	t
35205	88	0611	Las Caba¤as	154425.333	0923356.549	1479	D15B22	R	0	0	0	0	15.7403703	-92.5657081	t
35206	88	0612	La Rinconada	154352.042	0923121.301	1372	D15B22	R	0	0	0	0	15.7311228	-92.5225836	t
35207	88	0613	Pe¤a Blanca	154256.988	0923226.988	1201	D15B22	R	0	0	0	0	15.7158300	-92.5408300	t
35208	88	0615	Los Hern ndez	154336.145	0923351.822	1187	D15B22	R	0	0	0	0	15.7267069	-92.5643950	t
35209	88	0616	Santa Rosa	154013.687	0923316.069	1270	D15B22	R	0	0	0	0	15.6704686	-92.5544636	t
35210	88	0619	Ojo de Agua	153730.791	0923535.934	1619	D15B22	R	70	45	25	9	15.6252197	-92.5933150	t
35211	88	0620	El Refugio	153805.462	0923513.248	1226	D15B22	R	0	0	0	0	15.6348506	-92.5870133	t
35212	88	0621	Jeric¢	153739.774	0923512.941	1377	D15B22	R	23	12	11	4	15.6277150	-92.5869281	t
35213	88	0622	La Rinconada	153829.974	0923504.700	1149	D15B22	R	6	0	0	1	15.6416594	-92.5846389	t
35214	88	0623	Las Maravillas	153759.399	0923513.632	1225	D15B22	R	8	0	0	1	15.6331664	-92.5871200	t
35215	88	0630	La Violeta	154751.907	0924801.149	0774	D15B11	R	0	0	0	0	15.7977519	-92.8003192	t
35216	88	0632	Barrio el 9	154601.537	0924911.478	0882	D15B11	R	73	37	36	11	15.7670936	-92.8198550	t
35217	88	0633	San Joseito	154406.329	0924626.277	1409	D15B21	R	53	25	28	8	15.7350914	-92.7739658	t
35218	88	0634	La Esperanza	154317.585	0924859.355	1237	D15B21	R	0	0	0	0	15.7215514	-92.8164875	t
35219	88	0635	Los Mezcales (El Progreso)	153843.479	0923428.266	1742	D15B22	R	0	0	0	0	15.6454108	-92.5745183	t
35220	88	0639	La Abegonia	154106.083	0923231.944	1399	D15B22	R	0	0	0	0	15.6850231	-92.5422067	t
35221	88	0641	Jerusal‚n	154556.574	0923838.040	0915	D15B12	R	467	244	223	78	15.7657150	-92.6439000	t
35222	88	0642	Altamira	155206.854	0923938.498	1308	D15B12	R	0	0	0	0	15.8685706	-92.6606939	t
35223	88	0643	San Ram¢n	154650.654	0924850.756	0839	D15B11	R	244	118	126	43	15.7807372	-92.8140989	t
35224	88	0644	La Esperanza	154011.179	0923237.803	1490	D15B22	R	10	0	0	2	15.6697719	-92.5438342	t
35225	88	0645	Pe¤a Flor	154325.070	0923213.943	1456	D15B22	R	2	0	0	1	15.7236306	-92.5372064	t
35226	88	0646	La Estrella	153741.352	0923535.057	1537	D15B22	R	28	17	11	3	15.6281533	-92.5930714	t
35227	88	0648	San Sebasti n	154348.471	0924634.816	1681	D15B21	R	0	0	0	0	15.7301308	-92.7763378	t
35228	88	0649	El Chorro (El Charro)	154445.472	0924632.052	1405	D15B21	R	4	0	0	1	15.7459644	-92.7755700	t
35229	88	0650	El Pencil	153745.502	0923512.420	1349	D15B22	R	21	0	0	2	15.6293061	-92.5867833	t
35230	88	0652	El Vergel	154109.087	0923215.229	1543	D15B22	R	0	0	0	0	15.6858575	-92.5375636	t
35231	88	0653	Las Tres Garant¡as	154121.012	0923106.996	1287	D15B22	R	3	0	0	1	15.6891700	-92.5186100	t
35232	88	0654	La Esperanza	154118.721	0923159.767	1560	D15B22	R	5	0	0	1	15.6885336	-92.5332686	t
35233	88	0655	Argelia	154154.996	0922952.008	0902	D15B22	R	17	9	8	3	15.6986100	-92.4977800	t
35234	88	0658	El Recreo	154500.234	0923935.217	1043	D15B12	R	0	0	0	0	15.7500650	-92.6597825	t
35235	88	0659	Rancho Nuevo	154542.668	0923823.423	0904	D15B12	R	0	0	0	0	15.7618522	-92.6398397	t
35236	88	0660	Buenavista	153848.193	0923346.763	1696	D15B22	R	0	0	0	0	15.6467203	-92.5629897	t
35237	88	0661	Las Joyas	153906.177	0923400.365	1635	D15B22	R	0	0	0	0	15.6517158	-92.5667681	t
35238	88	0662	Las Pimientillas	153851.840	0923355.816	1794	D15B22	R	16	0	0	1	15.6477333	-92.5655044	t
35239	88	0663	Alejandro Flores G.	154950.809	0924653.745	0679	D15B11	R	0	0	0	0	15.8307803	-92.7815958	t
35240	88	0664	Buenos Aires	154004.945	0923537.305	0872	D15B22	R	4	0	0	1	15.6680403	-92.5936958	t
35241	88	0669	Guadalupe	155135.465	0924130.314	0618	D15B11	R	0	0	0	0	15.8598514	-92.6917539	t
35242	88	0671	Los Guzmanes	153853.837	0923324.709	1564	D15B22	R	19	11	8	3	15.6482881	-92.5568636	t
35243	88	0672	Las Limas	154002.841	0923537.504	0879	D15B22	R	6	0	0	1	15.6674558	-92.5937511	t
35244	88	0675	Loma Bonita	154544.187	0924643.717	1348	D15B11	R	17	0	0	2	15.7622742	-92.7788103	t
35245	88	0676	Monte Sina¡	155127.401	0924203.963	0633	D15B11	R	7	0	0	1	15.8576114	-92.7011008	t
35246	88	0678	Las Nubes	153830.312	0923657.343	1237	D15B22	R	0	0	0	0	15.6417533	-92.6159286	t
35247	88	0681	El Pacayal	154036.210	0923223.737	1577	D15B22	R	0	0	0	0	15.6767250	-92.5399269	t
35248	88	0682	El Palomar	154556.682	0923647.435	0995	D15B12	R	0	0	0	0	15.7657450	-92.6131764	t
35249	88	0684	Ninguno	154328.731	0924800.705	0976	D15B21	R	0	0	0	0	15.7246475	-92.8001958	t
35250	88	0688	San Mart¡n	154348.429	0923441.882	1165	D15B22	R	0	0	0	0	15.7301192	-92.5783006	t
35251	88	0690	Sayulita	154502.860	0923826.830	0986	D15B12	R	7	0	0	2	15.7507944	-92.6407861	t
35252	88	0692	Enrique Berm£dez M.	155046.821	0924239.442	0645	D15B11	R	0	0	0	0	15.8463392	-92.7109561	t
35253	88	0693	Joaqu¡n Berm£dez M.	155040.452	0924229.765	0643	D15B11	R	11	0	0	1	15.8445700	-92.7082681	t
35254	88	0694	San Miguel	154929.431	0924230.193	0668	D15B11	R	0	0	0	0	15.8248419	-92.7083869	t
35255	88	0695	Jorge Borrayes L¢pez	155148.381	0924158.820	0621	D15B11	R	0	0	0	0	15.8634392	-92.6996722	t
35256	88	0696	Las Vegas	154409.042	0924221.256	1132	D15B21	R	0	0	0	0	15.7358450	-92.7059044	t
35257	88	0699	El Manguito	155141.988	0924436.774	0622	D15B11	R	0	0	0	0	15.8616633	-92.7435483	t
35258	88	0700	Mapolitas	154324.886	0923355.027	1093	D15B22	R	0	0	0	0	15.7235794	-92.5652853	t
35259	88	0701	Sajonia	154336.348	0923250.132	1365	D15B22	R	0	0	0	0	15.7267633	-92.5472589	t
35260	88	0703	La Hierbabuena	155146.389	0924420.283	0656	D15B11	R	0	0	0	0	15.8628858	-92.7389675	t
35261	88	0704	El Brillante	153820.003	0923347.480	1712	D15B22	R	0	0	0	0	15.6388897	-92.5631889	t
35262	88	0705	Jard¡n del Ed‚n	154107.129	0923148.659	1566	D15B22	R	0	0	0	0	15.6853136	-92.5301831	t
35263	88	0706	La Lagunita	154008.310	0923317.112	1261	D15B22	R	0	0	0	0	15.6689750	-92.5547533	t
35264	88	0707	Loma Bonita	153835.586	0923352.221	1711	D15B22	R	2	0	0	1	15.6432183	-92.5645058	t
35265	88	0709	San Miguel	153844.329	0923358.641	1730	D15B22	R	6	0	0	1	15.6456469	-92.5662892	t
35266	88	0710	El Zanahorial	153910.033	0923447.750	1546	D15B22	R	0	0	0	0	15.6527869	-92.5799306	t
35267	88	0711	Nueva Esperanza	154112.009	0923358.520	0819	D15B22	R	100	50	50	21	15.6866692	-92.5662556	t
35268	88	0712	Nuevo Milenio Quince de Septiembre	154124.468	0923342.726	0803	D15B22	R	125	65	60	20	15.6901300	-92.5618683	t
35269	88	0713	Magnolia Hern ndez M.	154533.739	0924643.246	1367	D15B11	R	0	0	0	0	15.7593719	-92.7786794	t
35270	88	0714	El Rodeo	153917.061	0923352.159	1491	D15B22	R	6	0	0	1	15.6547392	-92.5644886	t
35271	88	0715	Guadalupe Toledo H.	154541.316	0924651.254	1450	D15B11	R	1	0	0	1	15.7614767	-92.7809039	t
35272	88	0716	Agua Fr¡a	154404.992	0923156.346	1339	D15B22	R	0	0	0	0	15.7347200	-92.5323183	t
35273	88	0717	El Arenal	154044.004	0923454.984	0953	D15B22	R	0	0	0	0	15.6788900	-92.5819400	t
35274	88	0718	Ninguno	154456.004	0923515.000	1582	D15B22	R	0	0	0	0	15.7488900	-92.5875000	t
35275	88	0719	Nuevo Milenio Loma Bonita	154004.967	0923538.639	0880	D15B22	R	36	18	18	6	15.6680464	-92.5940664	t
35276	88	0724	San Pedro	154339.508	0923350.120	1213	D15B22	R	0	0	0	0	15.7276411	-92.5639222	t
35277	88	0726	La Victoria	154450.070	0923658.570	1245	D15B22	R	0	0	0	0	15.7472417	-92.6162694	t
35278	88	0727	El Brasilito	154608.739	0924554.794	0963	D15B11	R	0	0	0	0	15.7690942	-92.7652206	t
35279	88	0728	Manuel G¢mez	154613.059	0924604.050	1021	D15B11	R	0	0	0	0	15.7702942	-92.7677917	t
35280	88	0729	Agust¡n G¢mez	154614.988	0924556.016	0989	D15B11	R	0	0	0	0	15.7708300	-92.7655600	t
35281	88	0730	El Pacayal	154738.184	0924828.347	0791	D15B11	R	27	14	13	4	15.7939400	-92.8078742	t
35282	88	0731	Santa Cruz	154424.798	0924825.432	1009	D15B21	R	27	16	11	4	15.7402217	-92.8070644	t
35283	88	0732	Marcela Alvarado L¢pez	155152.873	0924213.145	0621	D15B11	R	4	0	0	1	15.8646869	-92.7036514	t
35284	88	0733	Mar¡a Alvarado L¢pez	155154.544	0924217.058	0620	D15B11	R	6	0	0	1	15.8651511	-92.7047383	t
35285	88	0734	La Primavera	154117.473	0923343.100	0797	D15B22	R	0	0	0	0	15.6881869	-92.5619722	t
35286	88	0735	Ciudad Rural Angel Albino Corzo	155250.345	0924240.215	0622	D15B11	R	0	0	0	0	15.8806514	-92.7111708	t
35287	88	0736	Rancho Escondido	154643.283	0924708.484	1316	D15B11	R	0	0	0	0	15.7786897	-92.7856900	t
35288	88	0737	Tres Hermanos	155215.905	0924227.065	0600	D15B11	R	0	0	0	0	15.8710847	-92.7075181	t
35289	89	0001	Arriaga	161409.834	0935358.104	0061	E15C87	U	24447	11610	12837	7041	16.2360650	-93.8994733	t
35290	89	0002	Licenciado Adolfo L¢pez Mateos	162044.243	0935824.604	0250	E15C77	R	23	14	9	10	16.3456231	-93.9735011	t
35291	89	0003	Agua Fr¡a	161144.051	0935455.198	0033	E15C87	R	150	73	77	39	16.1955697	-93.9153328	t
35292	89	0006	Las Anonas	160851.590	0935703.876	0009	E15C87	R	0	0	0	0	16.1476639	-93.9510767	t
35293	89	0008	Las Arenas	161334.658	0940014.075	0025	E15C86	R	257	144	113	83	16.2262939	-94.0039097	t
35294	89	0009	Argelia	160652.769	0935759.950	0004	E15C87	R	0	0	0	0	16.1146581	-93.9666528	t
35295	89	0010	La Argentina	161040.251	0935717.222	0022	E15C87	R	3	0	0	1	16.1778475	-93.9547839	t
35296	89	0012	La Aurora	161612.486	0935801.787	0051	E15C77	R	11	6	5	3	16.2701350	-93.9671631	t
35297	89	0013	Azteca (La Punta)	161302.176	0935642.529	0025	E15C87	R	1829	871	958	550	16.2172711	-93.9451469	t
35298	89	0015	Berl¡n	160717.340	0935452.040	0009	E15C87	R	0	0	0	0	16.1214833	-93.9144556	t
35299	89	0016	Betania	161822.245	0940024.510	0113	E15C76	R	9	0	0	2	16.3061792	-94.0068083	t
35300	89	0017	La Bondad	161617.997	0935220.216	0135	E15C77	R	0	0	0	0	16.2716658	-93.8722822	t
35301	89	0022	La Victoria	160935.867	0940200.019	0007	E15C86	R	4	0	0	1	16.1599631	-94.0333386	t
35302	89	0026	5 de Febrero	161326.223	0934812.011	0166	E15C87	R	55	31	24	18	16.2239508	-93.8033364	t
35303	89	0027	5 de Mayo	161040.642	0935348.628	0026	E15C87	R	275	147	128	84	16.1779561	-93.8968411	t
35304	89	0029	La Concepci¢n	161955.255	0935922.726	0138	E15C77	R	5	0	0	1	16.3320153	-93.9896461	t
35305	89	0030	C¢rcega	161107.662	0935844.341	0020	E15C87	R	0	0	0	0	16.1854617	-93.9789836	t
35306	89	0031	Costa Bella	160715.024	0935455.207	0008	E15C87	R	2	0	0	1	16.1208400	-93.9153353	t
35307	89	0033	Covadonga	161706.086	0935823.052	0062	E15C77	R	3	0	0	1	16.2850239	-93.9730700	t
35308	89	0034	La Coyotera (Santa Elena)	161438.965	0935751.812	0045	E15C87	R	10	7	3	3	16.2441569	-93.9643922	t
35309	89	0037	Las Delicias	160758.668	0935604.530	0009	E15C87	R	5	0	0	1	16.1329633	-93.9345917	t
35310	89	0039	La Doncella	160915.494	0940410.188	0003	E15C86	R	5	0	0	1	16.1543039	-94.0694967	t
35311	89	0041	Emiliano Zapata	161017.883	0940352.969	0008	E15C86	U	3353	1684	1669	933	16.1716342	-94.0647136	t
35312	89	0043	La Esperanza	161655.130	0934945.273	0259	E15C77	R	10	0	0	2	16.2819806	-93.8292425	t
35313	89	0045	Armon¡a las Flores	161642.016	0935221.295	0142	E15C77	R	26	15	11	8	16.2783378	-93.8725819	t
35314	89	0046	La Gloria	160857.156	0940532.922	-003	E15C86	R	1801	910	891	414	16.1492100	-94.0924783	t
35315	89	0050	El Jard¡n	161612.540	0935222.758	0136	E15C77	R	4	0	0	1	16.2701500	-93.8729883	t
35316	89	0053	L zaro C rdenas	161716.607	0935838.061	0072	E15C77	R	1172	597	575	331	16.2879464	-93.9772392	t
35317	89	0055	Libertad Dos	161305.953	0935726.557	0026	E15C87	R	3	0	0	1	16.2183203	-93.9573769	t
35318	89	0056	La Libertad	161319.591	0935729.805	0031	E15C87	R	6	0	0	2	16.2221086	-93.9582792	t
35319	89	0058	La L¡nea	160754.572	0940202.652	0001	E15C86	R	1452	756	696	353	16.1318256	-94.0340700	t
35320	89	0070	El Mil n	161226.217	0935955.371	0026	E15C87	R	0	0	0	0	16.2072825	-93.9987142	t
35321	89	0072	Monte Bonito	161929.206	0935219.202	0396	E15C77	R	6	0	0	1	16.3247794	-93.8720006	t
35322	89	0075	Morelia	161500.974	0935931.674	0047	E15C77	R	0	0	0	0	16.2502706	-93.9921317	t
35323	89	0079	Nicol s Bravo (El Hondo)	161607.377	0935455.235	0070	E15C77	R	838	440	398	221	16.2687158	-93.9153431	t
35324	89	0080	El Nilo	161023.364	0935903.049	0016	E15C87	R	0	0	0	0	16.1731567	-93.9841803	t
35325	89	0083	Oaxaquita	161119.051	0940005.687	0021	E15C86	R	206	116	90	60	16.1886253	-94.0015797	t
35326	89	0089	El Para¡so	161525.911	0935859.603	0050	E15C77	R	0	0	0	0	16.2571975	-93.9832231	t
35327	89	0093	Punta Flor	160615.801	0935842.110	0000	E15C87	R	931	487	444	272	16.1043892	-93.9783639	t
35328	89	0095	El Ponedero	162420.016	0940329.988	0330	E15C76	R	0	0	0	0	16.4055600	-94.0583300	t
35329	89	0096	El Porvenir	161907.500	0940012.502	0098	E15C76	R	11	0	0	2	16.3187500	-94.0034728	t
35330	89	0097	El Porvenir	161138.615	0935718.614	0025	E15C87	R	0	0	0	0	16.1940597	-93.9551706	t
35331	89	0098	El Porvenir	160826.498	0935935.389	0005	E15C87	R	0	0	0	0	16.1406939	-93.9931636	t
35332	89	0101	La Providencia	160912.514	0935701.581	0012	E15C87	R	0	0	0	0	16.1534761	-93.9504392	t
35333	89	0102	El Ramil	161222.877	0935637.854	0030	E15C87	R	0	0	0	0	16.2063547	-93.9438483	t
35334	89	0105	El Progreso (El Recreo)	160642.519	0935722.012	0005	E15C87	R	6	0	0	2	16.1118108	-93.9561144	t
35335	89	0107	San Mart¡n Caballero	161243.325	0935948.250	0028	E15C87	R	0	0	0	0	16.2120347	-93.9967361	t
35336	89	0110	La Providencia	161913.302	0935853.029	0124	E15C77	R	0	0	0	0	16.3203617	-93.9813969	t
35337	89	0117	San Antonio	161801.480	0935227.210	0197	E15C77	R	2	0	0	1	16.3004111	-93.8742250	t
35338	89	0121	San Felipe	161733.741	0935822.498	0072	E15C77	R	0	0	0	0	16.2927058	-93.9729161	t
35339	89	0125	San Jacinto	160939.455	0935633.511	0018	E15C87	R	2	0	0	1	16.1609597	-93.9426419	t
35340	89	0132	Nuevo San Pablo	161632.485	0935853.848	0051	E15C77	R	251	123	128	67	16.2756903	-93.9816244	t
35341	89	0133	San Pedro	161636.269	0934604.304	0454	E15C77	R	3	0	0	1	16.2767414	-93.7678622	t
35342	89	0136	Santa Anita	160856.411	0935821.173	0009	E15C87	R	0	0	0	0	16.1490031	-93.9725481	t
35343	89	0142	Santa Martha	161222.669	0935757.436	0028	E15C87	R	6	0	0	1	16.2062969	-93.9659544	t
35344	89	0143	Santa Rosa	161259.873	0935533.446	0038	E15C87	R	32	15	17	9	16.2166314	-93.9259572	t
35345	89	0144	Santo Domingo	160906.516	0940233.530	0005	E15C86	R	6	0	0	1	16.1518100	-94.0426472	t
35346	89	0145	San Vicente (El Ocote)	162042.985	0940010.010	0201	E15C76	R	12	7	5	3	16.3452736	-94.0027806	t
35347	89	0147	La Soledad	161747.130	0935921.026	0076	E15C77	R	4	0	0	1	16.2964250	-93.9891739	t
35348	89	0150	Flor de Liz	160838.308	0935445.043	0013	E15C87	R	10	0	0	2	16.1439744	-93.9125119	t
35349	89	0151	El Tamarindo	161310.001	0935824.842	0030	E15C87	R	7	0	0	1	16.2194447	-93.9735672	t
35350	89	0153	El Tesoro	161037.843	0940527.984	0002	E15C86	R	0	0	0	0	16.1771786	-94.0911067	t
35351	89	0155	Las Margaritas	161545.513	0935233.338	0138	E15C77	R	19	12	7	5	16.2626425	-93.8759272	t
35352	89	0160	M¡ura	161050.278	0940043.648	0016	E15C86	R	0	0	0	0	16.1806328	-94.0121244	t
35353	89	0161	Villa del Mar	160753.604	0935728.645	0008	E15C87	R	498	255	243	145	16.1315567	-93.9579569	t
35354	89	0163	El Yamuri	161529.841	0935917.283	0044	E15C77	R	0	0	0	0	16.2582892	-93.9881342	t
35355	89	0165	Tres Hermanos	161803.388	0940052.357	0116	E15C76	R	0	0	0	0	16.3009411	-94.0145436	t
35356	89	0166	Villa Alegr¡a	161608.181	0935213.990	0124	E15C77	R	3	0	0	1	16.2689392	-93.8705528	t
35357	89	0168	3 Mar¡as (Zacazonapan)	160706.720	0935739.215	0005	E15C87	R	5	0	0	1	16.1185333	-93.9608931	t
35358	89	0169	El Arenal	160645.355	0935958.101	0001	E15C87	R	215	115	100	55	16.1125986	-93.9994725	t
35359	89	0170	La Herradura	161824.960	0935234.150	0215	E15C77	R	3	0	0	1	16.3069333	-93.8761528	t
35360	89	0175	El Tri ngulo	161528.496	0935633.393	0050	E15C77	R	0	0	0	0	16.2579156	-93.9426092	t
35361	89	0183	El Tabl¢n	162256.628	0940141.217	0483	E15C76	R	0	0	0	0	16.3823967	-94.0281158	t
35362	89	0184	La Herradura	162139.739	0940222.607	0142	E15C76	R	0	0	0	0	16.3610386	-94.0396131	t
35363	89	0188	Los Cocos	161242.020	0935837.769	0031	E15C87	R	6	0	0	1	16.2116722	-93.9771581	t
35364	89	0189	El Ojaral	160907.555	0935945.211	0008	E15C87	R	0	0	0	0	16.1520986	-93.9958919	t
35365	89	0191	San Mart¡n (La Cascada)	161729.808	0935245.284	0181	E15C77	R	2	0	0	2	16.2916133	-93.8792456	t
35366	89	0194	El Pleito	160703.252	0940113.207	0000	E15C86	R	167	86	81	39	16.1175700	-94.0203353	t
35367	89	0197	Agua Zarca	161105.202	0935354.458	0030	E15C87	R	4	0	0	1	16.1847783	-93.8984606	t
35368	89	0200	El Parral	161208.588	0935927.231	0026	E15C87	R	1	0	0	1	16.2023856	-93.9908975	t
35369	89	0201	Grijalva	160940.623	0935913.240	0012	E15C87	R	2	0	0	1	16.1612842	-93.9870111	t
35370	89	0202	Palo Blanco	160902.918	0935931.951	0008	E15C87	R	12	0	0	2	16.1508106	-93.9922086	t
35371	89	0205	Veinte de Noviembre	161842.986	0934547.710	0658	E15C77	R	37	19	18	10	16.3119406	-93.7632528	t
35372	89	0209	Las µnimas (El Totoposte)	161705.133	0935743.896	0076	E15C77	R	0	0	0	0	16.2847592	-93.9621933	t
35373	89	0214	La Estancia	161133.682	0935756.772	0023	E15C87	R	3	0	0	1	16.1926894	-93.9657700	t
35374	89	0216	El Columpio (Nueva Rosita)	161410.580	0935702.997	0044	E15C87	R	6	0	0	2	16.2362722	-93.9508325	t
35375	89	0219	La Majada Uno	161210.943	0935814.758	0026	E15C87	R	0	0	0	0	16.2030397	-93.9707661	t
35376	89	0238	Llanero	161217.527	0935250.555	0036	E15C87	R	0	0	0	0	16.2048686	-93.8807097	t
35377	89	0239	El Rosario	161152.837	0935238.876	0033	E15C87	R	0	0	0	0	16.1980103	-93.8774656	t
35378	89	0240	San Gabriel	161241.716	0934957.083	0084	E15C87	R	0	0	0	0	16.2115878	-93.8325231	t
35379	89	0249	La Gloria	161117.372	0935542.894	0030	E15C87	R	20	10	10	6	16.1881589	-93.9285817	t
35380	89	0251	Reforma	161747.130	0935227.488	0194	E15C77	R	0	0	0	0	16.2964250	-93.8743022	t
35381	89	0258	San Carlos las Carolinas (El Salto de Abad)	161402.114	0934646.455	0216	E15C87	R	5	0	0	2	16.2339206	-93.7795708	t
35382	89	0265	Pe¤a Grande	161325.186	0935829.906	0042	E15C87	R	0	0	0	0	16.2236628	-93.9749739	t
35383	89	0266	San Ram¢n (Secci¢n Kil¢metro 136)	161348.178	0940042.592	0014	E15C86	R	44	21	23	12	16.2300494	-94.0118311	t
35384	89	0268	Santa Elena	161209.031	0940126.606	0017	E15C86	R	0	0	0	0	16.2025086	-94.0240572	t
35385	89	0269	Tabasquito	161532.158	0935846.785	0050	E15C77	R	0	0	0	0	16.2589328	-93.9796625	t
35386	89	0282	Lomita de Tierra	161145.755	0940331.010	0002	E15C86	R	5	0	0	1	16.1960431	-94.0586139	t
35387	89	0283	El Para¡so	161249.192	0940251.989	0012	E15C86	R	0	0	0	0	16.2136644	-94.0477747	t
35388	89	0285	Bola de Oro	161402.917	0935902.571	0032	E15C87	R	48	27	21	18	16.2341436	-93.9840475	t
35389	89	0290	Las Cruces	161653.520	0935031.649	0180	E15C77	R	10	0	0	1	16.2815333	-93.8421247	t
35390	89	0294	La Mica	161938.075	0934925.807	0473	E15C77	R	0	0	0	0	16.3272431	-93.8238353	t
35391	89	0295	El Nanchito	161414.932	0935954.861	0041	E15C87	R	16	8	8	4	16.2374811	-93.9985725	t
35392	89	0301	Poza Galana	161630.488	0934719.410	0345	E15C77	R	30	17	13	10	16.2751356	-93.7887250	t
35393	89	0302	Rancho Alegre	161703.091	0940151.660	0411	E15C76	R	1	0	0	1	16.2841919	-94.0310167	t
35394	89	0303	Los Cocos	160814.370	0940117.358	0003	E15C86	R	2	0	0	1	16.1373250	-94.0214883	t
35395	89	0304	Buenaventura	161305.492	0935140.492	0057	E15C87	R	13	6	7	3	16.2181922	-93.8612478	t
35396	89	0306	San µngel	160921.408	0940307.049	0006	E15C86	R	2	0	0	1	16.1559467	-94.0519581	t
35397	89	0308	El Tempisque	161344.873	0934616.533	0276	E15C87	R	4	0	0	1	16.2291314	-93.7712592	t
35398	89	0315	Santa Luc¡a	161334.200	0935823.074	0047	E15C87	R	3	0	0	1	16.2261667	-93.9730761	t
35399	89	0317	El Para¡so	161313.681	0935727.983	0028	E15C87	R	2	0	0	1	16.2204669	-93.9577731	t
35400	89	0318	Las Brisas	161735.125	0935249.340	0193	E15C77	R	15	7	8	7	16.2930903	-93.8803722	t
35401	89	0319	El Villamil	161543.747	0935720.337	0046	E15C77	R	6	0	0	1	16.2621519	-93.9556492	t
35402	89	0321	Vista Flor	161534.635	0935233.889	0105	E15C77	R	81	38	43	20	16.2596208	-93.8760803	t
35403	89	0322	Las Vegas	161621.573	0935720.266	0054	E15C77	R	5	0	0	2	16.2726592	-93.9556294	t
35404	89	0323	Los Limones	161254.740	0935741.350	0030	E15C87	R	9	0	0	2	16.2152056	-93.9614861	t
35405	89	0324	El Herradero	161530.714	0935601.786	0051	E15C77	R	11	6	5	3	16.2585317	-93.9338294	t
35406	89	0325	Las Bugambilias	161529.422	0935557.123	0050	E15C77	R	2	0	0	1	16.2581728	-93.9325342	t
35407	89	0326	Tres Hermanos	161553.946	0935641.558	0053	E15C77	R	5	0	0	1	16.2649850	-93.9448772	t
35408	89	0327	La Esmeralda (La Curva del Chivo)	161335.479	0935852.728	0032	E15C87	R	11	6	5	4	16.2265219	-93.9813133	t
35409	89	0331	Pozos [Frigor¡fico]	161512.095	0935543.566	0048	E15C77	R	0	0	0	0	16.2533597	-93.9287683	t
35410	89	0332	Cerro Colorado	161546.210	0935600.944	0069	E15C77	R	1	0	0	1	16.2628361	-93.9335956	t
35411	89	0333	Ota¤es	161456.847	0935628.505	0042	E15C87	R	12	7	5	3	16.2491242	-93.9412514	t
35412	89	0334	Angelita	161533.510	0935609.087	0054	E15C77	R	2	0	0	1	16.2593083	-93.9358575	t
35413	89	0335	San Antonio	161648.127	0935828.572	0060	E15C77	R	45	27	18	12	16.2800353	-93.9746033	t
35414	89	0336	La Esperanza	161707.933	0935802.593	0063	E15C77	R	6	0	0	2	16.2855369	-93.9673869	t
35415	89	0341	San Isidro	161317.892	0935510.296	0040	E15C87	R	11	0	0	2	16.2216367	-93.9195267	t
35416	89	0342	La Esperanza	161330.642	0935751.166	0038	E15C87	R	2	0	0	1	16.2251783	-93.9642128	t
35417	89	0343	Xochimilco	161407.322	0935658.835	0042	E15C87	R	0	0	0	0	16.2353672	-93.9496764	t
35418	89	0344	Parada las Piedras	161320.663	0935615.796	0045	E15C87	R	0	0	0	0	16.2224064	-93.9377211	t
35419	89	0345	Alberchica	161319.988	0935632.310	0039	E15C87	R	9	5	4	4	16.2222189	-93.9423083	t
35420	89	0346	Sein Gald mez Espinosa	161320.923	0935614.699	0043	E15C87	R	4	0	0	1	16.2224786	-93.9374164	t
35421	89	0348	Monte Sina¡	160933.565	0940457.079	0001	E15C86	R	0	0	0	0	16.1593236	-94.0825219	t
35422	89	0350	Las Delicias	160944.483	0940441.330	0003	E15C86	R	5	0	0	1	16.1623564	-94.0781472	t
35423	89	0351	San Pedro	161147.853	0940408.094	0007	E15C86	R	0	0	0	0	16.1966258	-94.0689150	t
35424	89	0352	Quinta Maricruz	160901.131	0940221.245	0005	E15C86	R	0	0	0	0	16.1503142	-94.0392347	t
35425	89	0353	San Mart¡n	160902.225	0940050.587	0006	E15C86	R	0	0	0	0	16.1506181	-94.0140519	t
35426	89	0354	La Azteca Dos (San Francisco)	160915.403	0940210.681	0010	E15C86	R	5	0	0	2	16.1542786	-94.0363003	t
35427	89	0355	El Lucero	161005.091	0940138.988	0009	E15C86	R	10	0	0	1	16.1680808	-94.0274967	t
35428	89	0356	Las Brucelas	160851.164	0940317.242	0004	E15C86	R	2	0	0	1	16.1475456	-94.0547894	t
35429	89	0357	El Zacatal	161005.406	0940220.692	0010	E15C86	R	0	0	0	0	16.1681683	-94.0390811	t
35430	89	0358	El Ca¤¢n (Palma Sola)	160920.408	0940203.698	0010	E15C86	R	0	0	0	0	16.1556689	-94.0343606	t
35431	89	0361	La Victoria (La Pichancha)	161027.373	0940039.588	0014	E15C86	R	0	0	0	0	16.1742703	-94.0109967	t
35432	89	0362	El Riachuelo (Rancho Bonito)	160824.796	0940059.968	0004	E15C86	R	0	0	0	0	16.1402211	-94.0166578	t
35433	89	0363	Rancho Bonito	160806.132	0940046.152	0003	E15C86	R	0	0	0	0	16.1350367	-94.0128200	t
35434	89	0364	San Francisco	160848.295	0940029.820	0006	E15C86	R	0	0	0	0	16.1467486	-94.0082833	t
35435	89	0365	Arroyito	160726.960	0940053.168	0001	E15C86	R	9	5	4	4	16.1241556	-94.0147689	t
35436	89	0366	El Sauce	161008.413	0935943.871	0015	E15C87	R	3	0	0	1	16.1690036	-93.9955197	t
35437	89	0367	Las Salinas	160834.086	0940142.398	0003	E15C86	R	0	0	0	0	16.1428017	-94.0284439	t
35438	89	0368	El Recuerdo	160754.450	0940100.702	0002	E15C86	R	3	0	0	1	16.1317917	-94.0168617	t
35439	89	0369	La Angostura	160751.513	0940106.997	0001	E15C86	R	6	0	0	2	16.1309758	-94.0186103	t
35440	89	0370	San Marcos	160751.379	0940105.477	0001	E15C86	R	0	0	0	0	16.1309386	-94.0181881	t
35441	89	0371	El Tamarindo	160711.814	0940009.395	0002	E15C86	R	6	0	0	1	16.1199483	-94.0026097	t
35442	89	0372	El Pe¤¢n	160738.490	0940026.511	0002	E15C86	R	7	0	0	2	16.1273583	-94.0073642	t
35443	89	0373	La Soledad	161515.208	0935301.945	0090	E15C77	R	136	63	73	31	16.2542244	-93.8838736	t
35444	89	0375	San Rom n	161349.043	0935010.719	0116	E15C87	R	1	0	0	1	16.2302897	-93.8363108	t
35445	89	0379	El Cuaulote	161250.845	0935347.782	0046	E15C87	R	0	0	0	0	16.2141236	-93.8966061	t
35446	89	0383	Las Clavellinas	161232.493	0935002.099	0082	E15C87	R	1	0	0	1	16.2090258	-93.8339164	t
35447	89	0385	25 de Marzo (La Pampa)	161157.075	0935343.335	0034	E15C87	R	0	0	0	0	16.1991875	-93.8953708	t
35448	89	0387	La Esperanza	161300.040	0935323.725	0050	E15C87	R	0	0	0	0	16.2166778	-93.8899236	t
35449	89	0388	Betania (La Granja)	161256.889	0935326.149	0050	E15C87	R	6	0	0	1	16.2158025	-93.8905969	t
35450	89	0389	La Atascosa	161124.326	0935320.977	0029	E15C87	R	0	0	0	0	16.1900906	-93.8891603	t
35451	89	0393	La Majada Dos	161155.803	0935830.630	0025	E15C87	R	0	0	0	0	16.1988342	-93.9751750	t
35452	89	0395	El Alba	161311.721	0940057.953	0027	E15C86	R	6	0	0	1	16.2199225	-94.0160981	t
35453	89	0396	Los Amores	161251.729	0940119.674	0013	E15C86	R	0	0	0	0	16.2143692	-94.0221317	t
35454	89	0397	El Huimanguillo	161324.634	0940052.197	0027	E15C86	R	0	0	0	0	16.2235094	-94.0144992	t
35455	89	0398	Los Limones	161153.101	0940133.359	0014	E15C86	R	6	0	0	1	16.1980836	-94.0259331	t
35456	89	0399	Santa Cecilia	161104.326	0940211.393	0008	E15C86	R	4	0	0	1	16.1845350	-94.0364981	t
35457	89	0403	El Cobano	161304.220	0935830.675	0032	E15C87	R	4	0	0	1	16.2178389	-93.9751875	t
35458	89	0404	La Guadalupe (Solo Dios)	162124.216	0940109.661	0132	E15C76	R	0	0	0	0	16.3567267	-94.0193503	t
35459	89	0405	Nuevo Progreso (Absal¢n Castellanos D.)	162023.525	0940126.340	0123	E15C76	R	209	96	113	59	16.3398681	-94.0239833	t
35460	89	0406	Balta	161834.548	0940022.235	0112	E15C76	R	0	0	0	0	16.3095967	-94.0061764	t
35461	89	0408	San Francisco	161905.335	0935952.258	0083	E15C77	R	2	0	0	1	16.3181486	-93.9978494	t
35462	89	0409	El Bosque Dos	161931.008	0940014.004	0100	E15C76	R	0	0	0	0	16.3252800	-94.0038900	t
35463	89	0410	El Mango	161757.400	0940125.413	0147	E15C76	R	0	0	0	0	16.2992778	-94.0237258	t
35464	89	0411	San Jos‚ los Desmontes	161657.908	0940018.303	0126	E15C76	R	0	0	0	0	16.2827522	-94.0050842	t
35465	89	0412	El Hormiguero	161618.815	0940117.945	0214	E15C76	R	0	0	0	0	16.2718931	-94.0216514	t
35466	89	0413	Las Hildas	161657.003	0935821.022	0060	E15C77	R	6	0	0	1	16.2825008	-93.9725061	t
35467	89	0414	Los µngeles	161550.004	0940145.984	0237	E15C76	R	1	0	0	1	16.2638900	-94.0294400	t
35468	89	0415	El Camar¢n	161529.988	0940057.996	0098	E15C76	R	0	0	0	0	16.2583300	-94.0161100	t
35469	89	0416	Los Mangos Dos	161829.148	0934732.888	0485	E15C77	R	5	0	0	1	16.3080967	-93.7924689	t
35470	89	0417	Las Palmitas	161842.350	0934716.389	0457	E15C77	R	0	0	0	0	16.3117639	-93.7878858	t
35471	89	0418	Las Naranjitas	161839.514	0934718.960	0440	E15C77	R	2	0	0	1	16.3109761	-93.7886000	t
35472	89	0419	Las Mercedes	161653.287	0934600.761	0498	E15C77	R	0	0	0	0	16.2814686	-93.7668781	t
35473	89	0420	La Esmeralda Dos	161629.564	0934619.440	0426	E15C77	R	3	0	0	1	16.2748789	-93.7720667	t
35474	89	0421	Ojo de Agua	161714.881	0934729.437	0555	E15C77	R	1	0	0	1	16.2874669	-93.7915103	t
35475	89	0422	El Roble	161656.815	0934648.229	0528	E15C77	R	0	0	0	0	16.2824486	-93.7800636	t
35476	89	0423	El Fais n	161647.053	0934706.868	0448	E15C77	R	2	0	0	1	16.2797369	-93.7852411	t
35477	89	0425	Las Monedas	161702.404	0934855.810	0275	E15C77	R	0	0	0	0	16.2840011	-93.8155028	t
35478	89	0426	La Esmeralda	161710.293	0934900.478	0270	E15C77	R	0	0	0	0	16.2861925	-93.8167994	t
35479	89	0427	La Piedrona	161200.711	0934730.256	0357	E15C87	R	0	0	0	0	16.2001975	-93.7917378	t
35480	89	0428	Rinc¢n Guayabo	161429.880	0934745.548	0239	E15C87	R	2	0	0	1	16.2416333	-93.7959856	t
35481	89	0429	El Tesoro	161244.547	0934713.721	0297	E15C87	R	0	0	0	0	16.2123742	-93.7871447	t
35482	89	0431	Los Arreolas	160949.946	0935742.146	0017	E15C87	R	0	0	0	0	16.1638739	-93.9617072	t
35483	89	0436	La Ceiba	160957.131	0935439.491	0019	E15C87	R	3	0	0	1	16.1658697	-93.9109697	t
35484	89	0438	Las Delicias	160953.016	0935632.061	0019	E15C87	R	10	0	0	2	16.1647267	-93.9422392	t
35485	89	0439	El Brillante	161042.478	0935607.321	0025	E15C87	R	6	0	0	1	16.1784661	-93.9353669	t
35486	89	0440	San Vicente	160956.649	0935624.065	0020	E15C87	R	4	0	0	2	16.1657358	-93.9400181	t
35487	89	0441	Las Flores	160959.375	0935620.452	0020	E15C87	R	2	0	0	1	16.1664931	-93.9390144	t
35488	89	0442	La Nueva Reforma	160930.495	0935652.594	0015	E15C87	R	3	0	0	1	16.1584708	-93.9479428	t
35489	89	0443	El Recuerdo	160921.671	0935653.002	0013	E15C87	R	2	0	0	1	16.1560197	-93.9480561	t
35490	89	0444	La Providencia	161117.446	0935639.308	0027	E15C87	R	0	0	0	0	16.1881794	-93.9442522	t
35491	89	0445	Fracci¢n la Esperanza	160910.160	0935638.612	0012	E15C87	R	55	30	25	11	16.1528222	-93.9440589	t
35492	89	0446	Emanuel	160646.210	0935536.016	0007	E15C87	R	7	0	0	2	16.1128361	-93.9266711	t
35493	89	0447	La Salinera	160635.464	0935533.797	0007	E15C87	R	0	0	0	0	16.1098511	-93.9260547	t
35494	89	0449	El Lirio	160719.698	0935451.924	0009	E15C87	R	2	0	0	1	16.1221383	-93.9144233	t
35495	89	0450	Rey David	160739.409	0935513.405	0009	E15C87	R	0	0	0	0	16.1276136	-93.9203903	t
35496	89	0451	El Para¡so	160705.993	0935806.553	0003	E15C87	R	0	0	0	0	16.1183314	-93.9684869	t
35497	89	0452	El Polvor¡n	160641.924	0935800.017	0004	E15C87	R	0	0	0	0	16.1116456	-93.9666714	t
35498	89	0453	El Sauce	160701.218	0935811.830	0003	E15C87	R	1	0	0	1	16.1170050	-93.9699528	t
35499	89	0454	Santa Luc¡a	161004.523	0935624.359	0020	E15C87	R	5	0	0	1	16.1679231	-93.9400997	t
35500	89	0455	Los Cocos	160824.862	0935550.543	0010	E15C87	R	4	0	0	1	16.1402394	-93.9307064	t
35501	89	0456	Villalinda (El Matochito)	160845.564	0935541.456	0013	E15C87	R	2	0	0	1	16.1459900	-93.9281822	t
35502	89	0457	El Dorado	160726.305	0935609.421	0007	E15C87	R	7	0	0	2	16.1239736	-93.9359503	t
35503	89	0458	Nayarit	160831.291	0935547.601	0011	E15C87	R	3	0	0	1	16.1420253	-93.9298892	t
35504	89	0460	Cuba	160722.796	0935747.566	0005	E15C87	R	5	0	0	1	16.1229989	-93.9632128	t
35505	89	0461	La Habana	160729.406	0935753.166	0004	E15C87	R	4	0	0	1	16.1248350	-93.9647683	t
35506	89	0463	El Vergel	160905.705	0935720.843	0011	E15C87	R	0	0	0	0	16.1515847	-93.9557897	t
35507	89	0464	Hamburgo	161027.369	0935607.059	0023	E15C87	R	0	0	0	0	16.1742692	-93.9352942	t
35508	89	0465	El Regad¡o	161031.963	0935628.561	0023	E15C87	R	2	0	0	1	16.1755453	-93.9412669	t
35509	89	0466	El Recuerdo	161103.668	0935659.866	0025	E15C87	R	0	0	0	0	16.1843522	-93.9499628	t
35510	89	0467	Rancho Bonito	161826.314	0934734.320	0499	E15C77	R	3	0	0	1	16.3073094	-93.7928667	t
35511	89	0468	Agr¡cola Veinte de Noviembre	161826.816	0934853.848	0327	E15C77	R	48	18	30	13	16.3074489	-93.8149578	t
35512	89	0470	San Isidro	161940.008	0934936.984	0514	E15C77	R	0	0	0	0	16.3277800	-93.8269400	t
35513	89	0472	El Pitayo (Guamuchal)	161637.310	0935103.539	0158	E15C77	R	4	0	0	1	16.2770306	-93.8509831	t
35514	89	0473	El Progreso	161939.133	0935202.839	0436	E15C77	R	0	0	0	0	16.3275369	-93.8674553	t
35515	89	0474	Italia	161941.657	0935202.309	0424	E15C77	R	0	0	0	0	16.3282381	-93.8673081	t
35516	89	0475	Solo Dios	161655.196	0935225.690	0167	E15C77	R	6	0	0	1	16.2819989	-93.8738028	t
35517	89	0476	Santa Rita	161735.570	0935239.480	0185	E15C77	R	2	0	0	1	16.2932139	-93.8776333	t
35518	89	0478	Las µnimas	161845.378	0934826.127	0348	E15C77	R	1	0	0	1	16.3126050	-93.8072575	t
35519	89	0480	Costa Bella	161059.524	0940537.461	0002	E15C86	R	0	0	0	0	16.1832011	-94.0937392	t
35520	89	0481	Las Margaritas	160657.606	0935607.027	0007	E15C87	R	3	0	0	1	16.1160017	-93.9352853	t
35521	89	0491	El Palenque	161940.415	0934737.370	0581	E15C77	R	0	0	0	0	16.3278931	-93.7937139	t
35522	89	0492	Las Lomitas	161918.128	0934710.260	0460	E15C77	R	0	0	0	0	16.3217022	-93.7861833	t
35523	89	0493	El Laurel	161832.053	0934708.950	0478	E15C77	R	1	0	0	1	16.3089036	-93.7858194	t
35524	89	0494	El Porvenir	161814.675	0934705.960	0551	E15C77	R	3	0	0	1	16.3040764	-93.7849889	t
35525	89	0497	El Vainillo	161453.704	0934857.677	0222	E15C87	R	0	0	0	0	16.2482511	-93.8160214	t
35526	89	0499	Santa Elena	161329.669	0935010.210	0093	E15C87	R	0	0	0	0	16.2249081	-93.8361694	t
35527	89	0503	Las Maravillas	161528.351	0935240.094	0102	E15C77	R	18	10	8	4	16.2578753	-93.8778039	t
35528	89	0504	La Libertad	161526.681	0935243.981	0101	E15C77	R	7	0	0	2	16.2574114	-93.8788836	t
35529	89	0505	Los Tamarindos	161524.026	0935252.035	0100	E15C77	R	5	0	0	1	16.2566739	-93.8811208	t
35530	89	0508	San Pablo	161329.863	0935306.181	0061	E15C87	R	3	0	0	1	16.2249619	-93.8850503	t
35531	89	0509	Agua Dulce	161243.643	0935337.769	0044	E15C87	R	48	24	24	14	16.2121231	-93.8938247	t
35532	89	0511	Los Cocos	161259.676	0935403.260	0047	E15C87	R	7	0	0	1	16.2165767	-93.9009056	t
35533	89	0512	La Ceiba	161247.642	0935415.064	0042	E15C87	R	6	0	0	1	16.2132339	-93.9041844	t
35534	89	0514	Cuatro Caminos	161156.706	0935421.958	0035	E15C87	R	0	0	0	0	16.1990850	-93.9060994	t
35535	89	0515	El Profesor	161136.562	0935427.537	0033	E15C87	R	10	0	0	2	16.1934894	-93.9076492	t
35536	89	0517	Granja Bachoco	161239.796	0940123.605	0018	E15C86	R	4	0	0	1	16.2110544	-94.0232236	t
35537	89	0518	La Historia (Casa del Ejido)	161127.268	0940111.367	0015	E15C86	R	0	0	0	0	16.1909078	-94.0198242	t
35538	89	0520	El Para¡so	160900.339	0935754.103	0009	E15C87	R	0	0	0	0	16.1500942	-93.9650286	t
35539	89	0521	La Huasteca	160830.701	0935826.080	0006	E15C87	R	5	0	0	1	16.1418614	-93.9739111	t
35540	89	0522	San Fernando	160729.701	0935806.841	0003	E15C87	R	0	0	0	0	16.1249169	-93.9685669	t
35541	89	0523	Monte Verde	160806.869	0935842.062	0002	E15C87	R	0	0	0	0	16.1352414	-93.9783506	t
35542	89	0525	La Herradura	161313.107	0935700.480	0021	E15C87	R	3	0	0	1	16.2203075	-93.9501333	t
35543	89	0529	El Danubio	161023.736	0935627.170	0023	E15C87	R	3	0	0	1	16.1732600	-93.9408806	t
35544	89	0530	San Jos‚	160938.818	0935754.127	0014	E15C87	R	0	0	0	0	16.1607828	-93.9650353	t
35545	89	0531	Santa Isabel	161005.644	0935748.384	0018	E15C87	R	1	0	0	1	16.1682344	-93.9634400	t
35546	89	0532	El Roble	161120.394	0935745.656	0023	E15C87	R	0	0	0	0	16.1889983	-93.9626822	t
35547	89	0533	La Guadalupana (Las Crucecitas)	160953.525	0935900.714	0015	E15C87	R	0	0	0	0	16.1648681	-93.9835317	t
35548	89	0534	El Salvador	160948.316	0935748.859	0016	E15C87	R	3	0	0	1	16.1634211	-93.9635719	t
35549	89	0536	Costa Rica	161010.045	0935707.812	0020	E15C87	R	6	0	0	1	16.1694569	-93.9521700	t
35550	89	0537	Los Laureles	161000.370	0935733.883	0018	E15C87	R	0	0	0	0	16.1667694	-93.9594119	t
35551	89	0538	El Arbolito	160957.970	0935722.473	0019	E15C87	R	4	0	0	1	16.1661028	-93.9562425	t
35552	89	0539	La Primavera	160708.501	0935455.893	0008	E15C87	R	4	0	0	2	16.1190281	-93.9155258	t
35553	89	0541	El Sauce	160653.641	0935605.310	0007	E15C87	R	0	0	0	0	16.1149003	-93.9348083	t
35554	89	0543	El Per£	161044.579	0935444.902	0026	E15C87	R	5	0	0	1	16.1790497	-93.9124728	t
35555	89	0544	San Antonio	161037.511	0935425.251	0025	E15C87	R	3	0	0	1	16.1770864	-93.9070142	t
35556	89	0545	San Andr‚s	160934.811	0935750.211	0014	E15C87	R	6	0	0	2	16.1596697	-93.9639475	t
35557	89	0546	Vistahermosa (El Matocho)	160911.319	0935530.891	0015	E15C87	R	0	0	0	0	16.1531442	-93.9252475	t
35558	89	0549	El Cuero	160750.838	0935455.259	0010	E15C87	R	7	0	0	2	16.1307883	-93.9153497	t
35559	89	0551	La Esperanza	161122.542	0935146.050	0043	E15C87	R	5	0	0	1	16.1895950	-93.8627917	t
35560	89	0552	El Porvenir	161404.563	0940034.637	0032	E15C86	R	11	0	0	2	16.2346008	-94.0096214	t
35561	89	0553	San Ram¢n	161323.132	0940047.295	0030	E15C86	R	7	0	0	1	16.2230922	-94.0131375	t
35562	89	0558	El Recuerdo	160642.825	0935837.100	0002	E15C87	R	8	0	0	2	16.1118958	-93.9769722	t
35563	89	0562	El Rinc¢n	161300.830	0935320.291	0050	E15C87	R	0	0	0	0	16.2168972	-93.8889697	t
35564	89	0565	San Luis	161600.413	0935843.891	0050	E15C77	R	0	0	0	0	16.2667814	-93.9788586	t
35565	89	0567	Jardines de San Pedro	161655.486	0934714.640	0464	E15C77	R	0	0	0	0	16.2820794	-93.7874000	t
35566	89	0577	El Bosque Uno	161932.016	0940020.016	0100	E15C76	R	0	0	0	0	16.3255600	-94.0055600	t
35567	89	0582	Las Flores del Retiro	162004.208	0935928.115	0142	E15C77	R	0	0	0	0	16.3345022	-93.9911431	t
35568	89	0583	San Felipe	161623.848	0934613.889	0420	E15C77	R	0	0	0	0	16.2732911	-93.7705247	t
35569	89	0585	La Paz	161809.308	0935228.044	0206	E15C77	R	16	9	7	5	16.3025856	-93.8744567	t
35570	89	0590	San Antonio	160947.405	0940153.968	0008	E15C86	R	4	0	0	1	16.1631681	-94.0316578	t
35571	89	0592	El Carmen	160923.393	0940213.610	0006	E15C86	R	0	0	0	0	16.1564981	-94.0371139	t
35572	89	0593	Las Delicias	160933.385	0940453.102	0001	E15C86	R	3	0	0	1	16.1592736	-94.0814172	t
35573	89	0594	La Reserva (La Granja)	160936.075	0940436.260	0003	E15C86	R	0	0	0	0	16.1600208	-94.0767389	t
35574	89	0595	Guadalupe	160912.415	0940223.712	0010	E15C86	R	0	0	0	0	16.1534486	-94.0399200	t
35575	89	0597	El Palmar	160903.436	0940112.025	0006	E15C86	R	0	0	0	0	16.1509544	-94.0200069	t
35576	89	0598	La Rosita (El Carmen)	160915.505	0940219.140	0006	E15C86	R	0	0	0	0	16.1543069	-94.0386500	t
35577	89	0600	El Amatillo	160754.056	0935947.651	0003	E15C87	R	6	0	0	1	16.1316822	-93.9965697	t
35578	89	0601	San Pedro	160640.248	0935506.242	0007	E15C87	R	4	0	0	1	16.1111800	-93.9184006	t
35579	89	0602	Las µnimas	161741.320	0935715.005	0120	E15C77	R	0	0	0	0	16.2948111	-93.9541681	t
35580	89	0603	El Playal (El Arenal)	161756.806	0934901.720	0289	E15C77	R	4	0	0	1	16.2991128	-93.8171444	t
35581	89	0604	El Carmen	160811.004	0935814.988	0010	E15C87	R	0	0	0	0	16.1363900	-93.9708300	t
35582	89	0605	El Carnero	161135.158	0935335.759	0031	E15C87	R	0	0	0	0	16.1930994	-93.8932664	t
35583	89	0606	Las Carolinas	161200.590	0935736.990	0026	E15C87	R	4	0	0	1	16.2001639	-93.9602750	t
35584	89	0607	El Caminante	161254.148	0935127.281	0058	E15C87	R	1	0	0	1	16.2150411	-93.8575781	t
35585	89	0608	Los Chahuites	161442.074	0935904.096	0038	E15C87	R	8	0	0	2	16.2450206	-93.9844711	t
35586	89	0609	Chicozapotal	161806.393	0934853.318	0301	E15C77	R	3	0	0	1	16.3017758	-93.8148106	t
35587	89	0610	Sin Pensar	160946.441	0935431.701	0019	E15C87	R	11	0	0	2	16.1629003	-93.9088058	t
35588	89	0612	El Destino	160911.419	0935442.448	0016	E15C87	R	6	0	0	2	16.1531719	-93.9117911	t
35589	89	0613	El Diamante	161304.948	0934934.394	0104	E15C87	R	4	0	0	1	16.2180411	-93.8262206	t
35590	89	0614	El Diamante	160938.624	0935914.344	0012	E15C87	R	1	0	0	1	16.1607289	-93.9873178	t
35591	89	0616	El Enga¤o	161701.346	0935803.717	0061	E15C77	R	5	0	0	1	16.2837072	-93.9676992	t
35592	89	0617	El Ciruelo	161050.643	0935516.865	0026	E15C87	R	4	0	0	1	16.1807342	-93.9213514	t
35593	89	0618	La Esperanza	160701.299	0935455.411	0008	E15C87	R	6	0	0	1	16.1170275	-93.9153919	t
35594	89	0619	La Esperanza	160817.654	0935526.290	0011	E15C87	R	0	0	0	0	16.1382372	-93.9239694	t
35595	89	0620	El Guamuche	161435.686	0935522.574	0046	E15C87	R	0	0	0	0	16.2432461	-93.9229372	t
35596	89	0621	Guillermo Ramos	160849.852	0935435.614	0014	E15C87	R	0	0	0	0	16.1471811	-93.9098928	t
35597	89	0622	La Ilusi¢n	161235.526	0935425.075	0038	E15C87	R	3	0	0	1	16.2098683	-93.9069653	t
35598	89	0623	Iturbe	161316.271	0935159.867	0057	E15C87	R	0	0	0	0	16.2211864	-93.8666297	t
35599	89	0624	El Jes£s	160944.469	0935737.215	0016	E15C87	R	5	0	0	2	16.1623525	-93.9603375	t
35600	89	0625	Lomita de Tierra	161204.549	0935955.749	0025	E15C87	R	15	9	6	3	16.2012636	-93.9988192	t
35601	89	0626	Juan A. Iturbide C.	161256.006	0935137.167	0057	E15C87	R	0	0	0	0	16.2155572	-93.8603242	t
35602	89	0627	La Ladera	161330.739	0935237.238	0162	E15C87	R	6	0	0	1	16.2252053	-93.8770106	t
35603	89	0628	Los Laureles	161407.901	0934925.390	0147	E15C87	R	0	0	0	0	16.2355281	-93.8237194	t
35604	89	0629	Los Laureles	160959.364	0935900.871	0016	E15C87	R	2	0	0	1	16.1664900	-93.9835753	t
35605	89	0630	La Lechuguilla	161057.143	0935816.143	0019	E15C87	R	0	0	0	0	16.1825397	-93.9711508	t
35606	89	0631	Los Mangos	161328.232	0935740.190	0038	E15C87	R	3	0	0	1	16.2245089	-93.9611639	t
35607	89	0632	Lucitania	160748.480	0935444.300	0010	E15C87	R	0	0	0	0	16.1301333	-93.9123056	t
35608	89	0633	Lucitania Dos	160746.669	0935444.176	0010	E15C87	R	1	0	0	1	16.1296303	-93.9122711	t
35609	89	0634	Luis Hern ndez	161045.327	0940030.272	0017	E15C86	R	0	0	0	0	16.1792575	-94.0084089	t
35610	89	0635	El Sauce	161202.710	0935951.363	0025	E15C87	R	1	0	0	1	16.2007528	-93.9976008	t
35611	89	0638	El Coco (El Ojo de Agua)	161301.283	0934937.473	0104	E15C87	R	0	0	0	0	16.2170231	-93.8270758	t
35612	89	0639	Las Ma¤anitas	161640.541	0934754.175	0332	E15C77	R	0	0	0	0	16.2779281	-93.7983819	t
35613	89	0641	Las Mari¡tas	161201.461	0935307.823	0033	E15C87	R	0	0	0	0	16.2004058	-93.8855064	t
35614	89	0642	El Maracaibo	161525.034	0935544.047	0050	E15C77	R	5	0	0	1	16.2569539	-93.9289019	t
35615	89	0644	La Media Vuelta	161223.460	0940021.261	0024	E15C86	R	0	0	0	0	16.2065167	-94.0059058	t
35616	89	0645	La Galera	161442.238	0935544.020	0045	E15C87	R	0	0	0	0	16.2450661	-93.9288944	t
35617	89	0646	San Pedro	161540.560	0935908.510	0051	E15C77	R	0	0	0	0	16.2612667	-93.9856972	t
35618	89	0648	La Nueva Esperanza	160753.498	0935652.999	0009	E15C87	R	0	0	0	0	16.1315272	-93.9480553	t
35619	89	0649	El Ocot¢n	161529.877	0934837.008	0354	E15C77	R	0	0	0	0	16.2582992	-93.8102800	t
35620	89	0650	Oscar Guti‚rrez	161438.197	0935551.152	0044	E15C87	R	0	0	0	0	16.2439436	-93.9308756	t
35621	89	0651	El Para¡so	160927.000	0935430.996	0018	E15C87	R	5	0	0	1	16.1575000	-93.9086100	t
35622	89	0652	La Piedad	161216.407	0935711.478	0028	E15C87	R	0	0	0	0	16.2045575	-93.9531883	t
35623	89	0653	Los Pocitos	161251.393	0935142.396	0055	E15C87	R	5	0	0	1	16.2142758	-93.8617767	t
35624	89	0654	Fracci¢n el Porvenir	161138.342	0935729.861	0025	E15C87	R	3	0	0	1	16.1939839	-93.9582947	t
35625	89	0655	La Estancia	161226.772	0935642.283	0031	E15C87	R	0	0	0	0	16.2074367	-93.9450786	t
35626	89	0656	El Puente Roto	161842.965	0934838.799	0347	E15C77	R	3	0	0	1	16.3119347	-93.8107775	t
35627	89	0657	El Ramal	161107.319	0935756.233	0021	E15C87	R	7	0	0	1	16.1853664	-93.9656203	t
35628	89	0659	Rancho Nuevo	161144.051	0940429.152	0009	E15C86	R	0	0	0	0	16.1955697	-94.0747644	t
35629	89	0660	Rancho Solo	161135.033	0935922.306	0024	E15C87	R	0	0	0	0	16.1930647	-93.9895294	t
35630	89	0661	El Carmen (Rayo de Plata)	161309.590	0935257.513	0052	E15C87	R	0	0	0	0	16.2193306	-93.8826425	t
35631	89	0662	El Recuerdo	161253.344	0934943.251	0093	E15C87	R	0	0	0	0	16.2148178	-93.8286808	t
35632	89	0663	El Refugio	161447.697	0935510.905	0049	E15C87	R	0	0	0	0	16.2465825	-93.9196958	t
35633	89	0664	Corral de la Rejeguer¡a	161257.764	0935734.459	0030	E15C87	R	0	0	0	0	16.2160456	-93.9595719	t
35634	89	0666	San Antonio	160926.837	0935523.981	0016	E15C87	R	0	0	0	0	16.1574547	-93.9233281	t
35635	89	0667	San Antonio	161001.239	0935920.596	0014	E15C87	R	0	0	0	0	16.1670108	-93.9890544	t
35636	89	0668	San Bartolo	161222.317	0935804.204	0028	E15C87	R	0	0	0	0	16.2061992	-93.9678344	t
35637	89	0669	San Felipe	161140.744	0935747.853	0024	E15C87	R	0	0	0	0	16.1946511	-93.9632925	t
35638	89	0670	San Francisco	161300.881	0934942.116	0101	E15C87	R	1	0	0	1	16.2169114	-93.8283656	t
35639	89	0671	El Nuevo Potrillo	161144.351	0935209.723	0043	E15C87	R	0	0	0	0	16.1956531	-93.8693675	t
35640	89	0672	San Jacinto	160944.228	0935705.402	0017	E15C87	R	4	0	0	1	16.1622856	-93.9515006	t
35641	89	0673	San Jes£s (Monte Cristo)	161906.075	0940035.129	0098	E15C76	R	0	0	0	0	16.3183542	-94.0097581	t
35642	89	0674	Joel Rodr¡guez Flores	161242.832	0935009.759	0087	E15C87	R	1	0	0	1	16.2118978	-93.8360442	t
35643	89	0675	San Juan	161901.220	0934741.910	0400	E15C77	R	1	0	0	1	16.3170056	-93.7949750	t
35644	89	0676	San Juan	161111.245	0935247.306	0029	E15C87	R	7	0	0	1	16.1864569	-93.8798072	t
35645	89	0677	San Rafael	161652.917	0934820.021	0300	E15C77	R	0	0	0	0	16.2813658	-93.8055614	t
35646	89	0679	San Vicente	160816.494	0935814.070	0005	E15C87	R	0	0	0	0	16.1379150	-93.9705750	t
35647	89	0680	Santa Catalina	161236.170	0935126.753	0059	E15C87	R	4	0	0	1	16.2100472	-93.8574314	t
35648	89	0681	Santa Elena	161704.435	0934624.780	0541	E15C77	R	2	0	0	1	16.2845653	-93.7735500	t
35649	89	0682	Santa Elvira	161511.754	0934814.230	0297	E15C77	R	0	0	0	0	16.2532650	-93.8039528	t
35650	89	0683	Santa Isabel	160959.397	0935628.333	0020	E15C87	R	5	0	0	1	16.1664992	-93.9412036	t
35651	89	0684	San Antonio	161153.685	0935208.881	0047	E15C87	R	0	0	0	0	16.1982458	-93.8691336	t
35652	89	0685	El Portillo	161400.996	0935652.008	0038	E15C87	R	0	0	0	0	16.2336100	-93.9477800	t
35653	89	0686	Tamarindo	160744.790	0935610.812	0008	E15C87	R	4	0	0	1	16.1291083	-93.9363367	t
35654	89	0687	El Centenario (El Sesenta y Dos)	161219.789	0935328.939	0038	E15C87	R	0	0	0	0	16.2054969	-93.8913719	t
35655	89	0688	Genaro Santiago	161130.730	0935912.830	0023	E15C87	R	0	0	0	0	16.1918694	-93.9868972	t
35656	89	0689	Antonio Dom¡nguez	161154.697	0935159.877	0048	E15C87	R	0	0	0	0	16.1985269	-93.8666325	t
35657	89	0690	La Soledad	161117.838	0935933.937	0022	E15C87	R	0	0	0	0	16.1882883	-93.9927603	t
35658	89	0691	El Suspiro	161251.837	0940230.222	0005	E15C86	R	0	0	0	0	16.2143992	-94.0417283	t
35659	89	0692	Los Tamarindos	161245.658	0934955.837	0089	E15C87	R	4	0	0	1	16.2126828	-93.8321769	t
35660	89	0694	µurea Gallego	161136.430	0935909.511	0023	E15C87	R	0	0	0	0	16.1934528	-93.9859753	t
35661	89	0695	El Triunfo	160811.050	0935957.131	0004	E15C87	R	5	0	0	1	16.1364028	-93.9992031	t
35662	89	0697	La Veladora	161326.146	0935521.947	0040	E15C87	R	0	0	0	0	16.2239294	-93.9227631	t
35663	89	0698	Agua Dulce	161457.948	0935535.352	0048	E15C87	R	3	0	0	1	16.2494300	-93.9264867	t
35664	89	0699	Las Adas (San Carlos)	161223.945	0935113.983	0061	E15C87	R	3	0	0	1	16.2066514	-93.8538842	t
35665	89	0700	Alberto Flores Oca¤a	161241.085	0935123.088	0058	E15C87	R	0	0	0	0	16.2114125	-93.8564133	t
35666	89	0701	Uxmal	161007.448	0935441.152	0021	E15C87	R	0	0	0	0	16.1687356	-93.9114311	t
35667	89	0702	Humberto Mu¤iz	161258.460	0935138.460	0056	E15C87	R	0	0	0	0	16.2162389	-93.8606833	t
35668	89	0703	Nuevo Colosio	162007.187	0940058.079	0100	E15C76	R	40	19	21	14	16.3353297	-94.0161331	t
35669	89	0704	El Rub¡	160804.969	0935742.289	0007	E15C87	R	2	0	0	1	16.1347136	-93.9617469	t
35670	89	0705	Los Sauces (El Quinto)	161724.928	0935933.267	0067	E15C77	R	0	0	0	0	16.2902578	-93.9925742	t
35671	89	0706	El Suspiro	161823.009	0935232.023	0217	E15C77	R	0	0	0	0	16.3063914	-93.8755619	t
35672	89	0707	Tierra Blanca	161538.762	0935234.861	0124	E15C77	R	0	0	0	0	16.2607672	-93.8763503	t
35673	89	0708	La Alianza	161923.323	0935140.559	0500	E15C77	R	0	0	0	0	16.3231453	-93.8612664	t
35674	89	0709	Los Amores	161154.949	0940027.290	0021	E15C86	R	0	0	0	0	16.1985969	-94.0075806	t
35675	89	0710	Los Dos µngeles	160646.964	0935545.183	0007	E15C87	R	3	0	0	1	16.1130456	-93.9292175	t
35676	89	0711	El Brasil	161224.066	0935919.820	0028	E15C87	R	0	0	0	0	16.2066850	-93.9888389	t
35677	89	0712	El Carmen	161051.670	0935707.762	0024	E15C87	R	2	0	0	1	16.1810194	-93.9521561	t
35678	89	0713	La Ceiba	161250.716	0934948.297	0093	E15C87	R	1	0	0	1	16.2140878	-93.8300825	t
35679	89	0714	El Destino	161045.797	0935714.151	0023	E15C87	R	4	0	0	1	16.1793881	-93.9539308	t
35680	89	0715	La Esperanza	161927.011	0935855.719	0140	E15C77	R	0	0	0	0	16.3241697	-93.9821442	t
35681	89	0716	La Esperanza	160949.044	0935933.030	0011	E15C87	R	1	0	0	1	16.1636233	-93.9925083	t
35682	89	0718	El Rayanal	160945.805	0935434.031	0019	E15C87	R	2	0	0	1	16.1627236	-93.9094531	t
35683	89	0720	San Antonio	161812.647	0935232.020	0206	E15C77	R	4	0	0	1	16.3035131	-93.8755611	t
35684	89	0721	Las Palomas	161925.387	0940039.884	0103	E15C76	R	9	0	0	1	16.3237186	-94.0110789	t
35685	89	0722	Las P¡ldoras	162314.844	0940151.980	0460	E15C76	R	4	0	0	1	16.3874567	-94.0311056	t
35686	89	0723	El Porvenir	160834.008	0940224.239	0003	E15C86	R	0	0	0	0	16.1427800	-94.0400664	t
35687	89	0724	El Recuerdo	161639.000	0934801.008	0332	E15C77	R	2	0	0	1	16.2775000	-93.8002800	t
35688	89	0726	San Antonio	161307.632	0935149.638	0056	E15C87	R	0	0	0	0	16.2187867	-93.8637883	t
35689	89	0727	San Joaqu¡n	161547.092	0935153.179	0134	E15C77	R	9	0	0	2	16.2630811	-93.8647719	t
35690	89	0728	San Juditas	160954.914	0935501.806	0019	E15C87	R	0	0	0	0	16.1652539	-93.9171683	t
35691	89	0729	Santa Clara	161534.535	0935506.769	0063	E15C77	R	0	0	0	0	16.2595931	-93.9185469	t
35692	89	0730	Agripino Marroqu¡n	161203.573	0935329.069	0034	E15C87	R	0	0	0	0	16.2009925	-93.8914081	t
35693	89	0731	µngel Zavala P‚rez	161639.883	0934552.529	0462	E15C77	R	0	0	0	0	16.2777453	-93.7645914	t
35694	89	0732	Marcelino L¢pez	161259.044	0935727.504	0028	E15C87	R	0	0	0	0	16.2164011	-93.9576400	t
35695	89	0733	Tres Hermanos	160921.458	0935428.843	0017	E15C87	R	6	0	0	1	16.1559606	-93.9080119	t
35696	89	0734	Tres Potrillos	162250.016	0940145.012	0473	E15C76	R	0	0	0	0	16.3805600	-94.0291700	t
35697	89	0735	Los Tulipanes	161012.743	0935416.100	0021	E15C87	R	6	0	0	1	16.1702064	-93.9044722	t
35698	89	0736	El Vergel	161316.767	0935540.932	0036	E15C87	R	11	0	0	2	16.2213242	-93.9280367	t
35699	89	0737	La Esperanza	161954.932	0934748.475	0629	E15C77	R	1	0	0	1	16.3319256	-93.7967986	t
35700	89	0738	Gloria Moguel	161439.609	0934907.849	0179	E15C87	R	0	0	0	0	16.2443358	-93.8188469	t
35701	89	0740	El Higuito	161228.197	0935121.373	0060	E15C87	R	7	0	0	2	16.2078325	-93.8559369	t
35702	89	0741	Los Limoncitos	161101.755	0940334.420	0006	E15C86	R	9	0	0	2	16.1838208	-94.0595611	t
35703	89	0742	Los Mangos	161857.065	0934752.729	0397	E15C77	R	4	0	0	1	16.3158514	-93.7979803	t
35704	89	0743	Salto Chico	162005.016	0934822.570	0621	E15C77	R	3	0	0	1	16.3347267	-93.8062694	t
35705	89	0745	San Vicente	161407.153	0935011.399	0133	E15C87	R	1	0	0	1	16.2353203	-93.8364997	t
35706	89	0746	El Espejo	161132.785	0940317.793	0002	E15C86	R	0	0	0	0	16.1924403	-94.0549425	t
35707	89	0747	Jerusal‚n	161040.694	0940531.959	0002	E15C86	R	7	0	0	1	16.1779706	-94.0922108	t
35708	89	0748	El Manantial	161912.990	0940030.800	0106	E15C76	R	4	0	0	1	16.3202750	-94.0085556	t
35709	89	0749	Las Tranquitas	161851.399	0940036.152	0108	E15C76	R	6	0	0	1	16.3142775	-94.0100422	t
35710	89	0750	Tres Hermanos	162214.016	0940108.004	0185	E15C76	R	0	0	0	0	16.3705600	-94.0188900	t
35711	89	0751	San Andr‚s	161441.747	0935534.289	0046	E15C87	R	0	0	0	0	16.2449297	-93.9261914	t
35712	89	0752	Eben Ezer	161202.511	0935057.356	0063	E15C87	R	112	50	62	21	16.2006975	-93.8492656	t
35713	89	0753	Buenos Aires	161313.134	0935147.065	0057	E15C87	R	6	0	0	1	16.2203150	-93.8630736	t
35714	89	0754	Javier Alem n C.	160956.856	0935449.910	0019	E15C87	R	0	0	0	0	16.1657933	-93.9138639	t
35715	89	0755	Jes£s Llaven Toledo	161348.432	0935547.321	0037	E15C87	R	0	0	0	0	16.2301200	-93.9298114	t
35716	89	0756	Jorge Gonz lez	161453.245	0935552.220	0045	E15C87	R	0	0	0	0	16.2481236	-93.9311722	t
35717	89	0757	Jos‚ D. Pascacio P.	161250.106	0935337.801	0046	E15C87	R	6	0	0	1	16.2139183	-93.8938336	t
35718	89	0758	Lucila Gir¢n	160952.757	0935527.513	0019	E15C87	R	0	0	0	0	16.1646547	-93.9243092	t
35719	89	0759	Malpaso	161251.148	0935626.041	0031	E15C87	R	0	0	0	0	16.2142078	-93.9405669	t
35720	89	0760	Rancho Nuevo	161425.412	0935718.432	0046	E15C87	R	0	0	0	0	16.2403922	-93.9551200	t
35721	89	0761	Las Tejerias	161420.075	0935241.109	0067	E15C87	R	0	0	0	0	16.2389097	-93.8780858	t
35722	89	0762	Fracci¢n el Tri ngulo	161553.794	0935655.981	0049	E15C77	R	0	0	0	0	16.2649428	-93.9488836	t
35723	89	0763	Ninguno	161451.142	0935556.517	0044	E15C87	R	5	0	0	1	16.2475394	-93.9323658	t
35724	89	0764	La Nueva Concepci¢n	161943.098	0935901.221	0156	E15C77	R	0	0	0	0	16.3286383	-93.9836725	t
35725	89	0765	San Felipe Dos	161819.424	0935754.725	0114	E15C77	R	4	0	0	1	16.3053956	-93.9652014	t
35726	89	0766	El Totoposte	161651.589	0935728.989	0068	E15C77	R	0	0	0	0	16.2809969	-93.9580525	t
35727	89	0767	El Roble Dos	161726.340	0934651.549	0656	E15C77	R	0	0	0	0	16.2906500	-93.7809858	t
35728	89	0768	Las Mar¡as	161917.565	0940040.077	0101	E15C76	R	3	0	0	1	16.3215458	-94.0111325	t
35729	89	0769	El Ed‚n	161027.790	0940423.731	0007	E15C86	R	6	0	0	1	16.1743861	-94.0732586	t
35730	89	0770	Mi Ranchito	161252.233	0935959.109	0029	E15C87	R	4	0	0	1	16.2145092	-93.9997525	t
35731	89	0772	Rancho Quemado	161144.334	0935139.476	0047	E15C87	R	1	0	0	1	16.1956483	-93.8609656	t
35732	89	0773	San Mart¡n de las Flores	161858.166	0934844.822	0367	E15C77	R	7	0	0	1	16.3161572	-93.8124506	t
35733	89	0774	El Tepeyac	161842.597	0934728.290	0429	E15C77	R	2	0	0	1	16.3118325	-93.7911917	t
35734	89	0775	El Recuerdo	161944.000	0935150.000	0461	E15C77	R	1	0	0	1	16.3288889	-93.8638889	t
35735	89	0776	La Monta¤a	161000.750	0940524.874	0000	E15C86	R	0	0	0	0	16.1668750	-94.0902428	t
35736	89	0777	Las Perlas	161249.655	0935420.821	0042	E15C87	R	0	0	0	0	16.2137931	-93.9057836	t
35737	89	0778	Ninguno [Jos‚ Alvis Ramos Camacho]	161219.277	0935113.123	0059	E15C87	R	0	0	0	0	16.2053547	-93.8536453	t
35738	89	0779	El Morrito	160725.788	0940054.010	0001	E15C86	R	0	0	0	0	16.1238300	-94.0150028	t
35739	89	0780	Dos Arbolitos	160842.885	0935946.308	0006	E15C87	R	0	0	0	0	16.1452458	-93.9961967	t
35740	89	0781	El Rub¡	160942.806	0935748.900	0015	E15C87	R	0	0	0	0	16.1618906	-93.9635833	t
35741	89	0782	Rancho Grande	160641.891	0935513.575	0007	E15C87	R	0	0	0	0	16.1116364	-93.9204375	t
35742	89	0783	La Antorcha	161234.227	0935422.641	0038	E15C87	R	0	0	0	0	16.2095075	-93.9062892	t
35743	89	0784	La Fortuna	160948.883	0935435.808	0019	E15C87	R	0	0	0	0	16.1635786	-93.9099467	t
35744	89	0785	Las Nubes	161814.100	0935350.200	0380	E15C77	R	0	0	0	0	16.3039167	-93.8972778	t
35745	89	0786	Jardines del Valle	161206.284	0935108.650	0060	E15C87	R	0	0	0	0	16.2017456	-93.8524028	t
35746	89	0787	Jab¢n la Corona [F brica]	161257.838	0940126.853	0011	E15C86	R	0	0	0	0	16.2160661	-94.0241258	t
35747	89	0788	Mexifrutas [F brica]	161256.314	0940125.345	0010	E15C86	R	0	0	0	0	16.2156428	-94.0237069	t
35748	90	0001	Bejucal de Ocampo	152719.415	0920930.265	2316	D15B33	U	315	159	156	64	15.4553931	-92.1584069	t
35749	90	0002	Los Aguacatales	152932.564	0921127.437	2380	D15B33	R	392	182	210	64	15.4923789	-92.1909547	t
35750	90	0003	Buenavista	152621.828	0920909.048	2112	D15B33	R	170	75	95	32	15.4393967	-92.1525133	t
35751	90	0004	El Cercadillo	152818.679	0920721.489	0956	D15B33	R	285	141	144	52	15.4718553	-92.1226358	t
35752	90	0005	Justo Sierra	153243.476	0921048.092	2244	D15B23	R	107	63	44	18	15.5454100	-92.1800256	t
35753	90	0006	La Laguna	153130.397	0921022.016	2256	D15B23	R	575	303	272	96	15.5251103	-92.1727822	t
35754	90	0007	Ojo de Agua Grande	152924.729	0920944.571	2152	D15B33	R	609	306	303	115	15.4902025	-92.1623808	t
35755	90	0009	El Pino	152722.763	0920948.060	2362	D15B33	R	530	274	256	99	15.4563231	-92.1633500	t
35756	90	0010	Las Tablas	152746.688	0921150.280	2600	D15B33	R	217	116	101	42	15.4629689	-92.1973000	t
35757	90	0011	La Nueva Libertad	152718.272	0921048.272	2606	D15B33	R	237	125	112	42	15.4550756	-92.1800756	t
35758	90	0012	Reforma	153205.049	0920717.829	0727	D15B23	R	730	366	364	143	15.5347358	-92.1216192	t
35759	90	0013	Palmar Chiquito	152905.057	0920753.143	1258	D15B33	R	41	20	21	7	15.4847381	-92.1314286	t
35760	90	0015	El Caballete	153005.511	0920742.208	1298	D15B23	R	232	112	120	45	15.5015308	-92.1283911	t
35761	90	0016	La Calera	152853.152	0920714.286	0821	D15B33	R	12	0	0	2	15.4814311	-92.1206350	t
35762	90	0017	El Molino	153022.138	0920854.718	2147	D15B23	R	483	250	233	77	15.5061494	-92.1485328	t
35763	90	0018	Nuevo Parralito	153049.517	0920745.841	1256	D15B23	R	129	73	56	21	15.5137547	-92.1294003	t
35764	90	0019	Ojo de Agua Centro	152951.505	0921022.804	2292	D15B33	R	896	464	432	149	15.4976403	-92.1730011	t
35765	90	0020	Las Pilas del Sicil	153045.805	0921016.388	2183	D15B23	R	212	104	108	34	15.5127236	-92.1712189	t
35766	90	0026	La Hacienda	153148.398	0921104.486	2222	D15B23	R	306	143	163	38	15.5301106	-92.1845794	t
35767	90	0027	Altamirano	152823.694	0921122.617	2628	D15B33	R	184	102	82	32	15.4732483	-92.1896158	t
35768	90	0028	La Soledad	153131.133	0920951.252	2085	D15B23	R	142	75	67	17	15.5253147	-92.1642367	t
35769	90	0029	El Lim¢n	152752.269	0921148.323	2633	D15B33	R	101	48	53	14	15.4645192	-92.1967564	t
35770	90	0030	Barrio Nuevo	152735.153	0921147.645	2656	D15B33	R	76	42	34	11	15.4597647	-92.1965681	t
35771	90	0031	Las Pilas	153115.934	0920708.670	0826	D15B23	R	144	60	84	25	15.5210928	-92.1190750	t
35772	90	0032	Yalinc£n	152737.914	0920904.830	2145	D15B33	R	61	30	31	10	15.4605317	-92.1513417	t
35773	90	0033	El Portal	152808.004	0920955.008	2489	D15B33	R	0	0	0	0	15.4688900	-92.1652800	t
35774	90	0034	Pe¤a Flor	152634.670	0920852.404	1950	D15B33	R	22	10	12	3	15.4429639	-92.1478900	t
35775	90	0035	Crest¢n del Gallo	152919.727	0920851.776	2165	D15B33	R	24	13	11	4	15.4888131	-92.1477156	t
35776	90	0036	El Sabinal	153027.310	0920720.276	1022	D15B23	R	33	16	17	8	15.5075861	-92.1222989	t
35777	90	0037	Banderas	152819.483	0921059.926	2699	D15B33	R	25	9	16	4	15.4720786	-92.1833128	t
35778	90	0038	Santa Mar¡a	152749.726	0920812.890	1504	D15B33	R	9	0	0	1	15.4638128	-92.1369139	t
35779	90	0039	Rancho Escondido	152959.481	0920700.353	0798	D15B33	R	12	4	8	3	15.4998558	-92.1167647	t
35780	90	0040	Cal y Canto	152904.807	0920728.237	0982	D15B33	R	0	0	0	0	15.4846686	-92.1245103	t
35781	90	0041	El Palmar Grande	153019.324	0920701.467	0853	D15B23	R	100	50	50	16	15.5053678	-92.1170742	t
35782	90	0042	El Triunfo	152921.929	0921052.772	2454	D15B33	R	143	75	68	26	15.4894247	-92.1813256	t
35783	90	0043	Loma Bonita	152956.298	0920928.699	2182	D15B33	R	69	34	35	11	15.4989717	-92.1579719	t
35784	90	0044	Nuevo Rosario	153103.118	0921113.274	2503	D15B23	R	0	0	0	0	15.5175328	-92.1870206	t
35785	90	0045	El Para¡so	153008.024	0920925.899	2158	D15B23	R	0	0	0	0	15.5022289	-92.1571942	t
35786	91	0001	Bella Vista	153458.540	0921441.155	1580	D15B23	U	1672	816	856	344	15.5829278	-92.2447653	t
35787	91	0002	Allende	153921.353	0921324.793	1206	D15B23	R	229	118	111	49	15.6559314	-92.2235536	t
35788	91	0003	Chemic	153533.893	0920932.344	0677	D15B23	R	369	185	184	79	15.5927481	-92.1589844	t
35789	91	0004	Emiliano Zapata	154012.415	0921419.170	0623	D15B23	R	1232	605	627	270	15.6701153	-92.2386583	t
35790	91	0005	La Hacienda	153858.013	0921654.733	1794	D15B23	R	636	308	328	121	15.6494481	-92.2818703	t
35791	91	0006	La Laguna	153403.794	0921334.610	2062	D15B23	R	200	105	95	31	15.5677206	-92.2262806	t
35792	91	0007	La Noria	153951.984	0921618.012	1270	D15B23	R	195	98	97	44	15.6644400	-92.2716700	t
35793	91	0008	Las Nubes	153340.059	0921221.646	2211	D15B23	R	206	98	108	33	15.5611275	-92.2060128	t
35794	91	0009	Nuevo Yucat n	153737.354	0921148.445	1485	D15B23	R	326	161	165	57	15.6270428	-92.1967903	t
35795	91	0010	Ojo de Agua Campana	154052.782	0921707.752	1050	D15B23	R	21	13	8	3	15.6813283	-92.2854867	t
35796	91	0011	Nuevo Pacayal	153934.667	0921855.951	0672	D15B23	R	1019	498	521	219	15.6596297	-92.3155419	t
35797	91	0012	Pacayal Viejo	153805.374	0921831.960	1219	D15B23	R	428	222	206	77	15.6348261	-92.3088778	t
35798	91	0013	El Platanar	153759.278	0921505.022	0859	D15B23	R	387	183	204	77	15.6331328	-92.2513950	t
35799	91	0014	El Progreso	153513.192	0921301.061	1647	D15B23	R	965	482	483	185	15.5869978	-92.2169614	t
35800	91	0015	La Rinconada	153538.372	0921606.286	1564	D15B23	R	1078	544	534	209	15.5939922	-92.2684128	t
35801	91	0016	San Jos‚ las Chicharras	153836.816	0921222.535	1494	D15B23	R	1080	514	566	217	15.6435600	-92.2062597	t
35802	91	0017	San Juan Progreso	153704.587	0920905.471	0664	D15B23	R	420	202	218	87	15.6179408	-92.1515197	t
35803	91	0018	Las Tablas	153352.438	0921738.274	2440	D15B23	R	182	81	101	26	15.5645661	-92.2939650	t
35804	91	0019	Las Chicharras	154013.443	0921240.156	0649	D15B23	R	1324	664	660	271	15.6704008	-92.2111544	t
35805	91	0020	Uni¢n Progreso	153509.459	0921344.075	1625	D15B23	R	585	271	314	117	15.5859608	-92.2289097	t
35806	91	0021	Zaragoza	153536.510	0921823.267	2120	D15B23	R	216	108	108	36	15.5934750	-92.3064631	t
35807	91	0022	Las Flores	153758.094	0921205.448	1572	D15B23	R	412	200	212	72	15.6328039	-92.2015133	t
35808	91	0023	Los Pocitos	153414.257	0921504.884	1940	D15B23	R	75	38	37	13	15.5706269	-92.2513567	t
35809	91	0024	Cueva del Arco	153802.836	0921051.422	0983	D15B23	R	139	72	67	29	15.6341211	-92.1809506	t
35810	91	0025	El Caballete	153617.791	0921428.846	1668	D15B23	R	188	88	100	28	15.6049419	-92.2413461	t
35811	91	0026	La Ca¤ada	153828.488	0921532.499	1091	D15B23	R	74	40	34	15	15.6412467	-92.2590275	t
35812	91	0027	Monte Florido	153849.021	0921333.114	1055	D15B23	R	6	0	0	1	15.6469503	-92.2258650	t
35813	91	0028	Puente Carranza	153544.087	0921509.093	1380	D15B23	R	117	57	60	23	15.5955797	-92.2525258	t
35814	91	0030	El Zapotal	153847.038	0921110.865	0882	D15B23	R	16	9	7	4	15.6463994	-92.1863514	t
35815	91	0032	Caballo Blanco	153703.827	0921521.765	1040	D15B23	R	83	43	40	19	15.6177297	-92.2560458	t
35816	91	0034	Minerva	153334.202	0921536.247	2361	D15B23	R	174	83	91	29	15.5595006	-92.2600686	t
35817	91	0036	La Mesilla	153506.505	0921629.932	2029	D15B23	R	52	24	28	10	15.5851403	-92.2749811	t
35818	91	0038	El Bojonal	153923.363	0921738.867	1164	D15B23	R	0	0	0	0	15.6564897	-92.2941297	t
35819	91	0039	C rdenas Ojo de Agua	153653.732	0921102.483	1187	D15B23	R	334	158	176	78	15.6149256	-92.1840231	t
35820	91	0043	El Vergel la Rinconada	153620.644	0921709.961	1961	D15B23	R	94	49	45	13	15.6057344	-92.2861003	t
35821	91	0046	Esmeralda el Recuerdo	153831.669	0921117.729	0992	D15B23	R	29	13	16	6	15.6421303	-92.1882581	t
35822	91	0051	La Independencia	153404.176	0921651.294	2365	D15B23	R	357	166	191	64	15.5678267	-92.2809150	t
35823	91	0053	La Lucha	153634.790	0921055.621	1373	D15B23	R	88	40	48	20	15.6096639	-92.1821169	t
35824	91	0055	Malpaso	153632.611	0921509.724	1126	D15B23	R	16	8	8	4	15.6090586	-92.2527011	t
35825	91	0059	El Tarral	153949.974	0921456.641	0856	D15B23	R	2	0	0	1	15.6638817	-92.2490669	t
35826	91	0060	El Plan	153901.013	0921450.674	0713	D15B23	R	36	15	21	8	15.6502814	-92.2474094	t
35827	91	0063	Veinte de Noviembre	153453.884	0921221.425	1643	D15B23	R	249	129	120	51	15.5816344	-92.2059514	t
35828	91	0064	Tres Picos	153605.168	0921006.365	1213	D15B23	R	29	13	16	4	15.6014356	-92.1684347	t
35829	91	0070	La Laguna	153458.314	0921842.393	2380	D15B23	R	67	44	23	11	15.5828650	-92.3117758	t
35830	91	0071	El Boquer¢n	153623.921	0921634.552	1882	D15B23	R	11	0	0	2	15.6066447	-92.2762644	t
35831	91	0072	Montevideo	153704.757	0921404.003	2082	D15B23	R	0	0	0	0	15.6179881	-92.2344453	t
35832	91	0073	Ojo de Agua	153613.914	0921746.108	2106	D15B23	R	113	62	51	24	15.6038650	-92.2961411	t
35833	91	0074	La Pinadita	154027.086	0921640.298	1320	D15B23	R	64	31	33	11	15.6741906	-92.2778606	t
35834	91	0075	El Platanarcito	154037.454	0921715.311	1010	D15B23	R	3	0	0	1	15.6770706	-92.2875864	t
35835	91	0076	Los Arroyos	154029.810	0921732.745	0865	D15B23	R	0	0	0	0	15.6749472	-92.2924292	t
35836	91	0078	Ojo de Agua el Palmar	153923.037	0921548.909	1379	D15B23	R	14	8	6	3	15.6563992	-92.2635858	t
35837	91	0079	Nueva Irlanda	153733.918	0921507.384	1065	D15B23	R	10	7	3	3	15.6260883	-92.2520511	t
35838	91	0081	El Pozolero	153724.121	0921521.384	0998	D15B23	R	5	0	0	1	15.6233669	-92.2559400	t
35839	91	0082	La Lucha San Marcos	153512.290	0921419.850	1464	D15B23	R	121	62	59	25	15.5867472	-92.2388472	t
35840	91	0083	Guadalupe	153533.278	0921252.984	1570	D15B23	R	280	141	139	49	15.5925772	-92.2147178	t
35841	91	0084	Monte Flor	153644.560	0921120.275	1532	D15B23	R	146	69	77	32	15.6123778	-92.1889653	t
35842	91	0085	Sintular	154107.074	0921359.775	0620	D15B23	R	0	0	0	0	15.6852983	-92.2332708	t
35843	91	0088	Loma del Ocote	153850.688	0921054.756	0780	D15B23	R	17	7	10	4	15.6474133	-92.1818767	t
35844	91	0089	Los Pocitos	153756.311	0921102.719	1067	D15B23	R	120	65	55	23	15.6323086	-92.1840886	t
35845	91	0091	Puente Ju rez	153423.016	0921417.988	1461	D15B23	R	0	0	0	0	15.5730600	-92.2383300	t
35846	91	0094	El Chilar	154040.372	0921234.548	0646	D15B23	R	69	32	37	10	15.6778811	-92.2095967	t
35847	91	0095	La Avanzada	153948.360	0921425.290	0720	D15B23	R	15	9	6	5	15.6634333	-92.2403583	t
35848	91	0099	Constancia	153531.937	0921427.433	1427	D15B23	R	7	0	0	1	15.5922047	-92.2409536	t
35849	91	0100	Saltillo	153539.211	0921425.784	1431	D15B23	R	2	0	0	2	15.5942253	-92.2404956	t
35850	91	0101	El Cedro	153423.248	0921610.872	2241	D15B23	R	157	81	76	26	15.5731244	-92.2696867	t
35851	91	0103	Buenavista	153445.760	0921736.800	2394	D15B23	R	100	54	46	17	15.5793778	-92.2935556	t
35852	91	0105	Libertad la Fuente	153534.170	0921719.879	2085	D15B23	R	192	98	94	33	15.5928250	-92.2888553	t
35853	91	0106	San Antonio	153349.420	0921720.960	2437	D15B23	R	267	123	144	43	15.5637278	-92.2891556	t
35854	91	0107	Paso Lim¢n	154129.688	0921316.425	0623	D15B23	R	105	55	50	25	15.6915800	-92.2212292	t
35855	91	0108	Tierra Colorada	153657.601	0920940.015	0680	D15B23	R	16	0	0	1	15.6160003	-92.1611153	t
35856	91	0110	Los Lagos	153316.404	0921123.560	2165	D15B23	R	207	109	98	31	15.5545567	-92.1898778	t
35857	91	0111	El Sabinalito	153349.723	0921358.462	1831	D15B23	R	73	35	38	14	15.5638119	-92.2329061	t
35858	91	0112	Cuatro Caminos	153524.050	0921238.692	1547	D15B23	R	343	187	156	61	15.5900139	-92.2107478	t
35859	91	0113	Guadalupe	153816.008	0921843.992	1094	D15B23	R	173	88	85	33	15.6377800	-92.3122200	t
35860	91	0114	Nuevo Maravillas	153822.516	0921045.053	0893	D15B23	R	8	0	0	1	15.6395878	-92.1791814	t
35861	91	0115	San Francisco	153851.095	0921207.596	1304	D15B23	R	59	27	32	12	15.6475264	-92.2021100	t
35862	91	0116	Nueva Estrella	153639.797	0921054.895	1296	D15B23	R	42	21	21	7	15.6110547	-92.1819153	t
35863	91	0117	El Cipr‚s	153407.167	0921328.667	2083	D15B23	R	96	52	44	17	15.5686575	-92.2246297	t
35864	91	0118	El Para¡so	153335.434	0921211.729	2200	D15B23	R	119	53	66	19	15.5598428	-92.2032581	t
35865	91	0119	La Delicia	153633.673	0921437.316	1650	D15B23	R	57	29	28	10	15.6093536	-92.2436989	t
35866	91	0120	Barrio Guadalupe	154142.000	0921336.984	0621	D15B23	R	199	88	111	42	15.6950000	-92.2269400	t
35867	91	0121	Los Ram¡rez	153358.112	0921555.701	2175	D15B23	R	98	57	41	20	15.5661422	-92.2654725	t
35868	91	0122	Los Llanitos	153430.775	0921653.660	2320	D15B23	R	220	104	116	37	15.5752153	-92.2815722	t
35869	91	0123	Rancho Nuevo	153639.555	0921158.291	2002	D15B23	R	9	0	0	1	15.6109875	-92.1995253	t
35870	91	0124	Los Tres Puentes	153337.463	0921609.301	2357	D15B23	R	337	161	176	57	15.5604064	-92.2692503	t
35871	91	0125	Rancho Iris	153427.010	0921421.141	1397	D15B23	R	0	0	0	0	15.5741694	-92.2392058	t
35872	91	0126	Rinc¢n el Ocote	153759.930	0920947.420	0750	D15B23	R	0	0	0	0	15.6333139	-92.1631722	t
35873	91	0127	Milpas Viejas	154009.780	0921403.520	0625	D15B23	R	0	0	0	0	15.6693833	-92.2343111	t
35874	91	0129	La Fuente	153504.528	0921247.072	1645	D15B23	R	0	0	0	0	15.5845911	-92.2130756	t
35875	92	0001	Berrioz bal	164801.155	0931623.777	0911	E15C59	U	28128	14027	14101	6001	16.8003208	-93.2732714	t
35876	92	0004	Alsacia	165119.319	0932223.331	0921	E15C58	R	7	0	0	1	16.8553664	-93.3731475	t
35877	92	0007	Bel‚n	164722.278	0931435.096	0840	E15C59	R	0	0	0	0	16.7895217	-93.2430822	t
35878	92	0008	Berl¡n	164920.323	0932051.943	0979	E15C58	R	410	198	212	79	16.8223119	-93.3477619	t
35879	92	0013	La Caba¤a	165103.893	0931710.476	1075	E15C59	R	0	0	0	0	16.8510814	-93.2862433	t
35880	92	0015	El Cairo	165407.684	0932006.734	0737	E15C58	R	13	8	5	4	16.9021344	-93.3352039	t
35881	92	0016	El Calvario	164619.100	0931707.007	0936	E15C59	R	8	0	0	2	16.7719722	-93.2852797	t
35882	92	0017	Las Camelias	165233.865	0932406.008	0799	E15C58	R	72	41	31	12	16.8760736	-93.4016689	t
35883	92	0018	Candelaria	164514.141	0931741.229	0974	E15C59	R	9	4	5	3	16.7539281	-93.2947858	t
35884	92	0020	El Capricho	164702.869	0931349.274	0808	E15C59	R	2	0	0	1	16.7841303	-93.2303539	t
35885	92	0021	El Caracol	165332.908	0931958.423	0893	E15C59	R	60	33	27	12	16.8924744	-93.3328953	t
35886	92	0022	El Carmen	165339.467	0932513.773	0809	E15C58	R	16	9	7	4	16.8942964	-93.4204925	t
35887	92	0026	El Clavel	165248.762	0932405.580	0798	E15C58	R	148	74	74	30	16.8802117	-93.4015500	t
35888	92	0028	Santa Cruz (Las Cruces)	165358.974	0931924.591	0919	E15C59	R	8	0	0	1	16.8997150	-93.3234975	t
35889	92	0030	La Nueva Esperanza	164929.788	0932020.477	0962	E15C58	R	236	125	111	43	16.8249411	-93.3390214	t
35890	92	0032	El Danubio	165728.288	0932127.596	0304	E15C58	R	159	83	76	34	16.9578578	-93.3576656	t
35891	92	0035	Dolores	165051.264	0932158.676	0925	E15C58	R	7	0	0	1	16.8475733	-93.3662989	t
35892	92	0038	Efra¡n A. Guti‚rrez	165255.399	0931746.934	1000	E15C59	R	576	279	297	111	16.8820553	-93.2963706	t
35893	92	0040	Santa Rosa (La F brica)	165212.216	0932343.130	0805	E15C58	R	8	0	0	1	16.8700600	-93.3953139	t
35894	92	0042	Flor de Coraz¢n	165247.977	0931938.414	1031	E15C59	R	6	0	0	1	16.8799936	-93.3273372	t
35895	92	0043	San Antonio (El Recuerdo)	164315.472	0931736.096	0916	E15C69	R	0	0	0	0	16.7209644	-93.2933600	t
35896	92	0048	El Franc‚s	165245.596	0932406.402	0819	E15C58	R	151	77	74	31	16.8793322	-93.4017783	t
35897	92	0050	La Gloria	165150.758	0932156.488	0918	E15C58	R	0	0	0	0	16.8640994	-93.3656911	t
35898	92	0053	Ignacio Zaragoza	165837.518	0932044.463	0518	E15C58	R	1354	673	681	295	16.9770883	-93.3456842	t
35899	92	0055	Joaqu¡n Miguel Guti‚rrez	165606.434	0932055.794	0527	E15C58	R	357	188	169	85	16.9351206	-93.3488317	t
35900	92	0057	Paso Lim¢n	170131.382	0932140.699	0181	E15C48	R	35	20	15	10	17.0253839	-93.3613053	t
35901	92	0059	Las Maravillas	165728.078	0931914.186	0275	E15C59	R	1339	675	664	345	16.9577994	-93.3206072	t
35902	92	0061	Nuevo Montecristo	165614.445	0931827.730	0329	E15C59	R	252	137	115	55	16.9373458	-93.3077028	t
35903	92	0064	Monte Tabor	165810.992	0932308.988	0497	E15C58	R	0	0	0	0	16.9697200	-93.3858300	t
35904	92	0066	El Olivo (Geyfer)	165019.781	0932231.433	0938	E15C58	R	11	0	0	1	16.8388281	-93.3753981	t
35905	92	0069	El Palmar	164646.742	0931708.346	0951	E15C59	R	8	0	0	2	16.7796506	-93.2856517	t
35906	92	0071	Las Pampas	164842.572	0931916.032	1001	E15C59	R	23	12	11	4	16.8118256	-93.3211200	t
35907	92	0072	Paso Naranjo	165013.755	0931616.014	1014	E15C59	R	0	0	0	0	16.8371542	-93.2711150	t
35908	92	0075	Las Pe¤as	165315.421	0931826.283	0928	E15C59	R	0	0	0	0	16.8876169	-93.3073008	t
35909	92	0076	San Marcos	165008.239	0932106.336	0941	E15C58	R	8	0	0	1	16.8356219	-93.3517600	t
35910	92	0081	La Providencia	164916.127	0931953.534	0960	E15C59	R	15	0	0	2	16.8211464	-93.3315372	t
35911	92	0088	El Rosario	165138.538	0931702.124	1090	E15C59	R	2	0	0	1	16.8607050	-93.2839233	t
35912	92	0090	El Sabino	164833.753	0931922.483	1000	E15C59	R	1	0	0	1	16.8093758	-93.3229119	t
35913	92	0091	El Sabino	164652.678	0931234.706	0678	E15C59	R	543	269	274	141	16.7812994	-93.2096406	t
35914	92	0093	San Antonio Bombano	164515.042	0931822.306	0952	E15C59	R	91	43	48	21	16.7541783	-93.3061961	t
35915	92	0094	San Francisco el T£nez	165217.863	0931837.099	1045	E15C59	R	7	0	0	2	16.8716286	-93.3103053	t
35916	92	0095	San Francisco	164621.505	0931653.134	0938	E15C59	R	141	79	62	26	16.7726403	-93.2814261	t
35917	92	0096	San Isidro	165347.852	0931810.060	0794	E15C59	R	6	0	0	1	16.8966256	-93.3027944	t
35918	92	0098	San Joaqu¡n	165253.016	0931900.356	1058	E15C59	R	26	9	17	6	16.8813933	-93.3167656	t
35919	92	0101	San Juan	165108.021	0931731.439	1080	E15C59	R	14	9	5	3	16.8522281	-93.2920664	t
35920	92	0103	La Monta¤a	165151.066	0931800.111	1031	E15C59	R	7	0	0	1	16.8641850	-93.3000308	t
35921	92	0107	Santa B rbara	164959.442	0932017.497	0961	E15C58	R	2	0	0	1	16.8331783	-93.3381936	t
35922	92	0109	Santa In‚s Bellavista	164543.142	0931648.692	0926	E15C59	R	70	34	36	17	16.7619839	-93.2801922	t
35923	92	0110	El Potrillo	165253.139	0931946.265	1005	E15C59	R	0	0	0	0	16.8814275	-93.3295181	t
35924	92	0112	Santa Rosa	165057.985	0931708.657	1063	E15C59	R	11	0	0	1	16.8494403	-93.2857381	t
35925	92	0116	El Tepeyac	164614.666	0931714.357	0938	E15C59	R	2	0	0	1	16.7707406	-93.2873214	t
35926	92	0117	El Tirol	165256.455	0931923.469	0999	E15C59	R	78	39	39	19	16.8823486	-93.3231858	t
35927	92	0119	Bombano Tres Hermanos	164510.223	0931848.858	0987	E15C59	R	20	9	11	4	16.7528397	-93.3135717	t
35928	92	0121	El Triunfo	164518.600	0931750.088	0971	E15C59	R	4	0	0	1	16.7551667	-93.2972467	t
35929	92	0123	El Turipache	165400.873	0932222.712	0840	E15C58	R	1	0	0	1	16.9002425	-93.3729756	t
35930	92	0124	Verapaz	165127.082	0931718.096	1108	E15C59	R	0	0	0	0	16.8575228	-93.2883600	t
35931	92	0128	El Ocote	165713.915	0931842.022	0303	E15C59	R	0	0	0	0	16.9538653	-93.3116728	t
35932	92	0134	Lindavista	164551.724	0931442.556	0841	E15C59	R	6	0	0	1	16.7643678	-93.2451544	t
35933	92	0135	El Lim¢n	165642.181	0932155.844	0554	E15C58	R	16	8	8	3	16.9450503	-93.3655122	t
35934	92	0137	La Herradura	165557.815	0932158.827	0437	E15C58	R	22	13	9	5	16.9327264	-93.3663408	t
35935	92	0138	Los Altos de San Jos‚ (Palo Alto)	164843.027	0932147.298	1048	E15C58	R	19	8	11	3	16.8119519	-93.3631383	t
35936	92	0139	El Zapote	165219.366	0931932.553	1079	E15C59	R	0	0	0	0	16.8720461	-93.3257092	t
35937	92	0140	La Libertad	165431.561	0931954.482	0779	E15C59	R	0	0	0	0	16.9087669	-93.3318006	t
35938	92	0141	El Para¡so	165213.433	0932401.798	0823	E15C58	R	98	47	51	16	16.8703981	-93.4004994	t
35939	92	0146	Vistahermosa	165037.818	0931804.562	1179	E15C59	R	237	115	122	52	16.8438383	-93.3012672	t
35940	92	0148	San Mart¡n	165215.013	0931902.393	1067	E15C59	R	6	0	0	1	16.8708369	-93.3173314	t
35941	92	0149	Montebello	165623.289	0931752.161	0459	E15C59	R	0	0	0	0	16.9398025	-93.2978225	t
35942	92	0150	San Pedro Bombano	164516.209	0931802.263	0953	E15C59	R	39	19	20	6	16.7545025	-93.3006286	t
35943	92	0154	Chucamay	164600.952	0931707.958	0931	E15C59	R	11	0	0	2	16.7669311	-93.2855439	t
35944	92	0155	Los Pinos	164553.191	0931715.487	0941	E15C59	R	11	5	6	3	16.7647753	-93.2876353	t
35945	92	0159	La Victoria	164857.188	0931853.518	1015	E15C59	R	0	0	0	0	16.8158856	-93.3148661	t
35946	92	0160	San Antonio el Tri ngulo	164604.463	0931648.975	0930	E15C59	R	0	0	0	0	16.7679064	-93.2802708	t
35947	92	0161	Santa Sof¡a	164918.507	0931946.007	0956	E15C59	R	3	0	0	1	16.8218075	-93.3294464	t
35948	92	0168	Bonanza	164850.507	0932107.295	1001	E15C58	R	0	0	0	0	16.8140297	-93.3520264	t
35949	92	0169	San Jos‚ de los Naranjos	164913.400	0932121.779	1011	E15C58	R	10	0	0	2	16.8203889	-93.3560497	t
35950	92	0170	La Peregrina (La Pantalla)	164932.931	0932154.476	0983	E15C58	R	1	0	0	1	16.8258142	-93.3651322	t
35951	92	0172	San Jos‚ la Laguna	165339.986	0932002.193	0839	E15C58	R	4	0	0	1	16.8944406	-93.3339425	t
35952	92	0174	El Chinal Buenavista	165338.331	0931910.339	0957	E15C59	R	0	0	0	0	16.8939808	-93.3195386	t
35953	92	0175	Las Limas	165312.632	0932519.012	0909	E15C58	R	20	10	10	4	16.8868422	-93.4219478	t
35954	92	0179	San Jorge	164503.033	0931838.823	0980	E15C59	R	3	0	0	1	16.7508425	-93.3107842	t
35955	92	0180	Benito Ju rez	165743.344	0932139.872	0308	E15C58	R	228	117	111	53	16.9620400	-93.3610756	t
35956	92	0183	Buenos Aires	164744.480	0931403.405	0863	E15C59	R	17	10	7	3	16.7956889	-93.2342792	t
35957	92	0196	Uni¢n Hidalgo	165824.694	0932350.631	0357	E15C58	R	153	77	76	21	16.9735261	-93.3973975	t
35958	92	0197	Chicozapote	165837.415	0932246.317	0502	E15C58	R	4	0	0	1	16.9770597	-93.3795325	t
35959	92	0202	Paso de la Amistad	165716.289	0932141.304	0449	E15C58	R	0	0	0	0	16.9545247	-93.3614733	t
35960	92	0203	R¡o Blanco	165614.879	0931837.268	0314	E15C59	R	75	36	39	18	16.9374664	-93.3103522	t
35961	92	0205	Mi Lupita	165554.123	0932109.316	0635	E15C58	R	0	0	0	0	16.9317008	-93.3525878	t
35962	92	0207	La Primavera	165552.344	0931945.726	0745	E15C59	R	5	0	0	1	16.9312067	-93.3293683	t
35963	92	0211	Buenavista	165822.538	0932155.394	0578	E15C58	R	106	51	55	22	16.9729272	-93.3653872	t
35964	92	0213	Las Limas	165342.150	0931759.250	0861	E15C59	R	0	0	0	0	16.8950417	-93.2997917	t
35965	92	0214	Guadalupe	165258.345	0931758.964	0979	E15C59	R	0	0	0	0	16.8828736	-93.2997122	t
35966	92	0216	El Retiro	165215.069	0931923.111	1100	E15C59	R	9	0	0	2	16.8708525	-93.3230864	t
35967	92	0219	La Rosaria	165227.146	0931836.572	1047	E15C59	R	9	0	0	1	16.8742072	-93.3101589	t
35968	92	0222	El Girol	165326.720	0931847.542	1023	E15C59	R	8	0	0	2	16.8907556	-93.3132061	t
35969	92	0225	Montebello	165218.434	0931918.059	1099	E15C59	R	25	13	12	7	16.8717872	-93.3216831	t
35970	92	0229	La Conformidad (El Retazo)	165205.325	0932137.915	0906	E15C58	R	0	0	0	0	16.8681458	-93.3605319	t
35971	92	0230	Las Vistas	165310.405	0932510.343	0897	E15C58	R	6	0	0	2	16.8862236	-93.4195397	t
35972	92	0233	El Cerr¢n	165230.166	0932152.531	0907	E15C58	R	0	0	0	0	16.8750461	-93.3645919	t
35973	92	0234	El Potrero	165322.549	0932322.106	0788	E15C58	R	8	0	0	1	16.8895969	-93.3894739	t
35974	92	0238	El Mirador	165157.417	0932121.615	1032	E15C58	R	39	18	21	7	16.8659492	-93.3560042	t
35975	92	0239	El Domino	165028.809	0932145.974	0964	E15C58	R	0	0	0	0	16.8413358	-93.3627706	t
35976	92	0240	Loma Linda (Palo Alto)	164834.824	0932159.227	1061	E15C58	R	31	15	16	4	16.8096733	-93.3664519	t
35977	92	0241	San Jos‚ la Esperanza	165254.113	0931721.460	0960	E15C59	R	5	0	0	1	16.8816981	-93.2892944	t
35978	92	0242	San Jos‚ Porvenir	165246.306	0931736.647	0971	E15C59	R	10	0	0	1	16.8795294	-93.2935131	t
35979	92	0244	San Pedro el Tabl¢n	165037.803	0931700.841	1037	E15C59	R	0	0	0	0	16.8438342	-93.2835669	t
35980	92	0245	El Carmen	164957.333	0931640.773	1023	E15C59	R	14	0	0	1	16.8325925	-93.2779925	t
35981	92	0246	La Trinidad	164931.430	0931704.114	1060	E15C59	R	6	0	0	1	16.8253972	-93.2844761	t
35982	92	0247	Paso del Burro	164929.354	0931613.019	0907	E15C59	R	10	4	6	3	16.8248206	-93.2702831	t
35983	92	0248	Flamboyanes	164926.509	0931514.587	0919	E15C59	R	6	0	0	1	16.8240303	-93.2540519	t
35984	92	0249	Llantera	164706.778	0931333.811	0786	E15C59	R	6	0	0	1	16.7852161	-93.2260586	t
35985	92	0250	Atotonilco el Alto (Quinta Gas‚n)	164756.023	0931430.643	0877	E15C59	R	22	10	12	5	16.7988953	-93.2418453	t
35986	92	0251	Los Toritos	164750.711	0931423.947	0869	E15C59	R	3	0	0	1	16.7974197	-93.2399853	t
35987	92	0252	Saltillito	164747.239	0931418.499	0862	E15C59	R	0	0	0	0	16.7964553	-93.2384719	t
35988	92	0253	La Caridad	164757.416	0931417.707	0876	E15C59	R	193	104	89	41	16.7992822	-93.2382519	t
35989	92	0254	El Peaje	164745.265	0931409.427	0859	E15C59	R	0	0	0	0	16.7959069	-93.2359519	t
35990	92	0255	Buenavista	164530.324	0931833.039	1002	E15C59	R	4	0	0	1	16.7584233	-93.3091775	t
35991	92	0256	El Turc¢n	164731.736	0931359.513	0844	E15C59	R	5	0	0	2	16.7921489	-93.2331981	t
35992	92	0257	San Francisco	164724.544	0931352.773	0841	E15C59	R	2	0	0	1	16.7901511	-93.2313258	t
35993	92	0258	Santa Mar¡a	164714.628	0931356.438	0826	E15C59	R	10	4	6	3	16.7873967	-93.2323439	t
35994	92	0259	San Jos‚	164714.123	0931353.546	0825	E15C59	R	4	0	0	1	16.7872564	-93.2315406	t
35995	92	0260	Santa Cecilia	164710.251	0931349.001	0820	E15C59	R	4	0	0	1	16.7861808	-93.2302781	t
35996	92	0262	Quinta Ilusi¢n	164658.861	0931347.775	0800	E15C59	R	5	0	0	1	16.7830169	-93.2299375	t
35997	92	0268	San Antonio los Potrillos	164655.169	0931323.393	0773	E15C59	R	10	0	0	2	16.7819914	-93.2231647	t
35998	92	0269	Santa Cruz	164658.846	0931324.267	0778	E15C59	R	4	0	0	1	16.7830128	-93.2234075	t
35999	92	0272	El Ca¤averal	164851.948	0931545.138	0875	E15C59	R	14	0	0	2	16.8144300	-93.2625383	t
36000	92	0275	Cuchumbac	165134.145	0931829.554	1084	E15C59	R	55	28	27	9	16.8594847	-93.3082094	t
36001	92	0276	Amendu	165008.408	0931857.816	1080	E15C59	R	453	212	241	74	16.8356689	-93.3160600	t
36002	92	0277	Tierra y Libertad	165014.891	0931923.838	1043	E15C59	R	496	259	237	94	16.8374697	-93.3232883	t
36003	92	0278	Santa In‚s Buenos Aires	164551.704	0931714.988	0942	E15C59	R	11	0	0	2	16.7643622	-93.2874967	t
36004	92	0280	San Isidro	164337.563	0931629.527	0884	E15C69	R	111	52	59	22	16.7271008	-93.2748686	t
36005	92	0281	El Ed‚n	164551.884	0931828.851	1009	E15C59	R	8	0	0	1	16.7644122	-93.3080142	t
36006	92	0282	La Gloria	164609.132	0931706.612	0931	E15C59	R	4	0	0	1	16.7692033	-93.2851700	t
36007	92	0283	Gracias a Dios (La Rinconada)	164410.861	0931613.970	0861	E15C69	R	42	17	25	9	16.7363503	-93.2705472	t
36008	92	0286	San Antonio Coyatoc	164516.793	0931837.394	0973	E15C59	R	5	0	0	1	16.7546647	-93.3103872	t
36009	92	0287	El Peniel	164511.461	0931832.255	0965	E15C59	R	46	19	27	11	16.7531836	-93.3089597	t
36010	92	0288	Santa Luc¡a (Fracci¢n el Ed‚n)	164527.183	0931815.552	0979	E15C59	R	6	0	0	1	16.7575508	-93.3043200	t
36011	92	0289	El Rosario	164642.688	0931541.460	0907	E15C59	R	6	0	0	1	16.7785244	-93.2615167	t
36012	92	0290	El Forastero (El Carmen)	164458.547	0931837.419	0979	E15C69	R	8	0	0	1	16.7495964	-93.3103942	t
36013	92	0291	Mi Lupita	165018.042	0932116.501	0926	E15C58	R	6	0	0	1	16.8383450	-93.3545836	t
36014	92	0292	Santa Elena	164855.661	0931910.734	0999	E15C59	R	5	0	0	1	16.8154614	-93.3196483	t
36015	92	0293	El Sabinito	164837.120	0931935.136	0983	E15C59	R	177	78	99	36	16.8103111	-93.3264267	t
36016	92	0294	San Antonio	164841.721	0932005.666	0980	E15C58	R	13	0	0	2	16.8115892	-93.3349072	t
36017	92	0297	Quinta Say£o	164607.460	0931636.952	0926	E15C59	R	5	0	0	1	16.7687389	-93.2769311	t
36018	92	0298	Las Caba¤as	164620.043	0931509.416	0830	E15C59	R	3	0	0	1	16.7722342	-93.2526156	t
36019	92	0299	Mar¡a de Guadalupe	164614.524	0931513.575	0827	E15C59	R	7	0	0	2	16.7707011	-93.2537708	t
36020	92	0300	El Lim¢n	164610.561	0931514.608	0839	E15C59	R	8	0	0	1	16.7696003	-93.2540578	t
36021	92	0301	La Vaqueta	164702.840	0931525.530	0847	E15C59	R	8	0	0	1	16.7841222	-93.2570917	t
36022	92	0302	Santa Martha	164646.847	0931339.280	0769	E15C59	R	9	0	0	2	16.7796797	-93.2275778	t
36023	92	0305	El Rosario	164511.036	0931822.046	0952	E15C59	R	4	0	0	1	16.7530656	-93.3061239	t
36024	92	0306	La Libertad	164712.141	0931230.632	0695	E15C59	R	664	330	334	164	16.7867058	-93.2085089	t
36025	92	0308	El Chucamay	164844.888	0931745.050	0977	E15C59	R	4	0	0	1	16.8124689	-93.2958472	t
36026	92	0309	El Porvenir	164327.851	0931650.309	0894	E15C69	R	5	0	0	1	16.7244031	-93.2806414	t
36027	92	0313	El Higuito	164651.925	0931446.353	0804	E15C59	R	48	23	25	10	16.7810903	-93.2462092	t
36028	92	0314	R¡o Agua Dulce	164614.062	0931459.416	0842	E15C59	R	5	0	0	1	16.7705728	-93.2498378	t
36029	92	0315	El Palmar	164643.475	0931712.827	0950	E15C59	R	161	85	76	40	16.7787431	-93.2868964	t
36030	92	0317	Las Tulias	164804.966	0931433.506	0872	E15C59	R	3	0	0	1	16.8013794	-93.2426406	t
36031	92	0318	Rosario Buenavista	165016.226	0932040.036	0961	E15C58	R	6	0	0	1	16.8378406	-93.3444544	t
36032	92	0320	San Luis	164737.753	0931402.107	0848	E15C59	R	3	0	0	2	16.7938203	-93.2339186	t
36033	92	0321	El Chapital	164609.761	0931616.868	0919	E15C59	R	5	0	0	1	16.7693781	-93.2713522	t
36034	92	0324	El Mico	170017.805	0932141.472	0531	E15C48	R	0	0	0	0	17.0049458	-93.3615200	t
36035	92	0325	San Jorge	164907.404	0931645.690	1001	E15C59	R	0	0	0	0	16.8187233	-93.2793583	t
36036	92	0326	La Rinconada	165849.488	0932138.457	0442	E15C58	R	9	0	0	1	16.9804133	-93.3606825	t
36037	92	0352	San Jorge	165956.082	0932133.228	0561	E15C58	R	17	9	8	4	16.9989117	-93.3592300	t
36038	92	0353	La Pistola	165405.640	0932533.772	0933	E15C58	R	2	0	0	1	16.9015667	-93.4260478	t
36039	92	0357	Betania	165227.012	0932106.012	0998	E15C58	R	0	0	0	0	16.8741700	-93.3516700	t
36040	92	0359	Santa Martha	164730.444	0932200.113	1127	E15C58	R	110	58	52	23	16.7917900	-93.3666981	t
36041	92	0360	Campestre California (Peque¤o L¡bano)	164623.775	0931735.657	0960	E15C59	R	0	0	0	0	16.7732708	-93.2932381	t
36042	92	0362	Fanaber	164601.730	0931743.192	0971	E15C59	R	7	0	0	1	16.7671472	-93.2953311	t
36043	92	0363	Jacal£	164559.143	0931746.214	0978	E15C59	R	0	0	0	0	16.7664286	-93.2961706	t
36044	92	0364	Ingraprosur (Yazm¡n)	164601.225	0931745.529	0976	E15C59	R	0	0	0	0	16.7670069	-93.2959803	t
36045	92	0365	Las Bugambilias	164553.341	0931753.352	0994	E15C59	R	4	0	0	2	16.7648169	-93.2981533	t
36046	92	0366	Que Chula Monta¤a	164555.021	0931756.410	0999	E15C59	R	7	0	0	1	16.7652836	-93.2990028	t
36047	92	0367	El Cascarillo	164558.380	0931756.630	0997	E15C59	R	5	0	0	1	16.7662167	-93.2990639	t
36048	92	0368	Santa Cruz (San Jos‚)	164559.788	0931802.800	1001	E15C59	R	13	0	0	2	16.7666078	-93.3007778	t
36049	92	0369	Agua Escondida	165022.003	0931823.020	1151	E15C59	R	32	19	13	5	16.8394453	-93.3063944	t
36050	92	0372	El Tempisque	164858.352	0931645.368	0984	E15C59	R	7	0	0	1	16.8162089	-93.2792689	t
36051	92	0373	El Pozo	164903.514	0931745.938	1001	E15C59	R	0	0	0	0	16.8176428	-93.2960939	t
36052	92	0375	El Pe¤asco (Las Pilas)	165548.042	0931849.573	0348	E15C59	R	8	0	0	1	16.9300117	-93.3137703	t
36053	92	0378	Jorge Trejo	165339.942	0932342.002	0792	E15C58	R	0	0	0	0	16.8944283	-93.3950006	t
36054	92	0379	Llano Bonito	165113.682	0932325.668	0901	E15C58	R	1	0	0	1	16.8538006	-93.3904633	t
36055	92	0388	El Tesoro	164326.299	0931701.054	0897	E15C69	R	2	0	0	1	16.7239719	-93.2836261	t
36056	92	0392	Los Manueles Uno	164505.406	0931848.785	0999	E15C59	R	5	0	0	1	16.7515017	-93.3135514	t
36057	92	0394	Betel	164511.232	0931834.467	0969	E15C59	R	37	16	21	11	16.7531200	-93.3095742	t
36058	92	0397	Bonanza	164620.662	0931532.506	0864	E15C59	R	7	0	0	2	16.7724061	-93.2590294	t
36059	92	0398	La Ceiba	164622.173	0931528.092	0864	E15C59	R	5	0	0	1	16.7728258	-93.2578033	t
36060	92	0399	San Jeronimo (Solidaridad)	164609.922	0931540.626	0869	E15C59	R	239	115	124	54	16.7694228	-93.2612850	t
36061	92	0400	El Renacimiento	164655.126	0931349.133	0796	E15C59	R	3	0	0	1	16.7819794	-93.2303147	t
36062	92	0401	La Huasteca	164954.984	0931559.004	1065	E15C59	R	0	0	0	0	16.8319400	-93.2663900	t
36063	92	0406	El Palenque	165302.407	0932220.510	0940	E15C58	R	0	0	0	0	16.8840019	-93.3723639	t
36064	92	0417	El Moj¢n	165206.087	0932220.099	0910	E15C58	R	12	0	0	2	16.8683575	-93.3722497	t
36065	92	0420	Quinta Ferm n	164706.390	0931343.131	0801	E15C59	R	9	0	0	1	16.7851083	-93.2286475	t
36066	92	0422	Monte Sina¡	165119.043	0931902.811	1136	E15C59	R	0	0	0	0	16.8552897	-93.3174475	t
36067	92	0425	El Divisadero	165401.579	0932302.603	0871	E15C58	R	90	49	41	18	16.9004386	-93.3840564	t
36068	92	0432	El Fandango	164616.878	0931538.971	0872	E15C59	R	0	0	0	0	16.7713550	-93.2608253	t
36069	92	0434	Las Pe¤itas	165335.469	0932008.790	0873	E15C58	R	16	9	7	3	16.8931858	-93.3357750	t
36070	92	0436	Cima el Porvenir	165322.561	0931959.423	0906	E15C59	R	8	4	4	3	16.8896003	-93.3331731	t
36071	92	0437	San Mart¡n la Enca¤ada	165028.958	0932133.177	0941	E15C58	R	10	0	0	1	16.8413772	-93.3592158	t
36072	92	0439	El Arrinqu¡n	170004.423	0932048.531	0598	E15C48	R	0	0	0	0	17.0012286	-93.3468142	t
36073	92	0440	Bellavista (Monte Grande)	164603.194	0931806.228	1003	E15C59	R	5	0	0	1	16.7675539	-93.3017300	t
36074	92	0441	Betania	164920.627	0931608.877	0903	E15C59	R	20	13	7	3	16.8223964	-93.2691325	t
36075	92	0442	Betania	165256.642	0931858.743	1056	E15C59	R	0	0	0	0	16.8824006	-93.3163175	t
36076	92	0443	Santa In‚s	164605.068	0931706.571	0928	E15C59	R	0	0	0	0	16.7680744	-93.2851586	t
36077	92	0444	Buenos Aires	164745.605	0931400.237	0864	E15C59	R	20	10	10	7	16.7960014	-93.2333992	t
36078	92	0445	Los Capetillos	164727.151	0931519.845	0901	E15C59	R	5	0	0	1	16.7908753	-93.2555125	t
36079	92	0447	El Cacao	165930.705	0931927.160	0667	E15C59	R	0	0	0	0	16.9918625	-93.3242111	t
36080	92	0450	El Carmen	165353.377	0932228.960	0826	E15C58	R	6	0	0	1	16.8981603	-93.3747111	t
36081	92	0452	Quinta Isabel	164803.460	0931443.731	0868	E15C59	R	5	0	0	1	16.8009611	-93.2454808	t
36082	92	0457	El Zapote	164844.090	0931714.218	0962	E15C59	R	0	0	0	0	16.8122472	-93.2872828	t
36083	92	0458	La Conformidad	165355.120	0932437.143	0877	E15C58	R	0	0	0	0	16.8986444	-93.4103175	t
36084	92	0459	Los Coyotes	164848.622	0931516.206	0868	E15C59	R	0	0	0	0	16.8135061	-93.2545017	t
36085	92	0460	El Clavel	165651.761	0932157.168	0503	E15C58	R	10	0	0	2	16.9477114	-93.3658800	t
36086	92	0461	El Nuevo Triunfo (El Espad¡n)	170014.131	0931906.999	0479	E15C49	R	91	46	45	13	17.0039253	-93.3186108	t
36087	92	0462	Las Esperanzas	164503.852	0931825.816	0961	E15C59	R	14	5	9	4	16.7510700	-93.3071711	t
36088	92	0463	La Esperanza	170113.008	0932154.000	0182	E15C48	R	0	0	0	0	17.0202800	-93.3650000	t
36089	92	0465	Flor de Liz	164619.200	0931544.150	0882	E15C59	R	0	0	0	0	16.7720000	-93.2622639	t
36090	92	0467	Laguna Mora	164525.048	0931746.770	0984	E15C59	R	0	0	0	0	16.7569578	-93.2963250	t
36091	92	0468	Gracielita	164558.998	0931807.566	1001	E15C59	R	1	0	0	1	16.7663883	-93.3021017	t
36092	92	0469	Guadalupana	164533.000	0931741.255	0980	E15C59	R	0	0	0	0	16.7591667	-93.2947931	t
36093	92	0472	El Jocot¢n	164828.072	0931649.473	0943	E15C59	R	0	0	0	0	16.8077978	-93.2804092	t
36094	92	0473	Los Laguitos	170112.405	0932105.682	0382	E15C48	R	0	0	0	0	17.0201125	-93.3515783	t
36095	92	0475	Lindavista	165701.292	0932220.493	0392	E15C58	R	7	0	0	1	16.9503589	-93.3723592	t
36096	92	0476	Las Bugambilias	164609.613	0931702.551	0935	E15C59	R	6	0	0	1	16.7693369	-93.2840419	t
36097	92	0477	Las Mar¡as	165154.943	0932358.374	0901	E15C58	R	4	0	0	1	16.8652619	-93.3995483	t
36098	92	0478	El Mirador	164348.731	0931520.149	0818	E15C69	R	0	0	0	0	16.7302031	-93.2555969	t
36099	92	0479	Montecristo	165424.012	0932228.992	0823	E15C58	R	0	0	0	0	16.9066700	-93.3747200	t
36100	92	0480	Monterrey	164534.746	0931820.488	0983	E15C59	R	9	0	0	1	16.7596517	-93.3056911	t
36101	92	0481	Las Naranjas	165429.988	0932224.996	0783	E15C58	R	10	0	0	1	16.9083300	-93.3736100	t
36102	92	0483	Nueva Esperanza	165600.656	0931946.885	0704	E15C59	R	0	0	0	0	16.9335156	-93.3296903	t
36103	92	0484	Nueva Esperanza	165857.271	0932110.722	0521	E15C58	R	0	0	0	0	16.9825753	-93.3529783	t
36104	92	0486	Nuevo Chacacal	165822.978	0931846.437	0257	E15C59	R	130	66	64	30	16.9730494	-93.3128992	t
36105	92	0487	Nuevo Progreso	165420.016	0932240.008	0795	E15C58	R	0	0	0	0	16.9055600	-93.3777800	t
36106	92	0488	El Ocote	165338.159	0932532.092	0798	E15C58	R	10	0	0	1	16.8939331	-93.4255811	t
36107	92	0489	La Orqu¡dea	164559.004	0931819.008	0998	E15C59	R	0	0	0	0	16.7663900	-93.3052800	t
36108	92	0491	Pa¤uelo Rojo (Mexiquito)	164539.846	0931531.708	0892	E15C59	R	0	0	0	0	16.7610683	-93.2588078	t
36109	92	0493	El Para¡so	164547.420	0931830.832	1019	E15C59	R	5	0	0	1	16.7631722	-93.3085644	t
36110	92	0494	El Para¡so	164907.964	0931524.327	0894	E15C59	R	0	0	0	0	16.8188789	-93.2567575	t
36111	92	0495	Para¡so de la Cueva	164918.890	0931615.544	0930	E15C59	R	12	0	0	2	16.8219139	-93.2709844	t
36112	92	0496	El Pedregal de San Gabriel	164600.671	0931719.677	0941	E15C59	R	0	0	0	0	16.7668531	-93.2887992	t
36113	92	0497	La Pe¤a de Oreb	164557.484	0931746.490	0980	E15C59	R	5	0	0	1	16.7659678	-93.2962472	t
36114	92	0498	La Pe¤a	165352.633	0932143.705	0838	E15C58	R	6	0	0	1	16.8979536	-93.3621403	t
36115	92	0499	La Perdiz	170029.455	0932033.991	0583	E15C48	R	0	0	0	0	17.0081819	-93.3427753	t
36116	92	0500	Piedras Leguas	164858.309	0931740.412	1000	E15C59	R	5	0	0	1	16.8161969	-93.2945589	t
36117	92	0501	La Pomarrosa	165250.971	0932123.309	0966	E15C58	R	0	0	0	0	16.8808253	-93.3564747	t
36118	92	0502	Ponyal¢n	164524.297	0931816.263	0973	E15C59	R	10	0	0	1	16.7567492	-93.3045175	t
36119	92	0503	El Porvenir	164531.675	0931753.321	0985	E15C59	R	3	0	0	1	16.7587986	-93.2981447	t
36120	92	0505	Quinta Emita	164737.069	0931402.167	0846	E15C59	R	12	9	3	3	16.7936303	-93.2339353	t
36121	92	0506	Quinta Flor	164518.018	0931819.686	0963	E15C59	R	2	0	0	1	16.7550050	-93.3054683	t
36122	92	0507	Quinta Irma	164806.138	0931438.097	0870	E15C59	R	0	0	0	0	16.8017050	-93.2439158	t
36123	92	0508	Quinta Lupita	164656.335	0931643.629	0941	E15C59	R	0	0	0	0	16.7823153	-93.2787858	t
36124	92	0509	Rancho Alegre	165004.648	0931659.387	1053	E15C59	R	4	0	0	1	16.8346244	-93.2831631	t
36125	92	0510	El Rastrojal	164834.340	0931524.437	0856	E15C59	R	11	0	0	1	16.8095389	-93.2567881	t
36126	92	0513	El Recuerdo	165631.540	0931954.355	0610	E15C59	R	0	0	0	0	16.9420944	-93.3317653	t
36127	92	0514	El Relicario	164912.025	0931842.961	1033	E15C59	R	0	0	0	0	16.8200069	-93.3119336	t
36128	92	0515	El Rocoso	164853.492	0931734.068	0968	E15C59	R	0	0	0	0	16.8148589	-93.2927967	t
36129	92	0517	CM el Sabino	164719.877	0931252.404	0710	E15C59	R	10	4	6	6	16.7888547	-93.2145567	t
36130	92	0519	La Ceiba	165651.406	0931845.787	0294	E15C59	R	0	0	0	0	16.9476128	-93.3127186	t
36131	92	0520	San Carlos	164609.575	0931742.052	0973	E15C59	R	5	0	0	1	16.7693264	-93.2950144	t
36132	92	0523	Joel Ovando Melgar	164827.214	0932147.834	1079	E15C58	R	15	0	0	2	16.8075594	-93.3632872	t
36133	92	0525	San Isidro	165255.276	0932212.661	0962	E15C58	R	0	0	0	0	16.8820211	-93.3701836	t
36134	92	0526	San Javier	165708.832	0931928.260	0322	E15C59	R	0	0	0	0	16.9524533	-93.3245167	t
36135	92	0527	San Jer¢nimo	164554.887	0931804.918	1000	E15C59	R	0	0	0	0	16.7652464	-93.3013661	t
36136	92	0528	Oriana	164903.731	0931643.515	0993	E15C59	R	0	0	0	0	16.8177031	-93.2787542	t
36137	92	0529	San Jos‚ la Flor	165251.652	0932205.581	0968	E15C58	R	30	14	16	7	16.8810144	-93.3682169	t
36138	92	0530	San Jos‚ de los Naranjos	164859.591	0932107.243	0994	E15C58	R	0	0	0	0	16.8165531	-93.3520119	t
36139	92	0532	San Luis	164534.140	0931748.245	0989	E15C59	R	0	0	0	0	16.7594833	-93.2967347	t
36140	92	0534	San Mart¡n	165257.596	0932203.500	0936	E15C58	R	0	0	0	0	16.8826656	-93.3676389	t
36141	92	0535	San Rafael	165241.988	0931837.008	1000	E15C59	R	10	0	0	2	16.8783300	-93.3102800	t
36142	92	0537	San Sebasti n	164832.322	0931507.168	0860	E15C59	R	0	0	0	0	16.8089783	-93.2519911	t
36143	92	0538	Criscar	165225.758	0931955.590	1069	E15C59	R	6	0	0	1	16.8738217	-93.3321083	t
36144	92	0540	San Jos‚	164831.680	0931457.161	0853	E15C59	R	8	0	0	1	16.8088000	-93.2492114	t
36145	92	0543	Santa Luc¡a	165054.624	0932211.868	0910	E15C58	R	9	0	0	1	16.8485067	-93.3699633	t
36146	92	0545	Santo Domingo	165202.215	0931840.618	1100	E15C59	R	1	0	0	1	16.8672819	-93.3112828	t
36147	92	0546	El Palo Verde	164850.217	0931748.807	0985	E15C59	R	9	0	0	1	16.8139492	-93.2968908	t
36148	92	0547	Colonia Ejidal	164631.983	0931638.508	0927	E15C59	R	190	100	90	38	16.7755508	-93.2773633	t
36149	92	0549	El Cielito	164609.740	0931659.256	0937	E15C59	R	4	0	0	1	16.7693722	-93.2831267	t
36150	92	0550	David Jim‚nez	164903.000	0931643.000	0945	E15C59	R	5	0	0	1	16.8175000	-93.2786111	t
36151	92	0554	Las Carolinas	164646.918	0931649.501	0940	E15C59	R	8	0	0	1	16.7796994	-93.2804169	t
36152	92	0555	Tres Hermanos	164839.776	0931705.616	0946	E15C59	R	0	0	0	0	16.8110489	-93.2848933	t
36153	92	0558	La Monta¤ita	164559.636	0931752.139	0986	E15C59	R	0	0	0	0	16.7665656	-93.2978164	t
36154	92	0560	David Guti‚rrez R¡os	164842.131	0931712.875	0961	E15C59	R	6	0	0	1	16.8117031	-93.2869097	t
36155	92	0563	Jes£s Zavaleta	164618.594	0931532.000	0861	E15C59	R	0	0	0	0	16.7718317	-93.2588889	t
36156	92	0565	Jorge Zepeda	165318.079	0932506.981	0940	E15C58	R	5	0	0	1	16.8883553	-93.4186058	t
36157	92	0566	San Luis	164855.689	0931517.903	0880	E15C59	R	3	0	0	1	16.8154692	-93.2549731	t
36158	92	0568	La Herradura	164843.524	0931741.049	0991	E15C59	R	4	0	0	1	16.8120900	-93.2947358	t
36159	92	0569	Leandro	164639.151	0931636.518	0933	E15C59	R	1	0	0	1	16.7775419	-93.2768106	t
36160	92	0571	San Pedro	165635.029	0931846.917	0293	E15C59	R	3	0	0	1	16.9430636	-93.3130325	t
36161	92	0572	Santa Cecilia	164843.795	0931744.487	0977	E15C59	R	0	0	0	0	16.8121653	-93.2956908	t
36162	92	0573	Sanizatoc	164913.565	0931806.577	1032	E15C59	R	2	0	0	1	16.8204347	-93.3018269	t
36163	92	0574	Chacalatenco	164940.175	0931708.744	1081	E15C59	R	0	0	0	0	16.8278264	-93.2857622	t
36164	92	0575	No‚ Jim‚nez Sarmiento	170059.884	0932033.650	0424	E15C48	R	0	0	0	0	17.0166344	-93.3426806	t
36165	92	0576	Oscar Robles	164945.675	0931857.659	1069	E15C59	R	2	0	0	1	16.8293542	-93.3160164	t
36166	92	0577	Antonio Aguirre C.	164704.065	0931542.601	0882	E15C59	R	0	0	0	0	16.7844625	-93.2618336	t
36167	92	0578	Salom¢n	164609.928	0931656.476	0938	E15C59	R	0	0	0	0	16.7694244	-93.2823544	t
36168	92	0579	Aurora	164642.802	0931644.708	0936	E15C59	R	13	0	0	2	16.7785561	-93.2790856	t
36169	92	0581	El Ed‚n	164552.613	0931838.175	1026	E15C59	R	1	0	0	1	16.7646147	-93.3106042	t
36170	92	0583	La Tienda	164901.012	0931440.042	0900	E15C59	R	1	0	0	1	16.8169478	-93.2444561	t
36171	92	0584	Nuevo Horizonte (El Tigre)	165920.274	0931958.444	0562	E15C59	R	0	0	0	0	16.9889650	-93.3329011	t
36172	92	0585	Los Tulipanes	164838.957	0931515.454	0864	E15C59	R	7	0	0	2	16.8108214	-93.2542928	t
36173	92	0586	Tuxtl n	164646.189	0931325.826	0765	E15C59	R	6	0	0	1	16.7794969	-93.2238406	t
36174	92	0589	El Zapote	165600.825	0931848.339	0333	E15C59	R	10	0	0	2	16.9335625	-93.3134275	t
36175	92	0590	Buenos Aires (Salem)	164534.562	0931730.234	0965	E15C59	R	5	0	0	1	16.7596006	-93.2917317	t
36176	92	0591	San Francisco	164909.651	0931809.051	1023	E15C59	R	4	0	0	1	16.8193475	-93.3025142	t
36177	92	0593	El Maguey	164630.161	0931441.716	0815	E15C59	R	0	0	0	0	16.7750447	-93.2449211	t
36178	92	0594	La Alegr¡a	164836.141	0931655.394	0945	E15C59	R	4	0	0	1	16.8100392	-93.2820539	t
36179	92	0599	San Juditas Tadeo	165203.000	0931834.992	1068	E15C59	R	6	0	0	1	16.8675000	-93.3097200	t
36180	92	0602	Blanca Luc¡a	164645.649	0931641.893	0937	E15C59	R	0	0	0	0	16.7793469	-93.2783036	t
36181	92	0603	La Caba¤a	164704.278	0931332.512	0785	E15C59	R	0	0	0	0	16.7845217	-93.2256978	t
36182	92	0604	Monte Grande	164556.681	0931835.027	1015	E15C59	R	1	0	0	1	16.7657447	-93.3097297	t
36183	92	0605	El Amaranto	165638.772	0932206.629	0503	E15C58	R	2	0	0	1	16.9441033	-93.3685081	t
36184	92	0606	El Olivo	165648.406	0932156.098	0517	E15C58	R	9	0	0	1	16.9467794	-93.3655828	t
36185	92	0607	Benito Quezada	165246.303	0932343.522	0788	E15C58	R	92	50	42	20	16.8795286	-93.3954228	t
36186	92	0608	Berl¡n	165005.454	0932006.538	0965	E15C58	R	1	0	0	1	16.8348483	-93.3351494	t
36187	92	0610	Agua Zarca	165322.403	0932531.199	0904	E15C58	R	0	0	0	0	16.8895564	-93.4253331	t
36188	92	0611	Los Amates	165711.591	0931917.530	0274	E15C59	R	4	0	0	1	16.9532197	-93.3215361	t
36189	92	0612	El Mirador	170057.468	0932120.106	0433	E15C48	R	0	0	0	0	17.0159633	-93.3555850	t
36190	92	0613	Nuevo Progreso	165827.403	0932110.548	0441	E15C58	R	69	36	33	14	16.9742786	-93.3529300	t
36191	92	0614	Arau Hern ndez H.	170029.925	0932105.153	0535	E15C48	R	0	0	0	0	17.0083125	-93.3514314	t
36192	92	0615	Samuel Ovando Alegr¡a	170052.028	0932022.222	0424	E15C48	R	0	0	0	0	17.0144522	-93.3395061	t
36193	92	0616	Alex	164625.032	0931501.638	0840	E15C59	R	5	0	0	1	16.7736200	-93.2504550	t
36194	92	0617	El µmbar	164608.577	0931703.997	0932	E15C59	R	0	0	0	0	16.7690492	-93.2844436	t
36195	92	0621	La Caba¤a	164857.630	0931617.716	0938	E15C59	R	2	0	0	1	16.8160083	-93.2715878	t
36196	92	0622	Las Delicias	164346.641	0931903.093	1002	E15C69	R	1	0	0	1	16.7296225	-93.3175258	t
36197	92	0624	Las Delicias	164439.815	0931859.073	0990	E15C69	R	0	0	0	0	16.7443931	-93.3164092	t
36198	92	0625	Argusa	164935.709	0931655.977	1039	E15C59	R	6	0	0	1	16.8265858	-93.2822158	t
36199	92	0627	Los Girasoles	164628.830	0931456.540	0836	E15C59	R	1	0	0	1	16.7746750	-93.2490389	t
36200	92	0628	Los Pinos	164743.048	0931406.877	0859	E15C59	R	0	0	0	0	16.7952911	-93.2352436	t
36201	92	0629	San Antonio	164847.742	0931747.474	0981	E15C59	R	1	0	0	1	16.8132617	-93.2965206	t
36202	92	0630	Kil¢metro 9	164648.727	0931644.804	0938	E15C59	R	18	9	9	3	16.7802019	-93.2791122	t
36203	92	0631	Le¢n Dorado	164621.044	0931657.278	0939	E15C59	R	14	0	0	1	16.7725122	-93.2825772	t
36204	92	0633	Lindos Aires	164804.464	0931452.107	0866	E15C59	R	61	31	30	14	16.8012400	-93.2478075	t
36205	92	0634	Lolek	164948.936	0931818.253	1123	E15C59	R	5	0	0	1	16.8302600	-93.3050703	t
36206	92	0635	Los Mendoza	164904.560	0931801.079	1018	E15C59	R	1	0	0	1	16.8179333	-93.3002997	t
36207	92	0637	Nueva Esperanza	165243.172	0931931.031	1022	E15C59	R	6	0	0	1	16.8786589	-93.3252864	t
36208	92	0639	El Paisaje	165022.211	0931847.467	1109	E15C59	R	0	0	0	0	16.8395031	-93.3131853	t
36209	92	0640	Las Palmas	164731.293	0931528.238	0904	E15C59	R	7	0	0	1	16.7920258	-93.2578439	t
36210	92	0641	Las Palomas	164630.288	0931517.655	0863	E15C59	R	0	0	0	0	16.7750800	-93.2549042	t
36211	92	0642	Plan del Arado	164947.858	0931753.183	1162	E15C59	R	0	0	0	0	16.8299606	-93.2981064	t
36212	92	0644	Nueva Esperanza	165544.243	0932115.526	0679	E15C58	R	0	0	0	0	16.9289564	-93.3543128	t
36213	92	0645	San Agust¡n	165136.554	0931857.833	1147	E15C59	R	6	0	0	1	16.8601539	-93.3160647	t
36214	92	0646	San Antonio	164858.102	0931805.302	1006	E15C59	R	5	0	0	1	16.8161394	-93.3014728	t
36215	92	0647	San Isidro	164956.154	0931825.070	1119	E15C59	R	8	5	3	4	16.8322650	-93.3069639	t
36216	92	0648	San Jos‚ el Para¡so	165334.232	0932253.183	0891	E15C58	R	34	17	17	6	16.8928422	-93.3814397	t
36217	92	0649	San Miguel	165022.392	0931809.056	1164	E15C59	R	0	0	0	0	16.8395533	-93.3025156	t
36218	92	0650	San Miguelito	164659.032	0931634.579	0924	E15C59	R	6	0	0	1	16.7830644	-93.2762719	t
36219	92	0651	Santa B rbara	165123.415	0931916.440	1148	E15C59	R	4	0	0	1	16.8565042	-93.3212333	t
36220	92	0652	Santa Elena	165031.901	0931832.594	1162	E15C59	R	1	0	0	1	16.8421947	-93.3090539	t
36221	92	0653	Santa Elena	164553.991	0931744.084	0978	E15C59	R	0	0	0	0	16.7649975	-93.2955789	t
36222	92	0654	Santa Enedina	164653.565	0931647.718	0940	E15C59	R	0	0	0	0	16.7815458	-93.2799217	t
36223	92	0655	Santa Enith	164340.289	0931855.858	0998	E15C69	R	15	9	6	3	16.7278581	-93.3155161	t
36224	92	0656	Santa Rosa	165334.615	0931909.820	0973	E15C59	R	6	0	0	1	16.8929486	-93.3193944	t
36225	92	0657	Sina¡	165130.645	0932321.322	0887	E15C58	R	4	0	0	1	16.8585125	-93.3892561	t
36226	92	0658	Las Cumbres del Tepeyac	165044.384	0931834.451	1231	E15C59	R	5	0	0	1	16.8456622	-93.3095697	t
36227	92	0660	Santa Rosa las Bugambilias	164351.525	0931901.818	1004	E15C69	R	2	0	0	1	16.7309792	-93.3171717	t
36228	92	0661	Josefina	164618.493	0931336.361	0706	E15C59	R	3	0	0	1	16.7718036	-93.2267669	t
36229	92	0662	L¡bano	165113.723	0931902.648	1151	E15C59	R	8	0	0	1	16.8538119	-93.3174022	t
36230	92	0663	El Ensue¤o	164624.791	0931654.867	0938	E15C59	R	0	0	0	0	16.7735531	-93.2819075	t
36231	92	0664	Ninguno	164647.013	0931643.987	0937	E15C59	R	0	0	0	0	16.7797258	-93.2788853	t
36232	92	0666	Las Mar¡as	164554.977	0931821.456	0993	E15C59	R	1	0	0	1	16.7652714	-93.3059600	t
36233	92	0667	Tres Hermanos	164804.156	0931508.993	0839	E15C59	R	0	0	0	0	16.8011544	-93.2524981	t
36234	92	0668	T£ y las Nubes	165038.646	0931823.957	1206	E15C59	R	15	0	0	2	16.8440683	-93.3066547	t
36235	92	0669	El Zapote	165231.601	0932040.411	1037	E15C58	R	0	0	0	0	16.8754447	-93.3445586	t
36236	92	0670	Los Arcos	164743.193	0931401.171	0862	E15C59	R	5	0	0	1	16.7953314	-93.2336586	t
36237	92	0671	Babilonia	164538.240	0931913.262	1047	E15C59	R	0	0	0	0	16.7606222	-93.3203506	t
36238	92	0672	Las Brisas	164631.372	0931651.437	0938	E15C59	R	11	5	6	3	16.7753811	-93.2809547	t
36239	92	0674	El Changarro	164609.955	0931704.963	0932	E15C59	R	0	0	0	0	16.7694319	-93.2847119	t
36240	92	0675	Chivi Chivi	164630.268	0931448.414	0819	E15C59	R	0	0	0	0	16.7750744	-93.2467817	t
36241	92	0676	El Chucamay	164925.486	0931650.126	1035	E15C59	R	0	0	0	0	16.8237461	-93.2805906	t
36242	92	0677	Fubema	164649.065	0931336.317	0762	E15C59	R	3	0	0	1	16.7802958	-93.2267547	t
36243	92	0678	Monterrey (Granja)	164524.083	0931807.275	0960	E15C59	R	5	0	0	1	16.7566897	-93.3020208	t
36244	92	0679	Plan de Ayala [Grupo Agropecuario]	164538.423	0931729.457	0966	E15C59	R	0	0	0	0	16.7606731	-93.2915158	t
36245	92	0680	Guadalupe	164919.230	0931825.043	1042	E15C59	R	0	0	0	0	16.8220083	-93.3069564	t
36246	92	0681	Primavera	164602.434	0931817.732	0996	E15C59	R	4	0	0	1	16.7673428	-93.3049256	t
36247	92	0682	Francisco S nchez R.	164606.466	0931656.168	0933	E15C59	R	0	0	0	0	16.7684628	-93.2822689	t
36248	92	0683	Juli n Nazar Morales	164646.885	0931347.107	0780	E15C59	R	0	0	0	0	16.7796903	-93.2297519	t
36249	92	0684	Licenciado Rubio	164921.805	0931818.005	1051	E15C59	R	1	0	0	1	16.8227236	-93.3050014	t
36250	92	0685	Mariana	164917.724	0931659.156	1049	E15C59	R	11	0	0	1	16.8215900	-93.2830989	t
36251	92	0687	La Obra	164701.935	0931329.068	0781	E15C59	R	0	0	0	0	16.7838708	-93.2247411	t
36252	92	0688	El Para¡so	164521.131	0931640.993	0928	E15C59	R	0	0	0	0	16.7558697	-93.2780536	t
36253	92	0689	Patio de Maquinaria del Grupo JV	164611.782	0931503.412	0853	E15C59	R	3	0	0	1	16.7699394	-93.2509478	t
36254	92	0690	El Pelizco	164913.723	0931854.620	1029	E15C59	R	0	0	0	0	16.8204786	-93.3151722	t
36255	92	0691	Piedras Grandes	164858.143	0931615.079	0930	E15C59	R	0	0	0	0	16.8161508	-93.2708553	t
36256	92	0692	Las Piedras	165237.682	0931737.342	0997	E15C59	R	0	0	0	0	16.8771339	-93.2937061	t
36257	92	0693	La Planada	164824.363	0931415.301	0816	E15C59	R	13	0	0	1	16.8067675	-93.2375836	t
36258	92	0694	Renovadora Lupita	164555.229	0931711.417	0940	E15C59	R	0	0	0	0	16.7653414	-93.2865047	t
36259	92	0695	El Ruso	164650.727	0931352.370	0790	E15C59	R	0	0	0	0	16.7807575	-93.2312139	t
36260	92	0696	San Agustt¡n	164844.524	0931749.742	0982	E15C59	R	4	0	0	1	16.8123678	-93.2971506	t
36261	92	0697	San Francisco	164927.508	0931819.376	1064	E15C59	R	0	0	0	0	16.8243078	-93.3053822	t
36262	92	0698	San Jos‚	164917.478	0931836.203	1039	E15C59	R	1	0	0	1	16.8215217	-93.3100564	t
36263	92	0699	Santa Mar¡a	164701.735	0931428.577	0834	E15C59	R	0	0	0	0	16.7838153	-93.2412714	t
36264	92	0700	Santa Rosa	164609.897	0931707.388	0930	E15C59	R	5	0	0	1	16.7694158	-93.2853856	t
36265	92	0701	El Tambo	165036.203	0931834.353	1165	E15C59	R	0	0	0	0	16.8433897	-93.3095425	t
36266	92	0702	Nuevo Horizonte	165911.942	0932009.037	0505	E15C58	R	0	0	0	0	16.9866506	-93.3358436	t
36267	92	0703	La Flor	165219.925	0932252.044	0896	E15C58	R	14	0	0	2	16.8722014	-93.3811233	t
36268	92	0704	Monte Bonito	165613.171	0932210.143	0464	E15C58	R	9	0	0	2	16.9369919	-93.3694842	t
36269	92	0705	Las Potrancas	165845.643	0932217.005	0587	E15C58	R	0	0	0	0	16.9793453	-93.3713903	t
36270	92	0706	San Antonio	165059.926	0932316.844	0906	E15C58	R	0	0	0	0	16.8499794	-93.3880122	t
36271	92	0707	San Miguel	164949.074	0932035.784	0942	E15C58	R	24	11	13	3	16.8302983	-93.3432733	t
36272	92	0708	Santa Teresa	165037.913	0932100.439	0935	E15C58	R	23	11	12	6	16.8438647	-93.3501219	t
36273	92	0711	El Plan	165836.582	0932125.923	0434	E15C58	R	3	0	0	1	16.9768283	-93.3572008	t
36274	92	0712	El Recreo	165733.758	0932140.583	0304	E15C58	R	10	0	0	2	16.9593772	-93.3612731	t
36275	92	0713	Kil¢metro 8.9 (Alejandra Alina)	164631.282	0931700.096	0942	E15C59	R	3	0	0	1	16.7753561	-93.2833600	t
36276	92	0714	Ilusi¢n	164626.162	0931702.670	0941	E15C59	R	7	0	0	2	16.7739339	-93.2840750	t
36277	92	0715	La Bonanza	165410.648	0931958.733	0748	E15C59	R	1	0	0	1	16.9029578	-93.3329814	t
36278	92	0716	La Orqu¡dea	165119.871	0931840.962	1079	E15C59	R	0	0	0	0	16.8555197	-93.3113783	t
36279	92	0717	Crisp¡n V zquez	165125.053	0931840.664	1086	E15C59	R	0	0	0	0	16.8569592	-93.3112956	t
36280	92	0718	Loma Alta	170059.579	0932053.019	0445	E15C48	R	2	0	0	1	17.0165497	-93.3480608	t
36281	92	0719	Los Olivos	164524.034	0931912.367	1041	E15C59	R	0	0	0	0	16.7566761	-93.3201019	t
36282	92	0720	Los Robles	165027.431	0931805.183	1167	E15C59	R	0	0	0	0	16.8409531	-93.3014397	t
36283	92	0723	San Ram¢n	164909.012	0931905.988	1010	E15C59	R	7	0	0	1	16.8191700	-93.3183300	t
36284	92	0724	La Sombra	165622.529	0931911.751	0442	E15C59	R	11	0	0	1	16.9395914	-93.3199308	t
36285	92	0725	El Cedro	165236.655	0931908.547	1043	E15C59	R	9	0	0	1	16.8768486	-93.3190408	t
36286	92	0726	Cerro de la Tienda	164907.205	0931503.935	0919	E15C59	R	0	0	0	0	16.8186681	-93.2510931	t
36287	92	0727	Rancho Creg	164622.298	0931502.066	0842	E15C59	R	3	0	0	1	16.7728606	-93.2505739	t
36288	92	0728	El Brasilito	164730.422	0931526.848	0904	E15C59	R	0	0	0	0	16.7917839	-93.2574578	t
36289	92	0729	El Porvenir	164847.510	0931511.068	0881	E15C59	R	4	0	0	1	16.8131972	-93.2530744	t
36290	92	0730	El Yunque	164600.230	0931713.207	0935	E15C59	R	6	0	0	1	16.7667306	-93.2870019	t
36291	92	0731	El Rosario	164859.610	0931503.856	0884	E15C59	R	0	0	0	0	16.8165583	-93.2510711	t
36292	92	0732	La Castellana	164623.344	0931500.316	0841	E15C59	R	1	0	0	1	16.7731511	-93.2500878	t
36293	92	0733	La Tienda	164852.441	0931440.149	0868	E15C59	R	0	0	0	0	16.8145669	-93.2444858	t
36294	92	0734	Las Joyas	164631.907	0931514.396	0830	E15C59	R	4	0	0	1	16.7755297	-93.2539989	t
36295	92	0735	Las Nubes	164902.145	0931502.848	0893	E15C59	R	0	0	0	0	16.8172625	-93.2507911	t
36296	92	0736	Para¡so	164907.995	0931433.346	0892	E15C59	R	0	0	0	0	16.8188875	-93.2425961	t
36297	92	0737	Para¡so	164611.687	0931701.744	0938	E15C59	R	0	0	0	0	16.7699131	-93.2838178	t
36298	92	0738	San Jos‚	164948.490	0931825.177	1107	E15C59	R	0	0	0	0	16.8301361	-93.3069936	t
36299	92	0739	San Manuel	164711.004	0931722.992	0980	E15C59	R	0	0	0	0	16.7863900	-93.2897200	t
36300	92	0740	San Pedro	164920.853	0931839.374	1051	E15C59	R	0	0	0	0	16.8224592	-93.3109372	t
36301	92	0741	San Rafael	164835.713	0931523.937	0857	E15C59	R	7	0	0	1	16.8099203	-93.2566492	t
36302	92	0742	Ninguno	164829.016	0931301.992	0892	E15C59	R	0	0	0	0	16.8080600	-93.2172200	t
36303	92	0743	Santa Martha	164921.308	0931829.828	1048	E15C59	R	2	0	0	1	16.8225856	-93.3082856	t
36304	92	0744	Santa In‚s Buenavista	164507.790	0931629.902	0923	E15C59	R	1559	749	810	522	16.7521639	-93.2749728	t
36305	92	0745	Ribera Ovejer¡a	164330.185	0931648.911	0896	E15C69	R	18	11	7	7	16.7250514	-93.2802531	t
36306	92	0746	Ciudad Maya	164419.892	0931851.786	0987	E15C69	R	715	354	361	210	16.7388589	-93.3143850	t
36307	92	0747	Ricardo Flores Mag¢n	165519.909	0931834.292	0392	E15C59	R	213	114	99	50	16.9221969	-93.3095256	t
36308	92	0748	El Cerrillo	164905.472	0931556.564	0922	E15C59	R	0	0	0	0	16.8181867	-93.2657122	t
36309	92	0749	San Fernando	164850.765	0931518.027	0875	E15C59	R	3	0	0	1	16.8141014	-93.2550075	t
36310	92	0750	Los Sabinos	164830.453	0931523.149	0854	E15C59	R	4	0	0	1	16.8084592	-93.2564303	t
36311	92	0751	Quinta Mi Ranchito	164837.759	0931513.016	0867	E15C59	R	5	0	0	1	16.8104886	-93.2536156	t
36312	92	0752	Las µguilas	164857.837	0931455.284	0884	E15C59	R	6	0	0	1	16.8160658	-93.2486900	t
36313	92	0753	Mi Nueva Luz	164854.489	0931444.423	0876	E15C59	R	20	10	10	4	16.8151358	-93.2456731	t
36314	92	0754	San Miguel	164833.729	0931507.497	0863	E15C59	R	7	0	0	2	16.8093692	-93.2520825	t
36315	92	0755	Santa Ana	164905.160	0931510.427	0898	E15C59	R	6	0	0	1	16.8181000	-93.2528964	t
36316	92	0756	Los Capulines	164830.167	0931512.766	0860	E15C59	R	13	0	0	1	16.8083797	-93.2535461	t
36317	92	0757	La Ceiba	164900.073	0931515.776	0885	E15C59	R	8	0	0	2	16.8166869	-93.2543822	t
36318	92	0758	La Providencia	164902.529	0931513.769	0889	E15C59	R	0	0	0	0	16.8173692	-93.2538247	t
36319	92	0759	Villa Paloma	164500.336	0931701.939	0967	E15C59	R	1	0	0	1	16.7500933	-93.2838719	t
36320	92	0760	Punta Diamante	164521.771	0931658.322	0940	E15C59	R	11	5	6	3	16.7560475	-93.2828672	t
36321	92	0761	Independencia	164600.603	0931607.272	0928	E15C59	R	0	0	0	0	16.7668342	-93.2686867	t
36322	92	0762	Emiliano Zapata	165754.983	0931906.960	0341	E15C59	R	0	0	0	0	16.9652731	-93.3186000	t
36323	92	0763	San Manuel	164545.275	0931730.619	0962	E15C59	R	0	0	0	0	16.7625764	-93.2918386	t
36324	92	0764	Revoluci¢n	165514.080	0932103.670	0722	E15C58	R	0	0	0	0	16.9205778	-93.3510194	t
36325	92	0765	Celia Herrera Mendoza	164754.260	0931709.690	1009	E15C59	R	0	0	0	0	16.7984056	-93.2860250	t
36326	92	0766	Selva los Sabinos	164728.842	0931307.847	0711	E15C59	R	0	0	0	0	16.7913450	-93.2188464	t
36327	92	0767	Lomas del Valle	164824.124	0931740.758	1022	E15C59	R	0	0	0	0	16.8067011	-93.2946550	t
36328	92	0768	Villa Esmeralda	164710.599	0931432.950	0838	E15C59	R	0	0	0	0	16.7862775	-93.2424861	t
36329	92	0769	Villa Florencia	164719.756	0931446.067	0822	E15C59	R	0	0	0	0	16.7888211	-93.2461297	t
36330	92	0770	La Cascada	164706.795	0931441.253	0842	E15C59	R	0	0	0	0	16.7852208	-93.2447925	t
36331	93	0001	Bochil	165946.980	0925324.788	1148	E15D51	U	12404	5975	6429	2857	16.9963833	-92.8902189	t
36332	93	0006	Ajil¢	165859.776	0925621.599	1316	E15D51	R	1271	645	626	227	16.9832711	-92.9393331	t
36333	93	0007	Allende Esquipulas	170410.764	0925711.432	1274	E15D41	R	657	325	332	117	17.0696567	-92.9531756	t
36334	93	0008	El Amate	170725.329	0930020.145	1490	E15C49	R	508	256	252	103	17.1237025	-93.0055958	t
36335	93	0017	El Cerro	165733.350	0925257.084	1465	E15D51	R	131	65	66	23	16.9592639	-92.8825233	t
36336	93	0020	Garrido Canaval (Chavarr¡a)	170430.777	0930135.183	0558	E15C49	R	588	300	288	152	17.0752158	-93.0264397	t
36337	93	0021	El Chuchis	165904.396	0925402.487	1185	E15D51	R	102	57	45	20	16.9845544	-92.9006908	t
36338	93	0033	La Yerbabuena	165625.187	0925347.748	1361	E15D51	R	528	264	264	98	16.9403297	-92.8965967	t
36339	93	0034	Yerbabuena Isbontick	165557.717	0925157.282	1651	E15D51	R	933	474	459	159	16.9326992	-92.8659117	t
36340	93	0035	Las Lagunas	170029.627	0930017.005	1543	E15C49	R	440	236	204	86	17.0082297	-93.0047236	t
36341	93	0037	La Libertad	165638.004	0925339.984	1375	E15D51	R	130	66	64	27	16.9438900	-92.8944400	t
36342	93	0039	Luis Espinoza	170158.813	0930137.409	1442	E15C49	R	1107	579	528	211	17.0330036	-93.0270581	t
36343	93	0040	Llano Grande	170159.125	0925853.686	1556	E15D41	R	554	268	286	120	17.0330903	-92.9815794	t
36344	93	0041	Santa Cruz Niho	170119.143	0925658.372	1489	E15D41	R	319	162	157	62	17.0219842	-92.9495478	t
36345	93	0046	Monte Grande	165617.197	0925145.191	1723	E15D51	R	688	324	364	107	16.9381103	-92.8625531	t
36346	93	0047	Monte Chico	165659.954	0925249.093	1401	E15D51	R	96	51	45	21	16.9499872	-92.8803036	t
36347	93	0050	La Naranja	165750.172	0925222.393	1304	E15D51	R	401	202	199	68	16.9639367	-92.8728869	t
36348	93	0051	Hierbabuena el Naranjo	165609.608	0925331.096	1424	E15D51	R	0	0	0	0	16.9360022	-92.8919711	t
36349	93	0055	San Antonio la Pitahaya	170030.930	0925827.365	1560	E15D41	R	243	127	116	48	17.0085917	-92.9742681	t
36350	93	0056	Pomil¢	165914.665	0925528.238	1237	E15D51	R	272	137	135	46	16.9874069	-92.9245106	t
36351	93	0064	El Palmar	170304.797	0930037.869	1129	E15C49	R	23	11	12	4	17.0513325	-93.0105192	t
36352	93	0077	San Pedro el Achiote (San Pedro M rtir)	170000.869	0925553.275	1115	E15D41	R	540	280	260	98	17.0002414	-92.9314653	t
36353	93	0079	San Ram¢n	170619.431	0930209.287	1022	E15C49	R	0	0	0	0	17.1053975	-93.0359131	t
36354	93	0082	Santo Domingo	165908.735	0925232.912	1182	E15D51	R	261	136	125	49	16.9857597	-92.8758089	t
36355	93	0083	San Vicente	165718.679	0925522.119	1404	E15D51	R	545	253	292	115	16.9551886	-92.9228108	t
36356	93	0086	Sitetic	170036.254	0925830.421	1560	E15D41	R	241	120	121	42	17.0100706	-92.9751169	t
36357	93	0092	Tierra Colorada	170052.920	0925453.772	1280	E15D41	R	789	388	401	157	17.0147000	-92.9149367	t
36358	93	0095	El Tulip n	170041.288	0925358.049	1203	E15D41	R	28	18	10	5	17.0114689	-92.8994581	t
36359	93	0097	Venustiano Carranza	165740.930	0925547.810	1427	E15D51	R	747	386	361	132	16.9613694	-92.9299472	t
36360	93	0099	Pocito Caulote	170124.927	0930400.188	1053	E15C49	R	178	90	88	33	17.0235908	-93.0667189	t
36361	93	0101	N¡ho	170100.277	0925531.062	1333	E15D41	R	119	51	68	25	17.0167436	-92.9252950	t
36362	93	0107	El Copal	165759.003	0925539.754	1368	E15D51	R	1133	565	568	225	16.9663897	-92.9277094	t
36363	93	0108	La Lagunita	170030.925	0925018.592	1567	E15D41	R	389	206	183	63	17.0085903	-92.8384978	t
36364	93	0113	Palma Real	170108.883	0930259.925	1079	E15C49	R	79	39	40	16	17.0191342	-93.0499792	t
36365	93	0115	El Palmarcito	165954.387	0930239.447	0870	E15C59	R	38	19	19	7	16.9984408	-93.0442908	t
36366	93	0123	Shashalpa	170724.516	0925716.204	1111	E15D41	R	272	145	127	54	17.1234767	-92.9545011	t
36367	93	0124	San Jos‚ Mujular	170934.664	0925918.661	1470	E15D41	R	278	144	134	50	17.1596289	-92.9885169	t
36368	93	0129	El Lim¢n	165953.538	0925205.448	1305	E15D51	R	11	0	0	2	16.9982050	-92.8681800	t
36369	93	0130	San Jos‚ Morelos	170027.087	0925437.979	1152	E15D41	R	22	9	13	3	17.0075242	-92.9105497	t
36370	93	0131	Agua Bendita	165949.796	0925540.886	1120	E15D51	R	130	73	57	27	16.9971656	-92.9280239	t
36371	93	0133	Emiliano Zapata	170111.358	0925215.432	1491	E15D41	R	299	147	152	53	17.0198217	-92.8709533	t
36372	93	0135	Cant‚	165900.174	0925322.642	1300	E15D51	R	13	8	5	4	16.9833817	-92.8896228	t
36373	93	0138	Cerro Palmita	165749.599	0925356.002	1261	E15D51	R	97	47	50	17	16.9637775	-92.8988894	t
36374	93	0139	El Ocotal	170110.324	0925742.550	1537	E15D41	R	47	23	24	10	17.0195344	-92.9618194	t
36375	93	0157	Francisco Villa	170029.764	0925758.223	1488	E15D41	R	51	28	23	10	17.0082678	-92.9661731	t
36376	93	0158	Guadalupe	170112.800	0925932.289	1391	E15D41	R	45	23	22	9	17.0202222	-92.9923025	t
36377	93	0159	Guadalupe	165957.258	0925337.945	1152	E15D51	R	218	110	108	46	16.9992383	-92.8938736	t
36378	93	0160	El Mirador	165932.037	0925407.585	1221	E15D51	R	151	82	69	29	16.9922325	-92.9021069	t
36379	93	0161	Monte Verde	165940.301	0925150.493	1281	E15D51	R	33	16	17	6	16.9945281	-92.8640258	t
36380	93	0163	Nuevo Chuchilt¢n	170000.791	0924915.223	1489	E15D41	R	136	76	60	24	17.0002197	-92.8208953	t
36381	93	0164	El Ocote	170019.985	0925258.265	1266	E15D41	R	51	27	24	10	17.0055514	-92.8828514	t
36382	93	0165	Pashamum	170647.136	0925920.335	1613	E15D41	R	32	17	15	5	17.1130933	-92.9889819	t
36383	93	0166	Plan de Ayala	165817.483	0925223.915	1306	E15D51	R	102	45	57	16	16.9715231	-92.8733097	t
36384	93	0167	San Antonio Pomil¢	165925.065	0925452.608	1280	E15D51	R	106	54	52	18	16.9902958	-92.9146133	t
36385	93	0168	San Fernando	170013.445	0925248.521	1281	E15D41	R	21	12	9	3	17.0037347	-92.8801447	t
36386	93	0169	San Gregorio	165918.228	0925349.870	1157	E15D51	R	147	72	75	27	16.9883967	-92.8971861	t
36387	93	0170	San Jos‚ Chavarr¡a	170430.131	0930126.659	0561	E15C49	R	288	155	133	71	17.0750364	-93.0240719	t
36388	93	0171	San Jos‚ el Ed‚n	165958.198	0925321.783	1180	E15D51	R	231	123	108	48	16.9994994	-92.8893842	t
36389	93	0172	Santa Cruz Buenavista	170508.889	0930042.041	1165	E15C49	R	88	51	37	16	17.0858025	-93.0116781	t
36390	93	0173	La Pitahaya	170025.769	0925822.887	1517	E15D41	R	83	33	50	19	17.0071581	-92.9730242	t
36391	93	0174	Nueva Esperanza	170733.676	0930124.478	0995	E15C49	R	171	83	88	38	17.1260211	-93.0234661	t
36392	93	0175	La Laguna	170058.373	0930031.858	1489	E15C49	R	23	12	11	7	17.0162147	-93.0088494	t
36393	93	0176	La Ca¤ada	165735.402	0925526.511	1444	E15D51	R	293	154	139	57	16.9598339	-92.9240308	t
36394	93	0177	Argentina	170006.249	0925427.828	1143	E15D41	R	224	110	114	39	17.0017358	-92.9077300	t
36395	93	0178	La Victoria	165944.000	0925432.215	1150	E15D51	R	5	0	0	1	16.9955556	-92.9089486	t
36396	93	0179	Las Limas	165933.663	0925219.585	1305	E15D51	R	63	34	29	12	16.9926842	-92.8721069	t
36397	93	0180	Reforma 2000	170008.021	0925425.309	1140	E15D41	R	62	28	34	17	17.0022281	-92.9070303	t
36398	93	0181	San Isidro	165958.286	0925308.170	1201	E15D51	R	38	24	14	8	16.9995239	-92.8856028	t
36399	93	0182	San Juan	165908.801	0925427.896	1250	E15D51	R	1	0	0	1	16.9857781	-92.9077489	t
36400	93	0183	San Mart¡n	170012.326	0925426.703	1142	E15D41	R	35	21	14	6	17.0034239	-92.9074175	t
36401	93	0184	San Francisco el Pedregal	165926.682	0925328.150	1225	E15D51	R	73	33	40	20	16.9907450	-92.8911528	t
36402	93	0185	Nueva Libertad	165910.995	0925318.449	1285	E15D51	R	0	0	0	0	16.9863875	-92.8884581	t
36403	93	0186	Cerro Matasano	165829.407	0925336.126	1344	E15D51	R	39	21	18	7	16.9748353	-92.8933683	t
36404	93	0187	Los Pinitos	165916.472	0925356.260	1216	E15D51	R	172	89	83	40	16.9879089	-92.8989611	t
36405	93	0188	San Mart¡n	165913.833	0925431.025	1282	E15D51	R	3	0	0	1	16.9871758	-92.9086181	t
36406	93	0189	Guayaba Lagunita	165822.096	0925308.387	1458	E15D51	R	6	0	0	1	16.9728044	-92.8856631	t
36407	93	0190	Sebasti n P‚rez N£¤ez	170215.904	0925904.393	1578	E15D41	R	0	0	0	0	17.0377511	-92.9845536	t
36408	93	0191	Las Lomas	165939.000	0925055.000	1385	E15D51	R	0	0	0	0	16.9941667	-92.8486111	t
36409	93	0192	Vista Hermosa	165915.539	0925225.851	1226	E15D51	R	0	0	0	0	16.9876497	-92.8738475	t
36410	94	0001	El Bosque	170343.957	0924317.072	1080	E15D41	U	5155	2581	2574	1137	17.0622103	-92.7214089	t
36411	94	0002	Altagracia	170157.166	0924629.646	1456	E15D41	R	513	255	258	113	17.0325461	-92.7749017	t
36412	94	0003	µlvaro Obreg¢n	170141.016	0924829.988	1577	E15D41	R	867	434	433	187	17.0280600	-92.8083300	t
36413	94	0004	Los µngeles	170240.404	0924504.803	1403	E15D41	R	560	263	297	125	17.0445567	-92.7513342	t
36414	94	0005	Argentina	170429.922	0924532.054	1102	E15D41	R	156	76	80	27	17.0749783	-92.7589039	t
36415	94	0011	El Carrizal	170057.590	0924726.939	1460	E15D41	R	472	236	236	89	17.0159972	-92.7908164	t
36416	94	0015	Uni¢n Progreso	170008.657	0924611.407	1025	E15D41	R	143	72	71	42	17.0024047	-92.7698353	t
36417	94	0016	Chabajebal	170249.992	0924104.992	0753	E15D41	R	746	360	386	146	17.0472200	-92.6847200	t
36418	94	0017	Chivaltic	170443.479	0924225.325	1072	E15D41	R	18	9	9	6	17.0787442	-92.7070347	t
36419	94	0018	La Esperanza	170250.161	0924410.483	1171	E15D41	R	0	0	0	0	17.0472669	-92.7362453	t
36420	94	0020	Florencia	170114.264	0924528.340	1135	E15D41	R	209	104	105	42	17.0206289	-92.7578722	t
36421	94	0023	Chichaltic el Lim¢n	170444.669	0924150.384	0724	E15D41	R	14	7	7	3	17.0790747	-92.6973289	t
36422	94	0026	El Mangal	170421.224	0924223.410	0949	E15D41	R	12	7	5	3	17.0725622	-92.7065028	t
36423	94	0027	Sabinotic	170043.217	0924623.505	1273	E15D41	R	188	94	94	35	17.0120047	-92.7731958	t
36424	94	0028	El Moj¢n	170244.674	0924425.095	1271	E15D41	R	8	4	4	3	17.0457428	-92.7403042	t
36425	94	0032	Pl tanos	170014.343	0924433.886	1142	E15D41	R	1992	987	1005	316	17.0039842	-92.7427461	t
36426	94	0037	Nueva Ucrania	170250.063	0924427.847	1274	E15D41	R	51	29	22	15	17.0472397	-92.7410686	t
36427	94	0041	San Antonio el Brillante	165807.946	0924717.279	1253	E15D51	R	326	157	169	74	16.9688739	-92.7881331	t
36428	94	0045	San Cayetano	165738.611	0924533.374	1507	E15D51	R	1833	879	954	419	16.9607253	-92.7592706	t
36429	94	0047	San Francisco	170024.674	0924534.248	1200	E15D41	R	24	13	11	3	17.0068539	-92.7595133	t
36430	94	0052	San Isidro Uno	170005.369	0924419.632	1112	E15D41	R	57	29	28	7	17.0014914	-92.7387867	t
36431	94	0056	San Miguel	170151.052	0924542.288	1177	E15D41	R	399	174	225	82	17.0308478	-92.7617467	t
36432	94	0057	San Norberto	165920.795	0924302.788	0749	E15D51	R	0	0	0	0	16.9891097	-92.7174411	t
36433	94	0058	San Pedro Nichtalucum	170204.802	0924337.408	0901	E15D41	R	1881	870	1011	381	17.0346672	-92.7270578	t
36434	94	0060	Carmen Guayabal	170143.869	0924625.541	1249	E15D41	R	114	63	51	21	17.0288525	-92.7737614	t
36435	94	0061	La Trinidad	170115.357	0924450.139	1008	E15D41	R	214	104	110	40	17.0209325	-92.7472608	t
36436	94	0062	Vergel	165914.430	0924356.143	0783	E15D51	R	7	0	0	2	16.9873417	-92.7322619	t
36437	94	0065	Nueva Jerusal‚n	170346.866	0924554.114	1320	E15D41	R	63	30	33	17	17.0630183	-92.7650317	t
36438	94	0067	Buenavista	165816.147	0924422.610	0974	E15D51	R	12	5	7	3	16.9711519	-92.7396139	t
36439	94	0077	Pozo Verde	165917.212	0924356.516	0799	E15D51	R	0	0	0	0	16.9881144	-92.7323656	t
36440	94	0079	Uni¢n Tierra Tzotzil	170051.138	0924705.548	1415	E15D41	R	127	65	62	24	17.0142050	-92.7848744	t
36441	94	0080	Las Delicias	170040.657	0924337.982	1050	E15D41	R	421	199	222	74	17.0112936	-92.7272172	t
36442	94	0085	Tierra Caliente	170351.597	0924104.351	0655	E15D41	R	315	145	170	52	17.0643325	-92.6845419	t
36443	94	0090	Naptic	170433.996	0924148.012	0773	E15D41	R	39	21	18	11	17.0761100	-92.6966700	t
36444	94	0092	San Andr‚s la Laguna	165835.607	0924732.476	1230	E15D51	R	279	129	150	50	16.9765575	-92.7923544	t
36445	94	0093	Las Amapolas	170020.733	0924519.761	1203	E15D41	R	36	15	21	6	17.0057592	-92.7554892	t
36446	94	0094	San Cayetano Dos	165746.151	0924433.450	1111	E15D51	R	33	16	17	6	16.9628197	-92.7426250	t
36447	94	0096	Mercedes la Ilusi¢n	165955.514	0924408.793	1044	E15D51	R	266	152	114	50	16.9987539	-92.7357758	t
36448	94	0097	El Vergel Dos	170014.507	0924452.176	1074	E15D41	R	13	7	6	4	17.0040297	-92.7478267	t
36449	94	0100	El Palmar	165846.855	0924650.397	1007	E15D51	R	8	4	4	3	16.9796819	-92.7806658	t
36450	94	0101	Niquid mbar	170026.320	0924430.635	1063	E15D41	R	68	27	41	12	17.0073111	-92.7418431	t
36451	94	0102	Carmen el Ocotal	170022.417	0924510.149	1176	E15D41	R	150	76	74	20	17.0062269	-92.7528192	t
36452	94	0103	San Joaqu¡n	165744.286	0924443.523	1131	E15D51	R	0	0	0	0	16.9623017	-92.7454231	t
36453	94	0104	Coraz¢n de Mar¡a	165720.352	0924438.331	1215	E15D51	R	0	0	0	0	16.9556533	-92.7439808	t
36454	94	0105	Carmen Guayabal Dos	165738.407	0924530.356	1485	E15D51	R	72	28	44	14	16.9606686	-92.7584322	t
36455	94	0106	El Remolino	165915.754	0924356.171	0790	E15D51	R	11	5	6	3	16.9877094	-92.7322697	t
36456	94	0108	El Pedregal	170521.984	0924444.016	0942	E15D41	R	100	56	44	18	17.0894400	-92.7455600	t
36457	94	0112	El Naranjal	170226.428	0924504.620	1263	E15D41	R	18	11	7	5	17.0406744	-92.7512833	t
36458	94	0115	La Gloria Chikinch‚n	165912.984	0924239.996	1064	E15D51	R	78	43	35	21	16.9869400	-92.7111100	t
36459	94	0116	El Jard¡n	170023.339	0924455.872	1118	E15D41	R	115	65	50	20	17.0064831	-92.7488533	t
36460	94	0117	San Andr‚s el Para¡so	165904.992	0924239.996	0941	E15D51	R	0	0	0	0	16.9847200	-92.7111100	t
36461	94	0118	San Antonio	170158.219	0924555.819	1309	E15D41	R	53	23	30	10	17.0328386	-92.7655053	t
36462	94	0119	Vista Hermosa Dos	165830.000	0924430.099	0870	E15D51	R	0	0	0	0	16.9750000	-92.7416942	t
36463	94	0121	La Bonanza	170028.595	0924557.948	1193	E15D41	R	34	18	16	9	17.0079431	-92.7660967	t
36464	94	0122	Nueva Esperanza	170037.389	0924555.228	1228	E15D41	R	55	26	29	10	17.0103858	-92.7653411	t
36465	94	0123	Santa Teresa	170151.683	0924619.981	1300	E15D41	R	48	20	28	9	17.0310231	-92.7722169	t
36466	94	0124	El Calvario	165848.000	0924720.000	1229	E15D51	R	15	10	5	5	16.9800000	-92.7888889	t
36467	94	0125	San Francisco Conh¢	170518.674	0924052.222	0396	E15D41	R	171	84	87	35	17.0885206	-92.6811728	t
36468	94	0126	San Crist¢bal la Gloria	170439.536	0924008.471	0766	E15D41	R	99	41	58	17	17.0776489	-92.6690197	t
36469	95	0001	Cacahoat n	145923.239	0921005.197	0477	D15B53	U	16572	7933	8639	3990	14.9897886	-92.1681103	t
36470	95	0002	Agua Caliente	150951.568	0920920.163	1596	D15B43	R	345	168	177	66	15.1643244	-92.1556008	t
36471	95	0003	El µguila	150533.331	0921100.603	1219	D15B43	R	1274	607	667	287	15.0925919	-92.1835008	t
36472	95	0004	Agust¡n de Iturbide	150431.226	0921154.645	0829	D15B43	R	2211	1079	1132	501	15.0753406	-92.1985125	t
36473	95	0005	Ahuacatl n	150224.834	0921051.213	0670	D15B43	R	1583	756	827	391	15.0402317	-92.1808925	t
36474	95	0006	Alianza	150237.067	0921108.082	0656	D15B43	R	48	24	24	14	15.0436297	-92.1855783	t
36475	95	0007	Alpujarras	150425.446	0921017.525	0937	D15B43	R	576	296	280	150	15.0737350	-92.1715347	t
36476	95	0008	Fracci¢n Azteca	150515.705	0920725.788	1529	D15B43	R	215	119	96	45	15.0876958	-92.1238300	t
36477	95	0009	Azteca	150648.914	0921105.861	1390	D15B43	R	279	141	138	48	15.1135872	-92.1849614	t
36478	95	0010	Bellavista	150441.473	0920857.791	1187	D15B43	R	525	271	254	100	15.0781869	-92.1493864	t
36479	95	0011	Benito Ju rez	150318.000	0921127.996	0668	D15B43	R	1473	713	760	284	15.0550000	-92.1911100	t
36480	95	0014	Camamb‚	150959.455	0920944.900	1472	D15B43	R	162	88	74	29	15.1665153	-92.1624722	t
36481	95	0015	El Carmen	150151.732	0920949.461	0658	D15B43	R	781	396	385	170	15.0310367	-92.1637392	t
36482	95	0018	Dos de Mayo	150124.220	0920852.943	0648	D15B43	R	644	342	302	143	15.0233944	-92.1480397	t
36483	95	0020	Faja de Oro	150156.324	0920921.247	0687	D15B43	R	2356	1170	1186	510	15.0323122	-92.1559019	t
36484	95	0023	Guatimoc	150246.734	0920909.357	0798	D15B43	R	733	364	369	163	15.0463150	-92.1525992	t
36485	95	0026	Mil n	150525.119	0920727.028	1624	D15B43	R	37	23	14	10	15.0903108	-92.1241744	t
36486	95	0027	Mixcum	150133.691	0920826.248	0671	D15B43	R	1502	760	742	307	15.0260253	-92.1406244	t
36487	95	0033	Piedra Parada	150725.107	0921121.742	1590	D15B43	R	214	111	103	34	15.1236408	-92.1893728	t
36488	95	0035	El Platanar	150506.520	0920944.154	1284	D15B43	R	747	354	393	157	15.0851444	-92.1622650	t
36489	95	0038	El Progreso	150513.816	0921149.503	0938	D15B43	R	724	367	357	157	15.0871711	-92.1970842	t
36490	95	0040	La Rioja	145937.980	0921100.290	0459	D15B53	R	11	5	6	3	14.9938833	-92.1834139	t
36491	95	0041	La Concepci¢n	150110.574	0921046.320	0551	D15B43	R	7	0	0	2	15.0196039	-92.1795333	t
36492	95	0042	Tecoytac	151039.738	0921006.007	1623	D15B43	R	213	116	97	36	15.1777050	-92.1683353	t
36493	95	0043	Salvador Urbina	150208.338	0921235.320	0583	D15B43	U	2555	1246	1309	560	15.0356494	-92.2098111	t
36494	95	0044	Santa Rita	150051.338	0921009.114	0564	D15B43	R	6	0	0	2	15.0142606	-92.1691983	t
36495	95	0049	Toqui n las Nubes (Toqui n Guarumo)	150302.803	0921123.229	0633	D15B43	R	426	215	211	86	15.0507786	-92.1897858	t
36496	95	0052	Uni¢n Roja	150244.276	0921257.102	0520	D15B43	R	1829	864	965	452	15.0456322	-92.2158617	t
36497	95	0053	El Zapote	150209.188	0920953.069	0691	D15B43	R	26	16	10	5	15.0358856	-92.1647414	t
36498	95	0054	Santa Mar¡a la Vega	150351.405	0920831.559	0965	D15B43	R	328	165	163	83	15.0642792	-92.1420997	t
36499	95	0058	Benito Ju rez el Plan	150513.496	0920853.154	1425	D15B43	R	271	146	125	50	15.0870822	-92.1480983	t
36500	95	0060	Icul (Plan Chiapas)	151026.464	0921027.557	1327	D15B43	R	54	28	26	12	15.1740178	-92.1743214	t
36501	95	0061	Las Nubes Guatimoc	150219.333	0920904.002	0740	D15B43	R	338	160	178	66	15.0387036	-92.1511117	t
36502	95	0062	Palmira	150103.321	0920915.175	0617	D15B43	R	18	9	9	3	15.0175892	-92.1542153	t
36503	95	0063	Las Pulgas	150810.182	0921106.280	0991	D15B43	R	19	10	9	4	15.1361617	-92.1850778	t
36504	95	0064	Platanillo	150931.138	0921025.989	1204	D15B43	R	196	97	99	29	15.1586494	-92.1738858	t
36505	95	0065	El Ed‚n (Plata Dos)	150015.952	0921028.789	0522	D15B43	R	0	0	0	0	15.0044311	-92.1746636	t
36506	95	0066	Rancho Quemado	150616.751	0921013.414	1498	D15B43	R	119	58	61	26	15.1046531	-92.1703928	t
36507	95	0067	La Primavera	145930.020	0921039.340	0462	D15B53	R	22	13	9	4	14.9916722	-92.1775944	t
36508	95	0072	Rosario Ixtal	150028.335	0920914.973	0568	D15B43	R	839	405	434	201	15.0078708	-92.1541592	t
36509	95	0097	Santa Martha	145945.606	0921053.309	0489	D15B53	R	0	0	0	0	14.9960017	-92.1814747	t
36510	95	0098	Montebello	145940.686	0920921.917	0504	D15B53	R	0	0	0	0	14.9946350	-92.1560881	t
36511	95	0100	Nueva Alianza	150226.082	0921033.510	0696	D15B43	R	149	64	85	37	15.0405783	-92.1759750	t
36512	95	0101	El Jard¡n	150149.600	0921144.157	0598	D15B43	R	7	0	0	2	15.0304444	-92.1955992	t
36513	95	0102	San Vicente	150152.226	0921126.760	0611	D15B43	R	14	5	9	4	15.0311739	-92.1907667	t
36514	95	0103	San Antonio Ixtal	150023.988	0920901.145	0560	D15B43	R	19	9	10	3	15.0066633	-92.1503181	t
36515	95	0104	Tecate	150006.710	0920906.490	0531	D15B43	R	9	5	4	3	15.0018639	-92.1518028	t
36516	95	0105	Morelos	150152.568	0921145.260	0599	D15B43	R	9	5	4	3	15.0312689	-92.1959056	t
36517	95	0106	Zabakch‚	150028.063	0921117.499	0521	D15B43	R	1	0	0	1	15.0077953	-92.1881942	t
36518	95	0107	San Jos‚ las Flores	150117.842	0920912.069	0629	D15B43	R	0	0	0	0	15.0216228	-92.1533525	t
36519	95	0109	24 de Junio (La Gallera)	150256.102	0921202.692	0604	D15B43	R	74	36	38	15	15.0489172	-92.2007478	t
36520	95	0110	Numancia	150129.687	0920954.932	0625	D15B43	R	25	17	8	6	15.0249131	-92.1652589	t
36521	95	0111	La Soledad	150058.169	0921037.868	0573	D15B43	R	140	67	73	31	15.0161581	-92.1771856	t
36522	95	0112	Cacahoat n	145934.238	0921036.762	0471	D15B53	R	2	0	0	1	14.9928439	-92.1768783	t
36523	95	0114	La Plata Tres	150014.059	0921049.308	0506	D15B43	R	3	0	0	1	15.0039053	-92.1803633	t
36524	95	0115	La Gloria	150014.075	0920923.227	0549	D15B43	R	19	10	9	4	15.0039097	-92.1564519	t
36525	95	0120	El Porvenir	150013.277	0920926.005	0547	D15B43	R	9	0	0	2	15.0036881	-92.1572236	t
36526	95	0121	La Esperanza	150014.003	0920933.271	0547	D15B43	R	6	0	0	2	15.0038897	-92.1592419	t
36527	95	0122	Dolores	150012.165	0920929.941	0545	D15B43	R	14	7	7	3	15.0033792	-92.1583169	t
36528	95	0123	Cobach	150050.779	0920921.295	0597	D15B43	R	0	0	0	0	15.0141053	-92.1559153	t
36529	95	0124	San Jos‚ Col¢n	150111.874	0920910.151	0623	D15B43	R	10	0	0	1	15.0199650	-92.1528197	t
36530	95	0127	Toqui n y las Nubes	150502.419	0920732.972	1452	D15B43	R	443	229	214	93	15.0840053	-92.1258256	t
36531	95	0128	Miramar	150443.361	0920926.413	1070	D15B43	R	288	144	144	57	15.0787114	-92.1573369	t
36532	95	0129	Las Nubes los Patios	150453.139	0920825.288	1269	D15B43	R	56	30	26	6	15.0814275	-92.1403578	t
36533	95	0130	Benito Ju rez Montecristo	150548.359	0920926.830	1435	D15B43	R	217	112	105	36	15.0967664	-92.1574528	t
36534	95	0131	San Crist¢bal	150649.529	0921024.301	1606	D15B43	R	34	18	16	9	15.1137581	-92.1734169	t
36535	95	0133	Cant¢n Piedra Parada	150709.004	0921107.981	1428	D15B43	R	200	105	95	37	15.1191678	-92.1855503	t
36536	95	0134	La Laguna Seca	151116.010	0920946.487	1806	D15B43	R	87	48	39	13	15.1877806	-92.1629131	t
36537	95	0136	San Miguel	151009.200	0921004.556	1380	D15B43	R	134	68	66	25	15.1692222	-92.1679322	t
36538	95	0137	Buenos Aires	150754.654	0921138.709	0970	D15B43	R	9	0	0	1	15.1318483	-92.1940858	t
36539	95	0139	La Vega del Caot n	150426.004	0921256.016	0506	D15B43	R	34	18	16	8	15.0738900	-92.2155600	t
36540	95	0140	Puente Colorado	150210.095	0920832.086	0694	D15B43	R	190	90	100	46	15.0361375	-92.1422461	t
36541	95	0146	Bol¡var	150106.974	0921002.247	0587	D15B43	R	0	0	0	0	15.0186039	-92.1672908	t
36542	95	0148	La Libertad	150112.900	0920924.215	0626	D15B43	R	2	0	0	1	15.0202500	-92.1567264	t
36543	95	0159	La Atl ntida	150013.543	0920943.106	0542	D15B43	R	10	0	0	2	15.0037619	-92.1619739	t
36544	95	0160	Para¡so	150047.751	0921005.621	0562	D15B43	R	1	0	0	1	15.0132642	-92.1682281	t
36545	95	0161	La Rinconada	150127.984	0920810.540	0598	D15B43	R	0	0	0	0	15.0244400	-92.1362611	t
36546	95	0162	Tolomita	150122.277	0920814.540	0596	D15B43	R	0	0	0	0	15.0228547	-92.1373722	t
36547	95	0164	El Manguito	150202.261	0921312.935	0491	D15B43	R	151	70	81	38	15.0339614	-92.2202597	t
36548	95	0165	Brasil	150843.420	0921054.308	0997	D15B43	R	25	14	11	4	15.1453944	-92.1817522	t
36549	95	0166	El Porvenir	150147.949	0921124.403	0606	D15B43	R	21	12	9	4	15.0299858	-92.1901119	t
36550	95	0167	Salvador Urbina (Ishcanalero)	150204.854	0921120.800	0624	D15B43	R	69	35	34	11	15.0346817	-92.1891111	t
36551	95	0168	Agua Tibia	150918.962	0920817.595	1993	D15B43	R	7	0	0	2	15.1552672	-92.1382208	t
36552	95	0169	La Boquilla	150546.073	0921224.032	0672	D15B43	R	108	51	57	19	15.0961314	-92.2066756	t
36553	95	0172	Jeric¢	150000.558	0921021.638	0503	D15B43	R	7	0	0	1	15.0001550	-92.1726772	t
36554	95	0173	La Laguna	150953.378	0920808.769	1858	D15B43	R	55	33	22	14	15.1648272	-92.1357692	t
36555	95	0174	Esquipulas	150119.329	0920921.590	0635	D15B43	R	15	0	0	2	15.0220358	-92.1559972	t
36556	95	0175	La Paz	150027.437	0921027.209	0536	D15B43	R	1	0	0	1	15.0076214	-92.1742247	t
36557	95	0176	Plata Uno	150022.935	0921027.872	0528	D15B43	R	4	0	0	1	15.0063708	-92.1744089	t
36558	95	0177	Lupita	150123.607	0920916.392	0640	D15B43	R	29	15	14	7	15.0232242	-92.1545533	t
36559	95	0179	Rosales	150217.711	0921122.144	0629	D15B43	R	111	52	59	27	15.0382531	-92.1894844	t
36560	95	0180	San Fernando	150043.960	0920923.216	0585	D15B43	R	1	0	0	1	15.0122111	-92.1564489	t
36561	95	0181	Santa Luc¡a	145952.885	0920850.717	0523	D15B53	R	128	62	66	31	14.9980236	-92.1474214	t
36562	95	0182	San Vicente	150320.988	0921139.984	0685	D15B43	R	13	8	5	3	15.0558300	-92.1944400	t
36563	95	0183	Balneario los Rosales	150415.926	0921121.260	0799	D15B43	R	4	0	0	2	15.0710906	-92.1892389	t
36564	95	0185	Juan de Le¢n Santos	150335.861	0921140.955	0690	D15B43	R	8	5	3	3	15.0599614	-92.1947097	t
36565	95	0186	Tojbach	150937.075	0920935.871	1541	D15B43	R	153	69	84	22	15.1602986	-92.1599642	t
36566	95	0187	Tocham n	151056.688	0920947.420	1856	D15B43	R	105	59	46	15	15.1824133	-92.1631722	t
36567	95	0188	Toqui n	150959.064	0920827.490	1683	D15B43	R	5	3	2	3	15.1664067	-92.1409694	t
36568	95	0189	La Ventana	151010.294	0920848.437	1908	D15B43	R	59	31	28	10	15.1695261	-92.1467881	t
36569	95	0190	Loma Bonita	150423.455	0921116.289	0810	D15B43	R	0	0	0	0	15.0731819	-92.1878581	t
36570	95	0191	San Alberto	150054.430	0920959.838	0576	D15B43	R	2	0	0	1	15.0151194	-92.1666217	t
36571	95	0192	Alejandra	150040.335	0921109.934	0541	D15B43	R	9	0	0	2	15.0112042	-92.1860928	t
36572	95	0193	El Para¡so	150043.308	0921108.851	0545	D15B43	R	13	0	0	1	15.0120300	-92.1857919	t
36573	95	0194	El Pastizal	150045.374	0921116.541	0544	D15B43	R	11	4	7	3	15.0126039	-92.1879281	t
36574	95	0195	Ojo de Agua	145950.820	0920910.530	0525	D15B53	R	8	0	0	1	14.9974500	-92.1529250	t
36575	95	0196	La Primavera	150212.332	0921034.451	0674	D15B43	R	89	39	50	14	15.0367589	-92.1762364	t
36576	95	0197	Fraccionamiento San Antonio	145935.141	0921046.672	0473	D15B53	R	99	48	51	24	14.9930947	-92.1796311	t
36577	95	0198	Los Robles	150014.441	0920936.738	0546	D15B43	R	5	0	0	2	15.0040114	-92.1602050	t
36578	95	0199	Quinta Caspirol de la Monta¤a	150011.607	0920905.457	0545	D15B43	R	3	0	0	1	15.0032242	-92.1515158	t
36579	95	0200	Fracci¢n las Quinas	150347.560	0920837.910	0975	D15B43	R	0	0	0	0	15.0632111	-92.1438639	t
36580	96	0001	Catazaj 	174341.957	0920058.918	0010	E15D23	U	2973	1415	1558	809	17.7283214	-92.0163661	t
36581	96	0002	Agua Fr¡a	174442.035	0920548.145	0024	E15D23	R	571	290	281	124	17.7450097	-92.0967069	t
36582	96	0003	Bajo Usumacinta	175450.419	0915856.839	0003	E15D14	R	148	74	74	38	17.9140053	-91.9824553	t
36583	96	0004	Boca del R¡o Chico	175239.931	0915734.973	0003	E15D14	R	92	50	42	25	17.8777586	-91.9597147	t
36584	96	0005	Cuyo (µlvaro Obreg¢n)	175058.490	0915958.924	0003	E15D14	R	557	278	279	156	17.8495806	-91.9997011	t
36585	96	0007	Cuyo Santa Cruz	175201.133	0915927.509	0000	E15D14	R	139	77	62	44	17.8669814	-91.9909747	t
36586	96	0009	Emiliano Zapata (San Joaqu¡n)	174331.777	0915800.263	0020	E15D24	R	377	191	186	97	17.7254936	-91.9667397	t
36587	96	0010	Francisco J. Grajales	175218.479	0920331.221	0002	E15D13	R	377	207	170	102	17.8717997	-92.0586725	t
36588	96	0011	Jaboncillo (La Balanza)	174141.247	0920405.978	0020	E15D23	R	47	23	24	12	17.6947908	-92.0683272	t
36589	96	0012	Jicalango	174542.690	0915905.537	0012	E15D14	R	90	43	47	20	17.7618583	-91.9848714	t
36590	96	0013	Kil¢metro 325	173620.025	0920353.133	0060	E15D23	R	107	52	55	26	17.6055625	-92.0647592	t
36591	96	0014	L zaro C rdenas	174354.284	0915605.432	0019	E15D24	R	215	102	113	47	17.7317456	-91.9348422	t
36592	96	0015	Loma Bonita	174712.153	0920433.921	0012	E15D13	R	1071	535	536	266	17.7867092	-92.0760892	t
36593	96	0016	El Pajonal	174515.790	0920046.919	0007	E15D13	R	299	152	147	69	17.7543861	-92.0130331	t
36594	96	0017	El Para¡so	174727.978	0920232.191	0000	E15D13	R	534	265	269	141	17.7911050	-92.0422753	t
36595	96	0019	Punta Arena	174446.138	0920322.450	0010	E15D23	R	1365	685	680	308	17.7461494	-92.0562361	t
36596	96	0020	El Remolino 1ra. Secci¢n	175142.315	0915620.080	0001	E15D14	R	99	51	48	35	17.8617542	-91.9389111	t
36597	96	0021	San Agust¡n	175401.517	0915632.745	0003	E15D14	R	208	101	107	49	17.9004214	-91.9424292	t
36598	96	0023	La Siria 2da. Secci¢n	173914.404	0915813.157	0040	E15D24	R	137	67	70	35	17.6540011	-91.9703214	t
36599	96	0025	La Siria 1ra. Secci¢n	173951.701	0915837.542	0030	E15D24	R	203	105	98	49	17.6643614	-91.9770950	t
36600	96	0026	Tecolpa	175317.457	0915216.595	0001	E15D14	R	113	58	55	29	17.8881825	-91.8712764	t
36601	96	0027	La Tuza (Maceo)	174157.610	0915810.899	0023	E15D24	R	437	231	206	119	17.6993361	-91.9696942	t
36602	96	0028	Vicente Guerrero	175126.209	0914730.222	0010	E15D14	R	164	78	86	41	17.8572803	-91.7917283	t
36603	96	0029	Victorico R. Grajales	175043.961	0920035.297	0004	E15D13	R	147	79	68	36	17.8455447	-92.0098047	t
36604	96	0032	Ignacio Zaragoza	174712.990	0915928.174	0009	E15D14	R	963	492	471	262	17.7869417	-91.9911594	t
36605	96	0033	El Rosario	174816.032	0920354.014	0010	E15D13	R	0	0	0	0	17.8044533	-92.0650039	t
36606	96	0034	El Carmen	174821.098	0915904.601	0009	E15D14	R	6	0	0	1	17.8058606	-91.9846114	t
36607	96	0035	Doble A	174742.934	0915757.030	0008	E15D14	R	5	0	0	1	17.7952594	-91.9658417	t
36608	96	0036	Cielito Lindo	174834.661	0915904.711	0010	E15D14	R	26	12	14	8	17.8096281	-91.9846419	t
36609	96	0037	El Tinto Bonsh n	174951.604	0915728.095	0006	E15D14	R	109	62	47	19	17.8310011	-91.9578042	t
36610	96	0038	Paso de la Monta¤a	174809.224	0915924.353	0007	E15D14	R	14	6	8	4	17.8025622	-91.9900981	t
36611	96	0039	Punta Limonar	174703.326	0915653.507	0021	E15D14	R	0	0	0	0	17.7842572	-91.9481964	t
36612	96	0041	Nuevo Rosario	174839.282	0915803.444	0012	E15D14	R	81	39	42	21	17.8109117	-91.9676233	t
36613	96	0042	El Desenga¤o	174433.393	0920403.775	0010	E15D23	R	146	68	78	35	17.7426092	-92.0677153	t
36614	96	0044	Fronterita	174724.846	0920304.396	0010	E15D13	R	8	4	4	3	17.7902350	-92.0512211	t
36615	96	0045	El Limoncito	174453.551	0920459.020	0011	E15D23	R	3	0	0	1	17.7482086	-92.0830611	t
36616	96	0048	San Isidro (Palast£n Dos)	174005.717	0920205.568	0031	E15D23	R	5	0	0	1	17.6682547	-92.0348800	t
36617	96	0051	El Zapote	175124.984	0920108.004	0006	E15D13	R	12	7	5	3	17.8569400	-92.0188900	t
36618	96	0053	El Remolino 2da. Secci¢n	175336.468	0915517.292	0000	E15D14	R	65	34	31	18	17.8934633	-91.9214700	t
36619	96	0054	El Naranjo	175015.101	0920314.662	0002	E15D13	R	8	0	0	2	17.8375281	-92.0540728	t
36620	96	0055	Linda Vista 1ra. Secci¢n	174930.998	0920124.296	0000	E15D13	R	106	58	48	19	17.8252772	-92.0234156	t
36621	96	0062	La Esperanza	175024.466	0915719.491	0000	E15D14	R	21	10	11	6	17.8401294	-91.9554142	t
36622	96	0063	La Matilla	175031.992	0920257.984	0007	E15D13	R	19	10	9	4	17.8422200	-92.0494400	t
36623	96	0065	El Capricho (La Paila)	174752.008	0920800.996	0010	E15D13	R	0	0	0	0	17.7977800	-92.1336100	t
36624	96	0071	San Francisco el Cuyo	175106.663	0920005.764	0001	E15D13	R	155	74	81	40	17.8518508	-92.0016011	t
36625	96	0072	San Joaqu¡n	174356.796	0915826.444	0011	E15D24	R	3	0	0	1	17.7324433	-91.9740122	t
36626	96	0075	San Juanito	174656.614	0915553.705	0017	E15D14	R	11	6	5	4	17.7823928	-91.9315847	t
36627	96	0078	Fracci¢n Santa Isabel	174446.104	0915906.973	0015	E15D24	R	4	0	0	1	17.7461400	-91.9852703	t
36628	96	0081	El Serranal	174805.467	0915946.241	0006	E15D14	R	92	43	49	22	17.8015186	-91.9961781	t
36629	96	0082	El Tintillo Dos	174517.838	0915635.970	0014	E15D14	R	9	0	0	1	17.7549550	-91.9433250	t
36630	96	0089	Santa Cruz 2da. Secci¢n de Loma Bonita	174713.364	0920406.365	0010	E15D13	R	390	198	192	87	17.7870456	-92.0684347	t
36631	96	0090	Los Muchachos	174558.800	0920748.792	0022	E15D13	R	2	0	0	1	17.7663333	-92.1302200	t
36632	96	0091	Paso de la Hamaca	174301.188	0915935.441	0010	E15D24	R	0	0	0	0	17.7169967	-91.9931781	t
36633	96	0093	Ampliaci¢n la Tuza	174313.770	0915907.605	0010	E15D24	R	15	9	6	3	17.7204917	-91.9854458	t
36634	96	0095	Santa Rita	174513.188	0920000.168	0019	E15D13	R	11	0	0	1	17.7536633	-92.0000467	t
36635	96	0096	San Manuel	174511.988	0920015.012	0010	E15D13	R	1	0	0	1	17.7533300	-92.0041700	t
36636	96	0098	San Francisco	174523.403	0915915.865	0021	E15D14	R	0	0	0	0	17.7565008	-91.9877403	t
36637	96	0107	El Suspiro	174108.883	0915722.418	0031	E15D24	R	9	0	0	1	17.6858008	-91.9562272	t
36638	96	0108	La Providencia	174103.673	0915758.720	0030	E15D24	R	5	0	0	1	17.6843536	-91.9663111	t
36639	96	0110	La Esmeralda	174505.396	0920030.592	0002	E15D13	R	7	0	0	2	17.7514989	-92.0084978	t
36640	96	0111	Delicias Dos	174541.498	0920130.621	0003	E15D13	R	9	0	0	1	17.7615272	-92.0251725	t
36641	96	0112	Crucero Zaragoza	174317.162	0915859.293	0010	E15D24	R	2	0	0	1	17.7214339	-91.9831369	t
36642	96	0113	El Cocalito Uno	174457.906	0920425.751	0009	E15D23	R	19	9	10	3	17.7494183	-92.0738197	t
36643	96	0116	Mazatl n	174330.662	0920318.923	0010	E15D23	R	8	0	0	1	17.7251839	-92.0552564	t
36644	96	0117	San Joaqu¡n	174330.176	0920351.688	0010	E15D23	R	6	0	0	1	17.7250489	-92.0643578	t
36645	96	0119	San Antonio	174153.763	0920517.855	0030	E15D23	R	1	0	0	1	17.6982675	-92.0882931	t
36646	96	0120	El Porvenir	174133.412	0920511.078	0020	E15D23	R	17	8	9	3	17.6926144	-92.0864106	t
36647	96	0121	Cuauht‚moc	174200.401	0920547.066	0029	E15D23	R	728	352	376	177	17.7001114	-92.0964072	t
36648	96	0122	Las Gaviotas	174239.996	0920606.984	0040	E15D23	R	0	0	0	0	17.7111100	-92.1019400	t
36649	96	0127	El Sacrificio	174219.841	0920608.396	0023	E15D23	R	8	0	0	1	17.7055114	-92.1023322	t
36650	96	0128	El Diamante	174148.843	0920446.315	0020	E15D23	R	8	0	0	1	17.6969008	-92.0795319	t
36651	96	0129	Santo Domingo	174143.739	0920442.358	0020	E15D23	R	2	0	0	1	17.6954831	-92.0784328	t
36652	96	0130	El Viejo Jaboncillo	174117.234	0920457.732	0020	E15D23	R	4	0	0	1	17.6881206	-92.0827033	t
36653	96	0134	San Jos‚	175015.477	0920115.202	0008	E15D13	R	0	0	0	0	17.8376325	-92.0208894	t
36654	96	0135	Santa Rita	174957.000	0914811.016	0007	E15D14	R	25	15	10	8	17.8325000	-91.8030600	t
36655	96	0136	Las Delicias	175102.016	0915109.000	0004	E15D14	R	8	0	0	1	17.8505600	-91.8525000	t
36656	96	0137	El Caoba	174948.092	0915204.838	0007	E15D14	R	23	9	14	4	17.8300256	-91.8680106	t
36657	96	0138	Patricio los µngeles	175232.661	0915828.323	0001	E15D14	R	71	35	36	16	17.8757392	-91.9745342	t
36658	96	0140	Cuauht‚moc (San Pablo 1ra. Secci¢n)	174035.804	0920344.744	0025	E15D23	R	2	0	0	1	17.6766122	-92.0624289	t
36659	96	0141	El Encanto	174151.918	0920345.954	0019	E15D23	R	5	0	0	1	17.6977550	-92.0627650	t
36660	96	0142	La Perla	173732.988	0920337.008	0040	E15D23	R	0	0	0	0	17.6258300	-92.0602800	t
36661	96	0143	San Pablo	174125.292	0920316.605	0030	E15D23	R	0	0	0	0	17.6903589	-92.0546125	t
36662	96	0145	Las Flores	174140.745	0920058.647	0013	E15D23	R	7	0	0	1	17.6946514	-92.0162908	t
36663	96	0146	Palast£n Uno San Isidro	174046.198	0920140.757	0030	E15D23	R	287	283	4	3	17.6794994	-92.0279881	t
36664	96	0147	San Antonio	174222.945	0920201.234	0021	E15D23	R	11	0	0	2	17.7063736	-92.0336761	t
36665	96	0148	G‚nova (Palast£n)	173852.149	0920149.352	0030	E15D23	R	0	0	0	0	17.6478192	-92.0303756	t
36666	96	0153	El Diamante	173826.742	0920309.044	0040	E15D23	R	7	0	0	1	17.6407617	-92.0525122	t
36667	96	0157	San Francisco (Palast£n)	173941.233	0920158.661	0031	E15D23	R	0	0	0	0	17.6614536	-92.0329614	t
36668	96	0159	Jerusal‚n	173733.842	0920143.552	0043	E15D23	R	4	0	0	1	17.6260672	-92.0287644	t
36669	96	0160	La Marina	174123.456	0920141.418	0020	E15D23	R	3	0	0	1	17.6898489	-92.0281717	t
36670	96	0162	Guadalupe del Carmen	173936.012	0920215.147	0030	E15D23	R	6	0	0	1	17.6600033	-92.0375408	t
36671	96	0163	San Bartolo	173845.855	0920234.364	0028	E15D23	R	9	0	0	2	17.6460708	-92.0428789	t
36672	96	0164	San Juanito	174824.604	0915956.965	0007	E15D14	R	0	0	0	0	17.8068344	-91.9991569	t
36673	96	0168	Mariano Casaus	175006.653	0920053.185	0000	E15D13	R	0	0	0	0	17.8351814	-92.0147736	t
36674	96	0170	Rancho Santa Rafaelita	175043.489	0920025.190	0001	E15D13	R	0	0	0	0	17.8454136	-92.0069972	t
36675	96	0171	San Rom n	174853.099	0920125.502	0005	E15D13	R	0	0	0	0	17.8147497	-92.0237506	t
36676	96	0172	Orizaba	174827.423	0915955.709	0008	E15D14	R	12	6	6	3	17.8076175	-91.9988081	t
36677	96	0173	San Antonio el Para¡so	174921.000	0915832.988	0003	E15D14	R	0	0	0	0	17.8225000	-91.9758300	t
36678	96	0174	El Brasil	174928.992	0915904.592	0009	E15D14	R	7	0	0	1	17.8247200	-91.9846089	t
36679	96	0175	San Nicol s	174947.580	0915913.586	0008	E15D14	R	0	0	0	0	17.8298833	-91.9871072	t
36680	96	0176	El Brasil Dos	174913.057	0915902.058	0010	E15D14	R	0	0	0	0	17.8202936	-91.9839050	t
36681	96	0177	Guapinol	174611.535	0915658.795	0021	E15D14	R	6	0	0	1	17.7698708	-91.9496653	t
36682	96	0178	El Tintillo Tres	174416.138	0915611.921	0020	E15D24	R	6	0	0	2	17.7378161	-91.9366447	t
36683	96	0179	La Lucha (La Huerta)	174100.785	0920003.828	0020	E15D23	R	0	0	0	0	17.6835514	-92.0010633	t
36684	96	0181	San Juanito	173839.258	0920153.444	0030	E15D23	R	3	0	0	1	17.6442383	-92.0315122	t
36685	96	0183	San Antonio	174548.715	0920746.997	0023	E15D13	R	0	0	0	0	17.7635319	-92.1297214	t
36686	96	0184	Santo Tom s	174202.099	0920521.804	0031	E15D23	R	8	3	5	3	17.7005831	-92.0893900	t
36687	96	0185	Paso del Maca (El Limoncito)	174440.450	0920512.456	0010	E15D23	R	21	8	13	6	17.7445694	-92.0867933	t
36688	96	0189	Santa érsula	174118.580	0920318.772	0031	E15D23	R	3	0	0	1	17.6884944	-92.0552144	t
36689	96	0190	Buenavista	174720.481	0920349.292	0009	E15D13	R	40	22	18	7	17.7890225	-92.0636922	t
36690	96	0191	San Jorge	174542.659	0920708.157	0031	E15D13	R	0	0	0	0	17.7618497	-92.1189325	t
36691	96	0192	Las Palomas	174533.984	0920834.008	0019	E15D13	R	21	10	11	6	17.7594400	-92.1427800	t
36692	96	0199	Santa Isabel	174521.992	0915906.274	0012	E15D14	R	0	0	0	0	17.7561089	-91.9850761	t
36693	96	0201	San Sim¢n	174412.536	0920949.053	0028	E15D23	R	70	36	34	17	17.7368156	-92.1636258	t
36694	96	0206	San Sim¢n	174322.990	0920634.646	0040	E15D23	R	0	0	0	0	17.7230528	-92.1096239	t
36695	96	0207	San Sim¢n	174308.004	0920633.984	0038	E15D23	R	0	0	0	0	17.7188900	-92.1094400	t
36696	96	0211	San Fernando	174153.517	0920712.583	0048	E15D23	R	4	0	0	1	17.6981992	-92.1201619	t
36697	96	0213	San Jos‚	174136.665	0920023.896	0012	E15D23	R	0	0	0	0	17.6935181	-92.0066378	t
36698	96	0214	El Progreso	174122.992	0920453.004	0014	E15D23	R	6	0	0	1	17.6897200	-92.0813900	t
36699	96	0216	San Carlos	173908.331	0920229.348	0028	E15D23	R	0	0	0	0	17.6523142	-92.0414856	t
36700	96	0217	San Manuel	173623.236	0920136.541	0044	E15D23	R	2	0	0	1	17.6064544	-92.0268169	t
36701	96	0218	Rancho Alegre	173607.936	0920301.699	0060	E15D23	R	7	0	0	2	17.6022044	-92.0504719	t
36702	96	0219	Morelia	173551.746	0920251.132	0058	E15D23	R	4	0	0	1	17.5977072	-92.0475367	t
36703	96	0220	Sacrificio	173606.228	0920313.002	0060	E15D23	R	0	0	0	0	17.6017300	-92.0536117	t
36704	96	0224	La Paz (Calatrava)	174546.553	0920635.135	0040	E15D13	R	7	0	0	2	17.7629314	-92.1097597	t
36705	96	0226	Las Cazuelas	174209.202	0920204.345	0021	E15D23	R	0	0	0	0	17.7025561	-92.0345403	t
36706	96	0227	El Coloso	174152.935	0920337.388	0020	E15D23	R	8	0	0	2	17.6980375	-92.0603856	t
36707	96	0228	Crucero el Cuyo	174414.164	0915611.284	0019	E15D24	R	2	0	0	1	17.7372678	-91.9364678	t
36708	96	0229	El Crucero	174234.506	0920050.386	0021	E15D23	R	0	0	0	0	17.7095850	-92.0139961	t
36709	96	0230	La Cruz	174157.333	0920246.614	0020	E15D23	R	5	0	0	1	17.6992592	-92.0462817	t
36710	96	0231	Dayzu	173548.091	0920233.953	0060	E15D23	R	0	0	0	0	17.5966919	-92.0427647	t
36711	96	0232	Dos Hermanos	174630.795	0920716.667	0025	E15D13	R	0	0	0	0	17.7752208	-92.1212964	t
36712	96	0233	Patricio Tamarindo	175227.779	0915829.529	0000	E15D14	R	141	82	59	40	17.8743831	-91.9748692	t
36713	96	0234	La Esperanza	173654.861	0920156.730	0032	E15D23	R	0	0	0	0	17.6152392	-92.0324250	t
36714	96	0235	Las Gaviotas	174154.393	0920355.958	0019	E15D23	R	3	0	0	1	17.6984425	-92.0655439	t
36715	96	0237	El Herradero	174742.898	0915727.521	0010	E15D14	R	0	0	0	0	17.7952494	-91.9576447	t
36716	96	0238	La Ilusi¢n	173939.603	0915720.817	0040	E15D24	R	5	0	0	1	17.6610008	-91.9557825	t
36717	96	0239	El Vino y el Jerez	174122.748	0920212.118	0020	E15D23	R	0	0	0	0	17.6896522	-92.0366994	t
36718	96	0240	Palast£n	174038.238	0920233.643	0021	E15D23	R	0	0	0	0	17.6772883	-92.0426786	t
36719	96	0241	La Lucha	175109.506	0915934.646	0003	E15D14	R	0	0	0	0	17.8526406	-91.9929572	t
36720	96	0242	La Lucha	174115.689	0915858.997	0032	E15D24	R	8	0	0	2	17.6876914	-91.9830547	t
36721	96	0243	El Mangal	174537.008	0920424.996	0016	E15D13	R	7	0	0	1	17.7602800	-92.0736100	t
36722	96	0244	Los Veremos	174651.034	0920306.234	0009	E15D13	R	4	0	0	2	17.7808428	-92.0517317	t
36723	96	0245	El Naranjal	174409.996	0920033.984	0010	E15D23	R	0	0	0	0	17.7361100	-92.0094400	t
36724	96	0246	El Naranjo	174535.315	0920409.976	0020	E15D13	R	10	0	0	2	17.7598097	-92.0694378	t
36725	96	0247	La Perla Fracci¢n Uno	173813.964	0920346.997	0041	E15D23	R	0	0	0	0	17.6372122	-92.0630547	t
36726	96	0248	La Perla (Fracci¢n Cinco)	173611.324	0920325.084	0060	E15D23	R	4	0	0	1	17.6031456	-92.0569678	t
36727	96	0249	El Piedral	174531.710	0915932.471	0017	E15D14	R	13	0	0	2	17.7588083	-91.9923531	t
36728	96	0250	El Rosario	174821.190	0920559.301	0018	E15D13	R	666	351	315	166	17.8058861	-92.0998058	t
36729	96	0251	San Antonio	174820.016	0915935.016	0005	E15D14	R	0	0	0	0	17.8055600	-91.9930600	t
36730	96	0252	San Rom n Fracci¢n Tres	174809.910	0915944.785	0007	E15D14	R	0	0	0	0	17.8027528	-91.9957736	t
36731	96	0253	San Jos‚	173607.383	0920322.846	0060	E15D23	R	16	0	0	2	17.6020508	-92.0563461	t
36732	96	0254	Finca el Hojal	175036.996	0915939.984	0005	E15D14	R	0	0	0	0	17.8436100	-91.9944400	t
36733	96	0255	San Manuel (Desenga¤o)	174158.350	0920407.131	0018	E15D23	R	2	0	0	1	17.6995417	-92.0686475	t
36734	96	0256	San Miguel	173939.115	0915743.486	0033	E15D24	R	36	20	16	8	17.6608653	-91.9620794	t
36735	96	0257	San Ram¢n	174005.306	0915740.513	0042	E15D24	R	0	0	0	0	17.6681406	-91.9612536	t
36736	96	0258	Santa B rbara	174707.799	0915735.803	0014	E15D14	R	0	0	0	0	17.7854997	-91.9599453	t
36737	96	0259	Santa Clara	174018.984	0915818.012	0030	E15D24	R	0	0	0	0	17.6719400	-91.9716700	t
36738	96	0262	Bios	173854.037	0920159.866	0030	E15D23	R	0	0	0	0	17.6483436	-92.0332961	t
36739	96	0263	El Tintillo	174554.594	0915650.175	0016	E15D14	R	0	0	0	0	17.7651650	-91.9472708	t
36740	96	0265	El Cocal	174304.056	0915930.511	0010	E15D24	R	2	0	0	1	17.7177933	-91.9918086	t
36741	96	0266	La Victoria	174018.540	0915635.745	0037	E15D24	R	24	13	11	6	17.6718167	-91.9432625	t
36742	96	0267	El Diamante	174021.301	0915731.504	0032	E15D24	R	8	0	0	2	17.6725836	-91.9587511	t
36743	96	0268	Santa Rosa	173956.319	0915759.236	0035	E15D24	R	5	0	0	1	17.6656442	-91.9664544	t
36744	96	0269	El Saladero	174323.575	0915827.978	0010	E15D24	R	2	0	0	1	17.7232153	-91.9744383	t
36745	96	0270	El Bosque	174641.291	0920304.038	0009	E15D13	R	6	0	0	1	17.7781364	-92.0511217	t
36746	96	0271	Caoba	174228.343	0915804.589	0027	E15D24	R	0	0	0	0	17.7078731	-91.9679414	t
36747	96	0272	Ensenada de los Camaleones	174549.890	0920312.757	0009	E15D13	R	5	0	0	1	17.7638583	-92.0535436	t
36748	96	0273	La Escora	174525.725	0920054.926	0003	E15D13	R	8	0	0	2	17.7571458	-92.0152572	t
36749	96	0274	El Hular	174617.979	0920307.045	0007	E15D13	R	17	0	0	2	17.7716608	-92.0519569	t
36750	96	0275	La Lambique	174609.062	0920321.832	0007	E15D13	R	6	0	0	2	17.7691839	-92.0560644	t
36751	96	0276	Leopoldo Olvera	174346.878	0915742.107	0021	E15D24	R	1	0	0	1	17.7296883	-91.9616964	t
36752	96	0277	Rosario L¢pez	174245.670	0920027.344	0011	E15D23	R	5	0	0	1	17.7126861	-92.0075956	t
36753	96	0279	Austria	173712.307	0920127.128	0041	E15D23	R	3	0	0	1	17.6200853	-92.0242022	t
36754	96	0280	G‚nova	173708.072	0920134.110	0049	E15D23	R	0	0	0	0	17.6189089	-92.0261417	t
36755	96	0281	Morelia	173751.462	0920430.084	0043	E15D23	R	0	0	0	0	17.6309617	-92.0750233	t
36756	96	0284	El Recuerdo	173638.988	0920118.012	0040	E15D23	R	3	0	0	1	17.6108300	-92.0216700	t
36757	96	0285	Dos de Abril (La Nueva Uni¢n)	173806.623	0920359.128	0040	E15D23	R	5	0	0	1	17.6351731	-92.0664244	t
36758	96	0286	La Perla	173732.940	0920406.243	0048	E15D23	R	4	0	0	1	17.6258167	-92.0684008	t
36759	96	0287	San Francisco (La Herradura)	174351.954	0915645.867	0010	E15D24	R	4	0	0	1	17.7310983	-91.9460742	t
36760	96	0288	San Rom n	173652.357	0920420.674	0060	E15D23	R	5	0	0	1	17.6145436	-92.0724094	t
36761	96	0290	Villa Para¡so	173743.166	0920141.308	0041	E15D23	R	11	0	0	2	17.6286572	-92.0281411	t
36762	96	0293	Landero C rdenas	175337.612	0915421.683	0002	E15D14	R	93	49	44	22	17.8937811	-91.9060231	t
36763	96	0294	Remolino 3ra. Secci¢n	175317.408	0914945.199	0002	E15D14	R	4	0	0	1	17.8881689	-91.8292219	t
36764	96	0295	San Joaqu¡n	174535.150	0920502.680	0026	E15D13	R	3	0	0	1	17.7597639	-92.0840778	t
36765	96	0296	Familia Gonz lez R¡o	174832.479	0915759.207	0012	E15D14	R	70	40	30	18	17.8090219	-91.9664464	t
36766	96	0297	San Joaqu¡n (Sabana Perdida)	174450.496	0915720.312	0010	E15D24	R	8	0	0	1	17.7473600	-91.9556422	t
36767	96	0298	C rdenas	173943.914	0920108.594	0020	E15D23	R	4	0	0	2	17.6621983	-92.0190539	t
36768	96	0299	Cuauhtemoc Quemado	173808.001	0920135.742	0030	E15D23	R	210	100	110	53	17.6355558	-92.0265950	t
36769	96	0300	Estaci¢n la Uni¢n	173656.395	0920445.899	0055	E15D23	R	486	226	260	109	17.6156653	-92.0794164	t
36770	96	0301	Juan Aldama	174443.606	0921054.176	0021	E15D23	R	116	61	55	22	17.7454461	-92.1817156	t
36771	96	0302	La Lucha	174438.183	0920946.217	0029	E15D23	R	30	19	11	7	17.7439397	-92.1628381	t
36772	96	0303	La Potranca	174150.306	0920111.137	0020	E15D23	R	3	0	0	1	17.6973072	-92.0197603	t
36773	96	0304	El Sacrificio	174501.132	0921028.934	0024	E15D13	R	4	0	0	1	17.7503144	-92.1747039	t
36774	96	0305	San Lorenzo	173655.029	0920407.197	0060	E15D23	R	3	0	0	1	17.6152858	-92.0686658	t
36775	96	0306	Santa Clara Palast£n	173821.012	0920126.004	0020	E15D23	R	11	0	0	2	17.6391700	-92.0238900	t
36776	96	0307	Zipote Vaina	174252.666	0920554.961	0030	E15D23	R	0	0	0	0	17.7146294	-92.0986003	t
36777	96	0308	Los Almendros	174704.090	0915757.741	0011	E15D14	R	0	0	0	0	17.7844694	-91.9660392	t
36778	96	0309	La Botijuela	174808.463	0915732.973	0009	E15D14	R	1	0	0	1	17.8023508	-91.9591592	t
36779	96	0310	Cuatro Hermanos	174648.248	0915756.109	0013	E15D14	R	4	0	0	1	17.7800689	-91.9655858	t
36780	96	0311	Paso Nuevo	175009.968	0915330.192	0004	E15D14	R	2	0	0	1	17.8361022	-91.8917200	t
36781	96	0312	El Pital	174928.952	0915035.824	0001	E15D14	R	4	0	0	1	17.8247089	-91.8432844	t
36782	96	0313	Rivera Cuyo Santa Cruz 2da. Secci¢n	175227.302	0915809.387	0001	E15D14	R	92	52	40	31	17.8742506	-91.9692742	t
36783	96	0314	San Jos‚	175313.496	0915201.438	0002	E15D14	R	98	55	43	20	17.8870822	-91.8670661	t
36784	96	0315	San Miguel	174951.996	0915242.996	0006	E15D14	R	0	0	0	0	17.8311100	-91.8786100	t
36785	96	0316	Familia Gonz lez R¡o	174842.984	0915754.000	0003	E15D14	R	56	28	28	15	17.8119400	-91.9650000	t
36786	96	0317	Santa Rosa	175251.587	0915114.382	0002	E15D14	R	17	8	9	3	17.8809964	-91.8539950	t
36787	96	0318	Ninguno [UNACH]	174042.169	0920133.272	0029	E15D23	R	7	0	0	2	17.6783803	-92.0259089	t
36788	96	0319	La Jungla	174012.654	0920204.259	0032	E15D23	R	5	0	0	1	17.6701817	-92.0345164	t
36789	96	0320	Santa Rosa	173834.891	0920144.321	0019	E15D23	R	3	0	0	1	17.6430253	-92.0289781	t
36790	96	0321	Santo Domingo	174023.741	0920152.020	0029	E15D23	R	5	0	0	1	17.6732614	-92.0311167	t
36791	96	0322	Lindavista 2da. Secci¢n	175000.509	0920053.973	-018	E15D13	R	131	60	71	21	17.8334747	-92.0149925	t
36792	96	0323	El Tr‚bol	174450.530	0915632.501	0010	E15D24	R	0	0	0	0	17.7473694	-91.9423614	t
36793	96	0324	San Luisito	174212.757	0915809.454	0016	E15D24	R	0	0	0	0	17.7035436	-91.9692928	t
36794	96	0325	El Mulato	175306.664	0915335.711	0000	E15D14	R	41	21	20	11	17.8851844	-91.8932531	t
36795	96	0326	El Nuevo Para¡so	174529.092	0915759.200	0009	E15D14	R	4	0	0	1	17.7580811	-91.9664444	t
36796	96	0327	Las Lupitas	174609.000	0920351.000	0020	E15D13	R	4	0	0	1	17.7691667	-92.0641667	t
36797	96	0328	Los Gemelos	174630.615	0920341.735	0017	E15D13	R	5	0	0	1	17.7751708	-92.0615931	t
36798	96	0329	San Jos‚	174207.890	0920059.323	0022	E15D23	R	3	0	0	1	17.7021917	-92.0164786	t
36799	96	0330	Santa Margarita	174218.741	0915904.781	0022	E15D24	R	81	45	36	25	17.7052058	-91.9846614	t
36800	96	0331	La Guadalupe	174454.020	0920751.382	0028	E15D23	R	4	0	0	1	17.7483389	-92.1309394	t
36801	96	0332	Las Isabeles	174449.090	0920810.072	0025	E15D23	R	2	0	0	1	17.7469694	-92.1361311	t
36802	96	0333	San Rafael	174633.727	0920716.678	0025	E15D13	R	2	0	0	1	17.7760353	-92.1212994	t
36803	96	0334	San Ed‚n	174635.097	0920757.069	0018	E15D13	R	0	0	0	0	17.7764158	-92.1325192	t
36804	96	0335	El Tuc n	174455.639	0920812.777	0024	E15D23	R	2	0	0	1	17.7487886	-92.1368825	t
36805	96	0336	El Capit n	174426.098	0921027.630	0028	E15D23	R	7	0	0	1	17.7405828	-92.1743417	t
36806	96	0337	Ninguno	174343.826	0915722.310	0021	E15D24	R	1	0	0	1	17.7288406	-91.9561972	t
36807	96	0338	Victoria	174507.138	0920752.521	0025	E15D13	R	0	0	0	0	17.7519828	-92.1312558	t
36808	96	0339	Nuevo Progreso	175146.341	0920259.938	0002	E15D13	R	172	91	81	40	17.8628725	-92.0499828	t
36809	96	0340	Buenavista Damasco	174057.370	0920326.130	0029	E15D23	R	0	0	0	0	17.6826028	-92.0572583	t
36810	97	0001	Cintalapa de Figueroa	164155.256	0934313.541	0540	E15C67	U	42467	20350	22117	10386	16.6986822	-93.7204281	t
36811	97	0002	Abelardo L. Rodr¡guez	164003.379	0934804.040	0579	E15C67	R	807	419	388	171	16.6676053	-93.8011222	t
36812	97	0003	Adolfo L¢pez Mateos	165249.005	0934248.320	0712	E15C57	R	684	335	349	141	16.8802792	-93.7134222	t
36813	97	0005	El Ahogadero	164859.668	0935018.435	0574	E15C57	R	0	0	0	0	16.8165744	-93.8384542	t
36814	97	0006	Los µlamos	163612.405	0934902.944	0626	E15C67	R	0	0	0	0	16.6034458	-93.8174844	t
36815	97	0007	Los Alpes	164945.103	0934351.919	0969	E15C57	R	5	0	0	1	16.8291953	-93.7310886	t
36816	97	0012	Los µngeles	163047.387	0935941.770	0683	E15C67	R	5	0	0	1	16.5131631	-93.9949361	t
36817	97	0014	La Victoria	163556.403	0934445.703	0720	E15C67	R	0	0	0	0	16.5990008	-93.7460286	t
36818	97	0017	Bellavista	164636.243	0935605.977	0787	E15C57	R	10	0	0	2	16.7767342	-93.9349936	t
36819	97	0019	El Brillante	163057.213	0940358.263	0724	E15C66	R	41	25	16	8	16.5158925	-94.0661842	t
36820	97	0020	Las Brisas	163034.559	0940105.705	0676	E15C66	R	2	0	0	1	16.5095997	-94.0182514	t
36821	97	0023	Rosendo Salazar	162818.294	0940010.238	0706	E15C76	R	955	458	497	234	16.4717483	-94.0028439	t
36822	97	0025	El Carmen	164105.084	0935053.320	0609	E15C67	R	12	0	0	2	16.6847456	-93.8481444	t
36823	97	0026	El Carmen	163052.559	0934931.016	0701	E15C67	R	29	14	15	8	16.5145997	-93.8252822	t
36824	97	0028	Las Casitas	163338.676	0940111.628	0781	E15C66	R	29	16	13	6	16.5607433	-94.0198967	t
36825	97	0032	La Cieneguilla	164520.321	0935654.291	0821	E15C57	R	0	0	0	0	16.7556447	-93.9484142	t
36826	97	0033	Cinco Cerros	162858.799	0940045.859	0708	E15C76	R	7	0	0	2	16.4829997	-94.0127386	t
36827	97	0036	Concepci¢n	162903.180	0935310.324	0720	E15C77	R	18	0	0	2	16.4842167	-93.8862011	t
36828	97	0037	Constituci¢n (El Chayotal)	165643.406	0935613.061	0734	E15C57	R	261	130	131	87	16.9453906	-93.9369614	t
36829	97	0041	El Danubio	163035.804	0940335.208	0732	E15C66	R	58	26	32	12	16.5099456	-94.0597800	t
36830	97	0044	Emiliano Zapata	164330.379	0934835.675	0631	E15C67	R	1507	771	736	318	16.7251053	-93.8099097	t
36831	97	0046	Estorac¢n	165116.675	0934751.865	0494	E15C57	R	168	78	90	44	16.8546319	-93.7977403	t
36832	97	0048	Felipe µngeles	165600.807	0935310.079	0709	E15C57	R	49	28	21	12	16.9335575	-93.8861331	t
36833	97	0050	La Florida	164808.230	0933822.559	0923	E15C58	R	467	235	232	105	16.8022861	-93.6395997	t
36834	97	0051	Francisco I. Madero	164811.699	0934523.820	0727	E15C57	R	1444	714	730	301	16.8032497	-93.7566167	t
36835	97	0052	La Gloria	163839.180	0934332.489	0596	E15C67	R	31	16	15	8	16.6442167	-93.7256914	t
36836	97	0053	Guadalupe	164242.011	0935208.072	0681	E15C67	R	12	7	5	3	16.7116697	-93.8689089	t
36837	97	0057	El Jord n	164416.276	0935550.707	0704	E15C67	R	0	0	0	0	16.7378544	-93.9307519	t
36838	97	0060	L zaro C rdenas	163614.648	0934729.154	0613	E15C67	U	3002	1474	1528	768	16.6040689	-93.7914317	t
36839	97	0062	Llano Grande	162842.614	0935448.857	0705	E15C77	R	17	10	7	3	16.4785039	-93.9135714	t
36840	97	0064	29 de Diciembre	164405.610	0935218.887	0783	E15C67	R	11	8	3	3	16.7348917	-93.8719131	t
36841	97	0066	Nazareth	165007.460	0934354.887	0915	E15C57	R	0	0	0	0	16.8354056	-93.7319131	t
36842	97	0069	Las Merceditas	165652.003	0935628.589	0755	E15C57	R	93	47	46	31	16.9477786	-93.9412747	t
36843	97	0071	M‚rida	163403.093	0934902.340	0659	E15C67	R	1412	706	706	285	16.5675258	-93.8173167	t
36844	97	0072	Monserrat	163600.963	0935907.049	0750	E15C67	R	0	0	0	0	16.6002675	-93.9852914	t
36845	97	0074	Las Moradas	162844.532	0935717.056	0705	E15C77	R	2	0	0	1	16.4790367	-93.9547378	t
36846	97	0078	La Naranja	163124.694	0935826.950	0663	E15C67	R	4	0	0	1	16.5235261	-93.9741528	t
36847	97	0080	Nueva Puebla	163029.665	0940341.817	0738	E15C66	R	26	12	14	7	16.5082403	-94.0616158	t
36848	97	0081	Nueva Tenochtitl n (Rizo de Oro)	162835.004	0940450.016	0781	E15C76	R	1640	816	824	389	16.4763900	-94.0805600	t
36849	97	0086	Orizaba	162948.062	0935858.289	0679	E15C77	R	11	5	6	3	16.4966839	-93.9828581	t
36850	97	0087	Palo Blanco	163041.989	0940358.630	0724	E15C66	R	9	0	0	2	16.5116636	-94.0662861	t
36851	97	0089	El Pencil	163346.612	0935931.756	0720	E15C67	R	26	15	11	8	16.5629478	-93.9921544	t
36852	97	0091	El Per£	163951.641	0935005.906	0609	E15C67	R	3	0	0	1	16.6643447	-93.8349739	t
36853	97	0092	El Dorado	162949.314	0935322.513	0691	E15C77	R	0	0	0	0	16.4970317	-93.8895869	t
36854	97	0094	El Platanillo	163100.789	0940344.370	0733	E15C66	R	17	8	9	3	16.5168858	-94.0623250	t
36855	97	0095	Pomposo Castellanos	163527.525	0935204.599	0619	E15C67	R	1489	723	766	339	16.5909792	-93.8679442	t
36856	97	0096	El Porvenir	164150.287	0935129.209	0639	E15C67	R	9	0	0	2	16.6973019	-93.8581136	t
36857	97	0097	El Progreso	164611.258	0935454.691	0661	E15C57	R	52	23	29	11	16.7697939	-93.9151919	t
36858	97	0098	Alta Vista	163346.769	0935820.863	0680	E15C67	R	15	9	6	3	16.5629914	-93.9724619	t
36859	97	0102	Nueva Reforma (El Recreo)	163834.922	0935157.948	0639	E15C67	R	137	68	69	24	16.6430339	-93.8660967	t
36860	97	0104	Rinc¢n Antonio	163321.040	0940106.705	0761	E15C66	R	21	10	11	4	16.5558444	-94.0185292	t
36861	97	0107	Roberto Barrios	163402.280	0935913.297	0705	E15C67	R	430	215	215	106	16.5673000	-93.9870269	t
36862	97	0109	Jacinto Tirado	164304.127	0934633.108	0601	E15C67	R	687	350	337	158	16.7178131	-93.7758633	t
36863	97	0111	San µngel	163646.093	0935130.519	0635	E15C67	R	9	0	0	1	16.6128036	-93.8584775	t
36864	97	0112	Los Olachea (San Antonio Valdiviana)	163210.287	0935119.247	0643	E15C67	R	27	13	14	4	16.5361908	-93.8553464	t
36865	97	0113	San Bartolo	163442.093	0935538.915	0677	E15C67	R	23	12	11	7	16.5783592	-93.9274764	t
36866	97	0114	San Carlos	163328.427	0935359.649	0656	E15C67	R	17	9	8	5	16.5578964	-93.8999025	t
36867	97	0116	Valle de Corzo (San Fernando)	162411.543	0935929.005	0830	E15C77	R	92	51	41	21	16.4032064	-93.9913903	t
36868	97	0117	San Francisco	164048.620	0935033.200	0601	E15C67	R	15	0	0	2	16.6801722	-93.8425556	t
36869	97	0121	San Jos‚ (El Cuajilote)	163017.938	0934856.254	0720	E15C67	R	4	0	0	1	16.5049828	-93.8156261	t
36870	97	0123	San Juan	164615.223	0934933.361	0655	E15C57	R	0	0	0	0	16.7708953	-93.8259336	t
36871	97	0125	San Luis	164217.232	0934215.830	0525	E15C67	R	113	58	55	23	16.7047867	-93.7043972	t
36872	97	0126	San Mateo	164609.883	0934425.813	0711	E15C57	R	27	13	14	7	16.7694119	-93.7405036	t
36873	97	0127	San Rafael	163514.142	0935312.941	0620	E15C67	R	0	0	0	0	16.5872617	-93.8869281	t
36874	97	0128	San Sebasti n	164725.014	0934850.134	0619	E15C57	R	179	110	69	41	16.7902817	-93.8139261	t
36875	97	0129	Las Cruces	163342.439	0935124.553	0661	E15C67	R	6	0	0	2	16.5617886	-93.8568203	t
36876	97	0131	Vista Hermosa	163921.516	0934341.003	0564	E15C67	R	0	0	0	0	16.6559767	-93.7280564	t
36877	97	0132	Santa Rita	163207.316	0935637.846	0640	E15C67	R	10	0	0	2	16.5353656	-93.9438461	t
36878	97	0133	Santa Rosa	163944.917	0934455.842	0580	E15C67	R	30	15	15	6	16.6624769	-93.7488450	t
36879	97	0135	Santa Teresa	163044.492	0940218.648	0699	E15C66	R	4	0	0	1	16.5123589	-94.0385133	t
36880	97	0137	Santiago	163328.621	0935958.795	0740	E15C67	R	53	30	23	12	16.5579503	-93.9996653	t
36881	97	0139	Santo Domingo	163725.228	0935339.298	0663	E15C67	R	0	0	0	0	16.6236744	-93.8942494	t
36882	97	0140	El Santuario	163409.051	0935416.453	0621	E15C67	R	7	0	0	2	16.5691808	-93.9045703	t
36883	97	0141	La Selva	163245.268	0935858.477	0697	E15C67	R	6	0	0	2	16.5459078	-93.9829103	t
36884	97	0144	Tehuacan	163541.780	0935742.109	0692	E15C67	R	505	252	253	122	16.5949389	-93.9616969	t
36885	97	0147	Triunfo de Madero	164616.846	0934618.905	0681	E15C57	R	959	480	479	229	16.7713461	-93.7719181	t
36886	97	0150	Uni¢n Pastrana	163007.222	0935216.006	0665	E15C67	R	10	6	4	4	16.5020061	-93.8711128	t
36887	97	0155	Villa del R¡o	164443.496	0935512.830	0682	E15C67	R	70	40	30	19	16.7454156	-93.9202306	t
36888	97	0156	Villamorelos	162848.500	0935536.744	0704	E15C77	R	1677	860	817	420	16.4801389	-93.9268733	t
36889	97	0157	Vista Hermosa	163111.310	0935743.042	0651	E15C67	R	1149	561	588	250	16.5198083	-93.9619561	t
36890	97	0159	Yerbasanta	163102.329	0940256.025	0692	E15C66	R	22	11	11	6	16.5173136	-94.0488958	t
36891	97	0160	El Zapote de Arriba	163751.516	0934637.544	0620	E15C67	R	32	15	17	5	16.6309767	-93.7770956	t
36892	97	0164	Unidad Modelo	165409.642	0934051.752	0739	E15C57	R	397	194	203	74	16.9026783	-93.6810422	t
36893	97	0165	Guadalupe Victoria	164457.862	0934650.372	0651	E15C67	R	358	188	170	81	16.7494061	-93.7806589	t
36894	97	0173	Santa Mar¡a	165510.488	0934935.240	0240	E15C57	R	11	8	3	4	16.9195800	-93.8264556	t
36895	97	0175	R¡o Negro (Pueblo Viejo)	165310.002	0935335.572	0286	E15C57	R	3	0	0	1	16.8861117	-93.8932144	t
36896	97	0178	Venustiano Carranza	165114.545	0934025.428	0820	E15C57	R	432	218	214	74	16.8540403	-93.6737300	t
36897	97	0179	Integral Adolfo L¢pez Mateos	163253.509	0934850.116	0689	E15C67	R	305	161	144	69	16.5481969	-93.8139211	t
36898	97	0180	Jos‚ Castillo Tielmans	164717.650	0934022.880	1038	E15C57	R	272	145	127	50	16.7882361	-93.6730222	t
36899	97	0188	Las Maravillas	163829.726	0934227.245	0580	E15C67	R	0	0	0	0	16.6415906	-93.7075681	t
36900	97	0193	Santa Elena	162927.238	0935119.056	0681	E15C77	R	7	4	3	3	16.4908994	-93.8552933	t
36901	97	0195	Alta Uni¢n	164349.831	0935323.581	0840	E15C67	R	4	0	0	1	16.7305086	-93.8898836	t
36902	97	0197	La Mora	164326.465	0935223.331	0712	E15C67	R	10	0	0	2	16.7240181	-93.8731475	t
36903	97	0198	Guerrero (Ocho de Marzo)	164636.594	0934504.369	0720	E15C57	R	0	0	0	0	16.7768317	-93.7512136	t
36904	97	0204	Sonora	164641.829	0934524.607	0720	E15C57	R	0	0	0	0	16.7782858	-93.7568353	t
36905	97	0208	La Raz¢n	163425.200	0934921.384	0640	E15C67	R	1	0	0	1	16.5736667	-93.8226067	t
36906	97	0211	San Antonio	164136.302	0935124.588	0619	E15C67	R	0	0	0	0	16.6934172	-93.8568300	t
36907	97	0212	Piedra Pintada	162902.469	0935032.961	0689	E15C77	R	4	0	0	1	16.4840192	-93.8424892	t
36908	97	0215	El Jard¡n	163038.093	0935636.735	0647	E15C67	R	8	0	0	2	16.5105814	-93.9435375	t
36909	97	0217	Los Cocos (Rancho Bonito)	162812.631	0935436.189	0741	E15C77	R	0	0	0	0	16.4701753	-93.9100525	t
36910	97	0218	San Miguel	162709.820	0935935.079	0703	E15C77	R	2	0	0	1	16.4527278	-93.9930775	t
36911	97	0219	Macuilapa	162933.172	0935828.128	0680	E15C77	R	25	13	12	4	16.4925478	-93.9744800	t
36912	97	0224	La Sombra	165116.738	0935038.873	0459	E15C57	R	3	0	0	1	16.8546494	-93.8441314	t
36913	97	0225	Nuevas Maravillas	164325.051	0940145.170	1281	E15C66	R	327	164	163	44	16.7236253	-94.0292139	t
36914	97	0228	Las Palmas	162559.146	0935827.949	0723	E15C77	R	0	0	0	0	16.4330961	-93.9744303	t
36915	97	0235	El Balsamar	163306.299	0934627.464	0693	E15C67	R	0	0	0	0	16.5517497	-93.7742956	t
36916	97	0236	Santa Ana	163140.863	0935528.026	0682	E15C67	R	19	11	8	4	16.5280175	-93.9244517	t
36917	97	0237	El Salvador	163230.347	0935328.639	0648	E15C67	R	13	5	8	3	16.5417631	-93.8912886	t
36918	97	0240	El Pensamiento	163711.506	0934454.473	0661	E15C67	R	4	0	0	1	16.6198628	-93.7484647	t
36919	97	0243	El Chahuitillo	162759.913	0940238.365	0839	E15C76	R	9	0	0	1	16.4666425	-94.0439903	t
36920	97	0245	El Retiro	162939.395	0935318.820	0687	E15C77	R	4	0	0	1	16.4942764	-93.8885611	t
36921	97	0247	La Esmeralda	163202.238	0935850.285	0680	E15C67	R	10	7	3	4	16.5339550	-93.9806347	t
36922	97	0252	Quintilo Vel zquez L	164708.422	0934557.838	0686	E15C57	R	0	0	0	0	16.7856728	-93.7660661	t
36923	97	0253	El Porvenir	165022.375	0934421.380	0944	E15C57	R	0	0	0	0	16.8395486	-93.7392722	t
36924	97	0254	La Argentina	164657.897	0934501.512	0720	E15C57	R	4	0	0	1	16.7827492	-93.7504200	t
36925	97	0255	Los Horcones	165121.753	0934446.098	0818	E15C57	R	61	34	27	8	16.8560425	-93.7461383	t
36926	97	0256	El Ensue¤o	165049.090	0934423.822	0819	E15C57	R	19	7	12	4	16.8469694	-93.7399506	t
36927	97	0257	La Virginia	165136.302	0934542.804	0836	E15C57	R	10	6	4	3	16.8600839	-93.7618900	t
36928	97	0258	San Cayetano	164937.240	0934405.001	1032	E15C57	R	10	0	0	1	16.8270111	-93.7347225	t
36929	97	0259	El Riego	164704.453	0934914.798	0603	E15C57	R	3	0	0	1	16.7845703	-93.8207772	t
36930	97	0260	La Bizca	164338.352	0934711.776	0603	E15C67	R	0	0	0	0	16.7273200	-93.7866044	t
36931	97	0262	Monterrey	165118.960	0934527.788	0919	E15C57	R	100	51	49	14	16.8552667	-93.7577189	t
36932	97	0263	La Noria	165005.507	0934950.692	0558	E15C57	R	0	0	0	0	16.8348631	-93.8307478	t
36933	97	0264	El Dorado	165049.435	0934246.427	0809	E15C57	R	9	0	0	1	16.8470653	-93.7128964	t
36934	97	0265	Ojo de Agua (Unesco)	165054.522	0934540.305	1033	E15C57	R	0	0	0	0	16.8484783	-93.7611958	t
36935	97	0266	El Aguaj¢n	165107.148	0934048.792	0820	E15C57	R	5	0	0	1	16.8519856	-93.6802200	t
36936	97	0267	El Medallin (Unesco)	164953.129	0934427.054	1000	E15C57	R	0	0	0	0	16.8314247	-93.7408483	t
36937	97	0274	San Antonio del R¡o	164609.075	0935459.348	0663	E15C57	R	0	0	0	0	16.7691875	-93.9164856	t
36938	97	0277	Las Margaritas	164031.776	0934820.173	0576	E15C67	R	8	0	0	2	16.6754933	-93.8056036	t
37000	97	0380	El Triunfo	162914.620	0935848.432	0661	E15C77	R	19	10	9	8	16.4873944	-93.9801200	t
36939	97	0278	Plan de Guadalupe Dos	164732.190	0935643.991	1133	E15C57	R	0	0	0	0	16.7922750	-93.9455531	t
36940	97	0280	Monte Sina¡ Dos (Los Horcones)	165021.345	0935015.019	0482	E15C57	R	47	26	21	15	16.8392625	-93.8375053	t
36941	97	0282	Agua Fr¡a	164924.966	0934415.425	1065	E15C57	R	0	0	0	0	16.8236017	-93.7376181	t
36942	97	0283	Morelia	163457.353	0934650.364	0631	E15C67	R	18	11	7	3	16.5825981	-93.7806567	t
36943	97	0284	Los Tamarindos	163602.887	0934756.271	0597	E15C67	R	4	0	0	1	16.6008019	-93.7989642	t
36944	97	0288	La Esperanza	163905.069	0934448.385	0593	E15C67	R	1	0	0	1	16.6514081	-93.7467736	t
36945	97	0289	La Odisea	163554.710	0934808.533	0596	E15C67	R	0	0	0	0	16.5985306	-93.8023703	t
36946	97	0291	Pur¡sima Concepci¢n (Loma Colorada)	163914.966	0934516.061	0596	E15C67	R	7	0	0	2	16.6541572	-93.7544614	t
36947	97	0294	La Muralla	163847.356	0934345.714	0582	E15C67	R	0	0	0	0	16.6464878	-93.7293650	t
36948	97	0302	Altamira	164130.133	0934141.867	0539	E15C67	R	7	0	0	2	16.6917036	-93.6949631	t
36949	97	0305	El Caracol	163820.949	0934605.032	0619	E15C67	R	5	0	0	1	16.6391525	-93.7680644	t
36950	97	0306	La Esperanza	163816.426	0934539.683	0640	E15C67	R	5	0	0	1	16.6378961	-93.7610231	t
36951	97	0307	Las Pi¤uelas	163930.386	0934547.524	0580	E15C67	R	37	25	12	9	16.6584406	-93.7632011	t
36952	97	0308	San Isidro las Pi¤uelas	163921.977	0934538.424	0584	E15C67	R	0	0	0	0	16.6561047	-93.7606733	t
36953	97	0310	Chamiapa	164138.679	0934130.698	0540	E15C67	R	5	0	0	1	16.6940775	-93.6918606	t
36954	97	0311	Los Pocitos	163959.069	0934602.645	0571	E15C67	R	4	0	0	2	16.6664081	-93.7674014	t
36955	97	0312	Santa Martha	164512.099	0934601.491	0641	E15C57	R	0	0	0	0	16.7533608	-93.7670808	t
36956	97	0316	Ocho de Enero	164223.883	0934244.666	0550	E15C67	R	150	76	74	43	16.7066342	-93.7124072	t
36957	97	0317	Palmira	164133.721	0934139.134	0534	E15C67	R	0	0	0	0	16.6927003	-93.6942039	t
36958	97	0318	Pimienta Berl¡n	164500.505	0934000.938	0622	E15C57	R	174	85	89	41	16.7501403	-93.6669272	t
36959	97	0319	San Jos‚ Montenegro	165619.407	0934853.494	0251	E15C57	R	11	0	0	2	16.9387242	-93.8148594	t
36960	97	0320	La Candelaria	164706.414	0934245.927	0914	E15C57	R	14	0	0	2	16.7851150	-93.7127575	t
36961	97	0321	General C rdenas	165339.029	0934342.633	0703	E15C57	R	438	228	210	84	16.8941747	-93.7285092	t
36962	97	0322	El Manantial	164020.880	0934300.028	0554	E15C67	R	0	0	0	0	16.6724667	-93.7166744	t
36963	97	0324	La Esperanza Fracci¢n Dos	164130.762	0934119.321	0530	E15C67	R	5	0	0	1	16.6918783	-93.6887003	t
36964	97	0325	El Framboy n	164116.008	0934027.984	0520	E15C67	R	4	0	0	1	16.6877800	-93.6744400	t
36965	97	0327	La Candelaria	163935.260	0934420.425	0581	E15C67	R	5	0	0	1	16.6597944	-93.7390069	t
36966	97	0328	San Jorge	164139.068	0934113.863	0521	E15C67	R	8	0	0	2	16.6941856	-93.6871842	t
36967	97	0329	La Enramada	163954.176	0934236.189	0553	E15C67	R	6	0	0	1	16.6650489	-93.7100525	t
36968	97	0330	Fracci¢n Nuevo Mundo	163620.091	0935602.580	0676	E15C67	R	0	0	0	0	16.6055808	-93.9340500	t
36969	97	0331	El Cipr‚s	163949.875	0934423.707	0568	E15C67	R	5	0	0	1	16.6638542	-93.7399186	t
36970	97	0333	Monte de los Olivos (La Mona)	163901.099	0935230.789	0659	E15C67	R	285	133	152	60	16.6503053	-93.8752192	t
36971	97	0337	Los Corazones	165239.617	0935314.629	0495	E15C57	R	4	0	0	1	16.8776714	-93.8873969	t
36972	97	0347	Eduardo Esponda [Parque Ecol¢gico]	164209.435	0934222.655	0536	E15C67	R	10	0	0	1	16.7026208	-93.7062931	t
36973	97	0348	Rancho Verde	164220.913	0934225.951	0522	E15C67	R	3	0	0	1	16.7058092	-93.7072086	t
36974	97	0349	Los Pinos	162537.695	0940027.314	0760	E15C76	R	4	0	0	1	16.4271375	-94.0075872	t
36975	97	0351	El Manguito	163905.485	0934720.686	0580	E15C67	R	7	0	0	1	16.6515236	-93.7890794	t
36976	97	0352	Ni¤os H‚roes	162657.223	0940052.372	0719	E15C76	R	104	53	51	28	16.4492286	-94.0145478	t
36977	97	0353	El Ocote	162428.416	0935927.957	0820	E15C77	R	2	0	0	1	16.4078933	-93.9910992	t
36978	97	0354	El Sina¡	162232.988	0935732.004	0929	E15C77	R	0	0	0	0	16.3758300	-93.9588900	t
36979	97	0356	El Zapotillo	162741.512	0935924.631	0710	E15C77	R	3	0	0	1	16.4615311	-93.9901753	t
36980	97	0357	Las Tasajeras	162452.070	0935711.508	0784	E15C77	R	2	0	0	1	16.4144639	-93.9531967	t
36981	97	0358	Colima	162745.769	0935622.824	0769	E15C77	R	0	0	0	0	16.4627136	-93.9396733	t
36982	97	0360	Guadalupe	162245.551	0935611.721	0922	E15C77	R	15	8	7	3	16.3793197	-93.9365892	t
36983	97	0361	Rancho Alegre	162257.024	0935624.929	0883	E15C77	R	10	0	0	1	16.3825067	-93.9402581	t
36984	97	0362	Santa Fe	162258.805	0935712.558	0838	E15C77	R	19	0	0	1	16.3830014	-93.9534883	t
36985	97	0363	Coraz¢n del Valle	162505.879	0935903.360	0802	E15C77	R	133	68	65	31	16.4182997	-93.9842667	t
36986	97	0364	El Palenque	163750.776	0935044.128	0600	E15C67	R	8	0	0	1	16.6307711	-93.8455911	t
36987	97	0365	San Joaqu¡n	163828.487	0935120.659	0627	E15C67	R	0	0	0	0	16.6412464	-93.8557386	t
36988	97	0366	Las Pitayas	163736.105	0934919.260	0581	E15C67	R	2	0	0	1	16.6266958	-93.8220167	t
36989	97	0367	El Egipto	163743.172	0935032.571	0595	E15C67	R	1	0	0	1	16.6286589	-93.8423808	t
36990	97	0368	Nueva Venecia	163810.594	0935059.070	0600	E15C67	R	0	0	0	0	16.6362761	-93.8497417	t
36991	97	0370	Las Dalias	163740.008	0934928.992	0577	E15C67	R	6	0	0	1	16.6277800	-93.8247200	t
36992	97	0372	Agua Escondida	163457.427	0935644.543	0679	E15C67	R	0	0	0	0	16.5826186	-93.9457064	t
36993	97	0373	El Aguaj¢n	163457.631	0935743.731	0707	E15C67	R	9	0	0	2	16.5826753	-93.9621475	t
36994	97	0374	Nuevo Coyoac n	163508.110	0935737.960	0700	E15C67	R	181	94	87	38	16.5855861	-93.9605444	t
36995	97	0375	Rancho Nuevo	163515.881	0935517.651	0646	E15C67	R	3	0	0	1	16.5877447	-93.9215697	t
36996	97	0376	14 de Febrero	163605.476	0935500.889	0645	E15C67	R	182	90	92	45	16.6015211	-93.9169136	t
36997	97	0377	San Francisco Hojam n	164039.083	0935209.128	0668	E15C67	R	16	9	7	5	16.6775231	-93.8692022	t
36998	97	0378	La Lagunita	163453.838	0935717.857	0700	E15C67	R	0	0	0	0	16.5816217	-93.9549603	t
36999	97	0379	El Jobito	163502.810	0935658.244	0677	E15C67	R	0	0	0	0	16.5841139	-93.9495122	t
37001	97	0381	El Ecuador	162929.874	0935834.189	0681	E15C77	R	4	0	0	2	16.4916317	-93.9761636	t
37002	97	0382	Santa Martha	162917.340	0935844.912	0663	E15C77	R	6	0	0	1	16.4881500	-93.9791422	t
37003	97	0383	La Nueva Espa¤a	162830.309	0935916.679	0697	E15C77	R	0	0	0	0	16.4750858	-93.9879664	t
37004	97	0384	El Horizonte	162924.423	0935906.368	0681	E15C77	R	7	0	0	2	16.4901175	-93.9851022	t
37005	97	0385	El Tesoro	162841.258	0935858.993	0685	E15C77	R	4	0	0	2	16.4781272	-93.9830536	t
37006	97	0387	La Orqu¡dea	164018.984	0940248.984	1206	E15C66	R	0	0	0	0	16.6719400	-94.0469400	t
37007	97	0388	Cris lidas (Plan del Mango)	164120.651	0940039.658	1025	E15C66	R	0	0	0	0	16.6890697	-94.0110161	t
37008	97	0390	Ci‚nega de Le¢n	164048.213	0940214.089	1110	E15C66	R	0	0	0	0	16.6800592	-94.0372469	t
37009	97	0391	La Higuera	162938.369	0935337.602	0699	E15C77	R	0	0	0	0	16.4939914	-93.8937783	t
37010	97	0392	Vista Alegre (El Mercadito)	165101.368	0934240.174	0802	E15C57	R	5	0	0	1	16.8503800	-93.7111594	t
37011	97	0393	El Socorro	163246.629	0935341.469	0645	E15C67	R	6	0	0	2	16.5462858	-93.8948525	t
37012	97	0394	éltimo de Mayo	163240.089	0935334.870	0644	E15C67	R	10	5	5	3	16.5444692	-93.8930194	t
37013	97	0396	La Veleta	163234.807	0935329.319	0645	E15C67	R	2	0	0	1	16.5430019	-93.8914775	t
37014	97	0397	Las Crucecitas	163328.103	0935206.992	0618	E15C67	R	9	0	0	2	16.5578064	-93.8686089	t
37015	97	0398	Esperanza de los Pobres	163605.440	0935431.205	0642	E15C67	R	410	195	215	71	16.6015111	-93.9086681	t
37016	97	0399	San Juanito	163334.068	0935409.485	0642	E15C67	R	8	0	0	1	16.5594633	-93.9026347	t
37017	97	0400	La Gloria	163358.244	0935424.163	0620	E15C67	R	5	0	0	1	16.5661789	-93.9067119	t
37018	97	0401	El Desierto	163329.572	0935408.629	0641	E15C67	R	5	0	0	2	16.5582144	-93.9023969	t
37019	97	0402	El Calvario	163318.981	0935347.943	0660	E15C67	R	3	0	0	1	16.5552725	-93.8966508	t
37020	97	0403	El Pensamiento	163320.686	0935347.822	0660	E15C67	R	7	0	0	1	16.5557461	-93.8966172	t
37021	97	0404	La Esperanza	163352.723	0935427.553	0620	E15C67	R	8	0	0	2	16.5646453	-93.9076536	t
37022	97	0405	Argentina	163302.512	0935413.971	0640	E15C67	R	0	0	0	0	16.5506978	-93.9038808	t
37023	97	0406	Rancho Alegre	163342.681	0935416.731	0639	E15C67	R	6	0	0	1	16.5618558	-93.9046475	t
37024	97	0407	Santa Anita	163305.900	0935414.525	0635	E15C67	R	27	11	16	4	16.5516389	-93.9040347	t
37025	97	0408	Solo Dios	163245.698	0935401.115	0643	E15C67	R	0	0	0	0	16.5460272	-93.9003097	t
37026	97	0410	Las Reynas	163429.474	0935027.016	0616	E15C67	R	1	0	0	1	16.5748539	-93.8408378	t
37027	97	0411	San Andr‚s	162829.957	0935256.996	0760	E15C77	R	0	0	0	0	16.4749881	-93.8824989	t
37028	97	0412	Tres Hermanos	162832.540	0935254.529	0760	E15C77	R	3	0	0	1	16.4757056	-93.8818136	t
37029	97	0413	El Chiflido	162922.975	0935449.005	0694	E15C77	R	17	10	7	4	16.4897153	-93.9136125	t
37030	97	0415	Los Andes	162457.440	0935738.788	0766	E15C77	R	6	0	0	1	16.4159556	-93.9607744	t
37031	97	0416	Los Flamboyanes	162923.718	0935437.495	0701	E15C77	R	9	0	0	2	16.4899217	-93.9104153	t
37032	97	0418	Las Jaquimas	162953.583	0940714.431	0835	E15C76	R	11	6	5	3	16.4982175	-94.1206753	t
37033	97	0423	Sagrado Coraz¢n de Jes£s	162805.871	0940143.856	0807	E15C76	R	0	0	0	0	16.4682975	-94.0288489	t
37034	97	0424	Brasilia	163039.259	0935057.939	0660	E15C67	R	11	6	5	3	16.5109053	-93.8494275	t
37035	97	0425	El Carrizal	163054.474	0935109.081	0650	E15C67	R	7	0	0	2	16.5151317	-93.8525225	t
37036	97	0426	San Marcos	163036.641	0935117.610	0661	E15C67	R	165	85	80	39	16.5101781	-93.8548917	t
37037	97	0427	La Ilusi¢n	163127.691	0935108.191	0645	E15C67	R	2	0	0	1	16.5243586	-93.8522753	t
37038	97	0429	San Jos‚ Montecristo	163223.244	0935151.630	0633	E15C67	R	10	0	0	1	16.5397900	-93.8643417	t
37039	97	0430	El Lienzo	162943.962	0935030.311	0667	E15C77	R	0	0	0	0	16.4955450	-93.8417531	t
37040	97	0431	El Recuerdo	163158.446	0935149.321	0640	E15C67	R	8	0	0	1	16.5329017	-93.8637003	t
37041	97	0432	San Ricardo	163340.996	0934702.989	0666	E15C67	R	8	4	4	3	16.5613878	-93.7841636	t
37042	97	0433	El Tri ngulo	163058.119	0934914.476	0718	E15C67	R	11	5	6	3	16.5161442	-93.8206878	t
37043	97	0434	Puerto Barrio	163050.219	0934917.966	0706	E15C67	R	0	0	0	0	16.5139497	-93.8216572	t
37044	97	0435	La Argentina	163220.043	0934743.555	0738	E15C67	R	0	0	0	0	16.5389008	-93.7954319	t
37045	97	0437	Las Canoitas Primera	162800.957	0940628.913	0989	E15C76	R	13	0	0	2	16.4669325	-94.1080314	t
37046	97	0439	Ingeniero Eloy Borras Aguilar	163802.162	0935630.239	0773	E15C67	R	235	136	99	43	16.6339339	-93.9417331	t
37047	97	0441	Monterrey	163237.157	0935650.438	0640	E15C67	R	18	0	0	2	16.5436547	-93.9473439	t
37048	97	0442	El Rub¡	163041.090	0935959.558	0686	E15C67	R	7	0	0	1	16.5114139	-93.9998772	t
37049	97	0444	Miramar (El Tempisque)	163224.988	0935655.643	0640	E15C67	R	19	9	10	4	16.5402744	-93.9487897	t
37050	97	0445	El Estoraque (El Organal)	163259.382	0935740.749	0660	E15C67	R	6	0	0	1	16.5498283	-93.9613192	t
37051	97	0446	San Jacinto	163048.335	0935638.058	0647	E15C67	R	8	5	3	3	16.5134264	-93.9439050	t
37052	97	0447	El Cielito	163100.802	0935644.186	0643	E15C67	R	10	5	5	4	16.5168894	-93.9456072	t
37053	97	0448	San Juan	163004.322	0935935.196	0681	E15C67	R	7	0	0	2	16.5012006	-93.9931100	t
37054	97	0449	El Guam£chil	163038.463	0935859.727	0660	E15C67	R	20	12	8	4	16.5106842	-93.9832575	t
37055	97	0450	El Ed‚n	163009.623	0935941.249	0667	E15C67	R	10	0	0	1	16.5026731	-93.9947914	t
37056	97	0451	El Bosque	163046.880	0935741.931	0653	E15C67	R	13	5	8	4	16.5130222	-93.9616475	t
37057	97	0452	El Pensamiento (El Arbolito)	163020.510	0935738.008	0655	E15C67	R	0	0	0	0	16.5056972	-93.9605578	t
37058	97	0453	Las Bugambilias	163100.218	0940205.519	0687	E15C66	R	15	8	7	4	16.5167272	-94.0348664	t
37059	97	0454	La Florida	163037.000	0940116.000	0680	E15C66	R	0	0	0	0	16.5102778	-94.0211111	t
37060	97	0455	Terranova	163515.297	0935913.012	0724	E15C67	R	0	0	0	0	16.5875825	-93.9869478	t
37061	97	0456	La Herradura	163444.088	0935859.689	0715	E15C67	R	14	7	7	3	16.5789133	-93.9832469	t
37062	97	0457	La Cima	163111.975	0940311.900	0725	E15C66	R	0	0	0	0	16.5199931	-94.0533056	t
37063	97	0458	Juan Carral	163359.173	0940152.140	0830	E15C66	R	1	0	0	1	16.5664369	-94.0311500	t
37064	97	0459	El Oriente	163125.314	0940307.032	0739	E15C66	R	1	0	0	1	16.5236983	-94.0519533	t
37065	97	0460	San Mateo	163124.425	0940332.715	0742	E15C66	R	3	0	0	1	16.5234514	-94.0590875	t
37066	97	0461	Las Dos Gardenias	162959.521	0940403.070	0764	E15C76	R	0	0	0	0	16.4998669	-94.0675194	t
37067	97	0462	El Manguito	163345.812	0940037.150	0754	E15C66	R	25	8	17	3	16.5627256	-94.0103194	t
37068	97	0463	El Calvario	163259.810	0940121.454	0801	E15C66	R	6	0	0	2	16.5499472	-94.0226261	t
37069	97	0464	Las Perlas	162827.863	0940250.090	0857	E15C76	R	6	0	0	2	16.4744064	-94.0472472	t
37131	97	0555	Santa Julia	164117.941	0935034.949	0605	E15C67	R	12	0	0	2	16.6883169	-93.8430414	t
37070	97	0469	Jorge de la Vega Dom¡nguez (Las Pavas)	164310.312	0935936.703	1033	E15C67	R	156	81	75	30	16.7195311	-93.9935286	t
37071	97	0471	Las Minas	164045.401	0934118.967	0537	E15C67	R	3	0	0	1	16.6792781	-93.6886019	t
37072	97	0472	La Piedad	164038.020	0934211.381	0544	E15C67	R	0	0	0	0	16.6772278	-93.7031614	t
37073	97	0473	Santa Patricia	163915.123	0934204.475	0556	E15C67	R	0	0	0	0	16.6542008	-93.7012431	t
37074	97	0474	An¡bal Moguel Farrera	164114.483	0934121.841	0548	E15C67	R	4	0	0	1	16.6873564	-93.6894003	t
37075	97	0475	Avimarca	163932.356	0934146.176	0548	E15C67	R	0	0	0	0	16.6589878	-93.6961600	t
37076	97	0478	San Francisco	163957.284	0934153.422	0553	E15C67	R	5	0	0	1	16.6659122	-93.6981728	t
37077	97	0479	El Triunfo	163957.922	0934212.426	0541	E15C67	R	1	0	0	1	16.6660894	-93.7034517	t
37078	97	0480	El Cafetal (Rancho Nuevo)	162233.514	0935739.978	0919	E15C77	R	0	0	0	0	16.3759761	-93.9611050	t
37079	97	0483	Buenos Aires	164941.988	0934250.004	0959	E15C57	R	0	0	0	0	16.8283300	-93.7138900	t
37080	97	0484	Las Tres Mar¡as	164938.451	0934324.619	0925	E15C57	R	5	0	0	1	16.8273475	-93.7235053	t
37081	97	0486	Javier L¢pez Moreno	164850.790	0934352.878	0944	E15C57	R	12	0	0	2	16.8141083	-93.7313550	t
37082	97	0487	Santa In‚s	164829.033	0934323.012	0960	E15C57	R	0	0	0	0	16.8080647	-93.7230589	t
37083	97	0488	San Antonio	164729.713	0934433.659	0724	E15C57	R	0	0	0	0	16.7915869	-93.7426831	t
37084	97	0489	El Naranjo	164723.235	0934411.060	0743	E15C57	R	0	0	0	0	16.7897875	-93.7364056	t
37085	97	0490	Rancho Escondido	164647.157	0934352.708	0739	E15C57	R	5	0	0	1	16.7797658	-93.7313078	t
37086	97	0493	U¤a de Gato	164509.368	0934504.494	0693	E15C57	R	40	22	18	8	16.7526022	-93.7512483	t
37087	97	0494	Las Naranjas	165045.132	0934312.126	0829	E15C57	R	7	0	0	2	16.8458700	-93.7200350	t
37088	97	0495	Las Perlas	165007.237	0934349.342	0911	E15C57	R	16	0	0	2	16.8353436	-93.7303728	t
37089	97	0496	San Antonio	165126.470	0934559.161	0938	E15C57	R	27	13	14	4	16.8573528	-93.7664336	t
37090	97	0497	Colonia G¢mez	164147.800	0934941.866	0640	E15C67	R	2	0	0	1	16.6966111	-93.8282961	t
37091	97	0499	Los Limones (Tetesquite)	164825.925	0934914.012	0620	E15C57	R	9	0	0	1	16.8072014	-93.8205589	t
37092	97	0502	Las Pilas (Santa érsula)	164249.596	0934843.573	0626	E15C67	R	7	0	0	2	16.7137767	-93.8121036	t
37093	97	0503	P‚njamo	164710.734	0935332.542	0556	E15C57	R	0	0	0	0	16.7863150	-93.8923728	t
37094	97	0504	El Carrizalillo	164246.165	0935022.138	0683	E15C67	R	0	0	0	0	16.7128236	-93.8394828	t
37095	97	0505	El Majagual	164533.012	0935051.000	0721	E15C57	R	0	0	0	0	16.7591700	-93.8475000	t
37096	97	0506	Piedra Azul	164917.084	0935009.314	0544	E15C57	R	4	0	0	1	16.8214122	-93.8359206	t
37097	97	0507	Agua Dulce	164935.953	0935023.262	0532	E15C57	R	0	0	0	0	16.8266536	-93.8397950	t
37098	97	0508	El Jobal	165301.722	0935027.625	0339	E15C57	R	2	0	0	1	16.8838117	-93.8410069	t
37099	97	0509	El Chichonal	165341.588	0934846.205	0455	E15C57	R	21	10	11	4	16.8948856	-93.8128347	t
37100	97	0510	Sim¢n Bol¡var (El Transval)	165214.744	0935024.479	0390	E15C57	R	136	69	67	32	16.8707622	-93.8401331	t
37101	97	0511	Las µnimas	165310.705	0935019.543	0357	E15C57	R	0	0	0	0	16.8863069	-93.8387619	t
37102	97	0512	Guadalupe Victoria Uno (La Herradura)	165041.581	0934921.556	0486	E15C57	R	68	34	34	18	16.8448836	-93.8226544	t
37103	97	0513	El Chintule	165130.761	0934949.835	0444	E15C57	R	2	0	0	1	16.8585447	-93.8305097	t
37104	97	0515	La Herradura	164438.742	0935530.093	0694	E15C67	R	2	0	0	1	16.7440950	-93.9250258	t
37105	97	0516	Horno Blanco	164449.815	0935715.158	0770	E15C67	R	0	0	0	0	16.7471708	-93.9542106	t
37106	97	0517	El Caracol	164611.166	0935647.599	0825	E15C57	R	5	0	0	1	16.7697683	-93.9465553	t
37107	97	0519	Nuevo Amanecer Tenejapa	164210.702	0935502.626	0800	E15C67	R	81	43	38	15	16.7029728	-93.9173961	t
37108	97	0520	Vallarta	164212.903	0935249.960	0675	E15C67	R	4	0	0	1	16.7035842	-93.8805444	t
37109	97	0521	San Jos‚ Betania	164224.077	0935326.978	0682	E15C67	R	3	0	0	1	16.7066881	-93.8908272	t
37110	97	0525	Los Joaquines	165132.612	0934140.248	0765	E15C57	R	150	83	67	31	16.8590589	-93.6945133	t
37111	97	0533	El Pital	164910.992	0935339.012	0617	E15C57	R	0	0	0	0	16.8197200	-93.8941700	t
37112	97	0534	San Mart¡n	164811.145	0935305.041	0589	E15C57	R	0	0	0	0	16.8030958	-93.8847336	t
37113	97	0535	Chicozapote las Casetas	164732.569	0935407.669	0620	E15C57	R	0	0	0	0	16.7923803	-93.9021303	t
37114	97	0536	Mariano P‚rez D¡az (La Joya)	164646.019	0935455.835	0624	E15C57	R	89	51	38	12	16.7794497	-93.9155097	t
37115	97	0537	San Judas (San Jacinto)	164634.549	0935547.277	0737	E15C57	R	14	6	8	3	16.7762636	-93.9297992	t
37116	97	0538	La Jabalina	164712.012	0935151.012	0699	E15C57	R	0	0	0	0	16.7866700	-93.8641700	t
37117	97	0539	Guillermo Vel zquez	164911.117	0934849.830	0579	E15C57	R	0	0	0	0	16.8197547	-93.8138417	t
37118	97	0540	Gilberto Morales	164858.123	0934855.307	0580	E15C57	R	0	0	0	0	16.8161453	-93.8153631	t
37119	97	0541	Alberto Valencia	164855.008	0934854.000	0579	E15C57	R	0	0	0	0	16.8152800	-93.8150000	t
37120	97	0542	La Pe¤ita	164851.733	0934849.759	0584	E15C57	R	0	0	0	0	16.8143703	-93.8138219	t
37121	97	0543	El Manguito	164816.583	0934856.615	0610	E15C57	R	0	0	0	0	16.8046064	-93.8157264	t
37122	97	0544	El Para¡so	165117.294	0934511.972	0922	E15C57	R	24	11	13	4	16.8548039	-93.7533256	t
37123	97	0545	La Herendira	165038.271	0934525.171	1051	E15C57	R	0	0	0	0	16.8439642	-93.7569919	t
37124	97	0546	Las Carmelitas	165132.281	0934609.877	0940	E15C57	R	129	62	67	21	16.8589669	-93.7694103	t
37125	97	0547	Encarnaci¢n Hern ndez L.	165027.151	0934312.016	0947	E15C57	R	6	0	0	1	16.8408753	-93.7200044	t
37126	97	0549	La Esperanza	164724.608	0934504.021	0704	E15C57	R	0	0	0	0	16.7901689	-93.7511169	t
37127	97	0550	El Tri ngulo	164050.035	0935728.906	0829	E15C67	R	0	0	0	0	16.6805653	-93.9580294	t
37128	97	0551	Corral Falso	164313.480	0935418.792	0797	E15C67	R	0	0	0	0	16.7204111	-93.9052200	t
37129	97	0552	C¢rdova	164215.391	0935542.442	0786	E15C67	R	9	0	0	2	16.7042753	-93.9284561	t
37130	97	0554	San Vicente	164446.166	0935305.758	0757	E15C67	R	0	0	0	0	16.7461572	-93.8849328	t
37132	97	0556	El Saltillo	163905.948	0934521.847	0593	E15C67	R	6	0	0	1	16.6516522	-93.7560686	t
37133	97	0557	San Antonio del Valle	163830.959	0934610.918	0616	E15C67	R	77	33	44	20	16.6419331	-93.7696994	t
37134	97	0559	San Juditas	164052.902	0934158.267	0537	E15C67	R	3	0	0	1	16.6813617	-93.6995186	t
37135	97	0560	El Recuerdo	163950.772	0934759.712	0581	E15C67	R	0	0	0	0	16.6641033	-93.7999200	t
37136	97	0561	La Esperanza	163745.115	0935039.727	0597	E15C67	R	4	0	0	2	16.6291986	-93.8443686	t
37137	97	0562	Puerto Rico	163708.949	0935038.068	0593	E15C67	R	0	0	0	0	16.6191525	-93.8439078	t
37138	97	0564	El Amate	163902.073	0934353.921	0573	E15C67	R	2	0	0	1	16.6505758	-93.7316447	t
37139	97	0566	La Gavia	163510.987	0934720.864	0610	E15C67	R	5	0	0	1	16.5863853	-93.7891289	t
37140	97	0568	Villahermosa	163544.175	0934728.166	0605	E15C67	R	8	0	0	1	16.5956042	-93.7911572	t
37141	97	0569	Dos Hermanos	163536.877	0934726.682	0603	E15C67	R	0	0	0	0	16.5935769	-93.7907450	t
37142	97	0571	El Milagro	163543.426	0934833.636	0619	E15C67	R	5	0	0	1	16.5953961	-93.8093433	t
37143	97	0578	La Vibora	162952.597	0940710.967	0844	E15C76	R	0	0	0	0	16.4979436	-94.1197131	t
37144	97	0579	El Ocotillo	162738.988	0940539.984	0925	E15C76	R	0	0	0	0	16.4608300	-94.0944400	t
37145	97	0580	San Juan de Dios	163556.342	0934721.549	0601	E15C67	R	0	0	0	0	16.5989839	-93.7893192	t
37146	97	0581	Los Clavelitos (Pil¢n de Az£car)	162739.974	0940412.487	0848	E15C76	R	0	0	0	0	16.4611039	-94.0701353	t
37147	97	0582	El Sina¡ (Santa Elena)	162745.000	0940419.992	0842	E15C76	R	0	0	0	0	16.4625000	-94.0722200	t
37148	97	0583	Las Maravillas	163133.529	0940310.533	0741	E15C66	R	0	0	0	0	16.5259803	-94.0529258	t
37149	97	0584	El Amatillo	163059.249	0940305.020	0700	E15C66	R	2	0	0	1	16.5164581	-94.0513944	t
37150	97	0585	Santo Domingo	163056.844	0940234.595	0704	E15C66	R	24	15	9	7	16.5157900	-94.0429431	t
37151	97	0586	Nueva Vida	163056.807	0940253.297	0702	E15C66	R	14	8	6	4	16.5157797	-94.0481381	t
37152	97	0587	Lindavista	163053.624	0940245.185	0703	E15C66	R	8	0	0	1	16.5148956	-94.0458847	t
37153	97	0588	La Verbena	163046.678	0940303.307	0706	E15C66	R	5	0	0	1	16.5129661	-94.0509186	t
37154	97	0589	Siete Hermanos	163047.184	0940310.377	0707	E15C66	R	14	9	5	3	16.5131067	-94.0528825	t
37155	97	0590	El Consuelo	163053.187	0940225.570	0694	E15C66	R	2	0	0	1	16.5147742	-94.0404361	t
37156	97	0591	El Recuerdo	163050.600	0940239.527	0698	E15C66	R	3	0	0	1	16.5140556	-94.0443131	t
37157	97	0592	Las Lluvias	163047.690	0940122.388	0686	E15C66	R	5	0	0	1	16.5132472	-94.0228856	t
37158	97	0593	La Angostura	163011.016	0940512.012	0760	E15C66	R	0	0	0	0	16.5030600	-94.0866700	t
37159	97	0597	Las Guan banas	165351.000	0935007.008	0331	E15C57	R	0	0	0	0	16.8975000	-93.8352800	t
37160	97	0600	La Ceiba	164920.193	0934939.083	0565	E15C57	R	0	0	0	0	16.8222758	-93.8275231	t
37161	97	0601	La Bugambilia	164834.417	0934849.904	0616	E15C57	R	3	0	0	1	16.8095603	-93.8138622	t
37162	97	0602	Manuel Mart¡nez	163807.897	0934552.495	0610	E15C67	R	0	0	0	0	16.6355269	-93.7645819	t
37163	97	0603	Vesubio	163729.233	0934504.823	0657	E15C67	R	0	0	0	0	16.6247869	-93.7513397	t
37164	97	0604	Santa Ana	163647.988	0934444.016	0680	E15C67	R	12	0	0	2	16.6133300	-93.7455600	t
37165	97	0605	Santa Rita la Paloma	163822.955	0934154.493	0568	E15C67	R	7	0	0	1	16.6397097	-93.6984703	t
37166	97	0606	La Guacamaya	163357.239	0935753.610	0687	E15C67	R	14	8	6	3	16.5658997	-93.9648917	t
37167	97	0608	El Faro	163344.558	0935903.043	0702	E15C67	R	13	8	5	3	16.5623772	-93.9841786	t
37168	97	0609	El Porvenir	163336.015	0935949.466	0722	E15C67	R	0	0	0	0	16.5600042	-93.9970739	t
37169	97	0610	Las Margaritas	163208.797	0935835.139	0681	E15C67	R	33	15	18	7	16.5357769	-93.9764275	t
37170	97	0611	Betania	163227.591	0935906.035	0682	E15C67	R	16	0	0	2	16.5409975	-93.9850097	t
37171	97	0612	Zacualpa	163052.781	0935802.861	0660	E15C67	R	8	5	3	3	16.5146614	-93.9674614	t
37172	97	0613	San Francisco	163026.975	0935827.649	0665	E15C67	R	0	0	0	0	16.5074931	-93.9743469	t
37173	97	0614	Tierra Blanca	163118.302	0935646.263	0641	E15C67	R	6	0	0	2	16.5217506	-93.9461842	t
37174	97	0615	El Milagro	163038.695	0935646.140	0644	E15C67	R	8	0	0	2	16.5107486	-93.9461500	t
37175	97	0616	La Primavera	163045.049	0935716.853	0641	E15C67	R	4	0	0	1	16.5125136	-93.9546814	t
37176	97	0617	Rancho Bonito	163047.103	0935727.097	0642	E15C67	R	8	0	0	1	16.5130842	-93.9575269	t
37177	97	0618	El Bernal	162938.623	0935949.673	0683	E15C77	R	24	12	12	5	16.4940619	-93.9971314	t
37178	97	0620	Rinc¢n Sand¡a	163023.004	0940059.004	0716	E15C66	R	0	0	0	0	16.5063900	-94.0163900	t
37179	97	0621	Las Murallas	163105.621	0940157.788	0686	E15C66	R	12	0	0	2	16.5182281	-94.0327189	t
37180	97	0622	San Lucas	163234.575	0935929.863	0706	E15C67	R	4	0	0	1	16.5429375	-93.9916286	t
37181	97	0624	El Socorro Dos	163244.230	0935329.545	0639	E15C67	R	4	0	0	1	16.5456194	-93.8915403	t
37182	97	0627	La Fortuna	163245.157	0935317.719	0642	E15C67	R	10	0	0	2	16.5458769	-93.8882553	t
37183	97	0628	El Tule	163247.330	0935303.491	0632	E15C67	R	5	0	0	1	16.5464806	-93.8843031	t
37184	97	0629	El Milagro	163019.011	0935313.470	0702	E15C67	R	0	0	0	0	16.5052808	-93.8870750	t
37185	97	0630	El Oasis	163002.295	0935245.711	0677	E15C67	R	10	0	0	2	16.5006375	-93.8793642	t
37186	97	0631	Paso Real	162959.598	0935304.923	0687	E15C77	R	0	0	0	0	16.4998883	-93.8847008	t
37187	97	0632	Santa Cruz	162941.778	0935252.246	0682	E15C77	R	0	0	0	0	16.4949383	-93.8811794	t
37188	97	0633	El Siete (El Cero)	163417.727	0935040.171	0630	E15C67	R	2	0	0	1	16.5715908	-93.8444919	t
37189	97	0634	El Palomar	163128.665	0935314.915	0689	E15C67	R	6	0	0	1	16.5246292	-93.8874764	t
37190	97	0635	San Luis	163015.051	0934900.426	0713	E15C67	R	0	0	0	0	16.5041808	-93.8167850	t
37191	97	0637	Xochimilco	163413.381	0934655.064	0648	E15C67	R	0	0	0	0	16.5703836	-93.7819622	t
37192	97	0638	El Gran Chaparral	163320.536	0935047.580	0647	E15C67	R	3	0	0	2	16.5557044	-93.8465500	t
37193	97	0640	Los Miradores	162550.988	0935926.988	0777	E15C77	R	0	0	0	0	16.4308300	-93.9908300	t
37194	97	0642	Buenavista	162853.938	0935343.848	0722	E15C77	R	5	0	0	1	16.4816494	-93.8955133	t
37195	97	0643	San Francisco (La V¡bora)	162742.793	0935417.432	0764	E15C77	R	0	0	0	0	16.4618869	-93.9048422	t
37196	97	0644	La Escondida	163613.765	0934818.950	0590	E15C67	R	5	0	0	1	16.6038236	-93.8052639	t
37197	97	0646	El Novillero	163656.805	0935001.237	0583	E15C67	R	22	11	11	3	16.6157792	-93.8336769	t
37198	97	0648	Las Pilas	163011.686	0940340.440	0757	E15C66	R	10	0	0	2	16.5032461	-94.0612333	t
37199	97	0649	San Jos‚ la Verdad	162628.703	0940027.087	0762	E15C76	R	33	17	16	7	16.4413064	-94.0075242	t
37200	97	0650	Emiliano Zapata	165200.559	0934105.540	0768	E15C57	R	407	218	189	85	16.8668219	-93.6848722	t
37201	97	0651	La Argentina	164502.034	0934853.090	0644	E15C57	R	0	0	0	0	16.7505650	-93.8147472	t
37202	97	0652	La Isleta	163530.680	0934640.757	0621	E15C67	R	0	0	0	0	16.5918556	-93.7779881	t
37203	97	0653	Piedra de Cal	162754.000	0940629.988	0984	E15C76	R	0	0	0	0	16.4650000	-94.1083300	t
37204	97	0655	Sagrado Coraz¢n de Jes£s	164430.215	0934921.651	0680	E15C67	R	0	0	0	0	16.7417264	-93.8226808	t
37205	97	0656	La Claudia (Los Cocodrilos)	164012.426	0934257.213	0547	E15C67	R	4	0	0	1	16.6701183	-93.7158925	t
37206	97	0659	La Pe¤a	165623.530	0934900.807	0249	E15C57	R	7	0	0	2	16.9398694	-93.8168908	t
37207	97	0660	Las Palmas	165622.243	0934841.713	0248	E15C57	R	4	0	0	1	16.9395119	-93.8115869	t
37208	97	0667	San Vicente	162554.927	0935929.632	0780	E15C77	R	1	0	0	1	16.4319242	-93.9915644	t
37209	97	0669	Jilotepec	162829.241	0935909.198	0699	E15C77	R	0	0	0	0	16.4747892	-93.9858883	t
37210	97	0671	El Saltillo	162826.078	0935937.604	0698	E15C77	R	3	0	0	1	16.4739106	-93.9937789	t
37211	97	0672	El Capul¡n	163510.043	0935633.778	0681	E15C67	R	0	0	0	0	16.5861231	-93.9427161	t
37212	97	0674	Las Palmas	163907.369	0935737.746	0908	E15C67	R	104	50	54	19	16.6520469	-93.9604850	t
37213	97	0675	Nueva Libertad	163616.501	0935500.752	0655	E15C67	R	229	114	115	54	16.6045836	-93.9168756	t
37214	97	0677	Todos Santos	163812.559	0934243.639	0593	E15C67	R	18	12	6	3	16.6368219	-93.7121219	t
37215	97	0678	El Duraznillo	163829.791	0934241.367	0582	E15C67	R	2	0	0	1	16.6416086	-93.7114908	t
37216	97	0679	La Esmeralda	163832.639	0934239.194	0585	E15C67	R	0	0	0	0	16.6423997	-93.7108872	t
37217	97	0680	San Antonio	163556.070	0934709.944	0607	E15C67	R	0	0	0	0	16.5989083	-93.7860956	t
37218	97	0681	Rancho Escondido	163112.400	0934840.581	0760	E15C67	R	6	0	0	1	16.5201111	-93.8112725	t
37219	97	0683	Guadalupe	163010.521	0934907.224	0707	E15C67	R	4	0	0	1	16.5029225	-93.8186733	t
37220	97	0684	El Saltillito	164205.744	0934957.158	0641	E15C67	R	6	0	0	2	16.7015956	-93.8325439	t
37221	97	0685	San Antonio (Lindavista)	164144.363	0934950.747	0625	E15C67	R	11	0	0	1	16.6956564	-93.8307631	t
37222	97	0686	Santa Fe	163735.846	0934700.316	0599	E15C67	R	7	0	0	2	16.6266239	-93.7834211	t
37223	97	0687	Salto de Agua	164736.302	0934932.275	0589	E15C57	R	15	8	7	5	16.7934172	-93.8256319	t
37224	97	0688	El Aguacate	164238.039	0935015.710	0674	E15C67	R	5	0	0	1	16.7105664	-93.8376972	t
37225	97	0690	El Caoba	164228.868	0935010.507	0676	E15C67	R	2	0	0	1	16.7080189	-93.8362519	t
37226	97	0691	El Sauz	164129.004	0934941.016	0619	E15C67	R	0	0	0	0	16.6913900	-93.8280600	t
37227	97	0692	Guachipil¡n	164110.912	0934910.366	0635	E15C67	R	2	0	0	1	16.6863644	-93.8195461	t
37228	97	0694	San Joseito	163837.995	0934945.800	0620	E15C67	R	3	0	0	1	16.6438875	-93.8293889	t
37229	97	0695	Santa Cruz	163734.718	0934652.150	0605	E15C67	R	5	0	0	1	16.6263106	-93.7811528	t
37230	97	0698	El Patio	164501.356	0935630.399	0805	E15C57	R	3	0	0	1	16.7503767	-93.9417775	t
37231	97	0701	El Zapote de Abajo (Desvio de Abelardo)	163740.657	0934648.618	0611	E15C67	R	11	0	0	1	16.6279603	-93.7801717	t
37232	97	0702	Gracias a Dios	164117.756	0934946.634	0605	E15C67	R	5	0	0	1	16.6882656	-93.8296206	t
37233	97	0703	El Naranjal	165246.212	0934734.076	0754	E15C57	R	8	0	0	2	16.8795033	-93.7927989	t
37234	97	0704	El Aguaje	165451.511	0935346.526	0680	E15C57	R	6	0	0	2	16.9143086	-93.8962572	t
37235	97	0706	El Mirador	165346.205	0934837.153	0523	E15C57	R	3	0	0	1	16.8961681	-93.8103203	t
37236	97	0707	San Luis	165428.978	0934824.795	0600	E15C57	R	0	0	0	0	16.9080494	-93.8068875	t
37237	97	0708	La Selva	165429.234	0934822.477	0593	E15C57	R	0	0	0	0	16.9081206	-93.8062436	t
37238	97	0712	El Palmar	165439.316	0934850.140	0399	E15C57	R	36	19	17	7	16.9109211	-93.8139278	t
37239	97	0713	El Ingenio	165354.778	0934851.403	0402	E15C57	R	4	0	0	1	16.8985494	-93.8142786	t
37240	97	0717	La Primavera	164123.445	0934052.034	0525	E15C67	R	5	0	0	1	16.6898458	-93.6811206	t
37241	97	0718	Rancho Verde	164154.757	0934136.105	0523	E15C67	R	0	0	0	0	16.6985436	-93.6933625	t
37242	97	0720	El Hojam n	163945.158	0934518.247	0593	E15C67	R	0	0	0	0	16.6625439	-93.7550686	t
37243	97	0721	Emanuel	163956.664	0934700.509	0561	E15C67	R	4	0	0	1	16.6657400	-93.7834747	t
37244	97	0722	Gracias a Dios	164232.448	0934331.796	0544	E15C67	R	3	0	0	1	16.7090133	-93.7254989	t
37245	97	0724	Rancho Alegre	164539.407	0934519.156	0657	E15C57	R	17	10	7	4	16.7609464	-93.7553211	t
37246	97	0725	El Tomatal	163955.046	0934704.998	0560	E15C67	R	12	7	5	3	16.6652906	-93.7847217	t
37247	97	0727	El Cuajilote	164451.525	0934549.615	0660	E15C67	R	0	0	0	0	16.7476458	-93.7637819	t
37248	97	0729	San Luis	163111.501	0940252.721	0699	E15C66	R	9	0	0	2	16.5198614	-94.0479781	t
37249	97	0731	Altamira	163058.821	0940354.556	0726	E15C66	R	1	0	0	1	16.5163392	-94.0651544	t
37250	97	0732	Los Hornos	163135.004	0940400.984	0785	E15C66	R	0	0	0	0	16.5263900	-94.0669400	t
37251	97	0734	Nancital	163336.198	0940045.120	0767	E15C66	R	29	15	14	6	16.5600550	-94.0125333	t
37252	97	0735	Los Laureles	163118.958	0940258.457	0721	E15C66	R	28	14	14	5	16.5219328	-94.0495714	t
37253	97	0736	Santa Cruz	162924.753	0940355.244	0825	E15C76	R	0	0	0	0	16.4902092	-94.0653456	t
37254	97	0737	Guadalupe	163042.526	0940152.677	0686	E15C66	R	10	0	0	2	16.5118128	-94.0312992	t
37255	97	0738	P‚njamo	163042.480	0940319.537	0714	E15C66	R	25	15	10	4	16.5118000	-94.0554269	t
37256	97	0739	Palomares	164618.825	0934031.719	0900	E15C57	R	77	36	41	19	16.7718958	-93.6754775	t
37257	97	0740	El Retiro	164528.054	0934123.644	0673	E15C57	R	19	12	7	6	16.7577928	-93.6899011	t
37258	97	0743	Copalatenco	163740.907	0934952.952	0590	E15C67	R	2	0	0	1	16.6280297	-93.8313756	t
37259	97	0746	Los Higos	164151.703	0934919.434	0642	E15C67	R	2	0	0	1	16.6976953	-93.8220650	t
37260	97	0749	San Dami n	163316.827	0935211.716	0620	E15C67	R	3	0	0	1	16.5546742	-93.8699211	t
37261	97	0751	El Suspiro	163342.940	0940110.372	0782	E15C66	R	0	0	0	0	16.5619278	-94.0195478	t
37262	97	0752	San Antonio	162626.749	0940028.991	0756	E15C76	R	2	0	0	1	16.4407636	-94.0080531	t
37263	97	0753	El Renegado (La Caba¤a)	162358.994	0935750.152	0787	E15C77	R	10	0	0	2	16.3997206	-93.9639311	t
37264	97	0755	Bellalinda	162241.585	0935635.534	0921	E15C77	R	0	0	0	0	16.3782181	-93.9432039	t
37265	97	0756	San Joaqu¡n	162259.000	0935633.206	0874	E15C77	R	6	0	0	1	16.3830556	-93.9425572	t
37266	97	0758	R¡o Grande	163214.410	0935403.117	0684	E15C67	R	5	0	0	1	16.5373361	-93.9008658	t
37267	97	0759	Cinco de Mayo	163257.808	0934938.591	0662	E15C67	R	2	0	0	1	16.5493911	-93.8273864	t
37268	97	0760	Los Aguacates	164847.292	0934856.711	0593	E15C57	R	0	0	0	0	16.8131367	-93.8157531	t
37269	97	0761	Alaska	163335.614	0935824.252	0684	E15C67	R	12	0	0	2	16.5598928	-93.9734033	t
37270	97	0762	Los µngeles	164109.228	0934132.046	0543	E15C67	R	0	0	0	0	16.6858967	-93.6922350	t
37271	97	0763	Mesitalia	163630.748	0934948.186	0620	E15C67	R	0	0	0	0	16.6085411	-93.8300517	t
37272	97	0764	Santa Rosa	163812.984	0934955.992	0620	E15C67	R	3	0	0	1	16.6369400	-93.8322200	t
37273	97	0765	Bellamira	163824.472	0934201.178	0572	E15C67	R	10	0	0	2	16.6401311	-93.7003272	t
37274	97	0767	Bonanza	162735.103	0935401.719	0782	E15C77	R	0	0	0	0	16.4597508	-93.9004775	t
37275	97	0768	Casa de Cristal	163959.818	0934444.659	0575	E15C67	R	5	0	0	1	16.6666161	-93.7457386	t
37276	97	0769	El Brasil	163419.042	0934719.919	0639	E15C67	R	4	0	0	1	16.5719561	-93.7888664	t
37277	97	0770	Las Brisas	164427.893	0934747.203	0628	E15C67	R	0	0	0	0	16.7410814	-93.7964453	t
37278	97	0771	Buenos Aires	163754.800	0934905.268	0580	E15C67	R	0	0	0	0	16.6318889	-93.8181300	t
37279	97	0772	La Caba¤a	163828.735	0934941.363	0611	E15C67	R	4	0	0	1	16.6413153	-93.8281564	t
37280	97	0773	La Calzada	163745.984	0934918.984	0578	E15C67	R	0	0	0	0	16.6294400	-93.8219400	t
37281	97	0776	Las Canoitas Segunda	162826.687	0940701.085	1044	E15C76	R	4	0	0	2	16.4740797	-94.1169681	t
37282	97	0777	La Ca¤ada (La Papaya)	163139.000	0934633.996	0705	E15C67	R	0	0	0	0	16.5275000	-93.7761100	t
37283	97	0778	El Cardel	162955.185	0935303.223	0684	E15C77	R	1	0	0	1	16.4986625	-93.8842286	t
37284	97	0779	Casa Blanca	164314.848	0934750.201	0612	E15C67	R	0	0	0	0	16.7207911	-93.7972781	t
37285	97	0781	Chicozapote	164056.283	0935301.605	0728	E15C67	R	0	0	0	0	16.6823008	-93.8837792	t
\.


--
-- Data for Name: medicamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medicamento (id_medicamento, clave_medicamento, nombre_medicamento, id_tabulador) FROM stdin;
1	20191910	ACETAMINOFEN	1
2	10101010	PARACETAMOL	1
3	30102100	NAPROXENO SODICO	1
4	40140120	AMOXILINA	1
5	12450160	PENPROCILINA 400	1
6	45678215	APICILINA	1
7	89798765	PENPROCILINA 800	1
8	54896478	ACIDO ACETILSALICILICO	1
9	78241656	ACICLOVIR	1
10	14785236	ALOPURINOL	1
11	96325874	ALPROSTADIL	1
12	85214789	AMLODIPINA	1
13	78945612	ANASTROZOL	1
14	98765432	BACLOFENO	1
15	32145698	BENAZEPRIL	1
16	58746984	BENZOTROPINA	1
17	21456398	BISACODILO	1
18	87978978	CALCITONINA	1
19	21323232	CAPSAICINA	1
20	25454654	CARTEOLOL	1
\.


--
-- Data for Name: medico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medico (id_medico, nombre_medico, apellido_paterno_medico, apellido_materno_medico, sexo, id_especialidad, status) FROM stdin;
12	JUAN ANDREW	ESPINOZA	PEREYRA	MASCULINO	14	1
13	FERNANDO	VILLEGAS	APODACA	MASCULINO	11	1
14	Jose Antonio	Lopez	Villarral	MASCULINO	7	1
\.


--
-- Data for Name: motivos_cancelacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.motivos_cancelacion (id_motivos, descripcion_motivos) FROM stdin;
3	POR INFRAESTRUCTURA (-!NO DISPONIBLE¡-)
4	MUERTE DEL PACIENTE
6	RAZONES PERSONALES DEL PACIENTE
1	SITUACION ADMINIATRATIVA
\.


--
-- Data for Name: municipios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.municipios (id_municipio, id_estado, clave, descripcion_municipio, activo) FROM stdin;
\.


--
-- Data for Name: nacionalidades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nacionalidades (id_nacionalidad, descripcion_nacionalidad, clave_nacionalidad) FROM stdin;
1	MEXICANA	MEX
\.


--
-- Data for Name: nivel_socioeconomico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nivel_socioeconomico (id_nivel, descripcion_nivel) FROM stdin;
1	NIVEL 1
2	NIVEL 2
3	NIVEL 3
4	NIVEL 4
5	NIVEL 5
6	NIVEL 6
\.


--
-- Data for Name: paciente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paciente (id_paciente, nombre_paciente, apellido_paterno, apellido_materno, edad, sexo, numero_afiliacion, fecha_nacimiento, fecha_ingreso, cp, telefono, domicilio, id_nivel, id_nacionalidad, id_estado, id_localidad, id_municipio, curp) FROM stdin;
13	GABRIEL HIPOLITO	BARRANTES	LUMBY	52	MASCULINO	33907	1966-08-13	2019-12-27	707	9621479320	COLONIA LAS HORTENSIAS	2	1	7	34338	83	SIN CURP
1	Jose	Lopez	Gomez	22	MASCULINO	1111111	1999-03-08	1981-03-08	30700	1234567	PIJIJAPAN	1	1	7	34338	83	LOGJ810308
2	Maria	Morales	Garcia	18	FEMENINO	2222222	2003-03-11	1983-03-11	38800	7654321	CALLE NARANJAS	1	1	7	34338	83	MOGM830311
3	Ana	Perez	Garcia	15	FEMENINO	3333333	2006-03-14	1981-05-07	30789	9621430974	CONOCIDO	2	1	7	34338	83	PEGA810314
\.


--
-- Data for Name: prioridad_clinica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prioridad_clinica (id_prioridad_clinica, descripcion_prioridad) FROM stdin;
1	MENOR DE 15 DIAS
2	MENOR DE 3 MESES
3	RESTO DE PACIENTES
\.


--
-- Data for Name: programadas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.programadas (id_programadas, folio, id_leq, fecha_solicitud_leq, fecha_cirugia, hora_cirugia, id_tipo_anestesia, id_institucion, id_prioridad_clinica, id_tipo_cirugia, id_paciente, id_medico, qx_proyectada, id_anestesiologo, id_quirofano, especialidad, radiologia, biopsia, toto, rxrx, hd, tipo_leq, diagnostico, valoraciones, tipo_urgencia, status) FROM stdin;
\.


--
-- Data for Name: quirofano; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quirofano (id_quirofano, descripcion_quirofano) FROM stdin;
1	QUIROFANO 1
2	QUIROFANO 2
3	QUIROFANO 3
4	QUIROFANO 4
5	QUIROFANO 5
\.


--
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rol (id_rol, descripcion_rol) FROM stdin;
1	MEDICO
2	CAPTURISTA
3	ADMINISTRADOR
\.


--
-- Data for Name: sangre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sangre (id_sangre, grupo, factor) FROM stdin;
2	A	NEGATIVO
3	B	POSITIVO
4	B	NEGATIVO
1	A	POSITIVO
5	O	POSITIVO
6	O	NEGATIVO
7	AB 	POSITIVO
8	AB	NEGATIVO
\.


--
-- Data for Name: seccion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seccion (id_seccion, seccion) FROM stdin;
1	A
2	B
3	C
4	D
\.


--
-- Data for Name: tabulador; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tabulador (id_tabulador, descripcion_tabulador) FROM stdin;
1	MEDICAMENTO
2	MATERIAL CURACION
3	PROCEDIMIENTO
\.


--
-- Data for Name: tecnica_cirugia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tecnica_cirugia (id_tecnica, descripcion_tecnica) FROM stdin;
1	CIRUGIA
2	QUIROFANO
3	PACIENTE
4	DIAGNOSTICO
\.


--
-- Data for Name: tipo_anestesia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipo_anestesia (id_tipo_anestesia, descripcion_tipo_anestesia) FROM stdin;
1	LOCAL
2	GENERAL
3	OTRAS
4	DDD
\.


--
-- Data for Name: tipo_cirugia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipo_cirugia (id_tipo_cirugia, descripcion_tipo_cirugia) FROM stdin;
1	CMA
2	Cma
3	CON HOSPITALIZACION
\.


--
-- Data for Name: urgencia_cirugia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.urgencia_cirugia (id_urgencia, descripcion_urgencia) FROM stdin;
2	PROGRAMADA
1	URGENTE
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (id_usuario, nombre_usuario, password, telefono, correo, id_medico, id_rol, status) FROM stdin;
8	Jaep	545a67a2bba8df4f815bd2692db3f96b			12	2	1
\.


--
-- Data for Name: vitrinas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vitrinas (id_vitrina, descripcion_vitrina) FROM stdin;
1	VITRINA 2 ASEPSIA Y HEMODINAMIA
4	VITRINA Y ANAQUEL ÁREA AZUL
5	VITRINA 6 CATETERISMO, CX PLÁSTICA, GINECOLOGÍA
2	VITRINA 3 ADICIONALES
\.


--
-- Name: cirugia_id_cirugia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cirugia_id_cirugia_seq', 12, true);


--
-- Name: det_instrumentos_cns_instrumento_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.det_instrumentos_cns_instrumento_seq', 51, true);


--
-- Name: det_instrumentos_leq_cns_det_instrumentos_leq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.det_instrumentos_leq_cns_det_instrumentos_leq_seq', 175, true);


--
-- Name: det_programadas_cns_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.det_programadas_cns_seq', 40, true);


--
-- Name: det_sangre_leq_cns_det_sangre_leq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.det_sangre_leq_cns_det_sangre_leq_seq', 29, true);


--
-- Name: det_update_cns_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.det_update_cns_seq', 8, true);


--
-- Name: especialidad_id_especialidad_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.especialidad_id_especialidad_seq', 14, true);


--
-- Name: institucion_procedencia_id_institucion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.institucion_procedencia_id_institucion_seq', 31, true);


--
-- Name: instrumentos_id_instrumento_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrumentos_id_instrumento_seq', 64, true);


--
-- Name: leq_id_leq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leq_id_leq_seq', 67, true);


--
-- Name: medicamento_id_medicamento_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.medicamento_id_medicamento_seq', 20, true);


--
-- Name: medico_id_medico_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.medico_id_medico_seq', 13, true);


--
-- Name: motivos_cancelacion_id_motivos_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.motivos_cancelacion_id_motivos_seq', 6, true);


--
-- Name: nivel_socioeconomico_id_nivel_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nivel_socioeconomico_id_nivel_seq', 6, true);


--
-- Name: paciente_id_paciente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.paciente_id_paciente_seq', 13, true);


--
-- Name: prioridad_clinica_id_prioridad_clinica_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prioridad_clinica_id_prioridad_clinica_seq', 3, true);


--
-- Name: programadas_id_programadas_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.programadas_id_programadas_seq', 14, true);


--
-- Name: quirofano_id_quirofano_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quirofano_id_quirofano_seq', 6, true);


--
-- Name: sangre_id_sangre_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sangre_id_sangre_seq', 8, true);


--
-- Name: sec_folio; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sec_folio', 445, true);


--
-- Name: seccion_id_seccion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seccion_id_seccion_seq', 4, true);


--
-- Name: tabulador_id_tabulador_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tabulador_id_tabulador_seq', 12, true);


--
-- Name: tecnica_cirugia_id_tecnica_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tecnica_cirugia_id_tecnica_seq', 5, true);


--
-- Name: tipo_anestesia_id_tipo_anestesia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_anestesia_id_tipo_anestesia_seq', 4, true);


--
-- Name: tipo_cirugia_id_tipo_cirugia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tipo_cirugia_id_tipo_cirugia_seq', 9, true);


--
-- Name: urgencia_cirugia_id_urgencia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.urgencia_cirugia_id_urgencia_seq', 3, true);


--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_usuario_seq', 8, true);


--
-- Name: vitrinas_id_vitrina_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vitrinas_id_vitrina_seq', 5, true);


--
-- Name: cirugia cirugia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia
    ADD CONSTRAINT cirugia_pkey PRIMARY KEY (id_cirugia);


--
-- Name: det_instrumentos_leq det_instrumentos_leq_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_instrumentos_leq
    ADD CONSTRAINT det_instrumentos_leq_pkey PRIMARY KEY (cns_det_instrumentos_leq);


--
-- Name: det_instrumentos det_instrumentos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_instrumentos
    ADD CONSTRAINT det_instrumentos_pkey PRIMARY KEY (cns_instrumento);


--
-- Name: det_programadas det_programadas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_programadas
    ADD CONSTRAINT det_programadas_pkey PRIMARY KEY (id_programadas, cns);


--
-- Name: det_sangre_leq det_sangre_leq_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_sangre_leq
    ADD CONSTRAINT det_sangre_leq_pkey PRIMARY KEY (id_leq, id_sangre);


--
-- Name: det_update det_update_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_update
    ADD CONSTRAINT det_update_pkey PRIMARY KEY (id_programadas, cns);


--
-- Name: especialidad especialidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialidad
    ADD CONSTRAINT especialidad_pkey PRIMARY KEY (id_especialidad);


--
-- Name: estados estados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estados
    ADD CONSTRAINT estados_pkey PRIMARY KEY (id_estado);


--
-- Name: institucion_procedencia institucion_procedencia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.institucion_procedencia
    ADD CONSTRAINT institucion_procedencia_pkey PRIMARY KEY (id_institucion);


--
-- Name: instrumentos instrumentos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos
    ADD CONSTRAINT instrumentos_pkey PRIMARY KEY (id_instrumento);


--
-- Name: leq leq_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leq
    ADD CONSTRAINT leq_pkey PRIMARY KEY (id_leq);


--
-- Name: localidades localidades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.localidades
    ADD CONSTRAINT localidades_pkey PRIMARY KEY (id_localidad);


--
-- Name: medicamento medicamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicamento
    ADD CONSTRAINT medicamento_pkey PRIMARY KEY (id_medicamento);


--
-- Name: medico medico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medico
    ADD CONSTRAINT medico_pkey PRIMARY KEY (id_medico);


--
-- Name: motivos_cancelacion motivos_cancelacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motivos_cancelacion
    ADD CONSTRAINT motivos_cancelacion_pkey PRIMARY KEY (id_motivos);


--
-- Name: municipios municipios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipios
    ADD CONSTRAINT municipios_pkey PRIMARY KEY (id_municipio);


--
-- Name: nacionalidades nacionalidades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nacionalidades
    ADD CONSTRAINT nacionalidades_pkey PRIMARY KEY (id_nacionalidad);


--
-- Name: nivel_socioeconomico nivel_socioeconomico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nivel_socioeconomico
    ADD CONSTRAINT nivel_socioeconomico_pkey PRIMARY KEY (id_nivel);


--
-- Name: paciente paciente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paciente
    ADD CONSTRAINT paciente_pkey PRIMARY KEY (id_paciente);


--
-- Name: prioridad_clinica prioridad_clinica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prioridad_clinica
    ADD CONSTRAINT prioridad_clinica_pkey PRIMARY KEY (id_prioridad_clinica);


--
-- Name: programadas programadas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programadas
    ADD CONSTRAINT programadas_pkey PRIMARY KEY (id_programadas);


--
-- Name: quirofano quirofano_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quirofano
    ADD CONSTRAINT quirofano_pkey PRIMARY KEY (id_quirofano);


--
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id_rol);


--
-- Name: sangre sangre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sangre
    ADD CONSTRAINT sangre_pkey PRIMARY KEY (id_sangre);


--
-- Name: seccion seccion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seccion
    ADD CONSTRAINT seccion_pkey PRIMARY KEY (id_seccion);


--
-- Name: tabulador tabulador_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tabulador
    ADD CONSTRAINT tabulador_pkey PRIMARY KEY (id_tabulador);


--
-- Name: tecnica_cirugia tecnica_cirugia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tecnica_cirugia
    ADD CONSTRAINT tecnica_cirugia_pkey PRIMARY KEY (id_tecnica);


--
-- Name: tipo_anestesia tipo_anestesia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_anestesia
    ADD CONSTRAINT tipo_anestesia_pkey PRIMARY KEY (id_tipo_anestesia);


--
-- Name: tipo_cirugia tipo_cirugia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_cirugia
    ADD CONSTRAINT tipo_cirugia_pkey PRIMARY KEY (id_tipo_cirugia);


--
-- Name: urgencia_cirugia urgencia_cirugia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.urgencia_cirugia
    ADD CONSTRAINT urgencia_cirugia_pkey PRIMARY KEY (id_urgencia);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);


--
-- Name: vitrinas vitrinas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vitrinas
    ADD CONSTRAINT vitrinas_pkey PRIMARY KEY (id_vitrina);


--
-- Name: cirugia cirugia_id_especialidad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia
    ADD CONSTRAINT cirugia_id_especialidad_fkey FOREIGN KEY (id_especialidad) REFERENCES public.especialidad(id_especialidad);


--
-- Name: cirugia cirugia_id_tecnica_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cirugia
    ADD CONSTRAINT cirugia_id_tecnica_fkey FOREIGN KEY (id_tecnica) REFERENCES public.tecnica_cirugia(id_tecnica);


--
-- Name: det_instrumentos det_instrumentos_id_instrumento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_instrumentos
    ADD CONSTRAINT det_instrumentos_id_instrumento_fkey FOREIGN KEY (id_instrumento) REFERENCES public.instrumentos(id_instrumento);


--
-- Name: det_instrumentos_leq det_instrumentos_leq_cns_instrumento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_instrumentos_leq
    ADD CONSTRAINT det_instrumentos_leq_cns_instrumento_fkey FOREIGN KEY (cns_instrumento) REFERENCES public.det_instrumentos(cns_instrumento);


--
-- Name: det_instrumentos_leq det_instrumentos_leq_id_leq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_instrumentos_leq
    ADD CONSTRAINT det_instrumentos_leq_id_leq_fkey FOREIGN KEY (id_leq) REFERENCES public.leq(id_leq);


--
-- Name: det_sangre_leq det_sangre_leq_id_leq_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_sangre_leq
    ADD CONSTRAINT det_sangre_leq_id_leq_fkey FOREIGN KEY (id_leq) REFERENCES public.leq(id_leq);


--
-- Name: det_sangre_leq det_sangre_leq_id_sangre_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_sangre_leq
    ADD CONSTRAINT det_sangre_leq_id_sangre_fkey FOREIGN KEY (id_sangre) REFERENCES public.sangre(id_sangre);


--
-- Name: det_update det_update_id_programadas_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_update
    ADD CONSTRAINT det_update_id_programadas_fkey FOREIGN KEY (id_programadas) REFERENCES public.programadas(id_programadas);


--
-- Name: especialidad especialidad_id_quirofano_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialidad
    ADD CONSTRAINT especialidad_id_quirofano_fkey FOREIGN KEY (id_quirofano) REFERENCES public.quirofano(id_quirofano);


--
-- Name: estados estados_id_nacionalidades_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estados
    ADD CONSTRAINT estados_id_nacionalidades_fkey FOREIGN KEY (id_nacionalidades) REFERENCES public.nacionalidades(id_nacionalidad);


--
-- Name: instrumentos instrumentos_id_seccion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos
    ADD CONSTRAINT instrumentos_id_seccion_fkey FOREIGN KEY (id_seccion) REFERENCES public.seccion(id_seccion);


--
-- Name: instrumentos instrumentos_id_vitrina_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumentos
    ADD CONSTRAINT instrumentos_id_vitrina_fkey FOREIGN KEY (id_vitrina) REFERENCES public.vitrinas(id_vitrina);


--
-- Name: leq leq_id_anestesiologo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leq
    ADD CONSTRAINT leq_id_anestesiologo_fkey FOREIGN KEY (id_anestesiologo) REFERENCES public.medico(id_medico);


--
-- Name: leq leq_id_cirugia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leq
    ADD CONSTRAINT leq_id_cirugia_fkey FOREIGN KEY (id_cirugia) REFERENCES public.cirugia(id_cirugia);


--
-- Name: leq leq_id_institucion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leq
    ADD CONSTRAINT leq_id_institucion_fkey FOREIGN KEY (id_institucion) REFERENCES public.institucion_procedencia(id_institucion);


--
-- Name: leq leq_id_medico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leq
    ADD CONSTRAINT leq_id_medico_fkey FOREIGN KEY (id_medico) REFERENCES public.medico(id_medico);


--
-- Name: leq leq_id_paciente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leq
    ADD CONSTRAINT leq_id_paciente_fkey FOREIGN KEY (id_paciente) REFERENCES public.paciente(id_paciente);


--
-- Name: leq leq_id_prioridad_clinica_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leq
    ADD CONSTRAINT leq_id_prioridad_clinica_fkey FOREIGN KEY (id_prioridad_clinica) REFERENCES public.prioridad_clinica(id_prioridad_clinica);


--
-- Name: leq leq_id_quirofano_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leq
    ADD CONSTRAINT leq_id_quirofano_fkey FOREIGN KEY (id_quirofano) REFERENCES public.quirofano(id_quirofano);


--
-- Name: leq leq_id_tipo_anestesia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leq
    ADD CONSTRAINT leq_id_tipo_anestesia_fkey FOREIGN KEY (id_tipo_anestesia) REFERENCES public.tipo_anestesia(id_tipo_anestesia);


--
-- Name: leq leq_id_tipo_cirugia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leq
    ADD CONSTRAINT leq_id_tipo_cirugia_fkey FOREIGN KEY (id_tipo_cirugia) REFERENCES public.tipo_cirugia(id_tipo_cirugia);


--
-- Name: medicamento medicamento_id_tabulador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicamento
    ADD CONSTRAINT medicamento_id_tabulador_fkey FOREIGN KEY (id_tabulador) REFERENCES public.tabulador(id_tabulador);


--
-- Name: medico medico_id_especialidad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medico
    ADD CONSTRAINT medico_id_especialidad_fkey FOREIGN KEY (id_especialidad) REFERENCES public.especialidad(id_especialidad);


--
-- Name: municipios municipios_id_estado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipios
    ADD CONSTRAINT municipios_id_estado_fkey FOREIGN KEY (id_estado) REFERENCES public.estados(id_estado);


--
-- Name: paciente paciente_id_estado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paciente
    ADD CONSTRAINT paciente_id_estado_fkey FOREIGN KEY (id_estado) REFERENCES public.estados(id_estado);


--
-- Name: paciente paciente_id_localidad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paciente
    ADD CONSTRAINT paciente_id_localidad_fkey FOREIGN KEY (id_localidad) REFERENCES public.localidades(id_localidad);


--
-- Name: paciente paciente_id_nacionalidad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paciente
    ADD CONSTRAINT paciente_id_nacionalidad_fkey FOREIGN KEY (id_nacionalidad) REFERENCES public.nacionalidades(id_nacionalidad);


--
-- Name: paciente paciente_id_nivel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paciente
    ADD CONSTRAINT paciente_id_nivel_fkey FOREIGN KEY (id_nivel) REFERENCES public.nivel_socioeconomico(id_nivel);


--
-- Name: programadas programadas_especialidad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programadas
    ADD CONSTRAINT programadas_especialidad_fkey FOREIGN KEY (especialidad) REFERENCES public.especialidad(id_especialidad);


--
-- Name: programadas programadas_id_anestesiologo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programadas
    ADD CONSTRAINT programadas_id_anestesiologo_fkey FOREIGN KEY (id_anestesiologo) REFERENCES public.medico(id_medico);


--
-- Name: programadas programadas_id_institucion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programadas
    ADD CONSTRAINT programadas_id_institucion_fkey FOREIGN KEY (id_institucion) REFERENCES public.institucion_procedencia(id_institucion);


--
-- Name: programadas programadas_id_medico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programadas
    ADD CONSTRAINT programadas_id_medico_fkey FOREIGN KEY (id_medico) REFERENCES public.medico(id_medico);


--
-- Name: programadas programadas_id_paciente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programadas
    ADD CONSTRAINT programadas_id_paciente_fkey FOREIGN KEY (id_paciente) REFERENCES public.paciente(id_paciente);


--
-- Name: programadas programadas_id_prioridad_clinica_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programadas
    ADD CONSTRAINT programadas_id_prioridad_clinica_fkey FOREIGN KEY (id_prioridad_clinica) REFERENCES public.prioridad_clinica(id_prioridad_clinica);


--
-- Name: programadas programadas_id_quirofano_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programadas
    ADD CONSTRAINT programadas_id_quirofano_fkey FOREIGN KEY (id_quirofano) REFERENCES public.quirofano(id_quirofano);


--
-- Name: programadas programadas_id_tipo_anestesia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programadas
    ADD CONSTRAINT programadas_id_tipo_anestesia_fkey FOREIGN KEY (id_tipo_anestesia) REFERENCES public.tipo_anestesia(id_tipo_anestesia);


--
-- Name: programadas programadas_id_tipo_cirugia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programadas
    ADD CONSTRAINT programadas_id_tipo_cirugia_fkey FOREIGN KEY (id_tipo_cirugia) REFERENCES public.tipo_cirugia(id_tipo_cirugia);


--
-- Name: programadas programadas_qx_proyectada_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programadas
    ADD CONSTRAINT programadas_qx_proyectada_fkey FOREIGN KEY (qx_proyectada) REFERENCES public.cirugia(id_cirugia);


--
-- Name: programadas programadas_tipo_urgencia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programadas
    ADD CONSTRAINT programadas_tipo_urgencia_fkey FOREIGN KEY (tipo_urgencia) REFERENCES public.urgencia_cirugia(id_urgencia);


--
-- Name: programadas programadas_valoraciones_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programadas
    ADD CONSTRAINT programadas_valoraciones_fkey FOREIGN KEY (valoraciones) REFERENCES public.medico(id_medico);


--
-- Name: usuario usuario_id_medico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_id_medico_fkey FOREIGN KEY (id_medico) REFERENCES public.medico(id_medico);


--
-- Name: usuario usuario_id_rol_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES public.rol(id_rol);


--
-- PostgreSQL database dump complete
--

