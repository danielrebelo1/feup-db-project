.mode columns
.headers on
.nullvalue NULL

select c1.nome VISITADO , c2.nome as VISITANTE , jogo.idJogo as ID , GOLOS_VISITADO , jogo.dataJogo
from jogo, clube c1 , clube c2 , (select jogo.idJogo as idJogo, clube.idClube , count(*) as GOLOS_VISITADO from golo join jogo using(idJogo) join jogador on golo.idMarcador = jogador.idJogador join clube using(idClube)
group by clube.nome,jogo.idJogo) as a
where (jogo.idEquipaVisitada = c1.idClube and jogo.idEquipaVisitante = c2.idClube and c1.idClube = 1)
or (jogo.idEquipaVisitada = c1.idClube and jogo.idEquipaVisitante = c2.idClube and c2.idClube = 1)
and a.idJogo = jogo.idJogo and a.idClube = c1.idClube
group by c1.nome , c2.nome


/*
select jogo.idJogo as idJogo, clube.idClube , count(*) as GOLOS_VISITADO from golo join jogo using(idJogo) join jogador on golo.idMarcador = jogador.idJogador join clube using(idClube) where idJogo = 3
group by clube.nome,jogo.idJogo;
*/
