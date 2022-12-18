.mode columns
.headers on
.nullvalue NULL

/* listagem dos jogos decididos em tempo compensação, ordenacao por data */

select DATA, VISITADA, GOLOS_VISITADA, GOLOS_VISITANTE, VISITANTE
from
    (
        select jogo.dataJogo DATA, golo.idJogo id, clube.nome VISITADA, count(*) GOLOS_VISITADA
        from jogo join golo join jogador join clube
        on jogo.idJogo = golo.idJogo and golo.idMarcador = jogador.idJogador and jogador.idClube = clube.idClube
        where jogador.idClube = jogo.idEquipaVisitada
        group by 2
        ) as t1,
    (
        select golo.idJogo id, clube.nome VISITANTE, count(*) GOLOS_VISITANTE
        from jogo join golo join jogador join clube
        on jogo.idJogo = golo.idJogo and golo.idMarcador = jogador.idJogador and jogador.idClube = clube.idClube
        where jogador.idClube = jogo.idEquipaVisitante
        group by 1
        ) as t2,
	(
		select golo.idJogo id, count(*) GOLOS_VISITADA_ANTES_PROLONGAMENTO
		from jogo join golo join jogador join clube
		on jogo.idJogo = golo.idJogo and golo.idMarcador = jogador.idJogador and jogador.idClube = clube.idClube
		where jogador.idClube = jogo.idEquipaVisitada and minuto not like '90+%'
		group by 1
		) as t3,
	(
		select golo.idJogo id, count(*) GOLOS_VISITANTE_ANTES_PROLONGAMENTO
		from jogo join golo join jogador join clube
		on jogo.idJogo = golo.idJogo and golo.idMarcador = jogador.idJogador and jogador.idClube = clube.idClube
		where jogador.idClube = jogo.idEquipaVisitante and minuto not like '90+%'
		group by 1
		) as t4
where t1.id = t2.id and t2.id = t3.id and t3.id = t4.id
		and t1.id in (
						select distinct idJogo
						from jogo join golo
						using(idJogo)
						where golo.minuto like '90+%'
						)
		and GOLOS_VISITADA_ANTES_PROLONGAMENTO = GOLOS_VISITANTE_ANTES_PROLONGAMENTO
order by 1
