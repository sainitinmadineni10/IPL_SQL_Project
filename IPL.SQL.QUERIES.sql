SELECT *
FROM ipl_project.cricket_data1
LIMIT 10

-- IPL-SQL-PROJECT

-- 1. Team With Most Wins
SELECT winner, COUNT(*) AS total_wins
FROM ipl_project.cricket_data1
GROUP BY winner
ORDER BY total_wins DESC

-- 2. Most Successful Captains
SELECT CASE
WHEN winner=home_team then home_captain
WHEN winner=away_team then away_captain
END AS winning_captain, COUNT(*) AS total_wins
FROM ipl_project.cricket_data1
WHERE winner is NOT NULL
GROUP BY winning_captain
ORDER BY total_wins DESC 

-- OR 
SELECT captain, SUM(wins) AS total_wins
FROM (
SELECT home_captain AS captain, COUNT(*) AS wins
FROM ipl_project.cricket_data1
WHERE winner=home_team
GROUP BY home_captain
UNION ALL 
SELECT away_captain AS captain, COUNT(*) AS wins
FROM ipl_project.cricket_data1
WHERE winner=away_team
GROUP BY away_captain
) AS combined

GROUP BY captain
ORDER BY total_wins DESC

-- 3. Toss Decision Analysis
SELECT decision, COUNT(*) as TOTAL_MATCHES 
FROM ipl_project.cricket_data1
GROUP BY decision 

-- 4. Toss Winner vs Match Winner
SELECT COUNT(*) as matches, 
SUM(CASE WHEN toss_won=winner THEN 1 ELSE 0 END) AS toss_win_match_win 
FROM ipl_project.cricket_data1

-- 5. Highest Scoring Matches 
SELECT short_name, venue_name, home_team, away_team, home_runs+away_runs AS total_runs, winner
FROM ipl_project.cricket_data1
ORDER BY total_runs DESC
LIMIT 10

-- 6. Team with highest Avg score
SELECT team, AVG(runs) as avg_score
FROM
(
SELECT home_team as team,
home_runs as runs
FROM ipl_project.cricket_data1
UNION ALL
SELECT away_team as team,
away_runs as runs
FROM ipl_project.cricket_data1
) as combined
GROUP BY team
ORDER BY avg_score DESC

-- 7. Venue hosting most matches
SELECT venue_name, COUNT(*) AS no_of_matches
FROM ipl_project.cricket_data1
GROUP BY venue_name
ORDER BY no_of_matches DESC

-- 8.Most player of the matches award
SELECT pom, COUNT(*) as Most_pom
FROM ipl_project.cricket_data1
WHERE pom IS NOT NULL
AND pom <> ''
GROUP BY pom
ORDER BY Most_pom DESC

-- 9. Season wise match count
SELECT season, COUNT(*) as match_count
FROM ipl_project.cricket_data1
GROUP BY season
ORDER BY match_count DESC

-- 10. Teams winning most while chasing 
SELECT winner, COUNT(*) as chase_wins
FROM ipl_project.cricket_data1
WHERE decision='BOWL FIRST'
GROUP BY winner
ORDER BY chase_wins DESC

-- 11. Teams winning most while batting first
SELECT winner, COUNT(*) AS total_matches_batfirst
FROM ipl_project.cricket_data1
WHERE decision='BAT FIRST'
GROUP BY winner
ORDER BY total_matches_batfirst DESC

-- 11. Home team win percentage 
SELECT home_team, COUNT(*) AS total_home_matches,
SUM(
	CASE
		WHEN winner=home_team THEN 1 
		ELSE 0
		END
) AS home_wins,

ROUND(
	SUM(
		CASE
			WHEN winner=home_team THEN 1 
			ELSE 0
			END
)*100/COUNT(*),2) AS win_percentage
FROM ipl_project.cricket_data1
GROUP BY home_team
ORDER BY win_percentage DESC

-- 12. Closest Matches
SELECT short_name,home_team, away_team, home_runs, away_runs,
ABS(home_runs - away_runs) AS run_difference
FROM ipl_project.cricket_data1
WHERE ABS(home_runs - away_runs) =0