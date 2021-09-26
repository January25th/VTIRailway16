package model;

import java.util.Date;

public class Question {
	int questionID;
	String content;
	CategoryQuestion categoryQuestion;
	TypeQuestion typeQuestion;
	Account creator;
	Date createDate;
}
