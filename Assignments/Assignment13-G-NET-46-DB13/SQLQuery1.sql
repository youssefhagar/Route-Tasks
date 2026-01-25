 -- SETUP TABLES FOR ASSIGNMENT
 -- ============================================ 
 use MyDatabase
 Go
CREATE TABLE AccountBalance ( 
    AccountId INT PRIMARY KEY, 
    AccountName VARCHAR(100), 
    Balance DECIMAL(18,2) CHECK (Balance >= 0), 
    LastUpdated DATETIME DEFAULT GETDATE() 
); 
GO
CREATE TABLE TransferHistory ( 
    TransferId INT IDENTITY(1,1) PRIMARY KEY, 
    FromAccountId INT, 
    ToAccountId INT, 
    Amount DECIMAL(18,2), 
    TransferDate DATETIME DEFAULT GETDATE(), 
    Status VARCHAR(20), 
    ErrorMessage VARCHAR(500) 
); 
GO 
CREATE TABLE AuditTrail ( 
    AuditId INT IDENTITY(1,1) PRIMARY KEY, 
    TableName VARCHAR(100), 
    Operation VARCHAR(50), 
    RecordId INT, 
    OldValue VARCHAR(500), 
    NewValue VARCHAR(500), 
    AuditDate DATETIME DEFAULT GETDATE(), 
    UserName VARCHAR(100) DEFAULT SYSTEM_USER 
);
-- Insert sample data 
INSERT INTO AccountBalance (AccountId, AccountName, Balance) 
VALUES  
(101, 'Checking Account', 10000.00), 
(102, 'Savings Account', 25000.00), 
(103, 'Investment Account', 50000.00), 
(104, 'Emergency Fund', 15000.00); 
GO 

/*
Question 01 : 
Write a simple transaction that transfers $500 from Account 101 
to Account 102. 
Use BEGIN TRANSACTION and COMMIT TRANSACTION. 
Display the balances before and after the transfer. 
*/
-- Display the balances before the transfer. 

SELECT AccountId, Balance FROM AccountBalance
WHERE AccountId IN (101,102);

Begin Transaction 

if (select a.Balance from AccountBalance a where a.AccountId = 101) >= 500
Begin
-- Withdraw money
UPDATE AccountBalance
SET Balance = Balance - 500
WHERE AccountId = 101;
-- Deposit money
UPDATE AccountBalance
SET Balance = Balance + 500
WHERE AccountId = 102;
-- if all Done
Commit;
End

-- Display the balances before and after the transfer. 
SELECT AccountId, Balance FROM AccountBalance
WHERE AccountId IN (101,102);

/*
Question 02 : 
Write a transaction that attempts to transfer $1000 from Account 101 
to Account 102, but then rolls it back using ROLLBACK TRANSACTION. 
Verify that the balances remain unchanged.. 
*/
-- for Verify that the balances remain unchanged i well use select 
SELECT AccountId, Balance FROM AccountBalance
WHERE AccountId IN (101,102);

Begin Transaction 

if (select a.Balance from AccountBalance a where a.AccountId = 101) >= 1000
Begin
-- Withdraw money
UPDATE AccountBalance
SET Balance = Balance - 1000
WHERE AccountId = 101;
-- Deposit money
UPDATE AccountBalance
SET Balance = Balance + 1000
WHERE AccountId = 102;
-- if all Done
RollBack;
End
-- for Verify that the balances remain unchanged i well use select 
SELECT AccountId, Balance FROM AccountBalance
WHERE AccountId IN (101,102);


/*
Question 03 : 
Write a transaction that checks if Account 101 has sufficient 
balance before transferring $2000 to Account 102. 
If insufficient, rollback the transaction. 
If sufficient, commit the transaction. 
*/
Begin Transaction 

if (select a.Balance from AccountBalance a where a.AccountId = 101) >= 100000
Begin
-- Withdraw money
UPDATE AccountBalance
SET Balance = Balance - 2000
WHERE AccountId = 101;
-- Deposit money
UPDATE AccountBalance
SET Balance = Balance + 2000
WHERE AccountId = 102;
-- if all Done
Print 'Done'
Commit;
End
Else 
Begin 
Print 'Fails..'
Rollback;
End 

