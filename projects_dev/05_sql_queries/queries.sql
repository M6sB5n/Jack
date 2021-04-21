    -- Throughout the week write SQL queries to answer the questions below

    --     Get the names and the quantities in stock for each product.
SELECT p.product_name, p.units_in_stock FROM products AS p WHERE p.units_in_stock > 0 ORDER BY p.units_in_stock DESC  LIMIT 5;

"         product_name         | units_in_stock 
------------------------------+----------------
 Rhönbräu Klosterbier         |            125
 Boston Crab Meat             |            123
 Grandma's Boysenberry Spread |            120
 Pâté chinois                 |            115
 Sirop d'érable               |            113
"
   --     Get a list of current products (Product ID and name).
SELECT product_id, product_name FROM products ORDER BY product_name ASC LIMIT 5;

" product_id |   product_name    
------------+-------------------
         17 | Alice Mutton
          3 | Aniseed Syrup
         40 | Boston Crab Meat
         60 | Camembert Pierrot
         18 | Carnarvon Tigers
"



--     Get a list of the most and least expensive products (name and unit price).
SELECT product_id, product_name, quantity_per_unit, unit_price FROM products AS p ORDER BY p.unit_price DESC LIMIT 5;

" product_id |      product_name       |  quantity_per_unit   | unit_price 
------------+-------------------------+----------------------+------------
         38 | Côte de Blaye           | 12 - 75 cl bottles   |      263.5
         29 | Thüringer Rostbratwurst | 50 bags x 30 sausgs. |     123.79
          9 | Mishi Kobe Niku         | 18 - 500 g pkgs.     |         97
         20 | Sir Rodney's Marmalade  | 30 gift boxes        |         81
         18 | Carnarvon Tigers        | 16 kg pkg.           |       62   
"
	-- not satisfactory... price per item would be more interesting (holds for everything besides the 30 gift boxes)
-- SELECT product_name, quantity_per_unit, unit_price, unit_price / CASE WHEN (SUBSTRING(quantity_per_unit,'([0-9]+\W+[^gkcm])') IS NULL) THEN '1' ELSE (CAST (SUBSTRING(quantity_per_unit,'([0-9]+)') AS INTEGER)) END AS price_per_item FROM products ORDER BY price_per_item DESC LIMIT 5;

    (SELECT product_name, quantity_per_unit, unit_price, unit_price / 
        CASE 
            WHEN (SUBSTRING(quantity_per_unit,'([0-9]+W+[^gkcm])') IS NULL) 
                THEN '1' 
            ELSE (CAST (SUBSTRING(quantity_per_unit,'([0-9]+)') AS INTEGER)) 
        END AS price_per_item 
    FROM products 
    ORDER BY price_per_item ASC LIMIT 5) 
UNION ALL 
    (SELECT product_name, quantity_per_unit, unit_price, unit_price / 
        CASE 
            WHEN (SUBSTRING(quantity_per_unit,'([0-9]+W+[^gkcm])') IS NULL) 
                THEN '1' 
            ELSE (CAST (SUBSTRING(quantity_per_unit,'([0-9]+)') AS INTEGER)) 
        END AS price_per_item 
    FROM products 
    ORDER BY price_per_item DESC LIMIT 5) 
ORDER BY price_per_item DESC;


"      product_name      | quantity_per_unit  | unit_price |   price_per_item   
------------------------+--------------------+------------+--------------------
 Sir Rodney's Marmalade | 30 gift boxes      |         81 |                 81
 Carnarvon Tigers       | 16 kg pkg.         |       62.5 |               62.5
 Raclette Courdavault   | 5 kg pkg.          |         55 |                 55
 Gudbrandsdalsost       | 10 kg pkg.         |         36 |                 36
 Côte de Blaye          | 12 - 75 cl bottles |      263.5 | 21.958333333333332
"



--     Get products that cost less than $20.
SELECT product_id, product_name, unit_price FROM products WHERE unit_price<20;
" product_id | product_name  | unit_price 
------------+---------------+------------
          1 | Chai          |         18
          2 | Chang         |         19
          3 | Aniseed Syrup |         10
         13 | Konbu         |          6
         15 | Genen Shouyu  |       15.5
"
    --     Get products that cost between $15 and $25.
SELECT product_name, unit_price FROM products WHERE unit_price BETWEEN 15 AND 25 ORDER BY unit_price DESC LIMIT 5;

"         product_name         | unit_price 
------------------------------+------------
 Grandma's Boysenberry Spread |         25
 Pâté chinois                 |         24
 Tofu                         |      23.25
 Chef Anton's Cajun Seasoning |         22
 Flotemysost                  |       21.5
"
    --     Get products above average price.
SELECT product_name, unit_price FROM products WHERE unit_price> (SELECT AVG(unit_price) FROM products) ORDER BY unit_price DESC LIMIT 5;

"      product_name       | unit_price 
-------------------------+------------
 Côte de Blaye           |      263.5
 Thüringer Rostbratwurst |     123.79
 Mishi Kobe Niku         |         97
 Sir Rodney's Marmalade  |         81
 Carnarvon Tigers        |       62.5
"
    --     Find the ten most expensive products.
"see task 3"

    --     Get a list of discontinued products (Product ID and name).
SELECT product_id, product_name FROM products WHERE discontinued = 1  LIMIT 5;

