--SELECT AVG(rating) FROM ratings WHERE movie_id in (SELECT id FROM movies WHERE year = 2012);

SELECT AVG(rating) FROM movies JOIN ratings ON movies.id = ratings.movie_id WHERE year = 2012 LIMIT 5;