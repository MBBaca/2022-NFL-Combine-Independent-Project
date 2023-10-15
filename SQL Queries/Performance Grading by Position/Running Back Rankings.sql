SELECT Position
FROM dbo.Player_Info;

SELECT * 
FROM dbo.Player_Info
	INNER JOIN dbo.Player_Athletic_Performance
	ON dbo.Player_Athletic_Performance.Player_ID = dbo.Player_Info.Player_ID
WHERE (Position = 'RB');

--Creating the grades for the significant combine events for that position
SELECT Player_Name, 
	Position,

	(CASE
		WHEN [Fourty_sec] < 4.30 THEN 10
		WHEN [Fourty_sec] < 4.35 AND [Fourty_sec] >= 4.3 THEN 9.5
		WHEN [Fourty_sec] < 4.4 AND [Fourty_sec] >= 4.35 THEN 9.0
		WHEN [Fourty_sec] < 4.45 AND [Fourty_sec] >= 4.4 THEN 8.5
		WHEN [Fourty_sec] < 4.5 AND [Fourty_sec] >= 4.45 THEN 8.0
		WHEN [Fourty_sec] < 4.55 AND [Fourty_sec] >= 4.5 THEN 7.0
		WHEN [Fourty_sec] < 4.6 AND [Fourty_sec] >= 4.55 THEN 6.0
		WHEN [Fourty_sec] < 4.65 AND [Fourty_sec] >= 4.6 THEN 5.0

		WHEN [Fourty_sec] IS NULL THEN NULL
		
		ELSE 4.0

	END) AS RB_FourtyGrade,

	(CASE
		WHEN [Vertical_in] >= 40.0 THEN 10
		WHEN [Vertical_in] >= 38 AND [Vertical_in] < 40 THEN 9.5
		WHEN [Vertical_in] >= 36 AND [Vertical_in] < 38 THEN 9.0
		WHEN [Vertical_in] >= 35 AND [Vertical_in] < 36 THEN 8.5
		WHEN [Vertical_in] >= 34 AND [Vertical_in] < 35 THEN 8.0
		WHEN [Vertical_in] >= 32 AND [Vertical_in] < 34 THEN 7.0
		WHEN [Vertical_in] >= 31 AND [Vertical_in] < 32 THEN 6.0
		WHEN [Vertical_in] >= 30 AND [Vertical_in] < 31 THEN 5.0

		WHEN [Vertical_in] IS NULL THEN NULL
		
		ELSE 4.0

	END) AS RB_VerticalGrade,

	(CASE
		WHEN [Broad_Jump_in] >= 132 THEN 10
		WHEN [Broad_Jump_in] >= 130 AND [Broad_Jump_in] < 132 THEN 9.5
		WHEN [Broad_Jump_in] >= 127 AND [Broad_Jump_in] < 130 THEN 9.0
		WHEN [Broad_Jump_in] >= 124 AND [Broad_Jump_in] < 127 THEN 8.5
		WHEN [Broad_Jump_in] >= 122 AND [Broad_Jump_in] < 124 THEN 8.0
		WHEN [Broad_Jump_in] >= 120 AND [Broad_Jump_in] < 122 THEN 7.0
		WHEN [Broad_Jump_in] >= 118 AND [Broad_Jump_in] < 120 THEN 6.0
		WHEN [Broad_Jump_in] >= 115 AND [Broad_Jump_in] < 118 THEN 5.0

		WHEN [Broad_Jump_in] IS NULL THEN NULL
		
		ELSE 4.0

	END) AS RB_BroadJumpGrade

	INTO RunningBackGrades

FROM dbo.Player_Info
	INNER JOIN dbo.Player_Athletic_Performance
	ON dbo.Player_Athletic_Performance.Player_ID = dbo.Player_Info.Player_ID
WHERE (Position = 'RB');

SELECT *
FROM dbo.RunningBackGrades;

--Add columns (overall grade and player draft pick) to the position 
ALTER TABLE dbo.RunningBackGrades
	ADD AthleticGrade FLOAT
	ADD DraftPick INT;

SELECT *
FROM dbo.RunningBackGrades;

--Need to delete the players that didn't attend the combine
SELECT * FROM dbo.RunningBackGrades
	WHERE (RB_BroadJumpGrade IS NULL)
		AND (RB_FourtyGrade IS NULL)
		AND (RB_VerticalGrade IS NULL)

DELETE FROM dbo.RunningBackGrades
	WHERE (RB_BroadJumpGrade IS NULL)
		AND (RB_FourtyGrade IS NULL)
		AND (RB_VerticalGrade IS NULL)

SELECT *
FROM dbo.RunningBackGrades;


--Need to change the overall athletic grade
--Code has to be done in order unless you want to add extra code to the qery. 
	--EX: The columns with single Nulls will alter the columns with multiple Nulls while the 'AthleticGrade' calculation is different for both

UPDATE dbo.RunningBackGrades
SET AthleticGrade = (RB_FourtyGrade + RB_BroadJumpGrade + RB_VerticalGrade) / 3

UPDATE dbo.RunningBackGrades
SET AthleticGrade = (RB_VerticalGrade + RB_BroadJumpGrade) / 2
WHERE RB_FourtyGrade IS NULL

UPDATE dbo.RunningBackGrades
SET AthleticGrade = (RB_FourtyGrade + RB_BroadJumpGrade) / 2
WHERE RB_VerticalGrade IS NULL

UPDATE dbo.RunningBackGrades
SET AthleticGrade = (RB_FourtyGrade + RB_VerticalGrade) / 2
WHERE RB_BroadJumpGrade IS NULL

UPDATE dbo.RunningBackGrades
SET AthleticGrade = RB_FourtyGrade
WHERE RB_VerticalGrade IS NULL AND RB_BroadJumpGrade IS NULL

UPDATE dbo.RunningBackGrades
SET AthleticGrade = RB_VerticalGrade
WHERE RB_FourtyGrade IS NULL AND RB_BroadJumpGrade IS NULL

UPDATE dbo.RunningBackGrades
SET AthleticGrade = RB_BroadJumpGrade
WHERE RB_FourtyGrade IS NULL AND RB_VerticalGrade IS NULL

--Update all draft picks for players
UPDATE dbo.RunningBackGrades
SET DraftPick = Draft_Pick
FROM dbo.AllCombineData
WHERE Player_Name = Player

SELECT *
FROM dbo.RunningBackGrades;