-- Drop tables if they exist
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Members;

-- Create Members table
CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    JoinDate DATE
);

-- Create Books table
CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(255),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    TotalCopies INT
);

-- Create Transactions table
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    MemberID INT,
    BookID INT,
    IssueDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Insert sample data into Members
INSERT INTO Members VALUES
(1, 'Alice Johnson', 'alice@email.com', '2023-01-10'),
(2, 'Bob Smith', 'bob@email.com', '2023-02-15'),
(3, 'Charlie Lee', 'charlie@email.com', '2023-03-20');

-- Insert sample data into Books
INSERT INTO Books VALUES
(101, 'Clean Code', 'Robert C. Martin', 'Programming', 5),
(102, 'The Pragmatic Programmer', 'Andrew Hunt', 'Programming', 3),
(103, '1984', 'George Orwell', 'Dystopian', 4),
(104, 'Harry Potter', 'J.K. Rowling', 'Fantasy', 2);

-- Insert sample data into Transactions
INSERT INTO Transactions VALUES
(1, 1, 101, '2024-01-15', NULL),
(2, 2, 102, '2024-01-20', '2024-02-01'),
(3, 1, 104, '2024-01-25', NULL),
(4, 3, 103, '2024-02-01', '2024-02-20');

-- Query 1: List all books currently issued
SELECT B.Title, M.Name, T.IssueDate
FROM Transactions T
JOIN Books B ON T.BookID = B.BookID
JOIN Members M ON T.MemberID = M.MemberID
WHERE T.ReturnDate IS NULL;

-- Query 2: Count of books issued by each member
SELECT M.Name, COUNT(*) AS BooksIssued
FROM Transactions T
JOIN Members M ON T.MemberID = M.MemberID
WHERE T.ReturnDate IS NULL
GROUP BY M.Name;

-- Query 3: Most issued books (all-time)
SELECT B.Title, COUNT(*) AS TimesIssued
FROM Transactions T
JOIN Books B ON T.BookID = B.BookID
GROUP BY B.Title
ORDER BY TimesIssued DESC;

-- Query 4: Books that were returned
SELECT B.Title, M.Name, T.IssueDate, T.ReturnDate
FROM Transactions T
JOIN Books B ON T.BookID = B.BookID
JOIN Members M ON T.MemberID = M.MemberID
WHERE T.ReturnDate IS NOT NULL;

-- Query 5: Total books available (not currently issued)
SELECT Title, TotalCopies -
    (SELECT COUNT(*) FROM Transactions T WHERE T.BookID = B.BookID AND T.ReturnDate IS NULL)
    AS AvailableCopies
FROM Books B;
