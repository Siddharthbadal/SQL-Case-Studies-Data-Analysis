-- Create Walmart Database
CREATE DATABASE IF NOT EXISTS walmart;

-- Create Sales Table
CREATE TABLE IF NOT EXISTS sales(
	invoiceid VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customertype VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    productline VARCHAR(100) NOT NULL,
    unitprice DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    grossmargin FLOAT(11,9),
    grossincome DECIMAL(12, 4),
    rating FLOAT(2, 1)
);