
-- Antes de realizar el análisis vemos que la columna stream esta enformato texto por lo que la cambiamos a integer
-- creando una nueva columna con los mismos datos, de la siguiente manera:
ALTER TABLE spotify2023
ADD numero_streams INT

UPDATE spotify2023
SET numero_streams = streams
-- También borramos una fila entera ya que esta mal escrita
DELETE FROM spotify2023
WHERE [artist(s)_name] = 'Edison Lighthouse'

--1.- ¿Cuál ha sido la canción y artista más escuchado en 2023 y el que menos?
       
-- El que más
       
      SELECT [artist(s)_name], track_name,streams_num
      FROM spotify2023
      ORDER BY streams_num DESC
       
--El que menos
       
       SELECT [artist(s)_name], track_name,streams_num
       FROM spotify2023
       ORDER BY streams_num 
       
--2.- ¿Y quién fue más escuchado entre 2000 y 2010?
       
       SELECT [artist(s)_name], track_name,streams_num,released_year
       FROM spotify2023
       WHERE released_year BETWEEN 2000 AND 2010
       ORDER BY streams_num DESC
       
--3. ¿Cuáles fueron las 5 canciones más escuchadas antes del 2000?¿Y cuales entre 2005 y 2010?
       
-- Antes del 2000
       
       SELECT [artist(s)_name], track_name,streams_num,released_year
       FROM spotify2023
       WHERE released_year < 2000 
       ORDER BY streams_num DESC
       LIMIT 5
       
--Entre 2005 y 2010
       
       SELECT [artist(s)_name], track_name,streams_num,released_year
       FROM spotify2023
       WHERE released_year BETWEEN 2005 AND 2010
       ORDER BY streams_num desc
       LIMIT 5
--4. ¿En que mes se escucha más música de 2022?
       
       SELECT sum(streams_num) as total_escuchas,released_year,released_month
       FROM spotify2023
       WHERE released_year = 2022 
       GROUP BY released_month
       ORDER BY total_escuchas DESC
       
--5.¿Cuántas canciones tiene Miley Cyrus, Bad Bunny y Taylor Swift?
       
       SELECT [artist(s)_name],COUNT(track_name) AS numero_canciones
       FROM spotify2023
       WHERE [artist(s)_name] IN ('Miley Cyrus','Bad Bunny','Taylor Swift')
       GROUP BY [artist(s)_name]
       ORDER BY numero_canciones DESC
       
--6.. ¿Qué porcentaje de discursos tienen las 5 canciones más escuchadas y las que menos?
       
-- Las que más
       
       SELECT track_name, [speechiness_%], numero_streams
       FROM spotify2023
       ORDER BY numero_streams DESC
       LIMIT 5
-- Las que menos
       
      SELECT track_name, [speechiness_%], numero_streams
      FROM spotify2023
      ORDER BY numero_streams 
      LIMIT 5
       
--7. Muéstrame las 10 canciones más escuchadas y dime en cuantas playlists están? ¿Y las que menos?
       
-- Las más escuchadas
       
     SELECT track_name,[artist(s)_name], numero_streams,in_spotify_playlists
     FROM spotify2023
     ORDER BY numero_streams DESC
     LIMIT 10
       
-- Las menos escuchadas
       
     SELECT track_name,[artist(s)_name], numero_streams,in_spotify_playlists
     FROM spotify2023
     ORDER BY numero_streams 
     LIMIT 10
       
-- 8. Créame una columna nueva en la que se clasifiquen las canciones según el número de escuchadas. 
--Las que superen 2000000000 que aparezcan como ‘Super hit’, entre 800000 y 2000000000 ‘Mediocre’ y menos de 800000 ‘No muy buena’.
       
     SELECT track_name, numero_streams, CASE
     WHEN numero_streams > 2000000000 THEN 'Super hit'
     WHEN  numero_streams > 80000000  THEN 'Mediocre'
     ELSE 'No muy buena'
     END AS 'Calificación canciones'
     FROM spotify2023
       
--9.Quiero comparar la popularidad de las canciones de Taylor Swift y Bad Bunny. Muestrame cuantas canciones tiene cada uno y la cantidad de veces que han escucado esa canción.
       
     SELECT [artist(s)_name], COUNT(track_name) AS numero_canciones, sum(numero_streams) AS total_vistas
     FROM spotify2023
     WHERE [artist(s)_name] IN ( 'SZA','Bad Bunny')
     GROUP BY [artist(s)_name]
       
--10. ¿Cuántas veces han escuchado canciones que empiezan con Car’s Outside y dime en que mes y año salió la canción?
       
     SELECT [artist(s)_name], track_name,numero_streams,
             released_month,released_year
     FROM spotify2023
     WHERE track_name LIKE 'Car%'
       
--11.Que 10 canciones más escuchadas al menos tienen dos artistas.
       
     SELECT track_name AS total_canciones,artist_count,numero_streams
     FROM spotify2023
     WHERE artist_count >= 2
     ORDER BY numero_streams DESC
     LIMIT 10
       
-- 12.Muéstrame el número de canciones que tiene aquellos, pero solo de aquellos que tengan más de 5 canciones.
       
      SELECT [artist(s)_name], COUNT(track_name) AS total_canciones
      FROM spotify2023
      GROUP BY  [artist(s)_name]
      HAVING total_canciones > 5
      ORDER BY total_canciones DESC
       
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
     HAVING media_escuchas_2017 IS NOT NULL