-- Display the balances before and after the transfer. 
SELECT AccountId, Balance FROM AccountBalance
WHERE AccountId IN (101,102);

/*
Question 04 : 
Write a transaction using TRY...CATCH that transfers money 
from Account 101 to Account 102. If any error occurs, 
rollback the transaction and display the error message.
*/
BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE AccountBalance SET Balance = Balance - 500 WHERE AccountId = 101;
    UPDATE AccountBalance SET Balance = Balance + 500 WHERE AccountId = 102;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error: '+ERROR_MESSAGE();
END CATCH

/*
Question 05 : 
Write a transaction that uses SAVE TRANSACTION to create 
a savepoint after the first update. Then perform a second 
update and rollback to the savepoint if an error occurs.
*/
BEGIN TRANSACTION;

UPDATE AccountBalance SET Balance = Balance - 300 WHERE AccountId = 101;
SAVE TRANSACTION SavePoint1;

BEGIN TRY
    UPDATE AccountBalance SET Balance = Balance + 300 WHERE AccountId = 102;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION SavePoint1;
END CATCH

COMMIT TRANSACTION;

/*
Question 06 : 
Write a transaction with nested BEGIN TRANSACTION statements. 
Display @@TRANCOUNT at each level to demonstrate how it changes. 
*/

BEGIN TRANSACTION;
PRINT @@TRANCOUNT; 

BEGIN TRANSACTION;
PRINT @@TRANCOUNT; 


COMMIT TRANSACTION;
PRINT @@TRANCOUNT; 

COMMIT TRANSACTION;
PRINT @@TRANCOUNT; 



/*
Question 07 : 
Demonstrate ATOMICITY by writing a transaction that performs 
multiple updates. 
Show that if one fails, all are rolled back. 
*/
-- for verifiy the result
SELECT AccountId, Balance FROM AccountBalance
WHERE AccountId IN (101,102);

Begin Try
	BEGIN TRANSACTION;

	UPDATE AccountBalance SET Balance = Balance - 500 WHERE AccountId = 101;
-- in this error
	UPDATE AccountBalance SET Balance = Balance + 'ABC' WHERE AccountId = 102;
	Commit
End Try
Begin Catch
	ROLLBACK TRANSACTION;
end Catch
-- for verifiy the result
SELECT AccountId, Balance FROM AccountBalance
WHERE AccountId IN (101,102);
/*
Question 08 : 
Demonstrate CONSISTENCY by writing a transaction that ensures 
the total balance across all accounts remains constant. 
Calculate total before and after transfer. 
*/
DECLARE @BeforeTotal DECIMAL(18,2),
        @AfterTotal DECIMAL(18,2);

SELECT @BeforeTotal = SUM(Balance) FROM AccountBalance;

BEGIN TRANSACTION;

UPDATE AccountBalance SET Balance = Balance - 400 WHERE AccountId = 101;
UPDATE AccountBalance SET Balance = Balance + 400 WHERE AccountId = 102;

COMMIT TRANSACTION;

SELECT @AfterTotal = SUM(Balance) FROM AccountBalance;

SELECT @BeforeTotal AS BeforeTotal, @AfterTotal AS AfterTotal;

/*
Question 09 :  
Demonstrate ISOLATION by setting different isolation levels 
and explaining their effects. Use READ UNCOMMITTED, READ 
COMMITTED, and SERIALIZABLE. 
*/

--  READ UNCOMMITTED
--Specifies that statements can read rows that were
--modified by other transactions but not yet committed.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM AccountBalance;

--  READ COMMITTED
-- Specifies that statements can't read data that was modified 
-- but not committed by other transactions.
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM AccountBalance;



SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM AccountBalance;
/*      SERIALIZABLE
Specifies the following conditions:
Statements can't read data that was modified but not yet committed by other transactions.
No other transactions can modify data that was read by the current transaction until the current transaction completes.
Other transactions can't insert new rows with key values that would fall in the range of keys read by any statements in the current transaction until the current transaction completes.
*/

