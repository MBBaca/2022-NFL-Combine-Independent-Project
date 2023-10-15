--Combine all tables into one to get the grades of all players

SELECT *
INTO AllPlayerGrades
FROM(
	SELECT *
	FROM dbo.DefensiveBackGrades
	UNION ALL

	SELECT *
	FROM dbo.DefensiveTackleGrades
	UNION ALL

	SELECT *
	FROM dbo.LineBackerGrades
	UNION ALL

	SELECT *
	FROM dbo.OffensiveLineGrades
	UNION ALL

	SELECT *
	FROM dbo.RunningBackGrades
	UNION ALL

	SELECT *
	FROM dbo.TightEndGrades
	UNION ALL

	SELECT *
	FROM dbo.WideReceiverGrades

	) AS AllData

	ORDER BY DraftPick Desc

--Just remove 'DB' from the grade columns