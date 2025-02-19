create database OnlineBookstore;


-- Create tables 
drop table if exists Books;

CREATE TABLE Books(
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10,2),
	Stock INT
);

drop table if exists Customers;
CREATE TABLE Customers(
	Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)	
);

drop table if exists Orders;
CREATE TABLE Orders(
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);




select* from Books;
select* from Customers;
select * from Orders;



-- Import Data into Books Table
COPY Books (book_ID, title, author, genre, published_year, price, stock)
FROM 'C:\Program Files\PostgreSQL\17\data\Books.csv'
CSV HEADER;

select * from Books;

-- Import Data into Customers Table

copy Customers
FROM 'C:\Program Files\PostgreSQL\17\data\Customers.csv'
delimiter ','
CSV HEADER;

select* from Customers;

-- Import Data into Orders Table

COPY Orders (order_id, customer_id, book_id, order_date, quantity, total_amount)
FROM 'C:\Program Files\PostgreSQL\17\data\Orders.csv'
CSV HEADER;

select * from Orders;





-- 1) Retrieve all books in the "Fiction" genre

select * from books
where genre = 'Fiction';


-- 2) Find books published after the year 1950

select * from books
where published_year >= 1950;


-- 3) List all customers from the Canada

select * from Customers
where country = 'Canada';



-- 4) Show orders placed in November 2023

select * from Orders
where order_date between '2023-11-01' and '2023-11-30';



-- 5) Retrieve the total stock of books available

select sum(stock) as Total_stock
from books;


-- 6) Find the details of the most expensive book

select * from books order by price desc
limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book

select *from Orders
where quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20

select * from Orders
where total_amount >20;


-- 9) List all genres available in the Books table

Select distinct genre 
from Books;


-- 10) Find the book with the lowest stock

select * from books 
order by stock asc
limit 1;


-- 11) Calculate the total revenue generated from all orders

select sum(total_amount) as Total_Revenue
from orders;







-- 1) Retrieve the total number of books sold for each genre

select b.genre, sum(o.quantity) as Books_Sold
from Orders o
JOIN Books b 
On o.book_id = b.book_id
group by b.genre;


-- 2)  Find the average price of books in the "Fantasy" genre

select * from Books;

select avg(price) as Average_Price
from Books
where genre = 'Fantasy';


-- 3) List customers who have placed at least 2 orders

select customer_id, count(order_id) as order_count
from Orders
group by customer_id
having count(order_id) >=2;

-- joins 
select o.customer_id, c.name, count(o.order_id) as order_count
from Orders o
join customers c on o.customer_id = c.customer_id
group by o.customer_id, c.name
having count(order_id) >=2;


-- 4) Find the most frequently ordered book

select book_id, count(order_id) as Order_count
from orders
group by book_id
order by Order_count desc
limit 5;

-- joins for retrieve book name 
select o.book_id, b.title, count(o.order_id) as Order_count
from orders o
join Books b on b.book_id = o.book_id
group by o.book_id, b.title
order by Order_count desc
limit 5;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre

select * from books 
where genre = 'Fantasy'
order by price desc
limit 3;


-- 6) Retrieve the total quantity of books sold by each author


select distinct author from Books; -- Check All Author

select b.author, sum(o.quantity) as total_books_sold
from Orders o
join Books b on o.book_id = b.book_id
group by b.author;



-- 7) List the cities where customers who spent over $30 are located

select distinct c.city, total_amount
from orders o
join customers c on o.customer_id = c.customer_id
where o.total_amount > 30;

-- 8) Find the customer who spent the most on orders

select c.customer_id, c.name,  sum(o.total_amount) as total_spent
from orders o
join customers c on o.customer_id = c.customer_id
group by c.customer_id, c.name
order by total_spent Desc
limit 1;


-- 9) Calculate the stock remaining after fulfilling all orders

select b.book_id, b.title, b.stock, coalesce(sum(o.quantity),0) as oreder_quantity,
	b.stock - coalesce(sum(o.quantity),0) as Remaining_quantity
from Books b
left join orders o on b.book_id = o.book_id
group by b.book_id order by b.book_id;
