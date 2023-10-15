SELECT *
FROM dbo.AllCombineData;

/*
INSERT INTO dbo.Player_Athletic_Performance(
	Fourty_sec, Vertical_in, Bench_rep, Broad_Jump_in, Three_Cone_sec, Shuttle_sec
	)
SELECT Fourty, Vertical, Bench, Broad_Jump,Three_Cone, Shuttle
FROM dbo.AllCombineData;
*/

SELECT *
FROM dbo.Player_Athletic_Performance;

/*
INSERT INTO dbo.Player_Draft_Pick(
	Draft_Pick
	)
SELECT Draft_Pick
FROM dbo.AllCombineData;
*/

SELECT * 
FROM dbo.Player_Draft_Pick;

/*
INSERT INTO dbo.Player_Info(
	Player_Name, Position, Payer_School
	)
SELECT Player, Pos, School
FROM dbo.AllCombineData;
*/

SELECT *
FROM dbo.Player_Info;

/*
INSERT INTO dbo.Player_Measurables(
	Height_in, Weight_lbs
	)
SELECT Ht_in, Wt
FROM dbo.AllCombineData;
*/

SELECT *
FROM dbo.Player_Measurables;