/*
Question 10 :  
Demonstrate DURABILITY by committing a transaction and 
explaining that the changes will persist even after 
system restart or failure. 
*/
BEGIN TRANSACTION;
UPDATE AccountBalance SET Balance = Balance + 200 WHERE AccountId = 102;
COMMIT TRANSACTION;


/*
Question 11 : 
Write a stored procedure that uses transactions to transfer
- money between two accounts. Include parameter validation,
- error handling, and proper transaction management.
*/
Go
CREATE or Alter PROCEDURE TransferMoney @FromAccount INT,@ToAccount INT,@Amount DECIMAL(18,2)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF @Amount <= 0
            THROW 50001, 'Invalid Amount', 1;

        IF (SELECT Balance FROM AccountBalance WHERE AccountId = @FromAccount) < @Amount
            THROW 50002, 'Insufficient Balance', 1;

        UPDATE AccountBalance
        SET Balance = Balance - @Amount
        WHERE AccountId = @FromAccount;

        UPDATE AccountBalance
        SET Balance = Balance + @Amount
        WHERE AccountId = @ToAccount;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error: '+ ERROR_MESSAGE();
    END CATCH
END
-- For Test 
SELECT AccountId, Balance FROM AccountBalance
WHERE AccountId IN (101,102);

Exec TransferMoney 101, 102 ,1000;

SELECT AccountId, Balance FROM AccountBalance
WHERE AccountId IN (101,102);
/*
Question 12 : 
Write a transaction that uses multiple savepoints to handle
- a multi-step operation. If step 2 fails, rollback to savepoint 1.
- If step 3 fails, rollback to savepoint 2. 
*/
BEGIN TRANSACTION;

SAVE TRANSACTION Step1;
UPDATE AccountBalance SET Balance = Balance - 100 WHERE AccountId = 101;

SAVE TRANSACTION Step2;
UPDATE AccountBalance SET Balance = Balance + 100 WHERE AccountId = 102;

SAVE TRANSACTION Step3;
UPDATE AccountBalance SET Balance = Balance + 100 WHERE AccountId = 103;

ROLLBACK TRANSACTION Step2;

COMMIT TRANSACTION;

/*
QUESTION 13 :
- Write a transaction that handles a deadlock scenario using
- TRY...CATCH. Retry the operation if a deadlock is detected. 
*/
/*
Understand deadlocks
A deadlock occurs when two or more tasks permanently block each other by each task having a
lock on a resource that the other tasks are trying to lock.
*/
BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE AccountBalance SET Balance = Balance - 10 WHERE AccountId = 101;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 1205
        PRINT 'Deadlock detected, retry transaction';
    ROLLBACK TRANSACTION;
END CATCH


/*
QUESTION 14 : 
Write a query to check the current transaction count    
(@@TRANCOUNT) 
and demonstrate how it changes within nested transactions. 
*/
-- Fast demonstrate : 
-- When We BEGIN TRANSACTION; the @@TRANCOUNT increment by 1
-- When We commit; the @@TRANCOUNT decrement by 1 
-- When We ROLLBACK the @@TRANCOUNT Equal to 0 

SELECT @@TRANCOUNT;
--- -- -- -- -- -- -- 
BEGIN TRANSACTION;
SELECT @@TRANCOUNT;

BEGIN TRANSACTION;
SELECT @@TRANCOUNT;

ROLLBACK TRANSACTION;
--- -- -- -- -- -- -- 
SELECT @@TRANCOUNT;

/*
QUESTION 15 : 
Write a transaction that logs all changes to the AuditTrail table. 
Include before and after values for updates. 
*/
DECLARE @OldBalance DECIMAL(18,2);

SELECT @OldBalance = Balance
FROM AccountBalance
WHERE AccountId = 101;
-- --
BEGIN TRANSACTION;

UPDATE AccountBalance
SET Balance = Balance - 250
WHERE AccountId = 101;

INSERT INTO AuditTrail
(TableName, Operation, RecordId, OldValue, NewValue)
VALUES
('AccountBalance', 'UPDATE', 101,
 CAST(@OldBalance AS VARCHAR),
 CAST(@OldBalance - 250 AS VARCHAR));

