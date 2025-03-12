CREATE TABLE USUARIO(
    CPF VARCHAR(20) PRIMARY KEY, 
    nome VARCHAR(45),
    email VARCHAR(45), 
    telefone1 VARCHAR(14), 
    telefone2 VARCHAR(14)
);

CREATE TABLE CONTA_BANCARIA (
    agencia VARCHAR(5), 
    conta VARCHAR(8), 
    CPF VARCHAR(20),
    PRIMARY KEY (agencia, conta)
);

CREATE TABLE CRIADOR (
    CPF VARCHAR(20) PRIMARY KEY, 
    agencia VARCHAR(5) NOT NULL, 
    conta VARCHAR(8) NOT NULL,
    CONSTRAINT criador_fk FOREIGN KEY (CPF) REFERENCES USUARIO(CPF), 
    CONSTRAINT agencia_fk FOREIGN KEY (agencia, conta) REFERENCES CONTA_BANCARIA(agencia, conta)
);

CREATE TABLE PREMIUM (
    CPF VARCHAR(20) PRIMARY KEY, 
    data_cobranca DATE, 
    CONSTRAINT premium_fk FOREIGN KEY (CPF) REFERENCES USUARIO(CPF)
);

CREATE TABLE EVENTO (
    CPF VARCHAR(20), 
    numEvento NUMBER, 
    data DATE, 
    CEP VARCHAR(9), 
    numero NUMBER,
    PRIMARY KEY (CPF, numEvento),
    CONSTRAINT CPF_artista_evento_fk FOREIGN KEY (CPF) REFERENCES CRIADOR(CPF)
);

CREATE TABLE ALBUM (
    id_album NUMBER PRIMARY KEY, 
    CPF VARCHAR(20) NOT NULL, 
    titulo VARCHAR(45), 
    capa VARCHAR(45), 
    genero VARCHAR(45), 
    total_faixas NUMBER, 
    CONSTRAINT CPF_criador_album_fk FOREIGN KEY (CPF) REFERENCES CRIADOR(CPF)
);

CREATE TABLE MUSICA (
    id_musica NUMBER PRIMARY KEY, 
    id_album NUMBER NOT NULL, 
    titulo VARCHAR(45), 
    duracao NUMBER, 
    capa VARCHAR(45)
);

CREATE TABLE PLAYLIST(
    id_playlist NUMBER PRIMARY KEY,
    titulo VARCHAR(45),
    capa VARCHAR(45),
    genero VARCHAR(45),
    total_faixas NUMBER
);

CREATE TABLE ASSINATURA(
    id_assinatura NUMBER PRIMARY KEY,
    tipo VARCHAR(45),
    valor NUMBER
);

CREATE TABLE DESCONTO(
    id_desconto NUMBER PRIMARY KEY
);

CREATE TABLE FAZ(
    id_musica NUMBER, 
    CPF VARCHAR(20), 
    data_publicada DATE,
    PRIMARY KEY (id_musica, CPF, data_publicada),
    CONSTRAINT id_musica_faz_fk FOREIGN KEY (id_musica) REFERENCES MUSICA(id_musica),
    CONSTRAINT CPF_criador_faz_fk FOREIGN KEY (CPF) REFERENCES CRIADOR(CPF)
);

CREATE TABLE CRIA(
    id_musica NUMBER, 
    id_playlist NUMBER, 
    CPF VARCHAR(20),
    PRIMARY KEY (id_musica, id_playlist),
    CONSTRAINT id_musica_cria_fk FOREIGN KEY (id_musica) REFERENCES MUSICA(id_musica),
    CONSTRAINT id_playlist_fk FOREIGN KEY (id_playlist) REFERENCES PLAYLIST(id_playlist)
);

CREATE TABLE SEGUE(
    seguido VARCHAR(20), 
    seguidor VARCHAR(20),
    PRIMARY KEY (seguido, seguidor),
    CONSTRAINT seguido_fk FOREIGN KEY (seguido) REFERENCES USUARIO(CPF),
    CONSTRAINT seguidor_fk FOREIGN KEY (seguidor) REFERENCES USUARIO(CPF)
);

CREATE TABLE ASSINA(
    CPF VARCHAR(20), 
    id_assinatura NUMBER, 
    id_desconto NUMBER,
    PRIMARY KEY (CPF, id_assinatura),
    CONSTRAINT CPF_usuario_assina_fk FOREIGN KEY (CPF) REFERENCES PREMIUM(CPF),
    CONSTRAINT id_assinatura_fk FOREIGN KEY (id_assinatura) REFERENCES ASSINATURA(id_assinatura),
    CONSTRAINT id_desconto_fk FOREIGN KEY (id_desconto) REFERENCES DESCONTO(id_desconto)
);


--- Povoamento ---

