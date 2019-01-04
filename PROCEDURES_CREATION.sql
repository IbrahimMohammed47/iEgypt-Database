--registered/unregistered 1
CREATE PROC Original_Content_Search
@typename varchar(15),
@categoryname varchar(15)
AS
BEGIN
	SELECT c.link As Link,c.uploaded_at As UploadDate, c.c_type As [Type], oc.rating As Rating, first_name+' '+middle_name+' '+last_name AS Contributor
	FROM Original_Content oc INNER JOIN Content c ON oc.id = c.id
							 INNER JOIN User_ u ON u.id = contributer_id
	WHERE (@categoryname=c.category_type OR @typename=c.c_type) AND oc.filter_status=1 AND oc.review_status=1
END

GO

--registered/unregistered 2
CREATE PROC Contributor_Search
@fullname varchar(47)
AS
BEGIN
	SELECT first_name+' '+middle_name+' '+last_name AS [Name] , email As Email, CONVERT(varchar(10),years_of_experience) + ' years' As Experience,specialization As Specialization, portfolio_link As Portfolio
	FROM User_ u INNER JOIN Contributer c
	ON u.id = c.id
	WHERE u.first_name +' '+u.middle_name+' '+u.last_name = @fullname

 
GO

--registered/unregistered 3
CREATE PROC Register_User
@user_type varchar(15),
@email varchar(15),
@u_password varchar(20),
@firstname varchar(15),				--USER
@middlename varchar(15),
@lastname varchar(15),
@birth_date date,
@working_place_name varchar(15), 
@working_place_type varchar(15),	--VIEWER
@wokring_place_description text,

@specilization varchar(15), 
@portofolio_link varchar(40),       --CONTRIBUTER 

@years_experience int,              --CONTRIBUTER OR STAFF

@hire_date date,
@working_hours decimal(8,2),		--STAFF	
@payment_rate decimal(8,2), 

@user_id int OUTPUT
AS 
BEGIN

	INSERT INTO User_ VALUES (@firstname,@middlename,@lastname,@birth_date,@u_password,@email,1,CURRENT_TIMESTAMP);

	If (@user_type='Viewer')BEGIN
		INSERT INTO Viewer VALUES(IDENT_CURRENT('User_'),@working_place_name,@working_place_type,@wokring_place_description);END
	Else If (@user_type = 'Contributer')BEGIN
		INSERT INTO Notified_Person VALUES(IDENT_CURRENT('User_'));
		INSERT INTO Contributer(id,notified_id,years_of_experience,portfolio_link,specialization) VALUES(IDENT_CURRENT('User_'),IDENT_CURRENT('User_'),@years_experience,@portofolio_link,@specilization);END
	Else If (@user_type = 'Staff')BEGIN
		INSERT INTO Notified_Person VALUES(IDENT_CURRENT('User_'));
		INSERT INTO Staff VALUES(IDENT_CURRENT('User_'),IDENT_CURRENT('User_'),@years_experience,@working_hours,@payment_rate,@hire_date);END
	Else If (@user_type = 'Content Manager') BEGIN
		INSERT INTO Notified_Person VALUES(IDENT_CURRENT('User_'));
		INSERT INTO Staff VALUES(IDENT_CURRENT('User_'),IDENT_CURRENT('User_'),@years_experience,@working_hours,@payment_rate,@hire_date);
		INSERT INTO Content_manager VALUES(IDENT_CURRENT('User_'),NULL);END
	SET @user_id = IDENT_CURRENT('User_');
	RETURN @user_id;
END

GO

--registered/unregistered 4
CREATE PROC Check_Type 
@typename varchar(15),
@content_manager_id int
As 
BEGIN
	If(EXISTS(SELECT * FROM Content_type WHERE c_type=@typename))BEGIN
		UPDATE Content_manager
		SET c_type = @typename
		WHERE id = @content_manager_id ;
	END
	ELSE BEGIN
		INSERT INTO Content_type VALUES (@typename);
		UPDATE Content_manager
		SET c_type = @typename
		WHERE id = @content_manager_id ;
	END
