### Introduction to Logical Operators

/*
LIKE (This allows you to perform operations similar to using WHERE)
for when you aren't exactly sure.

IN This allows you to perform operations similar to using WHERE,
but for more than one conditions

NOT this is used with IN and LIKE to select all of the rows
NOT LIKE or NOT IN a certain condition

AND & BETWEEN these allow you to combine operations where all combined
conditions must be true

OR this allows you to combine operations where at least one of the
combined conditions must be true.
*/

/*
All the companies whose names start with 'C'.
*/
SELECT name
FROM accounts
WHERE name LIKE 'C%';

/*
All companies that contain the string 'one' somewhere in the name
*/
SELECT name
FROM accounts
WHERE name LIKE '%one%';

/*
All companies that end in an 's'
*/
SELECT name
FROM accounts
WHERE name LIKE '%s';

### IN Operator
/*
The IN operator is useful for working with both numeric and text columns.
This operator allows you to use an =, but for more than one item of that
particular column. We can check one, two or many column values for which
we want to pull data, but all within the same query.
*/

/*
Use the accounts table to find the account name, primary_poc,
and sales_rep_id for Walmart, Target, and Nordstrom.
*/
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE names IN ('Walmart', 'Target', 'Nordstrom');

/*
Use the web_events table to find all information regarding individuals
who were contacted via the channel of organic or adwords.
*/
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

### NOT IN Operator
/*
The NOT operator is an extremely useful operator for working with the
previous two operators we introduced: IN and LIKE. By specifying NOT LIKE
or NOT IN, we can grab all of the rows that do not meet a particular criteria.
*/

/*
Use the accounts table to find the account name, primary poc, and sales rep
id for all stores except Walmart, Target, and Nordstrom.
*/
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN('Walmart', 'Target', 'Nordstrom')

/*
Use the web_events table to find all information regarding individuals
who were contacted via any method except using organic or adwords methods.
*/
SELECT *
FROM web_events
WHERE channel NOT IN('organic', 'adwords');

/*
Accounts table: All the companies whose names do not start with 'C'.
*/
SELECT name
FROM accounts
WHERE name NOT LIKE ('C%');

/*
All companies whose names do not contain the string 'one'
somewhere in the name.
*/
SELECT name
FROM accounts
WHERE name NOT LIKE ('%one%');

/*
Accounts table: all companies whose names do not end with 's'
*/
SELECT name
FROM accounts
WHERE name NOT LIKE ('%s');

### AND OPERATOR
/*The AND operator is used within a WHERE statement to consider more than
one logical clause at a time. Each time you link a new statement with an AND,
you will need to specify the column you are interested in looking at.
You may link as many statements as you would like to consider at the same time.
This operator works with all of the operations we have seen so far including
arithmetic operators (+, *, -, /). LIKE, IN, and NOT logic can also be linked
together using the AND operator.
*/
### BETWEEN Operator
/*
Sometimes we can make a cleaner statement using BETWEEN than we can using AND.
 Particularly this is true when we are using the same column for different
 parts of our AND statement. In the previous video, we probably should have u
 sed BETWEEN.
 */

 /*
 Write a query that returns all the orders where the standard_qty is over 1000,
 the poster_qty is 0, and the gloss_qty is 0.
*/
SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

/*
Using the accounts table, find all the companies whose names do not start
with 'C' and end with 's'.
*/
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND NOT LIKE '%s';

/*
When you use the BETWEEN operator in SQL, do the results include the values
of your endpoints, or not? Figure out the answer to this important question by
writing a query that displays the order date and gloss_qty data for all orders
where gloss_qty is between 24 and 29. Then look at your output to see if the
BETWEEN operator included the begin and end values or not.
*/
SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;
/* this includes 24 and 29 */

/*
Use the web_events table to find all information regarding individuals who
were contacted via the organic or adwords channels, and started their account
at any point in 2016, sorted from newest to oldest.
*/
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01'
AND '2017-01-01'
ORDER BY occurred_at DESC;

### OR Operator
/*
Similar to the AND operator, the OR operator can combine multiple statements.
Each time you link a new statement with an OR, you will need to specify the
column you are interested in looking at. You may link as many statements as
you would like to consider at the same time. This operator works with all of
the operations we have seen so far including arithmetic operators (+, *, -, /),
LIKE, IN, NOT, AND, and BETWEEN logic can all be linked together using the OR op
*/

/*
Find list of orders ids where either gloss_qty or poster_qty is greater
than 4000. Only include the id field in the resulting table.
*/
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

/*
Write a query that returns a list of orders where the standard_qty is zero
and either the gloss_qty or poster_qty is over 1000.
*/
SELECT *
FROM orders
WHERE standard_qty = 0
  AND (gloss_qty > 1000 OR poster_qty > 1000);

/*
Find all the company names that start with a 'C' or 'W', and the primary
contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.
*/
SELECT name
FROM accounts
WHERE (name LIKE ('C%') or name LIKE ('W%'))
      AND ((primary_poc LIKE '%ana%' or primary_poc LIKE '%Ana')
      AND (primary_poc NOT LIKE '%eana%'));
