.mode columns
.headers on
.nullvalue NULL

/* melhores marcadores - feita */

select jogador.nome , count(*) as GOLOS 
from golo join jogador on golo.idMarcador = jogador.idJogador join jogo on golo.idJogo = jogo.idJogo 
group by 1 
having GOLOS >= 10
order by 2 desc , 1 asc