--
-- PostgreSQL database dump
--

-- Dumped from database version 10.14 (Ubuntu 10.14-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 12.9 (Ubuntu 12.9-0ubuntu0.20.04.1)

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

SET default_tablespace = '';

--
-- Name: companias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.companias (
    id_comp integer NOT NULL,
    act_comp character varying(20)
);


ALTER TABLE public.companias OWNER TO postgres;

--
-- Name: cuarteles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cuarteles (
    cod_crtl integer NOT NULL,
    id_comp_fk integer NOT NULL,
    nom_crtl character varying(15) NOT NULL,
    ubi_crtl character varying(20) DEFAULT 'No_asignado'::character varying
);


ALTER TABLE public.cuarteles OWNER TO postgres;

--
-- Name: cuarteles_id_comp_fk_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cuarteles_id_comp_fk_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cuarteles_id_comp_fk_seq OWNER TO postgres;

--
-- Name: cuarteles_id_comp_fk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cuarteles_id_comp_fk_seq OWNED BY public.cuarteles.id_comp_fk;


--
-- Name: cuerpos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cuerpos (
    id_crpo integer NOT NULL,
    deno_crpo character varying(15)
);


ALTER TABLE public.cuerpos OWNER TO postgres;

--
-- Name: serv_realz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serv_realz (
    id_serv_fk integer,
    id_sol_fk integer,
    fecha_realn date NOT NULL
);


ALTER TABLE public.serv_realz OWNER TO postgres;

--
-- Name: servicios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.servicios (
    id_serv integer NOT NULL,
    actividad character varying(15) NOT NULL
);


ALTER TABLE public.servicios OWNER TO postgres;

--
-- Name: soldados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.soldados (
    id_sol integer NOT NULL,
    nombre_sol character varying(30) NOT NULL,
    ape_sol character varying(30) NOT NULL,
    grado_sol character varying(15) DEFAULT 'Sin_asignar'::character varying,
    id_crpo_fk integer,
    cod_crtl_fk integer,
    id_comp_fk integer
);


ALTER TABLE public.soldados OWNER TO postgres;

--
-- Name: cuarteles id_comp_fk; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuarteles ALTER COLUMN id_comp_fk SET DEFAULT nextval('public.cuarteles_id_comp_fk_seq'::regclass);


--
-- Data for Name: companias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.companias (id_comp, act_comp) FROM stdin;
11	Comp_Reconocimiento
22	Comp_Transporte
33	Comp_Inteligencia
44	Comp_Ope_Especiales
55	Comp_Ingenieria
\.


--
-- Data for Name: cuarteles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cuarteles (cod_crtl, id_comp_fk, nom_crtl, ubi_crtl) FROM stdin;
1	11	Crtl_sur	zonasur
2	22	Crtl_norte	zona_norte
3	33	Crtl_este	zona_este
4	44	Crtl_oeste	zona_oeste
\.


--
-- Data for Name: cuerpos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cuerpos (id_crpo, deno_crpo) FROM stdin;
10	Infanteria
20	Artilleria
30	Armada
40	Caballeria
50	Marina
\.


--
-- Data for Name: serv_realz; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serv_realz (id_serv_fk, id_sol_fk, fecha_realn) FROM stdin;
1	110	2024-02-24
2	120	2024-02-23
3	130	2024-02-22
4	140	2024-02-21
5	150	2024-02-20
5	110	2024-02-19
5	120	2024-02-18
4	110	2024-02-17
4	120	2024-02-16
3	110	2024-02-15
\.


--
-- Data for Name: servicios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.servicios (id_serv, actividad) FROM stdin;
1	Guardia
2	Cuartelero
3	Instructor
4	Conductor
5	Comunicacion
\.


--
-- Data for Name: soldados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.soldados (id_sol, nombre_sol, ape_sol, grado_sol, id_crpo_fk, cod_crtl_fk, id_comp_fk) FROM stdin;
110	Alejandro	García	Soldado	10	1	11
120	Juan 	Martínez	Cabo	20	2	22
130	Manuel	Hernandez	Sargento	30	3	33
140	Miguel	Lopez	Oficial	40	4	44
150	Luis	Rodriguez	General	50	4	55
\.


--
-- Name: cuarteles_id_comp_fk_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cuarteles_id_comp_fk_seq', 1, false);


--
-- Name: companias companias_act_comp_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companias
    ADD CONSTRAINT companias_act_comp_key UNIQUE (act_comp);


--
-- Name: companias companias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companias
    ADD CONSTRAINT companias_pkey PRIMARY KEY (id_comp);


--
-- Name: cuarteles cuarteles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuarteles
    ADD CONSTRAINT cuarteles_pkey PRIMARY KEY (cod_crtl);


--
-- Name: cuerpos cuerpos_deno_crpo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuerpos
    ADD CONSTRAINT cuerpos_deno_crpo_key UNIQUE (deno_crpo);


--
-- Name: cuerpos cuerpos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuerpos
    ADD CONSTRAINT cuerpos_pkey PRIMARY KEY (id_crpo);


--
-- Name: servicios servicios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicios
    ADD CONSTRAINT servicios_pkey PRIMARY KEY (id_serv);


--
-- Name: soldados soldados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soldados
    ADD CONSTRAINT soldados_pkey PRIMARY KEY (id_sol);


--
-- Name: soldados cod_crtl_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soldados
    ADD CONSTRAINT cod_crtl_fk FOREIGN KEY (cod_crtl_fk) REFERENCES public.cuarteles(cod_crtl);


--
-- Name: cuarteles cuarteles_id_comp_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuarteles
    ADD CONSTRAINT cuarteles_id_comp_fk_fkey FOREIGN KEY (id_comp_fk) REFERENCES public.companias(id_comp);


--
-- Name: soldados id_comp_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soldados
    ADD CONSTRAINT id_comp_fk FOREIGN KEY (id_comp_fk) REFERENCES public.companias(id_comp);


--
-- Name: soldados id_crp_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soldados
    ADD CONSTRAINT id_crp_fk FOREIGN KEY (id_crpo_fk) REFERENCES public.cuerpos(id_crpo);


--
-- Name: serv_realz serv_realz_id_serv_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serv_realz
    ADD CONSTRAINT serv_realz_id_serv_fk_fkey FOREIGN KEY (id_serv_fk) REFERENCES public.servicios(id_serv);


--
-- Name: serv_realz serv_realz_id_sol_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serv_realz
    ADD CONSTRAINT serv_realz_id_sol_fk_fkey FOREIGN KEY (id_sol_fk) REFERENCES public.soldados(id_sol);


--
-- PostgreSQL database dump complete
--

