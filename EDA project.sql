-- STEP 1 : UNDERSTANDING THE DATA STRUCTURE

-- CHECK TABLE STRUCTURE
DESCRIBE layoffs_staging2;

-- SAMPLE DATA
SELECT * FROM layoffs_staging2 LIMIT 10;

-- MISSING VALUES CHECK
SELECT COUNT(*) 
FROM layoffs_staging2
WHERE company IS NULL OR location IS NULL OR industry IS NULL;


-- STEP 2 : SUMMARIZE KEY METRICS

-- TOTAL NUMBER OF LAYOFFS
SELECT SUM(total_laid_off) AS total_layoffs FROM layoffs_staging2;


-- NUMBER OF COMAPNIES
SELECT COUNT(DISTINCT company) AS num_companies FROM layoffs_staging2;

-- AFFECTED INDUSTRIES
SELECT 
    COUNT(DISTINCT industry) AS num_industries
FROM
    layoffs_staging2;


-- STEP 3 :DATA DISTRIBUTION

-- LAYOFFS BY INDUSTRY
SELECT industry, SUM(total_laid_off) AS layoffs_per_industry
FROM layoffs_staging2
GROUP BY industry
ORDER BY layoffs_per_industry DESC;

-- LAYOFFS BY COUNTRY 
SELECT country, SUM(total_laid_off) AS layoffs_per_country
FROM layoffs_staging2
GROUP BY country
ORDER BY layoffs_per_country DESC;

-- TOP 10 COMPANIES WITH MOST LAYOFFS
SELECT company, total_laid_off
FROM layoffs_staging2
ORDER BY total_laid_off DESC
LIMIT 10;


-- STEP 4 : TRENDS OVER TIME

-- LAYOFF BY YEAR (OR MONTH)
SELECT EXTRACT(YEAR FROM date) AS year, SUM(total_laid_off) AS layoffs_per_year
FROM layoffs_staging2
GROUP BY year
ORDER BY year;

-- LAYOFF BY STAGE (EARLY ,GROWTH ,ETC)

SELECT stage, SUM(total_laid_off) AS layoffs_per_stage
FROM layoffs_staging2
GROUP BY stage
ORDER BY layoffs_per_stage DESC;


-- STEP 5 : SEGMENT THE DATA

-- LAYOFFS BY PERCENTAGE(COMPANIES LAYING OFF MORE THAN 50%)
SELECT company, total_laid_off, percentage_laid_off
FROM layoffs_staging2
WHERE CAST(REPLACE(percentage_laid_off, '%', '') AS DECIMAL) > .5
ORDER BY total_laid_off DESC;

-- LAYOFFS OVER COMAPNIES THAT RAISED OVER 100M

SELECT company, total_laid_off, funds_raised_millions
FROM layoffs_staging2
WHERE funds_raised_millions > 100
ORDER BY total_laid_off DESC;

-- STEP 6 : IDENITFY ANOMALIES

SELECT Distinct company, total_laid_off 
FROM layoffs_staging2
WHERE total_laid_off > (SELECT AVG(total_laid_off) FROM layoffs) * 2
ORDER BY total_laid_off DESC;





-- average total laid off
SELECT avg(total_laid_off)
from layoffs_staging2;

