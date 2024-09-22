-- Data cleaning

SELECT *
FROM layoffs;


-- step 1 : Remove duplicates
-- step 2 : Standardize the data
-- step 3 : Null values / blank values
-- step 4 : Remove columns and rows



CREATE TABLE layoffs_staging
LIKE layoffs;







SELECT *
FROM layoffs_staging;

-- insert data from layoffs into new table layoffs_staging
INSERT layoffs_staging
SELECT * 
FROM layoffs;



SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company,industry,total_laid_off,percentage_laid_off,`date`) AS row_num
FROM layoffs_staging;

-- checking duplicates using CTE
WITH duplicate_cte AS
(SELECT *, 
ROW_NUMBER() OVER(PARTITION BY location,company,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num>1;


SELECT *
FROM layoffs_staging
WHERE company='Casper';

-- creating new table to delete duplicates
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



SELECT *
FROM layoffs_staging2
WHERE row_num>1;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,industry,total_laid_off,percentage_laid_off,`date`) AS row_num
FROM layoffs_staging;


-- DELETE duplicates

Delete 
 FROM layoffs_staging2
	WHERE row_num >1 ;

SELECT *
FROM layoffs_staging2
WHERE row_num>1;



-- STAndardizind data 

SELECT company ,TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company=TRIM(company);

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto';


SELECT DISTINCT industry
FROM layoffs_staging2;




SELECT DISTINCT location
FROM layoffs_staging2;

SELECT DISTINCT country , TRIM(Trailing '.' FROM country)
FROM layoffs_staging2

ORDER By 1;


UPDATE layoffs_staging2
SET country =TRIM(Trailing '.' FROM country)
WHERE country LIKE 'United States%';


-- change string to data 
SELECT `date`,
str_to_date(`date`,'%m/%d/%Y')
FROM layoffs_staging2;

SELECT `date`
from layoffs_staging2;

-- update date
UPDATE layoffs_staging2
SET `date` = str_to_date(`date`,'%m/%d/%Y');

-- change data type 

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

UPDATE layoffs_staging2
SET industry =NULL
WHERE industry='';

SELECT *
FROM layoffs_staging2
WHERE industry is NULL or industry='';


SELECT *
FROM layoffs_staging2
WHERE company Like'Bally%';




SELECT t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	On t1.company=t2.company
WHERE (t1.industry is NULL OR t1.industry='')
AND t2.industry is not NULL ;


UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	On t1.company=t2.company
SET t1.industry=t2.industry
WHERE (t1.industry is NULL OR t1.industry='')
AND t2.industry is not NULL ;


SELECT *
FROM layoffs_staging2;


-- delete columns

SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

