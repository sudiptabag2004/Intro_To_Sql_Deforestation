/* a. Which 5 countries saw the largest amount decrease in forest area
from 1990 to 2016? */
-- FIX: replaced conditional aggregation with an explicit self-join that only
-- pairs a country's 1990 row with its 2016 row when BOTH exist and have a
-- non-null forest_area_sqkm value. LIMIT corrected from 6 to 5.
SELECT
    f1990.country_code,
    f1990.country_name,
    f1990.forest_area_sqkm AS forest_area_1990,
    f2016.forest_area_sqkm AS forest_area_2016,
    (f2016.forest_area_sqkm - f1990.forest_area_sqkm) AS forest_area_change
FROM forestation AS f1990
JOIN forestation AS f2016
    ON f1990.country_code = f2016.country_code
WHERE f1990.year = 1990
    AND f2016.year = 2016
    AND f1990.country_name <> 'World'
    AND f1990.forest_area_sqkm IS NOT NULL
    AND f2016.forest_area_sqkm IS NOT NULL
ORDER BY forest_area_change ASC
LIMIT 5;

/* b. Which 5 countries saw the largest percent decrease in forest
area from 1990 to 2016? */
-- FIX: same self-join pattern. This is the query that previously let
-- St. Martin (French part) in with a false -100%, because CASE WHEN ... ELSE 0
-- turned its missing (NULL) 2016 observation into a 0, making it look like a
-- complete loss. Requiring both years' values to be NOT NULL removes it
-- correctly instead of papering over the gap. LIMIT corrected from 6 to 5.
SELECT
    f1990.country_code,
    f1990.country_name,
    f1990.forest_area_sqkm AS forest_area_1990,
    f2016.forest_area_sqkm AS forest_area_2016,
    ROUND(CAST((f2016.forest_area_sqkm - f1990.forest_area_sqkm)
        / f1990.forest_area_sqkm * 100 AS NUMERIC), 2) AS percent_change
FROM forestation AS f1990
JOIN forestation AS f2016
    ON f1990.country_code = f2016.country_code
WHERE f1990.year = 1990
    AND f2016.year = 2016
    AND f1990.country_name <> 'World'
    AND f1990.forest_area_sqkm IS NOT NULL
    AND f2016.forest_area_sqkm IS NOT NULL
    AND f1990.forest_area_sqkm > 0
ORDER BY percent_change ASC
LIMIT 5;

/* c. If countries were grouped by percent forestation in quartiles,
which group had the most countries in it in 2016? */
-- FIX: switched from a window function (COUNT ... OVER PARTITION BY + DISTINCT)
-- to a true GROUP BY aggregation, as the rubric specifically required for this
-- question. ORDER BY countries DESC makes the largest group immediately visible.
SELECT
    CASE
        WHEN perc_land_is_forest <= 25 THEN '0-25%'
        WHEN perc_land_is_forest <= 50 THEN '25-50%'
        WHEN perc_land_is_forest <= 75 THEN '50-75%'
        ELSE '75-100%'
    END AS quartiles,
    COUNT(country_name) AS countries
FROM forestation
WHERE perc_land_is_forest IS NOT NULL
    AND year = 2016
    AND country_name <> 'World'
GROUP BY quartiles
ORDER BY countries DESC;

/* d. List all of the countries that were in the 4th quartile
(percent forest > 75%) in 2016. */
SELECT country_name, region, perc_land_is_forest
FROM forestation
WHERE year = 2016
    AND country_name <> 'World'
    AND perc_land_is_forest > 75
ORDER BY perc_land_is_forest DESC;

/* e. How many countries had a percent forestation higher than the
United States in 2016? */
WITH us_forest_percentage AS (
    SELECT perc_land_is_forest
    FROM forestation
    WHERE country_code = 'USA' AND year = 2016
)
SELECT COUNT(*) AS countries_higher_than_us
FROM forestation
WHERE year = 2016
    AND country_name <> 'World'
    AND perc_land_is_forest > (SELECT perc_land_is_forest FROM us_forest_percentage);
