.mode columns
.headers on
.nullvalue NULL

/* resultados de todos os jogos do campeonato ordenados cronologicamente */

SELECT DATA, HORA, VISITADA, GOLOS_VISITADA, GOLOS_VISITANTE, VISITANTE
FROM ( 
        SELECT t1.idJogo, t1.dataJogo DATA, t1.horaJogo HORA, t1.nome VISITADA, (CASE WHEN t2.TMP IS NULL THEN 0 ELSE t2.TMP END) GOLOS_VISITADA
        FROM (
                SELECT *
                FROM JOGO JOIN CLUBE
                ON JOGO.idEquipaVisitada = CLUBE.idClube
                ) as t1
                LEFT JOIN 
            (
                SELECT *, COUNT(*) TMP
                FROM JOGO JOIN GOLO JOIN JOGADOR JOIN CLUBE
                ON JOGO.idJogo = GOLO.idJogo AND GOLO.idMarcador = JOGADOR.idJogador AND JOGADOR.idClube = CLUBE.idClube
                WHERE idEquipaVisitada = JOGADOR.idClube
                GROUP BY CLUBE.idClube, GOLO.idJogo
                ) as t2
        using(idJogo)
        ) 
JOIN
     (
        SELECT t1.idJogo, t1.nome VISITANTE, (CASE WHEN t2.TMP IS NULL THEN 0 ELSE t2.TMP END) GOLOS_VISITANTE
        FROM (
                SELECT *
                FROM JOGO JOIN CLUBE
                ON JOGO.idEquipaVisitante = CLUBE.idClube
                ) as t1
                LEFT JOIN 
            (
                SELECT *, COUNT(*) TMP
                FROM JOGO JOIN GOLO JOIN JOGADOR JOIN CLUBE
                ON JOGO.idJogo = GOLO.idJogo AND GOLO.idMarcador = JOGADOR.idJogador AND JOGADOR.idClube = CLUBE.idClube
                WHERE idEquipaVisitante = JOGADOR.idClube
                GROUP BY CLUBE.idClube, GOLO.idJogo
                ) as t2
        using(idJogo)
        )
USING(idJogo)
ORDER BY 1, 2
