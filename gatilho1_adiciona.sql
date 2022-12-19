create trigger updategoals
after insert on golo
for each row
begin
    update classificacao
        set goalsScored = goalsScored + 1
        where idClube = (select jogador.idClube from jogador join golo where jogador.idJogador = new.idMarcador);
    update classificacao
        set goalsConceded = goalsConceded + 1
        where idClube = (select clube.idClube from jogo,clube where jogo.idJogo = new.idJogo and idClube <> (select jogador.idClube from jogador join golo where jogador.idJogador = new.idMarcador) and idClube in 
			(select idEquipaVisitada as Equipas from jogo where idJogo = new.idJogo
			UNION
			select idEquipaVisitante from jogo where idjogo = new.idJogo));
end;