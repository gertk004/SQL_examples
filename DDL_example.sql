--------------------------------------------------------------------------------
/*				                 Create Database         	 		          */
--------------------------------------------------------------------------------

CREATE DATABASE banking;

--------------------------------------------------------------------------------
/*				             Connect to Database        		  	          */
--------------------------------------------------------------------------------

-- **DO NOT DELETE OR ALTER THE CODE BELOW!**
-- **THIS IS NEEDED FOR CODEGRADE TO RUN YOUR ASSIGNMENT**

\connect banking;

--------------------------------------------------------------------------------
/*				                 Banking DDL           		  		          */
--------------------------------------------------------------------------------

CREATE TABLE branch(
	branch_name varchar(40) PRIMARY KEY,
	branch_city varchar(40) CHECK (branch_city IN ('Brooklyn', 'Bronx', 'Manhattan', 'Yonkers')),
	assets money CHECK (assets >= '$0.00') NOT NULL
);

CREATE TABLE customer(
	cust_ID varchar(40) PRIMARY KEY,
	customer_name varchar(40) NOT NULL,
	customer_street varchar(40) NOT NULL,
	customer_city varchar(40)
);

CREATE TABLE loan(
	loan_number varchar(40) PRIMARY KEY,
	branch_name varchar(40) REFERENCES branch ON UPDATE CASCADE ON DELETE CASCADE,
	amount money NOT NULL CHECK (amount >= '$0.00') DEFAULT '$0.00'
);

CREATE TABLE borrower(
	cust_ID varchar(40) REFERENCES customer ON UPDATE CASCADE ON DELETE CASCADE,
	loan_number varchar(40) REFERENCES loan ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE account (
	account_number varchar(40) PRIMARY KEY,
	branch_name varchar(40) REFERENCES branch ON UPDATE CASCADE ON DELETE CASCADE,
	balance money NOT NULL DEFAULT '$0.00'
);

CREATE TABLE depositor (
	cust_ID varchar(40) REFERENCES customer ON UPDATE CASCADE ON DELETE CASCADE,
	account_number varchar(40) REFERENCES account ON UPDATE CASCADE ON DELETE CASCADE
);
