--Demonstrates filters, sorting, aggregation, joins:

--1.	List the Store, City, State, and Zip code for stores located in California and Texas. Display result-set in ascending order of states, and for each state in ascending order of city names. (Note – Please refer to the Store table).

                    SELECT DISTINCT STORE, CITY, STATE, ZIP_CODE
                    FROM STORE
                    WHERE STATE IN ('CA','TX')
                    ORDER BY STATE ASC, CITY ASC;

---2.	List the Customer ID (Cust_ID), Transaction amount (Tran_Amt), Transaction date (Tran_Date), City, State, and Zip code (Zip_Code) for the largest purchase transaction (Tran_Type) by customer from Texas (State). Information about the purchase transaction should be displayed once. (Note – Please refer to the Customer and Transact tables).

                    SELECT DISTINCT TOP 1 WITH TIES
                    CUSTOMER.CUST_ID AS 'Customer ID',
                    TRAN_AMT AS 'Transaction amount',
                    TRAN_DATE AS 'Transaction date',
                    City,
                    State,
                    ZIP_CODE AS 'Zip code'
                    FROM CUSTOMER
                    JOIN TRANSACT
                    ON CUSTOMER.CUST_ID = TRANSACT.CUST_ID
                    WHERE STATE = 'TX'
                    AND TRAN_TYPE = 'P'
                    	 ORDER BY TRAN_AMT DESC;

---3.	Display with appropriate column heading the total purchase amount (Tran_Type) in year 2015 (Tran_Date) at stores located in Texas (State). (Note – Please refer to the Transact and Store tables).

                    SELECT STORE.STORE, SUM(TRAN_AMT) AS 'TOTAL PURCHASE AMOUNT'
                    FROM STORE
                    JOIN TRANSACT
                    ON TRANSACT.STORE = STORE.STORE
                    WHERE STATE = 'TX'
                    AND YEAR(TRAN_DATE) = '2015'
                    AND TRAN_TYPE = 'P'
                    GROUP BY STORE.STORE
                    	 ORDER BY STORE.STORE;

---4.	For stores located in Texas (State), what is the total purchase amount (Tran_Type) for each year (Tran_Date). In the result-set, include two columns: year and total dollar amount of purchase for each year. (Note – Please refer to the Transact and Store tables).

                    SELECT
                    YEAR(TRAN_DATE) AS 'Year',
                    SUM(TRAN_AMT) AS 'Total dollar amount of purchase'
                    FROM STORE
                    JOIN TRANSACT
                    ON TRANSACT.STORE = STORE.STORE
                    WHERE STATE = 'TX'
                    AND TRAN_TYPE = 'P'
                    GROUP BY YEAR(TRAN_DATE)
                    	  ORDER BY Year ASC;

---5.	List the Product SKU (SKU), Department description (Dept_Desc), DeptDec_Desc, Color, Retail price (Retail), and Size (SKU_Size) for navy (Color) career (DeptDec_Desc) sweaters (Classification) with retail price (Retail) less than or equal to $100 from Jones Signature or Daniel Cremieux (Dept_Desc). Display result-set in descending order of Department Description (Dept_Desc), and for each Department Description in ascending order of Size (SKU_SIZE). Information for each Product SKU should be displayed once. (Note – Please refer to the Department, SKU, and SKU_Store tables).

                    SELECT DISTINCT
                    SKU.SKU AS 'Product SKU',
                    DEPT_DESC AS 'Department description',
                    DeptDec_Desc,
                    Color,
                    SKU_STORE.RETAIL AS 'Retail price',
                    SKU_SIZE AS 'Size'
                    FROM DEPARTMENT
                    JOIN SKU
                    ON DEPARTMENT.DEPT = SKU.DEPT
                    JOIN SKU_STORE
                    ON SKU.SKU = SKU_STORE.SKU
                    WHERE DEPT_DESC IN ('Jones Signature','Daniel Cremieux')
                    AND COLOR LIKE '%NAVY%'
                    AND DEPTDEC_DESC LIKE '%CAREER%'
                    AND CLASSIFICATION LIKE '%SWEATER%'
                    AND SKU_STORE.RETAIL <=100
                    	 ORDER BY DEPT_DESC DESC, SKU_SIZE ASC;

