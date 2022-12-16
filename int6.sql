.mode columns
.headers on
.nullvalue NULL

select a.idJogo , a.dataJogo , a.c1 , a.GOLOS_VISITADO , b.GOLOS_VISITANTE , b.c2 
from (select jogo.idJogo as idJogo, jogo.dataJogo as dataJogo , clube.nome as c1 ,  clube.idClube , count(*) as GOLOS_VISITADO 
from golo join jogo using(idJogo)
join jogador on golo.idMarcador = jogador.idJogador 
join clube using(idClube) 
where idJogo = 3 and idClube = jogo.idEquipaVisitada
group by clube.nome) a , (select jogo.idJogo as idJogo, clube.nome as c2 ,  clube.idClube , count(*) as GOLOS_VISITANTE
from golo join jogo using(idJogo)
join jogador on golo.idMarcador = jogador.idJogador 
join clube using(idClube) 
where idJogo = 3 and idClube = jogo.idEquipaVisitante
group by clube.nome) b;
