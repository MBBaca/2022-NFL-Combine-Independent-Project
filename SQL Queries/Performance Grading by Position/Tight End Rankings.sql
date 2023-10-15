SELECT Position
FROM dbo.Player_Info;

SELECT Player, Pos, Ht_in, Wt, Draft_Pick
FROM dbo.AllCombineData
WHERE (Pos = 'TE');

SELECT * 
FROM dbo.Player_Info
	INNER JOIN dbo.Player_Athletic_Performance
	ON dbo.Player_Athletic_Performance.Player_ID = dbo.Player_Info.Player_ID
WHERE (Position = 'TE');

--Creating the grades for the significant combine events for that position
SELECT Player_Name, 
	Position,

	(CASE
		WHEN [Fourty_sec] < 4.5 THEN 10
		WHEN [Fourty_sec] < 4.55 AND [Fourty_sec] >= 4.5 THEN 9.5
		WHEN [Fourty_sec] < 4.6 AND [Fourty_sec] >= 4.55 THEN 9.0
		WHEN [Fourty_sec] < 4.65 AND [Fourty_sec] >= 4.65 THEN 8.5
		WHEN [Fourty_sec] < 4.7 AND [Fourty_sec] >= 4.65 THEN 8.0
		WHEN [Fourty_sec] < 4.8 AND [Fourty_sec] >= 4.7 THEN 7.0
		WHEN [Fourty_sec] < 4.85 AND [Fourty_sec] >= 4.8 THEN 6.0
		WHEN [Fourty_sec] < 4.9 AND [Fourty_sec] >= 4.85 THEN 5.0

		WHEN [Fourty_sec] IS NULL THEN NULL
		
		ELSE 4.0

	END) AS TE_FourtyGrade,

	(CASE
		WHEN [Vertical_in] >= 38.0 THEN 10
		WHEN [Vertical_in] >= 36 AND [Vertical_in] < 38 THEN 9.5
		WHEN [Vertical_in] >= 34 AND [Vertical_in] < 36 THEN 9.0
		WHEN [Vertical_in] >= 33 AND [Vertical_in] < 34 THEN 8.5
		WHEN [Vertical_in] >= 32 AND [Vertical_in] < 33 THEN 8.0
		WHEN [Vertical_in] >= 31 AND [Vertical_in] < 32 THEN 7.0
		WHEN [Vertical_in] >= 30 AND [Vertical_in] < 31 THEN 6.0
		WHEN [Vertical_in] >= 29 AND [Vertical_in] < 30 THEN 5.0

		WHEN [Vertical_in] IS NULL THEN NULL
		
		ELSE 4.0

	END) AS TE_VerticalGrade,

	(CASE
		WHEN [Broad_Jump_in] >= 128 THEN 10
		WHEN [Broad_Jump_in] >= 126 AND [Broad_Jump_in] < 128 THEN 9.5
		WHEN [Broad_Jump_in] >= 123 AND [Broad_Jump_in] < 126 THEN 9.0
		WHEN [Broad_Jump_in] >= 120 AND [Broad_Jump_in] < 123 THEN 8.5
		WHEN [Broad_Jump_in] >= 118 AND [Broad_Jump_in] < 120 THEN 8.0
		WHEN [Broad_Jump_in] >= 116 AND [Broad_Jump_in] < 118 THEN 7.0
		WHEN [Broad_Jump_in] >= 114 AND [Broad_Jump_in] < 116 THEN 6.0
		WHEN [Broad_Jump_in] >= 112 AND [Broad_Jump_in] < 114 THEN 5.0

		WHEN [Broad_Jump_in] IS NULL THEN NULL
		
		ELSE 4.0

	END) AS TE_BroadJumpGrade

	INTO TightEndGrades

FROM dbo.Player_Info
	INNER JOIN dbo.Player_Athletic_Performance
	ON dbo.Player_Athletic_Performance.Player_ID = dbo.Player_Info.Player_ID
WHERE (Position = 'TE');

SELECT *
FROM dbo.TightEndGrades;

--Add columns (overall grade and player draft pick) to the position 
ALTER TABLE dbo.TightEndGrades
	ADD AthleticGrade FLOAT
	ADD DraftPick INT;

SELECT *
FROM dbo.TightEndGrades;

--Need to delete the players that didn't attend the combine
SELECT * FROM dbo.TightEndGrades
	WHERE (TE_BroadJumpGrade IS NULL)
		AND (TE_FourtyGrade IS NULL)
		AND (TE_VerticalGrade IS NULL)

DELETE FROM dbo.TightEndGrades
	WHERE (TE_BroadJumpGrade IS NULL)
		AND (TE_FourtyGrade IS NULL)
		AND (TE_VerticalGrade IS NULL)

SELECT *
FROM dbo.TightEndGrades;


--Need to change the overall athletic grade
--Code has to be done in order unless you want to add extra code to the qery. 
	--EX: The columns with single Nulls will alter the columns with multiple Nulls while the 'AthleticGrade' calculation is different for both

UPDATE dbo.TightEndGrades
SET AthleticGrade = (TE_FourtyGrade + TE_BroadJumpGrade + TE_VerticalGrade) / 3

UPDATE dbo.TightEndGrades
SET AthleticGrade = (TE_VerticalGrade + TE_BroadJumpGrade) / 2
WHERE TE_FourtyGrade IS NULL

UPDATE dbo.TightEndGrades
SET AthleticGrade = (TE_FourtyGrade + TE_BroadJumpGrade) / 2
WHERE TE_VerticalGrade IS NULL

UPDATE dbo.TightEndGrades
SET AthleticGrade = (TE_FourtyGrade + TE_VerticalGrade) / 2
WHERE TE_BroadJumpGrade IS NULL

UPDATE dbo.TightEndGrades
SET AthleticGrade = TE_FourtyGrade
WHERE TE_VerticalGrade IS NULL AND TE_BroadJumpGrade IS NULL

UPDATE dbo.TightEndGrades
SET AthleticGrade = TE_VerticalGrade
WHERE TE_FourtyGrade IS NULL AND TE_BroadJumpGrade IS NULL

UPDATE dbo.TightEndGrades
SET AthleticGrade = TE_BroadJumpGrade
WHERE TE_FourtyGrade IS NULL AND TE_VerticalGrade IS NULL

--Update all draft picks for players
UPDATE dbo.TightEndGrades
SET DraftPick = Draft_Pick
FROM dbo.AllCombineData
WHERE Player_Name = Player

SELECT *
FROM dbo.TightEndGrades;