.mode columns
.headers on
.nullvalue NULL

/* listagem dos jogos decididos em tempo compensação, ordenacao por data */

drop view if exists visitada_reg;
create view visitada_reg as
select jogo.dataJogo DATA, golo.idJogo id, clube.nome EQUIPA_VISITADA, count(*) GOLOS_EQUIPA_VISITADA
from jogo join golo join jogador join clube
on jogo.idJogo = golo.idJogo and golo.idMarcador = jogador.idJogador and jogador.idClube = clube.idClube
where jogador.idClube = jogo.idEquipaVisitada and golo.minuto not like '90+%'
group by 2, 3;

drop view if exists visitante_reg;
create view visitante_reg as
select jogo.dataJogo DATA, golo.idJogo id, clube.nome EQUIPA_VISITANTE, count(*) GOLOS_EQUIPA_VISITANTE
from jogo join golo join jogador join clube
on jogo.idJogo = golo.idJogo and golo.idMarcador = jogador.idJogador and jogador.idClube = clube.idClube
where jogador.idClube = jogo.idEquipaVisitante and golo.minuto not like '90+%'
group by 2, 3;

drop view if exists visitada_comp;
create view visitada_comp as
select jogo.dataJogo DATA, golo.idJogo id, clube.nome EQUIPA_VISITADA, count(*) GOLOS_EQUIPA_VISITADA
from jogo join golo join jogador join clube
on jogo.idJogo = golo.idJogo and golo.idMarcador = jogador.idJogador and jogador.idClube = clube.idClube
where jogador.idClube = jogo.idEquipaVisitada
group by 2, 3;

drop view if exists visitante_comp;
create view visitante_comp as
select jogo.dataJogo DATA, golo.idJogo id, clube.nome EQUIPA_VISITANTE, count(*) GOLOS_EQUIPA_VISITANTE
from jogo join golo join jogador join clube
on jogo.idJogo = golo.idJogo and golo.idMarcador = jogador.idJogador and jogador.idClube = clube.idClube
where jogador.idClube = jogo.idEquipaVisitante
group by 2, 3;		

drop view if exists jogo_equipas;
create view jogo_equipas as
select t1.id, EQUIPA_VISITADA, EQUIPA_VISITANTE
from (
		select jogo.idJogo id, clube.nome EQUIPA_VISITADA
		from clube join jogo
		on clube.idClube = jogo.idEquipaVisitada
		) as t1,
	(
		select jogo.idJogo id, clube.nome EQUIPA_VISITANTE
		from clube join jogo
		on clube.idClube = jogo.idEquipaVisitante		
		) as t2
where t1.id = t2.id;

drop view if exists tabela_resultados_comp;
create view tabela_resultados_comp as
select id, DATA, EQUIPA_VISITADA, ifnull(GOLOS_EQUIPA_VISITADA, 0) GOLOS_EQUIPA_VISITADA, ifnull(GOLOS_EQUIPA_VISITANTE, 0) GOLOS_EQUIPA_VISITANTE, EQUIPA_VISITANTE
from (
		select distinct id, data, GOLOS_EQUIPA_VISITADA, GOLOS_EQUIPA_VISITANTE
		from visitada_comp left join visitante_comp using(data, id)
		UNION
		select distinct id, data, GOLOS_EQUIPA_VISITADA, GOLOS_EQUIPA_VISITANTE
		from visitante_comp left join visitada_comp using(data, id)
		)
		join jogo_equipas using(id);
	

drop view if exists tabela_resultados_reg;
create view tabela_resultados_reg as
select id, DATA, EQUIPA_VISITADA, ifnull(GOLOS_EQUIPA_VISITADA, 0) GOLOS_EQUIPA_VISITADA, ifnull(GOLOS_EQUIPA_VISITANTE, 0) GOLOS_EQUIPA_VISITANTE, EQUIPA_VISITANTE
from (
		select distinct id, data, GOLOS_EQUIPA_VISITADA, GOLOS_EQUIPA_VISITANTE
		from visitada_reg left join visitante_reg using(data, id)
		UNION
		select distinct id, data, GOLOS_EQUIPA_VISITADA, GOLOS_EQUIPA_VISITANTE
		from visitante_reg left join visitada_reg using(data, id)
		)
		join jogo_equipas using(id);

select t2.data, t2.equipa_visitada, t2.golos_equipa_visitada, t2.golos_equipa_visitante, t2.equipa_visitante
from tabela_resultados_comp t2 left join tabela_resultados_reg t1 
on t1.id = t2.id
where (t1.GOLOS_EQUIPA_VISITADA = t1.GOLOS_EQUIPA_VISITANTE or t1.GOLOS_EQUIPA_VISITADA is null) and t2.GOLOS_EQUIPA_VISITADA <> t2.GOLOS_EQUIPA_VISITANTE
order by 1;