" product_id |      product_name      
------------+------------------------
          5 | Chef Anton's Gumbo Mix
          9 | Mishi Kobe Niku
         17 | Alice Mutton
         24 | Guaraná Fantástica
         28 | Rössle Sauerkraut
"
    --     Count current and discontinued products.
SELECT COUNT(product_id), discontinued  FROM products GROUP BY discontinued;

" count | discontinued 
-------+--------------
    69 |            0
     8 |            1
"
    --     Find products with less units in stock than the quantity on order.
SELECT product_id, product_name FROM products AS p WHERE (p.units_in_stock< p.units_on_order);

" product_id |     product_name      
------------+-----------------------
          2 | Chang
          3 | Aniseed Syrup
         11 | Queso Cabrales
         21 | Sir Rodney's Scones
         30 | Nord-Ost Matjeshering
"
    --     Find the customer who had the highest order amount
select c.company_name, c.customer_id, sum(od.quantity * od.unit_price) as revenue 
from customer as c
join orders as o on o.customer_id = c.customer_id
join order_details as od on od.order_id = o.order_id
group by c.company_name, c.customer_id
order by revenue DESC LIMIT 5;

"         company_name         | customer_id |      revenue       
------------------------------+-------------+--------------------
 QUICK-Stop                   | QUICK       | 117483.39000000001
 Save-a-lot Markets           | SAVEA       |          115673.39
 Ernst Handel                 | ERNSH       |          113236.68
"
    --     Get orders for a given employee and the according customer

select e.employee_id, c.company_name, o.order_id from employees as e join orders as o on o.employee_id = e.employee_id join customer as c on c.customer_id = o.customer_id group by c.company_name, o.order_id, e.employee_id ORDER BY employee_id LIMIT 5;
" employee_id |         company_name         | order_id 
-------------+------------------------------+----------
           1 | QUICK-Stop                   |    10361
           1 | Vaffeljernet                 |    10465
           1 | Hanari Carnes                |    10886
           1 | Berglunds snabbköp           |    10733
           1 | Hungry Owl All-Night Grocers |    10567
"
    --     Find the hiring age of each employee

SELECT hiredate, birth_date, SUBSTRING(CAST(((e.hiredate - e.birth_date)/365.25) AS VARCHAR),'[0-9]+') as age  FROM employees as e ;
"      hiredate       |     birth_date      | age 
---------------------+---------------------+-----
 1992-05-01 00:00:00 | 1948-12-08 00:00:00 | 43
 1992-08-14 00:00:00 | 1952-02-19 00:00:00 | 40
 1992-04-01 00:00:00 | 1963-08-30 00:00:00 | 28
 1993-05-03 00:00:00 | 1937-09-19 00:00:00 | 55
 1993-10-17 00:00:00 | 1955-03-04 00:00:00 | 38
 1993-10-17 00:00:00 | 1963-07-02 00:00:00 | 30
 1994-01-02 00:00:00 | 1960-05-29 00:00:00 | 33
 1994-03-05 00:00:00 | 1958-01-09 00:00:00 | 36
 1994-11-15 00:00:00 | 1966-01-27 00:00:00 | 28
"

SELECT hiredate, birth_date, 
	extract(YEAR FROM e.hiredate)-extract(YEAR FROM e.birth_date) as diff_cal_year, 
	SUBSTRING(CAST(((e.hiredate -e.birth_date)/365.25) AS VARCHAR),'[0-9]+') as days_div_365_25, 
	CASE 
		WHEN (EXTRACT(MONTH from e.hiredate) > EXTRACT(MONTH from e.birth_date)) 
			THEN (extract(YEAR FROM e.hiredate)-extract(YEAR FROM e.birth_date)) 
		WHEN (EXTRACT(MONTH from e.hiredate) = EXTRACT(MONTH from e.birth_date)) 
			THEN CASE 
				WHEN (EXTRACT(DAY from e.hiredate) > EXTRACT(DAY from e.birth_date)) 
					THEN (extract(YEAR FROM e.hiredate)-extract(YEAR FROM e.birth_date)) 
				ELSE (extract(YEAR FROM e.hiredate)-extract(YEAR FROM e.birth_date)-1) 
			END 
		ELSE (extract(YEAR FROM e.hiredate)-extract(YEAR FROM e.birth_date) -1) 
	END  as age,
	AGE(e.hiredate, e.birth_date) AS age_using_AGE
FROM employees as e ;
"      hiredate       |     birth_date      | diff_cal_year | days_div_365_25 | age 
---------------------+---------------------+---------------+-----------------+-----
 1992-05-01 00:00:00 | 1948-12-08 00:00:00 |            44 | 43              |  43
 1992-08-14 00:00:00 | 1952-02-19 00:00:00 |            40 | 40              |  40
 1992-04-01 00:00:00 | 1963-08-30 00:00:00 |            29 | 28              |  28
 1993-05-03 00:00:00 | 1937-09-19 00:00:00 |            56 | 55              |  55
 1993-10-17 00:00:00 | 1955-03-04 00:00:00 |            38 | 38              |  38
 1993-10-17 00:00:00 | 1963-07-02 00:00:00 |            30 | 30              |  30
 1994-01-02 00:00:00 | 1960-05-29 00:00:00 |            34 | 33              |  33
 1994-03-05 00:00:00 | 1958-01-09 00:00:00 |            36 | 36              |  36
 1994-11-15 00:00:00 | 1966-01-27 00:00:00 |            28 | 28              |  28
"



--     Create views and/or named queries for some of these queries
