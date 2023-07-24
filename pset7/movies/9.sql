SELECT DISTINCT(name) FROM people WHERE id in (SELECT person_id FROM stars WHERE movie_id in (SELECT id FROM movies WHERE year = 2004))
ORDER BY birth;
-- CREATE INDEX "stars.movie_id_index" ON stars ("movie_id");
-- CREATE INDEX "people.id_index" on people ("id");