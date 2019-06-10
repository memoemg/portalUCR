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
-- Data for Name: transformerrule; Type: TABLE DATA; Schema: public; Owner: eldomo
--

INSERT INTO public.transformerrule VALUES (1, '{"@class":"org.lareferencia.backend.validation.transformer.FieldContentConditionalAddOccrRule","removeDuplicatedOccurrences":true,"conditionalExpression":"NOT ( dc.rights.*=%''info.+'' )","fieldName":"dc.rights.none","valueToAdd":"info:eu-repo/semantics/openAccess"}', 'Agregar access level', 'Agregar access level', 1, 1);
INSERT INTO public.transformerrule VALUES (2, '{"@class":"org.lareferencia.backend.validation.transformer.FieldContentConditionalAddOccrRule","removeDuplicatedOccurrences":false,"conditionalExpression":"NOT ( dc.type.*==''info:eu-repo/semantics/draft'' OR dc.type.*==''info:eu-repo/semantics/submittedVersion'' OR dc.type.*==''info:eu-repo/semantics/acceptedVersion'' OR dc.type.*==''info:eu-repo/semantics/publishedVersion'' OR dc.type.*==''info:eu-repo/semantics/updatedVersion'' )","fieldName":"dc.type.none","valueToAdd":"info:eu-repo/semantics/publishedVersion"}', 'Agrega publiishedVersion sin no hay status', 'Agregado de status de la publicación', 2, 1);
INSERT INTO public.transformerrule VALUES (3, '{"@class":"org.lareferencia.backend.validation.transformer.AddRepoNameRule","doRepoNameAppend":true,"doRepoNameReplace":false,"doInstNameAppend":true,"doInstNameReplace":false,"repoNameField":"dc.source.none","repoNamePrefix":"reponame:","instNameField":"dc.source.none","instNamePrefix":"instname:","instAcronField":"dc.source.none","instAcronPrefix":"instacron:"}', 'Agregado de instname y reponame', 'Agregado de instname y reponame', 3, 1);
INSERT INTO public.transformerrule VALUES (4, '{"@class":"org.lareferencia.backend.validation.transformer.FieldNameTranslateRule","sourceFieldName":"dc.contributor.author.*:value","targetFieldName":"dc.creator.none"}', 'Cambia dc.contributor.author por dc.creator', 'Normaliza los autores', 4, 1);
INSERT INTO public.transformerrule VALUES (5, '{"@class":"org.lareferencia.backend.validation.transformer.FieldContentTranslateRule","replaceOccurrence":true,"testValueAsPrefix":false,"translationArray":[{"search":"Artículo revisado por pares","replace":"info:eu-repo/semantics/article"},{"search":"Libro","replace":"info:eu-repo/semantics/book"},{"search":"Capítulo de libro","replace":"info:eu-repo/semantics/bookPart"},{"search":"Informe técnico","replace":"info:eu-repo/semantics/report"},{"search":"Tesis de doctorado","replace":"info:eu-repo/semantics/doctoralThesis"},{"search":"Tesis de maestría","replace":"info:eu-repo/semantics/masterThesis"},{"search":"Tesis de licenciatura","replace":"info:eu-repo/semantics/bachelorThesis"},{"search":"Informe de investigación","replace":"info:eu-repo/semantics/report"},{"search":"Artículo científico","replace":"info:eu-repo/semantics/article"}],"testFieldName":"dc.type.*","writeFieldName":"dc.type.*"}', 'Transforma dc.type', 'Transforma los tipos de documento', 5, 1);


--
-- Name: transformerrule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eldomo
--

SELECT pg_catalog.setval('public.transformerrule_id_seq', 5, true);


--
-- PostgreSQL database dump complete
--

