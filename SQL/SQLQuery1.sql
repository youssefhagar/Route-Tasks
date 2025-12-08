Create Database BankSystem
Use BankSystem


---Manager
create table Manager
(
Id int Primary Key,
FullName varchar(100) Not null,
Email varchar(100) unique Not null,
phonenumber varchar(11) unique,
Hiredate Date 
)


---Customers
create table Customers
(
customerNumber int Primary Key,
fullName varchar(100) Not null,
email varchar(100) unique Not null,
phonenumber varchar(11) unique null,
dateOfBirth Date ,
gender char(1) check (gender IN ('M', 'F')),
nationalId varchar(100) unique Not null,
)


---Branches
create table Branches
(
code int Primary Key,
name varchar(100) Not null,
address varchar(100) Not null,
phonenumber varchar(50) unique Not null,
managerId int unique,
Constraint FK_BM_Manage Foreign Key (managerId ) references Manager (Id)
)


-- Accounts
create table Accounts
(
accountNumber int Primary Key,
accountType varchar(20) NOT NULL CHECK (accountType IN ('savings', 'current', 'business')),
OpeningData date not null,
branchCode int not null,
Constraint FK_AB_Belong  Foreign Key (branchCode ) references Branches (code)
)


-- Transactions
create table Transactions
(
transactionNumber int Primary Key,
transactionType varchar(50) NOT NULL CHECK (transactionType IN ('deposit', 'withdrawal', 'transfer' ,'payment')),
transactionData date not null,
amount int not null,
note varchar(100) ,
accountNumber int Not null,
Constraint FK_AB_RelatedTo  Foreign Key (accountNumber ) references Accounts (accountNumber)
)



create table CustomersAccount
(
accountNumber int Not null,
customerNumber int Not null ,
ownershipStartDate date Not null,
ownershipType varchar(20) NOT NULL CHECK (ownershipType IN ('primary holder', 'co-holder')),
accountStatus BIT NOT NULL,
Constraint FK_CA_Owns  Foreign Key (accountNumber ) references Accounts (accountNumber),
Constraint FK_CA_OwnedBy  Foreign Key (customerNumber ) references Customers (customerNumber)
)









