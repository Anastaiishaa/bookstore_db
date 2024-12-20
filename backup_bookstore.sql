PGDMP  /    "                |         	   bookstore    16.2    16.2 ^    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    66301 	   bookstore    DATABASE     }   CREATE DATABASE bookstore WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE bookstore;
                postgres    false                        3079    66302    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            �           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2            �           1247    66340    myroles    TYPE     R   CREATE TYPE public.myroles AS ENUM (
    'client',
    'employee',
    'admin'
);
    DROP TYPE public.myroles;
       public          postgres    false                       1255    66347 	   logging()    FUNCTION     |  CREATE FUNCTION public.logging() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
IF (TG_OP = 'DELETE') THEN
INSERT INTO public.main_log (operation_type, operation_date, user_operator, changed_data)
VALUES ('D', now(), current_user, row_to_json(OLD));
ELSIF (TG_OP = 'UPDATE') THEN
INSERT INTO public.main_log (operation_type, operation_date, user_operator, changed_data) VALUES ('U', now(), current_user, row_to_json(NEW));
ELSIF (TG_OP = 'INSERT') THEN
INSERT INTO public.main_log (operation_type, operation_date, user_operator, changed_data) VALUES ('I', now(), current_user, row_to_json(NEW));
END IF;
RETURN NULL;    
END;
$$;
     DROP FUNCTION public.logging();
       public          postgres    false            �            1259    66348 	   feedbacks    TABLE     �   CREATE TABLE public.feedbacks (
    feedback_id integer NOT NULL,
    client_id integer NOT NULL,
    product_id integer NOT NULL,
    feedback_text text,
    rate integer
);
    DROP TABLE public.feedbacks;
       public         heap    postgres    false            �           0    0    TABLE feedbacks    ACL     <   GRANT SELECT ON TABLE public.feedbacks TO admin_group_role;
          public          postgres    false    216            �            1259    66353    products    TABLE     �   CREATE TABLE public.products (
    product_id integer NOT NULL,
    book_name character varying(250),
    author_name character varying(100),
    genre text,
    price double precision,
    points_count integer,
    books_count integer
);
    DROP TABLE public.products;
       public         heap    postgres    false            �           0    0    TABLE products    ACL     ;   GRANT SELECT ON TABLE public.products TO admin_group_role;
          public          postgres    false    217            �            1259    66358    analysis_customer_preferences    VIEW       CREATE VIEW public.analysis_customer_preferences AS
 SELECT feedbacks.feedback_id,
    products.book_name,
    products.author_name,
    feedbacks.feedback_text,
    feedbacks.rate
   FROM (public.feedbacks
     JOIN public.products ON ((feedbacks.product_id = products.product_id)));
 0   DROP VIEW public.analysis_customer_preferences;
       public          postgres    false    216    216    217    217    217    216    216            �           0    0 #   TABLE analysis_customer_preferences    ACL     �   GRANT SELECT ON TABLE public.analysis_customer_preferences TO employees_group_role;
GRANT SELECT ON TABLE public.analysis_customer_preferences TO admin_group_role;
          public          postgres    false    218            �            1259    66362    supply    TABLE     �   CREATE TABLE public.supply (
    supply_id integer NOT NULL,
    supply_date date,
    products_number integer,
    product_id integer NOT NULL,
    supplier_id integer NOT NULL
);
    DROP TABLE public.supply;
       public         heap    postgres    false            �           0    0    TABLE supply    ACL     9   GRANT SELECT ON TABLE public.supply TO admin_group_role;
          public          postgres    false    219            �            1259    66365    book_catalog    VIEW     /  CREATE VIEW public.book_catalog AS
 SELECT products.book_name,
    products.author_name,
    products.genre,
    products.price,
    products.books_count,
    supply.supply_date,
    products.points_count
   FROM (public.products
     JOIN public.supply ON ((products.product_id = supply.product_id)));
    DROP VIEW public.book_catalog;
       public          postgres    false    217    217    217    217    217    217    217    219    219            �           0    0    TABLE book_catalog    ACL        GRANT SELECT ON TABLE public.book_catalog TO client_group_role;
