USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*) as row_count from  director_mapping;
-- Total 3867 rows in director_mapping table

select count(*) as row_count from genre;
-- Total 14662 rows in genre table

select count(*) as row_count from movie;
-- Total 7997 rows in movie table

select count(*) as row_count from names;
-- Total 25735 rows in names table

select count(*) as row_count from ratings;
-- Total 7997 rows in ratings table

select count(*) as row_count from role_mapping;
-- Total 15615 rows in role_mapping table






-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select sum(
			case when id is null then 1 
			else 0
			end) as id_null_count,
        sum(
			case when title is null then 1
            else 0
            end) as title_null_count,
		sum(
			case when year is null then 1
            else 0
            end)  as year_null_count,
        sum(    
			case when date_published is null then 1
            else 0
            end) as date_published_null_count,
		sum(
			case when duration is null then 1
            else 0
            end) as duration_null_count,
		sum(
			case when country is null then 1
            else 0
            end) as country_null_count,
		sum(
			case when worlwide_gross_income is null then 1
            else 0
            end) as worlwide_gross_income_null_count,
		sum(
			case when languages is null then 1
            else 0
            end) as languages_null_count,
		sum(
			case when production_company is null then 1
            else 0
            end) as production_company_null_count
from movie;

-- As we can see in above query output, there are null values present in country, worlwide_gross_income, languages, production_company columns







-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- for the first part:

select 
	Year, 
	count(id) as number_of_movies 
from 
	movie
group by 
	year 
order by 
	year;

-- -- We can see from above query output, the highest number of movies are released in the year 2017 followed by 2018 and 2019 which is a downward trend

 

-- for the second part:

select 
	month(date_published) as month_num, 
    count(id) as number_of_movies  
from 
	movie
group by 
	month_num
order by 
	number_of_movies desc;

-- We can see from above query output, the highest number of movies are released in March followed by Septemper




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(id) AS number_of_movies
FROM
    movie
WHERE
    (country REGEXP 'USA'
		OR country REGEXP 'India') 
    AND year = 2019;

-- The number of movies were produced in the USA or India in the year 2019 are 1059













/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
    genre
FROM
    genre;

-- There are a total of 13 unique types of genres present in the data









/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select 
	g.genre, count(m.id) as number_of_movies
from 
	movie m
		inner join 
	genre g		on m.id = g.movie_id
group by 
	g.genre
order by 
	number_of_movies desc 
limit 1;

-- Drama genre had the highest number of movies produced overall which is 4285

-- Finding out the genre which had highest movie production in the year 2019
select 
	g.genre, count(m.id) as number_of_movies
from 
	movie m
		inner join 
	genre g		on m.id = g.movie_id
where
	year = 2019
group by 
	g.genre
order by 
	number_of_movies desc 
limit 1;

-- Total Drama genre movies produced in the year 2019 was 1078

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


WITH one_genre_movie
     AS (SELECT movie_id, count(genre) as genre_count
         FROM   genre
         GROUP  BY movie_id
         HAVING genre_count = 1)
SELECT Count(*) AS one_genre_movie_count
FROM one_genre_movie; 

-- Total 3289 movies associated with only one genre




/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select 
	g.genre, 
    round(avg(m.duration), 2) as avg_duration
from 
	genre g
inner join 
	movie m 	on g.movie_id = m.id
group by 
	g.genre
order by 
	avg_duration desc;

-- Action genre had highest average duration of 112.88 minutes followed by romanace and crime genre





/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

with thriller_rank as
(select 
	genre, 
    count(movie_id) as movie_count,
	rank() over (order by count(movie_id) desc) as genre_rank
from 
	genre
group by 
	genre)
select 
	* 
from 
	thriller_rank
where 
	genre = 'thriller';

-- The rank of Thriller genre is 3rd among all the genres in terms of number of movies produced







/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select 
	min(avg_rating) as min_avg_rating, 
    max(avg_rating) as max_avg_rating,
	min(total_votes) as min_total_votes, 
    max(total_votes) as max_total_votes,
	min(median_rating) as min_median_rating, 
    max(median_rating) as max_median_rating
from ratings;







    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

with top_10_movie as
(select 
	m.title, 
    r.avg_rating,
	dense_rank() over(order by r.avg_rating desc) as movie_rank
from 
	movie m
		inner join 
	ratings r on m.id = r.movie_id)
select 
	* 
from 
	top_10_movie
where 
	movie_rank <=10;

-- The top 3 movies have average rating greater than or equals to 9.7

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

select 
	median_rating, 
	count(movie_id) as movie_count
from 
	ratings
group by 
	median_rating
order by 
	movie_count desc;








/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
with top_prod_company as
(select 
	production_company, 
    count(id) as movie_count,
	dense_rank() over(order by count(id) desc) as prod_company_rank
from 
	movie
where 
	id in (select movie_id from ratings where avg_rating > 8)
group by 
	production_company 
having 
	production_company is not null)
