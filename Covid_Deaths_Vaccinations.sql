/*
Covid 19 Exploration 
Skills used: Joins, CTE's, Temp Tables Aggregate Functions, Creating Views, Converting Data Types

*/
Select *
From Project..CovidDeaths
Where continent is not null
order by 3,4


-- Select Data that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
From Project..CovidDeaths
Where continent is not null
order by Location, date

--Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid within us countries

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Project..CovidDeaths
Where location like '%states%' and continent is not null
order by Location, date

--Looking at Total Cases vs Population
--Shows what percentage of population that has gotten Covid

Select Location, date, total_cases, population, (total_cases/population)*100 as PercentPopInfected
From Project..CovidDeaths
Where continent is not null
order by Location, date

-- Looking at countries with highest infection rate compared to population

Select Location, population, MAX(total_cases) as HighestInfectionCount, 
	MAX((total_cases/population))*100 as PercentPopInfected
From Project..CovidDeaths
Where continent is not null
Group by location, population
Order by PercentPopInfected desc

--Showing countries with highest death count per population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From Project..CovidDeaths
Where continent is not null
Group by location
order by TotalDeathCount desc


-- Showing continents with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From Project..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- Worldwide Numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
	SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From Project..CovidDeaths
Where continent is not null
order by 1,2


--Looking at total population vs vaccination

Select deaths.continent, deaths.location, deaths.date, deaths.population, vaccinate.new_vaccinations,
	SUM(cast(vaccinate.new_vaccinations as int)) OVER  (Partition by deaths.location Order by deaths.location,
	deaths.date) as RollingPeopleVacinated
From Project..CovidDeaths as deaths
Join Project..CovidVaccinations as vaccinate
	On deaths.location = vaccinate.location
	and deaths.date = vaccinate.date
Where deaths.continent is not null
Order by deaths.location, deaths.date



--Temp Table 

Drop Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

--Inserting data into table 

Insert into PercentPopulationVaccinated
Select deaths.continent, deaths.location, deaths.date, deaths.population, vaccinate.new_vaccinations,
	SUM(cast(vaccinate.new_vaccinations as int)) OVER  (Partition by deaths.location Order by deaths.location,
	deaths.date) as RollingPeopleVacinated
From Project..CovidDeaths as deaths
Join Project..CovidVaccinations as vaccinate
	On deaths.location = vaccinate.location
	and deaths.date = vaccinate.date
Where deaths.continent is not null

Select *, (RollingPeopleVaccinated/population)*100
From PercentPopulationVaccinated


-- Creating View visualizations

Create View PercentPopulationVaccinatedv01 as 
Select deaths.continent, deaths.location, deaths.date, deaths.population, vaccinate.new_vaccinations,
	SUM(cast(vaccinate.new_vaccinations as int)) OVER  (Partition by deaths.location Order by deaths.location,
	deaths.date) as RollingPeopleVacinated
From Project..CovidDeaths as deaths
Join Project..CovidVaccinations as vaccinate
	On deaths.location = vaccinate.location
	and deaths.date = vaccinate.date
Where deaths.continent is not null

Select *
From PercentPopulationVaccinatedv01