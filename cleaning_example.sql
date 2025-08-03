
--------------------------------------------------------------------------------
/*				                 Select Statement      		  		          */
--------------------------------------------------------------------------------

SELECT * FROM food_choices;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
/*				                   Backup Table     		  		          */
--------------------------------------------------------------------------------

CREATE TABLE food_choices_backup AS SELECT * FROM food_choices;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
/*				                 Duplicate Column      		  		          */
--------------------------------------------------------------------------------

ALTER TABLE food_choices
ADD vitamins_duplicate int;

UPDATE food_choices 
SET vitamins_duplicate = vitamins;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
/*				                   PART 2           		  		          */
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
/*		              Question 1 - Indentification query                      */
--------------------------------------------------------------------------------

SELECT type_sports FROM food_choices
WHERE type_sports LIKE 'nan' 
OR type_sports ILIKE '%none%'
OR type_sports ILIKE 'no%';

--------------------------------------------------------------------------------
/*				          Question 1 - Update query                           */
--------------------------------------------------------------------------------

UPDATE food_choices
SET type_sports = 'None'
WHERE type_sports ILIKE '%none%'
OR type_sports LIKE 'nan'
OR type_sports ILIKE 'no%';

--------------------------------------------------------------------------------
/*				        Question 1 - Validation query                         */
--------------------------------------------------------------------------------

SELECT type_sports, COUNT(type_sports) AS count 
FROM food_choices
WHERE type_sports = 'None'
GROUP BY type_sports;

--------------------------------------------------------------------------------
/*				        Question 1 - Rationale Comment                        */
--------------------------------------------------------------------------------

/*  
I chose to replace the variations of not playing sports with a uniform 'None', because
the lack of sports does not equate to a null value. The value is not missing, so much as
they simply do not partake in any of the activities. I used the 3 differenct where 
clauses as it encompasses all the different values representing none without grabbing
any extra values. The number of rows in the identification query matches the count from
the validation query.
*/
    
--------------------------------------------------------------------------------
/*		              Question 2 - Indentification query                      */
--------------------------------------------------------------------------------

SELECT weight FROM food_choices
WHERE weight NOT LIKE '1__' 
AND weight NOT LIKE '2__';

--------------------------------------------------------------------------------
/*				          Question 2 - Update query                           */
--------------------------------------------------------------------------------
START TRANSACTION;

UPDATE food_choices
SET weight = 'nan'
WHERE weight LIKE '%not%';

UPDATE food_choices
SET weight = SUBSTRING(weight, 1, length(weight)-4)
WHERE weight LIKE '%lbs';

UPDATE food_choices
SET weight = REPLACE(weight, 'Not sure, ', '');

UPDATE food_choices
SET weight = NULL
WHERE weight = 'nan';

COMMIT;
--------------------------------------------------------------------------------
/*				        Question 2 - Validation query                         */
--------------------------------------------------------------------------------

SELECT weight, COUNT(weight IS NULL) AS count 
FROM food_choices
WHERE weight IS NULL
GROUP BY weight;

--------------------------------------------------------------------------------
/*				        Question 2 - Rationale Comment                        */
--------------------------------------------------------------------------------

/*
The identification query showed 5 values that did not conform to the standard 3 
digit format for weight, considering there are no reported values at below 100.
For this question I cleaned the 2 values that contained a numeric value to just 
have the numeric value, and turned the other 3 into null values. I decided to 
change the absent values to null as this allows for aggregate functions if the 
column was cast to numeric values.
*/
    
--------------------------------------------------------------------------------
/*		              Question 3 - Indentification query                      */
--------------------------------------------------------------------------------

SELECT fav_cuisine FROM food_choices
WHERE fav_cuisine ILIKE '%italian%';

--------------------------------------------------------------------------------
/*				          Question 3 - Update query                           */
--------------------------------------------------------------------------------
START TRANSACTION;

UPDATE food_choices
SET fav_cuisine = REPLACE(fav_cuisine, 'italian', 'Italian');

UPDATE food_choices
SET fav_cuisine = REPLACE(fav_cuisine, ' food', '');

UPDATE food_choices
SET fav_cuisine = REPLACE(fav_cuisine, ' or ', '/');

UPDATE food_choices
SET fav_cuisine = REPLACE(fav_cuisine, ' and ', '/');

COMMIT;

--------------------------------------------------------------------------------
/*				        Question 3 - Validation query                         */
--------------------------------------------------------------------------------

SELECT DISTINCT fav_cuisine
FROM food_choices
WHERE fav_cuisine ILIKE '%Italian%';

--------------------------------------------------------------------------------
/*				        Question 3 - Rationale Comment                        */
--------------------------------------------------------------------------------

/* 
I decided to clean up the group of people that denoted Italian as their favorite food.
I did so by making capitalization uniform, as removed the superfluous addition of
the word 'food'. Doing so helps with grouping the data together as well. Finally I made
it uniform in the format of multiple submitted types, just in the name of making the
queries cleaner.
*/
    
--------------------------------------------------------------------------------
/*		              Question 4 - Indentification query                      */
--------------------------------------------------------------------------------

SELECT income, COUNT(income) AS count 
FROM food_choices
GROUP BY income
ORDER BY count DESC;

--------------------------------------------------------------------------------
/*				          Question 4 - Update query                           */
--------------------------------------------------------------------------------

START TRANSACTION;

UPDATE food_choices
SET income = NULL
WHERE income = 'nan';

UPDATE food_choices
SET income = '0-15000'
WHERE income = '1';

UPDATE food_choices
SET income = '15001-30000'
WHERE income = '2';

UPDATE food_choices
SET income = '30001-50000'
WHERE income = '3';

UPDATE food_choices
SET income = '50001-70000'
WHERE income = '4';

UPDATE food_choices
SET income = '70001-100000'
WHERE income = '5';

UPDATE food_choices
SET income = '100001-nan'
WHERE income = '6';

ALTER TABLE food_choices ADD COLUMN low_range integer;
ALTER TABLE food_choices ADD COLUMN high_range text;

UPDATE food_choices
SET low_range = split_part(income, '-', 1)::integer;

UPDATE food_choices
SET high_range = split_part(income, '-', 2);

UPDATE food_choices
SET high_range = NULL
WHERE high_range = 'nan';

ALTER TABLE food_choices
ALTER COLUMN high_range
SET DATA TYPE integer
USING high_range::integer;

COMMIT;

--------------------------------------------------------------------------------
/*				        Question 4 - Validation query                         */
--------------------------------------------------------------------------------

SELECT DISTINCT income, low_range, high_range
FROM food_choices
ORDER BY low_range;

--------------------------------------------------------------------------------
/*				        Question 4 - Rationale Comment                        */
--------------------------------------------------------------------------------

/*
I decided to alter the dummy coded income into its represented values, and then
splitting the values into the low and high range within the representation. The
columns were cast as numeric so that functions may be performed on them, allowing for
further statistical analysis. It is worth noting that there is no upper limit on 
the value of '6' for income. As there is no reasonable guess on upper limit, I 
decided to denote it as null as there is no appropriate substitution for the value.
*/
    
--------------------------------------------------------------------------------
