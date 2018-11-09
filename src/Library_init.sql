/* 
RDBMS used: MySQL
*/


DROP DATABASE IF EXISTS Libraries;
CREATE DATABASE Libraries;
USE Libraries;

CREATE TABLE Author (
  `authorID` int NOT NULL AUTO_INCREMENT,
  `authorName` varchar(255) NOT NULL,
  `dateOfBirth` date NOT NULL,
  PRIMARY KEY (`authorID`) 
) ENGINE=InnoDB;
  
  
CREATE TABLE Publisher (
  `name` varchar(255) NOT NULL,
  `phoneNo` varchar(15) NOT NULL,
  `address` text NOT NULL,
  PRIMARY KEY (`name`) 
) ENGINE=InnoDB;
  
  
CREATE TABLE LibraryBranch (
  `ID` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `address` text NOT NULL,
  PRIMARY KEY (`ID`) 
) ENGINE=InnoDB;
  
  
CREATE TABLE Borrower (
  `ID` int NOT NULL AUTO_INCREMENT,
  `creditCardNo` varchar(19) NOT NULL,
  `fName` varchar(255) NOT NULL,
  `lName` varchar(255) NOT NULL,
  `phoneNo` varchar(15) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`),
  CONSTRAINT uq_Borrower UNIQUE(fName, lName)
) ENGINE=InnoDB;


CREATE TABLE Book (
  `ISBN` varchar(13) NOT NULL,
  `title` varchar(255) NOT NULL,
  `Category` varchar(30) NOT NULL,
  `publisherName` varchar(255) NOT NULL,
  PRIMARY KEY (`ISBN`),
  FOREIGN KEY (`publisherName`) REFERENCES Publisher (`name`)
) ENGINE=InnoDB;
  
 
CREATE TABLE Bookinventory (
  `ISBN` varchar(13) NOT NULL,
  `branchID` int NOT NULL,
  `noOfCopies` int NOT NULL,
  PRIMARY KEY (`ISBN`,`branchID`),
  FOREIGN KEY (`branchID`) REFERENCES LibraryBranch (`ID`),
  FOREIGN KEY (`ISBN`) REFERENCES Book (`ISBN`)
) ENGINE=InnoDB;

              
CREATE TABLE Contributors (
  `ISBN` varchar(13) NOT NULL,
  `authorID` int NOT NULL,
  PRIMARY KEY (`ISBN`,`authorID`),
  FOREIGN KEY (`ISBN`) REFERENCES Book (`ISBN`),
  FOREIGN KEY (`authorID`) REFERENCES Author (`authorID`)
) ENGINE=InnoDB;


CREATE TABLE Loan (
  `branchID` int NOT NULL,
  `borrowerID` int NOT NULL,
  `ISBN` varchar(13) NOT NULL,
  `dateOut` datetime NOT NULL,
  `dateDue` date NOT NULL,
  `dateIn` date DEFAULT NULL,
  `dateFinePaid` date DEFAULT NULL,
  PRIMARY KEY (`branchID`,`borrowerID`,`ISBN`,`dateOut`),
  FOREIGN KEY (`borrowerID`) REFERENCES Borrower (`ID`),
  FOREIGN KEY (`ISBN`) REFERENCES Book (`ISBN`),
  FOREIGN KEY (`branchID`) REFERENCES LibraryBranch (`ID`)
) ENGINE=InnoDB;

-- NULL entries represent use of AUTO INCREMENT throughout INSERT statements.
INSERT INTO Author (`authorID`, `authorName`, `dateOfBirth`) VALUES
(NULL, 'George Orwell', '1968-09-14'),
(NULL, 'Jonathon Gordan', '1978-03-14'),
(NULL, 'J.K Rowling', '1988-07-10');

INSERT INTO Publisher (`name`, `phoneNo`, `address`) VALUES
('Bloomsberg Publishing', '01452895835', '34 High Road'),
('Sparks Publishing', '01682947523', '45 Swallow Road');

INSERT INTO LibraryBranch (`ID`, `name`, `address`) VALUES
(NULL, 'St Thomas', '17 Thomas Road \r\nExeter'),
(NULL, 'Streatham', 'Streatham Road \r\nExeter');

INSERT INTO Borrower (`ID`, `creditCardNo`, `fName`, `lName`, `phoneNo`, `email`) VALUES
(NULL, '4494029375869432', 'John', 'Cooper', '01849375693', 'JC43@gmail.com'),
(NULL, '4484920394859403', 'Sarah', 'Hoopern', '01483950692', 'SH65@hotmail.com'),
(NULL, '4439274857489302', 'Alex', 'Martin', '01489156325', 'aMartin17@gmail.com'),
(NULL, '4495713905746231', 'Sally', 'Piper', '07984392058', 'sPiper@hotmail.com'),
(NULL, '4483759017485723', 'Ian', 'Cooper', '01452739407', 'ICooper43@gmail.com'),
(NULL, '4845960184395862', 'Jordan', 'Smith', '07985504971', 'JSmith@hotmail.co.uk');

INSERT INTO Book (`ISBN`, `title`, `Category`, `publisherName`) VALUES
('0174852957321', 'Harry Potter and The Philosopher Stone', 'Fantasy', 'Bloomsberg Publishing'),
('7482947504824', 'SQL Guide For Dummies', 'Education', 'Sparks Publishing'),
('7483928465742', 'Pride and Prejudice', 'Adventure', 'Bloomsberg Publishing'),
('2930493492934', 'Star Wars', 'Fantasy', 'Sparks Publishing'),
('9365749206743', 'The Lost Tribe', 'Adventure', 'Bloomsberg Publishing'),
('5849303948543', 'Animal Farm', 'Novel', 'Sparks Publishing');

INSERT INTO BookInventory (`ISBN`, `branchID`, `noOfCopies`) VALUES
('0174852957321', 1, 2),
('0174852957321', 2, 5),
('7482947504824', 1, 3),
('7482947504824', 2, 6),
('7483928465742', 2, 3),
('2930493492934', 1, 1),
('2930493492934', 2, 1),
('9365749206743', 1, 2),
('9365749206743', 2, 4),
('5849303948543', 1, 5),
('5849303948543', 2, 3);


INSERT INTO Contributors (`ISBN`, `authorID`) VALUES
('0174852957321', 2),
('7482947504824', 1),
('7483928465742', 1),
('7483928465742', 2),
('7483928465742', 3),
('2930493492934', 2),
('2930493492934', 3),
('9365749206743', 1),
('5849303948543', 3);


INSERT INTO Loan (`branchID`, `borrowerID`, `ISBN`, `dateOut`, `dateDue`, `dateIn`, `dateFinePaid`) VALUES
(2, 6, '0174852957321', '2016-12-03 09:30:00', '2016-12-18', '2016-12-18', DEFAULT),
(1, 1, '7482947504824', '2017-11-01 06:12:16', '2017-11-16', '2017-11-14', DEFAULT),
(2, 2, '9365749206743', '2017-11-02 06:30:00', '2017-11-17', '2017-11-19', '2017-11-19'),
(1, 5, '7483928465742', '2017-11-02 08:30:35', '2017-11-17', DEFAULT, DEFAULT),
(2, 5, '7483928465742', '2017-11-02 13:54:21', '2017-11-17', DEFAULT, DEFAULT),
(1, 1, '0174852957321', '2017-11-02 07:30:00', '2017-11-17', '2017-11-17', DEFAULT),
(2, 3, '0174852957321', '2017-11-03 08:40:00', '2017-11-18', '2017-11-14', DEFAULT),
(1, 4, '0174852957321', '2017-11-04 09:30:00', '2017-11-19', '2017-11-21', '2017-11-21'),
(2, 5, '0174852957321', '2017-11-05 10:30:46', '2017-11-20', '2017-11-20', DEFAULT),
(1, 3, '7482947504824', '2017-11-05 11:50:45', '2017-11-20', '2017-11-23', DEFAULT),
(1, 2, '7483928465742', '2017-11-06 13:03:00', '2017-11-21', DEFAULT, DEFAULT),
(2, 4, '7483928465742', '2017-11-06 14:40:00', '2017-11-21', '2017-11-22', DEFAULT),
(2, 5, '0174852957321', '2017-11-07 15:30:00', '2017-11-22', DEFAULT, DEFAULT),
(1, 2, '0174852957321', '2017-11-08 16:20:00', '2017-11-23', DEFAULT, DEFAULT),
(2, 4, '0174852957321', '2017-11-09 07:40:00', '2017-11-24', DEFAULT, DEFAULT),
(1, 3, '0174852957321', '2017-11-10 08:20:00', '2017-11-25', DEFAULT, DEFAULT),
(2, 2, '7482947504824', '2016-04-11 06:23:00', '2017-11-26', DEFAULT, DEFAULT),
(1, 1, '0174852957321', '2017-11-11 07:40:00', '2017-11-26', DEFAULT, DEFAULT),
(1, 4, '0174852957321', '2017-11-12 11:50:00', '2017-11-27', DEFAULT, DEFAULT),
(1, 1, '7483928465742', '2017-11-13 14:50:00', '2017-11-28', DEFAULT, DEFAULT),
(2, 3, '7483928465742', '2017-11-14 08:50:13', '2017-11-29', DEFAULT, DEFAULT),
(2, 4, '7483928465742', '2017-11-15 07:30:00', '2017-11-30', DEFAULT, DEFAULT),
(2, 5, '9365749206743', '2017-11-16 07:30:15', '2017-12-01', DEFAULT, DEFAULT);
