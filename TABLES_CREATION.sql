


Create table User_									
(
	id int primary key identity(1,1),
	first_name varchar(15),
	middle_name varchar(15),
	last_name varchar(15),
	birth_date date,
	age AS YEAR(CURRENT_TIMESTAMP) - YEAR(birth_date),
	u_password varchar(20) not null,
	email varchar(15) unique,
	activated bit default 1,
	last_login datetime
);

GO

Create table Viewer									
(
	id int primary key ,
	foreign key(id) references User_  ON DELETE CASCADE,
	working_place varchar(15),
	working_place_type varchar(15),
	working_place_description text
);

GO

Create table Notified_Person(
	id int primary key ,
);

GO

Create table Contributer(
	id int primary key ,
	foreign key(id) references User_  ON DELETE CASCADE ,
	notified_id int ,
	foreign key(notified_id) references Notified_Person ,
	years_of_experience int,
	portfolio_link varchar(40),
	specialization varchar(15),
    Avg_Response decimal(8,2) default 0.0,
	Currently_handled int default 0,
	no_of_requests_handled int default 0
);

GO

Create table Staff(
	id int primary key ,
	foreign key(id) references User_  ON DELETE CASCADE ,
	notified_id int ,
	foreign key(notified_id) references Notified_Person ,
	years_of_experience int,
    working_hours decimal(8,2),
	payment_rate decimal(8,2),
	hire_date date,
	total_salary AS working_hours*payment_rate
);

GO

Create table Content_type(
	c_type varchar(15) primary key ,
);

GO

Create table Content_manager(
	id int primary key ,
	foreign key(id) references Staff  ON DELETE CASCADE,
	c_type varchar(15),
	foreign key(c_type) references Content_type
);

GO

Create table Reviewer(
	id int primary key ,
	foreign key(id) references Staff ON DELETE CASCADE
);

GO

Create table Message_(
	sender_type bit,
	read_status bit,
	sent_at datetime,
	read_at datetime,
	m_text text,
	contributer_id int ,
	foreign key(contributer_id) references Contributer,
	viewer_id int ,
	foreign key(viewer_id) references Viewer,
	primary key(sent_at, contributer_id, viewer_id, sender_type)
);

GO

Create table Category(
	ca_type varchar(15) primary key ,
	ca_description text
);

GO

Create table Sub_Category(
	ca_type varchar(15) ,
	foreign key(ca_type) references Category,
	s_name varchar(15),
	primary key(ca_type,s_name)
);

GO

Create table  Notification_object  (
id int primary key identity(1,1), 
 ); 

GO

 Create table Content ( 
	id int primary key identity(1,1),
	link  varchar (40),
	uploaded_at datetime,
	contributer_id int,
	foreign key ( contributer_id) references Contributer ,
	category_type varchar (15 ),
	subcategory_name varchar(15),
	foreign key ( category_type,subcategory_name) references Sub_category,
	c_type varchar (15 ),	--content type
	foreign  key (c_type) references Content_type
 );

 GO

Create table Original_Content(
	id int primary key,
	foreign key(id) references Content ON DELETE CASCADE,
	content_manager_id int,
	foreign key(content_manager_id) references Content_manager,
	reviewer_id int,
	foreign key(reviewer_id) references Reviewer,
	review_status bit, --by	reviewer
	filter_status bit, --by content_manager
	rating decimal(8,2)
);

GO

Create table New_request  (
	id int primary key identity(1,1) ,
	accept_status bit ,
	specified bit ,
	viewer_id int ,
	foreign key ( viewer_id) references Viewer,
	notif_obj_id int,
	foreign key (notif_obj_id) references Notification_object,
	contributer_id int,
	foreign key (contributer_id ) references Contributer,
	info text,
	accepted_at datetime 
);

GO

Create table Existing_request  (
	id int primary key identity(1,1),
	viewer_id int ,
	foreign key (viewer_id) references Viewer,
	original_content_id int,
	foreign key (original_content_id) references Original_Content,

);

GO

Create table New_Content(
	id int primary key,
	foreign key(id) references Content ON DELETE CASCADE,
	new_request_id int ,
	foreign key(new_request_id) references New_Request
);

GO

Create table Comment(
	viewer_id int ,
	foreign key(viewer_id) references Viewer,
	original_content_id int,
	foreign key(original_content_id) references Original_Content,
	co_date datetime ,
	co_text text
	primary key(viewer_id,original_content_id,co_date)
);

GO

Create table Rate (
	viewer_id int,
	FOREIGN KEY(viewer_id) REFERENCES Viewer,
	original_content_id int,
	FOREIGN KEY(original_content_id) REFERENCES Original_Content,
	PRIMARY KEY(viewer_id,original_content_id),
	r_date datetime,
	rate decimal(8,2)
);

GO

Create table Event_(
	id int primary key identity(1,1),
	e_description text,
	e_location varchar(15),
	city varchar (15),
	e_time datetime,
	entertainer varchar(15),
	notification_object_id int,
	FOREIGN key (notification_object_id) REFERENCES Notification_Object,
	viewer_id int,
	FOREIGN key (viewer_id) REFERENCES Viewer,
);

GO

Create table Event_Photos_link(
	event_id int ,
	FOREIGN key(event_id) REFERENCES Event_,
	link varchar(40),
	PRIMARY KEY(event_id,link)
);

GO

Create table Event_Videos_link(
	event_id int ,
	FOREIGN key(event_id) REFERENCES Event_,
	link varchar(40),
	PRIMARY KEY(event_id,link)
);

GO

Create table Advertisement(
	id int primary key identity(1,1),
	a_description text,
	a_location varchar(20),
	event_id int,
	FOREIGN key (event_id) REFERENCES Event_,
	viewer_id int,
	FOREIGN key (viewer_id) REFERENCES Viewer,
);

GO

Create table Ads_Video_Link(
	advertisement_id int,
	FOREIGN key (advertisement_id) REFERENCES Advertisement,
	link varchar(40),
	PRIMARY KEY(advertisement_id,link)
);

GO

Create table Ads_Photos_Link(
	advertisement_id int,
	FOREIGN key (advertisement_id) REFERENCES Advertisement,
	link varchar(40),
	PRIMARY KEY(advertisement_id,link)
);

GO

Create table Announcement(
	id int primary key identity(1,1) ,
	seen_at datetime,
	sent_at datetime,
	notified_person_id int ,
	FOREIGN key (notified_person_id) REFERENCES Notified_Person,
	notified_object_id int,
	FOREIGN key (notified_object_id)REFERENCES Notification_object,
)

GO



