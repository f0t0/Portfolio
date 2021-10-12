/*

Queries used for Tableau Covid Project

*/

-- Table#1 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Project..CovidDeaths
where continent is not null 
order by 1,2

-- Table#2

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From Project..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- Table#3
Select Location, population, MAX(total_cases) as HighestInfectionCount, 
	MAX((total_cases/population))*100 as PercentPopInfected
From Project..CovidDeaths
Where continent is not null
Group by location, population
Order by PercentPopInfected desc

-- Table#4
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,
  MAX((total_cases/population))*100 as PercentPopInfected
From Project..CovidDeaths
Group by location, population, date
order by PercentPopInfected desc

-- Table#5
Select Continent, MAX(cast(total_vaccinations as bigInt)) as TotalVaccinations
From Project..CovidVaccinations
Where continet is not null
Group by continent
Order by TotalVaccinations desc

-- Table#6
Select deaths.continent, deaths.location, deaths.date, deaths.population, vaccinate.new_vaccinations,
	SUM(cast(vaccinate.new_vaccinations as int)) OVER  (Partition by deaths.location Order by deaths.location,
	deaths.date) as RollingPeopleVacinated
From Project..CovidDeaths as deaths
Join Project..CovidVaccinations as vaccinate
	On deaths.location = vaccinate.location
	and deaths.date = vaccinate.date
Where deaths.continent is not null
Order by deaths.location, deaths.date

-- Table#7
Select deaths.location, deaths.population, MAX(cast(vaccinate.total_tests as int)) as HighestTestCount,
  MAX(vaccinate.total_tests/deaths.population)*100 as PercentPopTested
From Project..CovidDeaths as deaths
Join Project..CovidVaccinations as vaccinate
	On deaths.location = vaccinate.location
	and deaths.date = vaccinate.date
Where deaths.continent is not null
Group by deaths.location, deaths.population
Order by HighestTestCount desc

