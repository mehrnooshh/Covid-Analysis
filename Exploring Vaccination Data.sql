
USE covid_db

-- Looking at total vaccination in each country around the world
SELECT dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations, SUM(vac.new_vaccinations ) OVER (PARTITION BY dth.location ORDER BY dth.date) AS rolling_people_vaccinated
FROM covid_db.coviddeaths dth
JOIN covidvaccinations vac 
ON dth.location = vac.location AND dth.`date` = vac.`date` 
WHERE dth.continent <> '' 
ORDER BY 2,3 ASC;

-- Using CTE to calculate the percentage of rolling vaccinated people in each country
WITH popVsVac_cte (continent, location, date, population, new_vaccinations, rolling_people_vaccinated) 
 	AS
		(
		SELECT dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations, SUM(vac.new_vaccinations ) OVER (PARTITION BY dth.location ORDER BY dth.date) AS rolling_people_vaccinated
		FROM covid_db.coviddeaths dth
		JOIN covidvaccinations vac 
		ON dth.location = vac.location AND dth.`date` = vac.`date` 
		WHERE dth.continent <> '' 
		
		)
SELECT *, (rolling_people_vaccinated/population)* 100 AS rolling_vaccinated_percentage
FROM popVsVac_cte


-- Using CTE to calculate the percentage of total rolling vaccinated people in each country
WITH popVsVac_cte (continent, location, date, population, new_vaccinations, rolling_people_vaccinated) 
 	AS
		(
		SELECT dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations, SUM(vac.new_vaccinations ) OVER (PARTITION BY dth.location ORDER BY dth.date) AS rolling_people_vaccinated
		FROM covid_db.coviddeaths dth
		JOIN covidvaccinations vac 
		ON dth.location = vac.location AND dth.`date` = vac.`date` 
		WHERE dth.continent <> '' 
		
		)
SELECT continent, location, population, new_vaccinations, round(max(rolling_people_vaccinated/population) * 100 , 2) AS rolling_vaccination_percent
FROM popVsVac_cte
GROUP BY continent, location, population
ORDER BY rolling_vaccination_percent DESC 


-- Creating a TEMP table for 
DROP TABLE IF EXISTS vaccinated_population_percent_temp;
CREATE TEMPORARY TABLE vaccinated_population_percent_temp
(`continent` varchar(255),
 `location` varchar(255), 
 `date` datetime,`population` int,
  `new_vaccination` int,
  `rolling_vaccinated_people` int)

INSERT INTO vaccinated_population_percent_temp
SELECT dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations, SUM(vac.new_vaccinations ) OVER (PARTITION BY dth.location ORDER BY dth.date) AS rolling_people_vaccinated
FROM covid_db.coviddeaths dth
JOIN covidvaccinations vac 
ON dth.location = vac.location AND dth.`date` = vac.`date` 
WHERE dth.continent <> '' 

SELECT *, (rolling_vaccinated_people/population)*100
FROM vaccinated_population_percent_temp;


-- Create a view for vaccinated population percentage. Looking at total vaccination in each country around the world
CREATE VIEW vaccinated_percentage AS

SELECT dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations, SUM(vac.new_vaccinations ) OVER (PARTITION BY dth.location ORDER BY dth.date) AS rolling_people_vaccinated
FROM covid_db.coviddeaths dth
JOIN covidvaccinations vac 
ON dth.location = vac.location AND dth.`date` = vac.`date` 
WHERE dth.continent <> '' 
