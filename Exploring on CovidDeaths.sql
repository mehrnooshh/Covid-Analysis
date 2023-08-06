-- Making sure data has been imported
SELECT count(*) FROM covid_db.coviddeaths;

-- Exploring data on countries and cases
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_db.coviddeaths
WHERE continent <> ''
ORDER BY 1,2;

-- Looking at Total Cases vs. Total Deaths
SELECT  location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100, 2) as death_ratio
FROM covid_db.coviddeaths
WHERE continent <> '';

-- Looking at the US death ratio, if someone got covid in the US between 2020-01-22 and 2021-04-30 which this data is based on
SELECT location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100, 2) as death_ratio
FROM covid_db.coviddeaths
WHERE location LIKE '%states%' AND continent IS NOT NULL
ORDER BY 2 DESC;

-- Looking at the US death ratio, if someone got covid in the US between 2020-01-22 and 2021-04-30 which this data is based on
SELECT location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100, 2) as death_ratio
FROM covid_db.coviddeaths
WHERE location = 'Iran'
ORDER BY 2 DESC;

-- Looking at the number of days for the period which the data has been provided from different countries to compare with Iran's reported days
-- to see how many days they have contributed to report the cases or deaths numbers
SELECT count(location) AS 'days of Iran\'s contribution', (SELECT count(DISTINCT date)
FROM covid_db.coviddeaths) AS total_days
FROM covid_db.coviddeaths
WHERE location = 'Iran';

-- Looking at the number of days for the period which the data has been provided from different countries to compare with Canada's reported days
-- to see how many days they have contributed to report the cases or deaths numbers
SELECT count(location) AS 'days of Canada\'s contribution', (SELECT count(DISTINCT date)
FROM covid_db.coviddeaths) AS total_days
FROM covid_db.coviddeaths
WHERE location = 'Canada';

-- Looking at the number of days for the period which the data has been provided from different countries to compare with the US reported days
-- to see how many days they have contributed to report the cases or deaths numbers
SELECT count(location) AS 'days of the US contribution', (SELECT count(DISTINCT date)
FROM covid_db.coviddeaths) AS total_days
FROM covid_db.coviddeaths
WHERE location LIKE '%states%' AND continent <> '';

-- Finding which countries reported the number of cases continuously for all the 486 days 
SELECT location AS country, count(date) AS contributed_days
FROM covid_db.coviddeaths
WHERE continent <> ''
GROUP BY location
HAVING contributed_days = (SELECT count(DISTINCT date) FROM covid_db.coviddeaths);


-- Finding what percentage of population got Covid in Iran
SELECT location, date, population, total_cases, ROUND((total_cases/population)* 100, 2) AS infection_percentage
FROM covid_db.coviddeaths
WHERE location = 'Iran'
ORDER BY  infection_percentage DESC;

-- Finding what percentage of population got Covid in Canada
SELECT location, date, population, total_cases, ROUND((total_cases/population)* 100,2) AS infection_percentage
FROM covid_db.coviddeaths
WHERE location = 'Canada'
ORDER BY  infection_percentage DESC;

-- What country has the highest infection rate
SELECT location, population, MAX(total_cases) AS highest_infection_count, round(max((total_cases/population)* 100),2) AS highest_infection_percentage
FROM coviddeaths
WHERE continent <> ''
GROUP BY location, population
ORDER BY highest_infection_percentage DESC;

-- Looking at countries with highest death count per population (the reported numbers are accumulative in total_deaths column )
SELECT location AS country, population, MAX(CAST(total_deaths AS UNSIGNED)) AS total_death_count
FROM coviddeaths
WHERE continent <> ''
GROUP BY country, population
ORDER BY total_death_count DESC;

-- LET'S BREAK THINGS DOWN BY CONTINENT. Showing continents with the highest death count per population(the reported numbers are accumulative in total_deaths column )
SELECT continent, MAX(CAST(total_deaths AS UNSIGNED)) AS total_death_count
FROM coviddeaths
WHERE continent <> ''
GROUP BY continent
ORDER BY total_death_count DESC;


-- Cerating View for the future visualizations
CREATE VIEW total_deaths_per_continent AS
-- LET'S BREAK THINGS DOWN BY CONTINENT. Showing continents with the highest death count per population(the reported numbers are accumulative in total_deaths column )
SELECT continent, MAX(CAST(total_deaths AS UNSIGNED)) AS total_death_count
FROM coviddeaths
WHERE continent <> ''
GROUP BY continent;

-- Testing my total_deaths_per_continent view
SELECT * FROM total_deaths_per_continent;

-- Data Cleaning required
SELECT continent, location, date, new_cases 
FROM coviddeaths c 
WHERE new_cases  < 0
ORDER BY new_cases ASC;

-- Create a lOCATION view
CREATE VIEW location_v AS
SELECT  DISTINCT location, iso_code, continent
FROM coviddeaths c 
WHERE continent <> ''
ORDER BY 1;
 
SELECT count(*) FROM location_v 

