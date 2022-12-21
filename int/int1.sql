.mode columns
.headers on
.nullvalue NULL

-- listar todos os estadios ordenando por ano de fundacao do clube , desempate alfabetico

select c.nome as NOME_CLUBE, anoFundacao as ANO_FUNDACAO , e.nome AS ESTADIO from clube c join estadio e using(idEstadio) 
order by 2, 1;