END
 
GO

--registered/unregistered 5
CREATE PROC Order_Contributor
As
BEGIN 
	SELECT first_name+' '+middle_name+' '+last_name AS [Name] , email As Email, CONVERT(varchar(10),years_of_experience) + ' years' As Experience,specialization As Specialization, portfolio_link As Portfolio
	FROM Contributer c INNER JOIN User_ u ON c.id = u.id
	ORDER BY(years_of_experience) DESC
END
 
GO

--registered/unregistered 6
CREATE PROC Show_Original_Content 
@contributor_id int
AS
BEGIN
	If(@contributor_id is NULL )BEGIN
		SELECT c.link As Link,c.uploaded_at As UploadDate, c.category_type As Category,c.subcategory_name As SubCategory, c.c_type As [Type], oc.rating As Rating, u.first_name+' '+u.middle_name+' '+u.last_name AS Contributer , u.email As Email, CONVERT(varchar(10),con.years_of_experience) + ' years' As Experience, con.specialization As Specialization, con.portfolio_link As Portfolio
		FROM Content c INNER JOIN Original_Content oc ON (c.id = oc.id)
					   INNER JOIN Contributer con ON( c.contributer_id = con.id)
					   INNER JOIN User_ u On u.id = con.id
		WHERE oc.filter_status= 1 AND oc.review_status=1 
	END
	ELSE BEGIN
		SELECT c.link As Link,c.uploaded_at As UploadDate, c.category_type As Category,c.subcategory_name As SubCategory, c.c_type As [Type], oc.rating As Rating, u.first_name+' '+u.middle_name+' '+u.last_name AS Contributer , u.email As Email, CONVERT(varchar(10),con.years_of_experience) + ' years' As Experience, con.specialization As Specialization, con.portfolio_link As Portfolio
		FROM Content c INNER JOIN Original_Content oc ON (c.id = oc.id)
					   INNER JOIN Contributer con ON( c.contributer_id = con.id) 
					   INNER JOIN User_ u On u.id = con.id
		WHERE oc.filter_status= 1 AND oc.review_status=1 AND c.contributer_id=@contributor_id
	END
END
 
GO

--registered 1
CREATE PROC User_login
@email varchar(15),
@password varchar(20),
@user_id int OUTPUT
AS
BEGIN 
	if(EXISTS(SELECT id FROM User_ Where @email = email AND @password = u_password))BEGIN
		if(EXISTS(SELECT id FROM User_ Where @email = email AND (DATEDIFF(week,last_login,CURRENT_TIMESTAMP)<2)))BEGIN 
			SELECT @user_id=id FROM User_ Where @email = email ;
			update User_ SET last_login = CURRENT_TIMESTAMP where @email = email;
			if(Exists(SELECT id FROM User_ Where @email = email AND activated=0))BEGIN
				update User_ SET activated = 1 where @email = email;
			END
		END
		ELSE BEGIN
			SET @user_id = -2; -- deactivated account
		END
	END
	ELSE SET @user_id = -1; -- wrong credintials 
	Return @user_id;
END
 
GO

--registered 2
CREATE PROC Show_Profile
@user_id int,
@email varchar(15) OUTPUT, 
@password varchar(15) OUTPUT, 
@firstname varchar(15) OUTPUT, 
@middlename varchar(15) OUTPUT,
@lastname varchar(15) OUTPUT, 
@birth_date date OUTPUT,

