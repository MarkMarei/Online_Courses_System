--ADD user student or instructor and given message if any error occurs
CREATE OR ALTER PROCEDURE AddUser
@Id INT,
@Name VARCHAR(30),
@pass VARCHAR(10),
@email VARCHAR(30),
@date DATE,
@role VARCHAR(10)
AS
	BEGIN TRY
	INSERT INTO Users VALUES(@Id, @Name, @pass, @email, @date, @role)
	END TRY 
	BEGIN CATCH
	SELECT 'You Inserted duplicated id or the roll is not Stuednt or instructor'
	END CATCH


-- add course only if the client enters instructor_id not student
CREATE OR ALTER PROCEDURE AddCourse
@Course_Id INT,
@Insructor_Id INT,
@title VARCHAR(20),
@description VARCHAR(50),
@date DATE,
@pay INT,
@hours INT
AS
	IF EXISTS(select id from Users where role = 'Instructor' AND id= @Insructor_Id)
		BEGIN			
		INSERT INTO Courses 
		VALUES(@Course_Id, @Insructor_Id, @title, @description, @date, @pay, @hours)			
		END
	ELSE 
		SELECT 'Please Enter Insructor_Id'

-- Add enrollment only after chaeching the course_id and student_id valid or not
CREATE OR ALTER PROCEDURE Add_Enrollment
@Student_Id INT,
@Course_Id INT,
@date DATE
AS
	IF EXISTS(select id from Users where role = 'Student' AND id= @Student_Id) 
		AND EXISTS (select Course_Id from Courses where Course_Id= @Course_Id)
		BEGIN			
		INSERT INTO Enrollment 
		VALUES(@Student_Id, @Course_Id, @date)			
		END
	ELSE
		SELECT 'Please Enter Valid Student_Id OR Course_Id'

Add_Enrollment 1, 1, '2024-3-3'

-- add grade of a course after checking ids of course and student and grade_id
CREATE OR ALTER PROCEDURE AddGrade
@Grade_Id INT,
@Student_Id INT,
@Course_Id INT ,
@Grade NVARCHAR(5)
AS
	IF EXISTS(SELECT id FROM Users WHERE role = 'Student' AND id= @Student_Id) 
		AND EXISTS (SELECT Course_Id FROM Courses WHERE Course_Id= @Course_Id)
		AND NOT EXISTS(SELECT Grade_Id FROM Grades WHERE Grade_Id = @Grade_Id)
		BEGIN			
		INSERT INTO Grades 
		VALUES(@Grade_Id, @Student_Id, @Course_Id, @Grade)			
		END
	ELSE
		SELECT 'Please Enter Valid Student_Id OR Course_Id OR Grade_Id' 

CREATE OR ALTER PROCEDURE AddModule
@Module_Id INT ,
@title VARCHAR(20),
@descrition VARCHAR(50),
@Course_Id INT
AS
	IF EXISTS(select Course_Id from Courses where Course_Id= @Course_Id) 
	AND NOT EXISTS(SELECT Module_Id FROM Modules WHERE Module_Id = @Module_Id)
		BEGIN			
		INSERT INTO Modules 
		VALUES(@Module_Id, @title, @descrition, @Course_Id)			
		END
	ELSE
		SELECT 'Please Enter Valid Course_Id OR Module_Id'

-- delete enrollment after checking that the student already enrolled to this course or not
CREATE OR ALTER PROCEDURE Delete_Enrollment
@student_id INT, @course_id INT
AS
	IF EXISTS(select Course_Id from Enrollment where Course_Id= @Course_Id) 
		AND EXISTS(SELECT Student_Id FROM Enrollment WHERE Student_Id = @student_id)
		DELETE FROM Enrollment WHERE Student_Id = @student_id AND Course_Id = @course_id
	ELSE
		SELECT 'Please Enter Valid student_id or course_id'
		

--Make relation between foreign_key(student_id) and primary_key(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE enrollment
ADD CONSTRAINT z1
FOREIGN KEY (student_id) REFERENCES Users(ID)
ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE courses
ADD CONSTRAINT z2
FOREIGN KEY (instructor_id) REFERENCES Users(ID)
ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE grades
ADD CONSTRAINT z3
FOREIGN KEY (student_id) REFERENCES Users(ID)
ON UPDATE CASCADE ON DELETE SET NULL;

-- deleting user after Checking that is Valid ID or not
CREATE OR ALTER PROCEDURE Delete_User
@ID INT
AS
	IF EXISTS(select ID from Users where Id= @ID)
		DELETE FROM Users WHERE Id = @ID
	ELSE
		SELECT 'Please Enter Valid ID'


-- update grade by taking grade_id and the new grade
CREATE OR ALTER PROCEDURE Update_Grade
@grade_id INT, @grade NVARCHAR(5)
AS
	UPDATE Grades
	SET Grade = @grade WHERE Grade_Id = @grade_id


-- View shows each student and the grade of the courses that are enrolled

CREATE OR ALTER VIEW stud_grade
with encryption
AS
	SELECT Id, FullName, C.title, Grade 
	FROM Users U INNER JOIN Grades g
	ON u.Id =  g.Student_Id
	INNER JOIN Courses C on C.Course_Id = G.Course_Id


-- View shows each course teached by instrucor
CREATE VIEW instru_course
with encryption
AS
	SELECT Id, FullName, Course_Id, c.title, c.description, c.pay 
	FROM Users U INNER JOIN Courses c
	ON u.Id =  c.Insructor_Id

-- View shows the users that sent messages
CREATE OR ALTER VIEW user_SendMessage
with encryption
AS
	SELECT sender_id, accepter_id ,FullName, message_Id, content
	FROM Users u INNER JOIN Message m
	ON u.Id = m.sender_id

-- View shows the users that sent messages
CREATE OR ALTER VIEW user_RecieveMessage
with encryption
AS
	SELECT sender_id, accepter_id ,FullName, message_Id, content
	FROM Users u INNER JOIN Message m
	ON u.Id = m.accepter_id