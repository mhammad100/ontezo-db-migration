--
-- PostgreSQL database dump
--

-- Dumped from database version 14.18 (Ubuntu 14.18-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 17.4

-- Started on 2025-08-02 11:13:26

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 924 (class 1247 OID 18029)
-- Name: comments_tag_enum; Type: TYPE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TYPE public.comments_tag_enum AS ENUM (
    'project',
    'task'
);


ALTER TYPE public.comments_tag_enum OWNER TO "ontezo-stagging-user";

--
-- TOC entry 1011 (class 1247 OID 84399)
-- Name: media_tag_enum; Type: TYPE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TYPE public.media_tag_enum AS ENUM (
    'comment',
    'user',
    'project',
    'task'
);


ALTER TYPE public.media_tag_enum OWNER TO "ontezo-stagging-user";

--
-- TOC entry 936 (class 1247 OID 18084)
-- Name: media_type_enum; Type: TYPE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TYPE public.media_type_enum AS ENUM (
    'image',
    'video',
    'document',
    'other'
);


ALTER TYPE public.media_type_enum OWNER TO "ontezo-stagging-user";

--
-- TOC entry 1005 (class 1247 OID 81977)
-- Name: project_duration_enum; Type: TYPE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TYPE public.project_duration_enum AS ENUM (
    'short-term',
    'mid-term',
    'long-term',
    'on-going'
);


ALTER TYPE public.project_duration_enum OWNER TO "ontezo-stagging-user";

--
-- TOC entry 1014 (class 1247 OID 85950)
-- Name: sprints_status_enum; Type: TYPE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TYPE public.sprints_status_enum AS ENUM (
    'UPCOMING',
    'PLANNED',
    'ACTIVE',
    'COMPLETED',
    'CANCELLED'
);


ALTER TYPE public.sprints_status_enum OWNER TO "ontezo-stagging-user";

--
-- TOC entry 957 (class 1247 OID 18181)
-- Name: user_links_platform_enum; Type: TYPE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TYPE public.user_links_platform_enum AS ENUM (
    'github',
    'gitlab'
);


ALTER TYPE public.user_links_platform_enum OWNER TO "ontezo-stagging-user";

--
-- TOC entry 975 (class 1247 OID 18255)
-- Name: user_preferences_category_enum; Type: TYPE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TYPE public.user_preferences_category_enum AS ENUM (
    'usage',
    'management',
    'features'
);


ALTER TYPE public.user_preferences_category_enum OWNER TO "ontezo-stagging-user";

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 17957)
-- Name: audit_log; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.audit_log (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    action character varying NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    user_id integer
);


ALTER TABLE public.audit_log OWNER TO "ontezo-stagging-user";

--
-- TOC entry 219 (class 1259 OID 17956)
-- Name: audit_log_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.audit_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_log_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3830 (class 0 OID 0)
-- Dependencies: 219
-- Name: audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.audit_log_id_seq OWNED BY public.audit_log.id;


--
-- TOC entry 274 (class 1259 OID 82000)
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.audit_logs (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    action character varying NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    team_member_id integer NOT NULL,
    task_id integer,
    project_id integer
);


ALTER TABLE public.audit_logs OWNER TO "ontezo-stagging-user";

--
-- TOC entry 273 (class 1259 OID 81999)
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3831 (class 0 OID 0)
-- Dependencies: 273
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- TOC entry 226 (class 1259 OID 17992)
-- Name: checklist_items; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.checklist_items (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    description character varying NOT NULL,
    is_checked boolean DEFAULT false NOT NULL,
    checklist_id integer
);


ALTER TABLE public.checklist_items OWNER TO "ontezo-stagging-user";

--
-- TOC entry 225 (class 1259 OID 17991)
-- Name: checklist_items_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.checklist_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.checklist_items_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3832 (class 0 OID 0)
-- Dependencies: 225
-- Name: checklist_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.checklist_items_id_seq OWNED BY public.checklist_items.id;


--
-- TOC entry 228 (class 1259 OID 18004)
-- Name: checklists; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.checklists (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying NOT NULL,
    status character varying DEFAULT 'active'::character varying NOT NULL,
    phase_id integer
);


ALTER TABLE public.checklists OWNER TO "ontezo-stagging-user";

--
-- TOC entry 227 (class 1259 OID 18003)
-- Name: checklists_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.checklists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.checklists_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3833 (class 0 OID 0)
-- Dependencies: 227
-- Name: checklists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.checklists_id_seq OWNED BY public.checklists.id;


--
-- TOC entry 224 (class 1259 OID 17980)
-- Name: clients; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying NOT NULL,
    designation character varying,
    phone character varying,
    email character varying,
    company_name character varying,
    company_phone character varying,
    company_email character varying,
    created_by_id integer
);


ALTER TABLE public.clients OWNER TO "ontezo-stagging-user";

--
-- TOC entry 223 (class 1259 OID 17979)
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clients_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3834 (class 0 OID 0)
-- Dependencies: 223
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- TOC entry 232 (class 1259 OID 18034)
-- Name: comments; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    content character varying NOT NULL,
    parent_comment_id integer,
    team_member_id integer NOT NULL,
    project_id integer,
    task_id integer,
    tag public.comments_tag_enum DEFAULT 'project'::public.comments_tag_enum,
    is_edited boolean DEFAULT false NOT NULL,
    attachment json
);


ALTER TABLE public.comments OWNER TO "ontezo-stagging-user";

--
-- TOC entry 231 (class 1259 OID 18033)
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comments_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3835 (class 0 OID 0)
-- Dependencies: 231
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- TOC entry 278 (class 1259 OID 86206)
-- Name: invites; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.invites (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    email character varying NOT NULL,
    token character varying NOT NULL,
    "roleId" integer NOT NULL,
    invited_by_id integer NOT NULL,
    tenant_id integer NOT NULL
);


ALTER TABLE public.invites OWNER TO "ontezo-stagging-user";

--
-- TOC entry 277 (class 1259 OID 86205)
-- Name: invites_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.invites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.invites_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3836 (class 0 OID 0)
-- Dependencies: 277
-- Name: invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.invites_id_seq OWNED BY public.invites.id;


--
-- TOC entry 238 (class 1259 OID 18102)
-- Name: media; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.media (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    file_name character varying,
    original_name character varying,
    mime_type character varying,
    size integer,
    url character varying,
    type public.media_type_enum DEFAULT 'other'::public.media_type_enum NOT NULL,
    tag public.media_tag_enum DEFAULT 'user'::public.media_tag_enum NOT NULL,
    description character varying,
    bucket character varying NOT NULL,
    key character varying NOT NULL,
    thumbnail character varying,
    created_by_id integer
);


ALTER TABLE public.media OWNER TO "ontezo-stagging-user";

--
-- TOC entry 237 (class 1259 OID 18101)
-- Name: media_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.media_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.media_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3837 (class 0 OID 0)
-- Dependencies: 237
-- Name: media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.media_id_seq OWNED BY public.media.id;


--
-- TOC entry 240 (class 1259 OID 18116)
-- Name: media_records; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.media_records (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    media_id integer NOT NULL,
    user_id integer,
    project_id integer,
    task_id integer,
    comment_id integer
);


ALTER TABLE public.media_records OWNER TO "ontezo-stagging-user";

--
-- TOC entry 239 (class 1259 OID 18115)
-- Name: media_records_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.media_records_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.media_records_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3838 (class 0 OID 0)
-- Dependencies: 239
-- Name: media_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.media_records_id_seq OWNED BY public.media_records.id;


--
-- TOC entry 268 (class 1259 OID 18323)
-- Name: menu; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.menu (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying NOT NULL,
    icon character varying,
    route character varying,
    is_visible boolean DEFAULT true NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    "order" integer DEFAULT 0 NOT NULL,
    group_by character varying,
    "parentId" integer
);


ALTER TABLE public.menu OWNER TO "ontezo-stagging-user";