@working_place_name varchar(15) OUTPUT, 
@working_place_type varchar(15)  OUTPUT,
@wokring_place_description text OUTPUT, 
@specilization varchar(15)  OUTPUT,
@portofolio_link varchar(40) OUTPUT, 
@years_experience int OUTPUT, 
@hire_date date OUTPUT, 
@working_hours decimal(8,2) OUTPUT, 
@payment_rate decimal(8,2) OUTPUT
As
BEGIN
	SELECT  @password=u_password,@email=email, 
			@firstname=first_name, 
			@middlename=middle_name,
			@lastname=last_name,
			@birth_date=birth_date from User_ Where id=@user_id;
	if(EXISTS(Select c.id FROM User_ u INNER JOIN Contributer c ON  c.id=u.id where @user_id=u.id))BEGIN
	SELECT  @years_experience=years_of_experience ,
			@portofolio_link=portfolio_link ,
			@specilization=specialization 
			FROM User_ u INNER JOIN Contributer c ON  c.id=u.id where @user_id=u.id ;
	END ELSE
	if(EXISTS(Select u.id FROM User_ u INNER JOIN Staff s ON  s.id=u.id where @user_id=u.id))BEGIN
	SELECT	@years_experience=years_of_experience,
		    @working_hours=working_hours,
			@hire_date=hire_date,
			@payment_rate=payment_rate
			FROM User_ u INNER JOIN Staff s ON  s.id=u.id where @user_id=u.id;
	END ELSE
	if(EXISTS(Select v.id FROM User_ u INNER JOIN Viewer v ON  v.id=u.id where @user_id=u.id))BEGIN
	SELECT  @working_place_name= working_place, 
			@working_place_type= working_place_type,
			@wokring_place_description= working_place_description
			FROM User_ u INNER JOIN Viewer v ON  v.id=u.id where @user_id=u.id ;
	END 
END	
 
GO

--registered 3
CREATE PROC Edit_Profile
@user_id int,
@email varchar(15), 
@password varchar(15), 
@firstname varchar(15), 
@middlename varchar(15),
@lastname varchar(15), 
@birth_date date,
@working_place_name varchar(15), 
@working_place_type varchar(15),
@working_place_description text, 
@specialization varchar(15),
@portfolio_link varchar(40), 
@years_experience int, 
@hire_date date, 
@working_hours decimal(8,2), 
@payment_rate decimal(8,2)
As
BEGIN
	if @email is not null  
		update User_ SET email=@email where id = @user_id;
	if @password is not null   
		update User_ SET u_password=@password where id = @user_id;
	if @firstname is not null  
		update User_ SET first_name=@firstname where id = @user_id;
	if @middlename is not null 
		update User_ SET middle_name=@middlename where id = @user_id;
	if @lastname is not null	
		update User_ SET last_name=@lastname where id = @user_id;
	if @birth_date is not null  
		update User_ SET birth_date=@birth_date where id = @user_id;
	if @working_place_name is not null   
		update Viewer SET working_place=@working_place_name where id = @user_id;
	if @working_place_type is not null 
		update Viewer SET working_place_type=@working_place_type where id = @user_id;
	if @working_place_description is not null 
		update Viewer SET working_place_description=@working_place_description where id = @user_id;
	if @specialization is not null   
		update Contributer SET specialization=@specialization where id = @user_id;
	if @portfolio_link is not null 
		update Contributer SET portfolio_link=@portfolio_link where id = @user_id;
	if @hire_date is not null 
		update Staff SET hire_date=@hire_date where id = @user_id;
	if @working_hours is not null
		update Staff SET working_hours=@working_hours where id = @user_id;
	if @payment_rate is not null 
		update Staff SET payment_rate=@payment_rate where id = @user_id;
	if @years_experience is not null BEGIN
		If(EXISTS(SELECT id From Staff where id=@user_id))
			update Staff SET years_of_experience=@years_experience where id = @user_id;
		Else If(EXISTS(SELECT id From Contributer where id=@user_id))
			update Contributer SET years_of_experience=@years_experience where id = @user_id;
	END	
END
 
GO

--registered 4
CREATE PROC Deactivate_Profile 
@user_id int
As
BEGIN
	update User_ SET activated = 0 where @user_id = id;
END

GO

--registered 5
Create Proc Show_Event 
@event_id int
As
BEGIN 
	If(EXISTS(SELECT id From Event_ where id=@event_id))BEGIN
		SELECT e.*,u.first_name,u.middle_name,u.last_name 
		FROM Event_ e INNER JOIN Viewer v ON e.viewer_id=v.id
			          INNER JOIN User_ u ON u.id=v.id
		where e.id = @event_id
	END ELSE BEGIN
		SELECT e.*,u.first_name,u.middle_name,u.last_name 
		FROM Event_ e INNER JOIN Viewer v ON e.viewer_id=v.id
			          INNER JOIN User_ u ON u.id=v.id
	END
