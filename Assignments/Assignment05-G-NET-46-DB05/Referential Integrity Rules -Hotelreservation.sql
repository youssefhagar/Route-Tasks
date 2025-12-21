/*
######################################
## Referential Integrity Rules  
Note : Use Hotel System Database 
######################################
*/


 /*
Question 01 : 

● If a hotel is deleted from the Hotels table, what is the appropriate 
behavior for the rooms belonging to that hotel? Explain which 
foreign key rule you would choose and why And Represent Rule 
*/

-- Answer : 

-- If a hotel is deleted from the Hotels table -> We Must delete The rooms that belong to .
-- foreign key rule I would choose is : ( CasCade )

-- first delete column HotelID 
Alter Table Rooms 
Add constraint FK_Rooms_Hotels
foreign key (HotelID) references Hotels(HotelID)
ON DELETE CASCADE
ON UPDATE CASCADE;



/*
Question 2:
When a room is deleted from the Rooms table, what should
happen to the related records in Amenities? Which rule makes the
most sense for this relationship, and why? And Represent Rule
*/

-- Answer :
-- When a room is deleted from the Rooms table -> We Must Make => all amenities that belong to this room equal to => [ NULL ]
-- The foreign key rule I would choose is : ( SETNULL )
-- Because amenities can exist without a room

-- first delete column RoomID 
Alter Table Amenities
Add constraint FK_Amenities_Rooms
foreign key (RoomID) references Rooms(RoomID)
ON DELETE SET NULL
ON UPDATE CASCADE;



/*
Question 03 : 
● If a staff member’s ID changes, what impact should this have on 
the Services they are linked to? Which update rule is most 
suitable? And Represent Rule 
*/

-- Answer :
-- If a staff member’s ID is updated in the Staff table,
-- the related records in the Services table should be updated automatically.
-- The most suitable foreign key rule is : ( ON UPDATE CASCADE )


Alter Table Services
Add constraint FK_Services_Staff
foreign key (StaffID) references Staff(StaffID)
ON UPDATE CASCADE;