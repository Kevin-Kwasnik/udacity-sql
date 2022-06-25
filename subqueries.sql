### Subqueries
/*
First your inner query runs, as it will be treated as its own query. Thereafter,
the outer query will run accross the result set created by the inner query.
*/

### Practice
/* Find the number of events that occur for each day for each channel */
SELECT DATE_TRUNC ('day', occurred_at) as day,
       channel,
       Count(*) as event_count
FROM web_events
GROUP BY 1, 2
ORDER BY 3 DESC;

/* Now create a subquery that simply provides all of the data from your
first query*/

SELECT *
FROM
(SELECT DATE_TRUNC ('day', occurred_at) as day,
       channel,
       Count(*) as event_count
FROM web_events
GROUP BY 1, 2
) sub

/* Note in the above:
1. The original query goes in the FROM statement.
2. An * is used in the SELECT statement to pull all of the data from the
  original query.
3. You MUST use an alias for the table you nest within the outer query.
*/

/* Now find the average number of events for each channel. Since you broke
out by day earlier, this is giving you an average per day. */
SELECT channel, AVG(event_count) AS average_events_per_day
FROM (SELECT DATE_TRUNC ('day', occurred_at) AS day,
       channel, Count(*) as event_count
       FROM web_events
       GROUP BY 1, 2) sub
GROUP BY 1
ORDER BY 2 DESC;

### Poor Subquery Formatting

/* Poor Formatting Examples */
SELECT * FROM (SELECT DATE_TRUNC('day',occurred_at) AS day, channel, COUNT(*)
as events FROM web_events GROUP BY 1,2 ORDER BY 3 DESC) sub;

SELECT *
FROM (
SELECT DATE_TRUNC('day',occurred_at) AS day,
channel, COUNT(*) as events
FROM web_events
GROUP BY 1,2
ORDER BY 3 DESC) sub;

### Well Formatted Query Examples
/* Note the difference between the inner and outer queries */
SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
      FROM web_events
      GROUP BY 1,2
      ORDER BY 3 DESC) sub;

SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
      FROM web_events
      GROUP BY 1,2
      ORDER BY 3 DESC) sub
GROUP BY day, channel, events
ORDER BY 2 DESC;

### Different Subquery Locations
/* When the result of a query is only one cell (and thus treated as an
individual value), that query can be placed as an inner query in different
locations that the FROM statement such as WHERE, HAVING, or even SELECT as
nested within a CASE statement.

IN is the only kind of inner logic we will use when the table produces
multiple results*/

/* In the first subquery you wrote, you created a table that you could then
query again in the FROM statement. However, if you are only returning a single
value, you might use that value in a logical statement like WHERE, HAVING,
or even SELECT - the value could be nested within a CASE statement.

Note that you should not include an alias when you write a subquery in a
conditional statement. This is because the subquery is treated as an individual
 value (or set of values in the IN case) rather than as a table.

Also, notice the query here compared a single value. If we returned an entire
column IN would need to be used to perform a logical argument. If we are
returning an entire table, then we must use an ALIAS for the table, and perform
additional logic on the entire table.
*/

### Practice
/*
Use DATE_TRUNC to pull month level information about the first order ever
placed in the orders table.
*/
SELECT MIN(DATE_TRUNC('month', occurred_at)) AS earliest_month
FROM orders;

/*
Use the result of the previous query to find only the orders that took place
in the same month and year as the first order, and then pull the average for
each type of paper qty in this month
*/
SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

SELECT SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
      (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

### More Subquery Practice
/*
Provide the name of the sales_rep in each region with the largest amount of
total_amt_usd sales.
*/
SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1, 2) t1
     GROUP BY 1) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1,2
     ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;

/*
For the region with the largest (sum) of sales total_amt_usd, how many total
(count) orders were placed?
*/
SELECT r.name region, SUM(o.total_amt_usd) total_amt
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
GROUP BY r.name

SELECT MAX(total_amt)
FROM (SELECT r.name region, SUM(o.total_amt_usd) total_amt
      FROM region r
      JOIN sales_reps s
      ON r.id = s.region_id
      JOIN accounts a
      ON a.sales_rep_id = s.id
      JOIN orders o
      ON o.account_id = a.id
      GROUP BY r.name) sub;

SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
    SELECT MAX(total_amt)
    FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
          FROM sales_reps s
          JOIN accounts a
          ON a.sales_rep_id = s.id
          JOIN orders o
          ON o.account_id = a.id
          JOIN region r
          ON r.id = s.region_id
          GROUP BY r.name) sub);
/*
3. How many accounts had more total purchases than the account name which has
bought the most standard_qty paper throughout their lifetime as a customer?
*/

SELECT a.name account, SUM(o.standard_qty) most_std_ppr
FROM orders o
JOIN accounts a
ON a.id = o.account_id
