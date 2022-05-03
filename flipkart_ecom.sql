--most expensive model
select *
from flipkart_ecom

--In this instance we are seeing the most expensive phone
select *
from flipkart_ecom
where selling_price = (select max(selling_price)
					 	from flipkart_ecom
					 )

-- We are seeing the phone with the cheapest selling price
-- Which is the Nokia 105
select *
from flipkart_ecom
where selling_price = (select min(selling_price)
					 	from flipkart_ecom
					 )			

-- We see how that apple products are the most popular listing
select ref_id, count(*) as n_count 
from flipkart_ecom
group by 1
order by 2 desc
limit 10

-- There are a total of 3114 listing on flipkart for phone
select count(*) as n_count 
from flipkart_ecom

-- There a total of 17 different brand
select brand, count(*) as n_count
from flipkart_ecom
group by 1
order by 2 desc

-- There is a total of 928 different listing of models
select brand, model, count(*) as n_count
from flipkart_ecom
group by 1, 2
order by 3 desc

-- Starting to evaluate apple
select *
from flipkart_Ecom
where brand = 'Apple'

-- We see the cheapest listing for Apple, which is the iphone7, has a selling price 24999 rupees
select *
from flipkart_ecom
where lower(brand) = 'apple' 
and selling_price = (select min(selling_price)
					  from flipkart_ecom
					  where brand = 'Apple'
					 )

-- Most expensive listing for Apple, is the iphone13 Pro Max, has selling price of 179900 rupees
-- and comes in a variety of colors, memory, and storage
select *
from flipkart_ecom
where lower(brand) = 'apple' 
and selling_price = (select max(selling_price)
					  from flipkart_ecom
					  where brand = 'Apple'
					 )

-- Highest Rating Iphone is iphone7 Plus in red
select *
from flipkart_Ecom
where brand = 'Apple'
and rating = (select max(rating)
			  from flipkart_ecom
			  where brand = 'Apple'
			 )
-- We see the most average expensive color to buy is the sierra blue
select color, round(avg(selling_price),2), round(avg(original_price),2)
from flipkart_ecom
where brand = 'Apple'
group by 1
order by 2 desc, 3 desc

-- Top colors for the selling_price. As we see it is for the newest phones available
select * 
from (
	select *, rank() over(partition by color order by selling_price desc) as rnk
	from flipkart_ecom
	where brand = 'Apple' and rating is not null
	) as sub
where rnk = 1

-- Top 10 color listings for Apple
select color, count(*) as n_count
from flipkart_ecom
where brand = 'Apple'
group by 1
order by 2 desc
limit 10

-- Most listings for the specific brand
select ref_id, count(*) as n_count
from flipkart_ecom
where brand = 'Apple'
group by 1
order by 2 desc

-- Here we see a distribution of our phones by selling_price, notice that the higher your memory 
-- and storage_space, the more expensive your phone will be. We do have an anamoly though because 
-- someone put there Iphone11 4GB memory and 64GB storage at a higher price, compared to the other
-- listings that were cheaper, but people still bought it
select *, min(selling_price) over() min_price, max(selling_price) over() max_price
from flipkart_ecom
where ref_id = 'Apple iPhone 11 '
order by selling_price desc

-- The IphoneXR has a drop off by almost half in price by reducing its storage space from 
-- 256GB to 128GB, it is marginal when you compare the storage space from 128GB to 64GB. Your best
-- choice if you are to buy an IPhoneXR and want a little more storage space go for the 128GB
select *, min(selling_price) over() min_price, max(selling_price) over() max_price
from flipkart_ecom
where ref_id = 'Apple iPhone XR '
order by selling_price desc

-- The top 5 mobile brands make up 60% of all listings on the platform
with cte as (
	select brand, ((COUNT(*) / (SUM(COUNT(*)) OVER() )) * 100) as perc_of_total
	from flipkart_ecom
	group by 1
	order by 2 desc
)
select *
from (
	select *, rank() over(order by cte.perc_of_total desc) as rnk
	from cte
	) as sub
where sub.rnk <= 5

-- Since Samsung have the most listings let us explore that next
select *
from flipkart_ecom
where brand ILIKE 'samsung'

-- Top 10 Cheapest Samsung Phones 
with cte as (
	select *
	from (
		select *, (selling_price / (avg(selling_price) over() ))-1 avg_price
		from flipkart_ecom
		where brand ILIKE 'samsung'
	) as sub
	order by avg_price asc
)

select *
from (select *, rank() over(order by cte.avg_price) as rnk
	 	from cte
	 ) as sub
where rnk <= 10	 
--
select selling_price, min(selling_price)
from flipkart_ecom
group by 1
order by 2 asc
