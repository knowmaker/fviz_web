PGDMP     	    ;                {            fviz    12.12    12.12 L    p           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            q           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            r           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            s           1262    62417    fviz    DATABASE     �   CREATE DATABASE fviz WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Russian_Russia.1251' LC_CTYPE = 'Russian_Russia.1251';
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
       public          postgres    false            �            1255    89065    insert_users_trigger()    FUNCTION     �  CREATE FUNCTION public.insert_users_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO represents(title, id_user, active_quantities) VALUES ('Базовое', NEW.id_user, ARRAY[1, 2, 3, 4, 5, 6, 8, 10, 11, 12, 14, 15, 17, 19, 22, 23, 26, 28, 30, 33, 37, 38, 40, 41, 43, 45, 51, 54, 58, 60, 64, 65, 66, 70, 74, 77, 79, 80, 81, 82, 84, 87, 93, 95, 100, 101, 102, 103, 105, 109, 110, 112, 113, 115, 116, 119, 120]);

    RETURN NEW;
END;
$$;
 -   DROP FUNCTION public.insert_users_trigger();
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
    gk_name character varying(100),
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
       public          postgres    false    205            t           0    0    gk_id_gk_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.gk_id_gk_seq OWNED BY public.gk.id_gk;
          public          postgres    false    204            �            1259    80731    laws    TABLE     :  CREATE TABLE public.laws (
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
       public          postgres    false    207            u           0    0    laws_id_law_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.laws_id_law_seq OWNED BY public.laws.id_law;
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
       public          postgres    false    209            v           0    0    laws_type_id_type_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.laws_type_id_type_seq OWNED BY public.laws_type.id_type;
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
       public          postgres    false    211            w           0    0    lt_id_lt_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.lt_id_lt_seq OWNED BY public.lt.id_lt;
          public          postgres    false    210            �            1259    80758    quantity    TABLE     �  CREATE TABLE public.quantity (
    id_value integer NOT NULL,
    value_name character varying(200),
    symbol character varying(100),
    m_indicate_auto smallint NOT NULL,
    l_indicate_auto smallint NOT NULL,
    t_indicate_auto smallint NOT NULL,
    i_indicate_auto smallint NOT NULL,
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
       public          postgres    false    213            x           0    0    quantity_id_value_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.quantity_id_value_seq OWNED BY public.quantity.id_value;
          public          postgres    false    212            �            1259    80766 
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
       public          postgres    false    215            y           0    0    represents_id_repr_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.represents_id_repr_seq OWNED BY public.represents.id_repr;
          public          postgres    false    214            �            1259    89185    schema_migrations    TABLE     R   CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);
 %   DROP TABLE public.schema_migrations;
       public         heap    postgres    false            �            1259    80774    users    TABLE     |  CREATE TABLE public.users (
    id_user integer NOT NULL,
    email character varying(100) NOT NULL,
    password character varying NOT NULL,
    last_name character varying(100),
    first_name character varying(100),
    patronymic character varying(100),
    role boolean DEFAULT false NOT NULL,
    confirmation_token character varying,
    confirmed boolean DEFAULT false
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
       public          postgres    false    217            z           0    0    users_id_user_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_id_user_seq OWNED BY public.users.id_user;
          public          postgres    false    216            �
           2604    89363    gk id_gk    DEFAULT     d   ALTER TABLE ONLY public.gk ALTER COLUMN id_gk SET DEFAULT nextval('public.gk_id_gk_seq'::regclass);
 7   ALTER TABLE public.gk ALTER COLUMN id_gk DROP DEFAULT;
       public          postgres    false    204    205    205            �
           2604    89365    laws id_law    DEFAULT     j   ALTER TABLE ONLY public.laws ALTER COLUMN id_law SET DEFAULT nextval('public.laws_id_law_seq'::regclass);
 :   ALTER TABLE public.laws ALTER COLUMN id_law DROP DEFAULT;
       public          postgres    false    206    207    207            �
           2604    89366    laws_type id_type    DEFAULT     v   ALTER TABLE ONLY public.laws_type ALTER COLUMN id_type SET DEFAULT nextval('public.laws_type_id_type_seq'::regclass);
 @   ALTER TABLE public.laws_type ALTER COLUMN id_type DROP DEFAULT;
       public          postgres    false    209    208    209            �
           2604    89367    lt id_lt    DEFAULT     d   ALTER TABLE ONLY public.lt ALTER COLUMN id_lt SET DEFAULT nextval('public.lt_id_lt_seq'::regclass);
 7   ALTER TABLE public.lt ALTER COLUMN id_lt DROP DEFAULT;
       public          postgres    false    211    210    211            �
           2604    89368    quantity id_value    DEFAULT     v   ALTER TABLE ONLY public.quantity ALTER COLUMN id_value SET DEFAULT nextval('public.quantity_id_value_seq'::regclass);
 @   ALTER TABLE public.quantity ALTER COLUMN id_value DROP DEFAULT;
       public          postgres    false    213    212    213            �
           2604    89369    represents id_repr    DEFAULT     x   ALTER TABLE ONLY public.represents ALTER COLUMN id_repr SET DEFAULT nextval('public.represents_id_repr_seq'::regclass);
 A   ALTER TABLE public.represents ALTER COLUMN id_repr DROP DEFAULT;
       public          postgres    false    215    214    215            �
           2604    89370    users id_user    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN id_user SET DEFAULT nextval('public.users_id_user_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN id_user DROP DEFAULT;
       public          postgres    false    217    216    217            m          0    89193    ar_internal_metadata 
   TABLE DATA           R   COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
    public          postgres    false    219   `       _          0    80715    gk 
   TABLE DATA           T   COPY public.gk (id_gk, g_indicate, k_indicate, gk_name, gk_sign, color) FROM stdin;
    public          postgres    false    205   V`       a          0    80731    laws 
   TABLE DATA           �   COPY public.laws (id_law, law_name, first_element, second_element, third_element, fourth_element, id_user, id_type, combination) FROM stdin;
    public          postgres    false    207   b       c          0    80742 	   laws_type 
   TABLE DATA           7   COPY public.laws_type (id_type, type_name) FROM stdin;
    public          postgres    false    209   �b       e          0    80750    lt 
   TABLE DATA           D   COPY public.lt (id_lt, l_indicate, t_indicate, lt_sign) FROM stdin;
    public          postgres    false    211   �b       g          0    80758    quantity 
   TABLE DATA           �   COPY public.quantity (id_value, value_name, symbol, m_indicate_auto, l_indicate_auto, t_indicate_auto, i_indicate_auto, unit, id_lt, id_gk, mlti_sign) FROM stdin;
    public          postgres    false    213   �n       i          0    80766 
   represents 
   TABLE DATA           P   COPY public.represents (id_repr, title, id_user, active_quantities) FROM stdin;
    public          postgres    false    215   �{       l          0    89185    schema_migrations 
   TABLE DATA           4   COPY public.schema_migrations (version) FROM stdin;
    public          postgres    false    218   �|       k          0    80774    users 
   TABLE DATA           �   COPY public.users (id_user, email, password, last_name, first_name, patronymic, role, confirmation_token, confirmed) FROM stdin;
    public          postgres    false    217   �|       {           0    0    gk_id_gk_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.gk_id_gk_seq', 14, true);
          public          postgres    false    204            |           0    0    laws_id_law_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.laws_id_law_seq', 25, true);
          public          postgres    false    206            }           0    0    laws_type_id_type_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.laws_type_id_type_seq', 6, true);
          public          postgres    false    208            ~           0    0    lt_id_lt_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.lt_id_lt_seq', 410, true);
          public          postgres    false    210                       0    0    quantity_id_value_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.quantity_id_value_seq', 121, false);
          public          postgres    false    212            �           0    0    represents_id_repr_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.represents_id_repr_seq', 74, true);
          public          postgres    false    214            �           0    0    users_id_user_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.users_id_user_seq', 39, true);
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
           1259    97652    idx_unique_id_lt_id_gk    INDEX     Z   CREATE UNIQUE INDEX idx_unique_id_lt_id_gk ON public.quantity USING btree (id_lt, id_gk);
 *   DROP INDEX public.idx_unique_id_lt_id_gk;
       public            postgres    false    213    213            �
           1259    97642    unique_combination_user    INDEX     _   CREATE UNIQUE INDEX unique_combination_user ON public.laws USING btree (combination, id_user);
 +   DROP INDEX public.unique_combination_user;
       public            postgres    false    207    207            �
           2620    89066    users insert_users_trigger    TRIGGER     ~   CREATE TRIGGER insert_users_trigger AFTER INSERT ON public.users FOR EACH ROW EXECUTE FUNCTION public.insert_users_trigger();
 3   DROP TRIGGER insert_users_trigger ON public.users;
       public          postgres    false    217    234            �
           2620    97623 !   quantity update_mlti_sign_trigger    TRIGGER     �   CREATE TRIGGER update_mlti_sign_trigger BEFORE INSERT OR UPDATE OF m_indicate_auto, l_indicate_auto, t_indicate_auto, i_indicate_auto ON public.quantity FOR EACH ROW EXECUTE FUNCTION public.update_mlti_sign_function();
 :   DROP TRIGGER update_mlti_sign_trigger ON public.quantity;
       public          postgres    false    233    213    213    213    213    213            �
           2606    80835    quantity cell    FK CONSTRAINT     �   ALTER TABLE ONLY public.quantity
    ADD CONSTRAINT cell FOREIGN KEY (id_lt) REFERENCES public.lt(id_lt) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 7   ALTER TABLE ONLY public.quantity DROP CONSTRAINT cell;
       public          postgres    false    213    211    2759            �
           2606    80805    laws laws_first_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_first_element_fkey FOREIGN KEY (first_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 F   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_first_element_fkey;
       public          postgres    false    2762    213    207            �
           2606    80810    laws laws_fourth_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_fourth_element_fkey FOREIGN KEY (fourth_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 G   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_fourth_element_fkey;
       public          postgres    false    213    207    2762            �
           2606    97643    laws laws_id_type_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_id_type_fkey FOREIGN KEY (id_type) REFERENCES public.laws_type(id_type) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;
 @   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_id_type_fkey;
       public          postgres    false    2757    207    209            �
           2606    80820    laws laws_id_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 @   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_id_user_fkey;
       public          postgres    false    207    217    2768            �
           2606    80825    laws laws_second_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_second_element_fkey FOREIGN KEY (second_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 G   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_second_element_fkey;
       public          postgres    false    2762    213    207            �
           2606    80830    laws laws_third_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_third_element_fkey FOREIGN KEY (third_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 F   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_third_element_fkey;
       public          postgres    false    2762    207    213            �
           2606    80840    quantity level    FK CONSTRAINT     �   ALTER TABLE ONLY public.quantity
    ADD CONSTRAINT level FOREIGN KEY (id_gk) REFERENCES public.gk(id_gk) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 8   ALTER TABLE ONLY public.quantity DROP CONSTRAINT level;
       public          postgres    false    213    2752    205            �
           2606    80845 "   represents represents_id_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.represents
    ADD CONSTRAINT represents_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 L   ALTER TABLE ONLY public.represents DROP CONSTRAINT represents_id_user_fkey;
       public          postgres    false    2768    217    215            m   ?   x�K�+�,���M�+�LI-K��/ ����u�tL�����L��M,,�Hq��qqq ��L      _   �  x����J�@�ϙ�(��n��k����&=�?�H�������R5}��7rvۤ�&H���䛙o�Y.-|�1~`�5�y���o���U��gN���v�����m�����ƲS��P ��&?㻺[�83�1Qk���(��eM�1�'�%ʄ(}��9q��F\a�zt��Qq�a;�� �<���A����ۣ�B/���,|�L?��Fs*2��Z\�IS&iq�~�Խ�.U���m8�ܵ��2T���,�9����j��@#rڥ�����o:���+\�aU���q�Q~T��/#^�rb��1��_�(;e�^��$0�W
�T��}-:i�����c^�h.�L �{\���ʩ�MJG��Z?J����)�⇾H;�<S����gm���ii' ���O+      a      x�m�1
�0�Y:���U�K��K�i���W�1IA��dz���A�('R#8�L˝�pQK��Ƹ��w�.Ѥ�,MB�ZdM]��9_d�(]P�`cՋD��4~am�q�~h�񓯅]����?�EB�      c      x�3�,c.30m\&`>W� �w�      e   �  x�u�K��D���EI���W��z�ߥ2�T8=<��EO~�*�9��\������������������GY���/:�ֱ�.S����Ǣ�Ee:�y��Ǣ͋���/��v/�SY�����Xvx�6�2�m,+�e������|�e�c��e�T�4_cY},���Me����u�S������W����׭�8���[>����5���,�V�[�ΏCZ�m�yW4?�muZ�q��}��G�i0��+Ff�?{��������o�����%m����(8_���Op^�s�k�7��������[�=8?�s��.�s�����ɜ��]�_̹��y�=��} ��,4�hHy (?�r�q�;RnY��|C�}AGP^�r_u�Z)��"C�z���a��e)Z�u�^���^;�e)��kC�,�zU��R��׊z�~��Typ�^a!�`1��+��Ҟ��/؞�r�~�3T�y��z��(<Î��j_����+<CC�`��'z��%�p�g�-_�	��5$�W����n���>�!~4�RHz���Hz��oH���u	�+�^�(H_��Ջ���/�I_���Knҍ��^���z�(X��z�-Xߐ�T)Xߑ�݋��Y7��`�!�͋��Y?�(X���ˋ�zB������^^h��Ӿ��n�K�~ �)Gо#�����+*A{E�}�kо"������2�A���[���}FǞ(��;&|���W�=O�oȻuZ��y��n��w��!�FY�͉�eU7�n�Uݘ�'�	r�o�٭{�p������� ?�g1jH�#햵���RmS�v_�j�i��U���2��Y�v���ff�(Guc���箂����|Q��'�V*j���ݚ��9�wߞ����eU9'�n�U�\ȻQV�c���'ʪsL��V�W:	��V��:��o�� ~G�-��oH��HuNE�����������s$޲�Ι��'̪tfN��#�ǒ>q>����VG0�#�V��d�8�|C��̟����*�����r���>a���'\��U�߁Z^Z5ԪyQhu�Vy���B�./R�oA�l�U���"l�U9����$l�UY����KX{�ec/a��Q/T��G-�7�:g����|Ny��ͣ<��j��Q�S��p������Eq���P�ʀ4������^���@ql�e�ą�;$�@�ad�U�!�X� �?�E���1N�evu�{�lh\8vR��UQ���j��WIU�j�H�_��Lƣ���+��h>,�!�#�M�If��{�_頧lLc_:Ry��.n
�E�sS������O�U�>g-D�]�M!f��)=�y�a�+��������������o�I¤r�����W�T�b��1��O��_�������y�IU�~!΃�H�O����q0�w�02lڸ���BȻ������Tv����Tv�8[�GD����f������j���la��ō� [�M�p�!�J�,�bKp@�՘�~=6�뮨��.^r�#S2�]sU�`01*U��7���!sp~B�* f����UB����G����E{�;��8>��Ec|!�F�c��@j����؋z��'�-������[��p�§��p���>m}X�%�kcx��0�K�׶��aj�_x�n���w�Ǯl{*�����]T�k���!
"���Y����*�!���E)��>��QaJo�eA���\~,R�������K��>֧7�w��J���x��z�1߾�"�O�,~1��R-p���>�'�T�!�޼��	�J�w$ܢF��ᾞH���k�l_{�K�˘9�8�M�B�;.��4�Ky�{���e��[H%�>�ZH��e�B-��d�p�R�$�~�i�K���D�p����R�¹V��J�
g[٧P�U8�*�%\�3��h�2���ڔ�d�kKujÅL��'S���y�2 `�����Lm4�0��W1�����YOE%���9&��0�?V`�cbƲ:?�8��_��Q��Y߁�!
OC$��(<��k ��DD����3	xO�x*"�􄕀�w���(l�,l��
;��H�/Y�ʖ�{�%T�˫���_�q�F�<��+�ynʈo�g�_%�,�dK8�L����!��&/8&��o}P�eR���J�M�����|S���Dva{Ü'&�ֳE��0�[o���D����j<=�]�.�M7�zZ�'�	�a�__Ot��}���k�|�[�V����T �����Sb�˟��*<7�W��R�0��΢����|���ǒ򁮇Y�':��T�N�gG�˞k�0d�Z�������s������s���t����s:/M+��C�C��C��C�ܛ��P�U�oH}.
�+R�?�s���R�R�R��*���u��lx<)�aT1�L�ȵ�'�*�gvu�]��P������G5х�88TAę��6�Fv8v�>��G�/��J��Q�ART?��������qWj�2.=�F��k1lkcMX����\^b�8S�+��%�x��B���Mq��sc�ǝ7�|2σ����Ť*�\�� U����k�,\ݏ}GX9��q��)R��Pp�Yo�� 0��R�j�s|���3g������9�Է�m���̉C:G5��9�OU{+�=O�V5����g���=�,&4牷�ղ�<q4!ke�y�t�Y)k�s���RU�ylw}U��;�����V�ʖ���=����yO��f���'Ж�r�����Wd?�s��bh�sA��=[�*����=k�ªj�3��o2�ގ�7m='��k���7�[S��lM}�HD6��I����*cB��3�zO��s��S>���m�h�NT��c��@<���#���:l���ϔ�o񌂙z�Χ|��7]=��7�9��K9q�_R����@��G��T��x:q��ϹE��,�����?�����m      g   (  x��[[oT�~��+�h[����9sfFEHJD"�S���J���<ێ �Ieb�J�&H}�d��������������:�H���Z{]�o���j��Qo�{uRo������#�A��گ��Q�������+�#��K�K�.��O_^�/�a���HHq���3zї�U�	�<�m���A�L¿>���u��?w�-zJR���<+��̗�Y�P������`�5��?�s���D/ԫz�}N(I����H���$8�����`2����(�"�9�����z+0hh_0m	_�����C�V0�������{t!��a(ol�^��:h>�!����ó⯅��B��N�� ]|��]꿪cx�5�v
���|�/��]�`��1؃«���̷ȵ�k�� ڪ����ƣ���*�g�����9V����}q��
�xJ��D$f�}��.�\�A��&}
�>��+�E�HΨt�L�����o�-�~"c��Ā�؅��d�N`@���T��;��&��q� ��_oBZ�F��&s��k��H���+'4a	��|F��ósc���7��	���N)ѓ�&��/�����f��$�`���]Y���`�֥���ϳ��Ex�,�h_�@lRZa��͸��eK�^4�g�D�����S�j��M�8�c���pU�9� 3�AK/;��F���pl�T|��R͏ ;�n�?T�Q3�0���2���)�+�cxc˃X��pmC�h�B�.�
�����͑�L��w;x�i�K��W�ٲ�%�V�D,2��p)z7R���%.k|&6���;�OA�]8�{�� �o�;��2�T�\��_{�:��� 6��N�����i���S�:���_�6��Z�W(+�����[o'�Lڐ�_X�r$Ě��_��Ֆ¾0qv�Or>&���((���5�E�0г�XS<�:��r���cW�?���]�##\������\T/ㆄ����d,�����t=�jT_��'Wf�	cx=�-)h�,F�|��U��y��񡳶�wbc�̟��.�hdxl�ZmMYeU����^�*�G��@q�JTNi�����Pko9����REK���W9��8W��R��F�Z�N�-��ڒ��ѹ�ꍲ$��Cۈ�`�G�y(�7���;�#�T���qC�&�G6-��EF�G�IS��hv>���nNn0��Q䝃z%���	��g� 3
���y����2��75A��6���7��*֮"��^PF������Q!����,4{�^X�m�(���	���g,D��8�[d���x���ET��#�ՅUqnX�'�x�5�okGom�P���n��5�	�O���/�wH	��*���L���Z���F����݅��44�:jh�?l,ܵ�CB����BKM1&����בXu��%�r<�(�s� ?��〽���Y2�1���'&w���Ŷ�(�r�
D�3h��#�����I�;8:Z��X����4o�
kީ�9�7E�{L�"m�f�p�h��e��T	�ݘ��п�GQ�Vss	�z��p.�Az�<�{9�g^� be�v/~+�x>�?�"]]H��a�P��S5���YO� >���������#��DX(�YiZŐ��/�������񻺴`'�Fm�Rp��L:O@��7�%����7�V�J���#@7<C*��ZR�sS�|8�xr�y~2|��}�ݪm����4����!�Z_���*m�Q�*k��$�8\�8� nX�_�k��V�7�70#��2�Dq��I:��"�$��2ٍve�Q^�s(�d�/]��"�Ъ�x�	�*���@�)Y�	3C�0���4T}�P4�	^�t��}��.j�\����L��!r�r�O��㍣v���F��������tv3OH�=V��^ω���ǝ���qg:ЏX����6��2���麋Ƭg�bP�̏�@l�Ė�$�ź9]+6��vW�i�+%���ɠ��L���q�d�o����!��o���>���p��y@{ ���g�;�x�id�>�ٲ�iy7N�*���0����0`�6N�:���Ü���Sz.K���Mgϊ#B���]��Er��FG��c2!��cp��.'ӱN���M��`�=©�3�6�����������>�?6(d2o1@;dLN~"�9�"6����W���	Q�=ϕ�p���n�p�XB=���!�T���ؚ*�"m­p��O�HhQu�J|J��>��%jy��Z�H.�n3f>;d6e��X�)�/�p�m��Z^�4��b�Ӱ���������"`_4�,q5R�._�W"��"\����۴�'[V����d�L��3�Շ�{�$ʶ�嘱��\[1܏�[̬�����ql'���}�۵qh|R�9ƀJ�\�X�csQ ��i"�^>� �o��4p�yv�3�GO�o��r�l]׿͠v��ڶZv⒋ސ�� 1��x���`j�B�.�{-���@N�i>�.�D��g:���1/ZI�����4=��joB;��#nj���Q�.Ԋ/����`":�I��@.R�N*�d�،ѝ8Wr��`Z�w |���b$��XqP%���Q��#��i.�썓*�LLhHB�rg3�0 o۞��"%s=WX��@o��wd��\��֩��BΔ��L�,�`�4:;������sǤu��������K,n-M����:W�&¬9�K*+��xW��V8�c��K���s��ԑ�ŕ����� }��Jޘ�7�33�8��U5�U�1��qa�D�N�"IRv��'GQm;�ͅ u���A�5���!ѐC;��U�e2�|]A�t<�؃E�"��rx���N+ۀk4�9�\gd"��c%�k&����6��tR��-�K'��0���J�es(�1K	L���<�������j��U���m64�}�뇽?�b���r����ݸ2#l���ik�a�g�g��1N*]z���ɵ.S~�;�~�
��l���C5w���%Pҍ+��`x��bU�$�d6"�UzC/x�������!����n+'~�� ����j4��R��kh��FJ���ȔP,�b��^���D�����K��p�5ok��]y�&�Myo㝎��ɶ:l��Es��t���_��NW�y,�5& ���WVD�u#�v���MJ<�����O��NGpS��y�혒���_� i�����0��\"`�����J޶Zl�qy���9�r��R�VH�E��L�yz>V���Y�+_�+��9���;+����m`��*�%q�㺻1�og�=DZ��'�5��z���E}      i   �   x�Տ�M�1D�ϵ<���^��	G��:AH��\��ZM2�μ�c�������G����U1��3����hG]�a�l�;��$�P��;]�2�F�R� �\La*Ә�L��*_�O�P�Q�tz�N�򴼓CG�|�{K�;�׿���������/���å����b      l      x������ � �      k   %  x���OO�p�����M��Bp`��Ԇ�7�[��$�p�?��N][�^Dk��J_��;
֥���ٞ=�^><��� ~p{�� ���!|�MT^a�$�-��B}��l�-o\b�~�R�KL����ʼ#�i�5�mõ��Bj&��Yo�Q��cgfհ=q�A��	v�9�� o����yh�/�i)�I�
�O�O3Bw�X�����y4ӯ�Q�^�w�HD��t<{�d�lF�i�x�9�Ϛ���0�t)��-+�t�Y�]�>�>�x-m�b��Ŷd��/e�z^���#f�`��ѣX     