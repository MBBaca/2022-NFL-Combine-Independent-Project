/*
This query calculates the correlation coefficient for all events
*/

Select
Distinct
(Select
((Count(AthleticGrade) * Sum(AthleticGrade * DraftPick) - 
Sum(AthleticGrade) * Sum(DraftPick))
/
SQRT((Count(AthleticGrade) * Sum(Square(AthleticGrade)) - 
Square(Sum(AthleticGrade))) *
(Count(AthleticGrade) * Sum(Square(DraftPick)) - 
Square(Sum(DraftPick)))))
From dbo.AllPlayerGrades
Where DraftPick is not null) AS AthleticGradeCorrelationCoefficient,

(Select
((Count(FourtyGrade) * Sum(FourtyGrade * DraftPick) - 
Sum(FourtyGrade) * Sum(DraftPick))
/
SQRT((Count(FourtyGrade) * Sum(Square(FourtyGrade)) - 
Square(Sum(FourtyGrade))) *
(Count(FourtyGrade) * Sum(Square(DraftPick)) - 
Square(Sum(DraftPick)))))
From dbo.AllPlayerGrades
Where DraftPick is not null and FourtyGrade is not null) AS FourtyGradeCorrelationCoefficient,

(Select
((Count(VerticalGrade) * Sum(VerticalGrade * DraftPick) - 
Sum(VerticalGrade) * Sum(DraftPick))
/
SQRT((Count(VerticalGrade) * Sum(Square(VerticalGrade)) - 
Square(Sum(VerticalGrade))) *
(Count(VerticalGrade) * Sum(Square(DraftPick)) - 
Square(Sum(DraftPick)))))
From dbo.AllPlayerGrades
Where DraftPick is not null and VerticalGrade is not null) AS VerticalGradeCorrelationCoefficient,

(Select
((Count(BroadJumpGrade) * Sum(BroadJumpGrade * DraftPick) - 
Sum(BroadJumpGrade) * Sum(DraftPick))
/
SQRT((Count(BroadJumpGrade) * Sum(Square(BroadJumpGrade)) - 
Square(Sum(BroadJumpGrade))) *
(Count(BroadJumpGrade) * Sum(Square(DraftPick)) - 
Square(Sum(DraftPick)))))
From dbo.AllPlayerGrades
Where DraftPick is not null and BroadJumpGrade is not null) AS BroadJumpGradeCorrelationCoefficient

From dbo.AllPlayerGrades