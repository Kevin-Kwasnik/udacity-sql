### Nulls
/*
Null means no data, which is different
than a zero.
*/

/*
We can identify cells where there is no data, using a WHERE clause

We use IS NULL and not = NULL because NULL is not a value but a
property of the data.
*/

SELECT *
  FROM accounts
  WHERE primary_poc IS NULL

### COUNT
/*
Count returns a count from all non-null cells.
Count can be used on non-numerical data.
*/

SELECT COUNT(*) AS order_count
  FROM orders
  WHERE occurred_at >= '2016-12-01'
  AND occurred_at < '2017-01-01'

/*
COUNT(*) returns all the cells
COUNT(primary_poc) returns all the non-NULL cells
*/

### SUM
/*
Works similarly to COUNT, but you need to specify specific columns.
*/
SELECT SUM(standard_qty) AS standard
  FROM orders

/*
QUIZ:

1. Find the total amount of poster_qty paper ordered in the orders table.
*/
SELECT SUM(poster_qty) AS total_poster_sales
  FROM orders;

/*
2. Find the total amount of standard_qty paper ordered in the orders table.
*/
SELECT SUM(standard_qty) AS total_standard_sales
  FROM orders;

/*
3.Find the total dollar amount of sales using the total_amt_usd
in the orders table.
*/
SELECT SUM(total_amt_usd) AS total_dollar_sales
  FROM orders;

/*
4. Find the total amount spent on standard_amt_usd and gloss_amt_usd paper
for each order in the orders table. This should give a dollar amount
for each order in the table.
*/
SELECT standard_qty) gloss_amt_usd AS total_standard_gloss
FROM orders;

/*
Find the standard_amt_usd per unit of standard_qty paper. Your solution
should use both an aggregation and a mathematical operator.
*/
SELECT SUM(standard_amt_usd)/SUM(standard_qty)
  AS standard_price_per_unit
  FROM orders;

### MIN and MAX
/*
Notice that MIN and MAX are aggregators that again ignore NULL values.

Functionally, MIN and MAX are similar to COUNT in that they can be used on
non-numerical columns. Depending on the column type, MIN will return the
lowest number, earliest date, or non-numerical value as early in the alphabet
as possible. As you might suspect, MAX does the opposite—it returns the
highest number, the latest date, or the non-numerical value closest
alphabetically to “Z.”
*/

### AVG
/*
Similar to other software AVG returns the mean of the data - that is the sum
of all of the values in the column divided by the number of values in a column.
This aggregate function again ignores the NULL values in both the numerator and
the denominator.

If you want to count NULLs as zero, you will need to use SUM and COUNT.
However, this is probably not a good idea if the NULL values truly just
represent unknown values for a cell.

MEDIAN - Expert Tip
One quick note that a median might be a more appropriate measure of center
for this data, but finding the median happens to be a pretty difficult thing
to get using SQL alone — so difficult that finding a median is occasionally
asked as an interview question.
*/

### MIN, MAX, AVG QUIZ
/*
1. When was the earliest order ever placed? You only need to return the date.
*/
SELECT MIN(occurred_at) AS earliest_order
  FROM orders;

/*
2. Try performing the same query as in question 1 without using an
aggregation function.
*/
SELECT occurred_at
FROM orders
ORDER BY occurred_at;

/*
3. When did the most recent (latest) web_event occur?
*/
SELECT MAX(occurred_at) AS most_recent_web_event
  FROM web_events;

/*
4. Try to perform the result of the previous query without using an
aggregation function.
*/
SELECT occurred_at
  FROM web_events
  ORDER BY occurred_at DESC;

/*
5. Find the mean (AVERAGE) amount spent per order on each paper type,
as well as the mean amount of each paper type purchased per order.
Your final answer should have 6 values - one for each paper type for
the average number of sales, as well as the average amount.
*/
SELECT
AVG(standard_qty) AS average_standard_order,
AVG(standard_amt_usd) AS average_spent_standard,
AVG(gloss_qty) AS average_gloss_order,
AVG(gloss_amt_usd) AS average_spent_gloss,
AVG(poster_qty) AS average_poster_order,
AVG(poster_amt_usd) AS average_spent_poster
FROM orders;

