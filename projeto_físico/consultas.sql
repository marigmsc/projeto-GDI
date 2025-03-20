---------------------------------------------------------
-- 1) GROUP BY E HAVING
-- "CPF dos criadores que possuem mais de um álbum publicado."
---------------------------------------------------------
SELECT A.CPF AS CPF_CRIADOR,
       COUNT(*) AS TOTAL_ALBUNS
FROM ALBUM A
GROUP BY A.CPF
HAVING COUNT(*) > 1;

--"Nome do Criador que possui o maior número de eventos publicados."
SELECT U.NOME, COUNT(*) AS total_eventos
FROM EVENTO E INNER JOIN USUARIO U ON E.CPF=U.CPF
GROUP BY U.NOME
HAVING total_eventos = (
    SELECT MAX(COUNT(*)) 
    FROM EVENTO
    GROUP BY CPF
);

-- "Projetar os ids dos albuns que possuem mais de 2 musicas"
SELECT m.ID_ALBUM
FROM MUSICA m
GROUP BY m.ID_ALBUM
HAVING count(*) > 2;

-- "Projetar os CPFs dos usuários que possuem pelo menos 2 seguidores"
SELECT s.SEGUIDO AS CPF
FROM SEGUE s
GROUP BY s.SEGUIDO
HAVING count(*) >= 2;

-- "Projetar os generos de playlists que tem mais músicas que a média de musicas por genero"
SELECT p.GENERO
FROM PLAYLIST p
GROUP BY p.GENERO 
HAVING count(*) > 
(
SELECT avg(qtd)
FROM (SELECT count(*) AS qtd
	FROM PLAYLIST p2
	GROUP BY p2.GENERO
	)
);

---------------------------------------------------------
-- 2) INNER JOIN
-- "Exibir os usuários que não tiveram desconto na assinatura"
---------------------------------------------------------
SELECT u.nome
FROM assina a
INNER JOIN usuario u on u.CPF = a.CPF
WHERE a.ID_DESCONTO IS NULL; 

-- Usuários premiums com o valor e o tipo da assinatura que possuem
SELECT u.nome AS Nome_Usuario, 
       a.tipo AS Tipo_Assinatura, 
       a.valor AS Valor_Assinatura
FROM usuario u
INNER JOIN premium p ON u.CPF = p.CPF
INNER JOIN assina asn ON p.CPF = asn.CPF
INNER JOIN assinatura a ON asn.id_assinatura = a.id_assinatura;

--"Projetar os títulos das músicas e o CPF de seu criador"
SELECT m.TITULO, c.CPF
FROM MUSICA m
INNER JOIN FAZ f
ON m.ID_MUSICA = f.ID_MUSICA
INNER JOIN CRIADOR c
ON f.CPF = c.CPF;

-- "Projetar os títulos das músicas e o título do álbum a qual ela pertence"
SELECT m.TITULO, a.TITULO
FROM MUSICA m 
INNER JOIN ALBUM a
ON m.ID_ALBUM = a.ID_ALBUM;

-- Projetar o nome da playlist e as músicas que ela possui
SELECT p.TITULO AS titulo_playlist, m.TITULO AS titulo_musica
FROM PLAYLIST p
INNER JOIN CRIA c
ON p.ID_PLAYLIST = c.ID_PLAYLIST
INNER JOIN MUSICA m
ON m.ID_MUSICA = c.ID_MUSICA;

---------------------------------------------------------
-- 3) OUTER JOIN
-- "Mostrar o nome de todos os criadores e o título do álbum (se existir).
---------------------------------------------------------
SELECT U.CPF        AS NOME_CRIADOR,
       AL.TITULO     AS TITULO_ALBUM
FROM CRIADOR C
     LEFT OUTER JOIN ALBUM AL ON C.CPF = AL.CPF
ORDER BY U.NOME;

-- "Listar o nome de todos os usuários e por quem eles são seguidos (se houver seguidores)."
SELECT U1.nome AS seguido,
       U2.nome AS seguidor
FROM USUARIO U1
    LEFT OUTER JOIN SEGUE S ON U1.CPF = S.seguido
    LEFT OUTER JOIN USUARIO U2 ON S.seguidor = U2.CPF;

--"Projetar o títitulo das playlists sem músicas associadas usando LEFT OUTER JOIN" 
SELECT p.titulo AS playlist
FROM PLAYLIST p
LEFT OUTER JOIN CRIA c ON p.id_playlist = c.id_playlist
WHERE c.id_playlist IS NULL;

--"Nome dos criadores que não possuem músicas publicadas"
SELECT U.nome
FROM CRIADOR C
     LEFT OUTER JOIN FAZ F ON C.CPF = F.CPF
     INNER JOIN USUARIO u ON c.CPF = u.CPF
