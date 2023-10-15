ALTER TABLE dbo.AllPlayerGrades
	ADD DraftRound VARCHAR(50);

SELECT *
FROM dbo.AllPlayerGrades

UPDATE dbo.AllPlayerGrades
	SET DraftRound = (
	CASE

	WHEN [DraftPick] <= 32 THEN 'Round 1'
	WHEN [DraftPick] <= 64 AND [DraftPick] > 32 THEN 'Round 2'
	WHEN [DraftPick] <= 105 AND [DraftPick] > 64 THEN 'Round 3'
	WHEN [DraftPick] <= 143 AND [DraftPick] > 105 THEN 'Round 4'
	WHEN [DraftPick] <= 179 AND [DraftPick] > 143 THEN 'Round 5'
	WHEN [DraftPick] <= 221 AND [DraftPick] > 179 THEN 'Round 6'
	WHEN [DraftPick] <= 262 AND [DraftPick] > 221 THEN 'Round 7'

	WHEN [DraftPick] IS NULL THEN 'Undrafted'

	ELSE 'ERROR'
	
	END) 

SELECT *
FROM dbo.AllPlayerGrades


	