---6.	In terms of the Dept_Desc, which perfume/cologne (Classification) generated the highest total dollar sales (Tran_Amt). Display the Dept_Desc and total dollar sales amount. (Note – Please refer to the Department, SKU, and Transact tables).

                    SELECT TOP 1 WITH TIES
                    Dept_Desc,
                    SUM(TRAN_AMT) AS 'Dollar sales amount'
                    FROM DEPARTMENT
                    JOIN SKU
                    ON DEPARTMENT.DEPT = SKU.DEPT
                    JOIN TRANSACT
                    ON SKU.ITEM_ID = TRANSACT.ITEM_ID
                    WHERE SKU.CLASSIFICATION = 'PERFUME/COLOGNE'
                    GROUP BY Dept_Desc
                    	 ORDER BY SUM(TRAN_AMT) DESC;

---7.	List the Customer ID (Cust_ID), City, State, and Zip Code (Zip_Code) for customers from Texas (State) who have total purchase of $15,000 or more (total of Tran_Amt). Display these customers in descending order of total purchase amount. (Note – Please refer to the Customer and Transact tables).
                    SELECT DISTINCT
                    CUSTOMER.CUST_ID AS 'Customer ID'
                    , City
                    , State
                    , ZIP_CODE AS 'Zip code'
                    , SUM(TRAN_AMT) AS TOTAL_PURCHASE
                    FROM CUSTOMER
                    INNER JOIN TRANSACT
                    ON CUSTOMER.CUST_ID = TRANSACT.CUST_ID
                    WHERE STATE LIKE 'TX'
                    GROUP BY CUSTOMER.CUST_ID, CITY, STATE, ZIP_CODE
                    HAVING SUM(TRAN_AMT) >= 15000
                    	 ORDER BY TOTAL_PURCHASE DESC;

---8.	List the Department Code (Dept), Department Description (Dept_Desc), DeptDec_Desc, DeptCent, and Deptcent_Desc for departments with no items in the SKU table. Exclude from the list, departments with Lease in the Deptcent_Desc column. (Note – Please refer to the Department and SKU tables).

                    SELECT DEPARTMENT.DEPT AS 'Department Code',
                    DEPT_DESC AS 'Department Description',
                    DeptDec_Desc,
                    DeptCent,
                    Deptcent_Desc
                    FROM DEPARTMENT
                    LEFT JOIN SKU
                    ON DEPARTMENT.DEPT = SKU.DEPT
                    WHERE SKU.DEPT IS NULL
                    AND DeptCent_Desc <>'Lease';

---9.	For each store, list the Store, City, State, Zip Code (Zip_Code), and number of items (SKU) with retail price (Retail) $500 or more. Display result-set in descending order of the number of items with retail price $500 or more. (Note – Please refer to the Store and SKU_Store tables).

                    SELECT DISTINCT
                    STORE.Store, City, State,
                    ZIP_CODE AS 'Zip code',
                    COUNT(DISTINCT SKU) AS 'Number of Items'
                    FROM STORE
                    INNER JOIN SKU_STORE
                    ON STORE.STORE = SKU_STORE.STORE
                    WHERE RETAIL >=500
                    GROUP BY STORE.STORE, CITY, STATE, ZIP_CODE
                    ORDER BY 'Number of Items' DESC;


---Demonstrates sub queries:

