-- Create Database
CREATE DATABASE Online_Bookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
		Book_ID SERIAL PRIMARY KEY,
		Title VARCHAR(100),
		Author VARCHAR(100),
		Genre VARCHAR(50),
		Published_Year INT,
		Price NUMERIC(10,2),
		Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
		Customer_ID SERIAL PRIMARY KEY,
		Name VARCHAR(100),
		Email VARCHAR(100),
		Phone VARCHAR(15),
		City VARCHAR(50),
		Country VARCHAR(150)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
		Order_ID SERIAL PRIMARY KEY,
		Customer_ID INT REFERENCES Customers(Customer_ID),
		Book_ID INT REFERENCES Books(Book_ID),
		Order_Date DATE,
		Quantity INT,
		Total_Amount NUMERIC(10,2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Inport data into Books table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM '‪D:\\sql end to end work\\Books.csv'
DELIMITER ','
CSV HEADER;

-- Import data into Customers table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM '‪D:\\sql end to end work\\Customers.csv'
DELIMITER ','
CSV HEADER;

-- Import data into Orders table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'D:\\sql end to end work\\Orders.csv'
DELIMITER ','
CSV HEADER;

-- 1. Retrieve all books of the "Fiction" genre:
SELECT * FROM Books 
WHERE Genre = 'Fiction';

-- 2. Find books published after the year 1950:
SELECT * FROM Books
WHERE Published_year > 1950;

-- 3. List all the customers from the canada:
SELECT * FROM Customers
WHERE Country = 'Canada';

-- 4. Show orders placed in November 2023:
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5. Retrieve the total stock of books available:
SELECT SUM(Stock) AS Total_stock
FROM Books;

-- 6. Find the details of the most expensive books:
SELECT * FROM Books ORDER BY Price DESC LIMIT 1;

-- 7. Show all customer who ordered more than 1 quantity of a book:
SELECT * FROM Orders 
WHERE Quantity > 1;

-- 8. Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders
WHERE total_amount > 20;

-- 9. List all genre available in the books table:
SELECT DISTINCT Genre FROM Books;

-- 10. Find the books with the lowest stock:
SELECT * FROM Books
ORDER BY stock ASC LIMIT 1;

-- 11. Calculate the total revenue generated from all orders:
SELECT SUM(Total_amount) AS Total_revenue
FROM Orders;

-- 12. Retrieve the total number of books sold for each genre:
SELECT b.Genre, SUM(o.Quantity) AS  Total_books_sold 
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.genre;

-- 13. Find the average price of books in the "Fantacy" genre:
SELECT AVG(Price) AS Average_price
FROM Books
WHERE Genre = 'Fantacy';

-- 14. List customer who have placed at least 2 orders:
SELECT o.Customer_ID, c.Name, COUNT(o.order_ID) AS order_count
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_ID, c.Name
HAVING COUNT(order_ID) >=2;

-- 15. Find the most frequently ordered book:
SELECT o.Book_ID, title, COUNT(o.Order_id) AS Order_count
FROM orders o
JOIN Books b ON o.book_ID = b.book_ID
GROUP BY o.book_id, b.title
ORDER BY order_count DESC limit 1;

-- 16. Show the top 3 most expensive books of 'Fantasy' genre:
SELECT * FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC LIMIT 3;

-- 17. Retrieve the total quantity of books sold by each author:
SELECT b.author, SUM(o.quantity) AS Total_books_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.author;

-- 18. List the cities where customers who spent over $30 are located :
SELECT DISTINCT c.city, o.total_amount 
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.total_amount > 30;

-- 19. Find the customer who spent the most on the orders:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC LIMIT 1;

-- 20. calculate the stock remaning after fullfiling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS order_quantity, 
       b.stock - COALESCE(SUM(o.quantity),0) AS Remaning_quantity
FROM books b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id
ORDER BY b.book_id ASC;











