.mode columns
.headers on
.nullvalue NULL

/* a tentar fazer os resultados de todos os jogos*/

select a.idJogo,a.nome,a.NRGOLOS
from
(select idJogo,clube.nome as nome ,count(*) as NRGOLOS from golo join jogo using(idJogo) join jogador on golo.idMarcador = jogador.idJogador join clube using(idClube)
group by idClube,idJogo
order by 1 asc) as a