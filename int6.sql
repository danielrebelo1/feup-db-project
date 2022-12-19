.mode columns
.headers on
.nullvalue NULL

/* listar relação entre golos marcados no prolongamento em relação a golos em
tempo regulamentar para todas as equipas */

select a.GolosProlongamento * 100/b.GolosTotais as result, a.nomeClube from 
(select count(*) as GolosProlongamento, CLUBE.idClube as clubeID, CLUBE.nome as nomeClube from GOLO, JOGADOR, CLUBE where golo.idMarcador = JOGADOR.idJogador and JOGADOR.idClube = CLUBE.idClube and golo.minuto like '90+%' group by 2) as a, 
(select count(*) as GolosTotais, CLUBE.idClube as clubeID from clube, GOLO, JOGADOR where golo.idMarcador = JOGADOR.idJogador and JOGADOR.idCLUBE = CLUBE.idClube group by 2) as b where a.clubeID = b.clubeID
order by 1 DESC
