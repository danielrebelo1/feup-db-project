.mode columns
.headers on
.nullvalue NULL

/* listagem dos jogos decididos em tempo compensação, ordenacao por data */

SELECT t1.DATA, t1.HORA, t1.VISITADA, t2.GOLOS_VISITADA, t2.GOLOS_VISITANTE, t1.VISITANTE
from RESULTADOS_REG AS t1 join RESULTADOS AS t2
using(idJogo)
where (t1.GOLOS_VISITADA = t1.GOLOS_VISITANTE) and (t2.GOLOS_VISITADA <> t2.GOLOS_VISITANTE)
order by 1;
