SELECT Position
FROM dbo.Player_Info;

SELECT * 
FROM dbo.Player_Info
	INNER JOIN dbo.Player_Athletic_Performance
	ON dbo.Player_Athletic_Performance.Player_ID = dbo.Player_Info.Player_ID
WHERE (Position = 'DT');

--Creating the grades for the significant combine events for that position
SELECT Player_Name, 
	Position,

	(CASE
		WHEN [Fourty_sec] < 4.85 THEN 10
		WHEN [Fourty_sec] < 4.9 AND [Fourty_sec] >= 4.85 THEN 9.5
		WHEN [Fourty_sec] < 4.95 AND [Fourty_sec] >= 4.9 THEN 9.0
		WHEN [Fourty_sec] < 5.0 AND [Fourty_sec] >= 4.95 THEN 8.5
		WHEN [Fourty_sec] < 5.05 AND [Fourty_sec] >= 5.0 THEN 8.0
		WHEN [Fourty_sec] < 5.15 AND [Fourty_sec] >= 5.05 THEN 7.0
		WHEN [Fourty_sec] < 5.25 AND [Fourty_sec] >= 5.15 THEN 6.0
		WHEN [Fourty_sec] < 5.35 AND [Fourty_sec] >= 5.25 THEN 5.0

		WHEN [Fourty_sec] IS NULL THEN NULL
		
		ELSE 4.0

	END) AS DT_FourtyGrade,

	(CASE
		WHEN [Vertical_in] >= 32.0 THEN 10
		WHEN [Vertical_in] >= 30 AND [Vertical_in] < 32 THEN 9.5
		WHEN [Vertical_in] >= 29 AND [Vertical_in] < 30 THEN 9.0
		WHEN [Vertical_in] >= 28 AND [Vertical_in] < 29 THEN 8.5
		WHEN [Vertical_in] >= 27 AND [Vertical_in] < 28 THEN 8.0
		WHEN [Vertical_in] >= 25 AND [Vertical_in] < 27 THEN 7.0
		WHEN [Vertical_in] >= 23 AND [Vertical_in] < 25 THEN 6.0
		WHEN [Vertical_in] >= 21 AND [Vertical_in] < 23 THEN 5.0

		WHEN [Vertical_in] IS NULL THEN NULL
		
		ELSE 4.0

	END) AS DT_VerticalGrade,

	(CASE
		WHEN [Broad_Jump_in] >= 120 THEN 10
		WHEN [Broad_Jump_in] >= 117 AND [Broad_Jump_in] < 120 THEN 9.5
		WHEN [Broad_Jump_in] >= 115 AND [Broad_Jump_in] < 117 THEN 9.0
		WHEN [Broad_Jump_in] >= 113 AND [Broad_Jump_in] < 115 THEN 8.5
		WHEN [Broad_Jump_in] >= 110 AND [Broad_Jump_in] < 113 THEN 8.0
		WHEN [Broad_Jump_in] >= 107 AND [Broad_Jump_in] < 110 THEN 7.0
		WHEN [Broad_Jump_in] >= 104 AND [Broad_Jump_in] < 107 THEN 6.0
		WHEN [Broad_Jump_in] >= 100 AND [Broad_Jump_in] < 104 THEN 5.0

		WHEN [Broad_Jump_in] IS NULL THEN NULL
		
		ELSE 4.0

	END) AS DT_BroadJumpGrade

	INTO DefensiveTackleGrades

FROM dbo.Player_Info
	INNER JOIN dbo.Player_Athletic_Performance
	ON dbo.Player_Athletic_Performance.Player_ID = dbo.Player_Info.Player_ID
WHERE (Position = 'DT');

SELECT *
FROM dbo.DefensiveTackleGrades;

--Add columns (overall grade and player draft pick) to the position 
ALTER TABLE dbo.DefensiveTackleGrades
	ADD AthleticGrade FLOAT
	ADD DraftPick INT;

SELECT *
FROM dbo.DefensiveTackleGrades;

--Need to delete the players that didn't attend the combine
SELECT * FROM dbo.DefensiveTackleGrades
	WHERE (DT_BroadJumpGrade IS NULL)
		AND (DT_FourtyGrade IS NULL)
		AND (DT_VerticalGrade IS NULL)

DELETE FROM dbo.DefensiveTackleGrades
	WHERE (DT_BroadJumpGrade IS NULL)
		AND (DT_FourtyGrade IS NULL)
		AND (DT_VerticalGrade IS NULL)

SELECT *
FROM dbo.DefensiveTackleGrades;


--Need to change the overall athletic grade
--Code has to be done in order unless you want to add extra code to the qery. 
	--EX: The columns with single Nulls will alter the columns with multiple Nulls while the 'AthleticGrade' calculation is different for both

UPDATE dbo.DefensiveTackleGrades
SET AthleticGrade = (DT_FourtyGrade + DT_BroadJumpGrade + DT_VerticalGrade) / 3

UPDATE dbo.DefensiveTackleGrades
SET AthleticGrade = (DT_VerticalGrade + DT_BroadJumpGrade) / 2
WHERE DT_FourtyGrade IS NULL

UPDATE dbo.DefensiveTackleGrades
SET AthleticGrade = (DT_FourtyGrade + DT_BroadJumpGrade) / 2
WHERE DT_VerticalGrade IS NULL

UPDATE dbo.DefensiveTackleGrades
SET AthleticGrade = (DT_FourtyGrade + DT_VerticalGrade) / 2
WHERE DT_BroadJumpGrade IS NULL

UPDATE dbo.DefensiveTackleGrades
SET AthleticGrade = DT_FourtyGrade
WHERE DT_VerticalGrade IS NULL AND DT_BroadJumpGrade IS NULL

UPDATE dbo.DefensiveTackleGrades
SET AthleticGrade = DT_VerticalGrade
WHERE DT_FourtyGrade IS NULL AND DT_BroadJumpGrade IS NULL

--Update all draft picks for players
UPDATE dbo.DefensiveTackleGrades
SET DraftPick = Draft_Pick
FROM dbo.AllCombineData
WHERE Player_Name = Player

SELECT *
FROM dbo.DefensiveTackleGrades;