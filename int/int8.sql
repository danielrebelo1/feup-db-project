.mode columns
.headers on
.nullvalue NULL

/* jogadores da equipa do presidente + velho c mais de 1.75 de altura */

select jogador.nome as NOME_JOGADOR , jogador.altura as ALTURA_JOGADOR from jogador join
(select idClube, NOMECLUBE,  NOME , max(IDADE) from 
(select p.idPresidente as ID, p.idClube as idClube, c.nome as NOMECLUBE, p.nomePresidente as NOME , strftime('%Y','now') - substr(p.dataNascimento,7,4) as IDADE 
from presidente p join clube c using(idClube))) using(idClube) join clube using(idClube)
where CAST(substr(jogador.altura,1,4) AS FLOAT) >= 1.75 
order by CAST(substr(jogador.altura,1,4) AS FLOAT) desc , 1 asc