---10.	List CustomerID (Cust_ID), City, State, Zip code (Zip_Code), and Dept_Desc for customers from Texas who have purchased both Chanel and Armani (Dept_Desc) perfume/cologne (Classification). Display each combination of customer and perfumes purchased once. Sort result-set in ascending order of city, and for each city in ascending order of zip code. (Note – Please refer to the Department, SKU, Transact, and Customer tables. For Dept_Desc condition, use the LIKE operator with ‘%Chanel%’ and ‘%Armani%’.)

                    SELECT DISTINCT SELECTED_CUSTOMERS.CUST_ID, SELECTED_CUSTOMERS.City,
                    SELECTED_CUSTOMERS.State, SELECTED_CUSTOMERS.ZIP_CODE,
                    DEPARTMENT.DEPT_DESC
                    FROM
                    (
                    SELECT DISTINCT CUSTOMER.CUST_ID,
                    CUSTOMER.City, CUSTOMER.State, CUSTOMER.ZIP_CODE
                    FROM CUSTOMER
                    WHERE CUSTOMER.CUST_ID IN
                    (
                    SELECT DISTINCT CUSTOMER.CUST_ID
                    FROM DEPARTMENT
                    JOIN SKU
                    ON DEPARTMENT.DEPT = SKU.DEPT
                    JOIN TRANSACT
                    ON SKU.SKU = TRANSACT.SKU
                    JOIN CUSTOMER
                    ON TRANSACT.CUST_ID = CUSTOMER.CUST_ID
                    WHERE (DEPT_DESC LIKE '%Chanel%')
                    AND SKU.CLASSIFICATION = 'Perfume/Cologne'
                    AND STATE LIKE 'TX'
                    )
                    AND CUSTOMER.CUST_ID IN
                    (
                    SELECT DISTINCT CUSTOMER.CUST_ID
                    FROM DEPARTMENT
                    JOIN SKU
                    ON DEPARTMENT.DEPT = SKU.DEPT
                    JOIN TRANSACT
                    ON SKU.SKU = TRANSACT.SKU
                    JOIN CUSTOMER
                    ON TRANSACT.CUST_ID = CUSTOMER.CUST_ID
                    WHERE (DEPT_DESC LIKE '%Armani%')
                    AND SKU.CLASSIFICATION = 'Perfume/Cologne'
                    AND STATE LIKE 'TX'
                    )
                    ) SELECTED_CUSTOMERS
                    LEFT JOIN TRANSACT
                    ON TRANSACT.CUST_ID = SELECTED_CUSTOMERS.CUST_ID
                    LEFT JOIN SKU
                    ON TRANSACT.ITEM_ID = SKU.ITEM_ID
                    LEFT JOIN DEPARTMENT
                    ON DEPARTMENT.DEPT = SKU.DEPT
                    WHERE (DEPT_DESC LIKE '%Chanel%' OR Dept_Desc LIKE '%Armani%')
                    	 ORDER BY CITY ASC, Zip_code ASC;


---11.	Write a SELECT statement to list the Account Number and Account Description for General Ledger Accounts that have no invoice line items posted yet. Display the AccountNo and AccountDescription in ascending order of AccountDescription. (Note – Please refer to the GLAccounts and InvoiceLineItems tables).

                    select AccountNo, AccountDescription
                    from GLAccounts
                    where GLAccounts.AccountNo not in (select InvoiceLineItems.AccountNo from InvoiceLineItems
                    where GLAccounts.AccountNo = InvoiceLineItems.AccountNo)
                    		order by AccountDescription asc;

---12.	Write a SELECT statement to display InvoiceID, InvoiceDate, InvoiceTotal, TotalCredits (CreditTotal + PaymentTotal), TermsID, TermsDescription, and InvoiceLineItemAmount for invoices with TermsID 3 that are not fully paid (InvoiceTotal – PaymentTotal – CreditTotal > 0) and have InvoiceTotal greater than or equal to $500.  Display the result-set in descending order of the InvoiceTotal values. (Note – Please refer to the Invoices, Terms, and InvoiceLineItems tables).

                    select Invoices.InvoiceID,InvoiceDate,InvoiceTotal, (PaymentTotal+CreditTotal) as TotalCredits, Terms.TermsID, 	TermsDescription, InvoiceLineItems.InvoiceLineItemAmount
                    from Invoices
                    inner join InvoiceLineItems on Invoices.InvoiceID = InvoiceLineItems.InvoiceID
                    inner join Terms on Invoices.TermsID = Terms.TermsID
                    where Terms.TermsID = 3
                    and (InvoiceTotal - PaymentTotal - CreditTotal)>0
                    and InvoiceTotal >= 500
                    order by InvoiceTotal desc;