GRANT SELECT ON TABLE public.book_catalog TO admin_group_role;
          public          postgres    false    220            �            1259    66369    clients    TABLE     �   CREATE TABLE public.clients (
    client_id integer NOT NULL,
    client_name character varying(100),
    email text,
    points_number integer
);
    DROP TABLE public.clients;
       public         heap    postgres    false            �           0    0    TABLE clients    ACL     :   GRANT SELECT ON TABLE public.clients TO admin_group_role;
          public          postgres    false    221            �            1259    66374    content    TABLE     �   CREATE TABLE public.content (
    item_id integer NOT NULL,
    sale_id integer NOT NULL,
    product_id integer NOT NULL,
    products_count integer
);
    DROP TABLE public.content;
       public         heap    postgres    false            �           0    0    TABLE content    ACL     :   GRANT SELECT ON TABLE public.content TO admin_group_role;
          public          postgres    false    222            �            1259    66377 	   employees    TABLE     �   CREATE TABLE public.employees (
    employee_id integer NOT NULL,
    employee_full_name text,
    phone text,
    "position" text
);
    DROP TABLE public.employees;
       public         heap    postgres    false            �           0    0    TABLE employees    ACL     <   GRANT SELECT ON TABLE public.employees TO admin_group_role;
          public          postgres    false    223            �            1259    66382 	   suppliers    TABLE     }   CREATE TABLE public.suppliers (
    supplier_id integer NOT NULL,
    supplier_name text,
    phone character varying(20)
);
    DROP TABLE public.suppliers;
       public         heap    postgres    false            �           0    0    TABLE suppliers    ACL     <   GRANT SELECT ON TABLE public.suppliers TO admin_group_role;
          public          postgres    false    224            �            1259    66387 	   inventory    VIEW     �  CREATE VIEW public.inventory AS
 SELECT products.product_id,
    products.book_name,
    products.author_name,
    products.books_count,
    supply.supply_id,
    suppliers.supplier_id,
    suppliers.supplier_name,
    supply.supply_date
   FROM ((public.supply
     JOIN public.products ON ((products.product_id = supply.product_id)))
     JOIN public.suppliers ON ((supply.supplier_id = suppliers.supplier_id)));
    DROP VIEW public.inventory;
       public          postgres    false    219    219    217    217    217    217    219    219    224    224            �           0    0    TABLE inventory    ACL     |   GRANT SELECT ON TABLE public.inventory TO employees_group_role;
GRANT SELECT ON TABLE public.inventory TO admin_group_role;
          public          postgres    false    225            �            1259    66391    main_log    TABLE     �   CREATE TABLE public.main_log (
    log_item_id integer NOT NULL,
    operation_type text,
    operation_date text,
    user_operator text,
    changed_data text
);
    DROP TABLE public.main_log;
       public         heap    postgres    false            �           0    0    TABLE main_log    ACL     ;   GRANT SELECT ON TABLE public.main_log TO admin_group_role;
          public          postgres    false    226            �            1259    66396    main_log_log_item_id_seq    SEQUENCE     �   ALTER TABLE public.main_log ALTER COLUMN log_item_id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.main_log_log_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    226            �            1259    66397    sales    TABLE     �   CREATE TABLE public.sales (
    sale_id integer NOT NULL,
    employee_id integer NOT NULL,
    client_id integer NOT NULL,
    sale_date timestamp without time zone
);
    DROP TABLE public.sales;
       public         heap    postgres    false            �           0    0    TABLE sales    ACL     8   GRANT SELECT ON TABLE public.sales TO admin_group_role;
          public          postgres    false    228            �            1259    66400    purchase_history    VIEW     �  CREATE VIEW public.purchase_history AS
 SELECT sales.sale_id,
    products.book_name,
    products.author_name,
    content.products_count,
    sales.sale_date,
    products.price,
    feedbacks.rate
   FROM (((public.content
     JOIN public.products ON ((products.product_id = content.product_id)))
     JOIN public.sales ON ((content.sale_id = sales.sale_id)))
     JOIN public.feedbacks ON ((content.product_id = feedbacks.product_id)));
 #   DROP VIEW public.purchase_history;
       public          postgres    false    217    222    217    217    217    216    216    228    228    222    222            �           0    0    TABLE purchase_history    ACL     �   GRANT SELECT ON TABLE public.purchase_history TO client_group_role;
GRANT SELECT ON TABLE public.purchase_history TO admin_group_role;
          public          postgres    false    229            �            1259    66405    sales_report    VIEW     �  CREATE VIEW public.sales_report AS
 SELECT sales.sale_id,
    sales.sale_date,
    products.book_name,
    clients.client_name,
    employees.employee_full_name
   FROM ((((public.content
     JOIN public.sales ON ((content.sale_id = sales.sale_id)))
     JOIN public.products ON ((content.product_id = products.product_id)))
     JOIN public.employees ON ((sales.employee_id = employees.employee_id)))
     JOIN public.clients ON ((sales.client_id = clients.client_id)));
    DROP VIEW public.sales_report;
       public          postgres    false    223    228    228    228    228    223    222    222    221    221    217    217            �           0    0    TABLE sales_report    ACL     �   GRANT SELECT ON TABLE public.sales_report TO employees_group_role;