WHERE f.id_musica IS NULL;

--Listar a quantidade de eventos por CPF dos criadores(até aqueles que não possuem eventos)
SELECT c.CPF, COUNT(e.NUMEVENTO) AS total_eventos
FROM CRIADOR c
LEFT OUTER JOIN EVENTO e ON c.CPF = e.CPF
GROUP BY c.CPF
ORDER BY total_eventos DESC;

---------------------------------------------------------
-- 4) SEMI-JOIN (EXISTS)
-- "CPF dos criadores que já publicaram ao menos uma música."
---------------------------------------------------------
SELECT C.CPF
FROM CRIADOR C
WHERE EXISTS (
    SELECT 1
    FROM FAZ F
    WHERE F.CPF = C.CPF
);

-- "Nome dos usuários que são criadores"
SELECT U.nome
FROM USUARIO U
WHERE EXISTS (
    SELECT *
    FROM CRIADOR C
    WHERE C.CPF = U.CPF
);

-- Usuários que seguem pelo menos um usuário
SELECT u.cpf
from usuario u
where exists (
    select 1
    from SEGUE s
    where u.cpf = s.SEGUIDOR
);

-- Usuários que assinaram um plano com desconto
SELECT U.CPF
FROM USUARIO U
WHERE EXISTS (
    SELECT 1
    FROM ASSINA A
    WHERE A.CPF = U.CPF
      AND A.id_desconto IS NOT NULL
);

-- Usuários que participaram de pelo menos um evento
SELECT C.CPF
FROM CRIADOR C
WHERE EXISTS (
    SELECT 1
    FROM EVENTO E
    WHERE E.CPF = C.CPF
);

---------------------------------------------------------
-- 5) ANTI-JOIN(NOT EXISTS/NOT IN) 
-- "CPF dos criadores que nunca publicaram nenhuma música."
---------------------------------------------------------
SELECT C.CPF
FROM CRIADOR C
WHERE NOT EXISTS (
    SELECT 1
    FROM FAZ F
    WHERE F.CPF = C.CPF
);

-- "Nome dos usuários que não possuem plano Premium."
SELECT U.nome
FROM USUARIO U
WHERE NOT EXISTS (
    SELECT *
    FROM PREMIUM P
    WHERE P.CPF = U.CPF
);

-- "Projetar o CPF e o e-mail dos usuários que NINGUÉM segue."
SELECT U.CPF,
       U.EMAIL
FROM USUARIO U
WHERE U.CPF NOT IN (
    SELECT SEGUIDO
    FROM SEGUE
);

---------------------------------------------------------
-- 6) SUBCONSULTA ESCALAR
-- "Usuários que pagam o plano mais caro de assinatura."
---------------------------------------------------------
SELECT U.NOME,
       A.TIPO,
       A.VALOR
FROM USUARIO U
INNER JOIN PREMIUM PR ON U.CPF = PR.CPF
INNER JOIN ASSINA ASI ON ASI.CPF = PR.CPF
INNER JOIN ASSINATURA A ON A.ID_ASSINATURA = ASI.ID_ASSINATURA
WHERE A.VALOR = (
    SELECT MAX(VALOR)
    FROM ASSINATURA
);
-- "Projetar o título e a diferença entre a duração da música e a média de duração de todas as músicas."
SELECT M.titulo, 
       M.duracao - (SELECT AVG(duracao) FROM MUSICA) AS diferenca
FROM MUSICA M
WHERE M.duracao > (SELECT AVG(duracao) FROM MUSICA);

-- "Número total de músicas em cada álbum"
SELECT id_album, titulo, 
       (SELECT COUNT(*) FROM MUSICA WHERE MUSICA.id_album = ALBUM.id_album) AS total_musicas
FROM ALBUM;

-- "Número total de playlists de cada gênero"
SELECT genero,
       (SELECT COUNT(*) 
        FROM PLAYLIST p 
        WHERE p.genero = pl.genero) AS total_playlists
FROM PLAYLIST pl
GROUP BY genero;

-- "Valor da assinatura de cada usuário premium"
SELECT U.CPF, U.nome, 
       (SELECT valor FROM ASSINATURA A WHERE A.id_assinatura = S.id_assinatura) AS valor_assinatura
FROM USUARIO U
JOIN ASSINA S ON U.CPF = S.CPF;


---------------------------------------------------------
-- 7) SUBCONSULTA DE LINHA
-- "Projetar os títulos das playlists que tem o mesmo gênero e quantidade de músicas que a playlist de id 9
--------------------------------------------------------- 
SELECT P.TITULO
FROM PLAYLIST P
WHERE (P.GENERO, P.TOTAL_FAIXAS) = (
	SELECT GENERO, TOTAL_FAIXAS
	FROM PLAYLIST
	WHERE ID_PLAYLIST = 9
);