select 
	* 
from 
	top_prod_company
where 
	prod_company_rank = 1;

-- The 'Dream Warrior Pictures' and 'National Theatre Live' production houses have produced the most number of hit movies (average rating > 8)








-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre, COUNT(m.id) AS movie_count
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
        INNER JOIN
    ratings r ON r.movie_id = g.movie_id
WHERE
    year = 2017
	AND MONTH(m.date_published) = 3
	AND m.country REGEXP 'USA'
	AND r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;   

-- Top 3 genres are Drama, Comedy ,and Action
-- Total 24 Drama movies were released during March 2017 in the USA had more than 1,000 votes followed by 9 Comedy and 8 Action movies



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select 
	m.title, 
    r.avg_rating, 
    g.genre
from 
	movie m
		inner join 
	genre g 	on m.id = g.movie_id
		inner join 
	ratings r 	on r.movie_id = g.movie_id
where 
	m.title regexp '^The' 
    and r.avg_rating > 8
order by 
	avg_rating desc;

-- The Brighton Miracle has highest average rating of 9.5 




-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select 
	count(id) as movie_count
from 
	movie
where 
	date_published between '2018-04-01' and '2019-04-01' 
	and id in 
			(select movie_id from ratings where median_rating = 8);  

-- There are total 361 movies that was released between 1 April 2018 and 1 April 2019, and given a median rating of 8





-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select 
	m.country, 
	sum(r.total_votes) as total_votes
from 
	movie m
		inner join 
	ratings r	on m.id = r.movie_id
group by 
	m.country
having 
	m.country = 'Italy' 
	or m.country = 'Germany'
order by 
	total_votes desc;

-- Yes, the German movies got more votes than Italian movies.The German and Italian movie votes are 106710 and 77965 respectively.




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select
	sum(case when name is null then 1 else 0 end) as name_nulls,
	sum(case when height is null then 1 else 0 end) as height_nulls,
	sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
	sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_null
from 
	names;


/*
There are no null values in 'name' column, 17335 null values in 'height' column, 13431 null values in 'date of birth' column, 
15226 null values in 'known for movies' column
*/

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
with top_three_genre as 
(select
	genre,
	count(m.id) as movie_count
from
	movie m
		inner join
	genre g on m.id = g.movie_id
		inner join
	ratings r on r.movie_id = m.id
where
	avg_rating > 8
group by
	genre
order by
	movie_count desc
limit 3
)
select
    n.name as director_name,
    count(m.id) as movie_count
from
    movie m
		inner join
    director_mapping d on m.id = d.movie_id
		inner join
    names n on n.id = d.name_id
		inner join
    genre g on g.movie_id = m.id
		inner join
    ratings r on m.id = r.movie_id
where
    g.genre in (select genre from Top_Three_Genre)
    and avg_rating > 8
group by
    director_name
order by
    movie_count desc
limit 3;


 -- Using the top genres derived from the CTE, the directors are found whose movies have an average rating > 8 and are sorted based on number of movies made.  

-- The top three directors in the top three genres whose movies have an average rating > 8 are James Mangold, Joe Russo, and Anthony Russo








/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select 
	n.name as actor_name, 
    count(m.id) as movie_count
from 
	movie m
		inner join 
	ratings r on m.id = r.movie_id
		inner join 
	role_mapping rm on m.id = rm.movie_id
		inner join 
	names n on rm.name_id = n.id
where 
	median_rating >=8
group by 
	actor_name
order by 
	movie_count desc
limit 2;


-- the top two actors whose movies have a median rating >= 8 are Mammootty and Mohanlal



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select 
	production_company, 
    sum(total_votes) as vote_count, 
	dense_rank() over(order by sum(total_votes) desc) as prod_comp_rank
from 
	movie m
inner join 
	ratings r on m.id = r.movie_id
group by 
	production_company
limit 3;

-- the top three production houses based on the number of votes received by their movies are 'Marvel Studios', 'Twentieth Century Fox', 
-- and 'Warner Bros.'


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select n.name as actor_name, 
		sum(r.total_votes) as total_votes, 
		count(m.id) as movie_count, 
        round(sum(r.avg_rating * r.total_votes)/sum(r.total_votes),2) as actor_avg_rating,
		row_number() over(order by round(sum(r.avg_rating * r.total_votes)/sum(r.total_votes),2) desc) as actor_rank
from 
	movie m
		inner join 
	ratings r on m.id = r.movie_id
		inner join 
	role_mapping rm on m.id = rm.movie_id
		inner join 
	names n on rm.name_id = n.id
where 
	country regexp 'India' 
    and category = 'actor'
group by 
	n.name 