--
-- TOC entry 272 (class 1259 OID 18367)
-- Name: menu_closure; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.menu_closure (
    id_ancestor integer NOT NULL,
    id_descendant integer NOT NULL
);


ALTER TABLE public.menu_closure OWNER TO "ontezo-stagging-user";

--
-- TOC entry 267 (class 1259 OID 18322)
-- Name: menu_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.menu_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.menu_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3839 (class 0 OID 0)
-- Dependencies: 267
-- Name: menu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.menu_id_seq OWNED BY public.menu.id;


--
-- TOC entry 214 (class 1259 OID 17912)
-- Name: permissions; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying NOT NULL,
    permission_type character varying,
    feature character varying
);


ALTER TABLE public.permissions OWNER TO "ontezo-stagging-user";

--
-- TOC entry 213 (class 1259 OID 17911)
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permissions_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3840 (class 0 OID 0)
-- Dependencies: 213
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- TOC entry 230 (class 1259 OID 18016)
-- Name: phases; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.phases (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    title character varying NOT NULL,
    name character varying NOT NULL,
    status character varying DEFAULT 'in-progress'::character varying NOT NULL,
    project_id integer
);


ALTER TABLE public.phases OWNER TO "ontezo-stagging-user";

--
-- TOC entry 229 (class 1259 OID 18015)
-- Name: phases_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.phases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.phases_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3841 (class 0 OID 0)
-- Dependencies: 229
-- Name: phases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.phases_id_seq OWNED BY public.phases.id;


--
-- TOC entry 264 (class 1259 OID 18289)
-- Name: plans; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.plans (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    stripe_price_id character varying,
    stripe_product_id character varying,
    name character varying NOT NULL,
    description character varying,
    price_per_unit_amount numeric(10,2) NOT NULL,
    currency character varying NOT NULL,
    "interval" character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    features json NOT NULL,
    trial_period_days integer,
    is_custom boolean DEFAULT false NOT NULL
);


ALTER TABLE public.plans OWNER TO "ontezo-stagging-user";

--
-- TOC entry 263 (class 1259 OID 18288)
-- Name: plans_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.plans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.plans_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3842 (class 0 OID 0)
-- Dependencies: 263
-- Name: plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.plans_id_seq OWNED BY public.plans.id;


--
-- TOC entry 269 (class 1259 OID 18346)
-- Name: project_assignees; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.project_assignees (
    project_id integer NOT NULL,
    team_member_id integer NOT NULL
);


ALTER TABLE public.project_assignees OWNER TO "ontezo-stagging-user";

--
-- TOC entry 222 (class 1259 OID 17968)
-- Name: project_statuses; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.project_statuses (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    display_name character varying NOT NULL,
    name character varying NOT NULL,
    "order" integer NOT NULL,
    project_id integer NOT NULL
);


ALTER TABLE public.project_statuses OWNER TO "ontezo-stagging-user";

--
-- TOC entry 221 (class 1259 OID 17967)
-- Name: project_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.project_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project_statuses_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3843 (class 0 OID 0)
-- Dependencies: 221
-- Name: project_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.project_statuses_id_seq OWNED BY public.project_statuses.id;


--
-- TOC entry 242 (class 1259 OID 18126)
-- Name: projects; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying,
    status character varying DEFAULT 'active'::character varying NOT NULL,
    is_sprint_project boolean DEFAULT false NOT NULL,
    "clientId" integer,
    start_date date DEFAULT '2025-07-28'::date,
    end_date date,
    created_by_id integer,
    project_duration public.project_duration_enum,
    documents json
);


ALTER TABLE public.projects OWNER TO "ontezo-stagging-user";

--
-- TOC entry 241 (class 1259 OID 18125)
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.projects_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3844 (class 0 OID 0)
-- Dependencies: 241
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- TOC entry 276 (class 1259 OID 86140)
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.role_permissions (
    id integer NOT NULL,
    role_id integer NOT NULL,
    permission_id integer NOT NULL,
    is_global boolean DEFAULT false NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO "ontezo-stagging-user";

--
-- TOC entry 275 (class 1259 OID 86139)
-- Name: role_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.role_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.role_permissions_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3845 (class 0 OID 0)
-- Dependencies: 275
-- Name: role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.role_permissions_id_seq OWNED BY public.role_permissions.id;


--
-- TOC entry 216 (class 1259 OID 17926)
-- Name: roles; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying NOT NULL,
    label character varying,
    description character varying,
    role_type character varying,
    feature character varying,
    tenant_id integer NOT NULL
);


ALTER TABLE public.roles OWNER TO "ontezo-stagging-user";

--
-- TOC entry 215 (class 1259 OID 17925)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3846 (class 0 OID 0)
-- Dependencies: 215
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 234 (class 1259 OID 18051)
-- Name: sprint_statuses; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.sprint_statuses (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    display_name character varying NOT NULL,
    name character varying NOT NULL,
    "order" integer NOT NULL,
    sprint_id integer NOT NULL
);


ALTER TABLE public.sprint_statuses OWNER TO "ontezo-stagging-user";

--
-- TOC entry 233 (class 1259 OID 18050)
-- Name: sprint_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.sprint_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sprint_statuses_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3847 (class 0 OID 0)
-- Dependencies: 233
-- Name: sprint_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.sprint_statuses_id_seq OWNED BY public.sprint_statuses.id;


--
-- TOC entry 236 (class 1259 OID 18072)
-- Name: sprints; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.sprints (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying NOT NULL,
    description character varying,
    status public.sprints_status_enum DEFAULT 'PLANNED'::public.sprints_status_enum NOT NULL,
    project_id integer NOT NULL,
    start_date date,
    end_date date,
    duration character varying,
    old_id character varying
);


ALTER TABLE public.sprints OWNER TO "ontezo-stagging-user";

--
-- TOC entry 235 (class 1259 OID 18071)
-- Name: sprints_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.sprints_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sprints_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3848 (class 0 OID 0)
-- Dependencies: 235
-- Name: sprints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.sprints_id_seq OWNED BY public.sprints.id;


--
-- TOC entry 266 (class 1259 OID 18308)
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.subscriptions (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    stripe_subscription_id character varying NOT NULL,
    stripe_customer_id character varying NOT NULL,
    features json NOT NULL,
    status character varying NOT NULL,
    current_period_start timestamp without time zone NOT NULL,
    current_period_end timestamp without time zone NOT NULL,
    canceled_at timestamp without time zone,
    cancel_at_period_end boolean DEFAULT false NOT NULL,
    stripe_price_id character varying,
    amount numeric(10,2) NOT NULL,
    currency character varying NOT NULL,
    is_trialing boolean DEFAULT false NOT NULL,
    user_id integer NOT NULL,
    plan_id integer NOT NULL
);


ALTER TABLE public.subscriptions OWNER TO "ontezo-stagging-user";

--
-- TOC entry 265 (class 1259 OID 18307)
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.subscriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subscriptions_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3849 (class 0 OID 0)
-- Dependencies: 265
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- TOC entry 270 (class 1259 OID 18353)
-- Name: task_assignees; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.task_assignees (
    task_id integer NOT NULL,
    team_member_id integer NOT NULL
);


ALTER TABLE public.task_assignees OWNER TO "ontezo-stagging-user";

--
-- TOC entry 252 (class 1259 OID 18199)
-- Name: tasks; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.tasks (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    title character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying,
    status character varying DEFAULT 'pending'::character varying NOT NULL,
    start_date date DEFAULT '2025-07-28'::date NOT NULL,
    due_date date,
    priority character varying DEFAULT 'low'::character varying,
    tags json,
    project_id integer NOT NULL,
    sprint_id integer,
    parent_task_id integer,
    created_by_id integer,
    story_point numeric(4,1) DEFAULT 0.0 NOT NULL,
    sprint_status_id integer,
    project_status_id integer
);


ALTER TABLE public.tasks OWNER TO "ontezo-stagging-user";

