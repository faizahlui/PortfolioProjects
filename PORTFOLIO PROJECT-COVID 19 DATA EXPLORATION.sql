/*
COVID-19 data exploration
Data source: https://ourworldindata.org/covid-deaths
Software used: SQL SERVER MANAGEMENT STUDIO (SSMS)
Skills used: Joins, CTE's, Temp Tables, Aggregate Functions, 
Creating Views, Converting Data Types
*/


--Checking data 
SELECT * 
FROM PortfolioProjectAlex..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 2, 3

SELECT * 
FROM PortfolioProjectAlex..CovidVaccinations
WHERE continent IS NOT NULL
ORDER BY 2, 3

--Select data that we are going to start with

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProjectAlex..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at Total cases vs total deaths, checking percentage, doing calculation
--Shows the likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths
,(total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProjectAlex..CovidDeaths
WHERE location = 'Malaysia'
ORDER BY 1,2

-- Looking at the total cases vs population 
--Shows what percentage of population infected covid 

SELECT location, date, total_cases, population, 
(total_cases/population)*100 AS InfectionPercent
FROM PortfolioProjectAlex..CovidDeaths
WHERE location = 'Malaysia'
ORDER BY 1,2

--What countries have the highest infection rates to be compared with the population 

SELECT location, population, MAX(total_cases) AS highest_infection_count
,MAX(total_cases/population)*100 AS percent_population_infected
FROM PortfolioProjectAlex..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY 4 DESC

--What countries have the highest DEATH rates to be compared with the population

SELECT location, 
MAX(CAST (total_deaths AS int)) AS highest_death_count
FROM PortfolioProjectAlex..CovidDeaths
GROUP BY location
ORDER BY highest_death_count DESC 

---- Countries with Highest Death Count per Population

SELECT location
, MAX(CAST (total_deaths AS int)) highest_death_count
FROM PortfolioProjectAlex..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing continents with the highest death count per population 

SELECT  continent
,MAX(CAST (total_deaths AS int)) highest_death_count
FROM PortfolioProjectAlex..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC


--GLOBAL NUMBERS

-- Shows wordwide death percentage 

SELECT SUM(new_cases) AS total_cases
,SUM(CAST(new_deaths AS int)) AS total_deaths
,(SUM(CAST(new_deaths AS int))/ SUM(new_cases))*100  AS death_percentage
FROM PortfolioProjectAlex..CovidDeaths

-- Shows death percentage over total daily cases daily

SELECT  date
,SUM(total_cases) AS Total_Daily_Cases
,SUM(CAST (total_deaths AS int)) AS Total_Death_Cases
,(SUM(CAST (total_deaths AS int))/ SUM(total_cases)) * 100 AS death_pecentage
FROM PortfolioProjectAlex..CovidDeaths 
GROUP BY date
ORDER BY  1

-- Total Population Vs Vaccination 
-- Shows percentage of population that has received covid vaccine 

SELECT dea.continent
,SUM(dea.population) AS total_population 
,SUM(CAST (vac.total_vaccinations AS bigint)) AS total_vaccine 
,SUM(CAST (vac.total_vaccinations AS bigint)) / SUM(dea.population)  AS vaccination_percentage 
FROM PortfolioProjectAlex..CovidDeaths dea
JOIN PortfolioProjectAlex..CovidVaccinations vac
	ON dea.location =vac.location
	AND dea.date =vac.date 
WHERE dea.continent  IS NOT NULL
GROUP BY dea.continent
ORDER BY continent

-- Total Population Vs Vaccination 
-- Shows percentage of population that has received covid vaccine 

SELECT dea.continent, dea.location, dea.date, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations))OVER (PARTITION BY dea.location 
	ORDER BY dea.location, dea.Date)AS RollingPeopleVaccinated
FROM PortfolioProjectAlex..CovidDeaths dea
JOIN PortfolioProjectAlex..CovidVaccinations vac
	ON dea.location =vac.location
	AND dea.date =vac.date 
WHERE dea.continent  IS NOT NULL 
ORDER BY 1,2,3

-- USING CTE to perfom calculation on Partition By in previous query

WITH PopVsVac (Continent, Location, Date,Population,New_vaccinations
,RollingPeopleVaccinated)
as(
SELECT dea.continent, dea.location, dea.date
,dea.population,vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations))OVER (PARTITION BY dea.location 
	ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProjectAlex..CovidDeaths dea
JOIN PortfolioProjectAlex..CovidVaccinations vac
	ON dea.location =vac.location
	AND dea.date =vac.date 
WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated / Population)* 100 AS vaccinated_percent
FROM PopVsVac
WHERE location='Malaysia'

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255), 
Date datetime,
Population numeric, 
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent,dea.location, dea.date
,dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) 
AS RollingPeopleVaccinated
FROM PortfolioProjectAlex..CovidDeaths dea
JOIN PortfolioProjectAlex..CovidVaccinations vac
	ON dea.location =vac.location
	AND dea.date =vac.date 
WHERE dea.continent IS NOT NULL

SELECT *, (RollingPeopleVaccinated / Population) *100 AS VaccinationPercentage 
FROM #PercentPopulationVaccinated

--CREATING VIEW TO STORE DATA FOR VISUALIZATIONS 

CREATE VIEW PercentPopulationVaccinated AS 
SELECT dea.continent,dea.location, dea.date
,dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) 
AS RollingPeopleVaccinated
FROM PortfolioProjectAlex..CovidDeaths dea
JOIN PortfolioProjectAlex..CovidVaccinations vac
	ON dea.location =vac.location
	AND dea.date =vac.date 
WHERE dea.continent IS NOT NULL