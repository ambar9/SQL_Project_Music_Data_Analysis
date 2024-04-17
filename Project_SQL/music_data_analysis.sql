/* Q1: Who is the senior most employee based on job title? */

SELECT
    employee_id,
    first_name,
    last_name,
    title
FROM
    employee
ORDER BY
    levels DESC
LIMIT 1;


/* Q2: Which countries have the most Invoices? */

SELECT
    billing_country,
    COUNT(invoice_id) AS invoices
FROM
    invoice
GROUP BY
    billing_country
ORDER BY
    invoices DESC;


/* Q3: What are top 3 values of total invoice? */

SELECT
    invoice_id,
    customer_id,
    total
FROM
    invoice
ORDER BY
    total DESC
LIMIT 3;


/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

SELECT
    billing_city,
    SUM(total) AS invoice_totals
FROM
    invoice
GROUP BY
    billing_city
ORDER BY    
    invoice_totals DESC
LIMIT 1;


/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

SELECT
    tab1.first_name,
    tab1.last_name,
    tab1.customer_id,
    ROUND(SUM(tab2.total)::numeric,2) AS money_spent
FROM
    customer AS tab1 JOIN invoice AS tab2 ON
    tab1.customer_id = tab2.customer_id
GROUP BY
    tab1.customer_id
ORDER BY
    money_spent DESC
LIMIT 1;


/* Q6 : Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

--method1:

SELECT
    DISTINCT tab1.email,
    tab1.first_name,
    tab1.last_name,
    tab5.name
FROM
    customer AS tab1
    JOIN
        invoice AS tab2
    ON
        tab1.customer_id = tab2.customer_id
    JOIN
        invoice_line AS tab3
    ON
        tab2.invoice_id = tab3.invoice_id
    JOIN
        track AS tab4
    ON
        tab3.track_id = tab4.track_id
    JOIN
        genre AS tab5
    ON
        tab4.genre_id = tab5.genre_id
WHERE   
    tab5.name = 'Rock'
ORDER BY
    email;

-- method2:

SELECT 
    DISTINCT email,
    first_name,
    last_name
FROM 
    customer
    JOIN 
    invoice 
    ON
    customer.customer_id = invoice.customer_id
    JOIN 
    invoice_line 
    ON 
    invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
	SELECT 
        track_id 
    FROM 
        track
	JOIN 
        genre 
    ON 
        track.genre_id = genre.genre_id
	WHERE 
        genre.name Like 'Rock'
)
ORDER BY 
    email;


/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */


-- method1:

SELECT
    tab1.name AS artist_name,
    COUNT(tab3.track_id) AS tracks_count
FROM    
    artist AS tab1
    JOIN
        album AS tab2
    ON
        tab1.artist_id = tab2.artist_id
    JOIN    
        track AS tab3
    ON
        tab2.album_id = tab3.album_id
    JOIN
        genre AS tab4
    ON
        tab3.genre_id = tab4.genre_id
WHERE
    tab4.name = 'Rock'
GROUP BY
    artist_name
ORDER BY
    tracks_count DESC
LIMIT 10;

-- method2:

/* Method 2 */

SELECT 
    artist.artist_id,
    artist.name,
    COUNT(artist.artist_id) AS number_of_songs
FROM 
    artist
    Join 
        album 
    on  
        artist.artist_id = album.artist_id
    JOIN    
        track 
    ON 
        album.album_id = track.album_id
    where   
        track_id in(
	                SELECT 
                        track_id 
                    FROM 
                        track
	                JOIN 
                        genre 
                    ON 
                        track.genre_id = genre.genre_id
	                WHERE 
                        genre.name LIKE 'Rock'
)
GROUP BY 
    artist.artist_id
ORDER BY 
    number_of_songs DESC
LIMIT 10;


/* Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

--method1:

SELECT
    name,
    milliseconds
FROM
    track
WHERE
    milliseconds > (
        SELECT
            AVG(milliseconds) AS avg_millisec
        FROM
            track
    )
ORDER BY
    milliseconds DESC;


--Method2:


WITH name_length AS(
    SELECT  
        name,
        milliseconds
    FROM
        track
)
    , avg_millisec AS(
    SELECT
        AVG(milliseconds) AS avg_millisecs
    FROM
        name_length
    )

SELECT
    cte1.name,
    cte1.milliseconds
FROM
    name_length AS cte1,
    avg_millisec AS cte2
WHERE
   cte1.milliseconds > cte2.avg_millisecs
ORDER BY
    cte1.milliseconds DESC;


/* Q9: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

/* Steps to Solve: 
First, find which artist has earned the most according to the InvoiceLines. 
Now use this artist to find which customer spent the most on this artist. 
For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, 
Album, and Artist tables. 
Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, and then multiply this by the price
for each artist. */

WITH bets_selling_artist AS (
    SELECT
        tab4.artist_id,
        tab4.name AS artist_name,
        SUM(tab1.unit_price * tab1.quantity) AS total_sales
    FROM
        invoice_line AS tab1
        JOIN
            track AS tab2
        ON
            tab1.track_id = tab2.track_id
        JOIN
            album AS tab3
        ON
            tab2.album_id = tab3.album_id
        JOIN
            artist AS tab4
        ON
            tab3.artist_id = tab4.artist_id
    GROUP BY
        tab4.artist_id,
        artist_name
    ORDER BY
        total_sales DESC
    LIMIT 1
)