/*
Via the video, you might be interested in how to calculate the MEDIAN.
Though this is more advanced than what we have covered so far try finding -
what is the MEDIAN total_usd spent on all orders?
*/
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2);
/*
Since there are 6912 orders - we want the average of the 3457 and 3456 order
amounts when ordered. This is the average of 2483.16 and 2482.55. This gives
the median of 2482.855. This obviously isn't an ideal way to compute. If we
obtain new orders, we would have to change the limit. SQL didn't even calculate
the median for us. The above used a SUBQUERY, but you could use any method to
find the two necessary values, and then you just need the average of them.
*/

### GROUP BY
/*
The key takeaways here:

GROUP BY can be used to aggregate data within subsets of the data.
For example, grouping for different accounts, different regions, or different
sales representatives.

-Any column in the SELECT statement that is not within an aggregator must be
in the GROUP BY clause.

-The GROUP BY always goes between WHERE and ORDER BY.

-ORDER BY works like SORT in spreadsheet software.

GROUP BY - Expert Tip
Before we dive deeper into aggregations using GROUP BY statements,
it is worth noting that SQL evaluates the aggregations before the LIMIT clause.
If you don’t group by any columns, you’ll get a 1-row result—no problem there.
If you group by a column with enough unique values that it exceeds the LIMIT
number, the aggregates will be calculated, and then some rows will simply be
 omitted from the results.

This is actually a nice way to do things because you know you’re going to get
the correct aggregates. If SQL cuts the table down to 100 rows, then performed
the aggregations, your results would be substantially different. The above
query’s results exceed 100 rows, so it’s a perfect example. In the next
concept, use the SQL environment to try removing the LIMIT and running it again
to see what changes.
*/

SELECT account_id,
       SUM(standard_qty) AS standard_sum,
       SUM(gloss_qty) AS gloss_sum,
       SUM(poster_qty) AS poster_sum
  FROM orders
  GROUP BY account_id
  ORDER BY account_id;

/*
Whenever there's a filed in the Select statment that is not being aggregated,
the query expects the field to be in the GROUP BY statement. ******* */

### GROUP BY QUIZ
/*
1. Which account (by name) placed the earliest order? Your solution should
have the account name and the date of the order.
*/

SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1;

