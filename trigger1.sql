CREATE TRIGGER updateResultados 
on JOGO
AFTER INSERT
FOR EACH ROW
BEGIN
    WHEN
        EXISTS (SELECT 1 FROM jogo j , clube c WHERE j.idEquipaVisitada = clube.idClube)
END;

