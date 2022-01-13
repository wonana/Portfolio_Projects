update Portfolio_1.coviddeaths
set continent= null
where length(continent)=0;

SELECT * FROM Portfolio_1.coviddeaths
where continent is not null
order by 3,4;

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_1.coviddeaths
order by 1,2;

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Portfolio_1.coviddeaths
where location like'%korea%'
order by 1,2;

SELECT Location, date, total_cases, Population, (total_cases/population)*100 as CovidInfection
FROM Portfolio_1.coviddeaths
-- where location like'%korea%'
order by 1,2;

SELECT Location, Population,MAx(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
FROM Portfolio_1.coviddeaths
-- where location like'%korea%'
Group by location,population
order by PercentPopulationInfected desc;

SELECT Location, Max(cast(total_deaths as unsigned)) as TotalDeathCount
FROM Portfolio_1.coviddeaths
-- where location like'%korea%'
where continent is not null
Group by location
order by TotalDeathCount desc;

SELECT location, Max(cast(total_deaths as unsigned)) as TotalDeathCount
FROM Portfolio_1.coviddeaths
-- where location like'%korea%'
where continent is null
Group by location
order by TotalDeathCount desc;

SELECT date, sum(new_cases), sum(new_deaths)
FROM Portfolio_1.coviddeaths
-- where location like'%korea%'
where continent is not null
group by date
order by 1,2;

with PopvsVac (Continent,Location, date, new_vaccinations, RollingPeopleVaccinated)
as 
(
select d.continent,d.date,d.location,v.new_vaccinations,
sum(cast(v.new_vaccinations as unsigned)) over (partition by d.location order by location,d.date) as RollingPeopleVaccinated,
from Portfolio_1.coviddeaths d
join Portfolio_1.covidvaccinations v
	on d.location = v.location
	and d.date = v.date
)    

select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

create table PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
population nvarchar(255)
Date datetime,
New_vaccinations int(11),
RollingPeopleVaccinated int(11)
);
INSERT into PercentPopulationVaccinated(Continent,location,date, new_vaccinations, RollingPeopleVaccinated)
select d.continent,d.date,d.location,d.population, v.new_vaccinations,
sum(cast(v.new_vaccinations as unsigned)) over (partition by d.location order by location,d.date) as RollingPeopleVaccinated,
from Portfolio_1.coviddeaths d
join Portfolio_1.covidvaccinations v
	on d.location = v.location
	and d.date = v.date
    
Select *,(RollingPeopleVaccinated/Population)*100
from PercentPopulationVaccinated

Create View PercentPopulationVaccinated as
select d.continent,d.date,d.location,d.population, v.new_vaccinations,sum(cast(v.new_vaccinations as unsigned)) over (partition by d.location order by location,d.date) as RollingPeopleVaccinated,
From Portfolio_1.coviddeaths d
join Portfolio_1.covidvaccinations v
	on d.location = v.location
	and d.date = v.date




