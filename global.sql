/* a. What was the total forest area (in sq km) of the world in 1990? */
SELECT country_name, forest_area_sqkm, year
FROM forestation
WHERE country_name = 'World' AND year = 1990;

/* b. What was the total forest area (in sq km) of the world in 2016? */
SELECT country_name, forest_area_sqkm, year
FROM forestation
WHERE country_name = 'World' AND year = 2016;

/* c. What was the change (in sq km) in the forest area of the world
from 1990 to 2016? */
-- FIX: replaced the comma-separated table list with an explicit JOIN,
-- joining the two years of the same "World" row to itself on country_code.
SELECT
    (f2016.forest_area_sqkm - f1990.forest_area_sqkm) AS forest_area_change_sq_km
FROM forestation AS f2016
JOIN forestation AS f1990
    ON f2016.country_code = f1990.country_code
WHERE f2016.year = 2016 AND f2016.country_name = 'World'
    AND f1990.year = 1990 AND f1990.country_name = 'World';

/* d. What was the percent change in forest area of the world between
1990 and 2016? */
-- FIX: same explicit JOIN as (c).
SELECT
    (f2016.forest_area_sqkm - f1990.forest_area_sqkm) AS forest_area_change_sq_km,
    ROUND(CAST((f2016.forest_area_sqkm - f1990.forest_area_sqkm)
        / f1990.forest_area_sqkm * 100 AS NUMERIC), 2) AS forest_area_percent_change
FROM forestation AS f2016
JOIN forestation AS f1990
    ON f2016.country_code = f1990.country_code
WHERE f2016.year = 2016 AND f2016.country_name = 'World'
    AND f1990.year = 1990 AND f1990.country_name = 'World';

/* e. If you compare the amount of forest area lost between 1990 and
2016, to which country's total area in 2016 is it closest to? */
SELECT country_name, year, total_area_sqkm
FROM forestation
WHERE year = 2016
    AND country_name <> 'World'
    AND total_area_sqkm < (
        (SELECT forest_area_sqkm FROM forestation WHERE country_name = 'World' AND year = 1990) -
        (SELECT forest_area_sqkm FROM forestation WHERE country_name = 'World' AND year = 2016)
    )
ORDER BY total_area_sqkm DESC
LIMIT 1;
