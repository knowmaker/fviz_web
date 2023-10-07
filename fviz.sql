PGDMP     3                	    {            fviz    12.12    12.12 n    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    62417    fviz    DATABASE     �   CREATE DATABASE fviz WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Russian_Russia.1251' LC_CTYPE = 'Russian_Russia.1251';
    DROP DATABASE fviz;
                postgres    false            �            1255    97638    combination_array()    FUNCTION       CREATE FUNCTION public.combination_array() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.combination = ARRAY(SELECT unnest(ARRAY[NEW.first_element, NEW.second_element, NEW.third_element, NEW.fourth_element]) ORDER BY 1);
  RETURN NEW;
END;
$$;
 *   DROP FUNCTION public.combination_array();
       public          postgres    false            �            1255    89065    insert_users_trigger()    FUNCTION     �  CREATE FUNCTION public.insert_users_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_represent_id INT;
BEGIN
	INSERT INTO represents(title, id_user, active_quantities) VALUES ('Базовое', NEW.id_user, ARRAY[1, 2, 3, 4, 5, 6, 8, 10, 11, 12, 14, 15, 17, 19, 22, 23, 26, 28, 30, 33, 37, 38, 40, 41, 43, 45, 51, 54, 58, 60, 64, 65, 66, 70, 74, 77, 79, 80, 81, 82, 84, 87, 93, 95, 100, 101, 102, 103, 105, 109, 110, 112, 113, 115, 116, 119, 120]);
	
	SELECT id_repr INTO new_represent_id FROM represents WHERE id_user = NEW.id_user ORDER BY id_repr DESC LIMIT 1;

    UPDATE users
    SET active_repr = new_represent_id
    WHERE id_user = NEW.id_user;

    RETURN NEW;
END;
$$;
 -   DROP FUNCTION public.insert_users_trigger();
       public          postgres    false            �            1255    97659    remove_quantity_id()    FUNCTION       CREATE FUNCTION public.remove_quantity_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE represents
    SET active_quantities = array_remove(represents.active_quantities, OLD.id_value)
    WHERE OLD.id_value = ANY(represents.active_quantities);
	RETURN OLD;
END;
$$;
 +   DROP FUNCTION public.remove_quantity_id();
       public          postgres    false            �            1255    97686    update_active_repr()    FUNCTION       CREATE FUNCTION public.update_active_repr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE users
  SET active_repr = (SELECT id_repr FROM represents WHERE id_repr <> OLD.id_repr AND id_user = OLD.id_user LIMIT 1)
  WHERE id_user = OLD.id_user;

  RETURN OLD;
END;
$$;
 +   DROP FUNCTION public.update_active_repr();
       public          postgres    false            �            1255    97612    update_mlti_sign_function()    FUNCTION     6  CREATE FUNCTION public.update_mlti_sign_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.mlti_sign = (
    CASE
      WHEN NEW.m_indicate_auto <> 0 THEN ('M<sup>' || NEW.m_indicate_auto || '</sup>')
      ELSE ''
    END ||
    CASE
      WHEN NEW.l_indicate_auto <> 0 THEN ('L<sup>' || NEW.l_indicate_auto || '</sup>')
      ELSE ''
    END ||
    CASE
      WHEN NEW.t_indicate_auto <> 0 THEN ('T<sup>' || NEW.t_indicate_auto || '</sup>')
      ELSE ''
    END ||
    CASE
      WHEN NEW.i_indicate_auto <> 0 THEN ('I<sup>' || NEW.i_indicate_auto || '</sup>')
      ELSE ''
    END ||
    CASE
      WHEN NEW.m_indicate_auto = 0 AND NEW.l_indicate_auto = 0 AND NEW.t_indicate_auto = 0 AND NEW.i_indicate_auto = 0 THEN 'L<sup>0</sup>T<sup>0</sup>'
      ELSE ''
    END
  );
  RETURN NEW;
END;
$$;
 2   DROP FUNCTION public.update_mlti_sign_function();
       public          postgres    false            �            1259    89193    ar_internal_metadata    TABLE     �   CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 (   DROP TABLE public.ar_internal_metadata;
       public         heap    postgres    false            �            1259    80715    gk    TABLE     �   CREATE TABLE public.gk (
    id_gk integer NOT NULL,
    g_indicate smallint NOT NULL,
    k_indicate smallint NOT NULL,
    gk_sign character varying(50),
    color character varying(50) NOT NULL
);
    DROP TABLE public.gk;
       public         heap    postgres    false            �            1259    80713    gk_id_gk_seq    SEQUENCE     �   CREATE SEQUENCE public.gk_id_gk_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.gk_id_gk_seq;
       public          postgres    false    205            �           0    0    gk_id_gk_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.gk_id_gk_seq OWNED BY public.gk.id_gk;
          public          postgres    false    204            �            1259    105883    gk_translations    TABLE     �   CREATE TABLE public.gk_translations (
    id_gk_transl integer NOT NULL,
    gk_name character varying(100) NOT NULL,
    locale character varying(2) NOT NULL,
    id_gk integer NOT NULL
);
 #   DROP TABLE public.gk_translations;
       public         heap    postgres    false            �            1259    105881     gk_translations_id_gk_transl_seq    SEQUENCE     �   CREATE SEQUENCE public.gk_translations_id_gk_transl_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public.gk_translations_id_gk_transl_seq;
       public          postgres    false    221            �           0    0     gk_translations_id_gk_transl_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public.gk_translations_id_gk_transl_seq OWNED BY public.gk_translations.id_gk_transl;
          public          postgres    false    220            �            1259    105869 	   law_types    TABLE     j   CREATE TABLE public.law_types (
    id_type integer NOT NULL,
    color character varying(50) NOT NULL
);
    DROP TABLE public.law_types;
       public         heap    postgres    false            �            1259    105867    law_types_id_type_seq    SEQUENCE     �   CREATE SEQUENCE public.law_types_id_type_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.law_types_id_type_seq;
       public          postgres    false    219            �           0    0    law_types_id_type_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.law_types_id_type_seq OWNED BY public.law_types.id_type;
          public          postgres    false    218            �            1259    105904    law_types_translations    TABLE     �   CREATE TABLE public.law_types_translations (
    id_type_transl integer NOT NULL,
    type_name character varying(100) NOT NULL,
    locale character varying(2) NOT NULL,
    id_type integer NOT NULL
);
 *   DROP TABLE public.law_types_translations;
       public         heap    postgres    false            �            1259    105902 )   law_types_translations_id_type_transl_seq    SEQUENCE     �   CREATE SEQUENCE public.law_types_translations_id_type_transl_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 @   DROP SEQUENCE public.law_types_translations_id_type_transl_seq;
       public          postgres    false    223            �           0    0 )   law_types_translations_id_type_transl_seq    SEQUENCE OWNED BY     w   ALTER SEQUENCE public.law_types_translations_id_type_transl_seq OWNED BY public.law_types_translations.id_type_transl;
          public          postgres    false    222            �            1259    80731    laws    TABLE     :  CREATE TABLE public.laws (
    id_law integer NOT NULL,
    law_name character varying,
    first_element integer NOT NULL,
    second_element integer NOT NULL,
    third_element integer NOT NULL,
    fourth_element integer NOT NULL,
    id_user integer NOT NULL,
    id_type integer,
    combination integer[]
);
    DROP TABLE public.laws;
       public         heap    postgres    false            �            1259    80729    laws_id_law_seq    SEQUENCE     �   CREATE SEQUENCE public.laws_id_law_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.laws_id_law_seq;
       public          postgres    false    207            �           0    0    laws_id_law_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.laws_id_law_seq OWNED BY public.laws.id_law;
          public          postgres    false    206            �            1259    80750    lt    TABLE     �   CREATE TABLE public.lt (
    id_lt integer NOT NULL,
    l_indicate smallint NOT NULL,
    t_indicate smallint NOT NULL,
    lt_sign character varying(50)
);
    DROP TABLE public.lt;
       public         heap    postgres    false            �            1259    80748    lt_id_lt_seq    SEQUENCE     �   CREATE SEQUENCE public.lt_id_lt_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.lt_id_lt_seq;
       public          postgres    false    209            �           0    0    lt_id_lt_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.lt_id_lt_seq OWNED BY public.lt.id_lt;
          public          postgres    false    208            �            1259    80758    quantity    TABLE     ]  CREATE TABLE public.quantity (
    id_value integer NOT NULL,
    symbol character varying(100),
    m_indicate_auto smallint NOT NULL,
    l_indicate_auto smallint NOT NULL,
    t_indicate_auto smallint NOT NULL,
    i_indicate_auto smallint NOT NULL,
    id_lt integer NOT NULL,
    id_gk integer NOT NULL,
    mlti_sign character varying(100)
);
    DROP TABLE public.quantity;
       public         heap    postgres    false            �            1259    80756    quantity_id_value_seq    SEQUENCE     �   CREATE SEQUENCE public.quantity_id_value_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.quantity_id_value_seq;
       public          postgres    false    211            �           0    0    quantity_id_value_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.quantity_id_value_seq OWNED BY public.quantity.id_value;
          public          postgres    false    210            �            1259    105922    quantity_translations    TABLE     �   CREATE TABLE public.quantity_translations (
    id_value_transl integer NOT NULL,
    value_name character varying(200),
    unit character varying(100),
    locale character varying(2) NOT NULL,
    id_value integer NOT NULL
);
 )   DROP TABLE public.quantity_translations;
       public         heap    postgres    false            �            1259    105920 )   quantity_translations_id_value_transl_seq    SEQUENCE     �   CREATE SEQUENCE public.quantity_translations_id_value_transl_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 @   DROP SEQUENCE public.quantity_translations_id_value_transl_seq;
       public          postgres    false    225            �           0    0 )   quantity_translations_id_value_transl_seq    SEQUENCE OWNED BY     w   ALTER SEQUENCE public.quantity_translations_id_value_transl_seq OWNED BY public.quantity_translations.id_value_transl;
          public          postgres    false    224            �            1259    80766 
   represents    TABLE     �   CREATE TABLE public.represents (
    id_repr integer NOT NULL,
    title character varying(100),
    id_user integer NOT NULL,
    active_quantities integer[] NOT NULL
);
    DROP TABLE public.represents;
       public         heap    postgres    false            �            1259    80764    represents_id_repr_seq    SEQUENCE     �   CREATE SEQUENCE public.represents_id_repr_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.represents_id_repr_seq;
       public          postgres    false    213            �           0    0    represents_id_repr_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.represents_id_repr_seq OWNED BY public.represents.id_repr;
          public          postgres    false    212            �            1259    89185    schema_migrations    TABLE     R   CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);
 %   DROP TABLE public.schema_migrations;
       public         heap    postgres    false            �            1259    80774    users    TABLE     �  CREATE TABLE public.users (
    id_user integer NOT NULL,
    email character varying(100) NOT NULL,
    password character varying NOT NULL,
    last_name character varying(100),
    first_name character varying(100),
    patronymic character varying(100),
    role boolean DEFAULT false NOT NULL,
    confirmation_token character varying,
    confirmed boolean DEFAULT false,
    active_repr integer,
    locale character varying(2) DEFAULT 'ru'::character varying
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    80772    users_id_user_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_user_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_id_user_seq;
       public          postgres    false    215            �           0    0    users_id_user_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_id_user_seq OWNED BY public.users.id_user;
          public          postgres    false    214            �
           2604    89363    gk id_gk    DEFAULT     d   ALTER TABLE ONLY public.gk ALTER COLUMN id_gk SET DEFAULT nextval('public.gk_id_gk_seq'::regclass);
 7   ALTER TABLE public.gk ALTER COLUMN id_gk DROP DEFAULT;
       public          postgres    false    204    205    205            �
           2604    105886    gk_translations id_gk_transl    DEFAULT     �   ALTER TABLE ONLY public.gk_translations ALTER COLUMN id_gk_transl SET DEFAULT nextval('public.gk_translations_id_gk_transl_seq'::regclass);
 K   ALTER TABLE public.gk_translations ALTER COLUMN id_gk_transl DROP DEFAULT;
       public          postgres    false    221    220    221            �
           2604    105872    law_types id_type    DEFAULT     v   ALTER TABLE ONLY public.law_types ALTER COLUMN id_type SET DEFAULT nextval('public.law_types_id_type_seq'::regclass);
 @   ALTER TABLE public.law_types ALTER COLUMN id_type DROP DEFAULT;
       public          postgres    false    219    218    219            �
           2604    105907 %   law_types_translations id_type_transl    DEFAULT     �   ALTER TABLE ONLY public.law_types_translations ALTER COLUMN id_type_transl SET DEFAULT nextval('public.law_types_translations_id_type_transl_seq'::regclass);
 T   ALTER TABLE public.law_types_translations ALTER COLUMN id_type_transl DROP DEFAULT;
       public          postgres    false    222    223    223            �
           2604    89365    laws id_law    DEFAULT     j   ALTER TABLE ONLY public.laws ALTER COLUMN id_law SET DEFAULT nextval('public.laws_id_law_seq'::regclass);
 :   ALTER TABLE public.laws ALTER COLUMN id_law DROP DEFAULT;
       public          postgres    false    207    206    207            �
           2604    89367    lt id_lt    DEFAULT     d   ALTER TABLE ONLY public.lt ALTER COLUMN id_lt SET DEFAULT nextval('public.lt_id_lt_seq'::regclass);
 7   ALTER TABLE public.lt ALTER COLUMN id_lt DROP DEFAULT;
       public          postgres    false    209    208    209            �
           2604    89368    quantity id_value    DEFAULT     v   ALTER TABLE ONLY public.quantity ALTER COLUMN id_value SET DEFAULT nextval('public.quantity_id_value_seq'::regclass);
 @   ALTER TABLE public.quantity ALTER COLUMN id_value DROP DEFAULT;
       public          postgres    false    211    210    211            �
           2604    105925 %   quantity_translations id_value_transl    DEFAULT     �   ALTER TABLE ONLY public.quantity_translations ALTER COLUMN id_value_transl SET DEFAULT nextval('public.quantity_translations_id_value_transl_seq'::regclass);
 T   ALTER TABLE public.quantity_translations ALTER COLUMN id_value_transl DROP DEFAULT;
       public          postgres    false    225    224    225            �
           2604    89369    represents id_repr    DEFAULT     x   ALTER TABLE ONLY public.represents ALTER COLUMN id_repr SET DEFAULT nextval('public.represents_id_repr_seq'::regclass);
 A   ALTER TABLE public.represents ALTER COLUMN id_repr DROP DEFAULT;
       public          postgres    false    213    212    213            �
           2604    89370    users id_user    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN id_user SET DEFAULT nextval('public.users_id_user_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN id_user DROP DEFAULT;
       public          postgres    false    215    214    215            �          0    89193    ar_internal_metadata 
   TABLE DATA           R   COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
    public          postgres    false    217   �       �          0    80715    gk 
   TABLE DATA           K   COPY public.gk (id_gk, g_indicate, k_indicate, gk_sign, color) FROM stdin;
    public          postgres    false    205   T�       �          0    105883    gk_translations 
   TABLE DATA           O   COPY public.gk_translations (id_gk_transl, gk_name, locale, id_gk) FROM stdin;
    public          postgres    false    221   ,�       �          0    105869 	   law_types 
   TABLE DATA           3   COPY public.law_types (id_type, color) FROM stdin;
    public          postgres    false    219   0�       �          0    105904    law_types_translations 
   TABLE DATA           \   COPY public.law_types_translations (id_type_transl, type_name, locale, id_type) FROM stdin;
    public          postgres    false    223   q�       �          0    80731    laws 
   TABLE DATA           �   COPY public.laws (id_law, law_name, first_element, second_element, third_element, fourth_element, id_user, id_type, combination) FROM stdin;
    public          postgres    false    207   ��       �          0    80750    lt 
   TABLE DATA           D   COPY public.lt (id_lt, l_indicate, t_indicate, lt_sign) FROM stdin;
    public          postgres    false    209   "�       �          0    80758    quantity 
   TABLE DATA           �   COPY public.quantity (id_value, symbol, m_indicate_auto, l_indicate_auto, t_indicate_auto, i_indicate_auto, id_lt, id_gk, mlti_sign) FROM stdin;
    public          postgres    false    211   ��       �          0    105922    quantity_translations 
   TABLE DATA           d   COPY public.quantity_translations (id_value_transl, value_name, unit, locale, id_value) FROM stdin;
    public          postgres    false    225   E�       �          0    80766 
   represents 
   TABLE DATA           P   COPY public.represents (id_repr, title, id_user, active_quantities) FROM stdin;
    public          postgres    false    213   U�       �          0    89185    schema_migrations 
   TABLE DATA           4   COPY public.schema_migrations (version) FROM stdin;
    public          postgres    false    216   &�       �          0    80774    users 
   TABLE DATA           �   COPY public.users (id_user, email, password, last_name, first_name, patronymic, role, confirmation_token, confirmed, active_repr, locale) FROM stdin;
    public          postgres    false    215   C�       �           0    0    gk_id_gk_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.gk_id_gk_seq', 15, false);
          public          postgres    false    204            �           0    0     gk_translations_id_gk_transl_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.gk_translations_id_gk_transl_seq', 28, true);
          public          postgres    false    220            �           0    0    law_types_id_type_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.law_types_id_type_seq', 5, true);
          public          postgres    false    218            �           0    0 )   law_types_translations_id_type_transl_seq    SEQUENCE SET     X   SELECT pg_catalog.setval('public.law_types_translations_id_type_transl_seq', 10, true);
          public          postgres    false    222            �           0    0    laws_id_law_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.laws_id_law_seq', 3, true);
          public          postgres    false    206            �           0    0    lt_id_lt_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.lt_id_lt_seq', 422, true);
          public          postgres    false    208            �           0    0    quantity_id_value_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.quantity_id_value_seq', 212, true);
          public          postgres    false    210            �           0    0 )   quantity_translations_id_value_transl_seq    SEQUENCE SET     Y   SELECT pg_catalog.setval('public.quantity_translations_id_value_transl_seq', 240, true);
          public          postgres    false    224            �           0    0    represents_id_repr_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.represents_id_repr_seq', 361, true);
          public          postgres    false    212            �           0    0    users_id_user_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.users_id_user_seq', 150, true);
          public          postgres    false    214            �
           2606    89200 .   ar_internal_metadata ar_internal_metadata_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);
 X   ALTER TABLE ONLY public.ar_internal_metadata DROP CONSTRAINT ar_internal_metadata_pkey;
       public            postgres    false    217            �
           2606    80720 
   gk gk_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY public.gk
    ADD CONSTRAINT gk_pkey PRIMARY KEY (id_gk);
 4   ALTER TABLE ONLY public.gk DROP CONSTRAINT gk_pkey;
       public            postgres    false    205            �
           2606    105888 $   gk_translations gk_translations_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.gk_translations
    ADD CONSTRAINT gk_translations_pkey PRIMARY KEY (id_gk_transl);
 N   ALTER TABLE ONLY public.gk_translations DROP CONSTRAINT gk_translations_pkey;
       public            postgres    false    221            �
           2606    105874    law_types law_types_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.law_types
    ADD CONSTRAINT law_types_pkey PRIMARY KEY (id_type);
 B   ALTER TABLE ONLY public.law_types DROP CONSTRAINT law_types_pkey;
       public            postgres    false    219            �
           2606    105909 2   law_types_translations law_types_translations_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public.law_types_translations
    ADD CONSTRAINT law_types_translations_pkey PRIMARY KEY (id_type_transl);
 \   ALTER TABLE ONLY public.law_types_translations DROP CONSTRAINT law_types_translations_pkey;
       public            postgres    false    223            �
           2606    80739    laws laws_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_pkey PRIMARY KEY (id_law);
 8   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_pkey;
       public            postgres    false    207            �
           2606    80755 
   lt lt_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY public.lt
    ADD CONSTRAINT lt_pkey PRIMARY KEY (id_lt);
 4   ALTER TABLE ONLY public.lt DROP CONSTRAINT lt_pkey;
       public            postgres    false    209            �
           2606    105927 0   quantity_translations quantity_translations_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public.quantity_translations
    ADD CONSTRAINT quantity_translations_pkey PRIMARY KEY (id_value_transl);
 Z   ALTER TABLE ONLY public.quantity_translations DROP CONSTRAINT quantity_translations_pkey;
       public            postgres    false    225            �
           2606    80771    represents represents_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.represents
    ADD CONSTRAINT represents_pkey PRIMARY KEY (id_repr);
 D   ALTER TABLE ONLY public.represents DROP CONSTRAINT represents_pkey;
       public            postgres    false    213            �
           2606    89192 (   schema_migrations schema_migrations_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
 R   ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
       public            postgres    false    216            �
           2606    89375    users unique_email 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT unique_email UNIQUE (email);
 <   ALTER TABLE ONLY public.users DROP CONSTRAINT unique_email;
       public            postgres    false    215            �
           2606    80779    users user_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_pkey PRIMARY KEY (id_user);
 9   ALTER TABLE ONLY public.users DROP CONSTRAINT user_pkey;
       public            postgres    false    215            �
           2606    80763    quantity values_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.quantity
    ADD CONSTRAINT values_pkey PRIMARY KEY (id_value);
 >   ALTER TABLE ONLY public.quantity DROP CONSTRAINT values_pkey;
       public            postgres    false    211            �
           1259    97652    idx_unique_id_lt_id_gk    INDEX     Z   CREATE UNIQUE INDEX idx_unique_id_lt_id_gk ON public.quantity USING btree (id_lt, id_gk);
 *   DROP INDEX public.idx_unique_id_lt_id_gk;
       public            postgres    false    211    211            �
           1259    105895 )   index_gk_translations_on_id_gk_and_locale    INDEX     u   CREATE UNIQUE INDEX index_gk_translations_on_id_gk_and_locale ON public.gk_translations USING btree (id_gk, locale);
 =   DROP INDEX public.index_gk_translations_on_id_gk_and_locale;
       public            postgres    false    221    221            �
           1259    105894    index_gk_translations_on_locale    INDEX     ]   CREATE INDEX index_gk_translations_on_locale ON public.gk_translations USING btree (locale);
 3   DROP INDEX public.index_gk_translations_on_locale;
       public            postgres    false    221            �
           1259    105916 2   index_law_types_translations_on_id_type_and_locale    INDEX     �   CREATE UNIQUE INDEX index_law_types_translations_on_id_type_and_locale ON public.law_types_translations USING btree (id_type, locale);
 F   DROP INDEX public.index_law_types_translations_on_id_type_and_locale;
       public            postgres    false    223    223            �
           1259    105915 &   index_law_types_translations_on_locale    INDEX     k   CREATE INDEX index_law_types_translations_on_locale ON public.law_types_translations USING btree (locale);
 :   DROP INDEX public.index_law_types_translations_on_locale;
       public            postgres    false    223            �
           1259    105934 2   index_quantity_translations_on_id_value_and_locale    INDEX     �   CREATE UNIQUE INDEX index_quantity_translations_on_id_value_and_locale ON public.quantity_translations USING btree (id_value, locale);
 F   DROP INDEX public.index_quantity_translations_on_id_value_and_locale;
       public            postgres    false    225    225            �
           1259    105933 %   index_quantity_translations_on_locale    INDEX     i   CREATE INDEX index_quantity_translations_on_locale ON public.quantity_translations USING btree (locale);
 9   DROP INDEX public.index_quantity_translations_on_locale;
       public            postgres    false    225            �
           1259    97642    unique_combination_user    INDEX     _   CREATE UNIQUE INDEX unique_combination_user ON public.laws USING btree (combination, id_user);
 +   DROP INDEX public.unique_combination_user;
       public            postgres    false    207    207                       2620    89066    users insert_users_trigger    TRIGGER     ~   CREATE TRIGGER insert_users_trigger AFTER INSERT ON public.users FOR EACH ROW EXECUTE FUNCTION public.insert_users_trigger();
 3   DROP TRIGGER insert_users_trigger ON public.users;
       public          postgres    false    242    215                       2620    97660 #   quantity remove_quantity_id_trigger    TRIGGER     �   CREATE TRIGGER remove_quantity_id_trigger AFTER DELETE ON public.quantity FOR EACH ROW EXECUTE FUNCTION public.remove_quantity_id();
 <   DROP TRIGGER remove_quantity_id_trigger ON public.quantity;
       public          postgres    false    211    227                       2620    97687 %   represents update_active_repr_trigger    TRIGGER     �   CREATE TRIGGER update_active_repr_trigger AFTER DELETE ON public.represents FOR EACH ROW EXECUTE FUNCTION public.update_active_repr();
 >   DROP TRIGGER update_active_repr_trigger ON public.represents;
       public          postgres    false    241    213            �
           2606    80835    quantity cell    FK CONSTRAINT     �   ALTER TABLE ONLY public.quantity
    ADD CONSTRAINT cell FOREIGN KEY (id_lt) REFERENCES public.lt(id_lt) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 7   ALTER TABLE ONLY public.quantity DROP CONSTRAINT cell;
       public          postgres    false    211    2781    209                       2606    97681    users fk_active_repr    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_active_repr FOREIGN KEY (active_repr) REFERENCES public.represents(id_repr) ON UPDATE CASCADE ON DELETE SET NULL;
 >   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_active_repr;
       public          postgres    false    213    215    2786                       2606    105889 *   gk_translations gk_translations_id_gk_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.gk_translations
    ADD CONSTRAINT gk_translations_id_gk_fkey FOREIGN KEY (id_gk) REFERENCES public.gk(id_gk) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 T   ALTER TABLE ONLY public.gk_translations DROP CONSTRAINT gk_translations_id_gk_fkey;
       public          postgres    false    205    2776    221                       2606    105910 :   law_types_translations law_types_translations_id_type_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.law_types_translations
    ADD CONSTRAINT law_types_translations_id_type_fkey FOREIGN KEY (id_type) REFERENCES public.law_types(id_type) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 d   ALTER TABLE ONLY public.law_types_translations DROP CONSTRAINT law_types_translations_id_type_fkey;
       public          postgres    false    219    2796    223            �
           2606    80805    laws laws_first_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_first_element_fkey FOREIGN KEY (first_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 F   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_first_element_fkey;
       public          postgres    false    2784    207    211            �
           2606    80810    laws laws_fourth_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_fourth_element_fkey FOREIGN KEY (fourth_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 G   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_fourth_element_fkey;
       public          postgres    false    207    2784    211            �
           2606    105875    laws laws_id_type_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_id_type_fkey FOREIGN KEY (id_type) REFERENCES public.law_types(id_type) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;
 @   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_id_type_fkey;
       public          postgres    false    2796    207    219            �
           2606    80820    laws laws_id_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 @   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_id_user_fkey;
       public          postgres    false    2790    215    207            �
           2606    80825    laws laws_second_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_second_element_fkey FOREIGN KEY (second_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 G   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_second_element_fkey;
       public          postgres    false    211    2784    207            �
           2606    80830    laws laws_third_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_third_element_fkey FOREIGN KEY (third_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 F   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_third_element_fkey;
       public          postgres    false    207    2784    211                        2606    80840    quantity level    FK CONSTRAINT     �   ALTER TABLE ONLY public.quantity
    ADD CONSTRAINT level FOREIGN KEY (id_gk) REFERENCES public.gk(id_gk) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 8   ALTER TABLE ONLY public.quantity DROP CONSTRAINT level;
       public          postgres    false    205    2776    211                       2606    105928 9   quantity_translations quantity_translations_id_value_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.quantity_translations
    ADD CONSTRAINT quantity_translations_id_value_fkey FOREIGN KEY (id_value) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 c   ALTER TABLE ONLY public.quantity_translations DROP CONSTRAINT quantity_translations_id_value_fkey;
       public          postgres    false    225    2784    211                       2606    80845 "   represents represents_id_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.represents
    ADD CONSTRAINT represents_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 L   ALTER TABLE ONLY public.represents DROP CONSTRAINT represents_id_user_fkey;
       public          postgres    false    215    2790    213            �   ?   x�K�+�,���M�+�LI-K��/ ����u�tL�����L��M,,�Hq��qqq ��L      �   �   x�u�=�0��9�5����DB�\�%N�	q$R#U�G��qm����qq�S�~_̡H/`C�
3�%L����t-}0�U���H��/LSN%am���#��1� a�q��1�\���!�F�F��q?��fP�ƪ�����A�����vΡ
��α��ۛ�� �z/����/R6�������?&��~�����      �   �  x����j�@�ϻO�p�]�� ��Bsr�E�����
�*�[�@K	%���� nӐ��+̾Q�U��88>iٙ������oԧ�TЕ=��GwtKC�?�����4���-�����9\�Wa���H�848��1����?��C�MI��8I��(�Ұ�u�uOI����'(�Bq�|Bi��£���^L.��u���G��\����̄�8��k���/���q�7��$�=7�B���漇�cM'����j\TٛHu;�4

�b���d��T)�At�ٝ6�i��s1�GuUۤI�k5s		��ٳx䐊
=A���>��Rl�^�#�sר�E�ޚ4o�V�>��D�JȾ��%<�Qy"3^���O����G]m��-;�䢾��� ��l�ښ��h��z\S$�X��;�\Vqt��b|��F�oq�7��	�e��k��ki����^�\�W*���:#�񜝓+vN\6�Y:�;K��w[�����a      �   1   x�3�T6��4.#N�4 �2���\&����@�)H,���� ,!
$      �     x�m��J1��3O�'�ϟP�kO^�K �BL-��{�Ao��Jeq���&o�$ J 	3�}3� =��iC�oh�﨣�z���ZA�چ�_��B�)�Yy��\9�Uq,ze��6�K���������?A�9�ֶT�*#����H�� A�|���Fca��޸qK[��}���m���-��K.�6�#81�t����J9]�p���V;�b���^~����?�=h
L���Gp���d�{��ǩ�E      �   �   x���1�u.�@�?��:y}�$$��A�@HPù#�h��J;�	�i����O�G;�K;�`�By@��"J�R��v�ڶ�Y�����ON��Θ�>�NX�:�i�� ���KH*`���K�T���?��~�:�      �   �  x�u�K��D���EI���W��z�ߥ2�T8=<��EO~�*�9��\������������������GY���/:�ֱ�.S����Ǣ�Ee:�y��Ǣ͋���/��v/�SY�����Xvx�6�2�m,+�e������|�e�c��e�T�4_cY},���Me����u�S������W����׭�8���[>����5���,�V�[�ΏCZ�m�yW4?�muZ�q��}��G�i0��+Ff�?{��������o�����%m����(8_���Op^�s�k�7��������[�=8?�s��.�s�����ɜ��]�_̹��y�=��} ��,4�hHy (?�r�q�;RnY��|C�}AGP^�r_u�Z)��"C�z���a��e)Z�u�^���^;�e)��kC�,�zU��R��׊z�~��Typ�^a!�`1��+��Ҟ��/؞�r�~�3T�y��z��(<Î��j_����+<CC�`��'z��%�p�g�-_�	��5$�W����n���>�!~4�RHz���Hz��oH���u	�+�^�(H_��Ջ���/�I_���Knҍ��^���z�(X��z�-Xߐ�T)Xߑ�݋��Y7��`�!�͋��Y?�(X���ˋ�zB������^^h��Ӿ��n�K�~ �)Gо#�����+*A{E�}�kо"������2�A���[���}FǞ(��;&|���W�=O�oȻuZ��y��n��w��!�FY�͉�eU7�n�Uݘ�'�	r�o�٭{�p������� ?�g1jH�#햵���RmS�v_�j�i��U���2��Y�v���ff�(Guc���箂����|Q��'�V*j���ݚ��9�wߞ����eU9'�n�U�\ȻQV�c���'ʪsL��V�W:	��V��:��o�� ~G�-��oH��HuNE�����������s$޲�Ι��'̪tfN��#�ǒ>q>����VG0�#�V��d�8�|C��̟����*�����r���>a���'\��U�߁Z^Z5ԪyQhu�Vy���B�./R�oA�l�U���"l�U9����$l�UY����KX{�ec/a��Q/T��G-�7�:g����|Ny��ͣ<��j��Q�S��p������Eq���P�ʀ4������^���@ql�e�ą�;$�@�ad�U�!�X� �?�E���1N�evu�{�lh\8vR��UQ���j��WIU�j�H�_��Lƣ���+��h>,�!�#�M�If��{�_頧lLc_:Ry��.n
�E�sS������O�U�>g-D�]�M!f��)=�y�a�+��������������o�I¤r�����W�T�b��1��O��_�������y�IU�~!΃�H�O����q0�w�02lڸ���BȻ������Tv����Tv�8[�GD����f������j���la��ō� [�M�p�!�J�,�bKp@�՘�~=6�뮨��.^r�#S2�]sU�`01*U��7���!sp~B�* f����UB����G����E{�;��8>��Ec|!�F�c��@j����؋z��'�-������[��p�§��p���>m}X�%�kcx��0�K�׶��aj�_x�n���w�Ǯl{*�����]T�k���!
"���Y����*�!���E)��>��QaJo�eA���\~,R�������K��>֧7�w��J���x��z�1߾�"�O�,~1��R-p���>�'�T�!�޼��	�J�w$ܢF��ᾞH���k�l_{�K�˘9�8�M�B�;.��4�Ky�{���e��[H%�>�ZH��e�B-��d�p�R�$�~�i�K���D�p����R�¹V��J�
g[٧P�U8�*�%\�3��h�2���ڔ�d�kKujÅL��'S���y�2 `�����Lm4�0��W1�����YOE%���9&��0�?V`�cbƲ:?�8��_��Q��Y߁�!
OC$��(<��k ��DD����3	xO�x*"�􄕀�w���(l�,l��
;��H�/Y�ʖ�{�%T�˫���_�q�F�<��+�ynʈo�g�_%�,�dK8�L����!��&/8&��o}P�eR���J�M�����|S���Dva{Ü'&�ֳE��0�[o���D����j<=�]�.�M7�zZ�'�	�a�__Ot��}���k�|�[�V����T �����Sb�˟��*<7�W��R�0��΢����|���ǒ򁮇Y�':��T�N�gG�˞k�0d�Z�������s������s���t����s:/M+��C�C��C��C�ܛ��P�U�oH}.
�+R�?�s���R�R�R��*���u��lx<)�aT1�L�ȵ�'�*�gvu�]��P������G5х�88TAę��6�Fv8v�>��G�/��J��Q�ART?��������qWj�2.=�F��k1lkcMX����\^b�8S�+��%�x��B���Mq��sc�ǝ7�|2σ����Ť*�\�� U����k�,\ݏ}GX9��q��)R��Pp�Yo�� 0��R�j�s|���3g������9�Է�m���̉C:G5��9�OU{+�=O�V5����g���=�,&4牷�ղ�<q4!ke�y�t�Y)k�s���RU�ylw}U��;�����V�ʖ���=����yO��f���'Ж�r�����Wd?�s��bh�sA��=[�*����=k�ªj�3��o2�ގ�7m='��k���7�[S��lM}�HD6��I����*cB��3�zO��s��S>���m�h�NT��c��@<���#���:l���ϔ�o񌂙z�Χ|��7]=��7�9��K9q�_R����@��G��T��x:q��ϹE��,�����?�����m      �   >  x��Y�nE>�<E��a����YJ	�Bd�as��hR��m�����p�oE\�<�ƼOBuWw�vOͺe�g�S�����W5Z�gw��������p�	��`��/���龼8x�?��>=��F+_�����W�U�ͺs�.gh��?C�8�鮕����9J	�#[ީ������?��9y��%�]�4�`��5�M�p�����^��ݚ]�M��py�M��t�<+��n<C)m��k���2����2ݚO����
K%�V�`c�y��kDy�f�b]88Z,)�I���쭂.( ލ�t3���ha��b��@T1�	�ӭ9=��>�Lrzɲ�YVS3�%I/;Ĩd�{�p/�U�>$,cLT�R�hؼ�[P���"凂ۛ�>C��&]��]����I!��?�j��	F��u<�K����d��}\D�����e>_��2?Rji����eM)2CJ����AOB�7*R����1��E�gT>�>�S،���p�=d�ʶ���ɪ�@j.������*T�W���YU��|�٧�ej(���������s����J!G�Ѕ�;{Q������;H��^
���NRG�B�������vQo	�/M'�el�g���6��#�u> ��e{�r	D�|��w@Ky.g7끢{	�����K=T�:�F��4\���+[QՆr{3��BOt�#M�c[�`�tw��7;ǫRp���֋�ۮ�NK'���}^.��}�3�a���Kl4_��hIu?� M���W��DҬ�ί
WD�~~بց(�6� +�A��QS�
c��������S�e���5"���5�@�ݙ��Gj��+k�۫�խ��%���n��KkNy7��9_�_kj��Ys�$yޒUӶbŐ3ق��A1������"$��OF(���y���=�`�{1Բ;MlOK�!?�f=!qP�f����r�E�gDݠ������"u������"][�Ӕ���K���N�,j�<]p�!P,�ΎH̡t��C�I�&�H����"���&�؋�ΐ���m�+[|�ra���UsT !o�R��^�m��D:���'�v5�E"��CI�Ѱ�x�a��D̥�Oᓦ�㯄F�94J�`+���	^z��ux��7�f	�C�,��/V���OX�m*�#r:j��y(�#|�X����O;�([7�'����>��r�g�v��э�1-\R��3��bq���K��<f��SO�ÓЖ�''�k��=\�-����؂�w^ u�"���|�D���x�"#mX��E��|J�}��͗�{_&���l����k��Z(孩k�3�'�7�
�_�U`�fC'�������a�kz3�b��W���ѐW�G�O�3�܂f(����P�1�5x1��c�(�R��Jr)�0�ڶ�G�}��gh�c�b�o}�b��C 0���=��6��v��6�%5�d�[��� ����X#5���b�6.%�l�����=�ЖfUvg\*xB[�8YٺuL"��r�7�C�� ސo75����#�P9��ȓa�n�n��k�M��k��&y�cH�
��z㑜L�
���Xغ�O,���6I��6a��&(�YE[���|���F~4�Uy�낉��k�����%�t�M���Lƚ��w�/N�~��w.v����KX��Pa���E����~���
8�ҘOb[p�LU������x�6�_�mz熞�_�D��m�oH��;|$Y�*,��i"�Y|� l�'q��n5ס崱�iM��X
������i�>}a�      �      x��Z[�\�~��+��ڒg��"!���&��~�e<{�y.���5���G��%�"�D �)�blX���?����|U��ҧ{��l��������㋍�?�I��|��_=�������|z������k}�C�_�'ڇ���@l�9.���h8��;��v��]k�,��
�MO���j�]�/���Qg�����X�v�Hl\ޝϋ��-���"65	��.���/P�y�b�7�(�%ɡ��˃��p��/�i�P��Ճ�|ZW���<鹫�P�%�^� ��|�j\��^$3r2����b�X���ݞ�F�����\��(�[���K�K�K��7f��I!&�"��苎�I����J+�yq�$/q�@H5{��h��Nft�����	�P��1����nÅ0��"�:Z�WIp���R"��Z������w�����:}?����Cd�����S]�M�mJ��B]�sV>��?�ߎ��{��原��Y�;�펦�|9��ۦ{������M��O~_��>��i[��{N����E����5�"2���π��3��-g��02T߾/��4�'�Ps��x��=�̾z�C������D��ow��O���q!���mh=&��#���VC'H���I���-�������z����E��/�`���<�n���=���R3,��N��	�7q��;�'����`^EZ[	��@��o���	��_~Y����	��iե��P��2��ۀ<�Ft���,5u¨�b	��b��%���b��?"�Ϝ0�BB�ۅ-��,k �BW�#wB�C�oĪ�	a��I&H:�S"2WG0��էUq6��C�/�x�}4X�fS�{�#V�A��?8��Q}p#��NT�0��\n4�8F�ch �z@P��!�\)�ٝh#/��b��cre����8��-��N���{�\B�5K��%_{y��i�l��(c[h+w�� �6R�5���!?vb����鲘.꠱��n`���j����b�eo�I;�D<b��èl������J��^j�t��c�đ�: �z8������n�V�m���dN,ATH��a�o���������5й���>��"��;qL7޹3�8�Ҧ ͩ`8��S�q��9�'~SL��w�}���L��(>�t�#��$�onX�q�����A�!ac�F�v7N�_Vf�ׯN�k!z6���>���r����� Ҷ!jT��h1���wQ�L��CaA"N�N(�Pj�T�OiJV��"�,�t��?��$L존B�.6��2�t{��[`!*�c'���b�}g)���'_я$���u�X,��Y6�kFp�6{v��#��6�uO*�If�{��Sg�+Ȯ��9i"�6iu���ZSO���mKI����"�8��9��r����)׵  ��!��y����_�
R9��c��%�"����NQl霯�9���$���Qݒ��(p��l��BC"�ל�y��Q�dI[�b��L�iG=K�׍��Tx�~Y�t��u"u� �o
���ɏ�1�j�[���L��>�G�b�N�7��Ȇ��@-4�Mi���&A`@�M�Q*�mi>J����N�
�o�}b�~�E�¹�U&��M�Q��ؐ�ݯ�Ԛ��.Jy�Z��)��SyO^���J��m�@@�*o���c�t��~���lM�E���r'oR�l������C)	k��ᢆ��s|ϓ^-�7�,�(����h�#��^��]#�>��]W20G ���M���к��j���;���j�e�z�y�{j�@��`-���d��4��% ���_�#3���|m�l<��>�袏�L�df��16?�7I�����
��t�d��]ĦLԼ`D�����C�UbSp�A�
���jKbZ͡5�+�'^��!;���^{F|p�r��1�n��t7�'t�O��|AWETf��0��Nv8(7�%��tHhD��U,�s5�_��+�9����˚���iG��2Dg�λ�vz75��|�:�9gkq��D-[߅�n�̱>9�Р34[�D�O��P����v�%1���}����j��"̃L���&s��OxF��^F��i�CWl�w��r�S��Kn�,�Bľ�i�U�����<���:e	��os��=�v���G.h�q؊��Ų&X���E��$
����Գ��owX	�7L��,w�!\��bX����l�#J]�X 3�ĕy��b:�/�����s= �o��,����=EG^U�o�9��o�ҷ�ޮr�L�Q@���t�S%���8��&T��[Q$��S�_n�Y2�Ŗ�DX[�1%� DX:&K��Μz���+�.�G�� ��b�B�9�OJ��g�O��u�4�~ܗ�f���=q�.gswg�D�9�{�Z�[N^�m~��[m�@ �M��r�M��Di�w[��������KI3�7X��O�.�������Ä����d4�.H�)g
8h�|�椟!��L�/�ܗ�0�����Xz.�"�n�Ԛ!.O� �X��L���0��������AI5���n+D�8k������'��6��ʳ�r�yT������d��$Qo6,��r&�J�<$`���$S0�(�"h!ou$�S�Z����)�3r�1A�j�/���e�HJ��,,���)7�������:���@`�	ёF������D״*gU�`�#9_Q�KF/���+�Q����׻9JC�N[�BKi+ui�����đS��B�_+r�>�.~�D�e�xwF�7ThU%4~�$z�o\�������4��mY 6T�|�6÷vAIsL�J���}_�4��E�i_���ЌR#*�)�>I�yҿ��,�e�K>��D6��=!�@!D���Ţ����o-��L�Z=��2��LK.�|)Gg�z-ny�`�l��y����؅�!�s��X,�Ⱥ>`.�j�]��D�*l��y lW�����y9\�"���v{�A�G�㌽���I	b��nm$�sޕ�z��� ��y��:��-j+E2��:�|�7މ�ǚh��,��%���:��k�!�H�^]��RO�4Ľ�r��?$R~�^�ڷ�G�G?v��o'�=0^�݇:�mw��7�:Ir�Ə�^u1���>�?cZs7L%�7l'�����R�
ƚ���D�	u�����$[�d�b���h�if�M4?o�aȟRb��ڣH��'�C�;�_%�_(j���Hh�����SL�����F�������ތ�^
�HU4,YqI���X�����e`k~E�\1�'I�Z�R]g���������>���'��2ȧ�׿D��[Ib_l���ZJ���DA��i�Khyc>�[���HuU�qӦƂ�.���gAA"PuY�ʋ�Y�F�U��L�z�)��Y��Xۇr!����T�ǣ5�E�����1�G|T?/ҋ�W��$k�����,aF|��@.�Sj��;�K�z��#!O�P�oٲ���d��RD�r�v.T��M.ZF�􃕟]���ln �"��H�d�_��IJ7��'h��T�!�w>�9��?js�      �   �   x�ՑAJD1D��gyHw��N��N��2��&"�;ϐ#M����Em
R�*mm�����ᡨGyU*���TPE+�hC��J5j�L0������FSZ��Н�q� &CʨgӘ�/�'Y(�(�ڽ�;Gz��Ρ=�~�Ӧe�������G��\�2�ؼ������AF��o��p�{���m��U��      �      x������ � �      �   y  x����N�P�ק������&�ki�"�ZBb
�J{�M[(+\�5�}c0!*<�ፄ�Dݰp2�����>���u׻97�c\� R��'��P`Y���*;H<�fCS��V0�����[]��8G�|^3�����뙞�NS�/�B��g�Q���� =�5�D�E;�����A�����uj�d�@O�0�.��y�d�s��?��4��eԦE�Q5�VR���s5����!A����v��	z<���H�lxIDז-j =��~u �~�~�7���G/�h�_�|X���`�� 4�b4t�d@��T���ȅ�9�Ew9RS�3ZG&R�jG�2~aXZ?Ik�՞R��S�V	����$�
Q�>�ˊ��?�,cl��0���V     