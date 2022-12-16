select case 
            when minuto not like "%+%" then cast(substr(minuto, 1, length(minuto) - 1) as int)
            when minuto like "%+%" then cast(substr(minuto, 1, 2) as int)
        end as MINUTO_REGULAMENTAR,
        case when minuto like "%+%" then cast(substr(minuto, 4, length(minuto) - 4) as int) end as MINUTO_COMPENSACAO,
		count(idGolo) as GOLOS
from golo
group by minuto
order by 1, 2
