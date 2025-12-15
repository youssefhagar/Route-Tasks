CREATE DATABASE HotelReservationDB;
GO
USE HotelReservationDB;
GO



-- ======
-- Hotel Table

CREATE TABLE Hotels (
    HotelID INT IDENTITY PRIMARY KEY,
    HotelName VARCHAR(100) NOT NULL,
    StarRating INT CHECK (StarRating BETWEEN 1 AND 5),
    Address VARCHAR(200),
    City VARCHAR(100),
    ContactNumber VARCHAR(20)
);



-- Staff Table
CREATE TABLE Staff (
    StaffID INT IDENTITY PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Position VARCHAR(50),
    Salary DECIMAL(10,2),
    HotelID INT NOT NULL,
    CONSTRAINT FK_Staff_Hotel
        FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID)
);


-- Hotel-Manager
ALTER TABLE Hotels
ADD ManagerID INT;

ALTER TABLE Hotels
ADD CONSTRAINT FK_Hotel_Manager
FOREIGN KEY (ManagerID) REFERENCES Staff(StaffID);


-- Rooms
CREATE TABLE Rooms (
    RoomID INT IDENTITY PRIMARY KEY,
    HotelID INT NOT NULL,
    RoomNumber INT NOT NULL,
    RoomType VARCHAR(20) CHECK (RoomType IN ('Single','Double','Suite')),
    Capacity INT,
    DailyRate DECIMAL(10,2),
    IsAvailable BIT DEFAULT 1,
    CONSTRAINT UQ_Room UNIQUE (HotelID, RoomNumber),
    CONSTRAINT FK_Room_Hotel
        FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID)
);

CREATE TABLE RoomAmenities (
    AmenityID INT IDENTITY PRIMARY KEY,
    AmenityName VARCHAR(50) UNIQUE
);

CREATE TABLE Room_Amenities (
    RoomID INT,
    AmenityID INT,
    PRIMARY KEY (RoomID, AmenityID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    FOREIGN KEY (AmenityID) REFERENCES RoomAmenities(AmenityID)
);


CREATE TABLE Guests (
    GuestID INT IDENTITY PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    DateOfBirth DATE,
    ContactDetails VARCHAR(150),
    Nationality VARCHAR(50),
    ID_Passport_Number VARCHAR(50) UNIQUE
);

CREATE TABLE Reservations (
    ReservationID INT IDENTITY PRIMARY KEY,
    HotelID INT NOT NULL,
    CheckInDate DATE,
    CheckOutDate DATE,
    BookingDate DATE DEFAULT GETDATE(),
    Adults INT,
    Children INT,
    TotalPrice DECIMAL(12,2),
    Status VARCHAR(20) CHECK (Status IN ('Confirmed','Checked-in','Canceled','Completed')),
    CONSTRAINT FK_Reservation_Hotel
        FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID)
);


CREATE TABLE Guest_Reservations (
    GuestID INT,
    ReservationID INT,
    PRIMARY KEY (GuestID, ReservationID),
    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID),
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID)
);

CREATE TABLE Reservation_Rooms (
    ReservationID INT,
    RoomID INT,
    PRIMARY KEY (ReservationID, RoomID),
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);


CREATE TABLE Payments (
    PaymentID INT IDENTITY PRIMARY KEY,
    PaymentDate DATE,
    Amount DECIMAL(12,2),
    Method VARCHAR(20) CHECK (Method IN ('Cash','Credit Card','Online')),
    ConfirmationNumber VARCHAR(50)
);


CREATE TABLE Reservation_Payments (
    ReservationID INT,
    PaymentID INT,
    PRIMARY KEY (ReservationID, PaymentID),
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID),
    FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID)
);

CREATE TABLE Staff_Reservations (
    StaffID INT,
    ReservationID INT,
    PRIMARY KEY (StaffID, ReservationID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID)
);


CREATE TABLE Services (
    ServiceID INT IDENTITY PRIMARY KEY,
    ServiceName VARCHAR(50) UNIQUE
);


CREATE TABLE ServiceRequests (
    RequestID INT IDENTITY PRIMARY KEY,
    ReservationID INT NOT NULL,
    ServiceID INT NOT NULL,
    StaffID INT NOT NULL,
    RequestDate DATE,
    Charge DECIMAL(10,2),
    FOREIGN KEY (ReservationID) REFERENCES Reservations(ReservationID),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);









