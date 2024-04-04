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
-- Name: conectar(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.conectar() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE 
recBit record;
bdBit cursor for SELECT nombre, afiliacion, curp from 
dblink('dbname=bitacora port=5432 host=localhost user=postgres password=crypto',
    'select nompac, noafiliacion, curp from pacientes') AS px(nombre text, afiliacion text, curp text);
BEGIN
raise notice 'BDS BITACORA';
     for recBit in bdBit loop
    raise notice '% | % | %',recBit.nombre, recBit.afiliacion, recBit.curp; 
     end loop;
END; 
 $$;


ALTER FUNCTION public.conectar() OWNER TO postgres;

--
-- Name: curpfind(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.curpfind(curpvar character varying) RETURNS TABLE(id integer, p_curp character varying, p_nombre character varying, p_fecha_cirugia date)
    LANGUAGE plpgsql
    AS $$
DECLARE 
    recBit record;
BEGIN
    RETURN QUERY 
    SELECT id_paciente, curp, nombre_paciente, fecha_cirugia
    FROM 
        dblink ('lab_dbconn_prog', 'SELECT pa.id_paciente, pa.curp, pa.nombre_paciente, l.fecha_cirugia from paciente pa INNER JOIN leq l ON l.id_paciente = pa.id_paciente') 
        AS querylabprog(id_paciente INT, curp VARCHAR, nombre_paciente VARCHAR, fecha_cirugia DATE)
    WHERE curp = curpvar;
END; 
$$;


ALTER FUNCTION public.curpfind(curpvar character varying) OWNER TO postgres;

--
-- Name: findmunicipio(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.findmunicipio(mun character varying) RETURNS TABLE(id_paciente integer, nombre_paciente character varying, apellido_paterno character varying, apellido_materno character varying, fecha_cirugia date, idhospitalizado integer, fechahoraingreso timestamp without time zone, municipio character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE NOTICE 'ID_Pac| Nombre| Ape_pat | Ape_mat | fecha_cirugia | id_hosp | fecha_ingreso | municipio';
    
    RETURN QUERY 
    SELECT 
        labpro.id_paciente, 
        labpro.nombre_paciente, 
        labpro.apellido_paterno, 
        labpro.apellido_materno, 
        labpro.fecha_cirugia, 
        labbit.idhospitalizado, 
        labbit.fechahoraingreso, 
        labbit.municipio
    FROM 
        dblink ('lab_dbconn_prog', 'SELECT p.id_paciente, nombre_paciente, apellido_paterno, apellido_materno, l.id_leq, l.fecha_cirugia FROM paciente p INNER JOIN leq l ON p.id_paciente = l.id_paciente;') 
        AS labpro(id_paciente INT, nombre_paciente VARCHAR, apellido_paterno VARCHAR, apellido_materno VARCHAR, id_leq INT, fecha_cirugia DATE)
    INNER JOIN 
        dblink ('lab_dbconn_bit', 'SELECT p.nopaciente, p.nompac, p.apppac, p.apmpac, h.idhospitalizado, h.fechahoraingreso, m.nombre AS municipio FROM pacientes p INNER JOIN hospitalizado h ON p.nopaciente = h.idpac INNER JOIN catmunicipios m ON p.id_municipio = m.id_municipio') 
        AS labbit(nopaciente INT, nompac VARCHAR, apppac VARCHAR, apmpac VARCHAR, idhospitalizado INT, fechahoraingreso TIMESTAMP, municipio VARCHAR)
        ON labbit.nopaciente = labpro.id_paciente
    WHERE labbit.municipio = mun;
END;
$$;


ALTER FUNCTION public.findmunicipio(mun character varying) OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: analisis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.analisis (
    id_analisis integer NOT NULL,
    nombre text,
    precio double precision,
    tiempo_realiza time without time zone,
    activo boolean DEFAULT true
);


ALTER TABLE public.analisis OWNER TO postgres;

--
-- Name: analisis_atributos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.analisis_atributos (
    id_analisis integer NOT NULL,
    consecutivo integer NOT NULL,
    num_atributo integer
);


ALTER TABLE public.analisis_atributos OWNER TO postgres;

--
-- Name: analisis_id_analisis_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.analisis_id_analisis_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analisis_id_analisis_seq OWNER TO postgres;

--
-- Name: analisis_id_analisis_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.analisis_id_analisis_seq OWNED BY public.analisis.id_analisis;


--
-- Name: analisis_materiales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.analisis_materiales (
    id_analisis integer NOT NULL,
    consecutivo integer NOT NULL,
    codigo_barra integer
);


ALTER TABLE public.analisis_materiales OWNER TO postgres;

--
-- Name: atributo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.atributo (
    num_atributo integer NOT NULL,
    nombre text,
    maximo double precision,
    minimo double precision,
    unidad_medida integer
);


ALTER TABLE public.atributo OWNER TO postgres;

--
-- Name: atributo_num_atributo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.atributo_num_atributo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.atributo_num_atributo_seq OWNER TO postgres;

--
-- Name: atributo_num_atributo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.atributo_num_atributo_seq OWNED BY public.atributo.num_atributo;


--
-- Name: atributo_reactivo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.atributo_reactivo (
    num_atributo integer NOT NULL,
    consecutivo integer NOT NULL,
    codigo_barra integer,
    cantidad_uso double precision,
    unidad_medida integer
);


ALTER TABLE public.atributo_reactivo OWNER TO postgres;

--
-- Name: laboratorista; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.laboratorista (
    cedula integer NOT NULL,
    nombre text,
    edad integer,
    sexo text,
    salario double precision,
    fecha_contratacion date DEFAULT CURRENT_DATE,
    status boolean DEFAULT true
);


ALTER TABLE public.laboratorista OWNER TO postgres;

--
-- Name: material; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.material (
    codigo_barra integer NOT NULL,
    nombre text,
    stock_minimo integer,
    stock_maximo integer,
    stock_actual integer
);


ALTER TABLE public.material OWNER TO postgres;

--
-- Name: orden_de_servicio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orden_de_servicio (
    folio integer NOT NULL,
    id_analisis integer,
    cedula integer,
    folio_paciente integer,
    fecha date DEFAULT CURRENT_DATE,
    estado text DEFAULT 'REGISTRADO'::text
);


ALTER TABLE public.orden_de_servicio OWNER TO postgres;

--
-- Name: orden_de_servicio_folio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orden_de_servicio_folio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orden_de_servicio_folio_seq OWNER TO postgres;

--
-- Name: orden_de_servicio_folio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orden_de_servicio_folio_seq OWNED BY public.orden_de_servicio.folio;


--
-- Name: paciente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paciente (
    folio_paciente integer NOT NULL,
    nombre text,
    edad integer,
    sexo text,
    fecha_registro date DEFAULT CURRENT_DATE,
    email text,
    status boolean DEFAULT true,
    curp text
);


ALTER TABLE public.paciente OWNER TO postgres;

--
-- Name: paciente_folio_paciente_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.paciente_folio_paciente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.paciente_folio_paciente_seq OWNER TO postgres;

--
-- Name: paciente_folio_paciente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.paciente_folio_paciente_seq OWNED BY public.paciente.folio_paciente;


--
-- Name: reactivo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reactivo (
    codigo_barra integer NOT NULL,
    nombre text,
    stock_minimo integer,
    stock_maximo integer,
    stock_actual integer,
    unidad_medida integer
);


ALTER TABLE public.reactivo OWNER TO postgres;

--
-- Name: resultado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resultado (
    folio integer NOT NULL,
    resultado integer NOT NULL,
    id_analisis integer NOT NULL,
    consecutivo integer NOT NULL,
    valor double precision
);


ALTER TABLE public.resultado OWNER TO postgres;

--
-- Name: unidad_medida; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unidad_medida (
    id_unidad integer NOT NULL,
    nombre text
);


ALTER TABLE public.unidad_medida OWNER TO postgres;

--
-- Name: unidad_medida_atributo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unidad_medida_atributo (
    id_unidad integer NOT NULL,
    nombre text
);


ALTER TABLE public.unidad_medida_atributo OWNER TO postgres;

--
-- Name: unidad_medida_atributo_id_unidad_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unidad_medida_atributo_id_unidad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unidad_medida_atributo_id_unidad_seq OWNER TO postgres;

--
-- Name: unidad_medida_atributo_id_unidad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unidad_medida_atributo_id_unidad_seq OWNED BY public.unidad_medida_atributo.id_unidad;


--
-- Name: unidad_medida_id_unidad_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unidad_medida_id_unidad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unidad_medida_id_unidad_seq OWNER TO postgres;

--
-- Name: unidad_medida_id_unidad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unidad_medida_id_unidad_seq OWNED BY public.unidad_medida.id_unidad;


--
-- Name: v_all_laboratorista; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_all_laboratorista AS
 SELECT laboratorista.cedula,
    laboratorista.nombre,
    laboratorista.edad,
    laboratorista.sexo,
    laboratorista.salario,
    laboratorista.fecha_contratacion,
    laboratorista.status
   FROM public.laboratorista;


ALTER TABLE public.v_all_laboratorista OWNER TO postgres;

--
-- Name: v_all_paciente; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_all_paciente AS
 SELECT paciente.folio_paciente,
    paciente.nombre,
    paciente.edad,
    paciente.sexo,
    paciente.fecha_registro,
    paciente.email,
    paciente.status
   FROM public.paciente;


ALTER TABLE public.v_all_paciente OWNER TO postgres;

--
-- Name: analisis id_analisis; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analisis ALTER COLUMN id_analisis SET DEFAULT nextval('public.analisis_id_analisis_seq'::regclass);


--
-- Name: atributo num_atributo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atributo ALTER COLUMN num_atributo SET DEFAULT nextval('public.atributo_num_atributo_seq'::regclass);


--
-- Name: orden_de_servicio folio; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_de_servicio ALTER COLUMN folio SET DEFAULT nextval('public.orden_de_servicio_folio_seq'::regclass);


--
-- Name: paciente folio_paciente; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paciente ALTER COLUMN folio_paciente SET DEFAULT nextval('public.paciente_folio_paciente_seq'::regclass);


--
-- Name: unidad_medida id_unidad; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_medida ALTER COLUMN id_unidad SET DEFAULT nextval('public.unidad_medida_id_unidad_seq'::regclass);


--
-- Name: unidad_medida_atributo id_unidad; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_medida_atributo ALTER COLUMN id_unidad SET DEFAULT nextval('public.unidad_medida_atributo_id_unidad_seq'::regclass);


--
-- Data for Name: analisis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.analisis (id_analisis, nombre, precio, tiempo_realiza, activo) FROM stdin;
1	BHC	100	02:00:00	t
2	EGO	50	04:00:00	t
3	Examen coproparasitoscopico	150	08:00:00	t
4	Perfil Renal	500	08:00:00	t
5	Perfil Lipidico	800	12:00:00	t
\.


--
-- Data for Name: analisis_atributos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.analisis_atributos (id_analisis, consecutivo, num_atributo) FROM stdin;
\.


--
-- Data for Name: analisis_materiales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.analisis_materiales (id_analisis, consecutivo, codigo_barra) FROM stdin;
\.


--
-- Data for Name: atributo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.atributo (num_atributo, nombre, maximo, minimo, unidad_medida) FROM stdin;
\.


--
-- Data for Name: atributo_reactivo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.atributo_reactivo (num_atributo, consecutivo, codigo_barra, cantidad_uso, unidad_medida) FROM stdin;
\.


--
-- Data for Name: laboratorista; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.laboratorista (cedula, nombre, edad, sexo, salario, fecha_contratacion, status) FROM stdin;
\.


--
-- Data for Name: material; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.material (codigo_barra, nombre, stock_minimo, stock_maximo, stock_actual) FROM stdin;
\.


--
-- Data for Name: orden_de_servicio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orden_de_servicio (folio, id_analisis, cedula, folio_paciente, fecha, estado) FROM stdin;
2	1	122	1	2021-03-17	REGISTRADO
3	5	122	1	2021-03-17	REGISTRADO
4	1	122	2	2021-03-17	REGISTRADO
6	4	122	2	2021-03-17	REGISTRADO
8	1	122	3	2021-03-17	REGISTRADO
5	3	122	2	2021-03-17	PENDIENTE
7	3	122	3	2021-03-17	PENDIENTE
\.


--
-- Data for Name: paciente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.paciente (folio_paciente, nombre, edad, sexo, fecha_registro, email, status, curp) FROM stdin;
4	Pedro Ruiz	31	Masculino	2021-03-17	pedro@gmail.com	t	\N
5	Juan Landeta	57	Masculino	2021-03-17	juan@gmail.com	t	\N
1	Jose Lopez	22	Masculino	2021-03-17	jose@gmail.com	t	LOGJ810308
2	Maria Morales	18	Femenino	2021-03-17	maria@gmail.com	t	MOGM830311
3	Ana Perez	15	Femenino	2021-03-17	ana@gmail.com	t	PEGA810314
7	Cristian Valdez Castro	52	Masculino	2023-03-25	cristianvc@gmail.com	t	VACC701208
\.


--
-- Data for Name: reactivo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reactivo (codigo_barra, nombre, stock_minimo, stock_maximo, stock_actual, unidad_medida) FROM stdin;
\.


--
-- Data for Name: resultado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resultado (folio, resultado, id_analisis, consecutivo, valor) FROM stdin;
\.


--
-- Data for Name: unidad_medida; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unidad_medida (id_unidad, nombre) FROM stdin;
1	LITRO
2	MILILITRO
3	KILO
4	MILIGRAMO
5	GRAMO
6	GALON
7	UNIDAD
8	PAQUETE
9	LITRO
10	MILILITRO
11	KILO
12	MILIGRAMO
13	GRAMO
14	GALON
15	UNIDAD
16	PAQUETE
\.


--
-- Data for Name: unidad_medida_atributo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unidad_medida_atributo (id_unidad, nombre) FROM stdin;
1	Mg/dL
2	Mg/L
3	gr/L
4	Mg/dL
5	Mg/L
6	gr/L
\.


--
-- Name: analisis_id_analisis_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.analisis_id_analisis_seq', 5, true);


--
-- Name: atributo_num_atributo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.atributo_num_atributo_seq', 1, false);


--
-- Name: orden_de_servicio_folio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orden_de_servicio_folio_seq', 8, true);


--
-- Name: paciente_folio_paciente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.paciente_folio_paciente_seq', 7, true);


--
-- Name: unidad_medida_atributo_id_unidad_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unidad_medida_atributo_id_unidad_seq', 6, true);


--
-- Name: unidad_medida_id_unidad_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unidad_medida_id_unidad_seq', 16, true);


--
-- Name: analisis_atributos analisis_atributos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analisis_atributos
    ADD CONSTRAINT analisis_atributos_pkey PRIMARY KEY (id_analisis, consecutivo);


--
-- Name: analisis_materiales analisis_materiales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analisis_materiales
    ADD CONSTRAINT analisis_materiales_pkey PRIMARY KEY (id_analisis, consecutivo);


--
-- Name: analisis analisis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analisis
    ADD CONSTRAINT analisis_pkey PRIMARY KEY (id_analisis);


--
-- Name: atributo atributo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atributo
    ADD CONSTRAINT atributo_pkey PRIMARY KEY (num_atributo);


--
-- Name: atributo_reactivo atributo_reactivo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atributo_reactivo
    ADD CONSTRAINT atributo_reactivo_pkey PRIMARY KEY (num_atributo, consecutivo);


--
-- Name: laboratorista laboratorista_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laboratorista
    ADD CONSTRAINT laboratorista_pkey PRIMARY KEY (cedula);


--
-- Name: material material_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_pkey PRIMARY KEY (codigo_barra);


--
-- Name: orden_de_servicio orden_de_servicio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_de_servicio
    ADD CONSTRAINT orden_de_servicio_pkey PRIMARY KEY (folio);


--
-- Name: paciente paciente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paciente
    ADD CONSTRAINT paciente_pkey PRIMARY KEY (folio_paciente);


--
-- Name: reactivo reactivo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reactivo
    ADD CONSTRAINT reactivo_pkey PRIMARY KEY (codigo_barra);


--
-- Name: resultado resultado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultado
    ADD CONSTRAINT resultado_pkey PRIMARY KEY (folio, resultado, id_analisis, consecutivo);


--
-- Name: unidad_medida_atributo unidad_medida_atributo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_medida_atributo
    ADD CONSTRAINT unidad_medida_atributo_pkey PRIMARY KEY (id_unidad);


--
-- Name: unidad_medida unidad_medida_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_medida
    ADD CONSTRAINT unidad_medida_pkey PRIMARY KEY (id_unidad);


--
-- Name: analisis_atributos analisis_atributos_id_analisis_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analisis_atributos
    ADD CONSTRAINT analisis_atributos_id_analisis_fkey FOREIGN KEY (id_analisis) REFERENCES public.analisis(id_analisis);


--
-- Name: analisis_atributos analisis_atributos_num_atributo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analisis_atributos
    ADD CONSTRAINT analisis_atributos_num_atributo_fkey FOREIGN KEY (num_atributo) REFERENCES public.atributo(num_atributo);


--
-- Name: analisis_materiales analisis_materiales_codigo_barra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analisis_materiales
    ADD CONSTRAINT analisis_materiales_codigo_barra_fkey FOREIGN KEY (codigo_barra) REFERENCES public.material(codigo_barra);


--
-- Name: analisis_materiales analisis_materiales_id_analisis_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analisis_materiales
    ADD CONSTRAINT analisis_materiales_id_analisis_fkey FOREIGN KEY (id_analisis) REFERENCES public.analisis(id_analisis);


--
-- Name: atributo_reactivo atributo_reactivo_codigo_barra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atributo_reactivo
    ADD CONSTRAINT atributo_reactivo_codigo_barra_fkey FOREIGN KEY (codigo_barra) REFERENCES public.reactivo(codigo_barra);


--
-- Name: atributo_reactivo atributo_reactivo_num_atributo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atributo_reactivo
    ADD CONSTRAINT atributo_reactivo_num_atributo_fkey FOREIGN KEY (num_atributo) REFERENCES public.atributo(num_atributo);


--
-- Name: atributo_reactivo atributo_reactivo_unidad_medida_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atributo_reactivo
    ADD CONSTRAINT atributo_reactivo_unidad_medida_fkey FOREIGN KEY (unidad_medida) REFERENCES public.unidad_medida(id_unidad);


--
-- Name: atributo atributo_unidad_medida_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atributo
    ADD CONSTRAINT atributo_unidad_medida_fkey FOREIGN KEY (unidad_medida) REFERENCES public.unidad_medida_atributo(id_unidad);


--
-- Name: orden_de_servicio orden_de_servicio_folio_paciente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_de_servicio
    ADD CONSTRAINT orden_de_servicio_folio_paciente_fkey FOREIGN KEY (folio_paciente) REFERENCES public.paciente(folio_paciente);


--
-- Name: orden_de_servicio orden_de_servicio_id_analisis_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_de_servicio
    ADD CONSTRAINT orden_de_servicio_id_analisis_fkey FOREIGN KEY (id_analisis) REFERENCES public.analisis(id_analisis);


--
-- Name: reactivo reactivo_unidad_medida_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reactivo
    ADD CONSTRAINT reactivo_unidad_medida_fkey FOREIGN KEY (unidad_medida) REFERENCES public.unidad_medida(id_unidad);


--
-- Name: resultado resultado_id_analisis_consecutivo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultado
    ADD CONSTRAINT resultado_id_analisis_consecutivo_fkey FOREIGN KEY (id_analisis, consecutivo) REFERENCES public.analisis_atributos(id_analisis, consecutivo);


--
-- PostgreSQL database dump complete
--

