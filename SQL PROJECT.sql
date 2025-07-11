-- Create Database
CREATE DATABASE Online_Bookstore;

-- Switch to the database
\c Online_Bookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books (book_id, title, author, genre, published_year, price,stock)
FROM 'D:\SQL PRACTICE\Books.csv'
DELIMITER','
CSV HEADER;

-- Import Data into Customers Table
COPY Customers (customer_id, name, email, phone, city, country)
FROM 'D:\SQL PRACTICE\Customers.csv'
CSV HEADER;

-- Import Data into Orders Table
COPY Orders (order_id, customer_id, book_id, order_date, quantity, total_amount)
FROM 'D:\SQL PRACTICE\Orders.csv'
CSV HEADER;

-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books
WHERE genre='Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM Books
WHERE published_year>1950;

-- 3) List all customers from the Canada:
SELECT * FROM Customers
WHERE country='Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT SUM(stock) AS total_stock
FROM Books;

-- 6) Find the details of the most expensive book:
SELECT * FROM Books ORDER BY price DESC LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders
WHERE quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders
WHERE total_amount>20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre FROM Books;

-- 10) Find the book with the lowest stock:
SELECT * FROM Books ORDER BY stock LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) AS Revenue 
FROM Orders;

-- 12) Retrieve the total number of books sold for each genre:
SELECT b.Genre, SUM(o.Quantity) AS Total_Books_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.Genre;


-- 13) Find the average price of books in the "Fantasy" genre:
SELECT AVG(price) AS Average_price
FROM Books
WHERE genre= 'Fantasy';

-- 14) List customers who have placed at least 2 orders:

SELECT customer_id, COUNT(order_id) AS ORDER_COUNT
FROM orders
Group by customer_id
HAVING COUNT(order_id)>=2;

		or


SELECT o.customer_id, c.name, COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
Group by o.customer_id, c.name
HAVING COUNT(order_id)>=2;	


-- 15) Find the most frequently ordered book:
SELECT o.book_id, b.title, COUNT(o.Order_id) AS Order_count
FROM Orders o
JOIN Books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY Order_count LIMIT 1;

-- 16) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM Books
WHERE genre ='Fantasy'
ORDER BY price DESC LIMIT 3;

-- 17) Retrieve the total quantity of books sold by each author:
SELECT b.author, SUM(o.quantity) AS Total_books_sold
FROM orders o
JOIN Books b ON o.book_id=b.book_id
GROUP BY b.author;

-- 18) List the cities where customers who spent over $30 are located:
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE total_amount>30;


-- 19) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent DESC;

--20) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;