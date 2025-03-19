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
)

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

---------------------------------------------------------
-- 9) "Projetar o CPF de quem segue (seguidor) e de quem é seguido (seguido)."
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

----------- PLSQL -----------------

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

-- Trigger

CREATE OR REPLACE TRIGGER atualiza_faixas_album
AFTER INSERT ON MUSICA
FOR EACH ROW
BEGIN
    -- Atualiza o total de faixas no álbum relacionado
    UPDATE ALBUM
    SET total_faixas = total_faixas + 1
    WHERE id_album = :NEW.id_album;
END;

-- Teste
INSERT INTO MUSICA (id_musica, id_album, titulo, duracao, capa)
VALUES (12, 1, 'Nova Faixa', 210, 'nova_faixa_album.jpg');
