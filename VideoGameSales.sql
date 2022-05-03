/*

Video Game Sales Data Exploration 
Skills used: CTE's, Windows Functions, Aggregate Functions

*/

--Stakeholders want to know what is the most lucrative game per platform
select *
from vgsales

--#1 game overall
select *
from vgsales
where global_sales = (select max(global_sales)
						from vgsales)
						
--Top 1 grossing games per year
select *
from (	select game_name, year_, publisher, global_sales, 
	  rank() over(partition by year_ order by global_sales desc) as rnk
		from vgsales
		order by year_ desc) temp
where rnk = 1 

-- We can see the top 20 publishers
select publisher, count(publisher)
from vgsales
group by 1
order by 2 desc
limit 20

--Rank 1 companys producing top amount of games
--We see that during 2005-2009 produced the most games and that EA was the company, holding the
--rank1 position producing those games
select year_, publisher, n_count
from (select year_, publisher, count(*) as n_count,
			rank() over (partition by year_ order by count(*) desc) as rnk
		from vgsales
		group by 1, 2
		order by n_count desc
		) as sub
where rnk =1

--Most of the games are on the top 10 platforms
select *
from (select platform, count(*) as n_count
	 	from vgsales
	  	group by 1
	  	order by n_count desc
	 ) as sub

-- In these instance for platforms we see that the publishers are producing sport games
select *
from (select platform, genre, publisher, count(*) as n_count
	 	from vgsales
	  	group by 1,2,3
	  	order by n_count desc
	 ) as sub
--	 
select *
from (select genre,
	  	avg(global_sales) as avg_global_sales,
	  	sum(global_sales) as sum_global_sales
	  from vgsales
	  where platform ='PS2'
	  group by 1
	  order by 2 desc
	 ) as sub

--Top performing global sales for the platform PS2 for each genre category
select *
from (select *, rank() over (partition by genre order by global_sales desc) as rnk
	  from vgsales
	  where platform ='PS2'
	 ) as sub
where rnk = 1
order by global_sales desc

--Top performing games for each year for ps2
--We see a dip in 2007 within the PS2 category bc the PS3 was released in 2006 and thats 
--when ppl started shifting consoles
select *
from (select *, rank() over (partition by year_ order by global_sales desc) as rnk
	  from vgsales
	  where platform ='PS2'
	 ) as sub
where rnk = 1
order by year_ desc, global_sales desc

--As we see there is a shift in global sales due to shift in 2007 
select *
from (select *, rank() over (partition by year_ order by global_sales desc) as rnk
	  from vgsales
	  where platform ='PS3'
	 ) as sub
where rnk = 1
order by year_ desc, global_sales desc

--We see the PS2 genre in sport and Action make up 30% of all games produced
select *
from (select genre, count(genre)
	  from vgsales
	  where platform ='PS2'
	  group by 1
	  order by count(genre) desc
	 ) as sub
	 
--We see for the top grossing games within there respective category the most they account for is 10%
--of global sales within there genre on the platform PS2
select *
from (select *, rank() over (partition by genre order by global_sales desc) as rnk,
	  sum(global_sales) over(partition by genre) as sum_global_sales
	  from vgsales
	  where platform ='PS2'
	 ) as sub
where rnk = 1
order by sum_global_sales desc

--We also do see the for the global_sales within the rank 1 games within there respective genre 
--for PS2 the global_sales out match the the avg_global_sales by a large margin 
select *
from (select *, rank() over (partition by genre order by global_sales desc) as rnk,
	  sum(global_sales) over(partition by genre) as sum_global_sales,
	  avg(global_sales) over(partition by genre) as avg_global_sales
	  from vgsales
	  where platform ='PS2'
	 ) as sub
where rnk = 1
order by sum_global_sales desc

--Even if we do set avg_global_sales without being genre specific it does not make a difference at
--all compared to any of the genres rank 1 global sales
select *
from (select *, rank() over (partition by genre order by global_sales desc) as rnk,
	  sum(global_sales) over(partition by genre) as sum_global_sales,
	  avg(global_sales) over() as avg_global_sales
	  from vgsales
	  where platform ='PS2'
	 ) as sub
where rnk = 1
order by sum_global_sales desc

---We see the PS2 has been around since 2000-2011
select distinct year_
from vgsales
where platform = 'PS2'
order by 1 desc

--Years associated with the DS
--What we notice the first occurence of a DS game is in 1985, but after it goes from 2004-2014
--and then they start making games again in 2020
select distinct year_
from vgsales
where platform = 'DS'
order by 1 desc

--We see that there is only one game and it was the first iteration of the DS
select *
from vgsales
where platform = 'DS' AND year_ = 1985
order by 1 desc

--There is only one game in the DS in 2020 and it is the only game in 2020
select *
from vgsales
where platform = 'DS' AND year_ = 2020
order by 1 desc

--We notice that as a new platform for comes out it takes a 2-3year shift before people starting 
--adapting to the platform and it starts becoming more lucrative for those games within the moment





