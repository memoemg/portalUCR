--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Data for Name: transformer; Type: TABLE DATA; Schema: public; Owner: eldomo
--

INSERT INTO public.transformer VALUES (1, 'Transformador base aplicado a todos los repositorios', 'Transformador - General');


--
-- Name: transformer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eldomo
--

SELECT pg_catalog.setval('public.transformer_id_seq', 1, true);


--
-- PostgreSQL database dump complete
--

