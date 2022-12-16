.mode columns
.headers on
.nullvalue NULL

/* listar todos os avancados da liga */

select j.nome AS NOME , j.nacionalidade as NACIONALIDADE , c.nome as CLUBE 
from jogador j join clube c using (idClube)
where j.posicao = 'A' 
order by 1;
