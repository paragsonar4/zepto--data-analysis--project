# Zepto Data analysis project


# we have created the dataset zepto and imported the table naming "zepto" 

# data exploration

select *
from `zepto-sql-project.zepto.zepto`
limit 10


-- we have columns "category" : product category
-- "name" name of the product , "mrp" , "discountPercent", "availableQuantity", discountdSellingPrice,weightInGms, outOfStock, quantity





# checking the number of rows

select count(*)
from `zepto-sql-project.zepto.zepto` 

-- we have 3732 records


# check for null values
select *
from `zepto-sql-project.zepto.zepto`
where Category is null or
name is null or
mrp is null or
discountPercent is null or
discountedSellingPrice is null or 
weightInGms is null or
outOfStock is null or 
quantity is null

-- there is no null value is our data


# different product categories availabe 

select count(distinct Category)
from `zepto-sql-project.zepto.zepto`




select distinct Category
from `zepto-sql-project.zepto.zepto`


-- we have 14 different products catgories available 


select * from `zepto-sql-project.zepto.zepto` limit 10




# check how many products are in stock and out of stoch

select outOfStock,
count(name) as in_out_stock
from `zepto-sql-project.zepto.zepto`
group by outOfStock

-- instock product count : 3279
-- out of stock product count : 453



# count the different products 

select count(distinct name) as count_product
from `zepto-sql-project.zepto.zepto`

-- we have 1681 unique products




# chcking product name present multiple time 





select name,
  count(name) as count_
from `zepto-sql-project.zepto.zepto`
group by name
having count_ > 1
order by count_ desc


-- we have may products that appear more than 1 time with different mrp, discounts,and weights



# data cleaning 


select *
from `zepto-sql-project.zepto.zepto`
where mrp = 0 or discountedSellingPrice = 0


# delete this row as mrp cant be 0


delete from `zepto-sql-project.zepto.zepto`
where mrp = 0 or discountedSellingPrice = 0

# we have mrp and discoutedSellingPrice in paise not in rupees as 2500/kg is not possible for onion

# convert the value from paise to rupees

update `zepto-sql-project.zepto.zepto`
set mrp = mrp / 100 ,
discountedSellingPrice = discountedSellingPrice/100


select mrp,discountedSellingPrice
from `zepto-sql-project.zepto.zepto`



# data analysis

# find the top 10 products base on discount percentage 


select distinct name,discountPercent,mrp
from `zepto-sql-project.zepto.zepto`
order by discountPercent desc
limit 10

These 10 products are almost have 50% discount


# find the products with discount percentage more than or equal to 50 %

select distinct name, discountPercent
from `zepto-sql-project.zepto.zepto`
where discountPercent>=50

-- 25 products are having discount 50% and more


# find the product with higher mrp

select  distinct name,mrp
from `zepto-sql-project.zepto.zepto`
order by mrp desc


# find the products with higher mrp and that are out of stock

select distinct name,mrp
from `zepto-sql-project.zepto.zepto`
where(outOfStock) = TRUE 
order by mrp desc


# calculate the estimated revenue for each category

select
Category, round(sum(discountedSellingPrice * availableQuantity),2) as expected_revenue
from `zepto-sql-project.zepto.zepto`
group by Category
order by expected_revenue desc

# Total expected revenue

select sum(expected_revenue) as total_exp_rev
from (
select
Category, round(sum(discountedSellingPrice * availableQuantity),2) as expected_revenue
from `zepto-sql-project.zepto.zepto`
group by Category
order by expected_revenue desc)


-- Total expected revenue is 2243000



select*
from `zepto-sql-project.zepto.zepto`





# find all the products ehere mrp is more than 500 and discount is less than 10%


select distinct name, mrp, discountPercent
from `zepto-sql-project.zepto.zepto`
where mrp >= 500 and discountPercent < 10
order by mrp desc, discountPercent desc

-- these items are popular and dont need more discounts to sell



# identify the top 5 categories offering highest average discount pecentage

select Category,
round(avg(discountPercent),2) as avg_dis_percentage
from `zepto-sql-project.zepto.zepto`
group by Category
order by avg_dis_percentage desc
limit 5


# classify the products according to their weight 1000 gms and less "low", less than 5000 gms and more than 1000 gms medium and more than 5000 gms bulk


select distinct name, weightInGms,
case 
when weightInGms <= 1000  then "low"
when weightInGms >1000 and weightInGms <= 5000 then "medium"
when weightInGms > 5000 then "bulk"
end as weight_category
from 
`zepto-sql-project.zepto.zepto`
order by weightInGms desc



# find the total inventory weight per category

select 
category,
sum(weightInGms * availableQuantity) as total_weight
from `zepto-sql-project.zepto.zepto`
group by category
order by total_weight desc





