--
-- TOC entry 251 (class 1259 OID 18198)
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasks_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3850 (class 0 OID 0)
-- Dependencies: 251
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- TOC entry 254 (class 1259 OID 18216)
-- Name: team_members; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.team_members (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    joinin_date timestamp without time zone,
    monthly_salary integer,
    department character varying,
    designation character varying,
    skills json,
    experience character varying,
    user_id integer,
    created_by_id integer
);


ALTER TABLE public.team_members OWNER TO "ontezo-stagging-user";

--
-- TOC entry 253 (class 1259 OID 18215)
-- Name: team_members_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.team_members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.team_members_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3851 (class 0 OID 0)
-- Dependencies: 253
-- Name: team_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.team_members_id_seq OWNED BY public.team_members.id;


--
-- TOC entry 218 (class 1259 OID 17940)
-- Name: tenants; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.tenants (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    name character varying NOT NULL,
    subdomain character varying NOT NULL,
    database_name character varying,
    database_host character varying,
    database_user character varying,
    database_pwd character varying,
    email character varying,
    "ownerId" integer
);


ALTER TABLE public.tenants OWNER TO "ontezo-stagging-user";

--
-- TOC entry 217 (class 1259 OID 17939)
-- Name: tenants_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.tenants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tenants_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3852 (class 0 OID 0)
-- Dependencies: 217
-- Name: tenants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.tenants_id_seq OWNED BY public.tenants.id;


--
-- TOC entry 246 (class 1259 OID 18156)
-- Name: test_cases; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.test_cases (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    title character varying NOT NULL,
    description character varying,
    "isChecked" boolean DEFAULT false NOT NULL,
    steps character varying,
    expected_result character varying,
    actual_result character varying,
    task_id integer NOT NULL
);


ALTER TABLE public.test_cases OWNER TO "ontezo-stagging-user";

--
-- TOC entry 245 (class 1259 OID 18155)
-- Name: test_cases_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.test_cases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.test_cases_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3853 (class 0 OID 0)
-- Dependencies: 245
-- Name: test_cases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.test_cases_id_seq OWNED BY public.test_cases.id;


--
-- TOC entry 248 (class 1259 OID 18169)
-- Name: time_logs; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.time_logs (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    hours double precision,
    description character varying,
    task_id integer NOT NULL,
    team_member_id integer NOT NULL
);


ALTER TABLE public.time_logs OWNER TO "ontezo-stagging-user";

--
-- TOC entry 247 (class 1259 OID 18168)
-- Name: time_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.time_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.time_logs_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3854 (class 0 OID 0)
-- Dependencies: 247
-- Name: time_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.time_logs_id_seq OWNED BY public.time_logs.id;