---------------------------------------------------
-- 1) USUARIO
---------------------------------------------------
INSERT INTO USUARIO (CPF, nome, email, telefone1, telefone2) VALUES
('111.222.333-44', 'Mariana Diniz',  'mari23@gmail.com',   '(11) 9834-5210', '(11) 9934-6871'),
('222.333.444-55', 'João Tavares',   'jo_66_tavares@outlook.com',   '(21) 9456-7980', '(21) 9067-4412'),
('333.444.555-66', 'Ana Montenegro','anng34@gmail.com', '(31) 9120-3344', '(31) 9755-0182'),
('444.555.666-77', 'Pedro Antunes',  'pedro_ant223@hotmail.com',   '(41) 9891-2243', '(41) 9732-6781'),
('555.666.777-88', 'Rafaela Moura',  'rafam_1@gmail.com', '(48) 9342-8776', '(48) 9123-6722'),
('666.777.888-99', 'Lucas Pereira',  'luccasppp@hotmail.com',   '(61) 9665-4432', '(61) 9001-5589'),
('777.888.999-00', 'Beatriz Caruso', 'car_bia3@gmail.com',  '(71) 9802-1459', '(71) 9300-3298'),
('888.999.000-11', 'Carlos Alberto', 'calberto@gmail.com', '(85) 9055-3314', '(85) 9521-6670');

---------------------------------------------------
-- 2) CONTA_BANCARIA
---------------------------------------------------
INSERT INTO CONTA_BANCARIA (agencia, conta, CPF) VALUES
('0132','45367109','111.222.333-44'),
('0789','98754621','222.333.444-55'),
('0210','34567890','333.444.555-66'),
('1790','45678901','444.555.666-77'),
('4432','56789012','555.666.777-88'),
('1234','67890123','666.777.888-99'),
('9090','78901234','777.888.999-00'),
('8765','89012345','888.999.000-11');

---------------------------------------------------
-- 3) CRIADOR
---------------------------------------------------
INSERT INTO CRIADOR (CPF, agencia, conta) VALUES
('111.222.333-44', '0132', '45367109'),
('222.333.444-55', '0789', '98754621'),
('333.444.555-66', '0210', '34567890'),
('444.555.666-77', '1790', '45678901'),
('555.666.777-88', '4432', '56789012'),
('666.777.888-99', '1234', '67890123'),
('777.888.999-00', '9090', '78901234'),
('888.999.000-11', '8765', '89012345');

---------------------------------------------------
-- 4) PREMIUM
---------------------------------------------------
INSERT INTO PREMIUM (CPF, data_cobranca) VALUES
('111.222.333-44', TO_DATE('15/01/2023','DD/MM/YYYY')),
('222.333.444-55', TO_DATE('22/02/2023','DD/MM/YYYY')),
('333.444.555-66', TO_DATE('05/03/2023','DD/MM/YYYY')),
('444.555.666-77', TO_DATE('10/03/2023','DD/MM/YYYY')),
('555.666.777-88', TO_DATE('27/04/2023','DD/MM/YYYY')),
('666.777.888-99', TO_DATE('03/05/2023','DD/MM/YYYY')),
('777.888.999-00', TO_DATE('11/05/2023','DD/MM/YYYY')),
('888.999.000-11', TO_DATE('29/05/2023','DD/MM/YYYY'));

---------------------------------------------------
-- 5) EVENTO (NOVO)
---------------------------------------------------
INSERT INTO EVENTO (cod, nome, sigla, ano) VALUES
(1, 'Festival Universitário de Música',        'FUM', 2023),
(2, 'Semana Brasileira de Engenharia',         'SBE', 2024),
(3, 'Hackathon Nacional de Inovação',          'HNI', 2023),
(4, 'Congresso Internacional de Tecnologia',   'CIT', 2025),
(5, 'Encontro de Inteligência Artificial',     'EIA', 2023),
(6, 'Simpósio de Startups e Empreendedorismo', 'SSE', 2024),
(7, 'Feira de Ciências e Inovação',            'FCI', 2025),
(8, 'Workshop Avançado de Desenvolvimento',    'WAD', 2024);

---------------------------------------------------
-- 6) ALBUM
---------------------------------------------------
INSERT INTO ALBUM (id_album, CPF, titulo, capa, genero, total_faixas) VALUES
(1, '111.222.333-44', 'Acústico MTV',        'capa_anna_julia.jpg',    'Pop Rock',   18), 
(2, '222.333.444-55', 'Ideologia',           'capa_ideologia.jpg',     'Rock',       10),
(3, '333.444.555-66', 'Dois na Bossa',       'capa_a_banda.jpg',       'MPB',        12),
(4, '444.555.666-77', 'Mutantes e Seus Cometas no País dos Baurets', 'capa_mutantes.jpg', 'Rock Psicodélico', 9),
(5, '555.666.777-88', 'Caymmi Visita Tom',   'capa_sabia.jpg',         'MPB',        10),
(6, '666.777.888-99', 'Cartola 1974',        'capa_trem_das_onze.jpg', 'Samba',      12),
(7, '777.888.999-00', 'Elis & Tom',          'capa_aguas_de_marco.jpg','MPB',        14),
(8, '888.999.000-11', 'Getz/Gilberto',       'capa_garota_de_ipanema.jpg', 'Bossa Nova', 10);


