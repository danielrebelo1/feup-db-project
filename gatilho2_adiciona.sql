create trigger updateJogo
before insert on jogo
for each row
begin
    select case
    when(select idEquipaVisitante from jogo where idEquipaVisitante = new.idEquipaVisitante or idEquipaVisitante = new.idEquipaVisitada)
    then RAISE(ABORT, 'A mesma equipa nao pode jogar duas vezes na mesma jornada')
    end;
end;