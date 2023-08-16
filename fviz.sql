PGDMP         *                {            fviz    12.12    12.12 R    w           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            x           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            y           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            z           1262    62417    fviz    DATABASE     �   CREATE DATABASE fviz WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Russian_Russia.1251' LC_CTYPE = 'Russian_Russia.1251';
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
       public          postgres    false            �            1255    89069    update_quantity_trigger()    FUNCTION     .  CREATE FUNCTION public.update_quantity_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.mlti_sign := 
    '<p>' ||
    CASE
      WHEN NEW."M_indicate" <> 0 THEN CONCAT('M<sup>', NEW."M_indicate", '</sup>')
      ELSE ''
    END
    || CASE
      WHEN NEW."L_indicate" <> 0 THEN CONCAT('L<sup>', NEW."L_indicate", '</sup>')
      ELSE ''
    END
    || CASE
      WHEN NEW."T_indicate" <> 0 THEN CONCAT('T<sup>', NEW."T_indicate", '</sup>')
      ELSE ''
    END
    || CASE
      WHEN NEW."I_indicate" <> 0 THEN CONCAT('I<sup>', NEW."I_indicate", '</sup>')
      ELSE ''
    END
    || CASE
      WHEN NEW."M_indicate" = 0 AND NEW."L_indicate" = 0 AND NEW."T_indicate" = 0 AND NEW."I_indicate" = 0 THEN 'L<sup>0</sup>T<sup>0</sup>'
      ELSE ''
    END
    || '</p>';

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
       public          postgres    false    205            {           0    0    gk_id_gk_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.gk_id_gk_seq OWNED BY public.gk.id_gk;
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
       public          postgres    false    221            |           0    0    gk_settings_id_gk_set_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.gk_settings_id_gk_set_seq OWNED BY public.gk_settings.id_gk_set;
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
       public          postgres    false    207            }           0    0    laws_id_law_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.laws_id_law_seq OWNED BY public.laws.id_law;
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
       public          postgres    false    209            ~           0    0    laws_type_id_type_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.laws_type_id_type_seq OWNED BY public.laws_type.id_type;
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
       public          postgres    false    211                       0    0    lt_id_lt_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.lt_id_lt_seq OWNED BY public.lt.id_lt;
          public          postgres    false    210            �            1259    80758    quantity    TABLE     �  CREATE TABLE public.quantity (
    id_value integer NOT NULL,
    val_name character varying(100),
    symbol character varying(50),
    "M_indicate" smallint NOT NULL,
    "L_indicate" smallint NOT NULL,
    "T_indicate" smallint NOT NULL,
    "I_indicate" smallint NOT NULL,
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
       public          postgres    false    221    220    221            �
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
       public          postgres    false    212    213    213            �
           2604    89369    represents id_repr    DEFAULT     x   ALTER TABLE ONLY public.represents ALTER COLUMN id_repr SET DEFAULT nextval('public.represents_id_repr_seq'::regclass);
 A   ALTER TABLE public.represents ALTER COLUMN id_repr DROP DEFAULT;
       public          postgres    false    215    214    215            �
           2604    89370    users id_user    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN id_user SET DEFAULT nextval('public.users_id_user_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN id_user DROP DEFAULT;
       public          postgres    false    217    216    217            r          0    89193    ar_internal_metadata 
   TABLE DATA           R   COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
    public          postgres    false    219   ik       d          0    80715    gk 
   TABLE DATA           M   COPY public.gk (id_gk, g_indicate, k_indicate, gk_name, gk_sign) FROM stdin;
    public          postgres    false    205   �k       t          0    97588    gk_settings 
   TABLE DATA           J   COPY public.gk_settings (id_gk_set, id_gk, id_user, gk_color) FROM stdin;
    public          postgres    false    221   m       f          0    80731    laws 
   TABLE DATA           �   COPY public.laws (id_law, law_name, first_element, second_element, third_element, fourth_element, id_user, id_type) FROM stdin;
    public          postgres    false    207   �m       h          0    80742 	   laws_type 
   TABLE DATA           7   COPY public.laws_type (id_type, type_name) FROM stdin;
    public          postgres    false    209   �m       j          0    80750    lt 
   TABLE DATA           D   COPY public.lt (id_lt, l_indicate, t_indicate, lt_sign) FROM stdin;
    public          postgres    false    211   �m       l          0    80758    quantity 
   TABLE DATA           �   COPY public.quantity (id_value, val_name, symbol, "M_indicate", "L_indicate", "T_indicate", "I_indicate", unit, id_lt, id_gk, mlti_sign) FROM stdin;
    public          postgres    false    213   `x       n          0    80766 
   represents 
   TABLE DATA           L   COPY public.represents (id_repr, title, id_user, active_values) FROM stdin;
    public          postgres    false    215   �       q          0    89185    schema_migrations 
   TABLE DATA           4   COPY public.schema_migrations (version) FROM stdin;
    public          postgres    false    218   ��       p          0    80774    users 
   TABLE DATA           b   COPY public.users (id_user, email, password, last_name, first_name, patronymic, role) FROM stdin;
    public          postgres    false    217   ��       �           0    0    gk_id_gk_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.gk_id_gk_seq', 14, true);
          public          postgres    false    204            �           0    0    gk_settings_id_gk_set_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.gk_settings_id_gk_set_seq', 14, true);
          public          postgres    false    220            �           0    0    laws_id_law_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.laws_id_law_seq', 1, false);
          public          postgres    false    206            �           0    0    laws_type_id_type_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.laws_type_id_type_seq', 1, false);
          public          postgres    false    208            �           0    0    lt_id_lt_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.lt_id_lt_seq', 371, true);
          public          postgres    false    210            �           0    0    quantity_id_value_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.quantity_id_value_seq', 120, true);
          public          postgres    false    212            �           0    0    represents_id_repr_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.represents_id_repr_seq', 1, true);
          public          postgres    false    214            �           0    0    users_id_user_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.users_id_user_seq', 1, true);
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
       public          postgres    false    217    235            �
           2620    97583     quantity update_quantity_trigger    TRIGGER     �   CREATE TRIGGER update_quantity_trigger AFTER UPDATE OF "M_indicate", "L_indicate", "T_indicate", "I_indicate" ON public.quantity FOR EACH ROW EXECUTE FUNCTION public.update_quantity_trigger();
 9   DROP TRIGGER update_quantity_trigger ON public.quantity;
       public          postgres    false    213    213    213    213    234    213            �
           2606    80835    quantity cell    FK CONSTRAINT     �   ALTER TABLE ONLY public.quantity
    ADD CONSTRAINT cell FOREIGN KEY (id_lt) REFERENCES public.lt(id_lt) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 7   ALTER TABLE ONLY public.quantity DROP CONSTRAINT cell;
       public          postgres    false    211    213    2761            �
           2606    97594 "   gk_settings gk_settings_id_gk_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.gk_settings
    ADD CONSTRAINT gk_settings_id_gk_fkey FOREIGN KEY (id_gk) REFERENCES public.gk(id_gk) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 L   ALTER TABLE ONLY public.gk_settings DROP CONSTRAINT gk_settings_id_gk_fkey;
       public          postgres    false    221    205    2755            �
           2606    97599 $   gk_settings gk_settings_id_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.gk_settings
    ADD CONSTRAINT gk_settings_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 N   ALTER TABLE ONLY public.gk_settings DROP CONSTRAINT gk_settings_id_user_fkey;
       public          postgres    false    217    221    2769            �
           2606    80805    laws laws_first_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_first_element_fkey FOREIGN KEY (first_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 F   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_first_element_fkey;
       public          postgres    false    213    207    2763            �
           2606    80810    laws laws_fourth_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_fourth_element_fkey FOREIGN KEY (fourth_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 G   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_fourth_element_fkey;
       public          postgres    false    207    213    2763            �
           2606    80815    laws laws_id_type_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_id_type_fkey FOREIGN KEY (id_type) REFERENCES public.laws_type(id_type) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 @   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_id_type_fkey;
       public          postgres    false    2759    209    207            �
           2606    80820    laws laws_id_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 @   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_id_user_fkey;
       public          postgres    false    217    2769    207            �
           2606    80825    laws laws_second_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_second_element_fkey FOREIGN KEY (second_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 G   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_second_element_fkey;
       public          postgres    false    2763    213    207            �
           2606    80830    laws laws_third_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_third_element_fkey FOREIGN KEY (third_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 F   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_third_element_fkey;
       public          postgres    false    213    207    2763            �
           2606    80840    quantity level    FK CONSTRAINT     �   ALTER TABLE ONLY public.quantity
    ADD CONSTRAINT level FOREIGN KEY (id_gk) REFERENCES public.gk(id_gk) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 8   ALTER TABLE ONLY public.quantity DROP CONSTRAINT level;
       public          postgres    false    205    2755    213            �
           2606    80845 "   represents represents_id_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.represents
    ADD CONSTRAINT represents_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 L   ALTER TABLE ONLY public.represents DROP CONSTRAINT represents_id_user_fkey;
       public          postgres    false    215    217    2769            r   ?   x�K�+�,���M�+�LI-K��/ ����u�tL�����L��M,,�Hq��qqq ��L      d   W  x���[J�@��3��F:�z[�n!���A�6E��]\@l,�&[8gG�3���2��|�����EQ���e�EMxDyH�Ӓr���S��=�<������ds�*�ƭd�sm����>�auqf����!���|�>(PR�wF.�<����(x�Y������vc]�j�z
��R���7|��� �īQ%���' ~���PQ��h�^��eU«�s����n@<���AJ8�¬�	Ce�buj��T��_F'�Et�G�).!Z�L節��X�����ƪ�v"P�pe����H���6�t#En
uM�Au�c�)}h���Vt"��iir2      t   �   x�%��D!ϼb6�W�^�"�ￄ�l�˄����01t�)�}��COʊ�F�Z�I3�<~�`ѪM�[;�$�.iش��8�7(i���^7�!{CT��P���Έ�0w�Ό*�2-^p�������ح&l      f      x������ � �      h      x������ � �      j   f
  x�}�=�&�D㞽�hJ��ރC�g��<�ޭ*vp%��� ��*�*R�]e���������������?������z��3���gĸ�e?#����ծ�gD�q����W���G�ϐ4��k׸��)c������Ҳ�w��+z�e����Av/Qόz.�+�%ʖ�:��������6��e�J}�Z�N}F�˞+�%j;�5.�Wz��E��Ψ\���f��7�Z~/-_5d�|���,�#(#y�
iѪ!�L=�+B��ך��!B�qIpވ�Pg	uF�6I�!X��!�z���Ԛ������.�m�����>�t׀n(m�w�F�����ȿ9�# ,����K��޺�k�bh�񃙄wM8>>��	���WM8D� ���#=�I8ҜAx����M�2�%��7��On��x֌�{
/�q����G3}
��q�\��0��g��#���`�8�o�8�,θ���)�r�()�r,�!�MS1R^5��!另)z@y��#�(ϒr �r����ߒr����r"���9����9Ǻ*94�Ч��9�ҕ�7�9rV��p��W�|���ꜿ� �:����v,`�� WJ�5�\ )o�r��HyՔC�F�M9�Hyє#����dȧ���"��a�^]�):�jZ/HѩW�zA�A���ԫh� Š^Y��3�UM�
`�T�� 1N�����s!��3}˺��c?Ӻ������e�����n`�>�7w0]� �-��'���a��d�^�L���>f�8�O+3�B�w�_J�4���WM:e%�&}&(��)�� ��5�A��4� �~K�o���c�1�t2I_����k���6��h֩Y���� ��4�3s�M׬w���Y"�f�E���A|���l�q�\��v�o��i�)i��v��Ѵ#E�i���vO�5��p�4�i��inM;D��I�`'�t5I_��2}M�֝(�٬(�ez���@��MӼ#w�n��(���w����ռew7+��	��o6�����l �	��8s+�c�P��i����?�v$ȽMѴ#��m�����4���ͭi���mRp�e����@��&iO��pV��2=Ίr9Pv��4�Ȟ���y��r��(��y5�@�]Ί�8Qv����� Ng�>A�����x�_I|��C�J�M<R�>�h��s$>k���$�4��}έ����sRp�fw:)���F浥'΍���,qnd�j�z#�M3���y�������F�_�<p�>��5�Ĺ;�PݻS��{��/�о�k����0wJ�h①N�&�?G�&�O�MO!H������TSp�f��)��fw�)��ę~5�f-q�c�z���Y�f8�g�y��uh恳{�W3�ݳ���9���-��Ay���ވ�;W�o����꿤���3��M=��gM=?�ԛ��R��[SOYI}
z ]ܷ��*��;�4i tq�-�.t�I��tq��4�A�k�;�������Ws�"ȧz"G��7���r��=�c9 ]��Z0���}��9 ]�F�jŰN���{�:��w���:�VhA���{��o��o�4����n���U�8m'�މ-���.1��}K%B�O���[���o���=�#���Lr���0f����)huq���0mpn��~5����a�lb�}f�MLK��1���er~��^h.���F�T����������1�Eq&��k�3)��Op"������׸��\�7�Y���7���z�9�>�\���qV�������k�-��ӱ�����s�_�<?顉Ư��.q�_M����\=��6:SE��ɚ٠��#��U}xO:�nt�����hc3u�\Mp\��8��-�����\Sw�����7��S�o���g�����gλ�<�';�h,�4 �-ͫq�������knf��y~7�L�4����h3u��ѭ*T�o(��/�.�����ݨ.��Z9�v��{P�y�c^��?.,�|O�WeA��{
:�,�ހO����[�)�E��{>/�Xн���r�mx]�Y̽?d�y#�6����ԥx��##��~ό�wFP�[��4�M՛��5�M����6�M�k��xS-�~	�珒����Ⱦi�!���o�>��V|
+��f|
z�����)�>koȧ�]���|
��)�%�ޔ��`{S~h��w1_�����}��(��\�>�}�d�`?'���4}uu������N��~f�	��*�	f�&�7�8:�f��D���"A:?3=H�>�p���7���O$DOSP0��e��0I�)�;�kk��]V�tK��<����~�G��`�o�|b\����M��E~�Z/xG�������ʚ_��k��"��>���I¤j�`��M9���f�`,�3�)�+AF �ӈ��k{Y�?�gփ�,�I8������xw �u���kk���S�[� X�^z�͂���>��E���7�.�<�4%�O�3S�\�q�:�-���y��h�����S	��̽y���W�<Ye}���8�g�cq ^?z�)�ʪ�*����EA��AI����g��Ӡ���jS�T^K�Rʧ��pv�����#�H�g��`'����ǯ_������      l   �  x��[[oW~n~�<�Hc�}f�D�uDV(�4Z��,^�f@H�H�D	Y�@"��K�}Z�1<6R~A�?ڪs�:��r�c�s��T}�Wu��((�����b���;K�⠘���~�S~\�<�zw�>��`zesDA?� ���rz��Xޟ~�O����7�h��_\�<��ʭۛ���e���Џ�?�O�����I,�*��W�?�w�N1[��?��G�ڈ�S����/&�=-��OфAmB�݆U۠$(���ś�O=�r&������%���xcc���*갹�!p���oW�1�m��?���6����^��M(��'+��˵�x�{=���Yru��Ȓ��9.�j/80j^��@lUѴ�'x`�w�?9�P�<�Nh@�̋�1����}��O��<�`�y6o�F������&� 6���=������+�꿏�����9����.啁<�s�sJà�F,X�Nj���S�Plʷ�k�k��C�=�4�~�ܠ2�7&�{g*�Z�⅓8�h8�$�yL^��q��v8z�%|���M�?4�q��'�8�sr�~��|�H<�ܛ>8{h�7f̎��IAxـFH�<\���dJ��U�\+�e^�4 Y������x0����{�"����c�2~���$qҍʍfqG"��-�t�L&���x#��m��� �w�|q���]���&75�pౄ�eH-馹���m�-ΉC��#��@UF%�c��m:�0o5�b�s���~���}�ha�WQ$^< z�b� ��M�7�9�e��W���v
�¿��R��NG�:����� � �HOpై��r�,�&�F��/���K&&Q4�,�@��8Li��0y��}X��n3�|�=	��
�[�V�h�R7Yle����	)o#��]�*�*�H�H偐U��^T�ڧ����/F��`WNO��c�#��"y�.U^oЦ,�2�߉/r3.h3������}��Cr�i��}F�幠<r��G�_T�a�]�����:��P@�P}V�[��)A�l#��Ɍ:�!1�!�J�����n��	� �'��`�U�@���P�c�/�,^��7�[�����r��D�C����*q���U�S/xV�&i²]u?�<r�<5|���S�}����TB|��^'����{�y�"���snQ�i�\��8vjL�6����X#+�EJ㜞�qE�t�1��꫋i^!m}~�
�<\>i�D�H34�����7RgV�ڹz��sd���VZ�����r�2���,9phum��E�v�S����$G���DI�e�8*�z[]��$� ��A1�3E�у{�����G� xH0�t���I�јx,7�����rW��-��J�4rH���q���oz%�*R��5]��%u��x��	�l�(�-1�Ö{�!�ug�����T1��b�b�n&�{$l�-^����~mc,)�k� �B�7i��d?��H�52?�E�� �HqWꠀ0��z"������U�B����4��F~h�|�DH:�/��Wv�bM+��Vbe��r�W��W�)��3�����s̎��c���u�h"��3��"δ�9�b{X���Ģ�!zK��൭�ڴ�x0�ƃ`R��^%R,���VBYtd8,��'6|W��fLvc?:�R�l�і/��båi���\0A�ls�]+Bn.ַ�
p���R���X졯:�8�Q�R26�S��ɂ���{��ҮH���r���P�zՖ˴L��R�iC�J��hXa��֍��:)XCZ��vU��G�j����,{��VRB�U���ۤ]C�j��̨�Q2��;��~����[ѫE���EyIep�r�%��
O�9xE�C�K�U�M17��RMO���)�7�d���y�Z�Z:��N8ި¥�����i��b�3[��w��H�l�=M�t0��j:T��� �t����� �zj�U�o�p�cl�C����C��22�Μ��l����q�J{zDnX���A�ڔ~�8��Ҵԓ���������% �`r�M�ݰ3��~��H��M ��A*�BOO1��喦a���)S�c6r0��͕��E#nŇN+ �F�e�g�A]�X�`]�`�m]�UJ ���gQ��64P��P��j�b����.~��
�<k�~a��ʪ����Q��.L�&�ы?8%r�@5��R��A�߶�͇U��/HD�]U�;�D҆��7l�f�R!�͍���F��QY��%�j!v����yϝ\�M������J�D�X�ѡtceV Ѥ�w�G��Re�w��Q,�v�wl
�݊�%��yk��ͿѯI҉F�A�,�^�����lҫ�]r������{��u-���[*�NC�ڨ���Ѷ��л�3��U����,bxf,^��<S��}̼3�S/
�
@���ģTI�pR���Y��+��[�.)���K�]}��1!oj���E���4k�*�mWn/�UL޹���#�gH���w�����x��Ҁ�����xE�#�D
n�Mc�WrT޹E��^�}��6aj�Ok��]T��3��S�E����ڨ?X�,��(��_:��xi�T�v_¡��-��RO�  ?�����\��Z�֡�W�a��6%���rX_��}WoL��,��>d5K�D�����"��s=,�~ u:OI{[Zi5�ЁrkeΙ��s�`Zg	��L�TCO������ J�!����P�VӉR� �`b���ƖBW��q�i뤭JP1a%#��~Q魖�gk�,y-�����5�^�TX�����pIzI]9� ��ץ�͚_�*�5SĘ'�;��y�%o�vb�˻0�Ӱ'����Za��M�gԍܬ�W'�����u�o�EY�oYS8��Bz�j���Nes�{��z�q�ڹ���a։��(��}@a^��l�I#�\��viC��[n��Di(�j���	��v+���-��r���n�����j��6�f�bi�w։@[��A��Ji���LS����|��3�vo�s�g5"��j�]!����qu.��+�}�B��- �K'�	+����u[��Q�!Aӆ`a� :X�pI�
�Ҵ"��#�X@��-��U����Vu�v�_����K��[F�&ǝ�X}X���V�N���f%;�3��/�Ѱ��f�[/��\��,mE�-�~+���iɐ03eeգ��26fq0r�z�It=�$�2�,���tKm�Y�x�:	1O�Y�lyq׊W*��>�@��{��i�nT]�������/��O��� ���E׋i]�z��Υ��!�,��z�ɔðyW*��I.FA�������(����P�!��zEH`~C�]O�/$�H�u���4��E�_OcFg��}Q�=��w��[Z��qC?����'N���^�      n   �   x��˩Aϻ�F�irq&��21�c���=����[���������yz<�	�BU��@���slb��x�E�D�C-)�0�ٺI
d��J)��J���/�'=(�(޹��׏f�������������P#.j      q      x������ � �      p   6   x�3�L�)�/����3204u�L�KI��+*�4426153��,I-.A&�b���� 8�     