---------------------------------------------------
-- 7) MUSICA
---------------------------------------------------
INSERT INTO MUSICA (id_musica, id_album, titulo, duracao, capa) VALUES
(1, 1, 'Anna Júlia',      182, 'capa_anna_julia.jpg'),
(2, 2, 'Ideologia',       205, 'capa_ideologia.jpg'),
(3, 3, 'A Banda',         197, 'capa_a_banda.jpg'),
(4, 4, 'Balada do Louco', 243, 'capa_balada_do_louco.jpg'),
(5, 5, 'Sabiá',           189, 'capa_sabia.jpg'),
(6, 6, 'Trem das Onze',   221, 'capa_trem_das_onze.jpg'),
(7, 7, 'Águas De Março',  234, 'capa_aguas_de_marco.jpg'),
(8, 8, 'Garota de Ipanema', 251, 'capa_garota_de_ipanema.jpg');

---------------------------------------------------
-- 8) PLAYLIST
---------------------------------------------------
INSERT INTO PLAYLIST (id_playlist, titulo, capa, genero, total_faixas) VALUES
(1, 'Pop Atualizado',             'pop_list.jpg',        'Pop',        2),
(2, 'Vibes do Hip Hop',           'hiphop_list.jpg',     'Hip Hop',    4),
(3, 'MPB para Relaxar',           'mpb_list.jpg',        'MPB',        6),
(4, 'Rock Clássico e Novo',       'rock_list.jpg',       'Rock',       1),
(5, 'Sertanejo Universitário',    'sertanejo_list.jpg',  'Sertanejo',  2),
(6, 'Eletrônica Explosiva',       'eletronica_list.jpg', 'Eletrônica', 6),
(7, 'Canções Românticas',         'romanticas_list.jpg', 'Romântico',  3),
(8, 'Pagode em Casa',             'pagode_list.jpg',     'Pagode',     4);

---------------------------------------------------
-- 9) ASSINATURA
---------------------------------------------------
INSERT INTO ASSINATURA (id_assinatura, tipo, valor) VALUES
(1, 'Mensal',            9.90),
(2, 'Trimestral',       28.50),
(3, 'Semestral',        48.00),
(4, 'Anual',            90.00),
(5, 'Estudante Mensal', 7.50),
(6, 'Estudante Trim.',  22.90),
(7, 'Estudante Sem.',   40.00),
(8, 'Estudante Anual',  70.00);

---------------------------------------------------
-- 10) DESCONTO
---------------------------------------------------
INSERT INTO DESCONTO (id_desconto) VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8);

---------------------------------------------------
-- 11) FAZ
-- id_musica → MUSICA
-- CPF       → CRIADOR
---------------------------------------------------
INSERT INTO FAZ (id_musica, CPF, data_publicada) VALUES
(1, '111.222.333-44', TO_DATE('02/01/2023','DD/MM/YYYY')),
(2, '222.333.444-55', TO_DATE('10/01/2023','DD/MM/YYYY')),
(3, '333.444.555-66', TO_DATE('18/01/2023','DD/MM/YYYY')),
(4, '444.555.666-77', TO_DATE('25/01/2023','DD/MM/YYYY')),
(5, '555.666.777-88', TO_DATE('05/02/2023','DD/MM/YYYY')),
(6, '666.777.888-99', TO_DATE('15/02/2023','DD/MM/YYYY')),
(7, '777.888.999-00', TO_DATE('22/02/2023','DD/MM/YYYY')),
(8, '888.999.000-11', TO_DATE('02/03/2023','DD/MM/YYYY'));

---------------------------------------------------
-- 12) CRIA
---------------------------------------------------
INSERT INTO CRIA (id_musica, id_playlist, CPF) VALUES
(1, 1, '111.222.333-44'),
(2, 2, '222.333.444-55'),
(3, 3, '333.444.555-66'),
(4, 4, '444.555.666-77'),
(5, 5, '555.666.777-88'),
(6, 6, '666.777.888-99'),
(7, 7, '777.888.999-00'),
(8, 8, '888.999.000-11');

---------------------------------------------------
-- 13) SEGUE
---------------------------------------------------
INSERT INTO SEGUE (seguido, seguidor) VALUES
('111.222.333-44', '333.444.555-66'),
('222.333.444-55', '111.222.333-44'),
('333.444.555-66', '555.666.777-88'),
('444.555.666-77', '666.777.888-99'),
('555.666.777-88', '777.888.999-00'),
('666.777.888-99', '444.555.666-77'),
('777.888.999-00', '888.999.000-11'),
('888.999.000-11', '222.333.444-55');

---------------------------------------------------
-- 14) ASSINA
---------------------------------------------------
INSERT INTO ASSINA (CPF, id_assinatura, id_desconto) VALUES
('111.222.333-44', 1, 1),
('222.333.444-55', 2, 2),
('333.444.555-66', 3, 3),
('444.555.666-77', 4, 4),
('555.666.777-88', 5, 5),
('666.777.888-99', 6, 6),
('777.888.999-00', 7, 7),
('888.999.000-11', 8, 8);


