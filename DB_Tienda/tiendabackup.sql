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
-- Name: act_precvnta(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.act_precvnta() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
 --Almacena cada fila
 consulta record;
BEGIN
    -- Recorrer todas las categorías
    for consulta IN SELECT * FROM det_cat
    loop
     --El precio de la compra por la ganancia deseada (1 representa el 100% del valor original)
        update articulos set pre_vnta = pre_comp * (1 + consulta.porc_ganancia) where tipo = consulta.nomb_catg;
    end loop;
END;
$$;


ALTER FUNCTION public.act_precvnta() OWNER TO postgres;

--
-- Name: preciorefresco(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.preciorefresco() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
 consulta record;
 preciov numeric(7,2);
BEGIN
 for consulta in select *from articulos where tipo='refresco'
 loop
  preciov:=consulta.pre_comp*(100.00/(100.00-30.00));
  update articulos set pre_vnta=preciov where item_id=consulta.item_id;
 end loop;
END;
$$;


ALTER FUNCTION public.preciorefresco() OWNER TO postgres;

--
-- Name: precioventa(numeric, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.precioventa(numeric, character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
 consulta record;
 preciov numeric(7,2);
BEGIN
 for consulta in select *from articulos where tipo=$2
 loop
  preciov:=consulta.pre_comp*(100.00/(100.00-30.00));
  update articulos set pre_vnta=preciov where item_id=consulta.item_id;
 end loop;
END;
$_$;


ALTER FUNCTION public.precioventa(numeric, character varying) OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: articulos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.articulos (
    item_id integer NOT NULL,
    nom_art character varying(30) NOT NULL,
    tipo character varying(30) NOT NULL,
    stock integer NOT NULL,
    pre_comp numeric(7,2) NOT NULL,
    pre_vnta numeric(7,2)
);


ALTER TABLE public.articulos OWNER TO postgres;

--
-- Name: articulos_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.articulos_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.articulos_item_id_seq OWNER TO postgres;

--
-- Name: articulos_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.articulos_item_id_seq OWNED BY public.articulos.item_id;


--
-- Name: det_cat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.det_cat (
    id_catg integer NOT NULL,
    nomb_catg character varying(30) NOT NULL,
    porc_ganancia numeric(5,2) NOT NULL
);


ALTER TABLE public.det_cat OWNER TO postgres;

--
-- Name: det_cat_id_catg_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.det_cat_id_catg_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.det_cat_id_catg_seq OWNER TO postgres;

--
-- Name: det_cat_id_catg_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.det_cat_id_catg_seq OWNED BY public.det_cat.id_catg;


--
-- Name: articulos item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articulos ALTER COLUMN item_id SET DEFAULT nextval('public.articulos_item_id_seq'::regclass);


--
-- Name: det_cat id_catg; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_cat ALTER COLUMN id_catg SET DEFAULT nextval('public.det_cat_id_catg_seq'::regclass);


--
-- Data for Name: articulos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.articulos (item_id, nom_art, tipo, stock, pre_comp, pre_vnta) FROM stdin;
1	bebidaX 600ml	refresco	10	12.50	16.25
2	bebidaY 1lt	refresco	15	20.00	26.00
3	bebidaZ 3lt	refresco	20	25.00	32.50
4	Roles	pan	5	28.00	42.00
5	Conchas	pan	10	14.00	21.00
6	Mantecadas	pan	15	18.50	27.75
7	cigarroX	cigarros	3	80.00	104.00
8	cigarroY	cigarros	6	70.00	91.00
9	cigarroZ	cigarros	9	65.00	84.50
10	dulceX	dulces	4	5.50	8.25
11	dulceY	dulces	8	7.50	11.25
12	dulceZ	dulces	12	10.00	15.00
13	galletaX	galletas	2	13.50	16.20
14	galletaY	galletas	4	16.00	19.20
15	galletaZ	galletas	6	10.50	12.60
\.


--
-- Data for Name: det_cat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.det_cat (id_catg, nomb_catg, porc_ganancia) FROM stdin;
1	refresco	0.30
2	refresco	0.30
4	pan	0.50
5	cigarros	0.30
6	dulces	0.50
3	galletas	0.20
\.


--
-- Name: articulos_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.articulos_item_id_seq', 15, true);


--
-- Name: det_cat_id_catg_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.det_cat_id_catg_seq', 6, true);


--
-- Name: articulos articulos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articulos
    ADD CONSTRAINT articulos_pkey PRIMARY KEY (item_id);


--
-- Name: det_cat det_cat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.det_cat
    ADD CONSTRAINT det_cat_pkey PRIMARY KEY (id_catg);


--
-- PostgreSQL database dump complete
--

