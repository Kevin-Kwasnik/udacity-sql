### LIMITS
/*
Try using LIMIT yourself below by writing a query that displays all the data
in the occurred_at, account_id, and channel columns of the web_events table,
and limits the output to only the first 15 rows.
*/
SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;

### ORDER BY
/*
Order by statements appear before LIMIT and after FROM.
If you want the column to go the other way, you can use 'DESC'
after the column to flip the ordering.

Write a query to return the 10 earliest orders in the orders table.
Include the id, occurred_at, and total_amt_usd.
*/
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

/*
Write a query to return the top 5 orders in terms of largest total_amt_usd.
Include the id, account_id, and total_amt_usd.
*/
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

/*
Write a query to return the lowest 20 orders in terms of smallest total_amt_usd.
Include the id, account_id, and total_amt_usd.
*/
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;

### ORDER BY Multiple Columns
/*
Write a query that displays the order ID, account ID, and total dollar amount
for all the orders, sorted first by the account ID (in ascending order),
and then by the total dollar amount (in descending order).
*/
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

/*
Now write a query that again displays order ID, account ID, and
total dollar amount for each order, but this time sorted
first by total dollar amount (in descending order), and then by account ID
(in ascending order).
*/
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;

/*
What is the difference between the above?

ANSWER: Since there are no duplicate total amount, the id becomes irrelevant.
Everything is ordered according to total amount, exclusively. On the other
hand, there are duplicate ids, so then all the ids are ordered, then the amount.
*/

### WHERE
/*
WHERE queries are used after FROM and before ORDER BY or LIMIT

Using the WHERE statement, we can display subsets of tables based on
conditions that must be met. You can also think of the WHERE command
as filtering the data.

Use SINGLE QUOTES when querying for a non-numeric value.
*/
/*
Pull the first 5 rows and all columns from the orders table that
have a dollar amount of gloss_amt_usd greater than or equal to 1000.
*/
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

/*
Pulls the first 10 rows and all columns from the orders table that
have a total_amt_usd less than 500.
*/
SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

/*
Filter the accounts table to include the company name, website,
and the primary point of contact (primary_poc) just for the Exxon Mobil
company in the accounts table.
*/
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

### DERIVED COLUMNS

/*
Creating a new column that is a combination of existing columns is known as
a derived column (or "calculated" or "computed" column). Usually you want to
give a name, or "alias," to your new column using the AS keyword.

This derived column, and its alias, are generally only temporary,
existing just for the duration of your query. The next time you run a query
and access this table, the new column will not be there.
*/

/*
Create a column that divides the standard_amt_usd by the standard_qty to
find the unit price for standard paper for each order. Limit the results to
the first 10 orders, and include the id and account_id fields.
*/

SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price_each
FROM orders
LIMIT 10;

/*
Write a query that finds the percentage of revenue that comes from poster paper
for each order. You will need to use only the columns that end with _usd.
(Try to do this without using the total column.) Display the id and
account_id fields also. NOTE - you will receive an error with the correct
solution to this question. This occurs because at least one of the values in
the data creates a division by zero in your formula. You will learn later in
the course how to fully handle this issue. For now, you can just limit your
calculations to the first 10 orders, as we did in question #1, and you'll
avoid that set of data that causes the problem.
*/
SELECT id, account_id, (poster_amt_usd/(poster_amt_usd+gloss_amt_usd+
  standard_amt_usd)) AS perc_rev_post
FROM orders
LIMIT 10;
