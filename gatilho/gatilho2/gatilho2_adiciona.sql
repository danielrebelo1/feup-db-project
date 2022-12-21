create trigger updateJogo
before insert on jogo
for each row
begin
    select case
		when exists (
			select *
			from jogo
			where jogo.idJornada = new.idJornada and (idEquipaVisitante = new.idEquipaVisitante or idEquipaVisitada = new.idEquipaVisitada
														or idEquipaVisitante = new.idEquipaVisitada or idEquipaVisitada = new.idEquipaVisitante
			)
						)
		then RAISE(ABORT, 'A mesma equipa nao pode jogar duas vezes na mesma jornada')
    end;
end;    
