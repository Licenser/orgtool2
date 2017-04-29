--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: handles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE handles (
    id integer NOT NULL,
    name character varying(255),
    handle character varying(255),
    img character varying(255),
    login character varying(255),
    member integer,
    type character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: handles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE handles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: handles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE handles_id_seq OWNED BY handles.id;


--
-- Name: item_props; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE item_props (
    id integer NOT NULL,
    item integer,
    prop integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: item_props_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE item_props_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_props_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE item_props_id_seq OWNED BY item_props.id;


--
-- Name: item_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE item_types (
    id integer NOT NULL,
    name character varying(255),
    "typeName" character varying(255),
    description text,
    img character varying(255),
    permissions integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: item_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE item_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE item_types_id_seq OWNED BY item_types.id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE items (
    id integer NOT NULL,
    available boolean DEFAULT false NOT NULL,
    description text,
    hidden boolean DEFAULT false NOT NULL,
    img character varying(255),
    member integer,
    name character varying(255),
    parent integer,
    type integer,
    unit integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE items_id_seq OWNED BY items.id;


--
-- Name: member_units; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE member_units (
    id integer NOT NULL,
    log text,
    member integer,
    reward integer,
    unit integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: member_units_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE member_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: member_units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE member_units_id_seq OWNED BY member_units.id;


--
-- Name: members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE members (
    id integer NOT NULL,
    name character varying(255),
    avatar character varying(255),
    logs text,
    timezone integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE members_id_seq OWNED BY members.id;


--
-- Name: props; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE props (
    id integer NOT NULL,
    name character varying(255),
    value character varying(255),
    description text,
    img character varying(255),
    item integer,
    type integer,
    unit integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: props_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE props_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: props_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE props_id_seq OWNED BY props.id;


--
-- Name: reward_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE reward_types (
    id integer NOT NULL,
    name character varying(255),
    description text,
    img character varying(255),
    level integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: reward_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reward_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reward_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reward_types_id_seq OWNED BY reward_types.id;


--
-- Name: rewards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE rewards (
    id integer NOT NULL,
    description text,
    img character varying(255),
    level integer,
    name character varying(255),
    type integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: rewards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rewards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rewards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rewards_id_seq OWNED BY rewards.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


--
-- Name: unit_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE unit_types (
    id integer NOT NULL,
    description text,
    img character varying(255),
    name character varying(255),
    ordering integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: unit_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE unit_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: unit_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE unit_types_id_seq OWNED BY unit_types.id;


--
-- Name: units; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE units (
    id integer NOT NULL,
    name character varying(255),
    description text,
    color character varying(255),
    img character varying(255),
    type integer,
    parent integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: units_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE units_id_seq OWNED BY units.id;


--
-- Name: handles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY handles ALTER COLUMN id SET DEFAULT nextval('handles_id_seq'::regclass);


--
-- Name: item_props id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_props ALTER COLUMN id SET DEFAULT nextval('item_props_id_seq'::regclass);


--
-- Name: item_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_types ALTER COLUMN id SET DEFAULT nextval('item_types_id_seq'::regclass);


--
-- Name: items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY items ALTER COLUMN id SET DEFAULT nextval('items_id_seq'::regclass);


--
-- Name: member_units id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY member_units ALTER COLUMN id SET DEFAULT nextval('member_units_id_seq'::regclass);


--
-- Name: members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY members ALTER COLUMN id SET DEFAULT nextval('members_id_seq'::regclass);


--
-- Name: props id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY props ALTER COLUMN id SET DEFAULT nextval('props_id_seq'::regclass);


--
-- Name: reward_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reward_types ALTER COLUMN id SET DEFAULT nextval('reward_types_id_seq'::regclass);


--
-- Name: rewards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rewards ALTER COLUMN id SET DEFAULT nextval('rewards_id_seq'::regclass);


--
-- Name: unit_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY unit_types ALTER COLUMN id SET DEFAULT nextval('unit_types_id_seq'::regclass);


--
-- Name: units id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY units ALTER COLUMN id SET DEFAULT nextval('units_id_seq'::regclass);


--
-- Name: handles handles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY handles
    ADD CONSTRAINT handles_pkey PRIMARY KEY (id);


--
-- Name: item_props item_props_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_props
    ADD CONSTRAINT item_props_pkey PRIMARY KEY (id);


--
-- Name: item_types item_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_types
    ADD CONSTRAINT item_types_pkey PRIMARY KEY (id);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: member_units member_units_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY member_units
    ADD CONSTRAINT member_units_pkey PRIMARY KEY (id);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);


--
-- Name: props props_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY props
    ADD CONSTRAINT props_pkey PRIMARY KEY (id);


--
-- Name: reward_types reward_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reward_types
    ADD CONSTRAINT reward_types_pkey PRIMARY KEY (id);


--
-- Name: rewards rewards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rewards
    ADD CONSTRAINT rewards_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: unit_types unit_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY unit_types
    ADD CONSTRAINT unit_types_pkey PRIMARY KEY (id);


--
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

INSERT INTO "schema_migrations" (version) VALUES (20170428125711), (20170428131009), (20170428162713), (20170428170408), (20170428170840), (20170428172040), (20170428172622), (20170428180725), (20170428180928), (20170428181041), (20170428190044);