GRANT SELECT ON TABLE public.sales_report TO admin_group_role;
          public          postgres    false    230            �            1259    66410    secret_data    TABLE     i   CREATE TABLE public.secret_data (
    "ID" integer NOT NULL,
    username text,
    secret_token text
);
    DROP TABLE public.secret_data;
       public         heap    postgres    false            �           0    0    TABLE secret_data    ACL     >   GRANT SELECT ON TABLE public.secret_data TO admin_group_role;
          public          postgres    false    231            �            1259    66415    secret_data_ID_seq    SEQUENCE     �   ALTER TABLE public.secret_data ALTER COLUMN "ID" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."secret_data_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    231            �            1259    66416    users    TABLE     �   CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(250) NOT NULL,
    password character varying(250) NOT NULL,
    role public.myroles
);
    DROP TABLE public.users;
       public         heap    postgres    false    896            �            1259    66421    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    233            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    234            �           2604    66422    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    234    233                      0    66369    clients 
   TABLE DATA           O   COPY public.clients (client_id, client_name, email, points_number) FROM stdin;
    public          postgres    false    221   �p       �          0    66374    content 
   TABLE DATA           O   COPY public.content (item_id, sale_id, product_id, products_count) FROM stdin;
    public          postgres    false    222   �q       �          0    66377 	   employees 
   TABLE DATA           W   COPY public.employees (employee_id, employee_full_name, phone, "position") FROM stdin;
    public          postgres    false    223   +r       |          0    66348 	   feedbacks 
   TABLE DATA           \   COPY public.feedbacks (feedback_id, client_id, product_id, feedback_text, rate) FROM stdin;
    public          postgres    false    216   �s       �          0    66391    main_log 
   TABLE DATA           l   COPY public.main_log (log_item_id, operation_type, operation_date, user_operator, changed_data) FROM stdin;
    public          postgres    false    226   :u       }          0    66353    products 
   TABLE DATA           o   COPY public.products (product_id, book_name, author_name, genre, price, points_count, books_count) FROM stdin;
    public          postgres    false    217   �v       �          0    66397    sales 
   TABLE DATA           K   COPY public.sales (sale_id, employee_id, client_id, sale_date) FROM stdin;
    public          postgres    false    228   7x       �          0    66410    secret_data 
   TABLE DATA           C   COPY public.secret_data ("ID", username, secret_token) FROM stdin;
    public          postgres    false    231   �x       �          0    66382 	   suppliers 
   TABLE DATA           F   COPY public.suppliers (supplier_id, supplier_name, phone) FROM stdin;
    public          postgres    false    224   Cz       ~          0    66362    supply 
   TABLE DATA           b   COPY public.supply (supply_id, supply_date, products_number, product_id, supplier_id) FROM stdin;
    public          postgres    false    219   �z       �          0    66416    users 
   TABLE DATA           =   COPY public.users (id, username, password, role) FROM stdin;
    public          postgres    false    233   d{       �           0    0    main_log_log_item_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.main_log_log_item_id_seq', 117, true);
          public          postgres    false    227            �           0    0    secret_data_ID_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."secret_data_ID_seq"', 2, true);
          public          postgres    false    232            �           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 9, true);
          public          postgres    false    234            �           2606    66424    clients clients_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (client_id);
 >   ALTER TABLE ONLY public.clients DROP CONSTRAINT clients_pkey;
       public            postgres    false    221            �           2606    66426    content content_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.content
    ADD CONSTRAINT content_pkey PRIMARY KEY (item_id);
 >   ALTER TABLE ONLY public.content DROP CONSTRAINT content_pkey;
       public            postgres    false    222            �           2606    66428    employees employees_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);
 B   ALTER TABLE ONLY public.employees DROP CONSTRAINT employees_pkey;
       public            postgres    false    223            �           2606    66430    feedbacks feedbacks_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (feedback_id);
 B   ALTER TABLE ONLY public.feedbacks DROP CONSTRAINT feedbacks_pkey;
       public            postgres    false    216            �           2606    66432    main_log main_log_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.main_log
    ADD CONSTRAINT main_log_pkey PRIMARY KEY (log_item_id);
 @   ALTER TABLE ONLY public.main_log DROP CONSTRAINT main_log_pkey;
       public            postgres    false    226            �           2606    66434    products products_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);
 @   ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
       public            postgres    false    217            �           2606    66436    sales sales_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (sale_id);
 :   ALTER TABLE ONLY public.sales DROP CONSTRAINT sales_pkey;
       public            postgres    false    228            �           2606    66438    secret_data secret_data_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.secret_data
    ADD CONSTRAINT secret_data_pkey PRIMARY KEY ("ID");
 F   ALTER TABLE ONLY public.secret_data DROP CONSTRAINT secret_data_pkey;
       public            postgres    false    231            �           2606    66440    suppliers suppliers_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (supplier_id);
 B   ALTER TABLE ONLY public.suppliers DROP CONSTRAINT suppliers_pkey;
       public            postgres    false    224            �           2606    66442    supply supply_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.supply
    ADD CONSTRAINT supply_pkey PRIMARY KEY (supply_id);
 <   ALTER TABLE ONLY public.supply DROP CONSTRAINT supply_pkey;
       public            postgres    false    219            �           2606    66444    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    233            �           2606    66446    users users_username_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key;
       public            postgres    false    233            �           1259    66447    fki_content_product    INDEX     M   CREATE INDEX fki_content_product ON public.content USING btree (product_id);
 '   DROP INDEX public.fki_content_product;
       public            postgres    false    222            �           1259    66448    fki_content_sale    INDEX     G   CREATE INDEX fki_content_sale ON public.content USING btree (sale_id);
 $   DROP INDEX public.fki_content_sale;
       public            postgres    false    222            �           1259    66449    fki_feedback_product    INDEX     O   CREATE INDEX fki_feedback_product ON public.feedbacks USING btree (client_id);
 (   DROP INDEX public.fki_feedback_product;
       public            postgres    false    216            �           1259    66450    fki_k    INDEX     A   CREATE INDEX fki_k ON public.feedbacks USING btree (product_id);
    DROP INDEX public.fki_k;
       public            postgres    false    216            �           1259    66451    fki_sales_client    INDEX     G   CREATE INDEX fki_sales_client ON public.sales USING btree (client_id);
 $   DROP INDEX public.fki_sales_client;
       public            postgres    false    228            �           1259    66452    fki_sales_employee    INDEX     K   CREATE INDEX fki_sales_employee ON public.sales USING btree (employee_id);
 &   DROP INDEX public.fki_sales_employee;
       public            postgres    false    228            �           1259    66453    fki_supply_product    INDEX     K   CREATE INDEX fki_supply_product ON public.supply USING btree (product_id);
 &   DROP INDEX public.fki_supply_product;
       public            postgres    false    219            �           1259    66454    fki_supply_supplier    INDEX     M   CREATE INDEX fki_supply_supplier ON public.supply USING btree (supplier_id);
 '   DROP INDEX public.fki_supply_supplier;
       public            postgres    false    219            �           2620    66455    clients logging_clients    TRIGGER     �   CREATE TRIGGER logging_clients AFTER INSERT OR DELETE OR UPDATE ON public.clients FOR EACH ROW EXECUTE FUNCTION public.logging();
 0   DROP TRIGGER logging_clients ON public.clients;
       public          postgres    false    271    221            �           2620    66456    content logging_content    TRIGGER     �   CREATE TRIGGER logging_content AFTER INSERT OR DELETE OR UPDATE ON public.content FOR EACH ROW EXECUTE FUNCTION public.logging();
 0   DROP TRIGGER logging_content ON public.content;
       public          postgres    false    222    271            �           2620    66457    employees logging_employees    TRIGGER     �   CREATE TRIGGER logging_employees AFTER INSERT OR DELETE OR UPDATE ON public.employees FOR EACH ROW EXECUTE FUNCTION public.logging();
 4   DROP TRIGGER logging_employees ON public.employees;
       public          postgres    false    271    223            �           2620    66458    feedbacks logging_feedbacks    TRIGGER     �   CREATE TRIGGER logging_feedbacks AFTER INSERT OR DELETE OR UPDATE ON public.feedbacks FOR EACH ROW EXECUTE FUNCTION public.logging();
 4   DROP TRIGGER logging_feedbacks ON public.feedbacks;
       public          postgres    false    271    216            �           2620    66459    products logging_product    TRIGGER     �   CREATE TRIGGER logging_product AFTER INSERT OR DELETE OR UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.logging();
 1   DROP TRIGGER logging_product ON public.products;
       public          postgres    false    271    217            �           2620    66460    sales logging_sales    TRIGGER     ~   CREATE TRIGGER logging_sales AFTER INSERT OR DELETE OR UPDATE ON public.sales FOR EACH ROW EXECUTE FUNCTION public.logging();
 ,   DROP TRIGGER logging_sales ON public.sales;
       public          postgres    false    228    271            �           2620    66461    suppliers logging_suppliers    TRIGGER     �   CREATE TRIGGER logging_suppliers AFTER INSERT OR DELETE OR UPDATE ON public.suppliers FOR EACH ROW EXECUTE FUNCTION public.logging();
 4   DROP TRIGGER logging_suppliers ON public.suppliers;
       public          postgres    false    271    224            �           2620    66462    supply logging_supply    TRIGGER     �   CREATE TRIGGER logging_supply AFTER INSERT OR DELETE OR UPDATE ON public.supply FOR EACH ROW EXECUTE FUNCTION public.logging();
 .   DROP TRIGGER logging_supply ON public.supply;
       public          postgres    false    271    219            �           2606    66463    content fk_content_product    FK CONSTRAINT     �   ALTER TABLE ONLY public.content
    ADD CONSTRAINT fk_content_product FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 D   ALTER TABLE ONLY public.content DROP CONSTRAINT fk_content_product;
       public          postgres    false    222    217    4797            �           2606    66468    content fk_content_sale    FK CONSTRAINT     �   ALTER TABLE ONLY public.content
    ADD CONSTRAINT fk_content_sale FOREIGN KEY (sale_id) REFERENCES public.sales(sale_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 A   ALTER TABLE ONLY public.content DROP CONSTRAINT fk_content_sale;
       public          postgres    false    4817    228    222            �           2606    66473    feedbacks fk_feedback_client    FK CONSTRAINT     �   ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT fk_feedback_client FOREIGN KEY (client_id) REFERENCES public.clients(client_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 F   ALTER TABLE ONLY public.feedbacks DROP CONSTRAINT fk_feedback_client;
       public          postgres    false    221    4803    216            �           2606    66478    feedbacks fk_feedback_product    FK CONSTRAINT     �   ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT fk_feedback_product FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 G   ALTER TABLE ONLY public.feedbacks DROP CONSTRAINT fk_feedback_product;
       public          postgres    false    4797    216    217            �           2606    66483    sales fk_sales_client    FK CONSTRAINT     �   ALTER TABLE ONLY public.sales
    ADD CONSTRAINT fk_sales_client FOREIGN KEY (client_id) REFERENCES public.clients(client_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 ?   ALTER TABLE ONLY public.sales DROP CONSTRAINT fk_sales_client;
       public          postgres    false    221    4803    228            �           2606    66488    sales fk_sales_employee    FK CONSTRAINT     �   ALTER TABLE ONLY public.sales
    ADD CONSTRAINT fk_sales_employee FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 A   ALTER TABLE ONLY public.sales DROP CONSTRAINT fk_sales_employee;
       public          postgres    false    228    4809    223            �           2606    66493    supply fk_supply_product    FK CONSTRAINT     �   ALTER TABLE ONLY public.supply
    ADD CONSTRAINT fk_supply_product FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 B   ALTER TABLE ONLY public.supply DROP CONSTRAINT fk_supply_product;
       public          postgres    false    219    217    4797            �           2606    66498    supply fk_supply_supplier    FK CONSTRAINT     �   ALTER TABLE ONLY public.supply
    ADD CONSTRAINT fk_supply_supplier FOREIGN KEY (supplier_id) REFERENCES public.suppliers(supplier_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 C   ALTER TABLE ONLY public.supply DROP CONSTRAINT fk_supply_supplier;
       public          postgres    false    4811    224    219               �   x�M��j�0@�{?�XWR�n��.ʣAId�8	�V�]Z�:�LK���?\�Qe�!��C#���[n��XWu�g��yp~�M� �A*�v�6>'��v��Ȏ��z�Q	�G����%S�s��vW��0I��M<�S|z�#�WNg��T
��w���M�c|J�xtA��q5`�r$�ej������֕Jݜ���$�߸��!�J�tv��Mo��>C��'k      �   K   x����0��f�^l$�t�9�>u�BugK`MM��"!hs��݆��0i*l����F٩�������Yv�@x�      �   u  x�}RIN�0]ǧȒn��Lw�0m�(j�T��Xm��&1W����"G��{��V�ʌީ�c�R�oC.�%�8����Ӝڡz��2Za;`��s����rYG}V_4J�
��1Z(kUF/��p�y%�!l�`��O�D���-49����H�F��Ru�� >>��!�0����i�͆����}���@�F��8ef �2��Z6Zja�5}�X`hG{���>���Dq&X��@�����4��6=�LS_r`�6���H.�
�B�����r$��X[�Z�%��dn�����(��h�gO�Фx���	c�����uY�R�(N�{ ������p�dr��cyc�l0����+Ө�Jqu)��MBzB      |   z  x�uR�R�@<o�b�S���?F)�@�ki����/���=|<mҳ��ݳ���˼�a�g�<K��Lq@%K�?�Q�-"��[)�⽚�5Z��0��ʵ,��Z��	�7�K���<䣋��j�OD޾BE��<�Ms���-*�7$�[X#���jGFm������37�ah���"���$nQgSbz.�n'=�%�	i_?�s�:�UFE'_jsG�E_)�f��?3J���nj�(�L��Q:J$C�C_5ƣ�㤥U}DN9���k{�9`#��2�,���}��u3�82� ���n��C�X-K!K�/;������1��>���53���k�i.����.�{�Dt¬;�����1{��@.I�|��r      �   h  x�]Q�J�P]'_�J1��$7k7�u'���6��<"�.\I��Kn�ڵ�����Im1p�93sΙK��b�;��3��Q�qb�L��>�LKd�� �nP��A��{� yT0�]l�)�z�?��~n��z�Jd"��G2�#/j�>�755VO�$�u\B�0��mSUB˲*ջZ�;5�W%i����r�2��חE�#��6vҝ�L;k�v,*0�e+'����a(v��"���k���z��W�~A�B}�oC݃�W�؂��%�Cô{ 9�R��h$��V ��h�s����a�e	��̏�����]n�~���J���|C�Cp�S,�j��~n������      }   u  x�e�IN�@E��S����)��q´ ̬ !�7�DN��+����M�e�kx�뷖U�i*x��0Œ�]8��a��,��<���kx3�h�=cC�N�beh��TӸ�$S�#-��t��������p:�~Z�1��%�S��0c��$��'�6��͘�R�R�H+?)�\|5ɬl�5��rx&�(\�2��b+3x���X=u�O��'~\xj�B�к?ps42Xp�}Zt7\��<6$/�Ѣ0G���47�UpGP�����x�6�7�ݰ�Y�÷鸧7[����2�ŗ�O)���5��A���Z�H��፹n���ߋ��	I��"��'�'B���.�)Ȯ��Q�ck�k��I�&1W�JI��8��_��R�      �   v   x�U���0��v�.�)���t����+�?�Aq�
�B�6�fh�)�f��fDa'����8�p(�j��?�5��ǣ��HOC,@P7�^?������N�����5���Z)I)O      �   v  x�e�9�0c�ø@,w���>����U	�5�___������:�f���Nb��.d�<t_yUB�K�	7�QS��"*?rh���Gx@kZ"�����?iN�輤��S����r�Sud���7�Z�<�ez�Jd�n�]/�9!����{��4�pc�S5zf��[[o�{�
x>�t��u����lzg�4>�'�wu`-ͻ>�W؊ |�$�}�1�4�!lk�y�ܹ��ꭲ�ي$v���]�Q��,�%�4��Ƞ�y$�����H�6�յ���P��4�u{[z1e�!�~zn8�zB>W��>���%�v���2R?߰F�+�nw���V,��3���2ك\jC*�=�~�~>��q��(      �   �   x�-�;
AD����to��l�5L7320v�L�4PsAA��jn�(fEQ���G�H�S�-�����{�˲,j~���z��pƣ�xa �ٲ֗�mY�M�<Fw��w3rM��.c5�ɷY����m"찭���ZJ�'#f� :B�      ~   m   x�E��1E�5�����%��1�H���@*jK�DH딫��Z�8�;	���m;-z�� J6����W�k=NsO	�y��]���zM��ns�������_?!�      �   x   x�U�K
1D�Շ��w��iHH'�L���L/�M-T����ўҖ<����K��#r��Xx�>� '��rc#WA��������	\�Dcf8�3�Ļ�]�n���նs=���7o     