.mode columns
.headers on
.nullvalue NULL

/* equipas que estejam no top 3 melhores ataques e top 3 melhores defesas */
select nome 
from (select CLUBE.NOME as nome , count(*) as GOLOS_MARCADOS from clube, GOLO, JOGADOR where golo.idMarcador = JOGADOR.idJogador and JOGADOR.idCLUBE = CLUBE.idClube group by 1
order by 2 desc
limit 3) intersect 
select nome from (select clube.nome nome, a.counter  + b.counter AS GOLOS_SOFRIDOS
FROM (select clube.idClube id , count(*) as counter  from golo , jogo , clube , jogador
where golo.idJogo = jogo.idJogo and jogo.idEquipaVisitada = clube.idClube and GOLO.idMarcador = jogador.idJogador and jogador.idClube <> clube.idClube
group by clube.idClube) as a , (select clube.idClube id, count(*)as counter  from golo , jogo , clube , jogador
where golo.idJogo = jogo.idJogo and jogo.idEquipaVisitante = clube.idClube and GOLO.idMarcador = jogador.idJogador and jogador.idClube <> clube.idClube
group by clube.idClube) as b join clube where a.id = b.id and a.id = clube.idClube
ORDER BY 2
limit 3)