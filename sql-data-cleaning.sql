### SQL Data Cleaning

/*
POSITION takes a character and a column, and provides the index where that
character is for each row. The index of the first position is 1 in SQL. If
you come from another programming language, many begin indexing at 0. Here,
you saw that you can pull the index of a comma as POSITION(',' IN city_state).


STRPOS provides the same result as POSITION, but the syntax for achieving those
results is a bit different as shown here: STRPOS(city_state, ',').


Note, both POSITION and STRPOS are case sensitive, so looking for A is
different than looking for a.


Therefore, if you want to pull an index regardless of the case of a letter,
you might want to use LOWER or UPPER to make all of the characters lower or
uppercase.
*/

/*
1. Use the accounts table to create first and last name columns that hold
the first and last names for the primary_poc.
*/

SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;

/*
Now see if you can do the same thing for every rep name in the sales_reps
table. Again provide first and last name columns.
*/
SELECT LEFT(name, STRPOS(name, ' ') -1 ) first_name,
       RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) last_name
FROM sales_reps;

#### CONCAT AND PIPING

/*
Each company in the accounts table wants to create an email address for each
primary_poc. The email address should be the first name of the primary_poc .
last name primary_poc @ company name .com.
*/

WITH t1 AS (
  SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,
  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
  FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com')
FROM t1;

/*
You may have noticed that in the previous solution some of the company names
include spaces, which will certainly not work in an email address. See if you
can create an email address that will work by removing all of the spaces in
the account name, but otherwise your solution should be just as in question 1.
Some helpful documentation is here.
*/

WITH t1 AS (
 SELECT
 LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,
 RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com')
FROM  t1;

/*
We would also like to create an initial password, which they will change after
their first log in. The first password will be the first letter of the
primary_poc's first name (lowercase), then the last letter of their first name
(lowercase), the first letter of their last name (lowercase), the last letter
of their last name (lowercase), the number of letters in their first name,
the number of letters in their last name, and then the name of the company
they are working with, all capitalized with no spaces.
*/

WITH t1 AS (
 SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com'), LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '')
FROM t1;
