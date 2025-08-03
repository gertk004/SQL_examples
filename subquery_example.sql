--------------------------------------------------------------------------------
/*				                 Query 1            		  		          */
--------------------------------------------------------------------------------

SELECT cust_ID, account_number, loan_number 
FROM borrower
JOIN depositor USING (cust_ID)
ORDER BY cust_ID;

--------------------------------------------------------------------------------
/*				                  Query 2           		  		          */
--------------------------------------------------------------------------------

SELECT cust_ID, customer_city, branch_name, branch_city, account_number
FROM customer
JOIN depositor USING (cust_ID)
JOIN account USING (account_number)
JOIN branch USING (branch_name)
WHERE customer_city = branch_city;

--------------------------------------------------------------------------------
/*				                  Query 3           		  		          */
--------------------------------------------------------------------------------

SELECT cust_ID, customer_name
FROM customer
WHERE cust_ID IN (
	SELECT cust_ID FROM borrower
		EXCEPT
	SELECT cust_ID FROM depositor
)
ORDER BY cust_ID;
   
--------------------------------------------------------------------------------
/*				                  Query 4           		  		          */
--------------------------------------------------------------------------------

SELECT branch_name
FROM branch
JOIN account USING (branch_name)
JOIN depositor USING (account_number)
JOIN customer USING (cust_ID)
WHERE customer_city = 'Harrison' 
	AND cust_ID IN (SELECT cust_ID FROM depositor)
ORDER BY branch_name;



--------------------------------------------------------------------------------
/*				                  Query 5           		  		          */
--------------------------------------------------------------------------------

SELECT cust_ID, customer_name 
FROM customer
WHERE customer_city = (SELECT customer_city FROM customer
						WHERE cust_ID = '12345')
AND customer_street = (SELECT customer_street FROM customer
						WHERE cust_ID = '12345')
	EXCEPT
SELECT cust_ID, customer_name 
FROM customer 
WHERE cust_ID = '12345'
ORDER BY cust_ID;

--------------------------------------------------------------------------------
/*				                  Query 6           		  		          */
--------------------------------------------------------------------------------

SELECT cust_ID, customer_name 
FROM customer
JOIN depositor USING (cust_ID)
JOIN account USING (account_number)
JOIN branch USING (branch_name)
WHERE branch_city = 'Brooklyn'
GROUP BY cust_ID
HAVING COUNT(DISTINCT branch_name) = 
	(SELECT COUNT(DISTINCT branch_name)
	FROM branch
	WHERE branch_city = 'Brooklyn');

--------------------------------------------------------------------------------
/*				                  Query 7           		  		          */
--------------------------------------------------------------------------------

SELECT loan_number, customer_name, branch_name
FROM loan
JOIN borrower USING (loan_number)
JOIN customer USING (cust_ID)
WHERE branch_name = 'Yonkahs Bankahs'
	AND
CAST(amount AS numeric) > 
	(SELECT AVG(CAST(amount AS numeric)) FROM loan);


  