END

GO

--registered 6
CREATE PROC Show_Notification 
@user_id int
As 
Begin
	SELECT e.*
	FROM Announcement a INNER JOIN Event_ e ON a.notified_object_id=e.notification_object_id
	Where a.notified_person_id= @user_id
	SELECT n.*
	FROM Announcement a INNER JOIN New_request n ON a.notified_object_id=n.notif_obj_id
	Where a.notified_person_id = @user_id
END

GO

--registered 7
CREATE PROC Show_New_Content 
@viewer_id int,
@content_id int
As
BEGIN
	If(@content_id is null)BEGIN
		SELECT c.*,u.first_name,u.middle_name,u.last_name
		FROM New_Content cn INNER JOIN New_request nr ON cn.new_request_id=nr.id
							INNER JOIN Content c ON cn.id = c.id
							INNER JOIN User_ u ON u.id = nr.contributer_id 
							Where nr.viewer_id=@viewer_id
	END Else BEGIN
		SELECT c.*,u.first_name,u.middle_name,u.last_name
		FROM New_Content cn INNER JOIN New_request nr ON cn.new_request_id=nr.id
							INNER JOIN Content c ON cn.id = c.id
							INNER JOIN User_ u ON u.id = nr.contributer_id 
							Where nr.viewer_id=@viewer_id AND c.id =@content_id
	END
END

GO

--Viewer 1
Create proc Viewer_Create_Event
@city varchar(15), 
@event_date_time datetime, 
@description text, 
@entartainer varchar(15), 
@viewer_id int, 
@location varchar(15), 
@event_id int OUTPUT
AS
BEGIN
	insert into Event_(e_description ,e_location ,city,e_time,entertainer,viewer_id)
	values(@description,@location,@city,@event_date_time,@entartainer,@viewer_id);
	INSERT INTO Notification_object DEFAULT VALUES ;

	insert into Announcement(notified_person_id) SELECT id FROM Notified_Person;
	update Announcement SET notified_object_id=IDENT_CURRENT('Notification_object') where notified_object_id is null;
	SET @event_id=IDENT_CURRENT('Event_');
	update Event_ SET notification_object_id=('Notification_object') where id=@event_id
END

GO

--Viewer 2
create proc Viewer_Upload_Event_Photo
@event_id int , 
@link varchar(40)
As
INSERT INTO Event_Photos_link VALUES(@event_id,@link);

GO

--Viewer 3
create proc Viewer_Upload_Event_Video
@event_id int , 
@link varchar(40)
As
INSERT INTO Event_Videos_link VALUES(@event_id,@link);

GO
--Viewer 3-2
create proc Viewer_Create_Ad_From_Event 
@event_id int
AS 
INSERT INTO Advertisement(a_description,a_location,viewer_id)
SELECT e_description,e_location,viewer_id FROM Event_
where id =@event_id

GO

--Viewer 4
create proc Apply_Existing_Request
@viewer_id int,
@original_content_id int 
AS
If(EXISTS(SELECT * FROM Original_Content WHERE id=@original_content_id AND rating>3))
	INSERT INTO Existing_request VALUES (@viewer_id,@original_content_id)

GO

--Viewer 5
Create proc Apply_New_Request 
@information text, 
@contributor_id int,
@viewer_id int
AS
BEGIN
insert into New_request(info,viewer_id,contributer_id)
values(@information,@viewer_id,@contributor_id);
INSERT INTO Notification_object DEFAULT VALUES ;
update New_request SET notif_obj_id= IDENT_CURRENT('Notification_object') where id=IDENT_CURRENT('New_request')
if(@contributor_id is not null)BEGIN
	insert into Announcement(notified_person_id,notified_object_id)
	VALUES(@contributor_id,IDENT_CURRENT('Notification_object'));
	update New_request Set specified=1 where id=IDENT_CURRENT('New_request');
