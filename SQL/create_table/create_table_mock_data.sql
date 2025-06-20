--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-06-21 01:34:50

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


CREATE FUNCTION public.trigger_set_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_timestamp() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 228 (class 1259 OID 16488)
-- Name: group_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_roles (
    group_id integer NOT NULL,
    role_id integer NOT NULL,
    added_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.group_roles OWNER TO postgres;

--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE group_roles; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.group_roles IS '連結群組(groups)與角色(roles)的多對多關聯表。';


--
-- TOC entry 222 (class 1259 OID 16421)
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groups (
    id integer NOT NULL,
    group_name character varying(100) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.groups OWNER TO postgres;

--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE groups; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.groups IS '權限群組，作為角色的容器，用以簡化使用者管理。群組本身是跨系統的。';


--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN groups.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.groups.id IS '群組唯一識別碼 (主鍵)。';


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN groups.group_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.groups.group_name IS '群組的顯示名稱，需唯一 (例如："行銷部門", "開發團隊")。';


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN groups.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.groups.description IS '群組的用途或職責描述。';


--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN groups.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.groups.created_at IS '群組建立時間。';


--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN groups.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.groups.updated_at IS '群組最後更新時間 (由觸發器自動維護)。';


--
-- TOC entry 221 (class 1259 OID 16420)
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.groups_id_seq OWNER TO postgres;

--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 221
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- TOC entry 230 (class 1259 OID 16648)
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    role_id integer NOT NULL,
    resource_id integer NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE permissions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.permissions IS '權限核心表，紀錄哪個角色(role)可以存取哪個資源(resource)。只要此表中有紀錄，即代表擁有權限。';


--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN permissions.role_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.permissions.role_id IS '外鍵，關聯到角色 (roles.id)。';


--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN permissions.resource_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.permissions.resource_id IS '外鍵，關聯到資源 (resources.id)。';


--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN permissions.granted_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.permissions.granted_at IS '權限被授予的時間。';


--
-- TOC entry 226 (class 1259 OID 16454)
-- Name: resources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resources (
    id integer NOT NULL,
    system_id integer NOT NULL,
    resource_name character varying(100) NOT NULL,
    resource_identifier character varying(255) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.resources OWNER TO postgres;

--
-- TOC entry 5026 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE resources; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.resources IS '定義需要被保護的資源，通常是API端點或特定功能頁面。';


--
-- TOC entry 5027 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN resources.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resources.id IS '資源唯一識別碼 (主鍵)。';


--
-- TOC entry 5028 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN resources.system_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resources.system_id IS '外鍵，關聯此資源所屬的系統 (systems.id)。';


--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN resources.resource_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resources.resource_name IS '資源的易讀名稱 (例如："取得客戶列表API")。';


--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN resources.resource_identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.resources.resource_identifier IS '資源的唯一識別符，在同一個系統內需唯一。格式建議為 "HTTP方法:路徑" (例如："GET:/api/v1/users")。';


--
-- TOC entry 225 (class 1259 OID 16453)
-- Name: resources_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resources_id_seq OWNER TO postgres;

--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 225
-- Name: resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.resources_id_seq OWNED BY public.resources.id;


--
-- TOC entry 224 (class 1259 OID 16435)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    system_id integer NOT NULL,
    role_name character varying(50) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 5032 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE roles; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.roles IS '定義在特定系統中的角色，是權限的具體指派對象。';


--
-- TOC entry 5033 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN roles.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.roles.id IS '角色唯一識別碼 (主鍵)。';


--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN roles.system_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.roles.system_id IS '外鍵，關聯此角色所屬的系統 (systems.id)。';


--
-- TOC entry 5035 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN roles.role_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.roles.role_name IS '角色名稱 (例如："管理員", "訪客")，在同一個系統內需唯一。';


--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN roles.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.roles.description IS '角色的職責描述。';


--
-- TOC entry 223 (class 1259 OID 16434)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- TOC entry 5037 (class 0 OID 0)
-- Dependencies: 223
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 218 (class 1259 OID 16390)
-- Name: systems; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.systems (
    id integer NOT NULL,
    system_name character varying(100) NOT NULL,
    client_id character varying(50) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.systems OWNER TO postgres;

--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE systems; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.systems IS '註冊所有會對接此權限系統的應用程式或服務。';


--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN systems.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.systems.id IS '系統唯一識別碼 (主鍵)。';


--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN systems.system_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.systems.system_name IS '系統的顯示名稱，需唯一 (例如："客戶關係管理系統")。';


--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN systems.client_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.systems.client_id IS '系統的機器可讀ID，用於API溝通，需唯一 (例如："crm-backend")。';


--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN systems.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.systems.description IS '系統功能描述。';


--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN systems.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.systems.created_at IS '系統註冊時間。';


--
-- TOC entry 217 (class 1259 OID 16389)
-- Name: systems_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.systems_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.systems_id_seq OWNER TO postgres;

--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 217
-- Name: systems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.systems_id_seq OWNED BY public.systems.id;


--
-- TOC entry 227 (class 1259 OID 16472)
-- Name: user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_groups (
    user_id integer NOT NULL,
    group_id integer NOT NULL,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_groups OWNER TO postgres;

--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE user_groups; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.user_groups IS '連結使用者(users)與群組(groups)的多對多關聯表。';


--
-- TOC entry 229 (class 1259 OID 16504)
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    user_id integer NOT NULL,
    role_id integer NOT NULL,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE user_roles; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.user_roles IS '連結使用者(users)與角色(roles)的多對多關聯表，用於指派特殊或個人化權限。';


--
-- TOC entry 220 (class 1259 OID 16404)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    user_number character varying(50) NOT NULL,
    hashed_password character varying(255) NOT NULL,
    email character varying(100) NOT NULL,
    full_name character varying(100),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.users IS '儲存所有系統的使用者基本資訊。';


--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN users.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.id IS '使用者唯一識別碼 (主鍵)。';


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN users.user_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.user_number IS '使用者登入帳號，需唯一。';


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN users.hashed_password; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.hashed_password IS '使用 bcrypt 或 Argon2 等演算法加密後的密碼。';


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN users.email; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.email IS '使用者電子郵件，需唯一，可用於密碼重設。';


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN users.full_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.full_name IS '使用者全名或暱稱。';


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN users.is_active; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.is_active IS '帳號是否啟用，可用於軟刪除或暫時停權。';


--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN users.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.created_at IS '帳號建立時間。';


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN users.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.updated_at IS '帳號最後更新時間 (由觸發器自動維護)。';


--
-- TOC entry 219 (class 1259 OID 16403)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4786 (class 2604 OID 16737)
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- TOC entry 4792 (class 2604 OID 16757)
-- Name: resources id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources ALTER COLUMN id SET DEFAULT nextval('public.resources_id_seq'::regclass);


--
-- TOC entry 4789 (class 2604 OID 16773)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 4780 (class 2604 OID 16393)
-- Name: systems id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.systems ALTER COLUMN id SET DEFAULT nextval('public.systems_id_seq'::regclass);


--
-- TOC entry 4782 (class 2604 OID 16824)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 5006 (class 0 OID 16488)
-- Dependencies: 228
-- Data for Name: group_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.group_roles VALUES (1, 1, '2025-06-19 14:31:02.652248+08');
INSERT INTO public.group_roles VALUES (1, 5, '2025-06-19 14:31:02.652248+08');
INSERT INTO public.group_roles VALUES (2, 3, '2025-06-19 14:31:02.652248+08');
INSERT INTO public.group_roles VALUES (3, 6, '2025-06-19 14:31:02.652248+08');


--
-- TOC entry 5000 (class 0 OID 16421)
-- Dependencies: 222
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.groups VALUES (1, 'Administrators', '擁有所有系統最高權限的超級管理員群組。', '2025-06-19 14:31:02.652248+08', '2025-06-19 14:31:02.652248+08');
INSERT INTO public.groups VALUES (2, 'CRM Sales Team', 'CRM 系統的業務團隊，包含經理與專員。', '2025-06-19 14:31:02.652248+08', '2025-06-19 14:31:02.652248+08');
INSERT INTO public.groups VALUES (3, 'ERP Logistics Team', 'ERP 系統的物流與倉儲管理團隊。', '2025-06-19 14:31:02.652248+08', '2025-06-19 14:31:02.652248+08');


--
-- TOC entry 5008 (class 0 OID 16648)
-- Dependencies: 230
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.permissions VALUES (1, 1, '2025-06-19 14:53:31.566951+08');
INSERT INTO public.permissions VALUES (1, 2, '2025-06-19 14:53:31.566951+08');
INSERT INTO public.permissions VALUES (1, 3, '2025-06-19 14:53:31.566951+08');
INSERT INTO public.permissions VALUES (1, 4, '2025-06-19 14:53:31.566951+08');
INSERT INTO public.permissions VALUES (2, 4, '2025-06-19 14:53:31.566951+08');
INSERT INTO public.permissions VALUES (3, 1, '2025-06-19 14:53:31.566951+08');
INSERT INTO public.permissions VALUES (3, 2, '2025-06-19 14:53:31.566951+08');
INSERT INTO public.permissions VALUES (4, 1, '2025-06-19 14:53:31.566951+08');
INSERT INTO public.permissions VALUES (5, 5, '2025-06-19 14:53:31.566951+08');
INSERT INTO public.permissions VALUES (5, 6, '2025-06-19 14:53:31.566951+08');
INSERT INTO public.permissions VALUES (5, 7, '2025-06-19 14:53:31.566951+08');
INSERT INTO public.permissions VALUES (6, 5, '2025-06-19 14:53:31.566951+08');
INSERT INTO public.permissions VALUES (6, 6, '2025-06-19 14:53:31.566951+08');
INSERT INTO public.permissions VALUES (6, 7, '2025-06-19 14:53:31.566951+08');


--
-- TOC entry 5004 (class 0 OID 16454)
-- Dependencies: 226
-- Data for Name: resources; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.resources VALUES (1, 1, '讀取客戶列表', 'GET:/api/crm/customers', NULL, '2025-06-19 14:31:02.652248+08', '2025-06-19 14:31:02.652248+08');
INSERT INTO public.resources VALUES (2, 1, '新增/修改客戶', 'POST:/api/crm/customers', NULL, '2025-06-19 14:31:02.652248+08', '2025-06-19 14:31:02.652248+08');
INSERT INTO public.resources VALUES (3, 1, '刪除客戶', 'DELETE:/api/crm/customers/:id', NULL, '2025-06-19 14:31:02.652248+08', '2025-06-19 14:31:02.652248+08');
INSERT INTO public.resources VALUES (4, 1, '查看銷售報告', 'GET:/api/crm/reports', NULL, '2025-06-19 14:31:02.652248+08', '2025-06-19 14:31:02.652248+08');
INSERT INTO public.resources VALUES (5, 2, '讀取庫存資訊', 'GET:/api/erp/inventory', NULL, '2025-06-19 14:31:02.652248+08', '2025-06-19 14:31:02.652248+08');
INSERT INTO public.resources VALUES (6, 2, '更新庫存', 'PUT:/api/erp/inventory/:id', NULL, '2025-06-19 14:31:02.652248+08', '2025-06-19 14:31:02.652248+08');
INSERT INTO public.resources VALUES (7, 2, '建立出貨單', 'POST:/api/erp/shipments', NULL, '2025-06-19 14:31:02.652248+08', '2025-06-19 14:31:02.652248+08');


--
-- TOC entry 5002 (class 0 OID 16435)
-- Dependencies: 224
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles VALUES (1, 1, 'CRM Admin', 'CRM 系統的最高管理員。', '2025-06-19 14:31:02.652248+08', '2025-06-19 14:31:02.652248+08');
INSERT INTO public.roles VALUES (2, 1, 'Sales Manager', '業務經理，可查看銷售報告。', '2025-06-19 14:31:02.652248+08', '2025-06-19 14:31:02.652248+08');
INSERT INTO public.roles VALUES (3, 1, 'Sales Rep', '業務專員，負責客戶資料維護。', '2025-06-19 14:31:02.652248+08', '2025-06-19 14:31:02.652248+08');
INSERT INTO public.roles VALUES (4, 1, 'Guest Viewer', '訪客，僅有最低的讀取權限。', '2025-06-19 14:31:02.652248+08', '2025-06-19 14:31:02.652248+08');
INSERT INTO public.roles VALUES (5, 2, 'ERP Admin', 'ERP 系統的最高管理員。', '2025-06-19 14:31:02.652248+08', '2025-06-19 14:31:02.652248+08');
INSERT INTO public.roles VALUES (6, 2, 'Warehouse Manager', '倉儲主管，負責庫存與出貨管理。', '2025-06-19 14:31:02.652248+08', '2025-06-19 14:31:02.652248+08');


--
-- TOC entry 4996 (class 0 OID 16390)
-- Dependencies: 218
-- Data for Name: systems; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.systems VALUES (1, '客戶關係管理系統 (CRM)', 'crm-backend', '用於管理客戶、訂單和銷售報告的系統。', '2025-06-19 14:31:02.652248+08');
INSERT INTO public.systems VALUES (2, '企業資源規劃系統 (ERP)', 'erp-backend', '用於管理庫存、供應商和出貨的系統。', '2025-06-19 14:31:02.652248+08');


--
-- TOC entry 5005 (class 0 OID 16472)
-- Dependencies: 227
-- Data for Name: user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_groups VALUES (1, 1, '2025-06-19 14:31:02.652248+08');
INSERT INTO public.user_groups VALUES (2, 2, '2025-06-19 14:31:02.652248+08');
INSERT INTO public.user_groups VALUES (3, 2, '2025-06-19 14:31:02.652248+08');
INSERT INTO public.user_groups VALUES (4, 3, '2025-06-19 14:31:02.652248+08');


--
-- TOC entry 5007 (class 0 OID 16504)
-- Dependencies: 229
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_roles VALUES (2, 2, '2025-06-19 14:31:02.652248+08');
INSERT INTO public.user_roles VALUES (5, 4, '2025-06-19 14:31:02.652248+08');
INSERT INTO public.user_roles VALUES (2, 4, '2025-06-20 18:31:44.868628+08');


--
-- TOC entry 4998 (class 0 OID 16404)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES (1, '0001', '$2b$12$D9e1s2t3h4i5n6g7f8o9.uO3g4h5j6k7l8m9n0o1p2q3r4s5t', 'alice@example.com', 'Alice Smith (Admin)', true, '2025-06-19 14:31:02.652248+08', '2025-06-19 14:55:14.373436+08');
INSERT INTO public.users VALUES (2, '0002', '$2b$12$D9e1s2t3h4i5n6g7f8o9.uO3g4h5j6k7l8m9n0o1p2q3r4s5t', 'bob@example.com', 'Bob Johnson (Manager)', true, '2025-06-19 14:31:02.652248+08', '2025-06-19 14:55:14.373436+08');
INSERT INTO public.users VALUES (3, '0003', '$2b$12$D9e1s2t3h4i5n6g7f8o9.uO3g4h5j6k7l8m9n0o1p2q3r4s5t', 'carol@example.com', 'Carol Williams (Sales)', true, '2025-06-19 14:31:02.652248+08', '2025-06-19 14:55:14.373436+08');
INSERT INTO public.users VALUES (4, '0004', '$2b$12$D9e1s2t3h4i5n6g7f8o9.uO3g4h5j6k7l8m9n0o1p2q3r4s5t', 'dave@example.com', 'Dave Brown (Logistics)', true, '2025-06-19 14:31:02.652248+08', '2025-06-19 14:55:14.373436+08');
INSERT INTO public.users VALUES (5, '0005', '$2b$12$D9e1s2t3h4i5n6g7f8o9.uO3g4h5j6k7l8m9n0o1p2q3r4s5t', 'eve@example.com', 'Eve Davis (Guest)', false, '2025-06-19 14:31:02.652248+08', '2025-06-19 14:55:14.373436+08');


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 221
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.groups_id_seq', 1, false);


--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 225
-- Name: resources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.resources_id_seq', 1, false);


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 223
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 1, false);


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 217
-- Name: systems_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.systems_id_seq', 1, false);


--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- TOC entry 4829 (class 2606 OID 16725)
-- Name: group_roles group_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_roles
    ADD CONSTRAINT group_roles_pkey PRIMARY KEY (group_id, role_id);


--
-- TOC entry 4812 (class 2606 OID 16432)
-- Name: groups groups_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_group_name_key UNIQUE (group_name);


--
-- TOC entry 4814 (class 2606 OID 16739)
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- TOC entry 4835 (class 2606 OID 16676)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (role_id, resource_id);


--
-- TOC entry 4822 (class 2606 OID 16759)
-- Name: resources resources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
-- TOC entry 4824 (class 2606 OID 16465)
-- Name: resources resources_system_id_resource_identifier_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_system_id_resource_identifier_key UNIQUE (system_id, resource_identifier);


--
-- TOC entry 4817 (class 2606 OID 16775)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4819 (class 2606 OID 16446)
-- Name: roles roles_system_id_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_system_id_role_name_key UNIQUE (system_id, role_name);


--
-- TOC entry 4800 (class 2606 OID 16402)
-- Name: systems systems_client_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.systems
    ADD CONSTRAINT systems_client_id_key UNIQUE (client_id);


--
-- TOC entry 4802 (class 2606 OID 16398)
-- Name: systems systems_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.systems
    ADD CONSTRAINT systems_pkey PRIMARY KEY (id);


--
-- TOC entry 4804 (class 2606 OID 16400)
-- Name: systems systems_system_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.systems
    ADD CONSTRAINT systems_system_name_key UNIQUE (system_name);


--
-- TOC entry 4827 (class 2606 OID 16812)
-- Name: user_groups user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (user_id, group_id);


--
-- TOC entry 4833 (class 2606 OID 16699)
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- TOC entry 4806 (class 2606 OID 16418)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4808 (class 2606 OID 16826)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4810 (class 2606 OID 16416)
-- Name: users users_user_account_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_user_account_key UNIQUE (user_number);


--
-- TOC entry 4830 (class 1259 OID 16726)
-- Name: idx_group_roles_on_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_group_roles_on_role_id ON public.group_roles USING btree (role_id);


--
-- TOC entry 4820 (class 1259 OID 16547)
-- Name: idx_resources_on_system_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_resources_on_system_id ON public.resources USING btree (system_id);


--
-- TOC entry 4815 (class 1259 OID 16546)
-- Name: idx_roles_on_system_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_roles_on_system_id ON public.roles USING btree (system_id);


--
-- TOC entry 4825 (class 1259 OID 16813)
-- Name: idx_user_groups_on_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_groups_on_group_id ON public.user_groups USING btree (group_id);


--
-- TOC entry 4831 (class 1259 OID 16700)
-- Name: idx_user_roles_on_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_roles_on_role_id ON public.user_roles USING btree (role_id);


--
-- TOC entry 4847 (class 2620 OID 16433)
-- Name: groups set_timestamp_groups; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_timestamp_groups BEFORE UPDATE ON public.groups FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 4849 (class 2620 OID 16471)
-- Name: resources set_timestamp_resources; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_timestamp_resources BEFORE UPDATE ON public.resources FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 4848 (class 2620 OID 16452)
-- Name: roles set_timestamp_roles; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_timestamp_roles BEFORE UPDATE ON public.roles FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 4846 (class 2620 OID 16419)
-- Name: users set_timestamp_users; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_timestamp_users BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 4840 (class 2606 OID 16745)
-- Name: group_roles group_roles_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_roles
    ADD CONSTRAINT group_roles_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- TOC entry 4841 (class 2606 OID 16786)
-- Name: group_roles group_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_roles
    ADD CONSTRAINT group_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 4844 (class 2606 OID 16760)
-- Name: permissions permissions_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.resources(id) ON DELETE CASCADE;


--
-- TOC entry 4845 (class 2606 OID 16776)
-- Name: permissions permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 4837 (class 2606 OID 16466)
-- Name: resources resources_system_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_system_id_fkey FOREIGN KEY (system_id) REFERENCES public.systems(id) ON DELETE CASCADE;


--
-- TOC entry 4836 (class 2606 OID 16447)
-- Name: roles roles_system_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_system_id_fkey FOREIGN KEY (system_id) REFERENCES public.systems(id) ON DELETE CASCADE;


--
-- TOC entry 4838 (class 2606 OID 16814)
-- Name: user_groups user_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- TOC entry 4839 (class 2606 OID 16832)
-- Name: user_groups user_groups_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4842 (class 2606 OID 16781)
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 4843 (class 2606 OID 16827)
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- Completed on 2025-06-21 01:34:50

--
-- PostgreSQL database dump complete
--

