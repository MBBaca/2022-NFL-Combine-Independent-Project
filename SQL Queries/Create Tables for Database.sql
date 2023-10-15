CREATE TABLE Player_Info (
	Player_ID INT IDENTITY (1,1) PRIMARY KEY,
	Player_Name VARCHAR(50) NOT NULL,
	Position VARCHAR(50) NOT NULL,
	Payer_School VARCHAR(50) NOT NULL
	);

CREATE TABLE Player_Measurables(
	Player_ID INT IDENTITY (1,1) PRIMARY KEY,
	Height_in INT NOT NULL,
	Weight_lbs INT NOT NULL
	);

CREATE TABLE Player_Athletic_Performance(
	Player_ID INT IDENTITY (1,1) PRIMARY KEY,
	Fourty_sec DECIMAL (3, 2),
	Vertical_in DECIMAL (3, 1),
	Bench_rep INT,
	Broad_Jump_in INT,
	Three_Cone_sec DECIMAL (3, 2),
	Shuttle_sec DECIMAL (3, 2)
	);

CREATE TABLE Player_Draft_Pick(
	Player_ID INT IDENTITY (1,1) PRIMARY KEY,
	Draft_Pick INT
	);
