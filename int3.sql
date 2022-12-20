.mode columns
.headers on
.nullvalue NULL

-- listar todos os jogos em abril  

select c1.nome , c2.nome , DIA
from clube c1 , clube c2 , 
(select jogo.idJogo as ID , jogo.idEquipaVisitada as id1 , jogo.idEquipaVisitante as id2 , jogo.dataJogo as DIA
from jogo
where jogo.dataJogo like '%-04-%') as a
where c1.idClube = id1 and c2.idClube = id2 