COMMIT TRANSACTION;
-- fro Test 
select * from AuditTrail;
/*
QUESTION 16 : 
Write a transaction that demonstrates the difference between 
COMMIT and ROLLBACK by creating two identical transactions, 
committing one and rolling back the other. 
*/
Begin Transaction 

if (select a.Balance from AccountBalance a where a.AccountId = 101) >= 500
Begin
-- Withdraw money
UPDATE AccountBalance
SET Balance = Balance - 500
WHERE AccountId = 101;
-- Deposit money
UPDATE AccountBalance
SET Balance = Balance + 500
WHERE AccountId = 102;

Commit;
End

Begin Transaction	
if (select a.Balance from AccountBalance a where a.AccountId = 101) >= 500
Begin
-- Withdraw money
UPDATE AccountBalance
SET Balance = Balance - 500
WHERE AccountId = 101;
-- Deposit money
UPDATE AccountBalance
SET Balance = Balance + 500
WHERE AccountId = 102;

RollBack;
End


/*
QUESTION 17 : 
Write a transaction that enforces a business rule: "Total 
withdrawals in a single transaction cannot exceed $5000". 
If violated, rollback the transaction.
*/

BEGIN TRANSACTION;

DECLARE @WithdrawAmount DECIMAL(18,2) = 6000;

IF @WithdrawAmount > 5000
BEGIN
    PRINT 'Withdrawal limit exceeded';
    ROLLBACK TRANSACTION;
END
ELSE
BEGIN
    UPDATE AccountBalance
    SET Balance = Balance - @WithdrawAmount
    WHERE AccountId = 101;

    COMMIT TRANSACTION;
END


/*
QUESTION 18 : 
Write a transaction that uses explicit locking hints (WITH (UPDLOCK)) 
to prevent concurrent modifications during a transfer.
*/
BEGIN TRANSACTION;

UPDATE AccountBalance WITH (UPDLOCK)
SET Balance = Balance - 500
WHERE AccountId = 101;

UPDATE AccountBalance WITH (UPDLOCK)
SET Balance = Balance + 500
WHERE AccountId = 102;

COMMIT TRANSACTION;
-- 
/*
UPDLOCK
Specifies that update locks are to be taken and held until the transaction completes. UPDLOCK takes update locks 
for read operations only at the row-level or page-level. 
If UPDLOCK is combined with TABLOCK, or a table-level lock is taken for some other reason, 
an exclusive (X) lock is taken instead.

When UPDLOCK is specified, the READCOMMITTED and READCOMMITTEDLOCK isolation level hints 
are ignored. For example, if the isolation level of the session is set to SERIALIZABLE and
a query specifies (UPDLOCK, READCOMMITTED), the READCOMMITTED hint is ignored and the transaction is run using 
the SERIALIZABLE isolation level.
*/
/*
QUESTION 19 :  
Write a comprehensive error handling transaction that catches 
specific error numbers and handles them differently. 
Handle: Constraint violations, insufficient funds, and general errors. 
*/
Go
BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @Amount DECIMAL(18,2) = 30000;

    IF (SELECT Balance FROM AccountBalance WHERE AccountId = 101) < @Amount
        THROW 50010, 'Insufficient Funds', 1;

    UPDATE AccountBalance
    SET Balance = Balance - @Amount
    WHERE AccountId = 101;

    UPDATE AccountBalance
    SET Balance = Balance + @Amount
    WHERE AccountId = 102;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;

    IF ERROR_NUMBER() IN (547, 2627)
        PRINT 'Constraint violation occurred';
    ELSE IF ERROR_NUMBER() = 50010
        PRINT 'Insufficient funds error';
    ELSE
        PRINT 'General error: ' + ERROR_MESSAGE();

    INSERT INTO TransferHistory
    (FromAccountId, ToAccountId, Amount, Status, ErrorMessage)
    VALUES
    (101, 102, @Amount, 'FAILED', ERROR_MESSAGE());
END CATCH

/*
QUESTION 120: 
Write a transaction monitoring query that shows all active 
transactions in the database, including their status, start time, 
and session information. 
*/
-- i Can't Solve This 
