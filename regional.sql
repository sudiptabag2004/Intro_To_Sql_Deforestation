/* a. Percent forest of the entire world in 2016; highest and lowest
region, to 2 decimal places. */
SELECT ROUND(CAST(SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100
AS NUMERIC), 2) AS forest_area_world
FROM forestation
WHERE year = 2016;
SELECT region, ROUND(CAST(SUM(forest_area_sqkm) /
NULLIF(SUM(total_area_sqkm), 0) * 100 AS NUMERIC), 2) AS forest_area_world
FROM forestation
WHERE year = 2016
GROUP BY 1
ORDER BY 2 DESC;
SELECT region, ROUND(CAST(SUM(forest_area_sqkm) /
NULLIF(SUM(total_area_sqkm), 0) * 100 AS NUMERIC), 2) AS forest_area_world
FROM forestation
WHERE year = 2016
GROUP BY 1
ORDER BY 2;
/* b. Percent forest of the entire world in 1990; highest and lowest
region, to 2 decimal places. */
SELECT SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100 AS forest_area_world
FROM forestation
WHERE year = 1990;
SELECT region, ROUND(CAST(SUM(forest_area_sqkm) /
NULLIF(SUM(total_area_sqkm), 0) * 100 AS NUMERIC), 2) AS forest_area_world
FROM forestation
WHERE year = 1990
GROUP BY 1
ORDER BY 2 DESC;
SELECT region, ROUND(CAST(SUM(forest_area_sqkm) /
NULLIF(SUM(total_area_sqkm), 0) * 100 AS NUMERIC), 2) AS forest_area_world
FROM forestation
WHERE year = 1990
GROUP BY 1
ORDER BY 2;
/* c. Which regions of the world DECREASED in forest area from 1990
to 2016? */
SELECT
region,
SUM(CASE WHEN year = 1990 THEN forest_area_sqkm ELSE 0 END) AS forest_area_1990,
SUM(CASE WHEN year = 2016 THEN forest_area_sqkm ELSE 0 END) AS forest_area_2016
FROM forestation
GROUP BY region
HAVING SUM(CASE WHEN year = 2016 THEN forest_area_sqkm ELSE 0 END) <
SUM(CASE WHEN year = 1990 THEN forest_area_sqkm ELSE 0 END);