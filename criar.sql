PRAGMA foreign_keys=ON;
BEGIN TRANSACTION;
DROP TABLE IF EXISTS GOLO;
DROP TABLE IF EXISTS CLASSIFICACAO;
DROP TABLE IF EXISTS JOGO;
DROP TABLE IF EXISTS JORNADA;
DROP TABLE IF EXISTS ARBITRO;
DROP TABLE IF EXISTS JOGADOR;
DROP TABLE IF EXISTS PRESIDENTE;
DROP TABLE IF EXISTS TREINADOR;
DROP TABLE IF EXISTS CLUBE;
DROP TABLE IF EXISTS ESTADIO;
DROP VIEW IF EXISTS RESULTADOS;

CREATE TABLE ESTADIO (
	idEstadio	INTEGER NOT NULL UNIQUE,
	nome	TEXT NOT NULL UNIQUE,
	lotacao	INTEGER,
	PRIMARY KEY(idEstadio)	
);

CREATE TABLE CLUBE (
	idClube	INTEGER NOT NULL UNIQUE,
	nome	TEXT NOT NULL UNIQUE,
	anoFundacao	DATE,
	idEstadio	INTEGER NOT NULL,
	PRIMARY KEY(idClube)
	FOREIGN KEY(idEstadio) REFERENCES ESTADIO(idEstadio)
);

CREATE TABLE TREINADOR (
	idTreinador	INTEGER NOT NULL UNIQUE,
	nome	TEXT NOT NULL ,
	dataNascimento	DATE,
	nacionalidade	TEXT,
	idClube	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY(idTreinador),
	FOREIGN KEY(idClube) REFERENCES CLUBE(idClube)
);

CREATE TABLE PRESIDENTE (
	idPresidente	INTEGER NOT NULL UNIQUE,
	nomePresidente	TEXT NOT NULL ,
	dataNascimento	DATE,
	nacionalidade	TEXT,
	idClube	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY(idPresidente),
	FOREIGN KEY(idClube) REFERENCES CLUBE(idClube)
);

CREATE TABLE JOGADOR (
	idJogador	INTEGER NOT NULL UNIQUE,
	nome	TEXT NOT NULL,
	idade	TEXT,
	altura	TEXT,
	pePreferido	TEXT,
	jogadorDesde	DATE,
	fimContrato	DATE,
	valorMercado	REAL,
	numeroCamisola	TEXT,
	nacionalidade	TEXT,
	posicao	TEXT,
	idClube	INTEGER NOT NULL,
	PRIMARY KEY(idJogador),
	FOREIGN KEY(idClube) REFERENCES CLUBE(idClube)
);

CREATE TABLE ARBITRO (
	idArbitro	INTEGER NOT NULL UNIQUE,
	nome	TEXT NOT NULL,
	PRIMARY KEY(idArbitro)
);

CREATE TABLE JORNADA (
	idJornada INTEGER NOT NULL,
	PRIMARY KEY(idJornada)
);

CREATE TABLE JOGO (
	idJogo	INTEGER NOT NULL UNIQUE,
	dataJogo	DATE,
	horaJogo	TEXT,
	assistencia	INTEGER,
	idArbitro	INTEGER NOT NULL,
	idEstadio	INTEGER NOT NULL,
	idEquipaVisitada	INTEGER NOT NULL,
	idEquipaVisitante	INTEGER NOT NULL,
	idJornada INTEGER NOT NULL,
	PRIMARY KEY(idJogo),
	FOREIGN KEY(idEquipaVisitada) REFERENCES CLUBE(idClube),
	FOREIGN KEY(idEstadio) REFERENCES ESTADIO(idEstadio),
	FOREIGN KEY(idEquipaVisitante) REFERENCES CLUBE(idClube),
	FOREIGN KEY(idArbitro) REFERENCES ARBITRO(idArbitro),
	FOREIGN KEY(idJornada) REFERENCES JORNADA(idJornada)
);

CREATE TABLE CLASSIFICACAO(
	idResultados INTEGER NOT NULL,
	idClube INTEGER NOT NULL,
	goalsScored INTEGER check (goalsScored>= 0),
	goalsConceded INTEGER check (goalsConceded>= 0),
	PRIMARY KEY(idResultados),
	FOREIGN KEY(idClube) REFERENCES CLUBE(idClube)
);

