/* a. Percent forest of the entire world in 2016; highest and lowest
region, to 2 decimal places. */
-- FIX: the old query summed forest/total area across every row for the year,
-- which included the "World" aggregate row itself alongside every country row
-- (double counting). The world total should come straight from the single
-- World-level observation instead of being re-aggregated.
SELECT
    ROUND(CAST(forest_area_sqkm / total_area_sqkm * 100 AS NUMERIC), 2) AS forest_area_world
FROM forestation
WHERE year = 2016 AND country_name = 'World';

-- FIX: excluded the World row from the regional grouping (it has no region
-- of its own and would otherwise appear as a phantom "region"), and made the
-- descending sort explicit.
SELECT
    region,
    ROUND(CAST(SUM(forest_area_sqkm) / NULLIF(SUM(total_area_sqkm), 0) * 100
        AS NUMERIC), 2) AS forest_area_pct
FROM forestation
WHERE year = 2016 AND country_name <> 'World'
GROUP BY region
ORDER BY forest_area_pct DESC;

-- FIX: same exclusion, explicit ASC for the lowest-region view.
SELECT
    region,
    ROUND(CAST(SUM(forest_area_sqkm) / NULLIF(SUM(total_area_sqkm), 0) * 100
        AS NUMERIC), 2) AS forest_area_pct
FROM forestation
WHERE year = 2016 AND country_name <> 'World'
GROUP BY region
ORDER BY forest_area_pct ASC;

/* b. Percent forest of the entire world in 1990; highest and lowest
region, to 2 decimal places. */
SELECT
    ROUND(CAST(forest_area_sqkm / total_area_sqkm * 100 AS NUMERIC), 2) AS forest_area_world
FROM forestation
WHERE year = 1990 AND country_name = 'World';

SELECT
    region,
    ROUND(CAST(SUM(forest_area_sqkm) / NULLIF(SUM(total_area_sqkm), 0) * 100
        AS NUMERIC), 2) AS forest_area_pct
FROM forestation
WHERE year = 1990 AND country_name <> 'World'
GROUP BY region
ORDER BY forest_area_pct DESC;

SELECT
    region,
    ROUND(CAST(SUM(forest_area_sqkm) / NULLIF(SUM(total_area_sqkm), 0) * 100
        AS NUMERIC), 2) AS forest_area_pct
FROM forestation
WHERE year = 1990 AND country_name <> 'World'
GROUP BY region
ORDER BY forest_area_pct ASC;

/* c. Which regions of the world DECREASED in forest area from 1990
to 2016? */
-- FIX: excluded the World row so it can't be mistaken for a "region" in the
-- HAVING comparison, and added an ORDER BY for readability.
SELECT
    region,
    SUM(CASE WHEN year = 1990 THEN forest_area_sqkm ELSE 0 END) AS forest_area_1990,
    SUM(CASE WHEN year = 2016 THEN forest_area_sqkm ELSE 0 END) AS forest_area_2016
FROM forestation
WHERE country_name <> 'World'
GROUP BY region
HAVING SUM(CASE WHEN year = 2016 THEN forest_area_sqkm ELSE 0 END) <
    SUM(CASE WHEN year = 1990 THEN forest_area_sqkm ELSE 0 END)
ORDER BY region;
