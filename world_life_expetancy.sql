# world Life Expectancy Project (Data Cleaning)

SELECT *
FROM world_life_expectancy.worldlifeexpectancy

;


SELECT country, year, concat(country, year), count(concat(country,year))
FROM world_life_expectancy.worldlifeexpectancy
group by country, year, concat(country, year)
having count(concat(country,year)) > 1
;


select *
from(
	select row_id,
	concat(country, year),
	ROW_NUMBER() OVER(PARTITION BY concat(country, year) order by concat(country, year)) as ROW_Num
	FROM world_life_expectancy.worldlifeexpectancy
	) as Row_table
where Row_Num > 1
;


DELETE FROM world_life_expectancy.worldlifeexpectancy
where 
	Row_ID IN (
    select Row_ID
from(
	select row_id,
	concat(country, year),
	ROW_NUMBER() OVER(PARTITION BY concat(country, year) order by concat(country, year)) as ROW_Num
	FROM world_life_expectancy.worldlifeexpectancy
	) as Row_table
where Row_Num > 1
)
;    


SELECT distinct(status)
FROM world_life_expectancy.worldlifeexpectancy
where status <> ''
;

select distinct(country)
FROM world_life_expectancy.worldlifeexpectancy
where status = 'Developing'
;

update world_life_expectancy.worldlifeexpectancy
set status = 'Developing'
where country IN (select distinct(country)
					from world_life_expectancy.worldlifeexpectancy
					where status = 'Developing'); 


UPDATE world_life_expectancy.worldlifeexpectancy t1
join world_life_expectancy.worldlifeexpectancy t2
	on t1.country = t2.country
set t1.status = 'Developing'
where t1.status = ''
and t2.status <> ''
and t2.status = 'Developing'
;


select *
FROM world_life_expectancy.worldlifeexpectancy
where country is null
;


UPDATE world_life_expectancy.worldlifeexpectancy t1
join world_life_expectancy.worldlifeexpectancy t2
	on t1.country = t2.country
set t1.status = 'Developed'
where t1.status = ''
and t2.status <> ''
and t2.status = 'Developed'
;


select *
FROM world_life_expectancy.worldlifeexpectancy
where `Life expectancy` = ''
;

select country, year, `Life expectancy`
FROM world_life_expectancy.worldlifeexpectancy
# where `Life expectancy` = ''
;


select t1.country, t1.year, t1.`Life expectancy`,
t2.country, t2.year, t2.`Life expectancy`,
t3.country, t2.year, t2.`Life expectancy`,
round(t2.`Life expectancy` + t3.`Life expectancy`)/2,1
FROM world_life_expectancy.worldlifeexpectancy t1
join world_life_expectancy.worldlifeexpectancy t2
	on t1.country = t2.country
	and t1.year = t2.year - 1
join world_life_expectancy.worldlifeexpectancy t3
	on t1.country = t3.country
	and t1.year = t3.year + 1
where t1.`Life expectancy` = ''
;

update world_life_expectancy.worldlifeexpectancy t1
join world_life_expectancy.worldlifeexpectancy t2
	on t1.country = t2.country
	and t1.year = t2.year - 1
join world_life_expectancy.worldlifeexpectancy t3
	on t1.country = t3.country
	and t1.year = t3.year + 1
SET t1.`Life expectancy` = (round(t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
where t1.`Life expectancy` = ''
;


# world Life Expectancy Project (Exploratory Data Analysis)



SELECT *
FROM world_life_expectancy.worldlifeexpectancy;

SELECT Country, 
min(`Life expectancy`), 
max(`Life expectancy`),
round(max(`Life expectancy`) - min(`Life expectancy`),1) as Life_increase_15_years
FROM world_life_expectancy.worldlifeexpectancy
group by country
having min(`Life expectancy`) <> 0
and max(`Life expectancy`) <> 0
order by Life_increase_15_years asc;


SELECT year, Round(avg(`Life expectancy`),2)
FROM world_life_expectancy.worldlifeexpectancy
where `Life expectancy` <> 0
and `Life expectancy`<> 0
group by year
order by year
;


SELECT *
FROM world_life_expectancy.worldlifeexpectancy
;



SELECT country, round(avg(`Life expectancy`),1) as Life_exp,round(avg(GDP),1) as GDP
FROM world_life_expectancy.worldlifeexpectancy
group by country
having Life_exp > 0
and GDP > 0
order by GDP desc
;



SELECT 
sum(case when GDP >= 1500 then 1 else 0 end) High_GDP_Count,
avg(case when GDP >= 1500 then`Life expectancy` else null end) High_GDP_Life_expectancy,
sum(case when GDP <= 1500 then 1 else 0 end) Low_GDP_Count,
avg(case when GDP <= 1500 then`Life expectancy` else null end) Low_GDP_Life_expectancy
FROM world_life_expectancy.worldlifeexpectancy
;


SELECT *
FROM world_life_expectancy.worldlifeexpectancy; 

SELECT status, round(avg(`Life expectancy`),1)
FROM world_life_expectancy.worldlifeexpectancy
group by status
; 

SELECT 
status, count(distinct country),round(avg(`Life expectancy`),1)
FROM world_life_expectancy.worldlifeexpectancy
group by status
; 


SELECT country, round(avg(`Life expectancy`),1) as Life_exp,round(avg(BMI),1) as BMI
FROM world_life_expectancy.worldlifeexpectancy
group by country
having Life_exp > 0
and BMI > 0
order by BMI desc
;



SELECT country,
year,
`Life expectancy`,
`Adult Mortality`,
sum(`Adult Mortality`) over(partition by country order by year) as Rolling_total
FROM world_life_expectancy.worldlifeexpectancy
where country like '%united%'
; 














