CREATE TABLE GOLO (
	idGolo	INTEGER NOT NULL UNIQUE,
	minuto	TEXT,
	idMarcador	INTEGER NOT NULL,
	idAssistente	INTEGER,
	idJogo	INTEGER NOT NULL,
	FOREIGN KEY(idJogo) REFERENCES JOGO(idJogo),
	FOREIGN KEY(idMarcador) REFERENCES JOGADOR(idJogador) ON DELETE CASCADE,
	PRIMARY KEY(idGolo),
	FOREIGN KEY(idAssistente) REFERENCES JOGADOR(idJogador) ON DELETE CASCADE
);

CREATE VIEW RESULTADOS AS 
SELECT DATA, HORA, VISITADA, GOLOS_VISITADA, GOLOS_VISITANTE, VISITANTE
FROM ( 
        SELECT t1.idJogo, t1.dataJogo DATA, t1.horaJogo HORA, t1.nome VISITADA, (CASE WHEN t2.TMP IS NULL THEN 0 ELSE t2.TMP END) GOLOS_VISITADA
        FROM (
                SELECT *
                FROM JOGO JOIN CLUBE
                ON JOGO.idEquipaVisitada = CLUBE.idClube
                ) as t1
                LEFT JOIN 
            (
                SELECT *, COUNT(*) TMP
                FROM JOGO JOIN GOLO JOIN JOGADOR JOIN CLUBE
                ON JOGO.idJogo = GOLO.idJogo AND GOLO.idMarcador = JOGADOR.idJogador AND JOGADOR.idClube = CLUBE.idClube
                WHERE idEquipaVisitada = JOGADOR.idClube
                GROUP BY CLUBE.idClube, GOLO.idJogo
                ) as t2
        using(idJogo)
        ) 
JOIN
     (
        SELECT t1.idJogo, t1.nome VISITANTE, (CASE WHEN t2.TMP IS NULL THEN 0 ELSE t2.TMP END) GOLOS_VISITANTE
        FROM (
                SELECT *
                FROM JOGO JOIN CLUBE
                ON JOGO.idEquipaVisitante = CLUBE.idClube
                ) as t1
                LEFT JOIN 
            (
                SELECT *, COUNT(*) TMP
                FROM JOGO JOIN GOLO JOIN JOGADOR JOIN CLUBE
                ON JOGO.idJogo = GOLO.idJogo AND GOLO.idMarcador = JOGADOR.idJogador AND JOGADOR.idClube = CLUBE.idClube
                WHERE idEquipaVisitante = JOGADOR.idClube
                GROUP BY CLUBE.idClube, GOLO.idJogo
                ) as t2
        using(idJogo)
        )
USING(idJogo)
ORDER BY 1, 2;

CREATE VIEW RESULTADOS_REG AS 
SELECT idJogo, DATA, HORA, VISITADA, GOLOS_VISITADA, GOLOS_VISITANTE, VISITANTE
FROM ( 
        SELECT t1.idJogo, t1.dataJogo DATA, t1.horaJogo HORA, t1.nome VISITADA, (CASE WHEN t2.TMP IS NULL THEN 0 ELSE t2.TMP END) GOLOS_VISITADA
        FROM (
                SELECT *
                FROM JOGO JOIN CLUBE
                ON JOGO.idEquipaVisitada = CLUBE.idClube
                ) as t1
                LEFT JOIN 
            (
                SELECT *, COUNT(*) TMP
                FROM JOGO JOIN GOLO JOIN JOGADOR JOIN CLUBE
                ON JOGO.idJogo = GOLO.idJogo AND GOLO.idMarcador = JOGADOR.idJogador AND JOGADOR.idClube = CLUBE.idClube
                WHERE idEquipaVisitada = JOGADOR.idClube AND minuto not like '90+%'
                GROUP BY CLUBE.idClube, GOLO.idJogo
                ) as t2
        using(idJogo)
        ) 
JOIN
     (
        SELECT t1.idJogo, t1.nome VISITANTE, (CASE WHEN t2.TMP IS NULL THEN 0 ELSE t2.TMP END) GOLOS_VISITANTE
        FROM (
                SELECT *
                FROM JOGO JOIN CLUBE
                ON JOGO.idEquipaVisitante = CLUBE.idClube
                ) as t1
                LEFT JOIN 
            (
                SELECT *, COUNT(*) TMP
                FROM JOGO JOIN GOLO JOIN JOGADOR JOIN CLUBE
                ON JOGO.idJogo = GOLO.idJogo AND GOLO.idMarcador = JOGADOR.idJogador AND JOGADOR.idClube = CLUBE.idClube
                WHERE idEquipaVisitante = JOGADOR.idClube AND minuto not like '90+%'
                GROUP BY CLUBE.idClube, GOLO.idJogo
                ) as t2
        using(idJogo)
        )
USING(idJogo)
ORDER BY 1, 2;

COMMIT;
