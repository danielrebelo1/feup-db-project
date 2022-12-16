.mode columns
.headers on
.nullvalue NULL

/* jogadores da equipa do presidente + velho c mais de 1.75 de altura */

select jogador.nome , idClube , jogador.altura from 
jogador join
(select idClube , NOME , max(IDADE) from 
(select p.idPresidente as ID, p.idClube as idClube,  p.nomePresidente as NOME , strftime('%Y','now') - substr(p.dataNascimento,7,4) as IDADE from presidente p)
order by 2 desc , 1 asc) using(idClube)
where substr(jogador.altura,1,4) >= 1.75
order by substr(jogador.altura,1,4) desc , 1 asc