END ELSE BEGIN
	insert into Announcement(notified_person_id) SELECT id FROM Contributer;
	update Announcement SET notified_object_id=IDENT_CURRENT('Notification_object') where notified_object_id is null;
END
END

GO

--Viewer 6
create proc Delete_New_Request 
@request_id int 
as
delete from New_request where accept_status is null and @request_id=id

GO

--Viewer 7
create proc Rating_Original_Content 
@orignal_content_id int, 
@rating_value int, 
@viewer_id int
as
update Original_Content SET rating=@rating_value,reviewer_id=reviewer_id where id=@orignal_content_id

GO

--Viewer 8
create proc Write_Comment 
@comment_text text,
@viewer_id int, 
@original_content_id int, 
@written_time datetime
as
insert into Comment(co_text,viewer_id,original_content_id,co_date)
values(@comment_text,@viewer_id,@original_content_id,@written_time)

GO

--Viewer 9
create proc Edit_Comment 
@comment_text text, 
@viewer_id int,
@original_content_id int, 
@last_written_time datetime, 
@updated_written_time datetime
as
Update Comment
Set co_text=@comment_text,co_date=@updated_written_time
Where original_content_id=@original_content_id and viewer_id=@viewer_id and co_date=@last_written_time;

GO

--Viewer 10
create proc Delete_Comment 
@viewer_id int, 
@original_content_id int,
@written_time datetime
as
delete from Comment 
where viewer_id=@viewer_id and original_content_id=@original_content_id and co_date=@written_time


GO

--Viewer 11
create proc Create_Ads 
@viewer_id int,
@description text,
@location varchar(20)
as
insert into Advertisement(viewer_id,a_description,a_location)
	values(@viewer_id,@description,@location);

GO

--Viewer 12
create proc Edit_Ad 
@ad_id int,
@description text, 
@location varchar(20)
as
update Advertisement
set a_description=@description,a_location=@location
where id=@ad_id

GO

--Viewer 13
create proc Delete_Ads 
@ad_id int
as
delete from Advertisement where id=@ad_id 

GO

--Viewer 14
create proc Send_Message 
@msg_text text, 
@viewer_id int,
@contributor_id int, 
@sender_type bit, 
@sent_at datetime
as 
insert into Message_(m_text,viewer_id,contributer_id,sender_type,sent_at)
values(@msg_text,@viewer_id,@contributor_id,@sender_type,@sent_at)

GO

--Viewer 15
Create proc Show_Message 
@contributor_id int
as 
select m_text 
from Message_ 
where contributer_id=@contributor_id
update Message_ SET read_at = CURRENT_TIMESTAMP ,read_status=1 
where contributer_id=@contributor_id

GO

--Viewer 16
create proc Highest_Rating_Original_content
as
Declare @maxi decimal(8,2);
SELECT @maxi=MAX(Rating) FROM Original_Content
SELECT * FROM Original_Content where rating=@maxi

GO

--Viewer 17
Create Proc Assign_New_Request 
@request_id int,
@contributor_id int
As
BEGIN 
	if(EXISTS(SELECT * FROM New_request Where id=@request_id AND accept_status is null))BEGIN
		update New_request SET contributer_id=@contributor_id,specified=1 Where id=@request_id ;
	END
END


GO 

--Contributor 1
CREATE PROC Receive_New_Requests 
@request_id int,
@contributor_id int
As
BEGIN
	If(@request_id is null)BEGIN
		SELECT *
		FROM New_request nr
		Where (nr.accept_status is null) AND ((nr.contributer_id = @contributor_id) OR nr.contributer_id is null)
	END Else BEGIN
		SELECT *
		FROM New_request nr
		Where (nr.accept_status is null) AND ((nr.contributer_id = @contributor_id) OR nr.contributer_id is null) AND (nr.id=@request_id)
	END
END

GO

