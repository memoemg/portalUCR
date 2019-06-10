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
-- Data for Name: validator; Type: TABLE DATA; Schema: public; Owner: eldomo
--

INSERT INTO public.validator VALUES (1, 'Validador OpenAire 3.0/Lareferencia', 'Validador Nodo Central / OpenAire 3.0');


--
-- Name: validator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eldomo
--

SELECT pg_catalog.setval('public.validator_id_seq', 1, true);


--
-- PostgreSQL database dump complete
--

