PGDMP                         {            fviz    12.12    12.12 R    x           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            y           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            z           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            {           1262    62417    fviz    DATABASE     �   CREATE DATABASE fviz WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Russian_Russia.1251' LC_CTYPE = 'Russian_Russia.1251';
    DROP DATABASE fviz;
                postgres    false            �            1255    89065    insert_users_trigger()    FUNCTION     �  CREATE FUNCTION public.insert_users_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO gk_settings(id_gk, id_user, gk_color) VALUES (1, NEW.id_user, 'dbdb7b');
    INSERT INTO gk_settings(id_gk, id_user, gk_color) VALUES (2, NEW.id_user, 'c2c5c8');
    INSERT INTO gk_settings(id_gk, id_user, gk_color) VALUES (3, NEW.id_user, '6d6d6d');
    INSERT INTO gk_settings(id_gk, id_user, gk_color) VALUES (4, NEW.id_user, '9b9b9b');
    INSERT INTO gk_settings(id_gk, id_user, gk_color) VALUES (5, NEW.id_user, 'a3cada');
    INSERT INTO gk_settings(id_gk, id_user, gk_color) VALUES (6, NEW.id_user, '92e892');
    INSERT INTO gk_settings(id_gk, id_user, gk_color) VALUES (7, NEW.id_user, 'e79670');
    INSERT INTO gk_settings(id_gk, id_user, gk_color) VALUES (8, NEW.id_user, '64a020');
    INSERT INTO gk_settings(id_gk, id_user, gk_color) VALUES (9, NEW.id_user, '74afec');
    INSERT INTO gk_settings(id_gk, id_user, gk_color) VALUES (10, NEW.id_user, 'bfd799');
    INSERT INTO gk_settings(id_gk, id_user, gk_color) VALUES (11, NEW.id_user, 'a2c8eb');
    INSERT INTO gk_settings(id_gk, id_user, gk_color) VALUES (12, NEW.id_user, 'bccb98');
    INSERT INTO gk_settings(id_gk, id_user, gk_color) VALUES (13, NEW.id_user, '575bdf');
    INSERT INTO gk_settings(id_gk, id_user, gk_color) VALUES (14, NEW.id_user, 'e79bde');
	INSERT INTO represents(title, id_user, active_values) VALUES ('Базовое', NEW.id_user, ARRAY[1, 2, 3, 4, 5, 6, 8, 10, 11, 12, 14, 15, 17, 19, 22, 23, 26, 28, 30, 33, 37, 38, 40, 41, 43, 45, 51, 54, 58, 60, 64, 65, 66, 70, 74, 77, 79, 80, 81, 82, 84, 87, 93, 95, 100, 101, 102, 103, 105, 109, 110, 112, 113, 115, 116, 119, 120]);
    
    RETURN NEW;
END;
$$;
 -   DROP FUNCTION public.insert_users_trigger();
       public          postgres    false            �            1255    89069    update_quantity_trigger()    FUNCTION     �  CREATE FUNCTION public.update_quantity_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.mlti_sign := 
    CASE
      WHEN NEW.m_indicate <> 0 THEN CONCAT('M<sup>', NEW.m_indicate, '</sup>')
      ELSE ''
    END
    || CASE
      WHEN NEW.l_indicate <> 0 THEN CONCAT('L<sup>', NEW.l_indicate, '</sup>')
      ELSE ''
    END
    || CASE
      WHEN NEW.t_indicate <> 0 THEN CONCAT('T<sup>', NEW.t_indicate, '</sup>')
      ELSE ''
    END
    || CASE
      WHEN NEW.i_indicate <> 0 THEN CONCAT('I<sup>', NEW.i_indicate, '</sup>')
      ELSE ''
    END
    || CASE
      WHEN NEW.m_indicate = 0 AND NEW.l_indicate = 0 AND NEW.t_indicate = 0 AND NEW.i_indicate = 0 THEN 'L<sup>0</sup>T<sup>0</sup>'
      ELSE ''
    END;

  RETURN NEW;
END;
$$;
 0   DROP FUNCTION public.update_quantity_trigger();
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
    gk_name character varying(100),
    gk_sign character varying(50)
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
       public          postgres    false    205            |           0    0    gk_id_gk_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.gk_id_gk_seq OWNED BY public.gk.id_gk;
          public          postgres    false    204            �            1259    97588    gk_settings    TABLE     �   CREATE TABLE public.gk_settings (
    id_gk_set integer NOT NULL,
    id_gk integer NOT NULL,
    id_user integer NOT NULL,
    gk_color character varying(20) NOT NULL
);
    DROP TABLE public.gk_settings;
       public         heap    postgres    false            �            1259    97586    gk_settings_id_gk_set_seq    SEQUENCE     �   CREATE SEQUENCE public.gk_settings_id_gk_set_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.gk_settings_id_gk_set_seq;
       public          postgres    false    221            }           0    0    gk_settings_id_gk_set_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.gk_settings_id_gk_set_seq OWNED BY public.gk_settings.id_gk_set;
          public          postgres    false    220            �            1259    80731    laws    TABLE     (  CREATE TABLE public.laws (
    id_law integer NOT NULL,
    law_name character varying,
    first_element integer NOT NULL,
    second_element integer NOT NULL,
    third_element integer NOT NULL,
    fourth_element integer NOT NULL,
    id_user integer NOT NULL,
    id_type integer NOT NULL
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
       public          postgres    false    207            ~           0    0    laws_id_law_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.laws_id_law_seq OWNED BY public.laws.id_law;
          public          postgres    false    206            �            1259    80742 	   laws_type    TABLE     o   CREATE TABLE public.laws_type (
    id_type integer NOT NULL,
    type_name character varying(100) NOT NULL
);
    DROP TABLE public.laws_type;
       public         heap    postgres    false            �            1259    80740    laws_type_id_type_seq    SEQUENCE     �   CREATE SEQUENCE public.laws_type_id_type_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.laws_type_id_type_seq;
       public          postgres    false    209                       0    0    laws_type_id_type_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.laws_type_id_type_seq OWNED BY public.laws_type.id_type;
          public          postgres    false    208            �            1259    80750    lt    TABLE     �   CREATE TABLE public.lt (
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
       public          postgres    false    211            �           0    0    lt_id_lt_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.lt_id_lt_seq OWNED BY public.lt.id_lt;
          public          postgres    false    210            �            1259    80758    quantity    TABLE     �  CREATE TABLE public.quantity (
    id_value integer NOT NULL,
    val_name character varying(200),
    symbol character varying(100),
    m_indicate smallint NOT NULL,
    l_indicate smallint NOT NULL,
    t_indicate smallint NOT NULL,
    i_indicate smallint NOT NULL,
    unit character varying(200),
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
       public          postgres    false    213            �           0    0    quantity_id_value_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.quantity_id_value_seq OWNED BY public.quantity.id_value;
          public          postgres    false    212            �            1259    80766 
   represents    TABLE     �   CREATE TABLE public.represents (
    id_repr integer NOT NULL,
    title character varying(100),
    id_user integer NOT NULL,
    active_values integer[] NOT NULL
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
       public          postgres    false    215            �           0    0    represents_id_repr_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.represents_id_repr_seq OWNED BY public.represents.id_repr;
          public          postgres    false    214            �            1259    89185    schema_migrations    TABLE     R   CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);
 %   DROP TABLE public.schema_migrations;
       public         heap    postgres    false            �            1259    80774    users    TABLE     1  CREATE TABLE public.users (
    id_user integer NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(50) NOT NULL,
    last_name character varying(100),
    first_name character varying(100),
    patronymic character varying(100),
    role boolean DEFAULT false NOT NULL
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
       public          postgres    false    217            �           0    0    users_id_user_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_id_user_seq OWNED BY public.users.id_user;
          public          postgres    false    216            �
           2604    89363    gk id_gk    DEFAULT     d   ALTER TABLE ONLY public.gk ALTER COLUMN id_gk SET DEFAULT nextval('public.gk_id_gk_seq'::regclass);
 7   ALTER TABLE public.gk ALTER COLUMN id_gk DROP DEFAULT;
       public          postgres    false    205    204    205            �
           2604    97591    gk_settings id_gk_set    DEFAULT     ~   ALTER TABLE ONLY public.gk_settings ALTER COLUMN id_gk_set SET DEFAULT nextval('public.gk_settings_id_gk_set_seq'::regclass);
 D   ALTER TABLE public.gk_settings ALTER COLUMN id_gk_set DROP DEFAULT;
       public          postgres    false    220    221    221            �
           2604    89365    laws id_law    DEFAULT     j   ALTER TABLE ONLY public.laws ALTER COLUMN id_law SET DEFAULT nextval('public.laws_id_law_seq'::regclass);
 :   ALTER TABLE public.laws ALTER COLUMN id_law DROP DEFAULT;
       public          postgres    false    206    207    207            �
           2604    89366    laws_type id_type    DEFAULT     v   ALTER TABLE ONLY public.laws_type ALTER COLUMN id_type SET DEFAULT nextval('public.laws_type_id_type_seq'::regclass);
 @   ALTER TABLE public.laws_type ALTER COLUMN id_type DROP DEFAULT;
       public          postgres    false    208    209    209            �
           2604    89367    lt id_lt    DEFAULT     d   ALTER TABLE ONLY public.lt ALTER COLUMN id_lt SET DEFAULT nextval('public.lt_id_lt_seq'::regclass);
 7   ALTER TABLE public.lt ALTER COLUMN id_lt DROP DEFAULT;
       public          postgres    false    211    210    211            �
           2604    89368    quantity id_value    DEFAULT     v   ALTER TABLE ONLY public.quantity ALTER COLUMN id_value SET DEFAULT nextval('public.quantity_id_value_seq'::regclass);
 @   ALTER TABLE public.quantity ALTER COLUMN id_value DROP DEFAULT;
       public          postgres    false    213    212    213            �
           2604    89369    represents id_repr    DEFAULT     x   ALTER TABLE ONLY public.represents ALTER COLUMN id_repr SET DEFAULT nextval('public.represents_id_repr_seq'::regclass);
 A   ALTER TABLE public.represents ALTER COLUMN id_repr DROP DEFAULT;
       public          postgres    false    214    215    215            �
           2604    89370    users id_user    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN id_user SET DEFAULT nextval('public.users_id_user_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN id_user DROP DEFAULT;
       public          postgres    false    217    216    217            s          0    89193    ar_internal_metadata 
   TABLE DATA           R   COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
    public          postgres    false    219   k       e          0    80715    gk 
   TABLE DATA           M   COPY public.gk (id_gk, g_indicate, k_indicate, gk_name, gk_sign) FROM stdin;
    public          postgres    false    205   nk       u          0    97588    gk_settings 
   TABLE DATA           J   COPY public.gk_settings (id_gk_set, id_gk, id_user, gk_color) FROM stdin;
    public          postgres    false    221   �l       g          0    80731    laws 
   TABLE DATA           �   COPY public.laws (id_law, law_name, first_element, second_element, third_element, fourth_element, id_user, id_type) FROM stdin;
    public          postgres    false    207   �m       i          0    80742 	   laws_type 
   TABLE DATA           7   COPY public.laws_type (id_type, type_name) FROM stdin;
    public          postgres    false    209   �m       k          0    80750    lt 
   TABLE DATA           D   COPY public.lt (id_lt, l_indicate, t_indicate, lt_sign) FROM stdin;
    public          postgres    false    211   �m       m          0    80758    quantity 
   TABLE DATA           �   COPY public.quantity (id_value, val_name, symbol, m_indicate, l_indicate, t_indicate, i_indicate, unit, id_lt, id_gk, mlti_sign) FROM stdin;
    public          postgres    false    213   �x       o          0    80766 
   represents 
   TABLE DATA           L   COPY public.represents (id_repr, title, id_user, active_values) FROM stdin;
    public          postgres    false    215   ��       r          0    89185    schema_migrations 
   TABLE DATA           4   COPY public.schema_migrations (version) FROM stdin;
    public          postgres    false    218   ��       q          0    80774    users 
   TABLE DATA           b   COPY public.users (id_user, email, password, last_name, first_name, patronymic, role) FROM stdin;
    public          postgres    false    217   ��       �           0    0    gk_id_gk_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.gk_id_gk_seq', 14, true);
          public          postgres    false    204            �           0    0    gk_settings_id_gk_set_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.gk_settings_id_gk_set_seq', 28, true);
          public          postgres    false    220            �           0    0    laws_id_law_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.laws_id_law_seq', 1, false);
          public          postgres    false    206            �           0    0    laws_type_id_type_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.laws_type_id_type_seq', 1, false);
          public          postgres    false    208            �           0    0    lt_id_lt_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.lt_id_lt_seq', 371, true);
          public          postgres    false    210            �           0    0    quantity_id_value_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.quantity_id_value_seq', 120, true);
          public          postgres    false    212            �           0    0    represents_id_repr_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.represents_id_repr_seq', 2, true);
          public          postgres    false    214            �           0    0    users_id_user_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.users_id_user_seq', 2, true);
          public          postgres    false    216            �
           2606    89200 .   ar_internal_metadata ar_internal_metadata_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);
 X   ALTER TABLE ONLY public.ar_internal_metadata DROP CONSTRAINT ar_internal_metadata_pkey;
       public            postgres    false    219            �
           2606    80720 
   gk gk_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY public.gk
    ADD CONSTRAINT gk_pkey PRIMARY KEY (id_gk);
 4   ALTER TABLE ONLY public.gk DROP CONSTRAINT gk_pkey;
       public            postgres    false    205            �
           2606    97593    gk_settings gk_settings_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.gk_settings
    ADD CONSTRAINT gk_settings_pkey PRIMARY KEY (id_gk_set);
 F   ALTER TABLE ONLY public.gk_settings DROP CONSTRAINT gk_settings_pkey;
       public            postgres    false    221            �
           2606    80739    laws laws_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_pkey PRIMARY KEY (id_law);
 8   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_pkey;
       public            postgres    false    207            �
           2606    80747    laws_type laws_type_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.laws_type
    ADD CONSTRAINT laws_type_pkey PRIMARY KEY (id_type);
 B   ALTER TABLE ONLY public.laws_type DROP CONSTRAINT laws_type_pkey;
       public            postgres    false    209            �
           2606    80755 
   lt lt_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY public.lt
    ADD CONSTRAINT lt_pkey PRIMARY KEY (id_lt);
 4   ALTER TABLE ONLY public.lt DROP CONSTRAINT lt_pkey;
       public            postgres    false    211            �
           2606    80771    represents represents_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.represents
    ADD CONSTRAINT represents_pkey PRIMARY KEY (id_repr);
 D   ALTER TABLE ONLY public.represents DROP CONSTRAINT represents_pkey;
       public            postgres    false    215            �
           2606    89192 (   schema_migrations schema_migrations_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
 R   ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
       public            postgres    false    218            �
           2606    89375    users unique_email 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT unique_email UNIQUE (email);
 <   ALTER TABLE ONLY public.users DROP CONSTRAINT unique_email;
       public            postgres    false    217            �
           2606    80779    users user_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_pkey PRIMARY KEY (id_user);
 9   ALTER TABLE ONLY public.users DROP CONSTRAINT user_pkey;
       public            postgres    false    217            �
           2606    80763    quantity values_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.quantity
    ADD CONSTRAINT values_pkey PRIMARY KEY (id_value);
 >   ALTER TABLE ONLY public.quantity DROP CONSTRAINT values_pkey;
       public            postgres    false    213            �
           2620    89066    users insert_users_trigger    TRIGGER     ~   CREATE TRIGGER insert_users_trigger AFTER INSERT ON public.users FOR EACH ROW EXECUTE FUNCTION public.insert_users_trigger();
 3   DROP TRIGGER insert_users_trigger ON public.users;
       public          postgres    false    235    217            �
           2620    97610     quantity update_quantity_trigger    TRIGGER     �   CREATE TRIGGER update_quantity_trigger AFTER UPDATE OF m_indicate, l_indicate, t_indicate, i_indicate ON public.quantity FOR EACH ROW EXECUTE FUNCTION public.update_quantity_trigger();
 9   DROP TRIGGER update_quantity_trigger ON public.quantity;
       public          postgres    false    213    213    213    234    213    213            �
           2606    80835    quantity cell    FK CONSTRAINT     �   ALTER TABLE ONLY public.quantity
    ADD CONSTRAINT cell FOREIGN KEY (id_lt) REFERENCES public.lt(id_lt) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 7   ALTER TABLE ONLY public.quantity DROP CONSTRAINT cell;
       public          postgres    false    213    2762    211            �
           2606    97594 "   gk_settings gk_settings_id_gk_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.gk_settings
    ADD CONSTRAINT gk_settings_id_gk_fkey FOREIGN KEY (id_gk) REFERENCES public.gk(id_gk) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 L   ALTER TABLE ONLY public.gk_settings DROP CONSTRAINT gk_settings_id_gk_fkey;
       public          postgres    false    205    221    2756            �
           2606    97599 $   gk_settings gk_settings_id_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.gk_settings
    ADD CONSTRAINT gk_settings_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 N   ALTER TABLE ONLY public.gk_settings DROP CONSTRAINT gk_settings_id_user_fkey;
       public          postgres    false    2770    217    221            �
           2606    80805    laws laws_first_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_first_element_fkey FOREIGN KEY (first_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 F   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_first_element_fkey;
       public          postgres    false    207    2764    213            �
           2606    80810    laws laws_fourth_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_fourth_element_fkey FOREIGN KEY (fourth_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 G   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_fourth_element_fkey;
       public          postgres    false    2764    213    207            �
           2606    80815    laws laws_id_type_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_id_type_fkey FOREIGN KEY (id_type) REFERENCES public.laws_type(id_type) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 @   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_id_type_fkey;
       public          postgres    false    207    209    2760            �
           2606    80820    laws laws_id_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 @   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_id_user_fkey;
       public          postgres    false    217    2770    207            �
           2606    80825    laws laws_second_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_second_element_fkey FOREIGN KEY (second_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 G   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_second_element_fkey;
       public          postgres    false    213    207    2764            �
           2606    80830    laws laws_third_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_third_element_fkey FOREIGN KEY (third_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 F   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_third_element_fkey;
       public          postgres    false    207    2764    213            �
           2606    80840    quantity level    FK CONSTRAINT     �   ALTER TABLE ONLY public.quantity
    ADD CONSTRAINT level FOREIGN KEY (id_gk) REFERENCES public.gk(id_gk) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 8   ALTER TABLE ONLY public.quantity DROP CONSTRAINT level;
       public          postgres    false    213    2756    205            �
           2606    80845 "   represents represents_id_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.represents
    ADD CONSTRAINT represents_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 L   ALTER TABLE ONLY public.represents DROP CONSTRAINT represents_id_user_fkey;
       public          postgres    false    215    217    2770            s   ?   x�K�+�,���M�+�LI-K��/ ����u�tL�����L��M,,�Hq��qqq ��L      e   Q  x���MN�0F��)rC�?�b˂+p$ľM%�P�AH ���
u�0s#>;q�J�ET�����h�Ï(��4�)�	�iE��2Niŷ��دb�������7�w�����������2�I:F��QO<Bz�t�zn����ȳ�
�<Ɔ�YX��*
Ӣ<5e�� L-��}�[�1 B%1mՖ<D^�6��=n�)X�Z�V'b��"�0P��4�^�'4q(g#��u�AJ���Յ?^P���r �7���Ol��b��m���:!���*�����W21��xN����C5��w*L'%�4O�
������̘��yI��bOJ��O3L      u   �   x�5�An� Dѵ}�
O �]��@���j,��$�	��c�����=>��Õ��iq�Q󱞽��N=np�+����k�A#>PWA�IӇ����R(���,�{\c�谽mψ������!��'v.K� �)�@�	H�7 2�D�P��)ࡾ>���C�Ԁ !hAB���@��`	��a�?��N      g      x������ � �      i      x������ � �      k   �
  x�u�A��(D��0c�[j�	z��9�H����3!�(=�Z���2�#��\��m)o������_��>��������\���R��eP����-�1�/������1]ˠC��vo��A�2�iP��s���2�԰c�yK}�˰�am�eK�V�a���[�[�簺�5�o�����qǪ뮁�3���i�?~�~�3H������~����G~Vq
��IJأ<<�%J�`Z��n�6�z�^K}|��&3�_2G���-_#�s{~������~������ � ��=�yE�5�f�ȹ�i�yCΥt3�O�\k֜�Μk��s~1�b�9�7s.��s ����?��d�&EG�cF���K��(oH�d=��)��FyEʵ���
ʋ}�_����ꨗ��׉zI�nz5�KR\�ׁzI��������L��zi�\�V�T$��T����ļ����,�~��������c��be��Ye8�2�FVV�}[e8�2h�n�+���2\X��n�7W���+C@�������ڥ�}>��Dc
&ŉ��FzC�CV#�@����H�Hz� #� �E����gzH߉�]C҅��d�d=��X��z��X?��P�Xo�z� c�D��ʕl�wd�k��~!��7�~k��������v)���v����i9����K�l�H��(�i�b�� ���b�g�]2�}G�%jyhOX��b�c�(�"�1;��@ޥS1��.��ݜȻ���MGޅ���y��nn�](���+���7���}8� ��xi��8�	���$F5)�.Y��~ �Z �6i�R��)H�>ܽMF�%�{�i���m�@�܍P^���2�+�����+�R�<�P^y���rN�]��.�#�B�]΅�ew97�.�����@�}�H�!^�� �/�����x�ߌ���K�f�H���}NE������������sv$^���I\�fw:�[���4���Χ1 ���4�2/�Oc�D��i�wd^8�����O��w~�M��W��K~h�պ?�p�V��N��� Ӫ�V]�L����V7juk��};��[�Ԇ]K�6l�P�u-ڮջ@�֟*!���W	i��F�4O��s��y���%:�<��f�b�^W3�G1O�����稭!eQ�ܱE��IFm.G�ZM�B�(�H��*N˗IZ��Q�~��aVW�8q�\��&n&b�zmMlc�zuM#���䚡-<�k皡M���17���*��3F�I���1����3��(N��J�O��u��kf�g�|.���äh4\��^�}��/Ü�HGu�q�6�ѩqf|>>.�����-���f��ɽX�p`\���2�o�Pm�C�EFw�Y{<��T��6/#̿�}S��P���Z��B��q���8�>s�D���C!�5U�ѹ�4�: ������̠��̠*��C�Tv����\rf�\���<�>�U{�jS	�j�͚Hu�v#ΓUsjXT�Z�E/����ZL�yZS���O���}�����>rkoi� Gn}Z�q��[wk6m��T�Z���@���jq�m�u��p�FВt�	7��c�95�|��RZ����sE,��IŹ���Q�u�T����[<ԯ������p.���7�u��'W����W�Εd�����J2��Jrs%���y����tk�y��uD���XFĤ{�ˈ�6G��N���Z_�6ssnjך��k+�~sr�ITE�ǡ�S5����������7����7�3R��tK�៌��l$�����g�b��Rv�o&\\z�/x�c�Iq!��A��;���Ώ-���Ư!�������X㇁���:?��.���)��w"<�-��F|ը��>�4�o�������������
����O����NZ����t3�r�-L��x��vZ��O�I����!���� q��?.H|��?/H�#�G{`�����A�1���s�:���\Ds����`���b�G��/�G?�ҐHyoI2�$��w%�ے�y4&��3�aɌ���AF}E��'��������)���Y=<�d>L�7&��^#o��DG��4�t��Ms��ol<��|g x<Ӻq7N=кp+�מ��iί6O�����Y*�&����O��N����y)�n�Z�Q���\t;g𔙺�#���c;����-�py9[朆�^�k��zM��ob��5�_�t�3�sͻ�|1ϓ?^2�/"�ϗq�C4�/�y���,����c�$����L�#e�h
^�*�O*�v	۰�m���Jܖ�ΪBqmY�>nq��j5�Wo{7Q��M|�����_kE���o◜ry���������*G��X0��(��\��q�X&��P��#�����=�x���J?rJ���~�S�S��?�����,:�j���Y��~�SUg�2���~A�c�~F�%�?dّ��m���ۇ�ڟ�$����1K`�N�g���Kv�!i�����x���F��OZ����IF����q���7 �/�Gd���JM3���Ǧ�s� ۭe��4�撳� {����fyt��E/n�7//O%���_�Fp�El����8X���m�L`0�,�Eҁ�Ż^|��,.A�i[x^��L���0b��l���H�����a���_�v��=id��n���o�Qj��";{����������������      m   Z  x��[[oT�~���h[���}.sFAH�
�Y!���k%�����+H�5Y)���]���H�`0x�����/䗤��r�Rg|�+�\|��._}U��9�;Ͷ|'?��f��j��_�Gy �r�ْ�͟�7~�N_�l�ᇜ�����&�Ǥلy]2ή�|�/F\�%���5�Ȝ���G�=�'Z�s��7�CQ���*����|�!�|���ͷ��S��-��������e|!_7�7�������r��_�(s�Ĩ��(�9��@k:�O"� o$�� �4��uCc���*�K`uau������Z~P��>�����#�����~��O����⯄�L� ���X�������#x��v?���>�c�'w�.�����쁱VEj�[��b�C��"j�ل'�5��ֆgU�=y��O�Α����/�+�@�g�[��Lc��[���ϝ�3��hs)w�y�r�Y�Z+��	8�����d�G4��TP��6��t�tٚϘ|���}���8B��5!G�(��Ds��k��H���)'4a�G��|F�f_�������[x`M�B��)��>�I����ef3qq*@�n���;�P0ok�i6U��L��Em�c����V*͏��z�4#ށ�Kz�QtN�8�3�j��m9�c���dM㜋K�蠥�୕^��PF8�A����A��Pz�r2jf�ʩw���?�3*dzo�)x`뿚�o�-�P��rM	�����푦D��w3x�i�K���D�g[�f5["<ip9z;R��5�
������3Pa��� ���|OX>T&���K9��n�N�5e袯���<{{���\�P2FC,sﱄ)2�e�{�+?�4[	�I2�s+�����������m1�s�aea�tL�HyQPr^�k���a�f�4�x�p:������ǎ|~T���O##\������\��₤$�H;��Xe�
 ��8)�в�԰��!ZN��W���$̗]V�[���%�Ϩ��Ms�b
�<S��rX�.GTPEZ�`,}�ڢ�4Z�,���+K6��+��
�h4�)�&�G�6<�Tp̮�b���ȦE�1��$�K��4m4Z��nD⯛���)�zeG�T`
`�/�����I��^��[c<��5���!�����r"eQ�N9US/��˪��pW�Ȅ��˜y��+,&_Z�h� ֣*��[O3��x|\��M4�}m<l^Gyb��:kE�{��5Ѱ�A��em������*�����a���UB\�����Cfʍ*��!��a�/�-�,= <"%<1�g]�ǉ���I|4�s�ϬCu�PvcP�Qa�C�*��1�Zdi�?�,�1*d0?]�Ų�Ct�����ӎ���]���ݱL��m��*YW�k���h�@l��E.B���B1�bS:��ߣ�ї�w�AX3����!ҞnPA���[-{���˺�=o#FpU���b�h -�"2!&�������*"<T_���
�iN�*���-�a�����Z�3��1�`y��݉|��%ѝkE������\��Er��)�9��,��1k�Ӕ���$����J�p%�؏c����T�t�$��5O��!$��筻�cC&�:v���䤋IE^����|����V)���	@p�80^u��3u�cۍ��Δ��3�~cx��b �h�pXwݳ�pSI͗�4�f���}yR8��o��ӫ�h>��j�@�1��y2ζI�g���3��rO�C���3�Ts)����i��w!h���l���p���H�E�)�kzgj x�tm�v{�h�rrEM��d��Q��п�<D�ݫ��M� ڃ��E:pZˠ/V��ʝ������ ��ꜻB���T����;� ϐ?�ċb�zn�o�Ol
��(�dΎ�|b��@�yps}x=~W�VE+Q��i���r�<��3PL���FI�R>��P�Uz~���_X��(�q`��f������S��Ǔ��-���&���&9�kV�3�Ob2#ɧr���a(��V�2NPa[���׶��)�/ѯ��yJ4���j��h�u������JŪW�]/���������Mw�;��ES�V|T�,~�||��_�o.H'�������d�g�u5���O-�kG��bR]�.��4V�/U�d�n�jU�H���"�kŢ�"���.P�v<ٱ#��T�6��Y��W���LEW3�j��5�\Y5�	K����;���N��}�,�q��Ul�1�d�K�@��!S������j�y J�x�β�6ώ���E<���⸆�&�8��G֮u��,��������^��z�`f��.\r\����|L=/
D]� 2�4YO�����nnG��6*}�'H�/��G����g�XK�u�ǰ@��lnKؿ%��2I'�ML��3'�$o�dFHa�8	蝫�m��i�>�cǓ�u���XK���q��*kiY|]�EPuh�x~�������`׊��u���qx�Ov���r����}��k��Vy����h�{��3Dɷ ��oe����,�C�]�����Ɍ��l���IIX<w$��%�|�a)�؆ވ��b�;�н�C?�7�y�m)�hT��v�گjd���)]x��wz�}WhyN��g8��61�=	Ƶ�5���g-�*��}EgP�7�e�g��s�X�F8��@��
�Y{�*�B�92k)�b̪��z׵R*7�3��q���v��!�B�+��4[Ɉ��hY�|�{��A�13�$��aU;Rr�uJn�\�%y�C$OB�/yG��t��Sa�	�T	��h�4��i�hx��v\�6&kvGh�~��^��4���$^�폢��#�j�eh�Նu4z\}�M��>ӷ�xzѥ�V��b��^���Gr���󦵇w4�}��<���m=0?=����=k��U�Iۦ��.�I��� 
f�KW�#�I�2���6[)��K���MS�4s�Op֨��eSt!��8��d�j[�p��Y����9S� �[�X�'�.������~�ŀ�T�9� G����qhU��r3S�-�V�.#"ﻩ�,O���,�����H��� q-��"�'o+Ӓ�zZ�]���-�wMN\�-��PXԯ������?�!�.2��Gn��x�_u��ʺ���t�{p�-��������qXw�K<yj��ܑB׸6,��J,�����8}��sY���7�%�A%��M��4"=#j��^ᘶW8ȥ��u�)��^��՗�{�ٴ�#)s<�4WZ�q	����j�����^��X߸��x���dѣ'���7ƃ���-0o      o   �   x�Տ��B1E��Z��|lϸ��Q� $DF.�y)lp�#ݟ����?�Yzz\��&�
���h�3̱�%.��']�J/�`(�B�)�ά�Iщ )��Fv2XΪ|�>�B�F���Vm8w�b����&�f�/�?����־h\-      r      x������ � �      q   L   x�3�L�)�/����3204u�L�KI��+*�4426153��,I-.A&��8�ZL�s3s���sqjI����� 6E �     