---13.	Display the VendorID, VendorName, InvoiceID, InvoiceDate and InvoiceTotal for invoice(s) with invoice total amount greater than the largest invoice total amount for invoices from vendors located in California. Display the result-set in descending order of InvoiceTotal values. (Note – Please refer to the Vendors and Invoices tables).

                    select Vendors.VendorID, VendorName, InvoiceID, InvoiceDate , InvoiceTotal from
                    Vendors inner join Invoices on Vendors.VendorID = Invoices.VendorID
                    where Invoices.InvoiceTotal > (select Max(Invoices.InvoiceTotal) from
                    Vendors inner join Invoices on Vendors.VendorID = Invoices.VendorID AND Vendors.VendorState = 'CA')
                    order by InvoiceTotal desc;


---14.	Write a SELECT statement to display the TermsID, TermsDescription, Total of Invoice Amounts (i.e., total of invoice total values), Number of Invoices, and Average Invoice Total for each payment term that has ten or more invoices. Display the result-set in ascending order of Average Invoice Total values. In the result-set, provide appropriate column names for the total of invoice amounts, number of invoices, and average invoice total columns. (Note – Please refer to the Terms and Invoices tables).

                    select Terms.TermsID, TermsDescription,sum(InvoiceTotal) as 'Total of Invoice Amounts', count (*) as 'NumberOfInvoices',      avg(InvoiceTotal) as 'AverageInvoiceTotal'
                    from Invoices inner join Terms on Invoices.TermsID = Terms.TermsID
                    group by Terms.TermsID,TermsDescription
                    having count(*) >= 10
                    order by 'AverageInvoiceTotal';

---15.	Write a SELECT statement to display the VendorID and VendorName for vendors with invoices in February 2012 and March 2012. Display the result-set in ascending order of VendorName values. In the result-set each vendor should be displayed once. (Note – Please refer to the Vendors and Invoices tables).

                    select distinct Vendors.VendorID, Vendors.VendorName
                    from Vendors inner join Invoices on Vendors.VendorId = Invoices.VendorID
                    where (year (InvoiceDate) =  '2012' and month(InvoiceDate) =  '02')
                    or (year (InvoiceDate) =  '2012' and 	month(InvoiceDate) =  '03')
                    And VENDORs.vendorId in (select distinct vendors.vendorID
                    			from Vendors inner join Invoices on Vendors.VendorId = Invoices.VendorID
                    			where (year (InvoiceDate) =  '2012' and month(InvoiceDate) =  '02')
                                         	And
                    VENDORs.vendorId in  (select distinct vendors.vendorID
                    			from Vendors inner join Invoices on Vendors.VendorId = Invoices.VendorID
                    			where (year (InvoiceDate) =  '2012' and month(InvoiceDate) =  '03')))
                    order by VendorName asc

--- Inner joins

-- Select all columns from cities

--Begin by selecting all columns from the cities table.
                    select * from cities;

                    SELECT *
                    FROM cities
                      -- Inner join to countries
                      INNER JOIN countries
                        -- Match on the country codes
                        ON cities.country_code = countries.code;

--Modify the SELECT statement to keep only the name of the city, the name of the country, and the name of the region the country resides in.
--Alias the name of the city AS city and the name of the country AS country.

                    SELECT cities.name as city, countries.name as country, region
                    FROM cities
                    INNER JOIN countries
                    ON cities.country_code = countries.code;


/*Join the tables countries (left) and economies (right) aliasing countries AS c and economies AS e.
Specify the field to match the tables ON.
From this join, SELECT:
c.code, aliased as country_code.
name, year, and inflation_rate, not aliased.*/

-- Select fields with aliases
                    SELECT c.code AS country_code, name, year, inflation_rate
                    FROM countries AS c
                      -- Join to economies (alias e)
                      inner JOIN  economies AS e
                        -- Match on code
                        ON c.code = e.code;

