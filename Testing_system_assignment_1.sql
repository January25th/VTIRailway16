CREATE DATABASE Testing_system;
USE Testing_system;

-- Định danh auto increment là INT
-- Nên dùng VARCHAR thay thay cho CHAR là vì nó có thể đáp ứng thay đổi về size tương ứng với length tuy nhiên 
-- Tốc độ xử lý CHAR sẽ nhanh hơn 50% vd mã tiền tệ cố định 3 chữ số
CREATE TABLE Department(
	DepartmentID			INT,
    DepartmentName			VARCHAR(50)
);

-- Tên của bảng posiotion trùng với tên queries nên phải dùng dấu huyền ``
CREATE TABLE `Position`(
	PositionID				INT,
    PositionName			VARCHAR(50)
);	

-- Những cái nào có chữ ID là chọn kiểu dữ liệu INT, còn ngày tháng chọn DATE
CREATE TABLE `Account`(
	AccountID				INT,
    Email					VARCHAR(50),
    Username				VARCHAR(50),
    Fullname				VARCHAR(50),
    DepartmentID			INT,
    PositionID				INT,
    CreateDate				DATE
);

CREATE TABLE `Group`(
	GroupID					INT,
    GroupName				VARCHAR(50),
    CeatorID				INT,
    CreateDate				DATE
);

CREATE TABLE GroupAccount(
	GroupID					INT,
    AccountID				INT,
    JoinDate				DATE
);

CREATE TABLE TypeQuestion(
	TypeID					INT,
    TypeName				VARCHAR(50)
);
CREATE TABLE CategoryQuestion(
	CategoryID				INT,
    CategoryName			VARCHAR(50)
    );
    
CREATE TABLE `Question`(
	QuestionID				INT,
    Content					VARCHAR(50),
    CategoryID				VARCHAR(50),
    TypeID					INT,
    CreatorID				INT,
    CreateDate				DATE
);

-- kiểu dữ liệu BIT: 0 là false, 1 là true
CREATE TABLE `Answer`(
	AnswerID				INT,
    Content					VARCHAR(50),
    QuestionID				INT,
    isCorrect				BIT
);

-- mã đề thi CODE là chuỗi ký tự cả chữ và số nên sẽ dùng VARCHAR
CREATE TABLE `Exam`(
	ExamID					INT,
    Code					VARCHAR(10),
	Title					VARCHAR(50),
    CategoryID				INT,
    Duration				INT,
    CreatorID				INT,
    CreateDate				DATE
);

CREATE TABLE ExamQuestion(
	ExamID					INT,
    QuestionID				INT
);