/*
    Name: Chase Gertken
    DTSC660: Data and Database Managment with SQL
    Assignment 5- PART 2
*/

--------------------------------------------------------------------------------
/*				                 Query 8            		  		          */
--------------------------------------------------------------------------------

SELECT course_id FROM course
	EXCEPT
SELECT course_id FROM prereq
ORDER BY course_id;

--------------------------------------------------------------------------------
/*				                  Query 9           		  		          */
--------------------------------------------------------------------------------

SELECT dept_name FROM department
	INTERSECT
SELECT dept_name FROM instructor
ORDER BY dept_name;

--------------------------------------------------------------------------------
/*				                  Query 10           		  		          */
--------------------------------------------------------------------------------

SELECT dept_name FROM department
WHERE budget < 50000
	UNION
SELECT dept_name FROM instructor
GROUP BY dept_name
HAVING MAX(salary) > 100000
	UNION
SELECT dept_name FROM student
GROUP BY dept_name
HAVING MAX(tot_cred) = (SELECT MAX(tot_cred) FROM student)
ORDER BY dept_name;

--------------------------------------------------------------------------------
/*				                  Query 11           		  		          */
--------------------------------------------------------------------------------

SELECT A.course_id AS course_id, A.title AS course_name,
	prereq_id, B.title AS prereq_name 
FROM course AS A
FULL JOIN prereq USING (course_id)
JOIN course AS B 
ON B.course_id = prereq_id
ORDER BY course_id;

--------------------------------------------------------------------------------
/*				                  Query 12           		  		          */
--------------------------------------------------------------------------------

SELECT id
FROM student
LEFT OUTER JOIN course USING (dept_name)
GROUP BY id 
HAVING COUNT(DISTINCT title) = 0;

