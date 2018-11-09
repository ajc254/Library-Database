/* 
RDBMS used: MySQL
*/

USE libraries;

-- Query A
SELECT
    sum(noOfCopies) AS `Total Number Of Copies`, 
    LB.name AS `Branch Name`
    
	FROM
		BookInventory AS BI
	JOIN LibraryBranch AS LB ON
		BI.branchID = LB.ID
	JOIN Book ON
		BI.ISBN = book.ISBN
	JOIN Contributors AS CT ON
		book.ISBN = CT.ISBN 
	JOIN Author AS AU ON
		CT.authorID = AU.authorID

WHERE
	AU.authorName = 'George Orwell'
    
GROUP BY 
	LB.name;


-- Query B
-- Subtract total number of copies from number of active loans.
SELECT BI.noOfCopies - (
    SELECT
        IF(
            loan.dateOut IS NULL,
            0,
            COUNT(loan.dateOut)
        ) 
        AS `Number of Active Loans`

		FROM
			BookInventory AS BI

		JOIN Book 
			ON book.ISBN = BI.ISBN

		JOIN LibraryBranch AS LB
			ON BI.branchID = LB.ID

		-- Left join needed here as a Book may have not been loaned out yet.
		LEFT JOIN Loan
			ON Book.ISBN = loan.ISBN AND 
			LB.ID = loan.branchID
            
		WHERE
			Loan.dateIn IS NULL AND 
			Book.title = 'The Lost Tribe' AND 
			LB.name = 'St Thomas')
			
		AS `Number of Available Copies`
    

	FROM BookInventory AS BI

	JOIN LibraryBranch AS LB ON
		BI.branchID = LB.ID
		
	JOIN Book ON 
		Book.ISBN = BI.ISBN   
        
	WHERE
		book.title = 'The Lost Tribe' AND 
		LB.name = 'St Thomas';

-- Query C
SELECT fName AS `First Name`, lName AS `Last Name` 
	FROM 
		Borrower as BRW
	WHERE 
		BRW.ID NOT IN (SELECT DISTINCT BRW.ID	-- Distinct avoids duplicates.
							FROM 
								borrower as BRW
							JOIN Loan ON
								BRW.ID = Loan.borrowerID
                                
							WHERE
							  Loan.dateOut > '2017-01-01');

-- Query D
SELECT BK.title AS `Book Title`, BRW.fName AS `First Name`, BRW.lName AS `Last Name`, BRW.email AS `Email`
	FROM Loan as LN

	JOIN LibraryBranch AS LB ON	
		LN.branchID = LB.ID
	JOIN Book AS BK ON
		LN.ISBN = BK.ISBN
	JOIN Borrower AS BRW ON
		LN.borrowerID = BRW.ID

	WHERE 
		LB.name = 'St Thomas'  AND
		LN.dateDue = CURRENT_DATE;
    
-- Query E PART 1
SELECT BK.title AS `Book Title`, LN.dateOut AS `Date Out`, LN.dateDue AS `Date Due`, BRW.email AS `Email`
	FROM Loan AS LN

	JOIN Book AS BK ON
		LN.ISBN = BK.ISBN
	JOIN Borrower AS BRW ON
		LN.borrowerID = BRW.ID

	WHERE 
		BRW.fName = 'Ian' AND
		BRW.lName = 'Cooper' AND
		LN.dateIn IS NULL AND 		-- Not returned yet.
		LN.dateDue < CURRENT_DATE;  -- Past due date.

-- Query E PART 2
-- IFNULL deals with Borrowers who have not made a loan yet, selects 0 instead.
SELECT IFNULL(SUM( 
              DATEDIFF(
				IF(LN.dateIn IS NULL, 
				   CURRENT_DATE, 
				   LN.dateIn), 
				LN.dateDue)*0.25), 0) 
	   as `Total Outstanding Fine (£)`
       
	FROM 
		Loan as LN

	JOIN Book AS BK ON
		LN.ISBN = BK.ISBN
	JOIN Borrower AS BRW ON
		LN.borrowerID = BRW.ID
        
	WHERE 
		BRW.fName = 'Ian' AND
		BRW.lName = 'Cooper' AND
		LN.dateFinePaid IS NULL AND		-- Fine not paid yet.
		( LN.dateIn IS NULL OR LN.dateIn > LN.dateDue ) AND 
		LN.dateDue < CURRENT_DATE;
        
    