--Contributor 2
CREATE PROC Respond_New_Request 
@contributor_id int, 
@accept_status bit ,
@request_id int
As
BEGIN
	update New_request SET accept_status = @accept_status where id=@request_id AND contributer_id=@contributor_id;
	if(@accept_status=1)BEGIN
		update New_request SET accepted_at = CURRENT_TIMESTAMP Where id=@request_id;
		update Contributer SET Currently_handled = Currently_handled+1 where id= @contributor_id
	END
END

GO

--Contributor 3
CREATE PROC Upload_Original_Content
@type_id varchar(15),
@subcategory_name varchar(15),
@category_id varchar(15), 
@contributor_id int,
@link varchar(40)
As
BEGIN
	INSERT INTO Content VALUES(@link,CURRENT_TIMESTAMP,@contributor_id,@category_id,@subcategory_name,@type_id);
	INSERT INTO Original_Content VALUES(IDENT_CURRENT('Content'),null,null,null,null,null);
END

GO

--Contributor 4
CREATE PROC Upload_New_Content
@new_request_id int,
@contributor_id int,
@subcategory_name varchar(15),
@category_id varchar(15),
@link varchar(40)
As
BEGIN
	Declare @temp int;
	INSERT INTO Content(link,uploaded_at,contributer_id,category_type,subcategory_name,c_type) VALUES(@link,CURRENT_TIMESTAMP,@contributor_id,@category_id,@subcategory_name,null);
	INSERT INTO New_Content VALUES(IDENT_CURRENT('Content'),@new_request_id);
	SELECT @temp=DATEDIFF(day,co.uploaded_at,nr.accepted_at) FROM New_request nr INNER JOIN New_Content nc ON nc.new_request_id=nr.id
																				 INNER JOIN Content co ON co.id = nc.id
	Where nr.id=@new_request_id
	update Contributer SET no_of_requests_handled = no_of_requests_handled+1 Where id=@contributor_id;
	update Contributer SET Avg_Response = Avg_Response+(@temp/no_of_requests_handled) Where id=@contributor_id;
	update Contributer SET Currently_handled = Currently_handled-1 Where id=@contributor_id;
END

GO

--Contributor 5
Create Proc Delete_Content 
@content_id int 
As 
BEGIN
	If(EXISTS(SELECT id FROM Original_Content WHERE id=@content_id AND filter_status is null AND review_status is null))BEGIN
		DELETE FROM Original_Content WHERE id=@content_id ;
		DELETE FROM Content WHERE id=@content_id;
	END Else Print('this content has been filtered,you can not delete it')
	
END

GO

--Contributor 6
CREATE Proc Receive_New_Request 
@contributor_id int ,
@can_receive bit OUTPUT
As 
BEGIN
	Declare @finished_and_notFinished int; 
	SELECT @finished_and_notFinished=COUNT(id)
	FROM New_request
	Where contributer_id=@contributor_id;
	Declare @finished int; 
	SELECT @finished=COUNT(nc.id)
	FROM New_request nr INNER JOIN New_Content nc ON nr.id=nc.new_request_id 
	Where nr.contributer_id=@contributor_id;
	If(@finished_and_notFinished-@finished<3)
		SET @can_receive = 1;
	Else
		SET @can_receive = 0;
END

GO

--Staff 1
CREATE PROC reviewer_filter_content   
@reviewer_id int, 
@original_content int, 
@status int
As 
BEGIN 
	update Original_Content SET review_status = @status
	Where id =@original_content;
	update Original_Content SET reviewer_id = @reviewer_id
	Where id =@original_content;
END

GO

--Staff 2
CREATE PROC content_manager_filter_content 
@content_manager_id int, 
@original_content int, 
@status int
As 
BEGIN 
	If(EXISTS(SELECT oc.id FROM Original_Content oc INNER JOIN Content c ON oc.id=c.id 
											        INNER JOIN Content_manager cm ON c.c_type = cm.c_type 
												    Where oc.id=@original_content AND cm.id =@content_manager_id))BEGIN
		update Original_Content SET filter_status = @status
		Where id =@original_content;
		update Original_Content SET content_manager_id = @content_manager_id
		Where id =@original_content ;
	END
