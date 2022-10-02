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
select location, date, total_cases, population, (total_cases/population)*100 as Infectious_percent from
CovidProjects..CovidDeath where location = 'India' order by 3,4

--Highest Covid Infected Cases per country(location)
select location, population, max(total_cases) as InfectedCases, Max((total_cases/population)*100) as Infectious_percent from
CovidProjects..CovidDeath group by location, population order by Infectious_percent desc

--Highest Motality Count due to Covid per country(location)
select location, max(cast(total_deaths as int)) as TotalDeathCount from CovidProjects..CovidDeath
group by location
order by TotalDeathCount desc

--Highest Motality percent due to Covid per population
select location, max((cast(total_deaths as int)/population)*100) as TotalDeathPercent from CovidProjects..CovidDeath
group by location
order by TotalDeathPercent desc

--Global Motality due to covid per date
select date, sum(cast(new_cases as int)) as Total_New_cases, sum(cast(new_deaths as int)) as Total_New_Deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as TotalDeathPercent 
from CovidProjects..CovidDeath where new_deaths <> 0
group by date
order by date

--Total count of people in the world who is vaccinated
select dh.location, dh.population, vc.people_fully_vaccinated from 
CovidProjects..CovidVaccination vc
join
CovidProjects..CovidDeath dh
on
vc.location = dh.location
and
vc.date = dh.date
where vc.continent is not null and vc.location <> 'world'
order by vc.population desc

--Vaccination by running total per country(location)
select d.date, d.location, v.new_vaccinations, SUM(Convert(int, v.new_vaccinations)) Over (Partition by d.location order by d.location, d.date) as RunningCountPeopleVaccinated
from CovidProjects..CovidDeath d
join
CovidProjects..CovidVaccination v
on
d.date = v.date and
d.location = v.location
where d.continent is not null
order by 2,1


--Percentage for Running total of Vaccinated Vs Population per country(location)
--using CTE
with PopVsVac(date, location, population, new_vaccinations, RollingCountVaccinatedPeople) as
(
select d.date, d.location, d.population,v.new_vaccinations, SUM(Convert(float, v.new_vaccinations)) Over (Partition by d.location order by d.location, d.date) as
RunningCountPeopleVaccinated
from CovidProjects..CovidDeath d
join
CovidProjects..CovidVaccination v
on
d.date = v.date and
d.location = v.location
where d.continent is not null
--order by 2,1
)
--Max percentage of Vaccinated Vs Population per country(location)
select  location, max((RollingCountVaccinatedPeople/population)*100) as maxcount from PopVsVac group by location