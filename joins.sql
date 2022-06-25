### JOINS
/*
When using a JOIN, make sure to specify the columns you intend to join:
table.column or table.* for all columns in a given table.

ON holds the two tables such that:
FROM firsttable
JOIN secondtable
ON firsttable.foreignkey = secondtable.primarykey


/*
Try pulling all the data from the accounts table,
and all the data from the orders table.
*/
SELECT orders.*, accounts.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

/*
Try pulling standard_qty, gloss_qty, and poster_qty from the orders table,
and the website and the primary_poc from the accounts table.
*/
SELECT
orders.standard_qty,
orders.gloss_qty,
orders.poster_qty,
accounts.website,
accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

### Primary Keys and Foreign Keys
/*
A primary key exists in every table, and it is a column that has
a unique value for every row.

It is common that a primary key is the first key in every table.

A foreign key is a column in one table that is a primary key in a
different table.

This is important to link two tables:
  ON firsttable.foreignkey = secondtable.primarykey
*/

### Joining Multiple Tables w/ ALIAS
/*
When performing JOINS it's easiest to give you table name an alias.
In the FROM or JOIN lines, the table can be specified by the alias,
so it's less to type.

e.g.:
FROM tablename AS t1
JOIN tablename2 AS t2
*/

### Aliases for Columns in Resulting Table
/*
While aliasing tables is the most common use case. It can also be used
to alias the columns selected to have the resulting table reflect
a more readable name.

e.g.:
SELECT t1.column1 aliasname, t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 AS t2

The alias name fields will be what shows up in the returned table
instead of t1.column1 and t2.column2
*/

### Practice

/*
Provide a table for all web_events associated with account name of Walmart.
There should be three columns. Be sure to include the primary_poc,
time of the event, and the channel for each event. Additionally, you might
choose to add a fourth column to assure only Walmart events were chosen.
*/
SELECT
w.occurred_at,
w.channel,
a.primary_poc,
a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart';

/*
Provide a table that provides the region for each sales_rep along with
their associated accounts. Your final table should include three columns:
the region name, the sales rep name, and the account name. Sort the accounts
alphabetically (A-Z) according to account name.
*/
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;

/*
Provide the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order. Your final
table should have 3 columns: region name, account name, and unit price.
A few accounts have 0 for total, so I divided by (total + 0.01) to assure
not dividing by zero.
*/

SELECT r.name region, a.name account,
o.total_amt_usd/(o.total+0.01) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id;

### LEFT and RIGHT JOIN (LEFT OUTER JOIN | RIGHT OUTER JOIN)
/*
Left and Right JOINS include all the info from an inner join as well
as the relevant side, where the unmatched content does not receive values.
Generally they have the following structure:
  SELECT
  FROM left table
  LEFT JOIN right table
*/

### FULL OUTER JOIN (OUTER JOIN)
/*
The last type of join is a full outer join. This will return the inner join
result set, as well as any unmatched rows from either of the two tables
being joined.

Again this returns rows that do not match one another from the two tables.
The use cases for a full outer join are very rare.
*/

### FINAL TEST
/*
If you have two or more columns in your SELECT that have the same name
after the table name such as accounts.name and sales_reps.name you will need
to alias them. Otherwise it will only show one of the columns. You can alias
them like accounts.name AS AcountName, sales_rep.name AS SalesRepName.
*/

/*
1. Provide a table that provides the region for each sales_rep along with their
associated accounts. This time only for the Midwest region. Your final table
should include three columns: the region name, the sales rep name, and the
account name. Sort the accounts alphabetically (A-Z) according to account name.
*/
SELECT
r.name region,
s.name sales_rep,
a.name account
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest'
ORDER BY a.name;

/*
2. Provide a table that provides the region for each sales_rep along with their
associated accounts. This time only for accounts where the sales rep has a
first name starting with S and in the Midwest region. Your final table should
include three columns: the region name, the sales rep name, and the
account name. Sort the accounts alphabetically (A-Z) according to account name.
*/
SELECT r.name region,
s.name sales_rep,
a.name account
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest'
  AND s.name LIKE 'S%'
ORDER BY a.name;

/*
3. Provide a table that provides the region for each sales_rep along with
their associated accounts. This time only for accounts where the sales rep
has a last name starting with K and in the Midwest region. Your final table
should include three columns: the region name, the sales rep name, and the
account name. Sort the accounts alphabetically (A-Z) according to account name.
*/
SELECT r.name region,
s.name sales_rep,
a.name account
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest'
  AND s.name LIKE '%K%'
  AND s.name NOT LIKE 'K%'
ORDER BY a.name;

/* '% K%' is a more graceful way of finding last name */

/*
4. Provide the name for each region for every order, as well as the
account name and the unit price they paid (total_amt_usd/total) for the order.
However, you should only provide the results if the standard order quantity
exceeds 100. Your final table should have 3 columns: region name, account name,
and unit price. In order to avoid a division by zero error, adding .01 to the
denominator here is helpful total_amt_usd/(total+0.01).
*/
SELECT
r.name region,
a.name account,
o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100;

/*
5. Provide the name for each region for every order, as well as the account
name and the unit price they paid (total_amt_usd/total) for the order.
However, you should only provide the results if the standard order quantity
exceeds 100 and the poster order quantity exceeds 50. Your final table should
have 3 columns: region name, account name, and unit price. Sort for the
smallest unit price first. In order to avoid a division by zero error, adding
.01 to the denominator here is helpful (total_amt_usd/(total+0.01).
*/
SELECT
r.name region,
a.name account,
o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100
AND o.poster_qty > 50
ORDER BY o.total_amt_usd/(o.total + 0.01);
/*
6. Provide the name for each region for every order, as well as the account
name and the unit price they paid (total_amt_usd/total) for the order.
However, you should only provide the results if the standard order quantity
exceeds 100 and the poster order quantity exceeds 50. Your final table should
have 3 columns: region name, account name, and unit price. Sort for the largest
unit price first. In order to avoid a division by zero error, adding .01 to the
denominator here is helpful (total_amt_usd/(total+0.01).
*/
SELECT
r.name region,
a.name account,
o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100
AND o.poster_qty > 50
ORDER BY o.total_amt_usd/(o.total + 0.01) DESC;

/*
7.What are the different channels used by account id 1001? Your final table
should have only 2 columns: account name and the different channels. You can
try SELECT DISTINCT to narrow down the results to only the unique values.
*/
SELECT DISTINCT
a.name account,
w.channel channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.id = '1001';

/*
8. Find all the orders that occurred in 2015. Your final table should have
4 columns: occurred_at, account name, order total, and order total_amt_usd.
*/
SELECT
o.occurred_at time_stamp,
a.name account,
o.total total,
o.total_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
WHERE o.occurred_at BETWEEN
  '2015-01-01%' AND '2016-01-01%';
