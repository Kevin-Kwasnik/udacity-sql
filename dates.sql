### GROUP BY DAY
/*
Here we saw that dates are stored in year, month, day, hour, minute, second,
which helps us in truncating. In the next concept, you will see a number of
functions we can use in SQL to take advantage of this functionality.
*/

### DATE_TRUNC & DATE_PART
/*
The first function you are introduced to in working with dates is DATE_TRUNC.

DATE_TRUNC allows you to truncate your date to a particular part of your
date-time column. Common trunctions are day, month, and year. Here is a great
blog post by Mode Analytics on the power of this function.

DATE_PART can be useful for pulling a specific portion of a date, but notice
pulling month or day of the week (dow) means that you are no longer keeping
the years in order. Rather you are grouping for certain components regardless
of which year they belonged in.

For additional functions you can use with dates, check out the documentation
here, but the DATE_TRUNC and DATE_PART functions definitely give you
a great start!

You can reference the columns in your select statement in GROUP BY and
ORDER BY clauses with numbers that follow the order they appear in the select
statement. For example:

SELECT standard_qty, COUNT(*)

FROM orders

GROUP BY 1 (this 1 refers to standard_qty since it is the first of the columns
included in the select statement)

ORDER BY 1 (this 1 refers to standard_qty since it is the first of the columns
included in the select statement)

dow stands for day of week, and returns a value of 0-6, where 0 is Sunday
and 6 is Saturday
*/

### DATES Quiz 1
/*
1.Find the sales in terms of total dollars for all orders in each year, ordered
from greatest to least. Do you notice any trends in the yearly sales totals?
*/
SELECT DATE_TRUNC('year', occurred_at) AS year,
       SUM(total_amt_usd) as total_spent
FROM orders
GROUP BY DATE_TRUNC('year', occurred_at)
ORDER BY SUM(total_amt_usd) DESC;

/*
2. Which month did Parch & Posey have the greatest sales in terms of total
dollars? Are all months evenly represented by the dataset?
*/
SELECT DATE_PART('month', occurred_at) AS month,
       SUM(total_amt_usd) as total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY DATE_PART('month', occurred_at) /*GROUP BY 1*/
ORDER BY SUM(total_amt_usd) DESC; /*ORDER BY 2 DESC*/

/*
3. Which year did Parch & Posey have the greatest sales in terms of total
number of orders? Are all years evenly represented by the dataset?
*/
SELECT DATE_PART('year', occurred_at) year,
       COUNT(*) total_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

/*
4. Which month did Parch & Posey have the greatest sales in terms of total
number of orders? Are all months evenly represented by the dataset?
*/
SELECT DATE_PART('month', occurred_at) AS month,
       COUNT(*) monthly_orders
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

/*
5.In which month of which year did Walmart spend the most on gloss paper in
terms of dollars?
*/
SELECT DATE_PART('month', o.occurred_at) AS month,
       DATE_PART('year', o.occurred_at) AS year,
       SUM(gloss_amt_usd) spent_gloss
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1;
