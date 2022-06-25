### CASES
/*
IF, THEN logic = WHEN, THEN
ELSE can catch values that fall outside a WHEN, THEN statement
WHEN = the logical contition
THEN = the desired output
END AS = the derived column

CASE - Expert Tip
The CASE statement always goes in the SELECT clause.

CASE must include the following components: WHEN, THEN, and END. ELSE is an
optional component to catch cases that didn’t meet any of the other previous
\CASE conditions.

You can make any conditional statement using any conditional operator
(like WHERE) between WHEN and THEN. This includes stringing together multiple
conditional statements using AND and OR.

You can include multiple WHEN statements, as well as an ELSE statement again,
to deal with any unaddressed conditions.
*/

/* The easiest way to count all the menbers of a group is to create a column
that groups in the way you want to, then create a coulumn that counts the
members of that group. e.g.:
*/
SELECT CASE WHEN total > 500 THEN 'Over 500'
            ELSE '500 or under' END AS total_group,
      COUNT(*) AS order_count
FROM orders
GROUP BY 1;

### CASE QUIZ
/*
1. Write a query to display for each order, the account ID, total amount of
the order, and the level of the order - ‘Large’ or ’Small’ - depending on if
the order is $3000 or more, or smaller than $3000.
*/
SELECT account_id, total,
       CASE WHEN total > 3000 THEN 'Large'
            ELSE 'Small' END AS order_size
FROM orders
GROUP BY 1, 2
ORDER BY 2 DESC;

/*
2. Write a query to display the number of orders in each of three categories,
based on the total number of items in each order. The three categories are:
'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
*/
SELECT total,
       CASE WHEN total > 2000 THEN 'At Least 2000'
            WHEN total >= 1000 AND total <= 2000 THEN 'Between 1000 and 2000'
            WHEN total < 1000 THEN 'Less than 1000'
            END AS order_size
FROM orders
GROUP BY 1
ORDER BY 1 DESC;

/*
3. We would like to understand 3 different levels of customers based on the
amount associated with their purchases. The top level includes anyone with a
Lifetime Value (total sales of all orders) greater than 200,000 usd. The
second level is between 200,000 and 100,000 usd. The lowest level is anyone
under 100,000 usd. Provide a table that includes the level associated with
each account. You should provide the account name, the total sales of all
orders for the customer, and the level. Order with the top spending customers
listed first.
*/
SELECT a.name Account,
       SUM(o.total_amt_usd) Lifetime_Value,
CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'Top'
     WHEN SUM(o.total_amt_usd) >= 100000
          AND SUM(o.total_amt_usd) <= 200000 THEN 'Mid'
     ELSE 'Bottom' END AS Spending_Tier
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;

/*
4. We would now like to perform a similar calculation to the first, but we
want to obtain the total amount spent by customers only in 2016 and 2017.
Keep the same levels as in the previous question. Order with the top spending
customers listed first.
*/
SELECT a.name Account,
       SUM(o.total_amt_usd) Lifetime_Value,
CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'Top'
     WHEN SUM(o.total_amt_usd) >= 100000
          AND SUM(o.total_amt_usd) <= 200000 THEN 'Mid'
     ELSE 'Bottom' END AS Spending_Tier
FROM accounts a
JOIN orders o
ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

/*
5. We would like to identify top performing sales reps, which are sales reps
associated with more than 200 orders. Create a table with the sales rep name,
the total number of orders, and a column with top or not depending on if they
have more than 200 orders. Place the top sales people first in your final table.
*/
SELECT s.name rep,
       COUNT(*) num_orders,
       CASE WHEN COUNT(*) > 200 THEN 'top'
            ELSE 'bottom' END AS performance_tier
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;

/*
6.The previous didn't account for the middle, nor the dollar amount associated
\with the sales. Management decides they want to see these characteristics
represented as well. We would like to identify top performing sales reps,
which are sales reps associated with more than 200 orders or more than 750000
in total sales. The middle group has any rep with more than 150 orders or
500000 in sales. Create a table with the sales rep name, the total number of
orders, total sales across all orders, and a column with top, middle, or low
depending on this criteria. Place the top sales people based on dollar amount
of sales first in your final table.
*/
SELECT s.name rep,
       COUNT(*) num_orders,
       SUM(total_amt_usd),
       CASE WHEN COUNT(*) > 200 OR SUM(total_amt_usd) > 750000 THEN 'TOP'
            WHEN COUNT(*) > 150 OR SUM(total_amt_usd) > 500000 THEN 'MID'
            ELSE 'LOW' END AS performance_tier
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC;
