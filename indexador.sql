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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: change_tracker; Type: TABLE; Schema: public; Owner: vufind; Tablespace: 
--

CREATE TABLE public.change_tracker (
    core character varying(30) NOT NULL,
    id character varying(120) NOT NULL,
    first_indexed timestamp without time zone,
    last_indexed timestamp without time zone,
    last_record_change timestamp without time zone,
    deleted timestamp without time zone
);


ALTER TABLE public.change_tracker OWNER TO vufind;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: vufind; Tablespace: 
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    user_id integer DEFAULT 0 NOT NULL,
    resource_id integer DEFAULT 0 NOT NULL,
    comment text NOT NULL,
    created timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL
);


ALTER TABLE public.comments OWNER TO vufind;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: vufind
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comments_id_seq OWNER TO vufind;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vufind
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: external_session; Type: TABLE; Schema: public; Owner: vufind; Tablespace: 
--

CREATE TABLE public.external_session (
    id integer NOT NULL,
    session_id character varying(128) NOT NULL,
    external_session_id character varying(255) NOT NULL,
    created timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL
);


ALTER TABLE public.external_session OWNER TO vufind;

--
-- Name: external_session_id_seq; Type: SEQUENCE; Schema: public; Owner: vufind
--

CREATE SEQUENCE public.external_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.external_session_id_seq OWNER TO vufind;

--
-- Name: external_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vufind
--

ALTER SEQUENCE public.external_session_id_seq OWNED BY public.external_session.id;


--
-- Name: oai_resumption; Type: TABLE; Schema: public; Owner: vufind; Tablespace: 
--

CREATE TABLE public.oai_resumption (
    id integer NOT NULL,
    params text,
    expires timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL
);


ALTER TABLE public.oai_resumption OWNER TO vufind;

--
-- Name: oai_resumption_id_seq; Type: SEQUENCE; Schema: public; Owner: vufind
--

CREATE SEQUENCE public.oai_resumption_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oai_resumption_id_seq OWNER TO vufind;

--
-- Name: oai_resumption_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vufind
--

ALTER SEQUENCE public.oai_resumption_id_seq OWNED BY public.oai_resumption.id;


--
-- Name: record; Type: TABLE; Schema: public; Owner: vufind; Tablespace: 
--

CREATE TABLE public.record (
    id integer NOT NULL,
    record_id character varying(255),
    source character varying(50),
    version character varying(20) NOT NULL,
    data text,
    updated timestamp without time zone
);


ALTER TABLE public.record OWNER TO vufind;

--
-- Name: record_id_seq; Type: SEQUENCE; Schema: public; Owner: vufind
--

CREATE SEQUENCE public.record_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.record_id_seq OWNER TO vufind;

--
-- Name: record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vufind
--

ALTER SEQUENCE public.record_id_seq OWNED BY public.record.id;


--
-- Name: resource; Type: TABLE; Schema: public; Owner: vufind; Tablespace: 
--

CREATE TABLE public.resource (
    id integer NOT NULL,
    record_id character varying(255) DEFAULT ''::character varying NOT NULL,
    title character varying(255) DEFAULT ''::character varying NOT NULL,
    author character varying(255) DEFAULT NULL::character varying,
    year integer,
    source character varying(50) DEFAULT 'Solr'::character varying NOT NULL
);


ALTER TABLE public.resource OWNER TO vufind;

--
-- Name: resource_id_seq; Type: SEQUENCE; Schema: public; Owner: vufind
--

CREATE SEQUENCE public.resource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.resource_id_seq OWNER TO vufind;

--
-- Name: resource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vufind
--

ALTER SEQUENCE public.resource_id_seq OWNED BY public.resource.id;


--
-- Name: resource_tags; Type: TABLE; Schema: public; Owner: vufind; Tablespace: 
--

