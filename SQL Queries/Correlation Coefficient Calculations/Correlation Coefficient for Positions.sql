//*
This query displays the correlation coeffeicients for all distinct positions for all events.

	Since you cannot display more than one value using a subquery under the select clause, 
I joined all queries that displayed the results I needed under the From clause.

	To stray from ambiguousness as 'Position' as a column, I renamed that column as 'Pos' in all
except one subquery.
*//

Select Position, AthleticGradeCorrelationCoefficient, FourtyGradeCorrelationCoefficient, VerticalGradeCorrelationCoefficient, BroadJumpGradeCorrelationCoefficient
FROM (
Select Position,
((Count(AthleticGrade) * Sum(AthleticGrade * DraftPick) - 
Sum(AthleticGrade) * Sum(DraftPick))
/
SQRT((Count(AthleticGrade) * Sum(Square(AthleticGrade)) - 
Square(Sum(AthleticGrade))) *
(Count(AthleticGrade) * Sum(Square(DraftPick)) - 
Square(Sum(DraftPick))))) AS AthleticGradeCorrelationCoefficient
From dbo.AllPlayerGrades
Where DraftPick is not null
Group By Position) AS AthleticGradeCorrelationCoefficient

Inner Join

(Select Position As Pos,
((Count(BroadJumpGrade) * Sum(BroadJumpGrade * DraftPick) - 
Sum(BroadJumpGrade) * Sum(DraftPick))
/
SQRT((Count(BroadJumpGrade) * Sum(Square(BroadJumpGrade)) - 
Square(Sum(BroadJumpGrade))) *
(Count(BroadJumpGrade) * Sum(Square(DraftPick)) - 
Square(Sum(DraftPick))))) As BroadJumpGradeCorrelationCoefficient
From dbo.AllPlayerGrades
Where DraftPick is not null and BroadJumpGrade is not null
Group By Position) As BroadJumpGradeCorrelationCoefficient

On AthleticGradeCorrelationCoefficient.Position = BroadJumpGradeCorrelationCoefficient.Pos

Inner Join

(Select Position As Pos,
((Count(FourtyGrade) * Sum(FourtyGrade * DraftPick) - 
Sum(FourtyGrade) * Sum(DraftPick))
/
SQRT((Count(FourtyGrade) * Sum(Square(FourtyGrade)) - 
Square(Sum(FourtyGrade))) *
(Count(FourtyGrade) * Sum(Square(DraftPick)) - 
Square(Sum(DraftPick))))) AS FourtyGradeCorrelationCoefficient
From dbo.AllPlayerGrades
Where DraftPick is not null and FourtyGrade is not null
Group By Position) AS FourtyGradeCorrelationCoefficient

On FourtyGradeCorrelationCoefficient.Pos = AthleticGradeCorrelationCoefficient.Position

Inner Join

(Select Position As Pos,
((Count(VerticalGrade) * Sum(VerticalGrade * DraftPick) - 
Sum(VerticalGrade) * Sum(DraftPick))
/
SQRT((Count(VerticalGrade) * Sum(Square(VerticalGrade)) - 
Square(Sum(VerticalGrade))) *
(Count(VerticalGrade) * Sum(Square(DraftPick)) - 
Square(Sum(DraftPick))))) AS VerticalGradeCorrelationCoefficient
From dbo.AllPlayerGrades
Where DraftPick is not null and VerticalGrade is not null
Group By Position) AS VerticalGradeCorrelationCoefficient

On VerticalGradeCorrelationCoefficient.Pos = AthleticGradeCorrelationCoefficient.Position