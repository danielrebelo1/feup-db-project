.mode columns
.headers on
.nullvalue NULL

/* valores de mercado das equipas bem como média de valor de mercado de jogador p cada equipa
ordenacao por valor de mercado total da equipa , desempate por média do valor de mercado de cada jogador */ 

select clube.nome as clube , round(sum(jogador.valorMercado)) as VM_EQUIPA , round(1.0 * sum(jogador.valorMercado) / a.JOGADORES_EQUIPA,2) as AVERAGE  
from clube join jogador on clube.idClube = jogador.idClube ,
 (select clube.idClube idClube , count(*) as JOGADORES_EQUIPA from jogador join clube on clube.idClube = jogador.idClube where jogador.valorMercado IS NOT NULL group by clube.idClube) as a where a.idClube = clube.idClube 
group by clube.idClube
order by 2 desc , 3 desc