.mode columns
.headers on
.nullvalue NULL

/* lista dos jogadores estrangeiros por equipa com maior número de golos+assistencias
   (a última coluna indica se este jogador e tambem o melhor tendo em conta os jogadores brasileiros da equipa) */

SELECT EQUIPA, NOME_JOGADOR, NACIONALIDADE_JOGADOR, MAX(TMP) GOLOS_MAIS_ASSISTENCIAS, (CASE WHEN MAX(TMP) = (SELECT MAX(G_A)
																											FROM (SELECT COUNT(*) G_A
																											FROM GOLO JOIN JOGADOR JOIN CLUBE
																											ON (GOLO.idMarcador = JOGADOR.idJogador OR GOLO.idAssistente = JOGADOR.idJogador) AND JOGADOR.idClube = CLUBE.idClube 
																											GROUP BY idJogador)
																											) THEN 'SIM' ELSE 'NAO' END) AS MELHOR_DA_EQUIPA
FROM (
		SELECT CLUBE.nome EQUIPA, JOGADOR.nome NOME_JOGADOR, nacionalidade NACIONALIDADE_JOGADOR, COUNT(*) TMP
		FROM GOLO JOIN JOGADOR JOIN CLUBE
		ON (GOLO.idMarcador = JOGADOR.idJogador OR GOLO.idAssistente = JOGADOR.idJogador) AND JOGADOR.idClube = CLUBE.idClube
		WHERE nacionalidade <> 'Brasil'
		GROUP BY idJogador
		)
GROUP BY 1
ORDER BY 4 DESC, 2
