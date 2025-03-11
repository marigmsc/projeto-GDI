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