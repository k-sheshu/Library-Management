# Library Management System SQL Analysis

This project focuses on creating a relational database for a library management system and analyzing its data using SQL queries. The primary goal is to build a database with properly defined relationships and constraints and to derive meaningful insights by running complex queries on the dataset.

## Project Workflow

### 1. **Database Schema and Table Creation**
- **Objective**: Design and implement the database structure based on the given schema diagram.
- **Process**:
  - Created the following tables: `Books`, `LibraryBranches`, `Borrowers`, `Loans`, and other necessary tables as per the schema.
  - Defined relationships between tables using **foreign keys**.
  - Constraints:
    - **Primary Keys**: Each table's primary key was defined with the `AUTO_INCREMENT` constraint to ensure unique identification.
    - **Foreign Keys**: Established relationships using foreign keys with `ON DELETE CASCADE` and `ON UPDATE CASCADE` to maintain referential integrity.
    - Ensured proper normalization to avoid data redundancy and maintain efficiency.
- **Tools**:
  - MySQL for database creation and management.

### 2. **SQL Queries for Analysis**
After creating the database, the following queries were executed to analyze the data:

#### Query 1: 
**How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?**  
- Used `JOIN` clauses and `WHERE` conditions to filter data based on book title and branch name.

#### Query 2: 
**How many copies of the book titled "The Lost Tribe" are owned by each library branch?**  
- Applied `GROUP BY` on branch names to calculate the total count of copies for the specified book.

#### Query 3: 
**Retrieve the names of all borrowers who do not have any books checked out.**  
- Used a `LEFT JOIN` to find borrowers with no matching records in the loans table and filtered results using `IS NULL`.

#### Query 4: 
**For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address.**  
- Utilized multiple `JOIN` operations across `Books`, `Loans`, `Borrowers`, and `LibraryBranches` tables with precise filtering on branch name and due date.

#### Query 5: 
**For each library branch, retrieve the branch name and the total number of books loaned out from that branch.**  
- Combined `GROUP BY` with aggregation functions like `COUNT()`.

#### Query 6: 
**Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.**  
- Used a `HAVING` clause after grouping data by borrower names and addresses.

#### Query 7: 
**For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".**  
- Combined `JOIN`, filtering on author name, and branch name to extract relevant data.

### 3. **Insights and Findings**
- Identified branch-wise inventory and borrowing trends.
- Determined borrower behavior, such as borrowers with no active loans or those who borrow frequently.
- Analyzed book distribution and availability across branches for specific authors or titles.

### 4. **Challenges**
- Designing the schema to ensure consistency and efficiency.
- Writing optimized queries to handle large datasets.
- Maintaining database integrity with appropriate constraints.

## Technologies Used
- **Database**: MySQL
- **Key Concepts**:
  - Relational Database Design
  - Primary Keys and Foreign Keys
  - Cascade Constraints
  - Joins and Subqueries
  - Aggregate Functions (`COUNT`, `SUM`, `GROUP BY`, `HAVING`)

## Conclusion
This project showcases the practical implementation of database design and SQL analysis. It highlights how relational databases can be leveraged to store, manage, and derive actionable insights from structured data.
