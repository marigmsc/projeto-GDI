---------------------------------------------------------
-- 1) GROUP BY E HAVING
-- "CPF dos criadores que possuem mais de um álbum publicado."
---------------------------------------------------------
SELECT A.CPF AS CPF_CRIADOR,
       COUNT(*) AS TOTAL_ALBUNS
FROM ALBUM A
GROUP BY A.CPF
HAVING COUNT(*) > 1;


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


---------------------------------------------------------
-- 4) "CPF dos criadores que nunca publicaram nenhuma música."
---------------------------------------------------------
SELECT C.CPF
FROM CRIADOR C
WHERE NOT EXISTS (
    SELECT 1
    FROM FAZ F
    WHERE F.CPF = C.CPF
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
