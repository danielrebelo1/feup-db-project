create trigger updategoals
after insert on golo
for each row
begin
    update classificacao
        set goalsScored = goalsScored + 1
        where idClube = (select clube.idClube from golo join jogo on new.idJogo = jogo.idJogo join jogador on new.idMarcador = jogador.idJogador join clube on jogador.idClube = clube.idClube);
    update classificacao
        set goalsConceded = goalsConceded + 1
        where idClube = (select clube.idClube from golo join jogo on new.idJogo = jogo.idJogo join jogador on new.idMarcador = jogador.idJogador join clube on jogador.idClube = clube.idClube
        where idClube <> (select clube.idClube from golo join jogo on new.idJogo = jogo.idJogo join jogador on new.idMarcador = jogador.idJogador join clube on jogador.idClube = clube.idClube));
end;