--
-- TOC entry 210 (class 1259 OID 17892)
-- Name: typeorm_migrations; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.typeorm_migrations (
    id integer NOT NULL,
    "timestamp" bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.typeorm_migrations OWNER TO "ontezo-stagging-user";

--
-- TOC entry 209 (class 1259 OID 17891)
-- Name: typeorm_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.typeorm_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.typeorm_migrations_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3855 (class 0 OID 0)
-- Dependencies: 209
-- Name: typeorm_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.typeorm_migrations_id_seq OWNED BY public.typeorm_migrations.id;


--
-- TOC entry 244 (class 1259 OID 18143)
-- Name: use_cases; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.use_cases (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    title character varying NOT NULL,
    description character varying,
    "isChecked" boolean DEFAULT false NOT NULL,
    task_id integer NOT NULL
);


ALTER TABLE public.use_cases OWNER TO "ontezo-stagging-user";

--
-- TOC entry 243 (class 1259 OID 18142)
-- Name: use_cases_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.use_cases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.use_cases_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3856 (class 0 OID 0)
-- Dependencies: 243
-- Name: use_cases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.use_cases_id_seq OWNED BY public.use_cases.id;


--
-- TOC entry 258 (class 1259 OID 18244)
-- Name: user_auth_providers; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.user_auth_providers (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    provider character varying NOT NULL,
    "socialId" character varying NOT NULL,
    "userId" integer
);


ALTER TABLE public.user_auth_providers OWNER TO "ontezo-stagging-user";

--
-- TOC entry 257 (class 1259 OID 18243)
-- Name: user_auth_providers_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.user_auth_providers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_auth_providers_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3857 (class 0 OID 0)
-- Dependencies: 257
-- Name: user_auth_providers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.user_auth_providers_id_seq OWNED BY public.user_auth_providers.id;


--
-- TOC entry 250 (class 1259 OID 18186)
-- Name: user_links; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.user_links (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    url character varying NOT NULL,
    description character varying,
    type character varying,
    platform public.user_links_platform_enum DEFAULT 'github'::public.user_links_platform_enum NOT NULL,
    task_id integer NOT NULL,
    team_member_id integer NOT NULL
);


ALTER TABLE public.user_links OWNER TO "ontezo-stagging-user";

--
-- TOC entry 249 (class 1259 OID 18185)
-- Name: user_links_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.user_links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_links_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3858 (class 0 OID 0)
-- Dependencies: 249
-- Name: user_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.user_links_id_seq OWNED BY public.user_links.id;


--
-- TOC entry 260 (class 1259 OID 18262)
-- Name: user_preferences; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.user_preferences (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    category public.user_preferences_category_enum NOT NULL,
    value text,
    user_id integer NOT NULL,
    "userId" integer
);


ALTER TABLE public.user_preferences OWNER TO "ontezo-stagging-user";

--
-- TOC entry 259 (class 1259 OID 18261)
-- Name: user_preferences_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.user_preferences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_preferences_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3859 (class 0 OID 0)
-- Dependencies: 259
-- Name: user_preferences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.user_preferences_id_seq OWNED BY public.user_preferences.id;


--
-- TOC entry 256 (class 1259 OID 18230)
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.user_profiles (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    full_name character varying,
    phone character varying,
    date_of_birth date,
    address character varying,
    city character varying,
    state character varying,
    postal_code character varying,
    country character varying,
    profile_picture character varying,
    is_profile_complete boolean DEFAULT false NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.user_profiles OWNER TO "ontezo-stagging-user";

--
-- TOC entry 255 (class 1259 OID 18229)
-- Name: user_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.user_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_profiles_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3860 (class 0 OID 0)
-- Dependencies: 255
-- Name: user_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.user_profiles_id_seq OWNED BY public.user_profiles.id;


--
-- TOC entry 271 (class 1259 OID 18360)
-- Name: user_roles; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.user_roles (
    "usersId" integer NOT NULL,
    "rolesId" integer NOT NULL
);


ALTER TABLE public.user_roles OWNER TO "ontezo-stagging-user";

--
-- TOC entry 262 (class 1259 OID 18273)
-- Name: users; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.users (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    email character varying NOT NULL,
    password character varying NOT NULL,
    otp_code character varying,
    is_email_verified boolean DEFAULT false NOT NULL,
    is_password_forget boolean DEFAULT false NOT NULL,
    otp_expiry timestamp without time zone,
    tenant_id integer,
    timezone character varying,
    last_login timestamp with time zone,
    is_agree_terms boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.users OWNER TO "ontezo-stagging-user";

--
-- TOC entry 261 (class 1259 OID 18272)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3861 (class 0 OID 0)
-- Dependencies: 261
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 212 (class 1259 OID 17901)
-- Name: webhook_events; Type: TABLE; Schema: public; Owner: ontezo-stagging-user
--

CREATE TABLE public.webhook_events (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    event_type character varying,
    payload json,
    status character varying,
    source character varying,
    target_url character varying,
    retry_count integer,
    error_message character varying
);


ALTER TABLE public.webhook_events OWNER TO "ontezo-stagging-user";

--
-- TOC entry 211 (class 1259 OID 17900)
-- Name: webhook_events_id_seq; Type: SEQUENCE; Schema: public; Owner: ontezo-stagging-user
--

CREATE SEQUENCE public.webhook_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.webhook_events_id_seq OWNER TO "ontezo-stagging-user";

--
-- TOC entry 3862 (class 0 OID 0)
-- Dependencies: 211
-- Name: webhook_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ontezo-stagging-user
--

ALTER SEQUENCE public.webhook_events_id_seq OWNED BY public.webhook_events.id;


--
-- TOC entry 3381 (class 2604 OID 17960)
-- Name: audit_log id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.audit_log ALTER COLUMN id SET DEFAULT nextval('public.audit_log_id_seq'::regclass);


--
-- TOC entry 3487 (class 2604 OID 82003)
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- TOC entry 3390 (class 2604 OID 17995)
-- Name: checklist_items id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.checklist_items ALTER COLUMN id SET DEFAULT nextval('public.checklist_items_id_seq'::regclass);


--
-- TOC entry 3394 (class 2604 OID 18007)
-- Name: checklists id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.checklists ALTER COLUMN id SET DEFAULT nextval('public.checklists_id_seq'::regclass);


--
-- TOC entry 3387 (class 2604 OID 17983)
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- TOC entry 3402 (class 2604 OID 18037)
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- TOC entry 3492 (class 2604 OID 86209)
-- Name: invites id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.invites ALTER COLUMN id SET DEFAULT nextval('public.invites_id_seq'::regclass);


--
-- TOC entry 3414 (class 2604 OID 18105)
-- Name: media id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.media ALTER COLUMN id SET DEFAULT nextval('public.media_id_seq'::regclass);


--
-- TOC entry 3419 (class 2604 OID 18119)
-- Name: media_records id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.media_records ALTER COLUMN id SET DEFAULT nextval('public.media_records_id_seq'::regclass);


--
-- TOC entry 3481 (class 2604 OID 18326)
-- Name: menu id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.menu ALTER COLUMN id SET DEFAULT nextval('public.menu_id_seq'::regclass);


--
-- TOC entry 3372 (class 2604 OID 17915)
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- TOC entry 3398 (class 2604 OID 18019)
-- Name: phases id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.phases ALTER COLUMN id SET DEFAULT nextval('public.phases_id_seq'::regclass);


--
-- TOC entry 3471 (class 2604 OID 18292)
-- Name: plans id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.plans ALTER COLUMN id SET DEFAULT nextval('public.plans_id_seq'::regclass);


--
-- TOC entry 3384 (class 2604 OID 17971)
-- Name: project_statuses id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.project_statuses ALTER COLUMN id SET DEFAULT nextval('public.project_statuses_id_seq'::regclass);


--
-- TOC entry 3422 (class 2604 OID 18129)
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- TOC entry 3490 (class 2604 OID 86143)
-- Name: role_permissions id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.role_permissions ALTER COLUMN id SET DEFAULT nextval('public.role_permissions_id_seq'::regclass);


--
-- TOC entry 3375 (class 2604 OID 17929)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 3407 (class 2604 OID 18054)
-- Name: sprint_statuses id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.sprint_statuses ALTER COLUMN id SET DEFAULT nextval('public.sprint_statuses_id_seq'::regclass);


--
-- TOC entry 3410 (class 2604 OID 18075)
-- Name: sprints id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.sprints ALTER COLUMN id SET DEFAULT nextval('public.sprints_id_seq'::regclass);


--
-- TOC entry 3476 (class 2604 OID 18311)
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- TOC entry 3443 (class 2604 OID 18202)
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- TOC entry 3450 (class 2604 OID 18219)
-- Name: team_members id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.team_members ALTER COLUMN id SET DEFAULT nextval('public.team_members_id_seq'::regclass);


--
-- TOC entry 3378 (class 2604 OID 17943)
-- Name: tenants id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.tenants ALTER COLUMN id SET DEFAULT nextval('public.tenants_id_seq'::regclass);


--
-- TOC entry 3432 (class 2604 OID 18159)
-- Name: test_cases id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.test_cases ALTER COLUMN id SET DEFAULT nextval('public.test_cases_id_seq'::regclass);


--
-- TOC entry 3436 (class 2604 OID 18172)
-- Name: time_logs id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.time_logs ALTER COLUMN id SET DEFAULT nextval('public.time_logs_id_seq'::regclass);


--
-- TOC entry 3368 (class 2604 OID 17895)
-- Name: typeorm_migrations id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.typeorm_migrations ALTER COLUMN id SET DEFAULT nextval('public.typeorm_migrations_id_seq'::regclass);


--
-- TOC entry 3428 (class 2604 OID 18146)
-- Name: use_cases id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.use_cases ALTER COLUMN id SET DEFAULT nextval('public.use_cases_id_seq'::regclass);


--
-- TOC entry 3457 (class 2604 OID 18247)
-- Name: user_auth_providers id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.user_auth_providers ALTER COLUMN id SET DEFAULT nextval('public.user_auth_providers_id_seq'::regclass);


--
-- TOC entry 3439 (class 2604 OID 18189)
-- Name: user_links id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.user_links ALTER COLUMN id SET DEFAULT nextval('public.user_links_id_seq'::regclass);


--
-- TOC entry 3460 (class 2604 OID 18265)
-- Name: user_preferences id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.user_preferences ALTER COLUMN id SET DEFAULT nextval('public.user_preferences_id_seq'::regclass);


--
-- TOC entry 3453 (class 2604 OID 18233)
-- Name: user_profiles id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.user_profiles ALTER COLUMN id SET DEFAULT nextval('public.user_profiles_id_seq'::regclass);


--
-- TOC entry 3463 (class 2604 OID 18276)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3369 (class 2604 OID 17904)
-- Name: webhook_events id; Type: DEFAULT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.webhook_events ALTER COLUMN id SET DEFAULT nextval('public.webhook_events_id_seq'::regclass);


--
-- TOC entry 3516 (class 2606 OID 17966)
-- Name: audit_log PK_07fefa57f7f5ab8fc3f52b3ed0b; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT "PK_07fefa57f7f5ab8fc3f52b3ed0b" PRIMARY KEY (id);


--
-- TOC entry 3546 (class 2606 OID 18123)
-- Name: media_records PK_157289ec3a019e636c67ea49f24; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.media_records
    ADD CONSTRAINT "PK_157289ec3a019e636c67ea49f24" PRIMARY KEY (id);


--
-- TOC entry 3622 (class 2606 OID 82009)
-- Name: audit_logs PK_1bb179d048bbc581caa3b013439; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT "PK_1bb179d048bbc581caa3b013439" PRIMARY KEY (id);


--
-- TOC entry 3576 (class 2606 OID 18240)
-- Name: user_profiles PK_1ec6662219f4605723f1e41b6cb; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT "PK_1ec6662219f4605723f1e41b6cb" PRIMARY KEY (id);


--
-- TOC entry 3526 (class 2606 OID 18014)
-- Name: checklists PK_336ade2047f3d713e1afa20d2c6; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.checklists
    ADD CONSTRAINT "PK_336ade2047f3d713e1afa20d2c6" PRIMARY KEY (id);


--
-- TOC entry 3602 (class 2606 OID 18335)
-- Name: menu PK_35b2a8f47d153ff7a41860cceeb; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.menu
    ADD CONSTRAINT "PK_35b2a8f47d153ff7a41860cceeb" PRIMARY KEY (id);


--
-- TOC entry 3589 (class 2606 OID 18300)
-- Name: plans PK_3720521a81c7c24fe9b7202ba61; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT "PK_3720521a81c7c24fe9b7202ba61" PRIMARY KEY (id);


--
-- TOC entry 3616 (class 2606 OID 18364)
-- Name: user_roles PK_38ffcfb865fc628fa337d9a0d4f; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT "PK_38ffcfb865fc628fa337d9a0d4f" PRIMARY KEY ("usersId", "rolesId");


--
-- TOC entry 3558 (class 2606 OID 18166)
-- Name: test_cases PK_39eb2dc90c54d7a036b015f05c4; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.test_cases
    ADD CONSTRAINT "PK_39eb2dc90c54d7a036b015f05c4" PRIMARY KEY (id);


--
-- TOC entry 3498 (class 2606 OID 17910)
-- Name: webhook_events PK_4cba37e6a0acb5e1fc49c34ebfd; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.webhook_events
    ADD CONSTRAINT "PK_4cba37e6a0acb5e1fc49c34ebfd" PRIMARY KEY (id);


--
-- TOC entry 3508 (class 2606 OID 17949)
-- Name: tenants PK_53be67a04681c66b87ee27c9321; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.tenants
    ADD CONSTRAINT "PK_53be67a04681c66b87ee27c9321" PRIMARY KEY (id);


--
-- TOC entry 3612 (class 2606 OID 18357)
-- Name: task_assignees PK_55716a6d7d7fa75334c2c5f02cf; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.task_assignees
    ADD CONSTRAINT "PK_55716a6d7d7fa75334c2c5f02cf" PRIMARY KEY (task_id, team_member_id);


--
-- TOC entry 3550 (class 2606 OID 18138)
-- Name: projects PK_6271df0a7aed1d6c0691ce6ac50; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT "PK_6271df0a7aed1d6c0691ce6ac50" PRIMARY KEY (id);


--
-- TOC entry 3541 (class 2606 OID 18082)
-- Name: sprints PK_6800aa2e0f508561812c4b9afb4; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.sprints
    ADD CONSTRAINT "PK_6800aa2e0f508561812c4b9afb4" PRIMARY KEY (id);


--
-- TOC entry 3608 (class 2606 OID 18350)
-- Name: project_assignees PK_7e0aa93b8510772e314b1e6559a; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.project_assignees
    ADD CONSTRAINT "PK_7e0aa93b8510772e314b1e6559a" PRIMARY KEY (project_id, team_member_id);


--
-- TOC entry 3624 (class 2606 OID 86146)
-- Name: role_permissions PK_84059017c90bfcb701b8fa42297; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT "PK_84059017c90bfcb701b8fa42297" PRIMARY KEY (id);


--
-- TOC entry 3561 (class 2606 OID 18178)
-- Name: time_logs PK_8657e6aaa7035da9fc7309f385a; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.time_logs
    ADD CONSTRAINT "PK_8657e6aaa7035da9fc7309f385a" PRIMARY KEY (id);


--
-- TOC entry 3531 (class 2606 OID 18044)
-- Name: comments PK_8bf68bc960f2b69e818bdb90dcb; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT "PK_8bf68bc960f2b69e818bdb90dcb" PRIMARY KEY (id);


--
-- TOC entry 3567 (class 2606 OID 18211)
-- Name: tasks PK_8d12ff38fcc62aaba2cab748772; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT "PK_8d12ff38fcc62aaba2cab748772" PRIMARY KEY (id);


--
-- TOC entry 3555 (class 2606 OID 18153)
-- Name: use_cases PK_9051865dd5ae654c69eced58574; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.use_cases
    ADD CONSTRAINT "PK_9051865dd5ae654c69eced58574" PRIMARY KEY (id);


--
-- TOC entry 3500 (class 2606 OID 17921)
-- Name: permissions PK_920331560282b8bd21bb02290df; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT "PK_920331560282b8bd21bb02290df" PRIMARY KEY (id);


--
-- TOC entry 3564 (class 2606 OID 18196)
-- Name: user_links PK_9eb83d225b238275d61eeedd8b1; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.user_links
    ADD CONSTRAINT "PK_9eb83d225b238275d61eeedd8b1" PRIMARY KEY (id);


--
-- TOC entry 3585 (class 2606 OID 18284)
-- Name: users PK_a3ffb1c0c8416b9fc6f907b7433; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);


--
-- TOC entry 3597 (class 2606 OID 18319)
-- Name: subscriptions PK_a87248d73155605cf782be9ee5e; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT "PK_a87248d73155605cf782be9ee5e" PRIMARY KEY (id);


--
-- TOC entry 3629 (class 2606 OID 86215)
-- Name: invites PK_aa52e96b44a714372f4dd31a0af; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT "PK_aa52e96b44a714372f4dd31a0af" PRIMARY KEY (id);


--
-- TOC entry 3519 (class 2606 OID 17977)
-- Name: project_statuses PK_b0ca0748cbeddc71d6bf76c2fa7; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.project_statuses
    ADD CONSTRAINT "PK_b0ca0748cbeddc71d6bf76c2fa7" PRIMARY KEY (id);


--
-- TOC entry 3539 (class 2606 OID 18060)
-- Name: sprint_statuses PK_b31b51a866c2b8c031be17fd154; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.sprint_statuses
    ADD CONSTRAINT "PK_b31b51a866c2b8c031be17fd154" PRIMARY KEY (id);


--
-- TOC entry 3524 (class 2606 OID 18002)
-- Name: checklist_items PK_bae00945a1d4789bd648e583e29; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.checklist_items
    ADD CONSTRAINT "PK_bae00945a1d4789bd648e583e29" PRIMARY KEY (id);


--
-- TOC entry 3496 (class 2606 OID 17899)
-- Name: typeorm_migrations PK_bb2f075707dd300ba86d0208923; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.typeorm_migrations
    ADD CONSTRAINT "PK_bb2f075707dd300ba86d0208923" PRIMARY KEY (id);


--
-- TOC entry 3505 (class 2606 OID 17935)
-- Name: roles PK_c1433d71a4838793a49dcad46ab; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT "PK_c1433d71a4838793a49dcad46ab" PRIMARY KEY (id);


--
-- TOC entry 3620 (class 2606 OID 18371)
-- Name: menu_closure PK_c81ac541666ce5929a897b1bae5; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.menu_closure
    ADD CONSTRAINT "PK_c81ac541666ce5929a897b1bae5" PRIMARY KEY (id_ancestor, id_descendant);


--
-- TOC entry 3572 (class 2606 OID 18225)
-- Name: team_members PK_ca3eae89dcf20c9fd95bf7460aa; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT "PK_ca3eae89dcf20c9fd95bf7460aa" PRIMARY KEY (id);


--
-- TOC entry 3580 (class 2606 OID 18253)
-- Name: user_auth_providers PK_e3b60f30b8112ac5bb474a2fe4b; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.user_auth_providers
    ADD CONSTRAINT "PK_e3b60f30b8112ac5bb474a2fe4b" PRIMARY KEY (id);


--
-- TOC entry 3582 (class 2606 OID 18271)
-- Name: user_preferences PK_e8cfb5b31af61cd363a6b6d7c25; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT "PK_e8cfb5b31af61cd363a6b6d7c25" PRIMARY KEY (id);


--
-- TOC entry 3529 (class 2606 OID 18026)
-- Name: phases PK_e93bb53460b28d4daf72735d5d3; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.phases
    ADD CONSTRAINT "PK_e93bb53460b28d4daf72735d5d3" PRIMARY KEY (id);


--
-- TOC entry 3522 (class 2606 OID 17989)
-- Name: clients PK_f1ab7cf3a5714dbc6bb4e1c28a4; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT "PK_f1ab7cf3a5714dbc6bb4e1c28a4" PRIMARY KEY (id);


--
-- TOC entry 3543 (class 2606 OID 18113)
-- Name: media PK_f4e0fcac36e050de337b670d8bd; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT "PK_f4e0fcac36e050de337b670d8bd" PRIMARY KEY (id);


--
-- TOC entry 3578 (class 2606 OID 18242)
-- Name: user_profiles REL_6ca9503d77ae39b4b5a6cc3ba8; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT "REL_6ca9503d77ae39b4b5a6cc3ba8" UNIQUE (user_id);


--
-- TOC entry 3574 (class 2606 OID 18227)
-- Name: team_members REL_c2bf4967c8c2a6b845dadfbf3d; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT "REL_c2bf4967c8c2a6b845dadfbf3d" UNIQUE (user_id);


--
-- TOC entry 3510 (class 2606 OID 17953)
-- Name: tenants UQ_21bb89e012fa5b58532009c1601; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.tenants
    ADD CONSTRAINT "UQ_21bb89e012fa5b58532009c1601" UNIQUE (subdomain);


--
-- TOC entry 3591 (class 2606 OID 18306)
-- Name: plans UQ_253d25dae4c94ee913bc5ec4850; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT "UQ_253d25dae4c94ee913bc5ec4850" UNIQUE (name);


--
-- TOC entry 3512 (class 2606 OID 17951)
-- Name: tenants UQ_32731f181236a46182a38c992a8; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.tenants
    ADD CONSTRAINT "UQ_32731f181236a46182a38c992a8" UNIQUE (name);


--
-- TOC entry 3599 (class 2606 OID 18321)
-- Name: subscriptions UQ_3a2d09d943f39912a01831a9272; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT "UQ_3a2d09d943f39912a01831a9272" UNIQUE (stripe_subscription_id);


--
-- TOC entry 3502 (class 2606 OID 17923)
-- Name: permissions UQ_48ce552495d14eae9b187bb6716; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT "UQ_48ce552495d14eae9b187bb6716" UNIQUE (name);


--
-- TOC entry 3604 (class 2606 OID 18337)
-- Name: menu UQ_4a648e48f7de4e4da77f7910d29; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.menu
    ADD CONSTRAINT "UQ_4a648e48f7de4e4da77f7910d29" UNIQUE (route);


--
-- TOC entry 3593 (class 2606 OID 18304)
-- Name: plans UQ_6e61112f9e80c7d419d85ca93dc; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT "UQ_6e61112f9e80c7d419d85ca93dc" UNIQUE (stripe_product_id);


--
-- TOC entry 3552 (class 2606 OID 18140)
-- Name: projects UQ_96e045ab8b0271e5f5a91eae1ee; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT "UQ_96e045ab8b0271e5f5a91eae1ee" UNIQUE (slug);


--
-- TOC entry 3587 (class 2606 OID 18286)
-- Name: users UQ_97672ac88f789774dd47f7c8be3; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE (email);


--
-- TOC entry 3569 (class 2606 OID 18213)
-- Name: tasks UQ_de87864b54eb03384b9845b2bac; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT "UQ_de87864b54eb03384b9845b2bac" UNIQUE (slug);


--
-- TOC entry 3595 (class 2606 OID 18302)
-- Name: plans UQ_fd5ce3c5becb7f6ec3c847ca906; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT "UQ_fd5ce3c5becb7f6ec3c847ca906" UNIQUE (stripe_price_id);


--
-- TOC entry 3626 (class 2606 OID 86148)
-- Name: role_permissions UQ_role_permission; Type: CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT "UQ_role_permission" UNIQUE (role_id, permission_id);


--
-- TOC entry 3520 (class 1259 OID 17990)
-- Name: IDX_0131566d07c5f535aa57af752b; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_0131566d07c5f535aa57af752b" ON public.clients USING btree (id, name);


--
-- TOC entry 3609 (class 1259 OID 18358)
-- Name: IDX_0141288f2306f20da9a60ec8d6; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_0141288f2306f20da9a60ec8d6" ON public.task_assignees USING btree (task_id);


--
-- TOC entry 3517 (class 1259 OID 17978)
-- Name: IDX_0d4acca7692a0ba8b2b74f44a1; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_0d4acca7692a0ba8b2b74f44a1" ON public.project_statuses USING btree (id, name, project_id);


--
-- TOC entry 3613 (class 1259 OID 18366)
-- Name: IDX_13380e7efec83468d73fc37938; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_13380e7efec83468d73fc37938" ON public.user_roles USING btree ("rolesId");


--
-- TOC entry 3617 (class 1259 OID 18372)
-- Name: IDX_2547be0cdfeccb9221c68976fd; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_2547be0cdfeccb9221c68976fd" ON public.menu_closure USING btree (id_ancestor);


--
-- TOC entry 3556 (class 1259 OID 18167)
-- Name: IDX_3fd64aee83521f62592e9a6ea5; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_3fd64aee83521f62592e9a6ea5" ON public.test_cases USING btree (id, title);


--
-- TOC entry 3562 (class 1259 OID 18197)
-- Name: IDX_517c35f2fc0dafb7f333b6d2ab; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_517c35f2fc0dafb7f333b6d2ab" ON public.user_links USING btree (id, task_id, team_member_id);


--
-- TOC entry 3565 (class 1259 OID 18214)
-- Name: IDX_5da4078ee97eebd957a605e22a; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_5da4078ee97eebd957a605e22a" ON public.tasks USING btree (id, title, project_id, slug);


--
-- TOC entry 3627 (class 1259 OID 86216)
-- Name: IDX_66477b1be90393256299aad39b; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_66477b1be90393256299aad39b" ON public.invites USING btree (id, email, "roleId");


--
-- TOC entry 3618 (class 1259 OID 18373)
-- Name: IDX_6a0038e7e00bb09a06ba3b1131; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_6a0038e7e00bb09a06ba3b1131" ON public.menu_closure USING btree (id_descendant);


--
-- TOC entry 3605 (class 1259 OID 18351)
-- Name: IDX_6ff495b45ab4853e84c3b06ab5; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_6ff495b45ab4853e84c3b06ab5" ON public.project_assignees USING btree (project_id);


--
-- TOC entry 3548 (class 1259 OID 18141)
-- Name: IDX_712ff534f697d0b6f5e67a6ad5; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_712ff534f697d0b6f5e67a6ad5" ON public.projects USING btree (id, name, slug);


--
-- TOC entry 3606 (class 1259 OID 18352)
-- Name: IDX_805c9619460737701ace926acb; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_805c9619460737701ace926acb" ON public.project_assignees USING btree (team_member_id);


--
-- TOC entry 3600 (class 1259 OID 18338)
-- Name: IDX_89821968b6c4ccc4f221db77a3; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_89821968b6c4ccc4f221db77a3" ON public.menu USING btree (name, is_visible, is_active, "order", group_by);


--
-- TOC entry 3614 (class 1259 OID 18365)
-- Name: IDX_99b019339f52c63ae615358738; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_99b019339f52c63ae615358738" ON public.user_roles USING btree ("usersId");


--
-- TOC entry 3570 (class 1259 OID 18228)
-- Name: IDX_ca3eae89dcf20c9fd95bf7460a; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE UNIQUE INDEX "IDX_ca3eae89dcf20c9fd95bf7460a" ON public.team_members USING btree (id);


--
-- TOC entry 3527 (class 1259 OID 18027)
-- Name: IDX_e45021e443c4323ad7e1ced367; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_e45021e443c4323ad7e1ced367" ON public.phases USING btree (id, name);


--
-- TOC entry 3583 (class 1259 OID 18287)
-- Name: IDX_e752aee509d8f8118c6e5b1d8c; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE UNIQUE INDEX "IDX_e752aee509d8f8118c6e5b1d8c" ON public.users USING btree (id, email);


--
-- TOC entry 3537 (class 1259 OID 18061)
-- Name: IDX_f3031fa22f7e18d67b2a0c8931; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_f3031fa22f7e18d67b2a0c8931" ON public.sprint_statuses USING btree (id, name, sprint_id);


--
-- TOC entry 3559 (class 1259 OID 18179)
-- Name: IDX_f9481fa6498d99f4526d4b47e4; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_f9481fa6498d99f4526d4b47e4" ON public.time_logs USING btree (id, task_id, team_member_id);


--
-- TOC entry 3610 (class 1259 OID 18359)
-- Name: IDX_fb04404d32a1afd2b4c978e3db; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_fb04404d32a1afd2b4c978e3db" ON public.task_assignees USING btree (team_member_id);


--
-- TOC entry 3553 (class 1259 OID 18154)
-- Name: IDX_fb9fc930f8d7351087ed57ef54; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX "IDX_fb9fc930f8d7351087ed57ef54" ON public.use_cases USING btree (id, title);


--
-- TOC entry 3532 (class 1259 OID 18049)
-- Name: idx_comment_content; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX idx_comment_content ON public.comments USING btree (content);


--
-- TOC entry 3533 (class 1259 OID 18048)
-- Name: idx_comment_parent_comment_id; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX idx_comment_parent_comment_id ON public.comments USING btree (parent_comment_id);


--
-- TOC entry 3534 (class 1259 OID 18046)
-- Name: idx_comment_project_id; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX idx_comment_project_id ON public.comments USING btree (project_id);


--
-- TOC entry 3535 (class 1259 OID 18045)
-- Name: idx_comment_task_id; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX idx_comment_task_id ON public.comments USING btree (task_id);


--
-- TOC entry 3536 (class 1259 OID 18047)
-- Name: idx_comment_team_member_id; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX idx_comment_team_member_id ON public.comments USING btree (team_member_id);


--
-- TOC entry 3544 (class 1259 OID 18114)
-- Name: idx_media_file_name; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX idx_media_file_name ON public.media USING btree (file_name);


--
-- TOC entry 3547 (class 1259 OID 18124)
-- Name: idx_media_record_relations; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE INDEX idx_media_record_relations ON public.media_records USING btree (user_id, project_id, task_id);


--
-- TOC entry 3503 (class 1259 OID 17924)
-- Name: permission_name_idx; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE UNIQUE INDEX permission_name_idx ON public.permissions USING btree (name);


--
-- TOC entry 3506 (class 1259 OID 90072)
-- Name: role_tenant_name_unique; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE UNIQUE INDEX role_tenant_name_unique ON public.roles USING btree (tenant_id, name);


--
-- TOC entry 3513 (class 1259 OID 17955)
-- Name: tenant_name_idx; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE UNIQUE INDEX tenant_name_idx ON public.tenants USING btree (name);


--
-- TOC entry 3514 (class 1259 OID 17954)
-- Name: tenant_subdomain_idx; Type: INDEX; Schema: public; Owner: ontezo-stagging-user
--

CREATE UNIQUE INDEX tenant_subdomain_idx ON public.tenants USING btree (subdomain);


--
-- TOC entry 3674 (class 2606 OID 18584)
-- Name: task_assignees FK_0141288f2306f20da9a60ec8d69; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.task_assignees
    ADD CONSTRAINT "FK_0141288f2306f20da9a60ec8d69" FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3637 (class 2606 OID 84763)
-- Name: comments FK_03dbde2ff570596e874bb3bb311; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT "FK_03dbde2ff570596e874bb3bb311" FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- TOC entry 3657 (class 2606 OID 18499)
-- Name: tasks FK_0804c9432857e4d333583f5afe1; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT "FK_0804c9432857e4d333583f5afe1" FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- TOC entry 3649 (class 2606 OID 84891)
-- Name: projects FK_091f9433895a53408cb8ae3864f; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT "FK_091f9433895a53408cb8ae3864f" FOREIGN KEY ("clientId") REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- TOC entry 3655 (class 2606 OID 18494)
-- Name: user_links FK_0f3960727e2d3f38027d5ce548e; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.user_links
    ADD CONSTRAINT "FK_0f3960727e2d3f38027d5ce548e" FOREIGN KEY (team_member_id) REFERENCES public.team_members(id) ON DELETE CASCADE;


--
-- TOC entry 3668 (class 2606 OID 18544)
-- Name: users FK_109638590074998bb72a2f2cf08; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "FK_109638590074998bb72a2f2cf08" FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- TOC entry 3632 (class 2606 OID 18379)
-- Name: project_statuses FK_12e48935c08ebc5ba11ec26d6bf; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.project_statuses
    ADD CONSTRAINT "FK_12e48935c08ebc5ba11ec26d6bf" FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- TOC entry 3676 (class 2606 OID 18599)
-- Name: user_roles FK_13380e7efec83468d73fc37938e; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT "FK_13380e7efec83468d73fc37938e" FOREIGN KEY ("rolesId") REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 3651 (class 2606 OID 18469)
-- Name: use_cases FK_15de65ea2a6711e4be3c4f3c6b7; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.use_cases
    ADD CONSTRAINT "FK_15de65ea2a6711e4be3c4f3c6b7" FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- TOC entry 3683 (class 2606 OID 86157)
-- Name: role_permissions FK_17022daf3f885f7d35423e9971e; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT "FK_17022daf3f885f7d35423e9971e" FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- TOC entry 3684 (class 2606 OID 86152)
-- Name: role_permissions FK_178199805b901ccd220ab7740ec; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT "FK_178199805b901ccd220ab7740ec" FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 3638 (class 2606 OID 84886)
-- Name: comments FK_18c2493067c11f44efb35ca0e03; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT "FK_18c2493067c11f44efb35ca0e03" FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- TOC entry 3671 (class 2606 OID 18559)
-- Name: menu FK_23ac1b81a7bfb85b14e86bd23a5; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.menu
    ADD CONSTRAINT "FK_23ac1b81a7bfb85b14e86bd23a5" FOREIGN KEY ("parentId") REFERENCES public.menu(id);


--
-- TOC entry 3678 (class 2606 OID 18604)
-- Name: menu_closure FK_2547be0cdfeccb9221c68976fd7; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.menu_closure
    ADD CONSTRAINT "FK_2547be0cdfeccb9221c68976fd7" FOREIGN KEY (id_ancestor) REFERENCES public.menu(id) ON DELETE CASCADE;


--
-- TOC entry 3680 (class 2606 OID 82012)
-- Name: audit_logs FK_29f9aab3dbed5978c3a24684e8a; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT "FK_29f9aab3dbed5978c3a24684e8a" FOREIGN KEY (team_member_id) REFERENCES public.team_members(id) ON DELETE CASCADE;


--
-- TOC entry 3666 (class 2606 OID 18534)
-- Name: user_auth_providers FK_344bc2c598846ecf8f58274fdaa; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.user_auth_providers
    ADD CONSTRAINT "FK_344bc2c598846ecf8f58274fdaa" FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- TOC entry 3658 (class 2606 OID 85631)
-- Name: tasks FK_54fc42a253a8338488ec1f960ad; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT "FK_54fc42a253a8338488ec1f960ad" FOREIGN KEY (parent_task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- TOC entry 3644 (class 2606 OID 18449)
-- Name: media_records FK_55a716c1d6c8907d927f6aa7ce7; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.media_records
    ADD CONSTRAINT "FK_55a716c1d6c8907d927f6aa7ce7" FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- TOC entry 3653 (class 2606 OID 18479)
-- Name: time_logs FK_5863acae12451e29b1414a3795c; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.time_logs
    ADD CONSTRAINT "FK_5863acae12451e29b1414a3795c" FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- TOC entry 3681 (class 2606 OID 82022)
-- Name: audit_logs FK_5e124016d61fe935a7f10ac3fa5; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT "FK_5e124016d61fe935a7f10ac3fa5" FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- TOC entry 3679 (class 2606 OID 18609)
-- Name: menu_closure FK_6a0038e7e00bb09a06ba3b11319; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.menu_closure
    ADD CONSTRAINT "FK_6a0038e7e00bb09a06ba3b11319" FOREIGN KEY (id_descendant) REFERENCES public.menu(id) ON DELETE CASCADE;


--
-- TOC entry 3665 (class 2606 OID 18529)
-- Name: user_profiles FK_6ca9503d77ae39b4b5a6cc3ba88; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT "FK_6ca9503d77ae39b4b5a6cc3ba88" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3636 (class 2606 OID 18399)
-- Name: phases FK_6ec6b200da7101a6cc19894ffbd; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.phases
    ADD CONSTRAINT "FK_6ec6b200da7101a6cc19894ffbd" FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- TOC entry 3672 (class 2606 OID 18574)
-- Name: project_assignees FK_6ff495b45ab4853e84c3b06ab51; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.project_assignees
    ADD CONSTRAINT "FK_6ff495b45ab4853e84c3b06ab51" FOREIGN KEY (project_id) REFERENCES public.projects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3652 (class 2606 OID 18474)
-- Name: test_cases FK_7b02d3083b96986d0361cfe4745; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.test_cases
    ADD CONSTRAINT "FK_7b02d3083b96986d0361cfe4745" FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- TOC entry 3673 (class 2606 OID 18579)
-- Name: project_assignees FK_805c9619460737701ace926acbe; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.project_assignees
    ADD CONSTRAINT "FK_805c9619460737701ace926acbe" FOREIGN KEY (team_member_id) REFERENCES public.team_members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3645 (class 2606 OID 81987)
-- Name: media_records FK_817d65ca9bef0a45e89bbbbb2f3; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.media_records
    ADD CONSTRAINT "FK_817d65ca9bef0a45e89bbbbb2f3" FOREIGN KEY (comment_id) REFERENCES public.comments(id) ON DELETE CASCADE;


--
-- TOC entry 3642 (class 2606 OID 84815)
-- Name: sprints FK_82145010051f3f2fc94671c0b35; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.sprints
    ADD CONSTRAINT "FK_82145010051f3f2fc94671c0b35" FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- TOC entry 3643 (class 2606 OID 18434)
-- Name: media FK_85864b5d9d32d0eb7b154b4b55b; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT "FK_85864b5d9d32d0eb7b154b4b55b" FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- TOC entry 3663 (class 2606 OID 18519)
-- Name: team_members FK_8b99ad56aac241d05e95af289d1; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT "FK_8b99ad56aac241d05e95af289d1" FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- TOC entry 3639 (class 2606 OID 82056)
-- Name: comments FK_93ce08bdbea73c0c7ee673ec35a; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT "FK_93ce08bdbea73c0c7ee673ec35a" FOREIGN KEY (parent_comment_id) REFERENCES public.comments(id) ON DELETE CASCADE;


--
-- TOC entry 3677 (class 2606 OID 18594)
-- Name: user_roles FK_99b019339f52c63ae6153587380; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT "FK_99b019339f52c63ae6153587380" FOREIGN KEY ("usersId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3659 (class 2606 OID 84896)
-- Name: tasks FK_9eecdb5b1ed8c7c2a1b392c28d4; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT "FK_9eecdb5b1ed8c7c2a1b392c28d4" FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- TOC entry 3654 (class 2606 OID 18484)
-- Name: time_logs FK_a2ec74f6520eb6bb57ea235fb4d; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.time_logs
    ADD CONSTRAINT "FK_a2ec74f6520eb6bb57ea235fb4d" FOREIGN KEY (team_member_id) REFERENCES public.team_members(id) ON DELETE CASCADE;


--
-- TOC entry 3656 (class 2606 OID 18489)
-- Name: user_links FK_b31dc94271a93cd29f0f31b0356; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.user_links
    ADD CONSTRAINT "FK_b31dc94271a93cd29f0f31b0356" FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- TOC entry 3635 (class 2606 OID 18394)
-- Name: checklists FK_b3df369f52f5bccc44a427aa261; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.checklists
    ADD CONSTRAINT "FK_b3df369f52f5bccc44a427aa261" FOREIGN KEY (phase_id) REFERENCES public.phases(id) ON DELETE CASCADE;


--
-- TOC entry 3646 (class 2606 OID 18439)
-- Name: media_records FK_b42b7493f2b00d09c39d969ff67; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.media_records
    ADD CONSTRAINT "FK_b42b7493f2b00d09c39d969ff67" FOREIGN KEY (media_id) REFERENCES public.media(id) ON DELETE CASCADE;


--
-- TOC entry 3660 (class 2606 OID 84807)
-- Name: tasks FK_b512d5a489d692f66569978b8a7; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT "FK_b512d5a489d692f66569978b8a7" FOREIGN KEY (sprint_id) REFERENCES public.sprints(id) ON DELETE SET NULL;


--
-- TOC entry 3667 (class 2606 OID 18539)
-- Name: user_preferences FK_b6202d1cacc63a0b9c8dac2abd4; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT "FK_b6202d1cacc63a0b9c8dac2abd4" FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3661 (class 2606 OID 86064)
-- Name: tasks FK_bde4de682df7f684549b847803d; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT "FK_bde4de682df7f684549b847803d" FOREIGN KEY (sprint_status_id) REFERENCES public.sprint_statuses(id) ON DELETE SET NULL;


--
-- TOC entry 3650 (class 2606 OID 18459)
-- Name: projects FK_c24760a4c22a838d6a8eb1fdc3a; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT "FK_c24760a4c22a838d6a8eb1fdc3a" FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- TOC entry 3664 (class 2606 OID 18524)
-- Name: team_members FK_c2bf4967c8c2a6b845dadfbf3d4; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT "FK_c2bf4967c8c2a6b845dadfbf3d4" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3641 (class 2606 OID 18424)
-- Name: sprint_statuses FK_c80453d9bd4090ff6c9fce88c75; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.sprint_statuses
    ADD CONSTRAINT "FK_c80453d9bd4090ff6c9fce88c75" FOREIGN KEY (sprint_id) REFERENCES public.sprints(id) ON DELETE CASCADE;


--
-- TOC entry 3631 (class 2606 OID 18374)
-- Name: audit_log FK_cb11bd5b662431ea0ac455a27d7; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT "FK_cb11bd5b662431ea0ac455a27d7" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3682 (class 2606 OID 82017)
-- Name: audit_logs FK_cdc15ea4d795d9a65791d915365; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT "FK_cdc15ea4d795d9a65791d915365" FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- TOC entry 3669 (class 2606 OID 18549)
-- Name: subscriptions FK_d0a95ef8a28188364c546eb65c1; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT "FK_d0a95ef8a28188364c546eb65c1" FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3633 (class 2606 OID 18384)
-- Name: clients FK_d2ac1947399a642a52f7eb50794; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT "FK_d2ac1947399a642a52f7eb50794" FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- TOC entry 3634 (class 2606 OID 18389)
-- Name: checklist_items FK_d98db409c26c6ed1a6d20c1bb0c; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.checklist_items
    ADD CONSTRAINT "FK_d98db409c26c6ed1a6d20c1bb0c" FOREIGN KEY (checklist_id) REFERENCES public.checklists(id) ON DELETE CASCADE;


--
-- TOC entry 3647 (class 2606 OID 18444)
-- Name: media_records FK_e15bf468f4a4aa268c954bcf1f5; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.media_records
    ADD CONSTRAINT "FK_e15bf468f4a4aa268c954bcf1f5" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3648 (class 2606 OID 18454)
-- Name: media_records FK_e43f5bde1fbe9f611740f776203; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.media_records
    ADD CONSTRAINT "FK_e43f5bde1fbe9f611740f776203" FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- TOC entry 3670 (class 2606 OID 18554)
-- Name: subscriptions FK_e45fca5d912c3a2fab512ac25dc; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT "FK_e45fca5d912c3a2fab512ac25dc" FOREIGN KEY (plan_id) REFERENCES public.plans(id);


--
-- TOC entry 3630 (class 2606 OID 90067)
-- Name: roles FK_e59a01f4fe46ebbece575d9a0fc; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT "FK_e59a01f4fe46ebbece575d9a0fc" FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- TOC entry 3662 (class 2606 OID 86069)
-- Name: tasks FK_e620f7d623e8a2b846512e7aab3; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT "FK_e620f7d623e8a2b846512e7aab3" FOREIGN KEY (project_status_id) REFERENCES public.project_statuses(id) ON DELETE SET NULL;


--
-- TOC entry 3640 (class 2606 OID 18414)
-- Name: comments FK_f57623e92e107a314303e432064; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT "FK_f57623e92e107a314303e432064" FOREIGN KEY (team_member_id) REFERENCES public.team_members(id);


--
-- TOC entry 3675 (class 2606 OID 18589)
-- Name: task_assignees FK_fb04404d32a1afd2b4c978e3db6; Type: FK CONSTRAINT; Schema: public; Owner: ontezo-stagging-user
--

ALTER TABLE ONLY public.task_assignees
    ADD CONSTRAINT "FK_fb04404d32a1afd2b4c978e3db6" FOREIGN KEY (team_member_id) REFERENCES public.team_members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3829 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2025-08-02 11:13:54

--
-- PostgreSQL database dump complete
--

