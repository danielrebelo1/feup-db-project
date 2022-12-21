CREATE TRIGGER IF NOT EXISTS deletePlayer
AFTER DELETE ON JOGADOR
BEGIN 
	SELECT CASE
		WHEN (
				SELECT count(*) 
				FROM CLUBE JOIN JOGADOR 
				USING(idClube)
				WHERE idClube = OLD.idClube
				) < 13
		THEN 
				RAISE(ABORT, 'Uma equipa tem de ter 13 jogadores no minimo')
	END;
END;

