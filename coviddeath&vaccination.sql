select *
from coviddeaths
order by 3,4

select location, date,total_cases, new_cases, total_deaths, population
from coviddeaths
order by 1,2

select location, date,total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where location like '%Afghanistan%'
order by 1,2

/*looking at total cases vs population*/

select location, date, population, (total_cases/population)*100 as DeathPercentage
from coviddeaths
where location like '%states%'
order by 1,2

select location,population, max(total_cases ), max((total_cases/population))*100 as DeathPercentage
from coviddeaths
group by location,population
order by DeathPercentage desc

select location, max(total_deaths) as TotalDeathCount
from coviddeaths
where continent is not null
group by location
order by TotalDeathCount desc


/*global numbers*/
select  sum(new_cases) as TotalNewCases , sum(new_deaths) as TotalNewDeaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from coviddeaths
order by 1,2

/*looking at total population vs vaccination*/

select dea.continent, dea.location , dea.date , dea.population , vac.new_vaccinations
, sum(vac.new_vaccinations) over ( partition by dea.location order by dea.location , dea.date)
as RollingPeopleVaccinated
from coviddeaths dea
join covidvacination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null


/*using CTE*/
with PopvsVac ( continent, location, date, population, new_vaccines, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location , dea.date , dea.population , vac.new_vaccinations
, sum(vac.new_vaccinations) over ( partition by dea.location order by dea.location , dea.date)
as RollingPeopleVaccinated
from coviddeaths dea
join covidvacination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac


/* creating view to store data for later visuization */
create view PercentPopulationVaccinated as
select dea.continent, dea.location , dea.date , dea.population , vac.new_vaccinations
, sum(vac.new_vaccinations) over ( partition by dea.location order by dea.location , dea.date)
as RollingPeopleVaccinated
from coviddeaths dea
join covidvacination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not nullpercentpopulationvaccinated

