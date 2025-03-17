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
---------------------------------------------------------
-- 2) OUTER JOIN
-- "Mostrar o nome de todos os criadores e o título do álbum (se existir).
---------------------------------------------------------
SELECT U.NOME        AS NOME_CRIADOR,
       AL.TITULO     AS TITULO_ALBUM
FROM CRIADOR C
     LEFT OUTER JOIN ALBUM AL ON C.CPF = AL.CPF
     INNER JOIN USUARIO U     ON C.CPF = U.CPF
ORDER BY U.NOME;

-- "Listar o nome de todos os usuários e por quem eles são seguidos (se houver seguidores)."
SELECT U1.nome AS seguido,
       U2.nome AS seguidor
FROM USUARIO U1
    LEFT OUTER JOIN SEGUE S ON U1.CPF = S.seguido
    LEFT OUTER JOIN USUARIO U2 ON S.seguidor = U2.CPF;

---------------------------------------------------------
-- 3) SEMI-JOIN (EXISTS)
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
-- 4) ANTI-JOIN(NOT EXISTS) 
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

---------------------------------------------------------
-- 5) SUBCONSULTA ESCALAR
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
-- 6) SUBCONSULTA DE LINHA
-- "Projetar o CPF e o nome dos criadores que têm a mesma (agência, conta)
--  do criador com CPF '111.222.333-44'."
---------------------------------------------------------
SELECT CR.CPF,
       U.NOME
FROM CRIADOR CR
INNER JOIN USUARIO U ON CR.CPF = U.CPF
WHERE (CR.AGENCIA, CR.CONTA) = (
    SELECT AGENCIA, CONTA
    FROM CRIADOR
    WHERE CPF = '111.222.333-44'
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
-- 7) SUBCONSULTA DE TABELA
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
-- 8) "Projetar o CPF de quem segue (seguidor) e de quem é seguido (seguido)."
---------------------------------------------------------
SELECT seguidor AS CPF
FROM SEGUE

UNION

SELECT seguido AS CPF
FROM SEGUE;


---------------------------------------------------------
-- 9) "Contar quantos usuários utilizam e-mail do Gmail (LIKE '%@gmail.com')."
---------------------------------------------------------
SELECT COUNT(*) AS TOTAL_GMAIL_USERS
FROM USUARIO
WHERE email LIKE '%@gmail.com';


---------------------------------------------------------
-- 10) "Projetar o CPF e o e-mail dos usuários que NINGUÉM segue."
---------------------------------------------------------
SELECT U.CPF,
       U.EMAIL
FROM USUARIO U
WHERE U.CPF NOT IN (
    SELECT SEGUIDO
    FROM SEGUE
);


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

