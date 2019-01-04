
EXEC Original_Content_Search 'painting','Entertainment';

EXEC Contributor_Search 'e ee eee';

DECLARE @userId int
EXEC Register_User 'user','zaki2@yahoo.com','123456','ahmed','ashraf','zaki','5-19-1998',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,@userId OUTPUT ;
Print @userId;

DECLARE @userId1 int
EXEC Register_User 'Viewer','khaled@yahoo.com','123456','Khaled','Mohammed','Elsawy','5-19-1997','Media Production City','Acting','fancy place',NULL,NULL,NULL,NULL,NULL,NULL,@userId1 OUTPUT ;
Print @userId1;

DECLARE @userId2 int
EXEC Register_User 'Staff','joe@yahoo.com','123456','Joe',NULL,'White','3-19-1996',NULL,NULL,NULL,NULL,NULL,NULL,'5-5-2005',20,100,@userId2 OUTPUT ;
Print @userId2;

DECLARE @userId3 int
EXEC Register_User 'Content Manager','mike@yahoo.com','123456','Mike',NULL,'Green','5-11-1995',NULL,NULL,NULL,NULL,NULL,NULL,'6-6-2006',30,90,@userId3 OUTPUT ;
Print @userId3;

EXEC Check_Type 'logo',11
EXEC Check_Type 'painting',11

EXEC Order_Contributor

EXEC Show_Original_Content 5

EXEC Show_Original_Content null

Declare @user_id7 int
EXEC User_login 'zaki2@yahoo.com','123456',@user_id7 OUTPUT ;
Print(@user_id7)

Declare @emailO varchar(15) Declare @passwordO varchar(15) Declare @firstnameO varchar(15) Declare @middlenameO varchar(15)  Declare @lastnameO varchar(15)   Declare @birth_dateO date  Declare @working_place_nameO varchar(15)   Declare @working_place_typeO varchar(15)   Declare @wokring_place_descriptionO varchar(MAX)   Declare @specilizationO varchar(15)   Declare @portofolio_linkO varchar(40)   Declare @years_experienceO int Declare @hire_dateO date   Declare @working_hoursO decimal(8,2)  Declare @payment_rateO decimal(8,2)
EXEC Show_Profile 8,@emailO OUTPUT,@passwordO OUTPUT,@firstnameO OUTPUT,@middlenameO OUTPUT, @lastnameO OUTPUT,  @birth_dateO OUTPUT, @working_place_nameO OUTPUT,  @working_place_typeO OUTPUT,  @wokring_place_descriptionO OUTPUT,  @specilizationO OUTPUT,  @portofolio_linkO OUTPUT,  @years_experienceO OUTPUT,@hire_dateO OUTPUT,  @working_hoursO  OUTPUT,@payment_rateO  OUTPUT;
Print @emailO; Print @passwordO; Print @firstnameO; Print @middlenameO;  Print @lastnameO;   Print @birth_dateO;  Print @working_place_nameO;   Print @working_place_typeO;   Print @wokring_place_descriptionO;   Print @specilizationO;   Print @portofolio_linkO;   Print @years_experienceO; Print @hire_dateO;   Print @working_hoursO ;  Print @payment_rateO;

EXEC Edit_Profile 10,null,null,null,null,null,null,null,null,null,null,null,null,null,null,31;

EXEC Deactivate_Profile 1012

EXEC Show_Event 1
EXEC Show_Event 3

EXEC Show_Notification 4

EXEC Show_New_Content 3,5
EXEC Show_New_Content 3,null

DECLARE @event_id int;
EXEC Viewer_Create_Event 'Giza','5-15-2010','we will have fun','funniestGuy',3,'Haram', @event_id OUTPUT
Print(@event_id)

Exec Viewer_Upload_Event_Photo 5,'funPhotosInGiza.fun'

Exec Viewer_Upload_Event_Video 5,'funVideosInGiza.fun'

Exec Viewer_Create_Ad_From_Event 5

Exec Apply_Existing_Request 3,2

Exec Apply_New_Request 'I want a dragon',7, 3

Exec Apply_New_Request 'I want 2 dragon',7, 3

Exec Delete_New_Request 12

Exec Rating_Original_Content 3, 3.1, 2

declare @time date
set @time = CURRENT_TIMESTAMP
Exec Write_Comment 'Not bad',2, 3,@time

declare @time date
set @time = CURRENT_TIMESTAMP
Exec Edit_Comment 'Not bad, keep it up', 2,3,'11/23/2018 12:00:00 AM', @time

Exec Delete_Comment 2,3,'11/23/2018 12:00:00 AM'

Exec Create_Ads 1,'i want to tell you that it is too late ', 'GUC'

Exec Edit_Ad 5,'i want to tell you that it is too late, OKAY ?!', 'GUC'

Exec Delete_Ads 5

Exec Send_Message 'Its been 7 YEARS! WHERE IS MY NEW CONTENT,man ?!', 1,5,0, '11/21/2018 7:00:00 AM'

Exec Show_Message 5

Exec Highest_Rating_Original_content

Exec Assign_New_Request 11,4

Exec Receive_New_Requests null, 4

Exec Respond_New_Request 4, 1, 11

Exec Upload_Original_Content 'logo','universities', 'Education', 5 ,'newGizaLogo.com'

Exec Upload_New_Content 7, 8, 'standups', 'Entertainment', 'absloutelyNOthing.com'

Exec Delete_Content 7
Exec Delete_Content 1

declare @can bit
Exec Receive_New_Request 7,@can OUTPUT
Print(@can)

Exec reviewer_filter_content 9,3,1

Exec content_manager_filter_content 11,3,1

Exec Staff_Create_Category 'Tech'

Exec Staff_Create_Subcategory 'Tech', 'Computers'

Exec Staff_Create_Type 'Vector art'

Exec Most_Requested_Content

Exec Workingplace_Category_Relation

declare @time date
set @time = CURRENT_TIMESTAMP
Exec Write_Comment 'Not bad',2, 3,@time
Exec Delete_Comment_by_staff 2, 3, '11/23/2018 12:00:00 AM'

Exec Delete_Original_Content 3 

Exec Delete_New_Content 8

Exec Assign_Contributor_Request 4, 8

Exec Show_Possible_Contributors

