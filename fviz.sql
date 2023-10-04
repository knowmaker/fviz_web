PGDMP     
                	    {            fviz    12.12    12.12 P    u           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            v           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            w           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            x           1262    62417    fviz    DATABASE     �   CREATE DATABASE fviz WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Russian_Russia.1251' LC_CTYPE = 'Russian_Russia.1251';
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
       public          postgres    false    205            y           0    0    gk_id_gk_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.gk_id_gk_seq OWNED BY public.gk.id_gk;
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
       public          postgres    false    207            z           0    0    laws_id_law_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.laws_id_law_seq OWNED BY public.laws.id_law;
          public          postgres    false    206            �            1259    80742 	   laws_type    TABLE     �   CREATE TABLE public.laws_type (
    id_type integer NOT NULL,
    type_name character varying(100) NOT NULL,
    color character varying(50) DEFAULT '#000000'::character varying NOT NULL
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
       public          postgres    false    209            {           0    0    laws_type_id_type_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.laws_type_id_type_seq OWNED BY public.laws_type.id_type;
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
       public          postgres    false    211            |           0    0    lt_id_lt_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.lt_id_lt_seq OWNED BY public.lt.id_lt;
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
       public          postgres    false    213            }           0    0    quantity_id_value_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.quantity_id_value_seq OWNED BY public.quantity.id_value;
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
       public          postgres    false    215            ~           0    0    represents_id_repr_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.represents_id_repr_seq OWNED BY public.represents.id_repr;
          public          postgres    false    214            �            1259    89185    schema_migrations    TABLE     R   CREATE TABLE public.schema_migrations (
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
    active_repr integer
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
       public          postgres    false    217                       0    0    users_id_user_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_id_user_seq OWNED BY public.users.id_user;
          public          postgres    false    216            �
           2604    89363    gk id_gk    DEFAULT     d   ALTER TABLE ONLY public.gk ALTER COLUMN id_gk SET DEFAULT nextval('public.gk_id_gk_seq'::regclass);
 7   ALTER TABLE public.gk ALTER COLUMN id_gk DROP DEFAULT;
       public          postgres    false    205    204    205            �
           2604    89365    laws id_law    DEFAULT     j   ALTER TABLE ONLY public.laws ALTER COLUMN id_law SET DEFAULT nextval('public.laws_id_law_seq'::regclass);
 :   ALTER TABLE public.laws ALTER COLUMN id_law DROP DEFAULT;
       public          postgres    false    206    207    207            �
           2604    89366    laws_type id_type    DEFAULT     v   ALTER TABLE ONLY public.laws_type ALTER COLUMN id_type SET DEFAULT nextval('public.laws_type_id_type_seq'::regclass);
 @   ALTER TABLE public.laws_type ALTER COLUMN id_type DROP DEFAULT;
       public          postgres    false    209    208    209            �
           2604    89367    lt id_lt    DEFAULT     d   ALTER TABLE ONLY public.lt ALTER COLUMN id_lt SET DEFAULT nextval('public.lt_id_lt_seq'::regclass);
 7   ALTER TABLE public.lt ALTER COLUMN id_lt DROP DEFAULT;
       public          postgres    false    210    211    211            �
           2604    89368    quantity id_value    DEFAULT     v   ALTER TABLE ONLY public.quantity ALTER COLUMN id_value SET DEFAULT nextval('public.quantity_id_value_seq'::regclass);
 @   ALTER TABLE public.quantity ALTER COLUMN id_value DROP DEFAULT;
       public          postgres    false    212    213    213            �
           2604    89369    represents id_repr    DEFAULT     x   ALTER TABLE ONLY public.represents ALTER COLUMN id_repr SET DEFAULT nextval('public.represents_id_repr_seq'::regclass);
 A   ALTER TABLE public.represents ALTER COLUMN id_repr DROP DEFAULT;
       public          postgres    false    214    215    215            �
           2604    89370    users id_user    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN id_user SET DEFAULT nextval('public.users_id_user_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN id_user DROP DEFAULT;
       public          postgres    false    216    217    217            r          0    89193    ar_internal_metadata 
   TABLE DATA           R   COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
    public          postgres    false    219   �g       d          0    80715    gk 
   TABLE DATA           T   COPY public.gk (id_gk, g_indicate, k_indicate, gk_name, gk_sign, color) FROM stdin;
    public          postgres    false    205   h       f          0    80731    laws 
   TABLE DATA           �   COPY public.laws (id_law, law_name, first_element, second_element, third_element, fourth_element, id_user, id_type, combination) FROM stdin;
    public          postgres    false    207   �i       h          0    80742 	   laws_type 
   TABLE DATA           >   COPY public.laws_type (id_type, type_name, color) FROM stdin;
    public          postgres    false    209   j       j          0    80750    lt 
   TABLE DATA           D   COPY public.lt (id_lt, l_indicate, t_indicate, lt_sign) FROM stdin;
    public          postgres    false    211   �j       l          0    80758    quantity 
   TABLE DATA           �   COPY public.quantity (id_value, value_name, symbol, m_indicate_auto, l_indicate_auto, t_indicate_auto, i_indicate_auto, unit, id_lt, id_gk, mlti_sign) FROM stdin;
    public          postgres    false    213   �v       n          0    80766 
   represents 
   TABLE DATA           P   COPY public.represents (id_repr, title, id_user, active_quantities) FROM stdin;
    public          postgres    false    215   ��       q          0    89185    schema_migrations 
   TABLE DATA           4   COPY public.schema_migrations (version) FROM stdin;
    public          postgres    false    218   N�       p          0    80774    users 
   TABLE DATA           �   COPY public.users (id_user, email, password, last_name, first_name, patronymic, role, confirmation_token, confirmed, active_repr) FROM stdin;
    public          postgres    false    217   k�       �           0    0    gk_id_gk_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.gk_id_gk_seq', 14, true);
          public          postgres    false    204            �           0    0    laws_id_law_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.laws_id_law_seq', 29, true);
          public          postgres    false    206            �           0    0    laws_type_id_type_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.laws_type_id_type_seq', 6, true);
          public          postgres    false    208            �           0    0    lt_id_lt_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.lt_id_lt_seq', 420, true);
          public          postgres    false    210            �           0    0    quantity_id_value_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.quantity_id_value_seq', 212, true);
          public          postgres    false    212            �           0    0    represents_id_repr_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.represents_id_repr_seq', 80, true);
          public          postgres    false    214            �           0    0    users_id_user_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.users_id_user_seq', 43, true);
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
       public          postgres    false    236    217            �
           2620    97660 #   quantity remove_quantity_id_trigger    TRIGGER     �   CREATE TRIGGER remove_quantity_id_trigger AFTER DELETE ON public.quantity FOR EACH ROW EXECUTE FUNCTION public.remove_quantity_id();
 <   DROP TRIGGER remove_quantity_id_trigger ON public.quantity;
       public          postgres    false    221    213            �
           2620    97687 %   represents update_active_repr_trigger    TRIGGER     �   CREATE TRIGGER update_active_repr_trigger AFTER DELETE ON public.represents FOR EACH ROW EXECUTE FUNCTION public.update_active_repr();
 >   DROP TRIGGER update_active_repr_trigger ON public.represents;
       public          postgres    false    235    215            �
           2606    80835    quantity cell    FK CONSTRAINT     �   ALTER TABLE ONLY public.quantity
    ADD CONSTRAINT cell FOREIGN KEY (id_lt) REFERENCES public.lt(id_lt) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 7   ALTER TABLE ONLY public.quantity DROP CONSTRAINT cell;
       public          postgres    false    211    2762    213            �
           2606    97681    users fk_active_repr    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_active_repr FOREIGN KEY (active_repr) REFERENCES public.represents(id_repr) ON UPDATE CASCADE ON DELETE SET NULL;
 >   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_active_repr;
       public          postgres    false    215    217    2767            �
           2606    80805    laws laws_first_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_first_element_fkey FOREIGN KEY (first_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 F   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_first_element_fkey;
       public          postgres    false    207    2765    213            �
           2606    80810    laws laws_fourth_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_fourth_element_fkey FOREIGN KEY (fourth_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 G   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_fourth_element_fkey;
       public          postgres    false    207    2765    213            �
           2606    97643    laws laws_id_type_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_id_type_fkey FOREIGN KEY (id_type) REFERENCES public.laws_type(id_type) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;
 @   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_id_type_fkey;
       public          postgres    false    2760    207    209            �
           2606    80820    laws laws_id_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 @   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_id_user_fkey;
       public          postgres    false    217    207    2771            �
           2606    80825    laws laws_second_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_second_element_fkey FOREIGN KEY (second_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 G   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_second_element_fkey;
       public          postgres    false    2765    213    207            �
           2606    80830    laws laws_third_element_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.laws
    ADD CONSTRAINT laws_third_element_fkey FOREIGN KEY (third_element) REFERENCES public.quantity(id_value) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 F   ALTER TABLE ONLY public.laws DROP CONSTRAINT laws_third_element_fkey;
       public          postgres    false    207    2765    213            �
           2606    80840    quantity level    FK CONSTRAINT     �   ALTER TABLE ONLY public.quantity
    ADD CONSTRAINT level FOREIGN KEY (id_gk) REFERENCES public.gk(id_gk) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 8   ALTER TABLE ONLY public.quantity DROP CONSTRAINT level;
       public          postgres    false    205    213    2755            �
           2606    80845 "   represents represents_id_user_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.represents
    ADD CONSTRAINT represents_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 L   ALTER TABLE ONLY public.represents DROP CONSTRAINT represents_id_user_fkey;
       public          postgres    false    217    215    2771            r   ?   x�K�+�,���M�+�LI-K��/ ����u�tL�����L��M,,�Hq��qqq ��L      d   �  x����J�@�ϙ�(��n��k����&=�?�H�������R5}��7rvۤ�&H���䛙o�Y.-|�1~`�5�y���o���U��gN���v�����m�����ƲS��P ��&?㻺[�83�1Qk���(��eM�1�'�%ʄ(}��9q��F\a�zt��Qq�a;�� �<���A����ۣ�B/���,|�L?��Fs*2��Z\�IS&iq�~�Խ�.U���m8�ܵ��2T���,�9����j��@#rڥ�����o:���+\�aU���q�Q~T��/#^�rb��1��_�(;e�^��$0�W
�T��}-:i�����c^�h.�L �{\���ʩ�MJG��Z?J����)�⇾H;�<S����gm���ii' ���O+      f   �   x�m��
�0�s�,E����K�;�C:2��&�Z����%-�1�sx\�=p��P�[�N0�xb���09l�R��*�HQ��D�iz�P%�R*ۍL���1���#�H���wjymw�IY�T]���������q9��J_���l�JiڣyQiX���җ6��L�(n��Ѓ�a^,���4��s���io      h   (   x�3�,cNe0�2�` .nq�LS�b���� ��      j   �  x�u�K��D���EI���W��z�ߥ2�T8=<��EO~�*�9��\������������������GY���/:�ֱ�.S����Ǣ�Ee:�y��Ǣ͋���/��v/�SY�����Xvx�6�2�m,+�e������|�e�c��e�T�4_cY},���Me����u�S������W����׭�8���[>����5���,�V�[�ΏCZ�m�yW4?�muZ�q��}��G�i0��+Ff�?{��������o�����%m����(8_���Op^�s�k�7��������[�=8?�s��.�s�����ɜ��]�_̹��y�=��} ��,4�hHy (?�r�q�;RnY��|C�}AGP^�r_u�Z)��"C�z���a��e)Z�u�^���^;�e)��kC�,�zU��R��׊z�~��Typ�^a!�`1��+��Ҟ��/؞�r�~�3T�y��z��(<Î��j_����+<CC�`��'z��%�p�g�-_�	��5$�W����n���>�!~4�RHz���Hz��oH���u	�+�^�(H_��Ջ���/�I_���Knҍ��^���z�(X��z�-Xߐ�T)Xߑ�݋��Y7��`�!�͋��Y?�(X���ˋ�zB������^^h��Ӿ��n�K�~ �)Gо#�����+*A{E�}�kо"������2�A���[���}FǞ(��;&|���W�=O�oȻuZ��y��n��w��!�FY�͉�eU7�n�Uݘ�'�	r�o�٭{�p������� ?�g1jH�#햵���RmS�v_�j�i��U���2��Y�v���ff�(Guc���箂����|Q��'�V*j���ݚ��9�wߞ����eU9'�n�U�\ȻQV�c���'ʪsL��V�W:	��V��:��o�� ~G�-��oH��HuNE�����������s$޲�Ι��'̪tfN��#�ǒ>q>����VG0�#�V��d�8�|C��̟����*�����r���>a���'\��U�߁Z^Z5ԪyQhu�Vy���B�./R�oA�l�U���"l�U9����$l�UY����KX{�ec/a��Q/T��G-�7�:g����|Ny��ͣ<��j��Q�S��p������Eq���P�ʀ4������^���@ql�e�ą�;$�@�ad�U�!�X� �?�E���1N�evu�{�lh\8vR��UQ���j��WIU�j�H�_��Lƣ���+��h>,�!�#�M�If��{�_頧lLc_:Ry��.n
�E�sS������O�U�>g-D�]�M!f��)=�y�a�+��������������o�I¤r�����W�T�b��1��O��_�������y�IU�~!΃�H�O����q0�w�02lڸ���BȻ������Tv����Tv�8[�GD����f������j���la��ō� [�M�p�!�J�,�bKp@�՘�~=6�뮨��.^r�#S2�]sU�`01*U��7���!sp~B�* f����UB����G����E{�;��8>��Ec|!�F�c��@j����؋z��'�-������[��p�§��p���>m}X�%�kcx��0�K�׶��aj�_x�n���w�Ǯl{*�����]T�k���!
"���Y����*�!���E)��>��QaJo�eA���\~,R�������K��>֧7�w��J���x��z�1߾�"�O�,~1��R-p���>�'�T�!�޼��	�J�w$ܢF��ᾞH���k�l_{�K�˘9�8�M�B�;.��4�Ky�{���e��[H%�>�ZH��e�B-��d�p�R�$�~�i�K���D�p����R�¹V��J�
g[٧P�U8�*�%\�3��h�2���ڔ�d�kKujÅL��'S���y�2 `�����Lm4�0��W1�����YOE%���9&��0�?V`�cbƲ:?�8��_��Q��Y߁�!
OC$��(<��k ��DD����3	xO�x*"�􄕀�w���(l�,l��
;��H�/Y�ʖ�{�%T�˫���_�q�F�<��+�ynʈo�g�_%�,�dK8�L����!��&/8&��o}P�eR���J�M�����|S���Dva{Ü'&�ֳE��0�[o���D����j<=�]�.�M7�zZ�'�	�a�__Ot��}���k�|�[�V����T �����Sb�˟��*<7�W��R�0��΢����|���ǒ򁮇Y�':��T�N�gG�˞k�0d�Z�������s������s���t����s:/M+��C�C��C��C�ܛ��P�U�oH}.
�+R�?�s���R�R�R��*���u��lx<)�aT1�L�ȵ�'�*�gvu�]��P������G5х�88TAę��6�Fv8v�>��G�/��J��Q�ART?��������qWj�2.=�F��k1lkcMX����\^b�8S�+��%�x��B���Mq��sc�ǝ7�|2σ����Ť*�\�� U����k�,\ݏ}GX9��q��)R��Pp�Yo�� 0��R�j�s|���3g������9�Է�m���̉C:G5��9�OU{+�=O�V5����g���=�,&4牷�ղ�<q4!ke�y�t�Y)k�s���RU�ylw}U��;�����V�ʖ���=����yO��f���'Ж�r�����Wd?�s��bh�sA��=[�*����=k�ªj�3��o2�ގ�7m='��k���7�[S��lM}�HD6��I����*cB��3�zO��s��S>���m�h�NT��c��@<���#���:l���ϔ�o񌂙z�Χ|��7]=��7�9��K9q�_R����@��G��T��x:q��ϹE��,�����?�����m      l   �  x��[[oT�~��+�q�43g�s�!A�P"Z!�:/��X�DA��l;�)%��i�*��D ���1������K��ڗ�/댏�$������[�������ܓ����停��ި7�o�'���//����ű��l(�`�/��Po���/	���Kc9�_2>-૿���~�:��o|���&�!���k��ޔ����H����]_�:����8�LI�����_u)��Q��}�ȩ<{l�.��o��y�������9X�>�c�w�.���G� ���EɪH��}�\�_����=��<�<(����YUl�^^1�3�s$����	|q�]3�5��*���n�7B�˟;�g,WV%�{s����(�����A�ΨS��<���L���rPr��GM��	8t��1�tWa����8��wp��z�����Z�hA���)RNh�4�/�: ������x�0���|�ҧ�u
�<��`�/�{��l&.NB�q�:E0�F0���7T��L4��Em���uL+��G#v3�4C�&o��p`J����d��0�M6۳�A/&!Xn�Wt�sq	2���Syk��*.��l���:(u���EQ�<��Q3�TN��e���S<��L[�ƞ*l����5��*wT�)����s�9҄ȼ �n�2-<q�W���!*و"��ͦl@x���@�HT@��T��*LmPgw���
;pfժ����=a�P�@*v.��_��:�הAl���Nr�q�h�SCE��q[���'؆��M�t2�;Wd����^(;��wh��1US��������D>c�o�!"�!gs,�����QM����c3Uu��V$��۞���v�}h��>����a_C�-��a���ԛI%.��m�[��dl���/ǫw�.��"7�vd&����!)/Jf�+i@p�:x,�ŶT��JǙ���*�h�'��0\9�DF�u+2B�j�|7r%qFڙ.b�L=�~h��8�a����!3�W)�iт-�Cb˲��m�烒)����|[9�q�'Я���ߩ�YSV�C��S�P�]xP'Hg��dd��!�����sy��!����!�+'���R�Ω=�X�k��������ɔ��o0?��m���3�A�MtC.�$6��pU=�����T�B2o���xP$V��Eƿ��7g�b'ա�-jH����^�%��ٹ;��S�1|��+��-��mx�!�{�:���и>�ƦE�T
FC
D���m��ck������?�L2>�:��B��J>�6��V�* �c)���-Rl�,s��)�� �1�Ҏ`�5`ru@���n�d����?����Vt�H ɧ$r?�����)��VW��p��IH#n��fn���g?i)s�Tyؐ��ֿc��i��І��&p�z��<�g�5S�u^:�Ȗ��o��4>��G�B�[fQi��I�.�*:�E�r`�b�u��f�@)�o9��L#��]Nj0S^qĔNu@�h�Cv�a���Fb��XL`�6&5�͡=��I��U7��4�#�P�B���~�gSn��.�R�	38�<c& ��B��L1b�¼JȞ0���r�#��Z�4	�;����@� 
'0�>�7�vw))�_��;�e��@K�/\�U��h�t'��D=��o��o��i,��+�Q�V&O�^�L0EN>V@�1����@�+��'6������yo�Y�3��o�1��_.>
jL�*�(�x�}����*"4m=�$M_��Xa��1d������
�Um<�;� c�S��!
G;ϨP��uM�dY���1�.Ӹ�8X	_��������]JgӨ�O�$�Ny~"*�RQ���o|.���}�簊őPu��`p�@S��(�,"�Χ�dX��Q�d�K ��D���l���Qd�LpJ�-��!�wqJB��f%cB���WK�F��`g�x[��Szx�~��,ĥW'.,�6g�jY��-���:�fr+6�6�g��?��G��$�y��.�D��UP����f����XW�����>,�\�������;{��"��0��Jv�;b�p�����D���sT��`�]�]<&�G��q J�Ø9�Ӕ�=��Pg�W��4/�,�R��]l��d��	�u��׺s��	�n�ۮJ���?��L�B&G��C�T��u�.4�����f�[X78�ff�Q �O��.�#�����s~�i��7�P��)�B/��8���؊N�0	���HO:ʵ?���{��Ԇj���q�t��lFN�;lU�ҿ�*����Z^�L�����r{����^��Z��dۚ��T5�-�4�<�M��f(����>@��ڲTp�u�5+j<q���vr��=0��6�"[`(��%�@�{bj._��B+B��%dQ|#dA:�gG{H|��Ee�j۲�\�M4e�n ����v��!Yhn��0^�{8  Z�Ѕ��6���b���|�0w)I��I���pic`n��0��u�Zؗ�u��]54-�t��t5�NȽI3ޙ����w��F���8��M���Oc%j+q�D�y�Sȇ@ǧ�$)	)�>n9�+�㲤Gܶ4��"4&�H�����!�����F�k���<�D�"�S���~���IT������̙͜j�k!
�L��´�N�Non9n	�O��Y�ܪw�,�l3:�h6�s_ 䴻�%�J\a��N��PpeF�*hc��<h-r[F�zh$��YFE�ٮ�mĽ�>�а<��Hd�,����+v!k��E�%�z"����X�]IP��	�>E�jx\}�&r��~�o���rG��t۸6W=���Cr���e�<o�]v[�q�r[A�{*^$�DO�+��~��?g�폶�ޚ!���1��L�d���u�\L��@|���.FԵ����`�Np�8�9�-�y-�J�F�$�C�x���SH�~�
�m�]-�ZH�U�TG�Uʌ.��X���)X�ckW<"���9`�_��wإ�0�Y�N�U�F�CV��CW���P8)r��7m{[�5�N�b#sF���]���.{8yY:o�aлF1�M�h�������������/��(ԡ7[INuQݶHOm&�N��X��F
Z�-#�Ћ��D���W�6�����KȤv���,!�H������/�#����Il2������r�e�X�X��n�x:�+������sP˲�}C&�h��˩����񺻜�/Ah��à)ȓ��z����e      n   �   x�Ւ�ME1D���r��K��B'�"�!!vԐ��E������2sƎ�e�����z�=��	�BU��@���slb��x�E�D�e�I1�̶���A&�(��2*�d9������{.m5��њ�vq��i�����S��u��f&�������o�p�|�����?=>���0��      q      x������ � �      p   v  x����N�P�׷�����v����������B[(�[��PV�rk\��`BTx��7B4�'��̙�9� @�55����Y8 ���Cy�$Cr�g
�I�|>=�!س�e�ZË�VeglH�2�B��"��f�d�R�3R��q}ZFL�̑����9iF ?�5����;��������ؠ�86ACp��4,�nf�J*ϦY�JF�KQa[�)a�&Q-9�k����Ph��dJV]\MTdJ�<YQ���)lPd	��$��rP>��@���G�E��G�Z�C�soP����L^���	c!!M��v�E�Y�5��U�ω�,+�8K��w�j�f������?�u��i��͞�/�>(RD/C�'���8     