-- "Projetar os usuários premium que possuem o mesmo tipo de assinatura que o usuário com CPF = '222.333.444-55'."
SELECT P.CPF, 
       U.NOME,
       A.ID_ASSINATURA
FROM PREMIUM P
INNER JOIN USUARIO U ON P.CPF = U.CPF
INNER JOIN ASSINA A ON P.CPF = A.CPF
WHERE (A.ID_ASSINATURA, A.ID_DESCONTO)= (
    SELECT A.id_assinatura,A.ID_DESCONTO
    FROM ASSINA A
    WHERE A.CPF = '222.333.444-55'
);

---------------------------------------------------------
-- 8) SUBCONSULTA DE TABELA
-- "Mostrar as músicas (título e id_album) onde o álbum seja do gênero 'Rock'."
---------------------------------------------------------
SELECT M.TITULO AS MUSICA,
       M.ID_ALBUM
FROM MUSICA M
WHERE M.ID_ALBUM IN (
    SELECT AL.ID_ALBUM
    FROM ALBUM AL
    WHERE AL.GENERO = 'Rock'
);

-- "Nome dos usuários que possuem álbuns de mais de um gênero."
SELECT U.nome
FROM USUARIO U
WHERE U.CPF IN (
    SELECT A.CPF 
    FROM ALBUM A
    GROUP BY A.CPF
    HAVING COUNT(DISTINCT A.genero) > 1
);

-- Àlbuns com mais de 10 músicas
SELECT id_album, titulo
FROM ALBUM
WHERE total_faixas > (
    SELECT MIN(total_faixas)
    FROM ALBUM
    WHERE total_faixas > 10
);


-- Usuários com músicas com duração acima da média
SELECT C.CPF
FROM CRIADOR C
WHERE C.CPF IN (
    SELECT F.CPF
    FROM FAZ F
    JOIN MUSICA M ON F.id_musica = M.id_musica
    WHERE M.duracao > (
        SELECT AVG(duracao)
        FROM MUSICA
    )
);

-- Músicas do àlbum mais longo
SELECT titulo
FROM MUSICA
WHERE id_album = (
    SELECT id_album
    FROM ALBUM
    WHERE total_faixas = (SELECT MAX(total_faixas) FROM ALBUM)
);



---------------------------------------------------------
-- 9) Operações de conjunto
-- "Projetar o CPF de quem segue (seguidor) e de quem é seguido (seguido)."
---------------------------------------------------------
SELECT seguidor AS CPF
FROM SEGUE

UNION

SELECT seguido AS CPF
FROM SEGUE;

-- Seguidores mutuais
SELECT seguidor AS CPF
FROM SEGUE

INTERSECT

SELECT seguido AS CPF
FROM SEGUE;

-- Criadores que também são premium
SELECT CPF FROM CRIADOR
INTERSECT
SELECT CPF FROM PREMIUM;

-- CPFs que são criadores ou usuários premium.
SELECT CPF
FROM CRIADOR

UNION

SELECT CPF
FROM PREMIUM;

-- Criadores que não são premium
SELECT CPF FROM CRIADOR
EXCEPT
SELECT CPF FROM PREMIUM;

----------- PLSQL -----------------
--------PROCEDIMENTOS--------------

-- Procedimento : Criar Usuário Criador
CREATE OR REPLACE PROCEDURE InserirUsuarioCriador(
    p_cpf IN USUARIO.CPF%TYPE,
    p_nome IN USUARIO.nome%TYPE,
    p_email IN USUARIO.email%TYPE,
    p_tel1 IN USUARIO.telefone1%TYPE,
    p_tel2 IN USUARIO.telefone2%TYPE,
    p_agencia IN CONTA_BANCARIA.agencia%TYPE,
    p_conta IN CONTA_BANCARIA.conta%TYPE
)
IS
BEGIN
    INSERT INTO USUARIO (CPF, nome, email, telefone1, telefone2)
    VALUES (p_cpf, p_nome, p_email, p_tel1, p_tel2);

    INSERT INTO CONTA_BANCARIA (agencia, conta, CPF)
    VALUES (p_agencia, p_conta, p_cpf);

    INSERT INTO CRIADOR (CPF, agencia, conta)
    VALUES (p_cpf, p_agencia, p_conta);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END InserirUsuarioCriador;

