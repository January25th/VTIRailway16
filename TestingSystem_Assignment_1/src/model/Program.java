package model;

import java.util.Date;

public class Program {

	public static void main(String[] args) {
//Department
		Department department1 = new Department();
		department1.departmentID = 1;
		department1.departmentName = "Sale";
		
		Department department2 = new Department();
		department2.departmentID = 2;
		department2.departmentName = "Marketing";
		
		Department department3 = new Department();
		department3.departmentID = 3;
		department3.departmentName = "R&D";
		
		System.out.println("Thông tin phòng ban 1: ");
		System.out.println("ID: " + department1.departmentID);
		System.out.println("Name: " + department1.departmentName);
		
//Position
		Position position1 = new Position();
		position1.positionID = 1;
		position1.positionName = PositionName.DEV; //enum
		
		Position position2 = new Position();
		position2.positionID = 2;
		position2.positionName = PositionName.PM;
		
		Position position3 = new Position();
		position3.positionID = 3;
		position3.positionName = PositionName.SCRUM;
		
		System.out.println("Thông tin vị trí 1: ");
		System.out.println("ID: " + position1.positionID);
		System.out.println("Name: " + position1.positionName);
		
//Account
		Account account1 = new Account();
		account1.accountID = 1;
		account1.email = "thuyvi@gmail.com";
		account1.userName = "thuyvi.user";
		account1.fullName = "Lương Thụy Vi";
		account1.department = department1;
		account1.position = position1;
		account1.createDate = new Date(2021/9/25); //date
		
		Account account2 = new Account();
		account2.accountID = 2;
		account2.email = "minhtuan@gmail.com";
		account2.userName = "minhtuan.user";
		account2.fullName = "Lương Minh Tuấn";
		account2.department = department2;
		account2.position = position2;
		account2.createDate = new Date(2021/9/25);
		
		Account account3 = new Account();
		account3.accountID = 3;
		account3.email = "sontung@gmail.com";
		account3.userName = "sontung.user";
		account3.fullName = "Nguyễn Sơn Tùng";
		account3.department = department3;
		account3.position = position3;
		account3.createDate = new Date(2021/9/25);
		
		System.out.println("Thông tin account: ");
		System.out.println("ID: " + account1.accountID);
		System.out.println("Email: " + account1.email);
		System.out.println("username: " + account1.userName);
		System.out.println("fullname: " + account1.fullName);
		System.out.println("department: " + account1.department.departmentName);
		System.out.println("position: " + account1.position.positionName);
		System.out.println("createDate: " + account1.createDate);
	
//Group
		Group group1 = new Group();
		group1.groupID =  1;
		group1.groupName = "Nhật";
		group1.creatorID = account1;
		
		Group group2 = new Group();
		group2.groupID =  2;
		group2.groupName = "Việt";
		group2.creatorID = account2;
		
		Group group3 = new Group();
		group3.groupID =  3;
		group3.groupName = "Mỹ";
		group3.creatorID = account3;
		
		System.out.println("Thông tin group: ");
		System.out.println("ID: " + group1.groupID);
		System.out.println("Name: " + group1.groupName );
		System.out.println("Creator: " + group1.creatorID.userName);
		
//GroupAccount
		GroupAccount groupaccount1 = new GroupAccount();
		groupaccount1.group = group1;
		groupaccount1.account = account1;
		groupaccount1.joinDate = new Date(2021/9/25);
		
		GroupAccount groupaccount2 = new GroupAccount();
		groupaccount2.group = group2;
		groupaccount2.account = account2;
		groupaccount2.joinDate = new Date(2021/9/25);

		GroupAccount groupaccount3 = new GroupAccount();
		groupaccount3.group = group3;
		groupaccount3.account = account3;
		groupaccount3.joinDate = new Date(2021/9/25);

		System.out.println("Thông tin GroupAccount");
		System.out.println("groupID: " + groupaccount1.group.groupID);
		System.out.println("AccountID: " + groupaccount1.account.accountID);
		System.out.println("JoinDate: " + groupaccount1.joinDate);
		
//TypeQuestion
		TypeQuestion typeQuestion1 =  new TypeQuestion();
		typeQuestion1.typeID = 1;
		typeQuestion1.typeName = TypeName.ESSAY;
		
		TypeQuestion typeQuestion2 =  new TypeQuestion();
		typeQuestion1.typeID = 2;
		typeQuestion1.typeName = TypeName.MULTIPLECHOICE;
		
		TypeQuestion typeQuestion3 =  new TypeQuestion();
		typeQuestion1.typeID = 3;
		typeQuestion1.typeName = TypeName.ESSAY;
		
		System.out.println("Thông tin typequestion: ");
		System.out.println("ID: " + typeQuestion1.typeID);
		System.out.println("Name: " + typeQuestion1.typeName);
		
//CategoryQuestion
		CategoryQuestion categoryQuestion1 = new CategoryQuestion();
		categoryQuestion1.categoryID = 1;
		categoryQuestion1.categoryName = CategoryName.JAVA;
		
		CategoryQuestion categoryQuestion2 = new CategoryQuestion();
		categoryQuestion1.categoryID = 2;
		categoryQuestion1.categoryName = CategoryName.NET;
		
		CategoryQuestion categoryQuestion3 = new CategoryQuestion();
		categoryQuestion1.categoryID = 3;
		categoryQuestion1.categoryName = CategoryName.POSTMAN;
		
		System.out.println("Thông tin Category Question: ");
		System.out.println("category ID: " + categoryQuestion1.categoryID);
		System.out.println("Category Name" + categoryQuestion1.categoryName);
		
//Question
		Question question1 = new Question();
		question1.questionID = 1;
		question1.content = "Java là gì?";
		question1.categoryQuestion = categoryQuestion1;
		question1.typeQuestion = typeQuestion1;
		question1.creator = account1;
		question1.createDate = new Date(2021/9/25);
		
		Question question2 = new Question();
		question2.questionID = 2;
		question2.content = ".NET là gì?";
		question2.categoryQuestion = categoryQuestion2;
		question2.typeQuestion = typeQuestion2;
		question2.creator = account2;
		question2.createDate = new Date(2021/9/25);
		
		Question question3 = new Question();
		question3.questionID = 3;
		question3.content = "Postman là gì?";
		question3.categoryQuestion = categoryQuestion3;
		question3.typeQuestion = typeQuestion3;
		question3.creator = account3;
		question3.createDate = new Date(2021/9/25);
		
		System.out.println("Thông tin Question");
		System.out.println("Question ID: " + question1.questionID);
		System.out.println("Content" +  question1.content);
		System.out.println("CategoryID " + question1.categoryQuestion.categoryID);
		System.out.println("TypeID " + question1.typeQuestion.typeID);
		System.out.println("Creator " + question1.creator.fullName);
		System.out.println("Create Date" + question1.createDate);
		
//Answer
		Answer answer1 = new Answer();
		answer1.answerID = 1;
		answer1.content = "là Java";
		answer1.question = question1;
		answer1.isCorrect = true;
		
		Answer answer2 = new Answer();
		answer2.answerID = 2;
		answer2.content = "là bế tắc";
		answer2.question = question2;
		answer2.isCorrect = false;
		
		Answer answer3 = new Answer();
		answer3.answerID = 3;
		answer3.content = "là Postman";
		answer3.question = question3;
		answer3.isCorrect = true;
		
		System.out.println("Thông tin answer: ");
		System.out.println("AnswerID: " + answer1.answerID);
		System.out.println("Content: " + answer1.content);
		System.out.println("Câu hỏi: " + answer1.question.content);
		System.out.println("Đáp án này: " + answer1.isCorrect);
		
		
//Exam
		Exam exam1 = new Exam();
		exam1.examID = 1;
		exam1.code = "ABC1";
		exam1.title = "Đề thi 45'";
		exam1.category = categoryQuestion1;
		exam1.duration = 45;
		exam1.creator = account1;
		exam1.createDate = new Date(2021/9/25);
		
		Exam exam2 = new Exam();
		exam2.examID = 2;
		exam2.code = "ABC2";
		exam2.title = "Đề thi 60'";
		exam2.category = categoryQuestion2;
		exam2.duration = 60;
		exam2.creator = account2;
		exam2.createDate = new Date(2021/9/25);
		
		Exam exam3 = new Exam();
		exam3.examID = 3;
		exam3.code = "ABC3";
		exam3.title = "Đề thi 90'";
		exam3.category = categoryQuestion3;
		exam3.duration = 90;
		exam3.creator = account3;
		exam3.createDate = new Date(2021/9/25);
		
		System.out.println("Thông tin exam: ");
		System.out.println("examID: " + exam1.examID);
		System.out.println("code:" + exam1.code);
		System.out.println("title: " + exam1.title);
		System.out.println("category: " + exam1.category.categoryName);
		System.out.println("duration: "  + exam1.duration);
		System.out.println("creator: " + exam1.creator.fullName);
		System.out.println("create Date: " + exam1.createDate);
				
//ExamQuestion
		ExamQuestion examQuestion1 = new ExamQuestion();
		examQuestion1.exam = exam1;
		examQuestion1.question = question1;
		
		ExamQuestion examQuestion2 = new ExamQuestion();
		examQuestion2.exam = exam2;
		examQuestion2.question = question2;
		
		ExamQuestion examQuestion3 = new ExamQuestion();
		examQuestion3.exam = exam3;
		examQuestion3.question = question3;
		
		System.out.println("Thông tin Exam Question: ");
		System.out.println("Exam: " + examQuestion1.exam.title);
		System.out.println("Question: " + examQuestion1.question.content);
	}

}
