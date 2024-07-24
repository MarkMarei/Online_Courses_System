-- function to get user bane by the id
CREATE FUNCTION getUserName(@stId INT)
RETURNS VARCHAR(30)
	BEGIN
		DECLARE @x VARCHAR(30)
		SELECT @x = FullName FROM Users WHERE Id = @stId
		RETURN @x
	END

-- function returns total number of courses hours of each student by id
CREATE FUNCTION gettotalhours(@stId INT)
RETURNS INT
	BEGIN
		DECLARE @x INT
		SELECT @x = SUM(hours_)
		FROM Courses c inner join Grades g 
		ON g.Course_Id = c.Course_Id
		WHERE student_id = @stId
		GROUP BY Student_Id
		RETURN @x
	END

-- function to search for name of a course 
CREATE FUNCTION SearchOfCourseByName(@CourseName varchar(20))
RETURNS TABLE
AS
RETURN
	SELECT title
	FROM Courses 
	WHERE title like '%' + @CourseName + '%'

-- function to get the payment of specific course by instructorId
CREATE FUNCTION getPriceOfCourse(@instId INT, @CourseName varchar(20))
RETURNS INT
	BEGIN
		DECLARE @x INT
		SELECT @x = pay
		FROM Courses 
		WHERE (Insructor_Id = @instId) AND title LIKE '%' + @CourseName + '%'
		RETURN @x
	END

