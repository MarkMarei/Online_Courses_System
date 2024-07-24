CREATE TABLE Users(
Id INT PRIMARY KEY,
FullName VARCHAR(30),
password_ VARCHAR(10),
email VARCHAR(30),
date_ DATE default getdate(),
role VARCHAR(10)
)


-- Rule to force column role being student or Instructor only
CREATE RULE r1 AS @x IN ('Student', 'Instructor');
sp_bindrule r1, 'Users.role'


CREATE TABLE Courses(
Course_Id INT PRIMARY KEY,
Insructor_Id INT FOREIGN KEY REFERENCES Users(Id),
title VARCHAR(20),
description VARCHAR(50),
date_ DATE default getdate(),
pay INT,
hours_ INT,
)

CREATE TABLE Enrollment(
Student_Id INT FOREIGN KEY REFERENCES Users(Id),
Course_Id INT FOREIGN KEY REFERENCES Courses(Course_Id),
date_ DATE default getdate(),
CONSTRAINT c1 PRIMARY KEY (Student_Id, Course_Id),
)

CREATE TABLE Grades
(
Grade_Id INT PRIMARY KEY,
Student_Id INT FOREIGN KEY REFERENCES Users(Id),
Course_Id INT FOREIGN KEY REFERENCES Courses(Course_Id),
Grade NVARCHAR(5),
)

CREATE TABLE Modules
(
Module_Id INT PRIMARY KEY,
title VARCHAR(20),
descrition VARCHAR(50),
Course_Id INT FOREIGN KEY REFERENCES Courses(Course_Id),
)

CREATE TABLE lessons
(
Lesson_Id INT PRIMARY KEY,
title VARCHAR(20),
descrition VARCHAR(50),
Module_Id INT FOREIGN KEY REFERENCES Modules(Module_Id),
)

CREATE TABLE content
(
content_Id INT PRIMARY KEY,
title VARCHAR(20),
content_Type VARCHAR(50),
File_Path VARCHAR(200),
Lesson_Id INT FOREIGN KEY REFERENCES lessons(Lesson_Id),
)

CREATE TABLE Message
(
message_Id INT PRIMARY KEY,
sender_id INT FOREIGN KEY REFERENCES Users(Id),
accepter_id INT FOREIGN KEY REFERENCES Users(Id),
subject VARCHAR(50),
content VARCHAR(200),
time DATE default getdate(),
)