having 
	count(m.id) >=5;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select 
	n.name as actress_name, 
    sum(r.total_votes) as total_votes,
	count(m.id) as movie_count,
	round(sum(r.total_votes * r.avg_rating)/sum(r.total_votes),2) as actress_avg_rating,
	row_number() over(order by round(sum(r.total_votes * r.avg_rating)/sum(r.total_votes),2) desc) as actress_rank
from 
	movie m
		inner join 
	ratings r on m.id = r.movie_id
		inner join 
	role_mapping rm on rm.movie_id = m.id
		inner join 
	names n on n.id = rm.name_id
where 
	category = 'actress' 
    and country regexp 'India' 
    and languages regexp 'hindi'
group by 
	actress_name
having 
	movie_count >=3
limit 5;

-- Top 5 actress in Hindi movies released in India based on their average ratings are 'Taapsee Pannu', 'Kriti Sanon', 'Divya Dutta', 'Shraddha Kapoor', 'Kriti Kharbanda'

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

select 
	m.title, 
    r.avg_rating,
	(case 
		when avg_rating > 8 then 'Superhit movies'
		when avg_rating between 7 and 8 then 'Hit movies'
		when avg_rating between 5 and 7 then 'One-time-watch movies'
		else 'Flop movies' end) as Rating_Type
from 
	movie m
		inner join 
	ratings r on m.id = r.movie_id
		inner join 
	genre g on g.movie_id = m.id
where 
	genre = 'thriller';


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select 
	genre, 
    round(avg(duration),2) as avg_duration,
	sum(round(avg(duration),2)) over(order by genre) as running_total_duration,
	round(avg(round(avg(duration),2)) over(order by genre rows between unbounded preceding and 0 following), 2) as moving_avg_duration
from 
	genre g
		inner join 
	movie m on g.movie_id = m.id
		inner join 
	ratings r on m.id = r.movie_id
group by 
	genre;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
with top_3_genre as
(select 
	g.genre, 
    count(m.id) as movie_count
from 
	genre g
		inner join 
	movie m on m.id = g.movie_id
group by 
	genre
order by 
	movie_count desc 
limit 3),

-- the top five movies from each of the top three genres for each year based on worldwide gross income in dollars.

top_5_movies as 
(select 
	g.genre, 
    m.year, 
    m.title as movie_name, 
    worlwide_gross_income,
	row_number() over(partition by m.year order by worlwide_gross_income desc) as movie_rank
from 
	genre g
		inner join 
	movie m on m.id = g.movie_id
		inner join 
	top_3_genre t using (genre)
)
select * 
from 
	top_5_movies
where 
	movie_rank <=5;





-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
with top_prod_house as
(select 
	production_company, 
    count(id) as movie_count,
	dense_rank() over (order by count(id) desc) as prod_comp_rank
from 
	movie m
		inner join 
	ratings r on m.id = r.movie_id
where 
	median_rating >= 8 
    and  POSITION(',' in languages) > 0 
    and production_company is not null
group by 
	production_company)
select * 
from 
	top_prod_house
where 
	prod_comp_rank <=2;

-- the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies are 'Star Cinema' and 'Twentieth Century Fox'

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select 
	name as actress_name, 
    sum(total_votes) as total_votes, 
    count(m.id) as movie_count, 
	round(sum(avg_rating * total_votes)/sum(total_votes), 2) as actress_avg_rating,
	row_number() over(order by count(m.id) desc) as actress_rank
from 
	movie m
		inner join 
	ratings r on m.id = r.movie_id
		inner join 
	genre g on g.movie_id = m.id
		inner join 
	role_mapping rm on rm.movie_id = m.id
		inner join 
	names n on n.id = rm.name_id
where 
	genre = 'drama' 
    and avg_rating >8 
    and category = 'actress'
group by actress_name
limit 3;

-- The top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre are 'Parvathy Thiruvothu', 'Susan Brown', and 'Amanda Lawrence'

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date_published_summary AS
(
SELECT  d.name_id,
		NAME,
		d.movie_id,
		duration,
		r.avg_rating,
		total_votes,
		m.date_published,
		Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
FROM    director_mapping  AS d
			INNER JOIN 
		names AS n 		ON n.id = d.name_id
			INNER JOIN 
		movie AS m		ON m.id = d.movie_id
			INNER JOIN 
		ratings AS r	ON r.movie_id = m.id ), 
top_director_summary AS
(
SELECT *,
	Datediff(next_date_published, date_published) AS date_difference
FROM   
	next_date_published_summary )
SELECT   
	name_id                       AS director_id,
	NAME                          AS director_name,
	Count(movie_id)               AS number_of_movies,
	Round(Avg(date_difference),2) AS avg_inter_movie_days,
	Round(Avg(avg_rating),2)      AS avg_rating,
	Sum(total_votes)              AS total_votes,
	Min(avg_rating)               AS min_rating,
	Max(avg_rating)               AS max_rating,
	Sum(duration)                 AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC 
limit 9;