SELECT
    tab1.customer_id,
    tab1.first_name,
    tab1.last_name,
    tab6.artist_name,
    SUM(tab3.unit_price * tab3.quantity) AS total_spent
FROM
    Customer AS tab1
    JOIN
        invoice AS tab2
    ON
        tab1.customer_id = tab2.customer_id
    JOIN
        invoice_line AS tab3
    ON
        tab2.invoice_id = tab3.invoice_id
    JOIN
        track AS tab4
    ON
        tab3.track_id = tab4.track_id
    JOIN
        album AS tab5
    ON
        tab4.album_id = tab5.album_id
    JOIN
        bets_selling_artist AS tab6
    ON
        tab5.artist_id = tab6.artist_id
GROUP BY
    tab1.customer_id,
    tab1.first_name,
    tab1.last_name,
    tab6.artist_name
ORDER BY
    total_spent DESC;
  

/* Q-10: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

/* Steps to Solve:  There are two parts in question- first most popular music genre and second need data at country level. */

--Method1:

WITH  genre_with_total_sales AS(    
    SELECT
        G.name AS genre_name,
        SUM(IL.quantity) AS highest_purchase,
        C.country AS country
    FROM
        genre AS G
        JOIN    
            track AS T
        ON
            G.genre_id = T.genre_id
        JOIN
            invoice_line AS IL
        ON
            T.track_id = IL.track_id
        JOIN
            invoice AS I
        ON
            IL.invoice_id = I.invoice_id
        JOIN
            customer AS c
        ON
            I.customer_id = C.customer_id
        
    GROUP BY
        genre_name,C.country
)

, rank_wise_sales AS (SELECT
    genre_name,
    country,
    highest_purchase,
    RANK() OVER (PARTITION BY country ORDER BY highest_purchase DESC) AS country_rank
FROM
    genre_with_total_sales)

SELECT
    genre_name,
    country,
    highest_purchase    
FROM
    rank_wise_sales
WHERE
    country_rank<=1;



--Method 2:

WITH RECURSIVE
	sales_per_country AS(
		SELECT 
            customer.country, 
            genre.name, 
            genre.genre_id, 
            COUNT(*) AS purchases_per_genre
		FROM 
            invoice_line
		    JOIN 
                invoice 
            ON 
                invoice.invoice_id = invoice_line.invoice_id
		    JOIN 
                customer 
            ON 
                customer.customer_id = invoice.customer_id
		    JOIN 
                track 
            ON 
                track.track_id = invoice_line.track_id
		    JOIN 
                genre 
            ON 
                genre.genre_id = track.genre_id
		GROUP BY 
            1,2,3
		ORDER BY 
            1
	),
	max_genre_per_country AS (
        SELECT 
            MAX(purchases_per_genre) AS max_genre_number, 
            country
		FROM 
            sales_per_country
		GROUP BY 
            2
		ORDER BY 
            2)

SELECT 
    sales_per_country.* 
FROM 
    sales_per_country
    JOIN 
        max_genre_per_country 
    ON 
        sales_per_country.country = max_genre_per_country.country
WHERE 
    sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number;


/* Q-11: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

/* Steps to Solve:  Similar to the above question. There are two parts in question- 
first find the most spent on music for each country and second filter the data for respective customers. */

--Method1:

WITH best_customer_in_each_country AS(
    SELECT
        C.customer_id,
        C.first_name,
        C.last_name,
        C.country,
        ROUND(SUM(I.total)::numeric,2) AS total_spent,
        RANK() OVER (PARTITION BY C.country ORDER BY SUM(I.total) DESC) AS country_rank
        
    FROM
        customer AS C 
        JOIN
            invoice AS I
        ON
            C.customer_id = I.customer_id
    GROUP BY
        C.country,C.customer_id
    ORDER BY
        C.country,total_spent DESC
)

SELECT
    customer_id,
    first_name,
    last_name,
    country,
    total_spent
FROM
    best_customer_in_each_country
WHERE
    country_rank <=1;


--Method2:

WITH RECURSIVE 
	customter_with_country AS (
		SELECT 
            customer.customer_id,
            first_name,last_name,
            billing_country,
            SUM(total) AS total_spending
		FROM 
            invoice
		JOIN 
            customer 
        ON 
            customer.customer_id = invoice.customer_id
		GROUP BY 
            1,2,3,4
		ORDER BY 
            2,3 DESC),

	country_max_spending AS(
		SELECT 
            billing_country,
            MAX(total_spending) AS max_spending
		FROM 
            customter_with_country
		GROUP BY 
            billing_country)

SELECT 
    cc.billing_country, 
    cc.total_spending, 
    cc.first_name, 
    cc.last_name, 
    cc.customer_id
FROM 
    customter_with_country cc
JOIN 
    country_max_spending ms
    ON 
        cc.billing_country = ms.billing_country
WHERE 
    cc.total_spending = ms.max_spending
ORDER BY 
    1;
