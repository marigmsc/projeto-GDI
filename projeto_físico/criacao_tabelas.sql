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
    agencia VARCHAR(5) UNIQUE NOT NULL, 
    conta VARCHAR(8) UNIQUE NOT NULL,
    CONSTRAINT criador_fk FOREIGN KEY (CPF) REFERENCES USUARIO(CPF), 
    CONSTRAINT agencia_fk FOREIGN KEY (agencia, conta) REFERENCES CONTA_BANCARIA(agencia, conta)
);

CREATE TABLE PREMIUM (
    CPF VARCHAR(20) PRIMARY KEY, 
    data_cobranca DATE, 
    CONSTRAINT premium_fk FOREIGN KEY (CPF) REFERENCES USUARIO(CPF)
);

CREATE TABLE MUSICA (
    id_musica NUMBER PRIMARY KEY, 
    id_album NUMBER, 
    titulo VARCHAR(45), 
    duracao NUMBER, 
    capa VARCHAR(45)
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

CREATE TABLE PLAYLIST(
    id_playlist NUMBER PRIMARY KEY,
    titulo VARCHAR(45),
    capa VARCHAR(45),
    genero VARCHAR(45),
    total_faixas NUMBER
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
    CPF VARCHAR(20) NOT NULL,
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

CREATE TABLE DESCONTO(
    id_desconto NUMBER PRIMARY KEY,
    percentual  NUMBER(5,2)
);

CREATE TABLE ASSINATURA(
    id_assinatura NUMBER PRIMARY KEY,
    tipo VARCHAR(45),
    valor NUMBER
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

CREATE TABLE EVENTO (
    CPF VARCHAR(20), 
    numEvento NUMBER, 
    data DATE, 
    end_CEP VARCHAR(9), 
    end_numero NUMBER,
    PRIMARY KEY (CPF, numEvento),
    CONSTRAINT CPF_artista_evento_fk FOREIGN KEY (CPF) REFERENCES CRIADOR(CPF)
);

--- Povoamento ---

-----------------------------------------------------------
-- TABELA: USUARIO
-----------------------------------------------------------
INSERT INTO USUARIO (CPF, nome, email, telefone1, telefone2)
VALUES
('111.222.333-44', 'Mariana Diniz',    'mari23@gmail.com',            '(11) 9834-5210', '(11) 9934-6871'),
('222.333.444-55', 'João Tavares',     'jo_66_tavares@outlook.com',   '(21) 9456-7980', '(21) 9067-4412'),
('333.444.555-66', 'Ana Montenegro',   'anng34@gmail.com',            '(31) 9120-3344',  NULL),
('444.555.666-77', 'Pedro Antunes',    'pedro_ant223@hotmail.com',    '(41) 9891-2243', '(41) 9732-6781'),
('555.666.777-88', 'Rafaela Moura',    'rafam_1@gmail.com',           '(48) 9342-8776', '(48) 9123-6722'),
('666.777.888-99', 'Lucas Pereira',    'luccasppp@hotmail.com',       '(61) 9665-4432', '(61) 9001-5589'),
('777.888.999-00', 'Beatriz Caruso',   'car_bia3@gmail.com',          '(71) 9802-1459', '(71) 9300-3298'),
('888.999.000-11', 'Carlos Alberto',   'calberto@gmail.com',          '(85) 9055-3314', '(85) 9521-6670'),
('055.200.300-45', 'Maria Silva',      'masilva@outlook.com',         '(86) 9940-3411',  NULL);

-----------------------------------------------------------
-- TABELA: CONTA_BANCARIA
-----------------------------------------------------------
INSERT INTO CONTA_BANCARIA (agencia, conta, CPF)
VALUES
('0132','45367109','111.222.333-44'),
('0789','98754621','222.333.444-55'),
('0210','34567890','333.444.555-66'),
('1790','45678901','444.555.666-77'),
('4432','56789012','555.666.777-88'),
('1234','67890123','666.777.888-99'),
('9090','78901234','777.888.999-00'),
('8765','89012345','888.999.000-11');

-----------------------------------------------------------
-- TABELA: CRIADOR
-----------------------------------------------------------
INSERT INTO CRIADOR (CPF, agencia, conta)
VALUES
('111.222.333-44', '0132', '45367109'),
('222.333.444-55', '0789', '98754621'),
('333.444.555-66', '0210', '34567890'),
('444.555.666-77', '1790', '45678901'),
('555.666.777-88', '4432', '56789012'),
('666.777.888-99', '1234', '67890123'),
('777.888.999-00', '9090', '78901234'),
('888.999.000-11', '8765', '89012345');

-----------------------------------------------------------
-- TABELA: PREMIUM
-----------------------------------------------------------
INSERT INTO PREMIUM (CPF, data_cobranca)
VALUES
('111.222.333-44', TO_DATE('15/01/2023','DD/MM/YYYY')),
('222.333.444-55', TO_DATE('22/02/2023','DD/MM/YYYY')),
('333.444.555-66', TO_DATE('05/03/2023','DD/MM/YYYY')),
('444.555.666-77', TO_DATE('10/03/2023','DD/MM/YYYY')),
('555.666.777-88', TO_DATE('27/04/2023','DD/MM/YYYY')),
('666.777.888-99', TO_DATE('03/05/2023','DD/MM/YYYY')),
('777.888.999-00', TO_DATE('11/05/2023','DD/MM/YYYY')),
('888.999.000-11', TO_DATE('29/05/2023','DD/MM/YYYY'));

-----------------------------------------------------------
-- TABELA: EVENTO
-----------------------------------------------------------
INSERT INTO EVENTO (CPF, numEvento, data, end_CEP,end_numero)
VALUES
('111.222.333-44', 1, TO_DATE('02/05/2023','DD/MM/YYYY'), '01001-000', 123),
('111.222.333-44', 2, TO_DATE('04/01/2024','DD/MM/YYYY'), '04538-132', 456),
('111.222.333-44', 3, TO_DATE('13/05/2024','DD/MM/YYYY'), '50010-902', 321),
('222.333.444-55', 4, TO_DATE('12/08/2023','DD/MM/YYYY'), '03047-010', 234),
('222.333.444-55', 5, TO_DATE('30/05/2024','DD/MM/YYYY'), '52041-040', 654),
('333.444.555-66', 6, TO_DATE('25/12/2024','DD/MM/YYYY'), '51200-020', 345),
('444.555.666-77', 7, TO_DATE('04/04/2025','DD/MM/YYYY'), '20010-000', 101),
('555.666.777-88', 8, TO_DATE('21/07/2025','DD/MM/YYYY'), '22041-001', 200),
('666.777.888-99', 9, TO_DATE('06/11/2025','DD/MM/YYYY'), '23052-090', 300),
('777.888.999-00', 10, TO_DATE('07/07/2024','DD/MM/YYYY'), '64000-200', 111),
('888.999.000-11', 11, TO_DATE('28/08/2025','DD/MM/YYYY'), '64019-245', 222);
-----------------------------------------------------------
-- TABELA: ALBUM
-----------------------------------------------------------
INSERT INTO ALBUM (id_album, CPF, titulo, capa, genero, total_faixas)
VALUES
(1,  '111.222.333-44', 'Acústico MTV',         'capa_anna_julia.jpg',       'Pop Rock',       18),
(2,  '222.333.444-55', 'Ideologia',            'capa_ideologia.jpg',        'Rock',           10),
(3,  '333.444.555-66', 'Dois na Bossa',        'capa_a_banda.jpg',          'MPB',            12),
(4,  '444.555.666-77', 'Mutantes e Seus Cometas no País dos Baurets','capa_mutantes.jpg','Rock Psicodélico',9),
(5,  '555.666.777-88', 'Caymmi Visita Tom',    'capa_sabia.jpg',            'MPB',            10),
(6,  '666.777.888-99', 'Cartola 1974',         'capa_trem_das_onze.jpg',    'Samba',          12),
(7,  '777.888.999-00', 'Elis & Tom',           'capa_aguas_de_marco.jpg',   'MPB',            14),
(8,  '888.999.000-11', 'Getz/Gilberto',        'capa_garota_de_ipanema.jpg','Bossa Nova',     10),
(9,  '111.222.333-44', 'Segundo Acústico MTV', 'capa_segundo.jpg',          'Rock',            8),
(10, '444.555.666-77', 'Mutantes Ao Vivo',     'capa_mutantes_ao_vivo.jpg','Rock Psicodélico',7);

-----------------------------------------------------------
-- TABELA: MUSICA
-----------------------------------------------------------
INSERT INTO MUSICA (id_musica, id_album, titulo, duracao, capa)
VALUES
(1,  1, 'Anna Júlia',         182, 'capa_anna_julia.jpg'),
(2,  2, 'Ideologia',          205, 'capa_ideologia.jpg'),
(3,  3, 'A Banda',            197, 'capa_a_banda.jpg'),
(4,  4, 'Balada do Louco',    243, 'capa_balada_do_louco.jpg'),
(5,  5, 'Sabiá',              189, 'capa_sabia.jpg'),
(6,  6, 'Trem das Onze',      221, 'capa_trem_das_onze.jpg'),
(7,  7, 'Águas De Março',     234, 'capa_aguas_de_marco.jpg'),
(8,  8, 'Garota de Ipanema',  251, 'capa_garota_de_ipanema.jpg'),
(9,  9, 'Nova Faixa 1',       200, 'nova_faixa1.jpg'),
(10, 9, 'Nova Faixa 2',       210, 'nova_faixa2.jpg'),
(11,10,'Ando Meio Desligado 2',220,'ando_meio_desligado2.jpg');

-----------------------------------------------------------
-- TABELA: PLAYLIST
-----------------------------------------------------------
INSERT INTO PLAYLIST (id_playlist, titulo, capa, genero, total_faixas)
VALUES
(1, 'Pop Atualizado',             'pop_list.jpg',        'Pop',        2),
(2, 'Vibes do Hip Hop',           'hiphop_list.jpg',     'Hip Hop',    4),
(3, 'MPB para Relaxar',           'mpb_list.jpg',        'MPB',        6),
(4, 'Rock Clássico e Novo',       'rock_list.jpg',       'Rock',       1),
(5, 'Sertanejo Universitário',    'sertanejo_list.jpg',  'Sertanejo',  2),
(6, 'Eletrônica Pulsante',        'eletronica_list.jpg', 'Eletrônica', 6),
(7, 'Canções Românticas',         'romanticas_list.jpg', 'Romântico',  3),
(8, 'Pagode em Casa',             'pagode_list.jpg',     'Pagode',     4);

-----------------------------------------------------------
-- TABELA: ASSINATURA
-----------------------------------------------------------
INSERT INTO ASSINATURA (id_assinatura, tipo, valor)
VALUES
(1, 'Mensal',            9.90),
(2, 'Trimestral',       28.50),
(3, 'Semestral',        48.00),
(4, 'Anual',            90.00),
(5, 'Estudante Mensal', 7.50),
(6, 'Estudante Trim.',  22.90),
(7, 'Estudante Sem.',   40.00),
(8, 'Estudante Anual',  70.00);

-----------------------------------------------------------
-- TABELA: DESCONTO
-----------------------------------------------------------
INSERT INTO DESCONTO (id_desconto, percentual)
VALUES
(1, 5.00),
(2, 10.00),
(3, 15.50),
(4, 20.00),
(5, 25.00),
(6, 30.00),
(7, 35.00),
(8, 40.00);

-----------------------------------------------------------
-- TABELA: FAZ
-----------------------------------------------------------
INSERT INTO FAZ (id_musica, CPF, data_publicada)
VALUES
(1,  '111.222.333-44', TO_DATE('02/01/2023','DD/MM/YYYY')),
(2,  '222.333.444-55', TO_DATE('10/01/2023','DD/MM/YYYY')),
(3,  '333.444.555-66', TO_DATE('18/01/2023','DD/MM/YYYY')),
(4,  '444.555.666-77', TO_DATE('25/01/2023','DD/MM/YYYY')),
(5,  '555.666.777-88', TO_DATE('05/02/2023','DD/MM/YYYY')),
(6,  '666.777.888-99', TO_DATE('15/02/2023','DD/MM/YYYY')),
(7,  '777.888.999-00', TO_DATE('22/02/2023','DD/MM/YYYY')),
(8,  '888.999.000-11', TO_DATE('02/03/2023','DD/MM/YYYY')),
(9,  '111.222.333-44', TO_DATE('05/04/2023','DD/MM/YYYY')),
(10, '111.222.333-44', TO_DATE('06/04/2023','DD/MM/YYYY')),
(11, '444.555.666-77', TO_DATE('07/04/2023','DD/MM/YYYY'));

-----------------------------------------------------------
-- TABELA: CRIA
-----------------------------------------------------------
INSERT INTO CRIA (id_musica, id_playlist, CPF)
VALUES
(1, 1, '111.222.333-44'),
(2, 2, '222.333.444-55'),
(3, 3, '333.444.555-66'),
(4, 4, '444.555.666-77'),
(5, 5, '555.666.777-88'),
(6, 6, '666.777.888-99'),
(7, 7, '777.888.999-00'),
(8, 8, '888.999.000-11');

-----------------------------------------------------------
-- TABELA: SEGUE
-----------------------------------------------------------
INSERT INTO SEGUE (seguido, seguidor)
VALUES
('111.222.333-44', '333.444.555-66'),
('222.333.444-55', '111.222.333-44'),
('333.444.555-66', '555.666.777-88'),
('444.555.666-77', '666.777.888-99'),
('555.666.777-88', '777.888.999-00'),
('666.777.888-99', '444.555.666-77'),
('777.888.999-00', '888.999.000-11'),
('888.999.000-11', '222.333.444-55'),
('111.222.333-44', '777.888.999-00');

-----------------------------------------------------------
-- TABELA: ASSINA
-----------------------------------------------------------
INSERT INTO ASSINA (CPF, id_assinatura, id_desconto)
VALUES
('111.222.333-44', 1, 1),
('222.333.444-55', 2, 2),
('333.444.555-66', 3, 3),
('444.555.666-77', 4, 4),
('555.666.777-88', 5, 5),
('666.777.888-99', 6, 6),
('777.888.999-00', 7, 7),
('888.999.000-11', 8, 8);



