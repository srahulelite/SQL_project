select * from CovidProjects.dbo.CovidVaccination order by 3,4
select * from CovidProjects..CovidDeath order by 3,4

--Selecting Useful Data
select location, date, total_cases, new_cases, total_deaths, population from
CovidProjects..CovidDeath order by 3,4

--Total Cases Vs Total Deaths in India
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percent from
CovidProjects..CovidDeath where location = 'India' order by 3,4

--Total Cases Vs Total Deaths per Country
--select cast(total_deaths as INT) as total_deaths from
--CovidProjects..CovidDeath
--select location,
--sum(total_cases) as total_cases, 
--sum(total_deaths) as total_deaths,
--(sum(total_deaths)/sum(total_cases))*100 as Death_percent
--from
--CovidProjects..CovidDeath where total_cases is not null AND
--total_deaths is not null group by location

--Total Cases Vs Total Population in India
select location, date, total_cases, population, (total_cases/population)*100 as Death_percent from
CovidProjects..CovidDeath where location = 'India' order by 3,4