END

GO

--Staff 3
CREATE PROC Staff_Create_Category
@category_name varchar(15)
As
BEGIN 
	INSERT INTO Category VALUES (@category_name,null)
END

GO

--Staff 4
CREATE PROC Staff_Create_Subcategory
@category_name varchar(15),
@subcategory_name varchar(15)
As
BEGIN 
	INSERT INTO Sub_Category VALUES (@category_name,@subcategory_name)
END

GO

--Staff 5
CREATE PROC Staff_Create_Type 
@type_name varchar(15)
As
BEGIN 
	INSERT INTO Content_type VALUES (@type_name)
END

GO

--Staff 6
CREATE PROC Most_Requested_Content
As
BEGIN 
	SELECT original_content_id,COUNT(id) As 'Frequency'
	FROM Existing_request
	GROUP BY original_content_id
	ORDER BY COUNT(id) DESC;
END

GO

--Staff 7
CREATE PROC Workingplace_Category_Relation
As
BEGIN
	SELECT v.working_place_type,ca.ca_type,COUNT(nr.id) as 'counts' INTO temp FROM Viewer v INNER JOIN New_request nr ON v.id =nr.viewer_id 
								  INNER JOIN New_Content nc ON nc.new_request_id=nr.id
								  INNER JOIN Content c      ON c.id=nc.id
								  INNER JOIN Category ca    ON ca.ca_type =c.category_type
	GROUP BY v.working_place_type,ca.ca_type;
	INSERT INTO temp
	SELECT v.working_place_type,ca.ca_type, COUNT(er.id) as 'counts' FROM Viewer v INNER JOIN Existing_request er ON v.id =er.viewer_id 
								  INNER JOIN Original_Content oc ON oc.id=er.original_content_id
								  INNER JOIN Content c           ON c.id =oc.id
								  INNER JOIN Category ca		 ON ca.ca_type =c.category_type
	GROUP BY v.working_place_type,ca.ca_type;
	SELECT working_place_type,ca_type,SUM(counts) As 'No. of requests'
	FROM temp
	GROUP BY working_place_type,ca_type
	ORDER BY working_place_type;
	DROP table temp;
END

GO

--Staff 8
CREATE Proc Delete_Comment_by_staff 
@viewer_id int, 
@original_content_id int, 
@comment_time date
As
BEGIN
	DELETE FROM Comment
	Where viewer_id=@viewer_id AND original_content_id=@original_content_id AND co_date=@comment_time
END

GO

--Staff 9
CREATE PROC Delete_Original_Content 
@content_id int
As
BEGIN
	DELETE FROM Original_Content
	Where id=@content_id;
	DELETE FROM Content
	Where id=@content_id
END

GO

--Staff 10
CREATE PROC Delete_New_Content 
@content_id int
As
BEGIN
	DELETE FROM New_Content
	Where id=@content_id;
	DELETE FROM Content
	Where id=@content_id
END

GO

--Staff 11
CREATE PROC Assign_Contributor_Request 
@contributor_id int, 
@new_request_id int
As
BEGIN
	update New_request SET contributer_id=@contributor_id,specified=1 where id=@new_request_id
END

GO

--Staff 12
CREATE PROC Show_Possible_Contributors
As
BEGIN
	SELECT id As 'Available Contributors'
	FROM Contributer
	where Currently_handled < 3
	ORDER BY Avg_Response , Currently_handled DESC
	SELECT COUNT(nr.id) AS 'number of unassigned new requests'
	FROM New_request nr
	Where nr.contributer_id is null
END

CREATE PROC Get_Type
@u_id int,
@type int OUTPUT
As 
BEGIN
	if(EXISTS(SELECT id FROM Viewer Where @u_id = id))
		SET @type = 1 ;  --viewer
	ELSE if(EXISTS(SELECT id FROM Contributer Where @u_id = id))
		SET @type = 2 ;  --contributor
	ELSE if(EXISTS(SELECT id FROM Staff Where @u_id = id))
		SET @type = 3 ;  --staff
	Return @type;
END