# Indian Census 2022
use indiancensus;
select * from population_data;
select * from new_populationdata;
desc population_data;
desc new_populationdata;
alter table `new_population data` rename to new_populationdata;
select * from new_populationdata;
# Counting the number of records in both tables 
select count(*) Total_records from population_data;
select count(*) Total_records from new_populationdata;
# Selcting the data records whose states are jharkhand and bihar
select distinct state from population_data order by state;
select * from  population_data where state in('jharkhand','bihar');
select * from  population_data where state='jharkhand' or state='bihar';
# Total population of india
select sum(population) total_population from new_populationdata;
# Average population growth in india 
select * from population_data;
select round((avg(growth)*100),1) Average_population_growth from population_data;
# Average population growth per state in india 
select state, round(avg(growth*100),2) Average_population_growth from population_data group by state order by Average_population_growth desc;
# Average sex ratio per state in india
select state,round(avg(sex_ratio)) Average_sex_ratio from population_data group by state order by average_sex_ratio desc;
# Average Literacy rate
select state,round(avg(literacy)) Average_literacy_rate from population_data group by state order by Average_literacy_rate desc;
# Average Literacy rate greater than 90
select state,round(avg(literacy)) Average_literacy_rate from population_data group by state having Average_literacy_rate>90 order by 
Average_literacy_rate desc;
# Three states with the highest average growth ratio
select state, round(avg(growth)*100,2) Average_population_growth from population_data group by state order by Average_population_growth desc limit 3;
# Three states with the least average sex_ratio
select state, round(avg(sex_ratio)) Average_sex_ratio from population_data group by state order by Average_sex_ratio asc limit 3;
# Three states with highest and lowest literacy rate
select * from population_data;
(select state,round(avg(literacy)) Average_literacy_rate from population_data group by state order by average_literacy_rate desc limit 3) union
(select state,round(avg(literacy)) Average_literacy_rate from population_data group by state order by average_literacy_rate  limit 3);
# States which are starting with the letter "a"
select distinct state from population_data where state like "a%";
# States which are starting with the letter "a" or "b"
select distinct state from population_data where state like ("a%") or state like "b%" order by  state;
# States which are starting with the letter "a" or ending with the letter "d"
select distinct state from population_data where state like "a%" or state like "%d";
select * from population_data;
select * from new_populationdata;
# Number of males and females per state 
select * from population_data;
# Adding population column from population_data table to new_populationdata table
select pd.District,pd.state,(pd.sex_ratio/1000) sex_ratio,npd.population from population_data pd inner join new_populationdata npd on 
pd.District=npd.District;
# Calculating the total number of males and females
select state,sum(males) Males_per_state,sum(females) Females_per_state from 
(select a.district,a.state,round((a.population/sex_ratio+1)) Males,round(((a.population*sex_ratio)/sex_ratio+1)) Females from
(select pd.District,pd.state,(pd.sex_ratio/1000) sex_ratio,npd.population from population_data pd inner join new_populationdata npd on 
pd.District=npd.District)a)b group by State order by state;
# Total literacy rate based on population in each state 
alter table population_data rename column literacy to literacy_ratio;
select state,sum(literate_people) Total_literate_people,sum(non_literates) Total_Illitrates from
(select district,state,round((a.Literacy_ratio*population)) Literate_people,round((1-(a.Literacy_ratio))*population) Non_Literates from
(select pd.district,pd.state,(pd.literacy_ratio/100) Literacy_ratio,npd.population from population_data pd inner join new_populationdata npd 
on pd.district=npd.district)a)b group by state order by state;
# Population in previous and current census per state
select state,sum(previous_census_population),sum(current_census_population) from
(select district,state,round((population/(1+growth))) previous_census_population, population current_census_population from
(select pd.district,pd.state,pd.growth,npd.population from population_data pd inner join new_populationdata npd on pd.district=
npd.district)a)b group by state order by state;
# Total population in previous and current census
select  sum(pcp) Previous_census_population ,sum(ccp) Current_census_population from 
(select state,sum(previous_census_population) PCP,sum(current_census_population) CCP from
(select district,state,round((population/(1+growth))) previous_census_population, population current_census_population from
(select pd.district,pd.state,pd.growth,npd.population from population_data pd inner join new_populationdata npd on pd.district=
npd.district)a)b group by state order by state)c;
# Population versus area
select * from new_populationdata;
 select total_area/Previous_census_population,total_area/Current_census_population from
(select e.*,f.total_area from
(select 1 as keyy,d.* from
(select  sum(pcp) Previous_census_population ,sum(ccp) Current_census_population from 
(select state,sum(previous_census_population) PCP,sum(current_census_population) CCP from
(select district,state,round((population/(1+growth))) previous_census_population, population current_census_population from
(select pd.district,pd.state,pd.growth,npd.population from population_data pd inner join new_populationdata npd on pd.district=
npd.district)a)b group by state order by state)c)d)e inner join(
select 1 as keyy,a.* from (select sum(Area_km2) total_area from new_populationdata)a)f on e.keyy=f.keyy)g;
# Top three districts from each state having the highest literacy_ratio
select * from population_data;
select district,state,literacy_ratio from population_data order by state,literacy_ratio desc;

select a.* from 
(select district,state,literacy_ratio,rank() over (partition by state order by literacy_ratio desc) rnk from population_data)a 
where a.rnk in (1,2,3) order by state;