/*
2. Find the total sales in usd for each account. You should include two columns
- the total sales for each company's orders in usd and the company name.
*/
SELECT a.name, SUM(total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name;

/*
3. Via what channel did the most recent (latest) web_event occur, which account
was associated with this web_event? Your query should return only three values
- the date, channel, and account name.
*/
SELECT a.name account_name,
       w.channel web_channel,
       w.occurred_at latest_web_event
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;

/*
4. Find the total number of times each type of channel from the web_events was
used. Your final table should have two columns - the channel and the number
of times the channel was used.
*/
SELECT w.channel,
       COUNT(w.channel)
FROM web_events w
GROUP BY w.channel;

/*
5. Who was the primary contact associated with the earliest web_event?
*/
SELECT a.primary_poc,
       w.occurred_at
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

/*
6. What was the smallest order placed by each account in terms of total usd.
Provide only two columns - the account name and the total usd. Order from
smallest dollar amounts to largest.
*/
SELECT a.name account,
       MIN(o.total_amt_usd) smallest_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order;

/*
7. Find the number of sales reps in each region. Your final table should have
two columns - the region and the number of sales_reps. Order from fewest
reps to most reps.
*/
SELECT r.name region,
       COUNT(s.name) number_of_reps
FROM sales_reps s
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
ORDER BY number_of_reps;

### GROUP BY (Part II)
/*
You can GROUP BY multiple columns at once, as we showed here. This is often
useful to aggregate across a number of different segments.

The order of columns listed in the ORDER BY clause does make a difference.
You are ordering the columns from left to right.
GROUP BY - Expert Tips
The order of column names in your GROUP BY clause doesn’t matter—the results
will be the same regardless. If we run the same query and reverse the order
in the GROUP BY clause, you can see we get the same results.


As with ORDER BY, you can substitute numbers for column names in the GROUP BY
clause. It’s generally recommended to do this only when you’re grouping many
columns, or if something else is causing the text in the GROUP BY clause to be
excessively long.


A reminder here that any column that is not within an aggregation must show up
in your GROUP BY statement. If you forget, you will likely get an error.
However, in the off chance that your query does work, you might not like the
results!
*/

### GROUP BY (PART II QUIZ)
/*
1.For each account, determine the average amount of each type of paper they
purchased across their orders. Your result should have four columns - one for
the account name and one for the average quantity purchased for each of the
paper types for each account.
*/
SELECT a.name account,
       AVG(o.standard_qty) average_standard_order,
       AVG(o.gloss_qty) average_gloss_order,
       AVG(o.poster_qty) average_poster_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY account
ORDER BY account;

/*
2. For each account, determine the average amount spent per order on each
paper type. Your result should have four columns - one for the account name
and one for the average amount spent on each paper type.
*/
SELECT a.name account,
AVG(o.standard_amt_usd) average_spent_standard,
AVG(o.gloss_amt_usd) average_spent_gloss,
AVG(o.poster_amt_usd) average_spent_poster
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY account
ORDER BY account;

/*
3. Determine the number of times a particular channel was used in the web_events
table for each sales rep. Your final table should have three columns - the
name of the sales rep, the channel, and the number of occurrences. Order your
table with the highest number of occurrences first.
*/
SELECT s.name rep,
       w.channel channel,
       COUNT(w.channel) num_events
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN web_events w
ON a.id = w.account_id
GROUP BY rep, channel
ORDER BY num_events DESC;

/*
4. Determine the number of times a particular channel was used in the
web_events table for each region. Your final table should have three columns -
the region name, the channel, and the number of occurrences. Order your table
with the highest number of occurrences first.
*/
SELECT r.name region,
       w.channel channel,
       COUNT(w.channel) number_of_occurances
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN web_events w
ON a.id = w.account_id
GROUP BY region, channel
ORDER BY number_of_occurances DESC;

### DISTINCT
/*
DISTINCT is always used in SELECT statements, and it provides the unique rows
for all columns written in the SELECT statement. Therefore, you only use
DISTINCT once in any particular SELECT statement.

You could write:

SELECT DISTINCT column1, column2, column3
FROM table1;

which would return the unique (or DISTINCT) rows across all three columns.

You would not write:

SELECT DISTINCT column1, DISTINCT column2, DISTINCT column3
FROM table1;

You can think of DISTINCT the same way you might think of
the statement "unique".

DISTINCT - Expert Tip
It’s worth noting that using DISTINCT, particularly in aggregations, can slow
your queries down quite a bit.
*/
/*1*/
SELECT DISTINCT id, name
FROM accounts

SELECT a.id as "account id", r.id as "region id",
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;

/*2*/
SELECT DISTINCT id, name
FROM sales_reps


SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;

### HAVING
/*
HAVING - Expert Tip
HAVING is the “clean” way to filter a query that has been aggregated, but
this is also commonly done using a subquery. Essentially, any time you want
to perform a WHERE on an element of your query that was created by an
aggregate, you need to use HAVING instead.
*/
/*
1. How many of the sales reps have more than 5 accounts that they manage?
*/
SELECT s.name rep,
	   COUNT(a.name) num_accounts
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
GROUP BY s.name
HAVING COUNT(a.name) > 5
ORDER BY num_accounts DESC;

/*
2. How many accounts have more than 20 orders?
*/
SELECT a.name account,
       COUNT(o.total) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY account
HAVING COUNT(o.total) > 20
ORDER BY COUNT(o.total) DESC;

/*
3. Which account has the most orders?
*/
SELECT a.name account,
       MAX(o.total) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY account
LIMIT 1;

/*
4. Which accounts spent more than 30,000 usd total across all orders?
*/
SELECT a.name account,
       o.total_amt_usd total_amt_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
WHERE o.total_amt_usd > 30000
ORDER BY o.total_amt_usd;

/*
5. Which accounts spent less than 1,000 usd total across all orders?
*/
SELECT a.name account,
       o.total_amt_usd total_amt_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
WHERE o.total_amt_usd < 1000
ORDER BY o.total_amt_usd;

/*
6. Which account has spent the most with us?
*/
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1;

/*
7. Which account has spent the least with us
*/
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1;

/*
8. Which accounts used facebook as a channel to contact customers more than
6 times?
*/
SELECT a.id, a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
GROUP BY a.id, a.name, w.channel
HAVING w.channel = 'facebook' AND COUNT(*) > 6
ORDER BY COUNT(*) DESC;

/*
9. Which accounts used facebook most as a channel
*/
SELECT a.id, a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
GROUP BY a.id, a.name, w.channel
HAVING w.channel = 'facebook'
ORDER BY COUNT(*) DESC
LIMIT 1;

/*
10. Which account used facebook most as a channel?
*/
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;
