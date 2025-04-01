select*
from PortfolioProject.dbo.CovidDeaths
where continent is not NULL
order by 3,4

--select*
--from PortfolioProject.dbo.CovidVaccinations

select location,date,total_cases,new_cases,total_deaths,population 
from PortfolioProject.dbo.CovidDeaths
order by 1,2

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from PortfolioProject.dbo.CovidDeaths
order by 1,2


select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from PortfolioProject.dbo.CovidDeaths
where location like '%states%'
order by 1,2

select location,date,population,total_cases,(total_cases/population)*100 as death_percentage
from PortfolioProject.dbo.CovidDeaths
where location like '%states%'
order by 1,2 


select location,population,MAX(total_cases) as highest_infected_cases,MAX((total_cases/population))*100 as highest_infected_percentage
from PortfolioProject.dbo.CovidDeaths
--where location like '%states%'
group by location,population
order by 1,2 



select location,population,MAX(total_cases) as highest_infected_cases,MAX((total_cases/population))*100 as highest_infected_percentage
from PortfolioProject.dbo.CovidDeaths
--where location like '%states%'
group by location,population
order by highest_infected_percentage desc


select continent,MAX(cast(total_deaths as int )) as deathcount 
from PortfolioProject.dbo.CovidDeaths
--where location like '%states%'
where continent is not NULL
group by continent
order by deathcount  desc


select date,sum(new_cases)as total_cases,sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/
sum(new_cases)*100 as death_percentage
from PortfolioProject.dbo.CovidDeaths
where continent is not null
--where location like '%states%'
group by date
order by 1,2

--use cte(common table expression)

with popvsvac (continent,location,date,population,new_vaccinations,total_people_vaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location  order by dea.location,
dea.date) as total_people_vaccinated  
from PortfolioProject.dbo.CovidDeaths dea
join PortfolioProject.dbo.CovidVaccinations vac
   on dea.date=vac.date
   and  dea.location=vac.location
   where dea.continent is not null
 --  order by 1,2
)
select*,(total_people_vaccinated/population)*100
from popvsvac



--temp table
drop table if exists  #PercentagePopulationVaccinated 
create table #PercentagePopulationVaccinated
(
continent nvarchar(255),          --nvarchar(stores character data in a variable-length field)
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
total_people_vaccinated numeric
)

insert into  #PercentagePopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location  order by dea.location,
dea.date) as total_people_vaccinated  
from PortfolioProject.dbo.CovidDeaths dea
join PortfolioProject.dbo.CovidVaccinations vac
   on dea.date=vac.date
   and  dea.location=vac.location
   where dea.continent is not null
 --  order by 1,2

 select*,(total_people_vaccinated/population)*100
from  #PercentagePopulationVaccinated


--creating view to store data for later visualisation 

use PortfolioProject
go
create view PercentagePopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location  order by dea.location,
dea.date) as total_people_vaccinated  
from PortfolioProject.dbo.CovidDeaths dea
join PortfolioProject.dbo.CovidVaccinations vac
   on dea.date=vac.date
   and  dea.location=vac.location
where dea.continent is not null
 --  order by 1,2