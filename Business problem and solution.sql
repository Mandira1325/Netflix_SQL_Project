create table netflix
(   show_id varchar(6),
	type varchar(10),	
	title varchar(150),	
	director varchar(210),	
	casting varchar(1000),	
	country	varchar(150),
    date_added varchar(50),
	release_year int,	
	rating varchar(10),
	duration varchar(15),	
	listed_in varchar(100),	
	description varchar(250)
);
select * from netflix;

select count(*) from netflix;

select distinct type from netflix;

-- 1. Count the number of Movies vs TV Shows
select type ,count( distinct show_id) as counting
from netflix
group by type;


-- 2. Find the most common rating for movies and TV shows

select rating , type , counting
from (
select rating ,type ,count(*) as counting, 
rank() over(partition by type order by count(*) desc) as ranking
from netflix 
group by rating ,type) as a 
where ranking =1

-- 3. List all movies released in a specific year (e.g., 2020)
select *
from netflix
where type ='Movie' and 
	  release_year =2020;


-- 4. Find the top 5 countries with the most content on Netflix

select new_country , counting 
from (
select trim(unnest(string_to_array(country,','))) as new_country, count(show_id) as counting , 
dense_rank() over(order by count(show_id) desc) as ranking
from netflix
group by  trim(unnest(string_to_array(country,',')))) as a 
where ranking <=5;

-- 5. Identify the longest movie

select *
from netflix
where type ='Movie'and 
	  duration =(select max(duration) from netflix);

-- 6. Find content added in the last 5 years
select * 
from netflix
where  cast(date_added as date)>= current_date - INTERVAL '5 YEARS';


-- or 
select *, to_DATE(date_added , 'Month DD , YYYY')
FROM NETFLIX
WHERE to_DATE(date_added , 'Month DD , YYYY')>= CURRENT_DATE -INTERVAL '5 YEARS';


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT * 
FROM NETFLIX 
WHERE lower(DIRECTOR) like '%rajiv chilaka%';

-- 8. List all TV shows with more than 5 seasons

select * 
from netflix
where type ='TV Show' and 
cast(split_part(duration , '', 1) as int) >5;

-- 9. Count the number of content items in each genre

select trim(unnest(string_to_array(listed_in , ','))) as genre , count(show_id) as counting
from netflix
group by trim(unnest(string_to_array(listed_in , ',')));


-- 10.Find each year and the average numbers of content release in India on netflix. 
select extract(year from to_DATE(date_added , 'Month DD , YYYY')) as year , 
	   count(*) as yearly_count, 
	   round(count(*)::numeric/
	   		(select count(*) from netflix where country ='India')::numeric*100,2) as average
from netflix
where country ='India'
group by  extract(year from to_DATE(date_added , 'Month DD , YYYY'))  ;

-- 11. List all movies that are documentaries

select * 
from netflix
where type ='Movie'
and listed_in like '%Documentaries';

-- 12. Find all content without a director
select * 
from netflix 
where director is null;


-- 13. Find how many movies actor 'Salman Khan' appeared in last 11 years!

select count(*) as total_movie_count
from (
select *
from netflix 
where release_year >=extract(year from current_date)-11
and casting ilike '%salman khan%' ) ;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select casts , movies_count
from (
select trim(unnest(string_to_array(casting , ','))) as casts , count(*) as movies_count, 
dense_rank() over(order by count(*) desc) as ranking
from netflix
where country ilike '%india%'
group by trim(unnest(string_to_array(casting , ',')))) as a 
where ranking<=10
;


-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

with cte as (select * , 
case when description Ilike '%kill%' or description Ilike '%violence%' then 'Bad'
else 'Good' end as category
from netflix ) 
select category ,count(*)
from cte
group by category;







