.mode columns
.headers on

select visitante.n as NOME, round(avg(VISITADA.aux) - avg(VISITANTE.aux), 2) ASSISTENCIA_CASA_VS_FORA
from (
        select CLUBE.nome as n, JOGO.assistencia * 100.0 / ESTADIO.lotacao as aux
        from CLUBE join JOGO join ESTADIO
        on CLUBE.idClube = JOGO.idEquipaVisitante and JOGO.idEstadio = ESTADIO.idEstadio
        ) as visitante,
     (
        select CLUBE.nome as n, JOGO.assistencia * 100.0 / ESTADIO.lotacao as aux
        from CLUBE join JOGO join ESTADIO
        on CLUBE.idClube = JOGO.idEquipaVisitada and JOGO.idEstadio = ESTADIO.idEstadio
        ) as visitada
where visitante.n = visitada.n
group by 1
order by 2 desc
