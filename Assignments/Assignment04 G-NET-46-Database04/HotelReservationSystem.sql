
-- ======================
-- 1. INSERT OPERATIONS : 
-- ======================

-- Insert a Guest (FullName, Nationality, PassportNumber, DateOfBirth) 
INSERT INTO Guests (FullName, Nationality, ID_Passport_Number, DateOfBirth)
VALUES ('Mohamed Ali', 'Egyptian', 'A12345678', '1995-06-15');

--  Insert multiple Guests in one statement 
INSERT INTO Guests (FullName, Nationality, ID_Passport_Number, DateOfBirth)
VALUES 
('Sara Ahmed', 'Egyptian', 'B98765432', '1998-02-20'),
('John Smith', 'British', 'UK445566', '1990-11-10'),
('Lina Hassan', 'Jordanian', 'J778899', '1996-08-05');


-- ======================
-- 2. UPDATE OPERATIONS 
-- ======================

-- Increase DailyRate by 15% for all suites 
UPDATE Rooms
SET DailyRate = DailyRate * 1.15
WHERE RoomType = 'Suite';

/* Update ReservationStatus: If CheckoutDate < GETDATE() → 
'Completed' If CheckinDate > GETDATE() → 'Upcoming' Else → 
'Active' */
UPDATE Reservations
SET Status =
    CASE
        WHEN CheckOutDate < GETDATE() THEN 'Completed'
        WHEN CheckInDate > GETDATE() THEN 'Upcoming'
        ELSE 'Active'
    END;

-- ======================
-- 3. DELETE OPERATIONS 
-- ======================

-- Delete Reservation_Guest for a reservation 
DELETE FROM Guest_Reservations
WHERE ReservationID = 10;

-- ======================
-- 4. MERGE OPERATION 
-- ======================

/* Create table #StaffUpdates (StaffId, FullName, Position, Salary) 
MERGE logic: 
Match → Update Position + Salary 
Not matched in Hotel DB → Insert 
Not matched in Update table → Delete  */

CREATE TABLE #StaffUpdates (
    StaffID INT,
    FullName VARCHAR(100),
    Position VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO #StaffUpdates
VALUES
(1, 'Ahmed Samy', 'Manager', 15000),
(3, 'Nour Hassan', 'Receptionist', 6000),
(20, 'Omar Adel', 'Cleaner', 4000);

MERGE Staff AS Target
USING #StaffUpdates AS Source
ON Target.StaffID = Source.StaffID

WHEN MATCHED THEN
    UPDATE SET
        Target.Position = Source.Position,
        Target.Salary = Source.Salary

WHEN NOT MATCHED BY TARGET THEN
    INSERT (FullName, Position, Salary, HotelID)
    VALUES (Source.FullName, Source.Position, Source.Salary, 1)

WHEN NOT MATCHED BY SOURCE THEN
    DELETE;


-- Adding Some Data in hotel table for doing last Query (Merge)
SELECT * FROM Hotels;

INSERT INTO Hotels (HotelName, StarRating, Address, City, ContactNumber)
VALUES
('Royal Palace Hotel', 5, 'Nile Street', 'Cairo', '0223456789'),
('Sea View Resort', 4, 'Beach Road', 'Alexandria', '0345678912'),
('Golden Tower Hotel', 5, 'Downtown', 'Giza', '0234567891');
