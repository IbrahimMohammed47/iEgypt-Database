INSERT INTO Category
VALUES  ('Education','content about education'),
		('Tourism','content about tourism'),
		('Entertainment','content about etertainment');

INSERT INTO Sub_Category
VALUES  ('Education','high schools'),
		('Entertainment','standups'),
		('Tourism','culutural'),
		('Education','universities'),
		('Entertainment','theatre'),
		('Tourism','religious');


INSERT INTO User_ (email,first_name,middle_name,last_name,birth_date,u_password)
VALUES  ('a@r.com','a','aa','aaa','1-1-1998','a123'),
		('b@r.com','b','bb','bbb','1-2-1998','b123'),
		('c@r.com','c','cc','ccc','1-3-1998','c123'),	
		('d@r.com','d','dd','ddd','1-4-1998','d123'),
		('e@r.com','e','ee','eee','1-5-1998','e123'),
		('f@r.com','f','ff','fff','1-6-1998','f123'),
		('g@r.com','g','gg','ggg','1-7-1998','g123'),
		('h@r.com','h','hh','hhh','1-8-1998','h123'),
		('i@r.com','i','ii','iii','1-9-1998','i123'),
		('j@r.com','j','jj','jjj','1-10-1998','j123'),
		('k@r.com','k','kk','kkk','1-11-1998','k123'),
		('l@r.com','l','ll','lll','1-12-1998','l123'),
		('m@r.com','m','nn','mmm','1-13-1998','m123'),
		('n@r.com','n','nn','nnn','1-14-1998','n123'),
		('o@r.com','o','oo','ooo','1-15-1998','o123'),
		('p@r.com','p','pp','ppp','1-16-1998','p123'),
		('q@r.com','q','qq','qqq','1-17-1998','q123'),
		('r@r.com','r','rr','rrr','1-18-1998','r123');

INSERT INTO Viewer
VALUES  (1,'Microsoft','IT','multiNatiolal company'),
		(2,'Hope Hospital','Health','fixing people up'),
		(3,'UK Embassy','Politics','Doing nothing at all');

INSERT INTO Notified_Person
VALUES  (4),
		(5),
		(6),
		(7),
		(8),
		(9),
		(10),
		(11),
		(12);


INSERT INTO Contributer(id,notified_id,years_of_experience,portfolio_link,specialization)
VALUES  (4,4,10,'z.com','painting'),
		(5,5,12,'z.net','logo'),
		(6,6,15,'z.ai','photographing'),
		(7,7,10,'z.fun','painting'),
		(8,8,11,'z.bi','photographing');


INSERT INTO Staff
VALUES  (9,9,10,25,25,'1-15-2007'),
		(10,10,11,25,26,'1-15-2006'),
		(11,11,13,22,25,'1-15-2008'),
		(12,12,7,22,26,'1-15-2009');


INSERT INTO Reviewer
VALUES  (9),
		(10);

INSERT INTO Content_type
VALUES ('painting'),
	   ('photographing'),
	   ('logo');

INSERT INTO Content_manager
VALUES (11,'painting'),
	   (12,'photographing');

INSERT INTO Content
VALUES ('paint101.com','2010-12-1 12:59:59',5,'Education','universities','painting'),		 
       ('shakespears.com','2019-12-1 12:49:49',6,'Entertainment','theatre','photographing'),
	   ('weLearn.com','2010-12-2 12:59:59',5,'Education','high schools','painting'),
	   ('weRead.com','2010-12-1 12:59:59',7,'Tourism','culutural','photographing'),        --new
	   ('Mosques.com','2010-12-1 12:59:59',8,'Tourism','religious','photographing'),        --new
	   ('laugh.com','2010-12-1 12:59:59',4,'Entertainment','standups','photographing');   --new



INSERT INTO Original_Content
VALUES (1,11,9,1,1,3),	
	   (2,12,9,1,1,4),		
	   (3,11,10,null,null,null);

INSERT INTO Existing_request
VALUES (1,2),
	   (2,2);
INSERT INTO Notification_object DEFAULT VALUES  
INSERT INTO Notification_object DEFAULT VALUES  
INSERT INTO Notification_object DEFAULT VALUES  
INSERT INTO Notification_object DEFAULT VALUES  
INSERT INTO Notification_object DEFAULT VALUES  
INSERT INTO Notification_object DEFAULT VALUES  
INSERT INTO Notification_object DEFAULT VALUES  
INSERT INTO Notification_object DEFAULT VALUES  
INSERT INTO Notification_object DEFAULT VALUES  
INSERT INTO Notification_object DEFAULT VALUES  
INSERT INTO Notification_object DEFAULT VALUES  
INSERT INTO Notification_object DEFAULT VALUES  
INSERT INTO Notification_object DEFAULT VALUES  
		

INSERT INTO New_request
VALUES  (1,1,1,1,4,null,'2010-1-1 12:59:59'),
		(1,1,1,2,4,null,'2010-2-1 12:59:59'),
		(1,1,1,3,5,null,'2010-3-1 12:59:59'),
		(1,1,2,4,5,null,'2010-4-1 12:59:59'),
		(1,1,2,5,5,null,'2010-5-1 12:59:59'),
		(1,1,2,6,6,null,'2010-5-2 12:59:59'),
		(1,1,3,7,7,null,'2010-5-6 12:59:59'),
		(1,1,3,8,8,null,'2010-1-7 12:59:59'),
		(0,0,3,9,null,null,null),
		(0,0,1,10,null,null,null),
		(0,0,2,11,null,null,null);


INSERT INTO New_Content
Values (4,2),
	   (5,3),
	   (6,4);


INSERT INTO Event_
VALUES  ('party','nasr city','Cairo','2017-12-1 7:59:59','funGuy',12,1),
	    ('anniversary','5th settlement','Cairo','2017-12-1 5:59:59','funnierGuy',13,2);


INSERT INTO Advertisement
VALUES ('Come to the party','nasr city',3,1),
	   ('Come to the anniversary','5th settlement',4,2);


