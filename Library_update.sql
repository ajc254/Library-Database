/* 
RDBMS used: MySQL
*/

USE Libraries;

-- Update A
UPDATE Loan SET Loan.dateIn = CURRENT_DATE
	WHERE 
		Loan.borrowerID = (SELECT ID 
								FROM
									borrower as BRW
								WHERE 
									BRW.fName = 'Ian' AND
									BRW.lName = 'Cooper')
		AND
		loan.ISBN = (SELECT ISBN 
						FROM 
							book as BK
						WHERE
							BK.title = 'Pride and Prejudice') 
		AND
		loan.dateIn IS NULL
				 
	ORDER BY loan.dateOut	-- Return the oldest loan of a certain copy.
	LIMIT 1;	-- Only return 1 of the copies loaned.
  

-- Update B
INSERT INTO loan( branchID, borrowerID, ISBN, dateOut, dateDue )
	SELECT LB.ID, BRW.ID, BK.ISBN, NOW(), DATE_ADD(CURRENT_DATE, INTERVAL 15 DAY)
		FROM
			borrower AS BRW 
		JOIN book AS BK
		JOIN librarybranch LB
		
		WHERE 
			BRW.fName = 'Ian' AND
			BRW.lName = 'Cooper' AND
			LB.name = 'St Thomas' AND
			BK.title = 'Animal Farm';
            

-- Update C
INSERT INTO book 
	VALUES( '8493027581235',
			'Insertion Book', 
			'Demonstration', 
			'Sparks Publishing');
    
INSERT INTO bookinventory( ISBN, branchID, noOfCopies )
	SELECT '8493027581235', LB.ID, 1
		FROM
			librarybranch AS LB
		
		WHERE 
			LB.name = 'St Thomas' OR LB.name = 'Streatham';
            
           
-- Update D
UPDATE bookinventory AS BI 
SET BI.noOfCopies = BI.noOfCopies - 1

	WHERE 
		BI.ISBN = (SELECT book.ISBN from book 
						WHERE
							book.title = 'The Lost Tribe')
		AND
		BI.branchID = (SELECT LB.ID from librarybranch AS LB 
							WHERE
								LB.name = 'St Thomas');
 

-- Update E
UPDATE loan AS LN 
SET
	dateFinePaid = CURRENT_DATE
WHERE
	LN.borrowerID = (SELECT BRW.ID FROM borrower AS BRW
						WHERE
							BRW.fName = 'Ian' AND
							BRW.lName = 'Cooper')
	AND
	LN.dateFinePaid IS NULL 
    AND
	( LN.dateIn IS NULL OR LN.dateIn > LN.dateDue ) 
    AND 
	LN.dateDue < CURRENT_DATE;	-- Ensure don't mark fine paid on books not due yet.