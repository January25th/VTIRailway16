DROP DATABASE IF EXISTS Testing_system;
CREATE DATABASE if not EXISTS Testing_system;
USE Testing_system;

DROP TABLE IF EXISTS Department;
CREATE TABLE Department(
	DepartmentID			TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    DepartmentName			VARCHAR(50) NOT NULL UNIQUE KEY
);

DROP TABLE IF EXISTS `Position`;
CREATE TABLE `Position`(
	PositionID				TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    PositionName			ENUM('Dev','Test','Scrum Master','PM') UNIQUE KEY
);	

DROP TABLE IF EXISTS `Account`;
CREATE TABLE `Account`(
	AccountID				SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Email					VARCHAR(50) NOT NULL UNIQUE KEY,
    Username				VARCHAR(50) NOT NULL UNIQUE KEY, -- CHECK(length(Username)>=6),
    Fullname				NVARCHAR(50) NOT NULL UNIQUE KEY,
    DepartmentID			TINYINT UNSIGNED NOT NULL,
    PositionID				TINYINT UNSIGNED NOT NULL,
    CreateDate				DATETIME DEFAULT NOW(),
    FOREIGN KEY (DepartmentID)  REFERENCES Department(DepartmentID),
    FOREIGN KEY (PositionID) REFERENCES `Position`(PositionID)
);

DROP TABLE IF EXISTS `Group`;
CREATE TABLE `Group`(
	GroupID					TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    GroupName				VARCHAR(50),
    CreatorID				TINYINT UNSIGNED,
    CreateDate				DATETIME DEFAULT NOW()
);

DROP TABLE IF EXISTS GroupAccount;
CREATE TABLE GroupAccount(
	GroupID					TINYINT UNSIGNED,
    AccountID				SMALLINT UNSIGNED NOT NULL,
    JoinDate				DATETIME DEFAULT NOW(),
    PRIMARY KEY(GroupID, AccountID),
    FOREIGN KEY(GroupID) REFERENCES`Group`(GroupID),
    FOREIGN KEY(AccountID)  REFERENCES `Account`(AccountID)
);

DROP TABLE IF EXISTS TypeQuestion;
CREATE TABLE TypeQuestion(
	TypeID					TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    TypeName				ENUM('Essay','Multiple-Choice')
);

DROP TABLE IF EXISTS CategoryQuestion;
CREATE TABLE CategoryQuestion(
	CategoryID				TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    CategoryName			VARCHAR(50)
    );

DROP TABLE IF EXISTS Question;    
CREATE TABLE Question(
	QuestionID				SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Content					TEXT NOT NULL,
    CategoryID				TINYINT UNSIGNED NOT NULL,
    TypeID					TINYINT UNSIGNED NOT NULL,
    CreatorID				SMALLINT UNSIGNED,
    CreateDate				DATETIME DEFAULT NOW(),
    FOREIGN KEY(CategoryID) REFERENCES CategoryQuestion(CategoryID),
    FOREIGN KEY(TypeID)		REFERENCES TypeQuestion(TypeID),
    FOREIGN KEY(CreatorID)	REFERENCES `Account`(AccountID)
);

DROP TABLE IF EXISTS `Answer`;
CREATE TABLE `Answer`(
	AnswerID				TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Content					NVARCHAR(50),
    QuestionID				SMALLINT UNSIGNED REFERENCES Question(QuestionID),
    isCorrect				BOOLEAN,
    FOREIGN KEY(QuestionID) REFERENCES Question(QuestionID)
);

-- mã đề thi CODE là chuỗi ký tự cả chữ và số nên sẽ dùng VARCHAR
DROP TABLE IF EXISTS `Exam`;
CREATE TABLE `Exam`(
	ExamID					TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `Code`					CHAR(10),
	Title					VARCHAR(50),
    CategoryID				TINYINT UNSIGNED NOT NULL,
    Duration				TINYINT UNSIGNED NOT NULL,
    CreatorID				SMALLINT UNSIGNED NOT NULL,
    CreateDate				DATETIME DEFAULT NOW(),
    FOREIGN KEY(CategoryID) REFERENCES CategoryQuestion(CategoryID),
    FOREIGN KEY(CreatorID) REFERENCES `Account`(AccountID)
);

DROP TABLE IF EXISTS ExamQuestion;
CREATE TABLE ExamQuestion(
	ExamID					TINYINT UNSIGNED AUTO_INCREMENT,
    QuestionID				SMALLINT UNSIGNED NOT NULL REFERENCES Question(QuestionID),
	PRIMARY KEY(ExamID,QuestionID),
    FOREIGN KEY(ExamID) REFERENCES Exam(ExamID),
    FOREIGN KEY(QuestionID) REFERENCES Question(QuestionID)
);

                      
                      