-- Executa com parâmetros
BEGIN
    InserirUsuarioCriador(
        '123.456.789-00', 
        'Novo Usuário', 
        'novo@email.com', 
        '(11)9999-9999', 
        NULL, 
        '9999', 
        '99999999'
    );
END;
-- Procedimento: Printar a quantidade de álbuns de um criador

CREATE OR REPLACE PROCEDURE ContarAlbunsPorCriador(cpf_criador IN VARCHAR2)
IS
    total_albuns NUMBER;
BEGIN
    -- Conta quantos álbuns o criador tem na tabela ALBUM
    SELECT COUNT(*)
    INTO total_albuns
    FROM ALBUM
    WHERE CPF = cpf_criador;

    -- Exibe o total de álbuns no console
    DBMS_OUTPUT.PUT_LINE('Total de Álbuns: ' || total_albuns);
END;

-- Executa o procedimento para um criador específico
EXEC ContarAlbunsPorCriador('111.222.333-44');

-- Procedimento: Listar todos os usuários com seu tipo (Premium, Criador ou Grátis)
CREATE OR REPLACE PROCEDURE ListarUsuarios (cpf_usuario IN USUARIO.CPF%TYPE)
IS
    v_cpf USUARIO.CPF%TYPE;
    v_nome USUARIO.NOME%TYPE;
    v_email USUARIO.EMAIL%TYPE;
    v_telefone1 USUARIO.TELEFONE1%TYPE;
    v_telefone2 USUARIO.TELEFONE2%TYPE;

    v_isPremium NUMBER := 0; -- 0 = Falso, 1 = Verdadeiro
    v_isCriador NUMBER := 0;

BEGIN
    SELECT CPF, nome, email, telefone1, telefone2 
    INTO v_cpf, v_nome, v_email, v_telefone1, v_telefone2
    FROM USUARIO
    WHERE CPF = cpf_usuario;

    -- Verifica se o usuário é Premium
    SELECT COUNT(*) INTO v_isPremium FROM PREMIUM WHERE CPF = cpf_usuario;

    -- Verifica se o usuário é Criador
    SELECT COUNT(*) INTO v_isCriador FROM CRIADOR WHERE CPF = cpf_usuario;

    DBMS_OUTPUT.PUT_LINE('CPF: ' || v_cpf);
    DBMS_OUTPUT.PUT_LINE('Nome: ' || v_nome);
    DBMS_OUTPUT.PUT_LINE('E-mail: ' || v_email);
    DBMS_OUTPUT.PUT_LINE('Telefone 1: ' || v_telefone1);
    
    IF v_telefone2 IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Telefone 2: ' || v_telefone2);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Telefone 2: Não cadastrado.');
    END IF;

    IF v_isPremium > 0 AND v_isCriador > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Tipo de Usuário: Premium e Criador');
    ELSIF v_isPremium > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Tipo de Usuário: Premium');
    ELSIF v_isCriador > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Tipo de Usuário: Criador');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Tipo de Usuário: Grátis');
    END IF;

    DBMS_OUTPUT.PUT_LINE('---------------------------');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Usuário não encontrado com CPF: ' || cpf_usuario);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao listar usuário: ' || SQLERRM);
END ListarUsuarios;


--------FUNÇÕES/GATILHOS--------------
-- Função: Retorna o valor ao ser pago a partir do CPF do Usuário Premium.

CREATE OR REPLACE FUNCTION CalcularTotalPago(p_cpf PREMIUM.CPF%TYPE)
RETURN NUMBER IS
    v_total NUMBER := 0;
BEGIN
    SELECT SUM(A.VALOR - (NVL(D.PERCENTUAL, 0) / 100) * A.VALOR)
    INTO v_total
    FROM ASSINA ass
    INNER JOIN ASSINATURA a ON ass.id_assinatura = a.id_assinatura
    LEFT JOIN DESCONTO D ON D.ID_DESCONTO = ass.ID_DESCONTO
    INNER JOIN PREMIUM P ON P.CPF = ass.CPF
    WHERE ass.CPF = p_cpf;

    RETURN NVL(v_total, 0);
END CalcularTotalPago;

--Executa a função:
SELECT CalcularTotalPago('111.222.333-44') FROM DUAL;


-- Gatilho

CREATE OR REPLACE TRIGGER atualiza_faixas_album
AFTER INSERT ON MUSICA
FOR EACH ROW
BEGIN
    -- Atualiza o total de faixas no álbum relacionado
    UPDATE ALBUM
    SET total_faixas = total_faixas + 1
    WHERE id_album = :NEW.id_album;
END;

-- Executa
INSERT INTO MUSICA (id_musica, id_album, titulo, duracao, capa)
VALUES (12, 1, 'Nova Faixa', 210, 'nova_faixa_album.jpg');
