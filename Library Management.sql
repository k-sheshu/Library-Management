CREATE DATABASE library; 
USE library; 

CREATE TABLE tbl_book_authors
( 
   book_authors_BookID INT NOT NULL,
   book_authors_AuthorName VARCHAR(100) NOT NULL,
   book_authors_AuthorID INT AUTO_INCREMENT PRIMARY KEY,
   FOREIGN KEY(book_authors_BookID) REFERENCES tbl_book(book_BookID) 
   ON DELETE CASCADE 
   ON UPDATE CASCADE
); 

CREATE TABLE tbl_publisher 
( 
   publisher_PublisherName VARCHAR(100) PRIMARY KEY, 
   publisher_PublisherAddress VARCHAR(255) NOT NULL, 
   publisher_PublisherPhone VARCHAR(20)
); 

CREATE TABLE tbl_book 
( 
   book_BookID INT AUTO_INCREMENT PRIMARY KEY, 
   book_Title VARCHAR(255) NOT NULL, 
   book_PublisherName VARCHAR(100) NOT NULL, 
   FOREIGN KEY(book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName)
   ON DELETE CASCADE 
   ON UPDATE CASCADE
); 

CREATE TABLE tbl_library_branch 
( 
   library_branch_BranchID INT AUTO_INCREMENT PRIMARY KEY, 
   library_branch_BranchName VARCHAR(100) NOT NULL, 
   library_branch_BranchAddress VARCHAR(255) NOT NULL 
); 

CREATE TABLE tbl_book_copies 
( 
   book_copies_BookID INT NOT NULL, 
   book_copies_BranchID INT NOT NULL, 
   book_copies_No_Of_Copies INT NOT NULL, 
   book_copies_CopiesID INT AUTO_INCREMENT PRIMARY KEY, 
   FOREIGN KEY(book_copies_BookID) REFERENCES tbl_book(book_BookID) 
   ON DELETE CASCADE 
   ON UPDATE CASCADE, 
   FOREIGN KEY(book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID) 
   ON DELETE CASCADE
   ON UPDATE CASCADE
); 

CREATE TABLE tbl_borrower
( 
   borrower_CardNo INT AUTO_INCREMENT PRIMARY KEY, 
   borrower_BorrowerName VARCHAR(100) NOT NULL, 
   borrower_BorrowerAddress VARCHAR(255) NOT NULL, 
   borrower_BorrowerPhone VARCHAR(15) NOT NULL
); 

CREATE TABLE tbl_book_loans 
( 
   book_loans_BookID INT NOT NULL, 
   book_loans_BranchID INT NOT NULL, 
   book_loans_CardNo INT NOT NULL, 
   book_loans_DateOut Date, 
   book_loans_DueDate Date, 
   book_loans_LoansID INT AUTO_INCREMENT PRIMARY KEY, 
   FOREIGN KEY(book_loans_BookID) REFERENCES tbl_book(book_BookID) 
    ON DELETE CASCADE
    ON UPDATE CASCADE, 
   FOREIGN KEY(book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID)
    ON DELETE CASCADE
    ON UPDATE CASCADE, 
   FOREIGN KEY(book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo)
    ON DELETE CASCADE
    ON UPDATE CASCADE 
); 

SELECT * FROM tbl_book_authors; 
SELECT * FROM tbl_publisher; 
SELECT * FROM tbl_book; 
SELECT * FROM tbl_library_branch; 
SELECT * FROM tbl_book_copies; 
SELECT * FROM tbl_borrower; 
SELECT * FROM tbl_book_loans; 

# 01. How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
SELECT bc.book_copies_No_Of_Copies AS total_copies
FROM tbl_book_copies bc
JOIN tbl_book b
   ON bc.book_copies_BookID = b.book_BookID 
JOIN tbl_library_branch lb 
   ON bc.book_copies_BranchID = lb.library_branch_BranchID 
WHERE 
    b.book_Title = "The Lost Tribe" AND 
    lb.library_branch_BranchName = "Sharpstown"; 


# 02. How many copies of the book titled "The Lost Tribe" are owned by each library branch?
SELECT 
	 library_branch_BranchName AS BranchName,
     SUM(bc.book_copies_No_Of_Copies) AS TotalCopies
FROM tbl_book_copies bc 
JOIN tbl_book b
   ON bc.book_copies_BookID = b.book_BookID
JOIN tbl_library_branch lb 
   ON bc.book_copies_BranchID = lb.library_branch_BranchID 
WHERE 
    b.book_Title = "The Lost Tribe" 
GROUP BY 
    lb.library_branch_BranchName; 
    
# 03. Retrieve the names of all borrowers who do not have any books checked out.
SELECT 
     b.borrower_CardNo AS CardNo,
     b.borrower_BorrowerName AS BorrowerName
FROM tbl_borrower b
LEFT JOIN tbl_book_loans bl 
    ON b.borrower_CardNo = bl.book_loans_CardNo 
WHERE 
    bl.book_loans_CardNo IS NULL; 
    
/* 04. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, 
retrieve the book title, the borrower's name, and the borrower's address. */ 
SELECT 
	b.book_Title AS BookTitle,
    br.borrower_BorrowerName AS BorrowerName, 
    br.borrower_BorrowerAddress AS BorrowerAddress
FROM tbl_book_loans bl 
INNER JOIN tbl_book b 
    ON bl.book_loans_BookID = b.book_BookID 
INNER JOIN tbl_borrower br
    ON bl.book_loans_CardNo = br.borrower_CardNo 
INNER JOIN tbl_library_branch lb
    ON bl.book_loans_BranchID = lb.library_branch_BranchID 
WHERE 
    lb.library_branch_BranchName = "Sharpstown" AND 
    bl.book_loans_DueDate = "2018-02-03"; 

# 05. For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
SELECT 
     lb.library_branch_BranchName AS BranchName, 
     COUNT(bl.book_loans_LoansID) AS TotalBooksLoaned
FROM tbl_library_branch lb 
LEFT JOIN tbl_book_loans bl 
    ON lb.library_branch_BranchID = bl.book_loans_BranchID 
GROUP BY 
    lb.library_branch_BranchName; 
    
# 06. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
SELECT 
     b.borrower_BorrowerName AS BorrowerName, 
     b.borrower_BorrowerAddress AS BorrowerAddress, 
     COUNT(bl.book_loans_BookID) AS BooksCheckedOut
FROM tbl_borrower b 
JOIN tbl_book_loans bl 
    ON b.borrower_CardNo = bl.book_loans_CardNo 
GROUP BY 
     b.borrower_CardNo, 
     b.borrower_BorrowerName, 
     b.borrower_BorrowerAddress 
HAVING 
     COUNT(bl.book_loans_BookID) > 5; 
     
# 07. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
SELECT 
     b.book_Title AS BookTitle, 
     bc.book_copies_No_Of_Copies AS NumberOfCopies
FROM tbl_book_authors ba 
INNER JOIN tbl_book b
    ON ba.book_authors_BookID = b.book_BookID
INNER JOIN tbl_book_copies bc 
    ON b.book_BookID = bc.book_copies_BookID 
INNER JOIN tbl_library_branch lb 
    ON bc.book_copies_BranchID = lb.library_branch_BranchID 
WHERE 
    ba.book_authors_AuthorName = "Stephen King" AND 
    lb.library_branch_BranchName = "Central"; 
    