/*
Inner join countries (left) and populations (right) on the code and country_code fields respectively.
Alias countries AS c and populations AS p.
Select code, name, and region from countries and also select year and fertility_rate from populations (5 fields in total).
                    */

                    -- Select fields
                    select c.code, c.name, c.region, p.year, p.fertility_rate
                      -- From countries (alias as c)
                      from countries as c
                      -- Join with populations (as p)
                      inner join populations as p
                        -- Match on country code
                        on c.code = p.country_code


                    /*
Add an additional INNER JOIN with economies to your previous query by joining on code.
Include the unemployment_rate column that became available through joining with economies.
Note that year appears in both populations and economies, so you have to explicitly use e.year instead of year as you did before.
                    */

                    -- Select fields
                    SELECT c.code, name, region, e.year, fertility_rate,unemployment_rate
                      -- From countries (alias as c)
                      FROM countries AS c
                      -- Join to populations (as p)
                        INNER JOIN populations AS p
                        -- Match on country code
                          ON c.code = p.country_code
                      -- Join to economies (as e)
                            INNER JOIN economies AS e
                        -- Match on country code
                              ON c.code = e.code;


/*The trouble with doing your last join on c.code = e.code and not also including year is that e.g. the 2010 value for fertility_rate is also paired with the 2015 value for unemployment_rate.
                    */
                    -- Select fields
                    SELECT c.code, name, region, e.year, fertility_rate, unemployment_rate
                      -- From countries (alias as c)
                      FROM countries AS c
                      -- Join to populations (as p)
                      INNER JOIN populations AS p
                        -- Match on country code
                        ON c.code = p.country_code
                      -- Join to economies (as e)
                      INNER JOIN economies AS e
                        -- Match on country code and year
                        ON c.code = e.code and e.year = p.year;

                    --- Joins with using keyword
/*Inner join countries on the left and languages on the right with USING(code).
Select the fields corresponding to:
country name AS country,
continent name,
language name AS language, and
whether or not the language is official.
Remember to alias your tables using the first letter of their names.*/

                    -- Select fields
                    select c.name as country, continent,l.name as language, official
                      -- From countries (alias as c)
                      from countries as c
                      -- Join to languages (as l)
                      inner join languages as l
                        -- Match using code
                        using(code)

/*Join populations with itself ON country_code.
Select the country_code from p1 and the size field from both p1 and p2. SQL won't allow same-named fields, so alias p1.size as size2010 and p2.size as size2015.
*/

                    -- Select fields with aliases
                    select p1.country_code,
                    p1.size as size2010,
                    p2.size as size2015
                    -- From populations (alias as p1)
                    from populations as p1
                      -- Join to itself (alias as p2)
                      inner join populations as p2
                        -- Match on country code
                        on p1.country_code = p2.country_code;

/*Notice from the result that for each country_code you have four entries laying out all combinations of 2010 and 2015.
Extend the ON in your query to include only those records where the p1.year (2010) matches with p2.year - 5 (2015 - 5 = 2010). This will omit the three entries per country_code that you aren't interested in.*/

                        -- Select fields with aliases
                        SELECT p1.country_code,
                               p1.size AS size2010,
                               p2.size AS size2015
                        -- From populations (alias as p1)
                        FROM populations as p1
                          -- Join to itself (alias as p2)
                          inner JOIN populations as p2
                            -- Match on country code
                            ON p1.country_code = p2.country_code
                                -- and year (with calculation)
                                and p1.year = (p2.year - 5)

                    --- Growth percent calculation

                                -- Select fields with aliases
                                SELECT p1.country_code,
                                       p1.size AS size2010,
                                       p2.size AS size2015,
                                       -- Calculate growth_perc
                                       ((p2.size - p1.size)/p1.size * 100.0) AS growth_perc
                                -- From populations (alias as p1)
                                FROM populations AS p1
                                  -- Join to itself (alias as p2)
                                  INNER JOIN populations AS p2
                                    -- Match on country code
                                    ON p1.country_code = p2.country_code
                                        -- and year (with calculation)
                                        AND p1.year = p2.year - 5;