CREATE TABLE public.resource_tags (
    id integer NOT NULL,
    resource_id integer DEFAULT 0 NOT NULL,
    tag_id integer DEFAULT 0 NOT NULL,
    list_id integer,
    user_id integer,
    posted timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.resource_tags OWNER TO vufind;

--
-- Name: resource_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: vufind
--

CREATE SEQUENCE public.resource_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.resource_tags_id_seq OWNER TO vufind;

--
-- Name: resource_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vufind
--

ALTER SEQUENCE public.resource_tags_id_seq OWNED BY public.resource_tags.id;


--
-- Name: search; Type: TABLE; Schema: public; Owner: vufind; Tablespace: 
--

CREATE TABLE public.search (
    id integer NOT NULL,
    user_id integer DEFAULT 0 NOT NULL,
    session_id character varying(128),
    folder_id integer,
    created timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    title character varying(20) DEFAULT NULL::character varying,
    saved integer DEFAULT 0 NOT NULL,
    search_object bytea,
    checksum integer
);


ALTER TABLE public.search OWNER TO vufind;

--
-- Name: search_id_seq; Type: SEQUENCE; Schema: public; Owner: vufind
--

CREATE SEQUENCE public.search_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.search_id_seq OWNER TO vufind;

--
-- Name: search_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vufind
--

ALTER SEQUENCE public.search_id_seq OWNED BY public.search.id;


--
-- Name: session; Type: TABLE; Schema: public; Owner: vufind; Tablespace: 
--

CREATE TABLE public.session (
    id integer NOT NULL,
    session_id character varying(128),
    data text,
    last_used integer DEFAULT 0 NOT NULL,
    created timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL
);


ALTER TABLE public.session OWNER TO vufind;

--
-- Name: session_id_seq; Type: SEQUENCE; Schema: public; Owner: vufind
--

CREATE SEQUENCE public.session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.session_id_seq OWNER TO vufind;

--
-- Name: session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vufind
--

ALTER SEQUENCE public.session_id_seq OWNED BY public.session.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: vufind; Tablespace: 
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    tag character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.tags OWNER TO vufind;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: vufind
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO vufind;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vufind
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: vufind; Tablespace: 
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    username character varying(255) DEFAULT ''::character varying NOT NULL,
    password character varying(32) DEFAULT ''::character varying NOT NULL,
    pass_hash character varying(60) DEFAULT NULL::character varying,
    firstname character varying(50) DEFAULT ''::character varying NOT NULL,
    lastname character varying(50) DEFAULT ''::character varying NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    cat_id character varying(255) DEFAULT NULL::character varying,
    cat_username character varying(50) DEFAULT NULL::character varying,
    cat_password character varying(70) DEFAULT NULL::character varying,
    cat_pass_enc character varying(170) DEFAULT NULL::character varying,
    college character varying(100) DEFAULT ''::character varying NOT NULL,
    major character varying(100) DEFAULT ''::character varying NOT NULL,
    home_library character varying(100) DEFAULT ''::character varying NOT NULL,
    created timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    verify_hash character varying(42) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public."user" OWNER TO vufind;

--
-- Name: user_card; Type: TABLE; Schema: public; Owner: vufind; Tablespace: 
--

CREATE TABLE public.user_card (
    id integer NOT NULL,
    user_id integer NOT NULL,
    card_name character varying(255) DEFAULT ''::character varying NOT NULL,
    cat_username character varying(50) DEFAULT ''::character varying NOT NULL,
    cat_password character varying(50) DEFAULT NULL::character varying,
    cat_pass_enc character varying(110) DEFAULT NULL::character varying,
    home_library character varying(100) DEFAULT ''::character varying NOT NULL,
    created timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    saved timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_card OWNER TO vufind;

--
-- Name: user_card_id_seq; Type: SEQUENCE; Schema: public; Owner: vufind
--

CREATE SEQUENCE public.user_card_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_card_id_seq OWNER TO vufind;

--
-- Name: user_card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vufind
--

ALTER SEQUENCE public.user_card_id_seq OWNED BY public.user_card.id;


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: vufind
--

CREATE SEQUENCE public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO vufind;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vufind
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: user_list; Type: TABLE; Schema: public; Owner: vufind; Tablespace: 
--

CREATE TABLE public.user_list (
    id integer NOT NULL,
    user_id integer NOT NULL,
    title character varying(200) NOT NULL,
    description text,
    created timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone NOT NULL,
    public integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_list OWNER TO vufind;

--
-- Name: user_list_id_seq; Type: SEQUENCE; Schema: public; Owner: vufind
--

CREATE SEQUENCE public.user_list_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_list_id_seq OWNER TO vufind;

--
-- Name: user_list_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vufind
--

ALTER SEQUENCE public.user_list_id_seq OWNED BY public.user_list.id;


--
-- Name: user_resource; Type: TABLE; Schema: public; Owner: vufind; Tablespace: 
--

CREATE TABLE public.user_resource (
    id integer NOT NULL,
    user_id integer NOT NULL,
    resource_id integer NOT NULL,
    list_id integer,
    notes text,
    saved timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_resource OWNER TO vufind;

--
-- Name: user_resource_id_seq; Type: SEQUENCE; Schema: public; Owner: vufind
--

CREATE SEQUENCE public.user_resource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_resource_id_seq OWNER TO vufind;

--
-- Name: user_resource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vufind
--

ALTER SEQUENCE public.user_resource_id_seq OWNED BY public.user_resource.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.external_session ALTER COLUMN id SET DEFAULT nextval('public.external_session_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.oai_resumption ALTER COLUMN id SET DEFAULT nextval('public.oai_resumption_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.record ALTER COLUMN id SET DEFAULT nextval('public.record_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.resource ALTER COLUMN id SET DEFAULT nextval('public.resource_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.resource_tags ALTER COLUMN id SET DEFAULT nextval('public.resource_tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.search ALTER COLUMN id SET DEFAULT nextval('public.search_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.session ALTER COLUMN id SET DEFAULT nextval('public.session_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.user_card ALTER COLUMN id SET DEFAULT nextval('public.user_card_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.user_list ALTER COLUMN id SET DEFAULT nextval('public.user_list_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.user_resource ALTER COLUMN id SET DEFAULT nextval('public.user_resource_id_seq'::regclass);


--
-- Name: change_tracker_pkey; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public.change_tracker
    ADD CONSTRAINT change_tracker_pkey PRIMARY KEY (core, id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: external_session_pkey; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public.external_session
    ADD CONSTRAINT external_session_pkey PRIMARY KEY (id);


--
-- Name: external_session_session_id_key; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public.external_session
    ADD CONSTRAINT external_session_session_id_key UNIQUE (session_id);


--
-- Name: oai_resumption_pkey; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public.oai_resumption
    ADD CONSTRAINT oai_resumption_pkey PRIMARY KEY (id);


--
-- Name: record_pkey; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public.record
    ADD CONSTRAINT record_pkey PRIMARY KEY (id);


--
-- Name: record_record_id_source_key; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public.record
    ADD CONSTRAINT record_record_id_source_key UNIQUE (record_id, source);


--
-- Name: resource_pkey; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public.resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (id);


--
-- Name: resource_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public.resource_tags
    ADD CONSTRAINT resource_tags_pkey PRIMARY KEY (id);


--
-- Name: search_pkey; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public.search
    ADD CONSTRAINT search_pkey PRIMARY KEY (id);


--
-- Name: session_pkey; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (id);


--
-- Name: session_session_id_key; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_session_id_key UNIQUE (session_id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: user_card_pkey; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public.user_card
    ADD CONSTRAINT user_card_pkey PRIMARY KEY (id);


--
-- Name: user_cat_id_key; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_cat_id_key UNIQUE (cat_id);


--
-- Name: user_list_pkey; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public.user_list
    ADD CONSTRAINT user_list_pkey PRIMARY KEY (id);


--
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public.user_resource
    ADD CONSTRAINT user_resource_pkey PRIMARY KEY (id);


--
-- Name: user_username_key; Type: CONSTRAINT; Schema: public; Owner: vufind; Tablespace: 
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- Name: change_tracker_deleted_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX change_tracker_deleted_idx ON public.change_tracker USING btree (deleted);


--
-- Name: comments_resource_id_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX comments_resource_id_idx ON public.comments USING btree (resource_id);


--
-- Name: comments_user_id_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX comments_user_id_idx ON public.comments USING btree (user_id);


--
-- Name: external_session_id; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX external_session_id ON public.external_session USING btree (external_session_id);


--
-- Name: last_used_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX last_used_idx ON public.session USING btree (last_used);


--
-- Name: resource_record_id_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX resource_record_id_idx ON public.resource USING btree (record_id);


--
-- Name: resource_tags_list_id_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX resource_tags_list_id_idx ON public.resource_tags USING btree (list_id);


--
-- Name: resource_tags_resource_id_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX resource_tags_resource_id_idx ON public.resource_tags USING btree (resource_id);


--
-- Name: resource_tags_tag_id_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX resource_tags_tag_id_idx ON public.resource_tags USING btree (tag_id);


--
-- Name: resource_tags_user_id_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX resource_tags_user_id_idx ON public.resource_tags USING btree (user_id);


--
-- Name: search_folder_id_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX search_folder_id_idx ON public.search USING btree (folder_id);


--
-- Name: search_user_id_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX search_user_id_idx ON public.search USING btree (user_id);


--
-- Name: session_id_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX session_id_idx ON public.search USING btree (session_id);


--
-- Name: user_card_cat_username_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX user_card_cat_username_idx ON public.user_card USING btree (cat_username);


--
-- Name: user_card_user_id_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX user_card_user_id_idx ON public.user_card USING btree (user_id);


--
-- Name: user_list_user_id_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX user_list_user_id_idx ON public.user_list USING btree (user_id);


--
-- Name: user_resource_list_id_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX user_resource_list_id_idx ON public.user_resource USING btree (list_id);


--
-- Name: user_resource_resource_id_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX user_resource_resource_id_idx ON public.user_resource USING btree (resource_id);


--
-- Name: user_resource_user_id_idx; Type: INDEX; Schema: public; Owner: vufind; Tablespace: 
--

CREATE INDEX user_resource_user_id_idx ON public.user_resource USING btree (user_id);


--
-- Name: comments_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_ibfk_1 FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: comments_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_ibfk_2 FOREIGN KEY (resource_id) REFERENCES public.resource(id) ON DELETE CASCADE;


--
-- Name: resource_tags_ibfk_14; Type: FK CONSTRAINT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.resource_tags
    ADD CONSTRAINT resource_tags_ibfk_14 FOREIGN KEY (resource_id) REFERENCES public.resource(id) ON DELETE CASCADE;


--
-- Name: resource_tags_ibfk_15; Type: FK CONSTRAINT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.resource_tags
    ADD CONSTRAINT resource_tags_ibfk_15 FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON DELETE CASCADE;


--
-- Name: resource_tags_ibfk_16; Type: FK CONSTRAINT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.resource_tags
    ADD CONSTRAINT resource_tags_ibfk_16 FOREIGN KEY (list_id) REFERENCES public.user_list(id) ON DELETE SET NULL;


--
-- Name: resource_tags_ibfk_17; Type: FK CONSTRAINT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.resource_tags
    ADD CONSTRAINT resource_tags_ibfk_17 FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: user_card_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.user_card
    ADD CONSTRAINT user_card_ibfk_1 FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: user_list_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.user_list
    ADD CONSTRAINT user_list_ibfk_1 FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: user_resource_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.user_resource
    ADD CONSTRAINT user_resource_ibfk_1 FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: user_resource_ibfk_2; Type: FK CONSTRAINT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.user_resource
    ADD CONSTRAINT user_resource_ibfk_2 FOREIGN KEY (resource_id) REFERENCES public.resource(id) ON DELETE CASCADE;


--
-- Name: user_resource_ibfk_3; Type: FK CONSTRAINT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.user_resource
    ADD CONSTRAINT user_resource_ibfk_3 FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: user_resource_ibfk_4; Type: FK CONSTRAINT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.user_resource
    ADD CONSTRAINT user_resource_ibfk_4 FOREIGN KEY (resource_id) REFERENCES public.resource(id) ON DELETE CASCADE;


--
-- Name: user_resource_ibfk_5; Type: FK CONSTRAINT; Schema: public; Owner: vufind
--

ALTER TABLE ONLY public.user_resource
    ADD CONSTRAINT user_resource_ibfk_5 FOREIGN KEY (list_id) REFERENCES public.user_list(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: TABLE change_tracker; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON TABLE public.change_tracker FROM PUBLIC;
REVOKE ALL ON TABLE public.change_tracker FROM vufind;
GRANT ALL ON TABLE public.change_tracker TO vufind;


--
-- Name: TABLE comments; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON TABLE public.comments FROM PUBLIC;
REVOKE ALL ON TABLE public.comments FROM vufind;
GRANT ALL ON TABLE public.comments TO vufind;


--
-- Name: SEQUENCE comments_id_seq; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON SEQUENCE public.comments_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.comments_id_seq FROM vufind;
GRANT ALL ON SEQUENCE public.comments_id_seq TO vufind;


--
-- Name: TABLE external_session; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON TABLE public.external_session FROM PUBLIC;
REVOKE ALL ON TABLE public.external_session FROM vufind;
GRANT ALL ON TABLE public.external_session TO vufind;


--
-- Name: SEQUENCE external_session_id_seq; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON SEQUENCE public.external_session_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.external_session_id_seq FROM vufind;
GRANT ALL ON SEQUENCE public.external_session_id_seq TO vufind;


--
-- Name: TABLE oai_resumption; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON TABLE public.oai_resumption FROM PUBLIC;
REVOKE ALL ON TABLE public.oai_resumption FROM vufind;
GRANT ALL ON TABLE public.oai_resumption TO vufind;


--
-- Name: SEQUENCE oai_resumption_id_seq; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON SEQUENCE public.oai_resumption_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.oai_resumption_id_seq FROM vufind;
GRANT ALL ON SEQUENCE public.oai_resumption_id_seq TO vufind;


--
-- Name: TABLE record; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON TABLE public.record FROM PUBLIC;
REVOKE ALL ON TABLE public.record FROM vufind;
GRANT ALL ON TABLE public.record TO vufind;


--
-- Name: SEQUENCE record_id_seq; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON SEQUENCE public.record_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.record_id_seq FROM vufind;
GRANT ALL ON SEQUENCE public.record_id_seq TO vufind;


--
-- Name: TABLE resource; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON TABLE public.resource FROM PUBLIC;
REVOKE ALL ON TABLE public.resource FROM vufind;
GRANT ALL ON TABLE public.resource TO vufind;


--
-- Name: SEQUENCE resource_id_seq; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON SEQUENCE public.resource_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.resource_id_seq FROM vufind;
GRANT ALL ON SEQUENCE public.resource_id_seq TO vufind;


--
-- Name: TABLE resource_tags; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON TABLE public.resource_tags FROM PUBLIC;
REVOKE ALL ON TABLE public.resource_tags FROM vufind;
GRANT ALL ON TABLE public.resource_tags TO vufind;


--
-- Name: SEQUENCE resource_tags_id_seq; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON SEQUENCE public.resource_tags_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.resource_tags_id_seq FROM vufind;
GRANT ALL ON SEQUENCE public.resource_tags_id_seq TO vufind;


--
-- Name: TABLE search; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON TABLE public.search FROM PUBLIC;
REVOKE ALL ON TABLE public.search FROM vufind;
GRANT ALL ON TABLE public.search TO vufind;


--
-- Name: SEQUENCE search_id_seq; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON SEQUENCE public.search_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.search_id_seq FROM vufind;
GRANT ALL ON SEQUENCE public.search_id_seq TO vufind;


--
-- Name: TABLE session; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON TABLE public.session FROM PUBLIC;
REVOKE ALL ON TABLE public.session FROM vufind;
GRANT ALL ON TABLE public.session TO vufind;


--
-- Name: SEQUENCE session_id_seq; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON SEQUENCE public.session_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.session_id_seq FROM vufind;
GRANT ALL ON SEQUENCE public.session_id_seq TO vufind;


--
-- Name: TABLE tags; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON TABLE public.tags FROM PUBLIC;
REVOKE ALL ON TABLE public.tags FROM vufind;
GRANT ALL ON TABLE public.tags TO vufind;


--
-- Name: SEQUENCE tags_id_seq; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON SEQUENCE public.tags_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.tags_id_seq FROM vufind;
GRANT ALL ON SEQUENCE public.tags_id_seq TO vufind;


--
-- Name: TABLE "user"; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON TABLE public."user" FROM PUBLIC;
REVOKE ALL ON TABLE public."user" FROM vufind;
GRANT ALL ON TABLE public."user" TO vufind;


--
-- Name: TABLE user_card; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON TABLE public.user_card FROM PUBLIC;
REVOKE ALL ON TABLE public.user_card FROM vufind;
GRANT ALL ON TABLE public.user_card TO vufind;


--
-- Name: SEQUENCE user_card_id_seq; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON SEQUENCE public.user_card_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.user_card_id_seq FROM vufind;
GRANT ALL ON SEQUENCE public.user_card_id_seq TO vufind;


--
-- Name: SEQUENCE user_id_seq; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON SEQUENCE public.user_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.user_id_seq FROM vufind;
GRANT ALL ON SEQUENCE public.user_id_seq TO vufind;


--
-- Name: TABLE user_list; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON TABLE public.user_list FROM PUBLIC;
REVOKE ALL ON TABLE public.user_list FROM vufind;
GRANT ALL ON TABLE public.user_list TO vufind;


--
-- Name: SEQUENCE user_list_id_seq; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON SEQUENCE public.user_list_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.user_list_id_seq FROM vufind;
GRANT ALL ON SEQUENCE public.user_list_id_seq TO vufind;


--
-- Name: TABLE user_resource; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON TABLE public.user_resource FROM PUBLIC;
REVOKE ALL ON TABLE public.user_resource FROM vufind;
GRANT ALL ON TABLE public.user_resource TO vufind;


--
-- Name: SEQUENCE user_resource_id_seq; Type: ACL; Schema: public; Owner: vufind
--

REVOKE ALL ON SEQUENCE public.user_resource_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.user_resource_id_seq FROM vufind;
GRANT ALL ON SEQUENCE public.user_resource_id_seq TO vufind;


--
-- PostgreSQL database dump complete
--

