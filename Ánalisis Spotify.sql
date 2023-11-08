
-- Antes de realizar el an�lisis vemos que la columna stream esta enformato texto por lo que la cambiamos a integer
-- creando una nueva columna con los mismos datos, de la siguiente manera:
ALTER TABLE spotify2023
ADD numero_streams INT

UPDATE spotify2023
SET numero_streams = streams
-- Tambi�n borramos una fila entera ya que esta mal escrita
DELETE FROM spotify2023
WHERE [artist(s)_name] = 'Edison Lighthouse'

--1.- �Cu�l ha sido la canci�n y artista m�s escuchado en 2023 y el que menos?
-- El que m�s
select [artist(s)_name], track_name,streams_num
from spotify2023
order by streams_num DESC
--El que menos
select [artist(s)_name], track_name,streams_num
from spotify2023
order by streams_num 
--2.- �Y qui�n fue m�s escuchado entre 2000 y 2010?
select [artist(s)_name], track_name,streams_num,released_year
from spotify2023
where released_year BETWEEN 2000 and 2010
order by streams_num desc
--3. �Cu�les fueron las 5 canciones m�s escuchadas antes del 2000?�Y cuales entre 2005 y 2010?
-- Antes del 2000
select [artist(s)_name], track_name,streams_num,released_year
from spotify2023
where released_year < 2000 
order by streams_num desc
limit 5
--Entre 2005 y 2010
select [artist(s)_name], track_name,streams_num,released_year
from spotify2023
where released_year BETWEEN 2005 and 2010
order by streams_num desc
limit 5
--4. �En que mes se escucha m�s m�sica de 2022?
select sum(streams_num) as total_escuchas,released_year,released_month
from spotify2023
where released_year = 2022 
group by released_month
order by total_escuchas desc
--5.�Cu�ntas canciones tiene Miley Cyrus, Bad Bunny y Taylor Swift?
select [artist(s)_name],count(track_name) as numero_canciones
from spotify2023
where [artist(s)_name] in ('Miley Cyrus','Bad Bunny','Taylor Swift')
group by [artist(s)_name]
order by numero_canciones desc
--6.. �Qu� porcentaje de discursos tienen las 5 canciones m�s escuchadas y las que menos?
-- Las que m�s
select track_name, [speechiness_%], numero_streams
from spotify2023
order by numero_streams DESC
limit 5
-- Las que menos
select track_name, [speechiness_%], numero_streams
from spotify2023
order by numero_streams 
limit 5
--7. Mu�strame las 10 canciones m�s escuchadas y dime en cuantas playlists est�n? �Y las que menos?
-- Las m�s escuchadas
select track_name,[artist(s)_name], numero_streams,in_spotify_playlists
from spotify2023
order by numero_streams desc
limit 10
-- Las menos escuchadas
select track_name,[artist(s)_name], numero_streams,in_spotify_playlists
from spotify2023
order by numero_streams 
limit 10
-- 8. Cr�ame una columna nueva en la que se clasifiquen las canciones seg�n el n�mero de escuchadas. 
--Las que superen 2000000000 que aparezcan como �Super hit�, entre 800000 y 2000000000 �Mediocre� y menos de 800000 �No muy buena�.
select track_name, numero_streams, case
when numero_streams > 2000000000 then 'Super hit'
when  numero_streams > 80000000  then 'Mediocre'
else 'No muy buena'
end as 'Calificaci�n canciones'
from spotify2023
--9.Quiero comparar la popularidad de las canciones de Taylor Swift y Bad Bunny. Muestrame cuantas canciones tiene cada uno y la cantidad de veces que han escucado esa canci�n.
select [artist(s)_name], count(track_name) as numero_canciones, sum(numero_streams) as total_vistas
from spotify2023
where [artist(s)_name] in ( 'SZA','Bad Bunny')
group by [artist(s)_name]
--10. �Cu�ntas veces han escuchado canciones que empiezan con Car�s Outside y dime en que mes y a�o sali� la canci�n?
select [artist(s)_name], track_name,numero_streams,
released_month,released_year
from spotify2023
where track_name Like 'Car%'
--11.Que 10 canciones m�s escuchadas al menos tienen dos artistas.
select track_name as total_canciones,artist_count,numero_streams
from spotify2023
where artist_count >= 2
order by numero_streams desc
limit 10
-- 12.Mu�strame el n�mero de canciones que tiene aquellos, pero solo de aquellos que tengan m�s de 5 canciones.
select [artist(s)_name], count(track_name) as total_canciones
from spotify2023
group by  [artist(s)_name]
having total_canciones > 5
order by total_canciones DESC
-- 13.En 2017 cual es la media de escuchas para cada artista (Solo 1 artista) 
SELECT [artist(s)_name], 
       (SELECT AVG(numero_streams) 
        FROM spotify2023 AS media_escuchas
        WHERE released_year = 2017
        AND media_escuchas.[artist(s)_name] = spotify2023.[artist(s)_name]
       ) AS media_escuchas_2017
FROM spotify2023
WHERE artist_count = 1 
GROUP BY [artist(s)_name]
having media_escuchas_2017 IS NOT NULL

