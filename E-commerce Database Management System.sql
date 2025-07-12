-- Create Database
CREATE DATABASE Onlinestore;


USE Onlinestore;
GO
-- Create Tables
CREATE TABLE Customers (
    customer_id CHAR(36) PRIMARY KEY, -- Unique identifier for each customer
    email VARCHAR(100) UNIQUE NOT NULL, -- Customer email must be unique
    first_name NVARCHAR(50) NOT NULL, -- First name is mandatory
    last_name NVARCHAR(50) NOT NULL, -- Last name is mandatory
    phone_number VARCHAR(20) NOT NULL, -- Phone number is mandatory
    address VARCHAR(255) NOT NULL, -- Address is mandatory
    age INT, -- Optional age column
    gender VARCHAR(10), -- Optional gender column (e.g., Male, Female, Other)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP -- Timestamp for record creation
);

CREATE TABLE Orders (
    order_id CHAR(36) PRIMARY KEY,
    customer_id CHAR(36) NOT NULL,
    status VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
CREATE TABLE Products (
    product_id CHAR(36) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255),
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    units_in_stock INT NOT NULL CHECK (units_in_stock >= 0)
);

CREATE TABLE OrderItems (
    order_item_id CHAR(36) PRIMARY KEY,
    order_id CHAR(36) NOT NULL,
    product_id CHAR(36) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Categories (
    category_id CHAR(36) PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE ProductCategories (
    product_id CHAR(36),
    category_id CHAR(36),
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Suppliers (
    supplier_id CHAR(36) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(255)
);

CREATE TABLE ProductSuppliers (
    product_id CHAR(36),
    supplier_id CHAR(36),
    PRIMARY KEY (product_id, supplier_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

CREATE TABLE Shipping (
    shipping_id CHAR(36) PRIMARY KEY,
    order_id CHAR(36) UNIQUE NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(50) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(50) NOT NULL,
    shipping_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Reviews (
    review_id CHAR(36) PRIMARY KEY,
    product_id CHAR(36) NOT NULL,
    customer_id CHAR(36) NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(255),
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Wishlists (
    wishlist_id CHAR(36) PRIMARY KEY,
    customer_id CHAR(36),
    product_id CHAR(36),
    added_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
    payment_id CHAR(36) PRIMARY KEY,
    order_id CHAR(36) UNIQUE NOT NULL,
    customer_id CHAR(36) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL CHECK (payment_status IN ('Pending', 'Completed', 'Failed')),
    payment_date DATETIME DEFAULT GETDATE(),
    cc_flag BIT DEFAULT 0,
    gc_flag BIT DEFAULT 0,
    CHECK (CAST(cc_flag AS INT) + CAST(gc_flag AS INT) >= 1),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE PaymentDetails (
    payment_detail_id CHAR(36) PRIMARY KEY,
    payment_id CHAR(36) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_type VARCHAR(20) NOT NULL CHECK (payment_type IN ('Credit Card', 'Gift Card')),
    FOREIGN KEY (payment_id) REFERENCES Payments(payment_id)
);

CREATE TABLE CreditCardPayments (
    credit_card_payment_id CHAR(36) PRIMARY KEY, -- Unique identifier for credit card payments
    payment_id CHAR(36) UNIQUE NOT NULL, -- Link to Payments table
    card_number VARCHAR(16) NOT NULL,
    card_holder_name VARCHAR(100) NOT NULL,
    expiry_date DATE NOT NULL,
    FOREIGN KEY (payment_id) REFERENCES Payments(payment_id)
);

CREATE TABLE GiftCardPayments (
    gift_card_payment_id CHAR(36) PRIMARY KEY, -- Unique identifier for gift card payments
    payment_id CHAR(36) UNIQUE NOT NULL, -- Link to Payments table
    gift_card_code VARCHAR(50) NOT NULL,
    FOREIGN KEY (payment_id) REFERENCES Payments(payment_id)
);

-- Insert Values
-- Customer 
INSERT INTO Customers (customer_id, first_name, last_name, age, gender, email, phone_number, address, created_at)
VALUES
('C001', 'Nguyen', 'Van A', 30, 'Male', 'nguyenvana@example.com', '0981-234-001', '12 Kim Ma, Ba Dinh, Ha Noi', '2025-01-01 10:00:00'),
('C002', 'Tran', 'Thi Bich', 25, 'Female', 'tranbich@example.com', '0982-345-002', '45 Lang Ha, Dong Da, Ha Noi', '2025-01-02 11:00:00'),
('C003', 'Le', 'Ngoc Cam', 28, 'Female', 'lengoccam@example.com', '0983-456-003', '78 Giang Vo, Ba Dinh, Ha Noi', '2025-01-03 12:00:00'),
('C004', 'Pham', 'Quang Dung', 35, 'Male', 'phamqd@example.com', '0984-567-004', '101 Pho Hue, Hai Ba Trung, Ha Noi', '2025-01-04 13:00:00'),
('C005', 'Vo', 'Minh Duc', 40, 'Male', 'vominhduc@example.com', '0985-678-005', '202 Tay Son, Dong Da, Ha Noi', '2025-01-05 14:00:00'),
('C006', 'Dang', 'Thuy Dung', 22, 'Female', 'dangthuydung@example.com', '0986-789-006', '303 Xuan Thuy, Cau Giay, Ha Noi', '2025-01-06 15:00:00'),
('C007', 'Ngo', 'Huu Hoa', 45, 'Male', 'ngohuuh@example.com', '0987-890-007', '404 Cau Giay, Cau Giay, Ha Noi', '2025-01-07 16:00:00'),
('C008', 'Bui', 'Mai Huong', 32, 'Female', 'buimaihuong@example.com', '0988-901-008', '505 Le Duan, Hoan Kiem, Ha Noi', '2025-01-08 17:00:00'),
('C009', 'Hoang', 'Van Khanh', 27, 'Male', 'hoangvankhanh@example.com', '0989-012-009', '606 Tran Duy Hung, Cau Giay, Ha Noi', '2025-01-09 18:00:00'),
('C010', 'Do', 'Thu Lan', 29, 'Female', 'dothulan@example.com', '0970-123-010', '707 De La Thanh, Ba Dinh, Ha Noi', '2025-01-10 19:00:00'),
('C011', 'Trinh', 'Cong Ly', 33, 'Male', 'trinhcongly@example.com', '0971-234-011', '808 Nguyen Chi Thanh, Dong Da, Ha Noi', '2025-01-11 20:00:00'),
('C012', 'Ly', 'Thanh Mai', 31, 'Female', 'lythanhmai@example.com', '0972-345-012', '909 Hoang Quoc Viet, Cau Giay, Ha Noi', '2025-01-12 21:00:00'),
('C013', 'Duong', 'Van Nam', 36, 'Male', 'duongvannam@example.com', '0973-456-013', '1010 Nguyen Trai, Thanh Xuan, Ha Noi', '2025-01-13 22:00:00'),
('C014', 'To', 'Kim Ngan', 38, 'Female', 'tokimngan@example.com', '0974-567-014', '1111 Tran Khat Chan, Hai Ba Trung, Ha Noi', '2025-01-14 23:00:00'),
('C015', 'Nguyen', 'Van Phuc', 42, 'Male', 'nguyenvanphuc@example.com', '0975-678-015', '1212 Bach Mai, Hai Ba Trung, Ha Noi', '2025-01-15 08:00:00'),
('C016', 'Phan', 'Ngoc Quynh', 34, 'Female', 'phanquynh@example.com', '0976-789-016', '1313 Le Trong Tan, Thanh Xuan, Ha Noi', '2025-01-16 09:00:00'),
('C017', 'Ho', 'Minh Quan', 37, 'Male', 'hominhquan@example.com', '0977-890-017', '1414 Kim Giang, Hoang Mai, Ha Noi', '2025-01-17 10:00:00'),
('C018', 'Lam', 'Dieu Thao', 26, 'Female', 'lamdieuthao@example.com', '0978-901-018', '1515 Nguyen Xien, Thanh Xuan, Ha Noi', '2025-01-18 11:00:00'),
('C019', 'Truong', 'Thanh Tung', 39, 'Male', 'truongthanhtung@example.com', '0979-012-019', '1616 Nguyen Luong Bang, Dong Da, Ha Noi', '2025-01-19 12:00:00'),
('C020', 'Dinh', 'Phuong Van', 41, 'Female', 'dinhphuongvan@example.com', '0968-123-020', '1717 Phan Dinh Phung, Ba Dinh, Ha Noi', '2025-01-20 13:00:00');

-- Orders 
select * from customers;
INSERT INTO Orders (order_id, customer_id, status, created_at)
VALUES
-- Orders for Customer C001
('O001', 'C001', 'Completed', '2025-07-01 12:00:00'),
('O002', 'C001', 'Processing', '2025-07-15 09:00:00'),

-- Orders for Customer C002
('O003', 'C002', 'Completed', '2025-07-10 08:00:00'),
('O004', 'C002', 'Completed', '2025-06-30 11:45:00'),

-- Orders for Customer C003
('O005', 'C003', 'Completed', '2025-07-12 14:15:00'),
('O006', 'C003', 'Processing', '2025-07-20 16:45:00'),

-- Orders for Customer C004
('O007', 'C004', 'Processing', '2025-07-18 10:30:00'),

-- Orders for Customer C005
('O008', 'C005', 'Completed', '2025-07-01 12:00:00'),
('O009', 'C005', 'Processing', '2025-07-10 08:00:00'),

-- Orders for Customer C006
('O010', 'C006', 'Completed', '2025-07-12 14:15:00'),
('O011', 'C006', 'Processing', '2025-07-12 14:15:00'),

-- Orders for Customer C007
('O012', 'C007', 'Completed', '2025-07-15 09:00:00'),

-- Orders for Customer C008
('O013', 'C008', 'Processing', '2025-07-18 10:30:00'),

-- Orders for Customer C009
('O014', 'C009', 'Completed', '2025-07-01 12:00:00'),
('O015', 'C009', 'Processing', '2025-07-10 08:00:00'),

-- Orders for Customer C010
('O016', 'C010', 'Completed', '2025-07-12 14:15:00'),
('O017', 'C010', 'Processing', '2025-07-12 14:15:00'),

-- Orders for Customer C011
('O018', 'C011', 'Completed', '2025-07-15 09:00:00'),

-- Orders for Customer C012
('O019', 'C012', 'Processing', '2025-07-18 10:30:00'),

-- Orders for Customer C013
('O020', 'C013', 'Completed', '2025-07-01 12:00:00'),
('O021', 'C013', 'Processing', '2025-07-10 08:00:00'),

-- Orders for Customer C014
('O022', 'C014', 'Completed', '2025-07-12 14:15:00'),
('O023', 'C014', 'Processing', '2025-07-12 14:15:00'),

-- Orders for Customer C015
('O024', 'C015', 'Completed', '2025-07-15 09:00:00'),

-- Orders for Customer C016
('O025', 'C016', 'Processing', '2025-07-18 10:30:00'),

-- Orders for Customer C017
('O026', 'C017', 'Completed', '2025-07-01 12:00:00'),
('O027', 'C017', 'Processing', '2025-07-10 08:00:00'),

-- Orders for Customer C018
('O028', 'C018', 'Completed', '2025-07-12 14:15:00'),
('O029', 'C018', 'Processing', '2025-07-12 14:15:00'),

-- Orders for Customer C019
('O030', 'C019', 'Completed', '2025-07-15 09:00:00'),

-- Orders for Customer C020
('O031', 'C020', 'Processing', '2025-07-18 10:30:00');

-- Products 
select * from orders;
INSERT INTO Products (product_id, name, description, price, units_in_stock)
VALUES
('P001', 'Smartphone', N'Điện thoại thông minh 128GB', 8500000, 50),
('P002', 'Jeans', N'Quần jeans xanh thoải mái', 400000, 100),
('P003', 'Cookbook', N'Sách nấu ăn lành mạnh hàng ngày', 120000, 200),
('P004', 'Blender', N'Máy xay sinh tố tốc độ cao', 950000, 30),
('P005', 'Laptop', N'Laptop 15 inch SSD 256GB', 15000000, 40),
('P006', 'T-shirt', N'Áo thun cotton nhiều màu', 150000, 150),
('P007', 'Headphones', N'Tai nghe chống ồn chụp tai', 1200000, 60),
('P008', 'Sneakers', N'Giày thể thao vải thoáng khí', 650000, 80),
('P009', 'Coffee Maker', N'Máy pha cà phê tự động có xay', 1800000, 25),
('P010', 'Backpack', N'Ba lô đa năng chắc chắn', 400000, 70),
('P011', 'Tablet', N'Máy tính bảng 10 inch 64GB', 5500000, 45),
('P012', 'Dress', N'Đầm dạ hội sang trọng', 890000, 90),
('P013', 'Novel', N'Tiểu thuyết bán chạy', 100000, 120),
('P014', 'Microwave', N'Lò vi sóng', 2000000, 35),
('P015', 'Action Figure', N'Mô hình hành động sưu tầm', 250000, 110),
('P016', 'Basketball', N'Bóng rổ cỡ tiêu chuẩn', 300000, 95),
('P017', 'Lipstick', N'Son lì lâu trôi', 180000, 130),
('P018', 'Yoga Mat', N'Thảm tập yoga chống trượt', 350000, 85),
('P019', 'Car Charger', N'Củ sạc nhanh dùng cho ô tô', 120000, 140),
('P020', 'Sofa', N'Sofa vải 3 chỗ ngồi', 7500000, 20),
('P021', 'Keyboard', N'Bàn phím cơ chơi game', 900000, 60),
('P022', 'Camera', N'Máy ảnh kỹ thuật số DSLR', 11500000, 20);

-- Wishlists
INSERT INTO Wishlists (wishlist_id, customer_id, product_id, added_date)
VALUES
('W001', 'C018', 'P021', '2025-12-07 00:00:00'),
('W002', 'C013', 'P012', '2025-06-15 00:00:00'),
('W003', 'C015', 'P005', '2025-12-24 00:00:00'),
('W004', 'C002', 'P012', '2025-09-26 00:00:00'),
('W005', 'C005', 'P012', '2025-09-03 00:00:00'),
('W006', 'C019', 'P015', '2025-04-16 00:00:00'),
('W007', 'C016', 'P001', '2025-07-18 00:00:00'),
('W008', 'C014', 'P007', '2025-11-13 00:00:00'),
('W009', 'C013', 'P011', '2025-08-10 00:00:00'),
('W010', 'C016', 'P011', '2025-05-28 00:00:00'),
('W011', 'C010', 'P018', '2025-07-22 00:00:00'),
('W012', 'C005', 'P020', '2025-11-08 00:00:00'),
('W013', 'C011', 'P018', '2025-11-17 00:00:00'),
('W014', 'C019', 'P021', '2025-06-21 00:00:00'),
('W015', 'C017', 'P008', '2025-10-14 00:00:00'),
('W016', 'C020', 'P010', '2025-01-05 00:00:00'), 
('W017', 'C018', 'P009', '2025-07-13 00:00:00'), 
('W018', 'C015', 'P013', '2025-12-07 00:00:00'),
('W019', 'C020', 'P017', '2025-06-21 00:00:00'),
('W020', 'C014', 'P006', '2025-03-09 00:00:00');

-- Categories
INSERT INTO Categories (category_id, name)
VALUES
('CAT001', 'Electronics'),
('CAT002', 'Home Appliances'),
('CAT003', 'Books'),
('CAT004', 'Clothing'),
('CAT005', 'Toys'),
('CAT006', 'Furniture'),
('CAT007', 'Health & Beauty'),
('CAT008', 'Sports'),
('CAT009', 'Automotive');

-- Product Categories
INSERT INTO ProductCategories (product_id, category_id)
VALUES
-- Electronics
('P001', 'CAT001'), -- Smartphone
('P005', 'CAT001'), -- Laptop
('P007', 'CAT001'), -- Headphones
('P011', 'CAT001'), -- Tablet
('P021', 'CAT001'), -- Keyboard
('P022', 'CAT001'), -- Camera

-- Home Appliances
('P004', 'CAT002'), -- Blender
('P009', 'CAT002'), -- Coffee Maker
('P014', 'CAT002'), -- Microwave

-- Books
('P003', 'CAT003'), -- Cookbook
('P013', 'CAT003'), -- Novel

-- Clothing
('P002', 'CAT004'), -- Jeans
('P006', 'CAT004'), -- T-shirt
('P012', 'CAT004'), -- Dress
('P010', 'CAT004'), -- Backpack (Added under Clothing)
('P008', 'CAT004'),

-- Toys
('P015', 'CAT005'), -- Action Figure
('P016', 'CAT005'),

-- Furniture
('P020', 'CAT006'), -- Sofa

-- Health & Beauty
('P017', 'CAT007'), -- Son 

-- Sports
('P008', 'CAT008'), -- Sneakers
('P016', 'CAT008'), -- Basketball
('P018', 'CAT008'), -- Yoga Mat
('P010', 'CAT008'),

-- Automotive
('P019', 'CAT009'); -- Car Charger

-- Suppliers
INSERT INTO Suppliers (supplier_id, name, contact_info)
VALUES
('S001', 'Samsung Inc.', 'techgurus@example.com, +84-981-010-001'),
('S002', 'Fashionista Co.', 'contact@fashionista.com, +84-982-020-002'),
('S003', 'Home Essentials', 'support@homeessentials.com, +84-983-030-003'),
('S004', 'FitLife Supplies', 'info@fitlife.com, +84-984-040-004'),
('S005', 'BooksWorld', 'books@example.com, +84-985-050-005'),
('S006', 'GadgetPros', 'sales@gadgetpros.com, +84-986-060-006'),
('S007', 'Sporty Gear', 'contact@sportygear.com, +84-987-070-007'),
('S008', 'FurnishWell', 'furnish@example.com, +84-988-080-008'),
('S009', 'BrightTech', 'hello@brighttech.com, +84-989-090-009'),
('S010', 'Healthy Living', 'healthyliving@example.com, +84-970-101-010'),
('S011', 'ElectroHub', 'contact@electrohub.com, +84-971-111-011'),
('S012', 'WearItWell', 'info@wearitwell.com, +84-972-121-012'),
('S013', 'ApplianceMart', 'support@appliancemart.com, +84-973-131-013'),
('S014', 'SportsEmpire', 'sales@sportsempire.com, +84-974-141-014'),
('S015', 'KitchenPros', 'info@kitchenpros.com, +84-975-151-015'),
('S016', 'EcoEssentials', 'hello@ecoessentials.com, +84-976-161-016'),
('S017', 'MegaBooks', 'support@megabooks.com, +84-977-171-017'),
('S018', 'StyleFirst', 'contact@stylefirst.com, +84-978-181-018'),
('S019', 'ActiveGear', 'info@activegear.com, +84-979-191-019'),
('S020', 'UrbanHome', 'sales@urbanhome.com, +84-968-202-020');

-- Product Suppliers
INSERT INTO ProductSuppliers (product_id, supplier_id)
VALUES
-- Smartphone (P001) is supplied by Samsung, GadgetPros, and ElectroHub
('P001', 'S001'),
('P001', 'S006'),
('P001', 'S011'),

-- Jeans (P002) is supplied by Fashionista Co. and StyleFirst
('P002', 'S002'),
('P002', 'S018'),

-- Cookbook (P003) is supplied by BooksWorld and MegaBooks
('P003', 'S005'),
('P003', 'S017'),

-- Blender (P004) is supplied by Home Essentials and KitchenPros
('P004', 'S003'),
('P004', 'S015'),

-- Laptop (P005) is supplied by Samsung, BrightTech, and ElectroHub
('P005', 'S001'),
('P005', 'S009'),
('P005', 'S011'),

-- T-shirt (P006) is supplied by Fashionista Co., WearItWell, and StyleFirst
('P006', 'S002'),
('P006', 'S012'),
('P006', 'S018'),

-- Headphones (P007) is supplied by GadgetPros and ElectroHub
('P007', 'S006'),
('P007', 'S011'),

-- Sneakers (P008) is supplied by Sporty Gear, ActiveGear, and SportsEmpire
('P008', 'S007'),
('P008', 'S014'),
('P008', 'S019'),

-- Coffee Maker (P009) is supplied by Home Essentials and KitchenPros
('P009', 'S003'),
('P009', 'S015'),

-- Backpack (P010) is supplied by Fashionista Co. and UrbanHome
('P010', 'S002'),
('P010', 'S020'),

-- Tablet (P011) is supplied by BrightTech and ElectroHub
('P011', 'S009'),
('P011', 'S011'),

-- Dress (P012) is supplied by Fashionista Co. and StyleFirst
('P012', 'S002'),
('P012', 'S018'),

-- Novel (P013) is supplied by BooksWorld and MegaBooks
('P013', 'S005'),
('P013', 'S017'),

-- Microwave (P014) is supplied by Home Essentials, KitchenPros, and ApplianceMart
('P014', 'S003'),
('P014', 'S015'),
('P014', 'S013'),

-- Action Figure (P015) is supplied by GadgetPros and BrightTech
('P015', 'S006'),
('P015', 'S009'),

-- Basketball (P016) is supplied by Sporty Gear, ActiveGear, and FitLife Supplies
('P016', 'S007'),
('P016', 'S019'),
('P016', 'S004'),

-- Lipstick (P017) is supplied by Healthy Living and EcoEssentials
('P017', 'S010'),
('P017', 'S016'),

-- Yoga Mat (P018) is supplied by FitLife Supplies, ActiveGear, and SportsEmpire
('P018', 'S004'),
('P018', 'S019'),
('P018', 'S014'),

-- Car Charger (P019) is supplied by GadgetPros and BrightTech
('P019', 'S006'),
('P019', 'S009'),

-- Sofa (P020) is supplied by FurnishWell, UrbanHome, and EcoEssentials
('P020', 'S008'),
('P020', 'S020'),
('P020', 'S016'),

-- Keyboard (P021) is supplied by Samsung, ElectroHub, and BrightTech
('P021', 'S001'),
('P021', 'S011'),
('P021', 'S009'),

-- Camera (P022) is supplied by BrightTech, ElectroHub, and Samsung
('P022', 'S009'),
('P022', 'S011'),
('P022', 'S001');

-- Shipping 
INSERT INTO Shipping (shipping_id, order_id, address, city, postal_code, country, shipping_date)
VALUES
('S001', 'O001', '12 Kim Ma', 'Ba Dinh', '11110', 'Vietnam', '2025-07-02 10:00:00'),
('S002', 'O002', '12 Kim Ma', 'Ba Dinh', '11110', 'Vietnam', '2025-07-16 12:00:00'),

('S003', 'O003', '45 Lang Ha', 'Dong Da', '11200', 'Vietnam', '2025-07-11 14:00:00'),
('S004', 'O004', '45 Lang Ha', 'Dong Da', '11200', 'Vietnam', '2025-07-01 16:00:00'),

('S005', 'O005', '78 Giang Vo', 'Ba Dinh', '11110', 'Vietnam', '2025-07-13 09:00:00'),
('S006', 'O006', '78 Giang Vo', 'Ba Dinh', '11110', 'Vietnam', '2025-07-21 11:00:00'),

('S007', 'O007', '101 Pho Hue', 'Hai Ba Trung', '11700', 'Vietnam', '2025-07-19 15:00:00'),

('S008', 'O008', '202 Tay Son', 'Dong Da', '11200', 'Vietnam', '2025-07-02 08:00:00'),
('S009', 'O009', '202 Tay Son', 'Dong Da', '11200', 'Vietnam', '2025-07-11 10:00:00'),

('S010', 'O010', '303 Xuan Thuy', 'Cau Giay', '11110', 'Vietnam', '2025-07-13 13:00:00'),
('S011', 'O011', '303 Xuan Thuy', 'Cau Giay', '11300', 'Vietnam', '2025-07-13 15:00:00'),

('S012', 'O012', '404 Cau Giay', 'Cau Giay', '11700', 'Vietnam', '2025-07-16 17:00:00'),

('S013', 'O013', '505 Le Duan', 'Hoan Kiem', '11500', 'Vietnam', '2025-07-19 10:00:00'),

('S014', 'O014', '606 Tran Duy Hung', 'Cau Giay', '11300', 'Vietnam', '2025-07-02 11:00:00'),
('S015', 'O015', '606 Tran Duy Hung', 'Cau Giay', '11300', 'Vietnam', '2025-07-11 12:00:00'),

('S016', 'O016', '707 De La Thanh', 'Ba Dinh', '11110', 'Vietnam', '2025-07-13 14:00:00'),
('S017', 'O017', '707 De La Thanh', 'Ba Dinh', '11110', 'Vietnam', '2025-07-13 16:00:00'),

('S018', 'O018', '808 Nguyen Chi Thanh', 'Dong Da', '11200', 'Vietnam', '2025-07-16 18:00:00'),

('S019', 'O019', '909 Hoang Quoc Viet', 'Cau Giay', '11300', 'Vietnam', '2025-07-19 19:00:00'),

('S020', 'O020', '1010 Nguyen Trai', 'Thanh Xuan', '11900', 'Vietnam', '2025-07-02 20:00:00'),
('S021', 'O021', '1010 Nguyen Trai', 'Thanh Xuan', '11900', 'Vietnam', '2025-07-11 21:00:00'),

('S022', 'O022', '1111 Tran Khat Chan', 'Hai Ba Trung', '11700', 'Vietnam', '2025-07-13 22:00:00'),
('S023', 'O023', '1111 Tran Khat Chan', 'Hai Ba Trung', '11700', 'Vietnam', '2025-07-13 23:00:00'),

('S024', 'O024', '1212 Bach Mai', 'Hai Ba Trung', '11700', 'Vietnam', '2025-07-16 08:00:00'),

('S025', 'O025', '1313 Le Trong Tan', 'Thanh Xuan', '11900', 'Vietnam', '2025-07-19 09:00:00'),

('S026', 'O026', '1414 Kim Giang', 'Hoang Mai', '11800', 'Vietnam', '2025-07-02 10:00:00'),
('S027', 'O027', '1414 Kim Giang', 'Hoang Mai', '11800', 'Vietnam', '2025-07-11 11:00:00'),

('S028', 'O028', '1515 Nguyen Xien', 'Thanh Xuan', '11900', 'Vietnam', '2025-07-13 12:00:00'),
('S029', 'O029', '1515 Nguyen Xien', 'Thanh Xuan', '11900', 'Vietnam', '2025-07-13 13:00:00'),

('S030', 'O030', '1616 Nguyen Luong Bang', 'Dong Da', '11200', 'Vietnam', '2025-07-16 14:00:00'),

('S031', 'O031', '1717 Phan Dinh Phung', 'Ba Dinh', '11110', 'Vietnam', '2025-07-19 15:00:00');

-- Order Items 
INSERT INTO OrderItems (order_item_id, order_id, product_id, quantity, price)
VALUES
-- Order O001 (Customer C001)
('OI001', 'O001', 'P001', 1, 8500000), -- Smartphone
('OI002', 'O001', 'P005', 1, 15000000), -- Laptop

-- Order O002 (Customer C001)
('OI003', 'O002', 'P007', 2, 1200000), -- Headphones
('OI004', 'O002', 'P008', 1, 650000),  -- Sneakers

-- Order O003 (Customer C002)
('OI005', 'O003', 'P012', 1, 890000),  -- Dress
('OI006', 'O003', 'P017', 3, 180000),  -- Lipstick

-- Order O004 (Customer C002)
('OI007', 'O004', 'P018', 2, 350000),  -- Yoga Mat

-- Order O005 (Customer C003)
('OI008', 'O005', 'P009', 1, 1800000), -- Coffee Maker
('OI009', 'O005', 'P022', 1, 11500000), -- Camera

-- Order O006 (Customer C003)
('OI010', 'O006', 'P003', 2, 120000),  -- Cookbook

-- Order O007 (Customer C004)
('OI011', 'O007', 'P021', 1, 900000),  -- Keyboard
('OI012', 'O007', 'P014', 1, 1700000), -- Microwave

-- Order O008 (Customer C005)
('OI013', 'O008', 'P013', 1, 100000),  -- Novel
('OI014', 'O008', 'P010', 1, 400000),  -- Backpack

-- Order O009 (Customer C005)
('OI015', 'O009', 'P019', 2, 120000),  -- Car Charger

-- Order O010 (Customer C006)
('OI016', 'O010', 'P004', 1, 950000),  -- Blender
('OI017', 'O010', 'P002', 3, 400000),  -- Jeans

-- Order O011 (Customer C006)
('OI018', 'O011', 'P016', 2, 300000),  -- Basketball

-- Order O012 (Customer C007)
('OI019', 'O012', 'P020', 1, 7500000), -- Sofa

-- Order O013 (Customer C008)
('OI020', 'O013', 'P001', 1, 8500000), -- Smartphone
('OI021', 'O013', 'P011', 1, 5500000), -- Tablet

-- Order O014 (Customer C009)
('OI022', 'O014', 'P015', 2, 250000),  -- Action Figure
('OI023', 'O014', 'P020', 1, 7500000), -- Sofa

-- Order O015 (Customer C009)
('OI024', 'O015', 'P006', 1, 150000), -- T-shirt
('OI025', 'O015', 'P012', 1, 890000), -- Dress

-- Order O016 (Customer C010)
('OI026', 'O016', 'P022', 1, 11500000), -- Camera
('OI027', 'O016', 'P008', 2, 650000), -- Sneakers

-- Order O017 (Customer C010)
('OI028', 'O017', 'P021', 1, 900000), -- Keyboard

-- Order O018 (Customer C011)
('OI029', 'O018', 'P001', 1, 8500000), -- Smartphone
('OI030', 'O018', 'P007', 2, 1200000), -- Headphones

-- Order O019 (Customer C012)
('OI031', 'O019', 'P017', 1, 180000), -- Lipstick
('OI032', 'O019', 'P016', 2, 300000), -- Basketball

-- Order O020 (Customer C013)
('OI033', 'O020', 'P003', 3, 120000), -- Cookbook
('OI034', 'O020', 'P009', 1, 1800000), -- Coffee Maker

-- Order O021 (Customer C013)
('OI035', 'O021', 'P002', 2, 400000), -- Jeans
('OI036', 'O021', 'P010', 1, 400000), -- Backpack

-- Order O022 (Customer C014)
('OI037', 'O022', 'P006', 1, 150000), -- T-shirt
('OI038', 'O022', 'P005', 1, 15000000), -- Laptop

-- Order O023 (Customer C014)
('OI039', 'O023', 'P012', 1, 890000), -- Dress
('OI040', 'O023', 'P019', 2, 120000), -- Car Charger

-- Order O024 (Customer C015)
('OI041', 'O024', 'P001', 1, 8500000), -- Smartphone
('OI042', 'O024', 'P007', 1, 1200000), -- Headphones

-- Order O025 (Customer C016)
('OI043', 'O025', 'P018', 2, 350000), -- Yoga Mat

-- Order O026 (Customer C017)
('OI044', 'O026', 'P015', 1, 250000), -- Action Figure
('OI045', 'O026', 'P008', 2, 650000), -- Sneakers

-- Order O027 (Customer C017)
('OI046', 'O027', 'P020', 1, 7500000), -- Sofa
('OI047', 'O027', 'P013', 1, 100000), -- Novel

-- Order O028 (Customer C018)
('OI048', 'O028', 'P017', 2, 180000), -- Lipstick
('OI049', 'O028', 'P009', 1, 1800000), -- Coffee Maker

-- Order O029 (Customer C018)
('OI050', 'O029', 'P022', 1, 11500000), -- Camera

-- Order O030 (Customer C019)
('OI051', 'O030', 'P010', 1, 400000), -- Backpack
('OI052', 'O030', 'P014', 1, 1700000), -- Microwave

-- Order O031 (Customer C020)
('OI053', 'O031', 'P004', 1, 950000), -- Blender
('OI054', 'O031', 'P021', 1, 900000); -- Keyboard

-- Thêm một cột mới vào bảng Orders để lưu tổng tiền của đơn hàng.
ALTER TABLE Orders ADD total_amount DECIMAL(10, 2) DEFAULT 0;

UPDATE o
SET o.total_amount = total_sub.total_amount
FROM Orders o
JOIN (
    SELECT order_id, SUM(quantity * price) AS total_amount
    FROM OrderItems
    GROUP BY order_id
) AS total_sub ON total_sub.order_id = o.order_id;

-- Kiểm tra dữ liệu hợp lệ mỗi khi có dòng mới chèn vào bảng OrderItems
-- 1.Không chèn sản phẩm không tồn tại
-- 2.Không cho giá sai lệch so với giá gốc trong bảng Products
USE Onlinestore;
GO 
CREATE TRIGGER check_order_item_price 
ON OrderItems
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    -- Kiểm tra nếu có sản phẩm không tồn tại trong bảng Products
    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN Products p ON i.product_id = p.product_id
        WHERE p.product_id IS NULL
    )
    BEGIN
        RAISERROR('Product ID does not exist in Products table', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    -- Kiểm tra nếu giá không khớp
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Products p ON i.product_id = p.product_id
        WHERE i.price <> p.price
    )
    BEGIN
        RAISERROR('Price in OrderItems does not match Products table', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;

-- Insert Payment, chia thành 2 cách thanh toán hoặc có thể thanh toán cả 2 loại - trường hợp thẻ giftcard giảm giá 50%, 100% thì chỉ gift card 
select * from orders;
INSERT INTO Payments (payment_id, order_id, customer_id, total_amount, payment_status, payment_date, cc_flag, gc_flag)
VALUES
('PAY001', 'O001', 'C001', 23500000, 'Completed', '2025-07-01 13:00:00', 1, 0),
('PAY002', 'O002', 'C001', 3050000, 'Completed', '2025-07-15 10:00:00', 1, 0),

('PAY003', 'O003', 'C002', 1430000, 'Completed', '2025-07-10 09:00:00', 0, 1),
('PAY004', 'O004', 'C002', 700000, 'Completed', '2025-06-30 12:00:00', 1, 0),

('PAY005', 'O005', 'C003', 13300000, 'Completed', '2025-07-12 15:00:00', 1, 1),
('PAY006', 'O006', 'C003', 240000, 'Completed', '2025-07-20 17:30:00', 1, 0),

('PAY007', 'O007', 'C004', 2600000, 'Completed', '2025-07-18 11:00:00', 0, 1),

('PAY008', 'O008', 'C005', 500000, 'Completed', '2025-07-01 14:00:00', 1, 0),
('PAY009', 'O009', 'C005', 240000, 'Completed', '2025-07-10 09:30:00', 0, 1),

('PAY010', 'O010', 'C006', 2150000, 'Completed', '2025-07-12 15:30:00', 1, 0),
('PAY011', 'O011', 'C006', 600000, 'Completed', '2025-07-12 15:45:00', 1, 0),

('PAY012', 'O012', 'C007', 7500000, 'Completed', '2025-07-15 10:30:00', 1, 1),

('PAY013', 'O013', 'C008', 14000000, 'Completed', '2025-07-18 11:30:00', 0, 1),

('PAY014', 'O014', 'C009', 8000000, 'Completed', '2025-07-01 14:30:00', 1, 0),
('PAY015', 'O015', 'C009', 1040000, 'Completed', '2025-07-10 10:00:00', 1, 0),

('PAY016', 'O016', 'C010', 12800000, 'Completed', '2025-07-12 16:00:00', 1, 1),
('PAY017', 'O017', 'C010', 900000, 'Completed', '2025-07-12 16:30:00', 0, 1),

('PAY018', 'O018', 'C011', 10900000, 'Completed', '2025-07-15 11:00:00', 1, 1),

('PAY019', 'O019', 'C012', 780000, 'Completed', '2025-07-18 12:00:00', 0, 1),

('PAY020', 'O020', 'C013', 2160000, 'Completed', '2025-07-01 15:00:00', 1, 0),
('PAY021', 'O021', 'C013', 1200000, 'Completed', '2025-07-10 10:30:00', 1, 0),

('PAY022', 'O022', 'C014', 15150000, 'Completed', '2025-07-12 17:00:00', 1, 1),
('PAY023', 'O023', 'C014', 1130000, 'Pending', '2025-07-12 17:30:00', 1, 0),

('PAY024', 'O024', 'C015', 9700000, 'Completed', '2025-07-15 12:00:00', 1, 0),

('PAY025', 'O025', 'C016', 700000, 'Completed', '2025-07-18 12:30:00', 0, 1),

('PAY026', 'O026', 'C017', 1550000, 'Completed', '2025-07-01 16:00:00', 1, 0),
('PAY027', 'O027', 'C017', 7600000, 'Completed', '2025-07-10 11:00:00', 0, 1),

('PAY028', 'O028', 'C018', 2160000, 'Completed', '2025-07-12 18:00:00', 1, 0),
('PAY029', 'O029', 'C018', 11500000, 'Completed', '2025-07-12 18:30:00', 0, 1),

('PAY030', 'O030', 'C019', 2100000, 'Completed', '2025-07-15 13:00:00', 1, 0),

('PAY031', 'O031', 'C020', 1850000, 'Pending', '2025-07-18 13:30:00', 1, 0);

-- Đảm bảo rằng tổng tiền thanh toán (Payments.total_amount) phải đúng bằng tổng tiền của đơn hàng (Orders.total_amount).
GO 
CREATE TRIGGER check_total_payment
ON Payments
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    -- Kiểm tra nếu total_amount trong Payments không khớp với Orders
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Orders o ON i.order_id = o.order_id
        WHERE i.total_amount <> o.total_amount
    )
    BEGIN
        RAISERROR('Total payment amount must match the total amount of the order', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO 

-- Insert Reviews
INSERT INTO Reviews (review_id, product_id, customer_id, rating, comment, review_date)
VALUES
-- Reviews for Customer C001
('R001', 'P001', 'C001', 5, N'Diện thoại thông minh rất tuyệt vời và dễ sử dụng.', '2025-08-01 12:00:00'), -- Order O001
('R002', 'P007', 'C001', 2, N'Tai nghe đeo lâu khá khó chịu.', '2025-08-15 09:00:00'), -- Order O002

-- Reviews for Customer C002
('R003', 'P012', 'C002', 4, N'Chiếc đầm rất thanh lịch và vừa vặn.', '2025-08-10 08:00:00'), -- Order O003
('R004', 'P018', 'C002', 2, N'Thảm yoga bị trơn sau một thời gian sử dụng.', '2025-07-30 11:45:00'), -- Order O004

-- Reviews for Customer C003
('R005', 'P009', 'C003', 5, N'Máy pha cà phê hoạt động hoàn hảo. Rất đáng mua!', '2025-08-12 14:15:00'), -- Order O005
('R006', 'P003', 'C003', 3, N'Sách nấu ăn có vài công thức hay nhưng chưa phong phú.', '2025-08-20 16:45:00'), -- Order O006

-- Reviews for Customer C004
('R007', 'P021', 'C004', 4, N'Bàn phím gõ mượt và phản hồi tốt.', '2025-08-18 10:30:00'), -- Order O007

-- Reviews for Customer C005
('R008', 'P013', 'C005', 4, N'Tiểu thuyết rất hấp dẫn và lôi cuốn!', '2025-08-01 12:00:00'), -- Order O008
('R009', 'P019', 'C005', 1, N'Cục sạc ô tô hỏng sau một tuần sử dụng.', '2025-08-10 08:00:00'), -- Order O009

-- Reviews for Customer C006
('R010', 'P004', 'C006', 5, N'Máy xay sinh tố hoạt động tốt cho món smoothie.', '2025-08-12 14:15:00'), -- Order O010
('R011', 'P016', 'C006', 2, N'Bóng rổ bị xì hơi nhanh.', '2025-08-12 14:15:00'), -- Order O011

-- Reviews for Customer C007
('R012', 'P020', 'C007', 5, N'Sofa rất thoải mái và đẹp mắt.', '2025-08-15 09:00:00'), -- Order O012

-- Reviews for Customer C008
('R013', 'P001', 'C008', 5, N'Diện thoại thông minh tuyệt vời. Rất dễ sử dụng.', '2025-08-18 10:30:00'), -- Order O013

-- Reviews for Customer C009
('R014', 'P015', 'C009', 4, N'Mô hình hành động được làm chi tiết và đẹp.', '2025-08-01 12:00:00'), -- Order O014

-- Reviews for Customer C010
('R015', 'P022', 'C010', 5, N'Máy ảnh chụp và quay video đều rất tốt.', '2025-08-12 14:15:00'), -- Order O016
('R016', 'P021', 'C010', 3, N'Bàn phím ổn, nhưng phím đôi khi bị kẹt.', '2025-08-12 14:15:00'), -- Order O017

-- Reviews for Customer C011
('R017', 'P001', 'C011', 5, N'Diện thoại rất nhanh và đáng tin cậy.', '2025-08-15 09:00:00'), -- Order O018

-- Reviews for Customer C012
('R018', 'P017', 'C012', 4, N'Son có màu đẹp và lâu trôi.', '2025-08-18 10:30:00'), -- Order O019

-- Reviews for Customer C013
('R019', 'P003', 'C013', 3, N'Sách nấu ăn ổn nhưng thiếu công thức sáng tạo.', '2025-08-01 12:00:00'), -- Order O020

-- Reviews for Customer C014
('R020', 'P006', 'C014', 4, N'Áo thun mặc thoải mái và vừa vặn.', '2025-08-12 14:15:00'), -- Order O022
('R021', 'P012', 'C014', 5, N'Chiếc đầm rất đẹp và vừa như in.', '2025-08-12 14:15:00'), -- Order O023

-- Reviews for Customer C015
('R022', 'P001', 'C015', 5, N'Diện thoại vượt xa mong đợi của tôi.', '2025-08-15 09:00:00'), -- Order O024

-- Reviews for Customer C016
('R023', 'P018', 'C016', 5, N'Thảm yoga rất thoải mái và không trơn trượt.', '2025-08-18 10:30:00'), -- Order O025

-- Reviews for Customer C017
('R024', 'P008', 'C017', 3, N'Giày thể thao ổn, nhưng đế nhanh mòn.', '2025-08-01 12:00:00'), -- Order O026

-- Reviews for Customer C018
('R025', 'P009', 'C018', 2, N'Máy pha cà phê hỏng sau một tháng sử dụng.', '2025-08-12 14:15:00'); -- Order O028

-- Insert payment method Creditcard 
select * from orderitems;
INSERT INTO CreditCardPayments (credit_card_payment_id, payment_id, card_number, card_holder_name, expiry_date)
VALUES
('CCPAY001', 'PAY001', '4111111111111111', 'Nguyen Van A', '2026-07-01'),
('CCPAY002', 'PAY002', '4111111111111111', 'Nguyen Van A', '2026-07-01'),
('CCPAY003', 'PAY004', '4111111111111113', 'Tran Thi Bich', '2026-06-30'),
('CCPAY004', 'PAY005', '4111111111111114', 'Vo Minh Duc', '2026-07-12'),
('CCPAY005', 'PAY006', '4111111111111114', 'Dang Thuy Dung', '2026-07-20'),
('CCPAY006', 'PAY008', '4111111111111116', 'Bui Mai Huong', '2026-07-01'),
('CCPAY007', 'PAY010', '4111111111111117', 'Do Thu Lan', '2026-07-12'),
('CCPAY008', 'PAY011', '4111111111111117', 'Trinh Cong Ly', '2026-07-12'),
('CCPAY009', 'PAY012', '4111111111111119', 'Ly Thanh Mai', '2026-07-15'),
('CCPAY010', 'PAY014', '4111111111111120', 'To Kim Ngan', '2026-07-01'),
('CCPAY011', 'PAY015', '4111111111111120', 'Nguyen Van Phuc', '2026-07-10'),
('CCPAY012', 'PAY016', '4111111111111122', 'Phan Ngoc Quynh', '2026-07-12'),
('CCPAY013', 'PAY018', '4111111111111123', 'Lam Dieu Thao', '2026-07-15'),
('CCPAY014', 'PAY020', '4111111111111125', 'Truong Thanh Tung', '2026-07-01'),
('CCPAY015', 'PAY021', '4111111111111125', 'Duong Van Nam', '2026-07-10'),
('CCPAY016', 'PAY022', '4111111111111126', 'To Kim Ngan', '2026-07-12'),
('CCPAY017', 'PAY023', '4111111111111126', 'To Kim Ngan', '2026-07-12'),
('CCPAY018', 'PAY024', '4111111111111128', 'Nguyen Van Phuc', '2026-07-15'),
('CCPAY019', 'PAY026', '4111111111111129', 'Ho Minh Quan', '2026-07-01'),
('CCPAY020', 'PAY028', '4111111111111130', 'Lam Dieu Thao', '2026-07-12'),
('CCPAY021', 'PAY030', '4111111111111131', 'Truong Thanh Tung', '2026-07-15'),
('CCPAY022', 'PAY031', '4111111111111132', 'Dinh Phuong Van', '2026-07-18');

-- Truy vấn thử Customer Name, Order ID, Payment ID; hiện bao gồm cả 2 phương thức 
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    p.order_id,
    p.payment_id
FROM 
    Customers c
JOIN 
    Payments p ON c.customer_id = p.customer_id;
    
-- Insert payment method GiftCard 
INSERT INTO GiftCardPayments (gift_card_payment_id, payment_id, gift_card_code)
VALUES
('GCPAY001', 'PAY003', 'GC1234567890'),
('GCPAY002', 'PAY005', 'GC1234567891'),
('GCPAY003', 'PAY007', 'GC1234567892'),
('GCPAY004', 'PAY009', 'GC1234567893'),
('GCPAY005', 'PAY012', 'GC1234567894'),
('GCPAY006', 'PAY013', 'GC1234567895'),
('GCPAY007', 'PAY016', 'GC1234567896'),
('GCPAY008', 'PAY017', 'GC1234567903'),
('GCPAY009', 'PAY018', 'GC1234567897'),
('GCPAY010', 'PAY019', 'GC1234567902'),
('GCPAY011', 'PAY022', 'GC1234567904'),
('GCPAY012', 'PAY025', 'GC1234567898'),
('GCPAY013', 'PAY027', 'GC1234567899'),
('GCPAY014', 'PAY029', 'GC1234567900');

-- Kiểm tra số tiền ở thẻ Creditcard của khách, nếu khoong đủ thì hủy bỏ 
USE Onlinestore;
GO 
CREATE TRIGGER check_cc_flag_before_insert
ON CreditCardPayments
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Payments p ON i.payment_id = p.payment_id
        WHERE p.cc_flag = 0 -- hoặc p.cc_flag IS NULL
    )
    BEGIN
        RAISERROR('Payment cannot be processed as Credit Card payment. cc_flag is FALSE.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    -- Nếu hợp lệ, tiếp tục chèn dữ liệu
    INSERT INTO CreditCardPayments (credit_card_payment_id, payment_id, card_number, card_holder_name, expiry_date)
    SELECT credit_card_payment_id, payment_id, card_number, card_holder_name, expiry_date
    FROM inserted;
END;

-- Sau khi chọn Giftcard giao dịch phải được thực hiện thì mới lưu vào payment 
GO
CREATE TRIGGER check_gc_flag_before_insert
ON GiftCardPayments
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    -- Nếu có bất kỳ dòng nào trong inserted có payment_id mà gc_flag = 0 thì lỗi
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Payments p ON i.payment_id = p.payment_id
        WHERE p.gc_flag = 0
    )
    BEGIN
        RAISERROR('Payment cannot be processed as Gift Card payment. gc_flag is FALSE.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    -- Nếu hợp lệ, thực hiện chèn
    INSERT INTO GiftCardPayments (gift_card_payment_id, payment_id, gift_card_code)
    SELECT gift_card_payment_id, payment_id, gift_card_code
    FROM inserted;
END;

-- Insert Payment Details
GO 
select *from payments;

-- Orders for Customer C001
-- Payment ID: PAY001
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD001', 'PAY001', 23500000, 'Credit Card');  -- Full payment via Credit Card

-- Payment ID: PAY002
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD002', 'PAY002', 3050000, 'Credit Card');  -- Full payment via Credit Card

-- Orders for Customer C002
-- Payment ID: PAY003
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD003', 'PAY003', 1430000, 'Gift Card');  -- Full payment via Gift Card

-- Payment ID: PAY004
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD004', 'PAY004', 700000, 'Credit Card');  -- Full payment via Credit Card

-- Orders for Customer C003
-- Payment ID: PAY005 (Split payment 1)
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD005', 'PAY005', 8866666.67, 'Credit Card'),  -- First part of split payment via Credit Card
('PD006', 'PAY005', 4433333.33, 'Gift Card');    -- Second part of split payment via Gift Card

-- Payment ID: PAY006
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD007', 'PAY006', 240000, 'Credit Card');   -- Full payment via Credit Card

-- Orders for Customer C004
-- Payment ID: PAY007
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD008', 'PAY007', 2600000, 'Gift Card');    -- Full payment via Gift Card

-- Orders for Customer C005
-- Payment ID: PAY008
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD009', 'PAY008', 500000, 'Credit Card');   -- Full payment via Credit Card

-- Payment ID: PAY009
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD010', 'PAY009', 240000, 'Gift Card');     -- Full payment via Gift Card

-- Orders for Customer C006
-- Payment ID: PAY010
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD011', 'PAY010', 2150000, 'Credit Card');  -- Full payment via Credit Card

-- Payment ID: PAY011
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD012', 'PAY011', 600000, 'Credit Card');   -- Full payment via Credit Card

-- Orders for Customer C007
-- Payment ID: PAY012 (Split payment 2)
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD013', 'PAY012', 3750000, 'Credit Card'),  -- First part of split payment via Credit Card
('PD014', 'PAY012', 3750000, 'Gift Card');    -- Second part of split payment via Gift Card

-- Orders for Customer C008
-- Payment ID: PAY013
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD015', 'PAY013', 14000000, 'Gift Card');    -- Full payment via Gift Card

-- Orders for Customer C009
-- Payment ID: PAY014
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD016', 'PAY014', 8000000, 'Credit Card');  -- Full payment via Credit Card

-- Payment ID: PAY015
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD017', 'PAY015', 1040000, 'Credit Card');  -- Full payment via Credit Card

-- Orders for Customer C010
-- Payment ID: PAY016 (Split payment 3)
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD018', 'PAY016', 6400000, 'Credit Card'),  -- First part of split payment via Credit Card
('PD019', 'PAY016', 6400000, 'Gift Card');    -- Second part of split payment via Gift Card

-- Payment ID: PAY017
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD020', 'PAY017', 900000, 'Gift Card');     -- Full payment via Gift Card

-- Orders for Customer C011
-- Payment ID: PAY018 (Split payment 4)
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD021', 'PAY018', 5450000, 'Credit Card'),  -- First part of split payment via Credit Card
('PD022', 'PAY018', 5450000, 'Gift Card');    -- Second part of split payment via Gift Card

-- Orders for Customer C012
-- Payment ID: PAY019
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD023', 'PAY019', 780000, 'Gift Card');     -- Full payment via Gift Card

-- Orders for Customer C013
-- Payment ID: PAY020
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD024', 'PAY020', 2160000, 'Credit Card');  -- Full payment via Credit Card

-- Payment ID: PAY021
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD025', 'PAY021', 1200000, 'Credit Card');  -- Full payment via Credit Card

-- Orders for Customer C014
-- Payment ID: PAY022 (Split payment 5)
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD026', 'PAY022', 7575000, 'Credit Card'),  -- First part of split payment via Credit Card
('PD027', 'PAY022', 7575000, 'Gift Card');    -- Second part of split payment via Gift Card

INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD038', 'PAY023', 1130000, 'Credit Card');

-- Orders for Customer C015
-- Payment ID: PAY024
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD028', 'PAY024', 9700000, 'Credit Card');  -- Full payment via Credit Card

-- Orders for Customer C016
-- Payment ID: PAY025
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD029', 'PAY025', 700000, 'Gift Card');     -- Full payment via Gift Card

-- Orders for Customer C017
-- Payment ID: PAY026
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD030', 'PAY026', 1550000, 'Credit Card');  -- Full payment via Credit Card

-- Payment ID: PAY027
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD031', 'PAY027', 7600000, 'Gift Card');    -- Full payment via Gift Card

-- Orders for Customer C018
-- Payment ID: PAY028
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD032', 'PAY028', 2160000, 'Credit Card');  -- Full payment via Credit Card

-- Payment ID: PAY029
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD033', 'PAY029', 11500000, 'Gift Card');    -- Full payment via Gift Card

-- Orders for Customer C019
-- Payment ID: PAY030
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD034', 'PAY030', 2100000, 'Credit Card');  -- Full payment via Credit Card

-- Orders for Customer C020
-- Payment ID: PAY031
INSERT INTO PaymentDetails (payment_detail_id, payment_id, amount, payment_type)
VALUES
('PD035', 'PAY031', 1850000, 'Credit Card');  -- Full payment via Credit Card

-- Kiểm soát tính toàn vẹn thanh toán: Không cho phép chèn vào bảng PaymentDetails 
-- nếu tổng tiền đã thanh toán vượt quá hoặc chưa đủ so với số tiền đơn hàng (Payments.total_amount)
GO 
CREATE TRIGGER trg_validate_payment_amounts
ON PaymentDetails
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
	-- Khai báo biến
    DECLARE @payment_id CHAR(36);  -- ID của giao dịch thanh toán vừa được chèn
    DECLARE @payment_total DECIMAL(18, 2);  -- Tổng tiền cần thanh toán (lấy từ bảng Payments)
    DECLARE @total_paid DECIMAL(18, 2);  -- Tổng tiền đã thực thanh toán (tính lại sau khi chèn)

    -- Giả sử chỉ 1 hàng được chèn mỗi lần
    SELECT TOP 1 @payment_id = payment_id FROM inserted;

    -- Tính tổng số tiền đã thanh toán cho payment_id này: Bao gồm cả dòng vừa mới được chèn.
    SELECT @total_paid = SUM(amount)
    FROM PaymentDetails
    WHERE payment_id = @payment_id;

    -- Lấy tổng số tiền cần thanh toán từ bảng Payments
    SELECT @payment_total = total_amount
    FROM Payments
    WHERE payment_id = @payment_id;

    -- So sánh
    IF @total_paid > @payment_total
    BEGIN
        RAISERROR('Tổng tiền thanh toán vượt quá số tiền đơn hàng.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF @total_paid < @payment_total
    BEGIN
        RAISERROR('Tổng tiền thanh toán chưa đủ so với đơn hàng.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
 
-- Tự động kiểm tra và cập nhật số lượng tồn kho khi có sản phẩm được đặt hàng.
-- 1.Kiểm tra xem còn đủ hàng không
-- 2.Nếu đủ → trừ tồn kho
-- 3.Nếu không đủ → báo lỗi và không cho chèn
GO 
CREATE TRIGGER trg_update_stock_on_purchase
ON OrderItems
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    -- Kiểm tra tồn kho trước khi trừ
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Products p ON i.product_id = p.product_id
        WHERE p.units_in_stock < i.quantity
    )
    BEGIN
        RAISERROR('Not enough stock for this product.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    -- Trừ số lượng tồn kho: Trừ quantity vừa được đặt mua khỏi units_in_stock
    UPDATE p
    SET p.units_in_stock = p.units_in_stock - i.quantity
    FROM Products p
    JOIN inserted i ON p.product_id = i.product_id;
END;

-- Tự động cập nhật lại số lượng tồn kho (units_in_stock) mỗi khi có hàng mới được nhập từ nhà cung cấp, 
-- tức là mỗi khi có dòng mới được thêm vào bảng Product Suppliers
GO 
CREATE TRIGGER trg_update_stock_on_supply
ON ProductSuppliers
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    -- Tăng tồn kho mỗi khi có hàng được nhập
    UPDATE p
    SET p.units_in_stock = p.units_in_stock + 1  
    FROM Products p
    JOIN inserted i ON p.product_id = i.product_id;
END;

-- Lan Anh NGUYEN 
-- Topic 1: Customer - thông tin khách hàng, hành vi mua hàng theo cá nhân và theo khu vực 
-- SQL query 1 (Retrieve detailed information about customer orders, including customer names, order IDs, product details, quantities, 
-- and prices, while ensuring the results are ordered by customer ID, order ID, and product ID)
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_id,
    oi.product_id,
    p.name AS product_name,
    oi.quantity,
    FORMAT(oi.price, 'N0', 'vi-vn') + ' đ' AS price_vnd
FROM 
    Customers c
JOIN 
    Orders o ON c.customer_id = o.customer_id
JOIN 
    OrderItems oi ON o.order_id = oi.order_id
JOIN 
    Products p ON oi.product_id = p.product_id
ORDER BY 
    c.customer_id, o.order_id, oi.product_id;

-- SQL query 1.1 ( list each customer’s ID, full name, the total sales, average order value, and the number of orders *for each customer*
-- sorted by total amount spent in descending order )

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS total_orders,
    FORMAT(SUM(o.total_amount), 'N0', 'vi-vn') + ' đ' AS total_sales,
    FORMAT(AVG(o.total_amount), 'N0', 'vi-vn') + ' đ' AS average_order_value
FROM 
    Customers c
JOIN 
    Orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
ORDER BY 
    SUM(o.total_amount) DESC;  

-- +) List customers who have placed at least 2 orders:
SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_full_name,
    COUNT(o.order_id) AS total_orders_placed
FROM
    Customers c
JOIN
    Orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name
HAVING
    COUNT(o.order_id) >= 2
ORDER BY
    total_orders_placed DESC;

-- SQL query 1.2 ( display the total number of purchases and the total amount spent for each shipping city
-- using the Shipping, Orders, and OrderItems tables, and sort the results by the total amount spent in descending order )

SELECT
    s.city AS shipping_city,
    COUNT(DISTINCT o.order_id) AS total_purchases,
    FORMAT(SUM(o.total_amount), 'N0', 'vi-vn') + ' đ' AS total_amount_spent
FROM
    Shipping s
JOIN
    Orders o ON s.order_id = o.order_id
JOIN
    OrderItems oi ON o.order_id = oi.order_id
GROUP BY
    s.city
ORDER BY
    SUM(o.total_amount) DESC;  -- có thể dùng SUM(oi.quantity * oi.price) DESC;

    
-- Lan Anh NGUYEN 
-- Topic 2: Product / Category 
-- SQL query 2 ( Retrieve total revenue and quantity sold by *product Category* ) - so sánh Category 
SELECT
    c.name AS category_name,
    SUM(oi.quantity) AS total_quantity_sold,
    FORMAT(SUM(oi.quantity * oi.price), 'N0', 'vi-vn') + ' đ' AS total_revenue
FROM
    Categories c
JOIN
    ProductCategories pc ON c.category_id = pc.category_id
JOIN
    OrderItems oi ON pc.product_id = oi.product_id
GROUP BY
    c.name
ORDER BY
    SUM(oi.quantity * oi.price) DESC;

-- SQL query 2.1 (Retrieve the *top 5 products* by total sales amount, including the total quantity sold and the total revenue generated.) - so sánh Product
SELECT TOP 5
    p.product_id,
    p.name AS product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    FORMAT(SUM(oi.quantity * oi.price), 'N0', 'vi-vn') + ' đ' AS total_revenue
FROM 
    OrderItems oi
JOIN 
    Products p ON oi.product_id = p.product_id
GROUP BY 
    p.product_id, p.name
ORDER BY 
    SUM(oi.quantity * oi.price) DESC;

-- SQL query 2.2 (Retrieve average customer feedback rating for each product)
SELECT 
    p.product_id,
    p.name AS product_name,
    CAST(AVG(CAST(r.rating AS FLOAT)) AS DECIMAL(3,1)) AS average_rating,
    COUNT(r.review_id) AS total_reviews
FROM 
    Products p
JOIN 
    Reviews r ON p.product_id = r.product_id
GROUP BY 
    p.product_id, p.name
ORDER BY 
    average_rating ASC;


-- Lan Anh NGUYEN 
-- Topic 3: Inventory
-- SQL query 3 (Retrieve the product ID, product name, and current stock quantity (units_in_stock) for all products, 
-- sorted in descending order by the number of units in stock )
SELECT
    product_id,
    name AS product_name,
    units_in_stock
FROM
    Products
ORDER BY
    units_in_stock DESC; 
-- SQL query 3.1 ( Calculate the stock remaining after fulfilling all orders )
SELECT
    p.product_id,
    p.name AS product_name,
    p.units_in_stock AS initial_stock,
    ISNULL(SUM(oi.quantity), 0) AS total_ordered_quantity,
    (p.units_in_stock - ISNULL(SUM(oi.quantity), 0)) AS remaining_stock
FROM
    Products p
LEFT JOIN
    OrderItems oi ON p.product_id = oi.product_id
GROUP BY
    p.product_id, p.name, p.units_in_stock
ORDER BY
    remaining_stock DESC, p.name;

-- Lan Anh NGUYEN 
-- Topic 4: Payment method 
-- SQL query 4 (Retrieve orders that have both credit card and gift card payments and how much they paid through each payment method and total number of order)
-- tùy thuộc vào mức độ % của phiếu giảm giá 
SELECT 
    o.order_id,
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
	COUNT(*) OVER(PARTITION BY c.customer_id) AS total_orders,
    FORMAT(o.total_amount, 'N0', 'vi-vn') + ' đ' AS total_amount,

    p.payment_id,
    p.payment_status,
    p.payment_date,

    -- Tổng tiền bằng thẻ tín dụng
    FORMAT(
        (SELECT SUM(pd.amount) 
         FROM PaymentDetails pd 
         WHERE pd.payment_id = p.payment_id AND pd.payment_type = 'Credit Card'),
        'N0', 'vi-vn'
    ) + ' đ' AS credit_card_amount,

    -- Tổng tiền bằng thẻ quà tặng
    FORMAT(
        (SELECT SUM(pd.amount) 
         FROM PaymentDetails pd 
         WHERE pd.payment_id = p.payment_id AND pd.payment_type = 'Gift Card'),
        'N0', 'vi-vn'
    ) + ' đ' AS gift_card_amount

FROM 
    Orders o
JOIN 
    Customers c ON o.customer_id = c.customer_id
JOIN 
    Payments p ON o.order_id = p.order_id
JOIN 
    CreditCardPayments ccp ON p.payment_id = ccp.payment_id
JOIN 
    GiftCardPayments gcp ON p.payment_id = gcp.payment_id
WHERE 
    p.cc_flag = 1 AND p.gc_flag = 1;

-- SQL query 4.1 ( Retrieve group all completed payments by payment method (Credit Card Only, Gift Card Only, or both), 
-- calculate the total amount paid for each group, using flags in the Payments table and sorting the results by the total amount in descending order )
SELECT
    CASE
        WHEN cc_flag = 1 AND gc_flag = 0 THEN 'Credit Card Only'
        WHEN cc_flag = 0 AND gc_flag = 1 THEN 'Gift Card Only'
        WHEN cc_flag = 1 AND gc_flag = 1 THEN 'Credit Card & Gift Card'
        ELSE 'Other/Unknown'
    END AS payment_method,

    FORMAT(SUM(total_amount), 'N0', 'vi-vn') + ' đ' AS total_amount_paid,

    -- Tính phần trăm: (tổng theo loại / tổng tất cả) * 100
    FORMAT(
        100.0 * SUM(total_amount) / 
        SUM(SUM(total_amount)) OVER (),
        'N2'
    ) + ' %' AS percentage

FROM
    Payments
WHERE
    payment_status = 'Completed'
GROUP BY
    CASE
        WHEN cc_flag = 1 AND gc_flag = 0 THEN 'Credit Card Only'
        WHEN cc_flag = 0 AND gc_flag = 1 THEN 'Gift Card Only'
        WHEN cc_flag = 1 AND gc_flag = 1 THEN 'Credit Card & Gift Card'
        ELSE 'Other/Unknown'
    END
ORDER BY
    SUM(total_amount) DESC;  


-- Lan Anh NGUYEN 
-- Topic 5: Order --> Payment --> Shipping
-- SQL query 5 ( Retrieve average order processing time (From Order to Payment) )

SELECT
    AVG(CAST(DATEDIFF(minute, o.created_at, p.payment_date) AS DECIMAL(10, 2))) AS average_processing_time_minutes
FROM
    Orders o
JOIN
    Payments p ON o.order_id = p.order_id
WHERE
    p.payment_status = 'Completed';

-- SQL query 5.1 ( Retrieve average delivery time (From Payment to Shipping)
 
SELECT
    AVG(CAST(DATEDIFF(minute, p.payment_date, s.shipping_date) AS DECIMAL(10, 2)) / 1440.0) AS average_shipping_prep_time_days
FROM
    Payments p
JOIN
    Orders o ON p.order_id = o.order_id
JOIN
    Shipping s ON o.order_id = s.order_id
WHERE
    p.payment_status = 'Completed';

-- SQL query 5.2 ( Retrieve average time from order to shipping ) 

SELECT
    CAST( AVG(CAST(DATEDIFF(minute, o.created_at, s.shipping_date) AS FLOAT)) / 1440.0 AS DECIMAL(10, 2) ) AS average_total_time_days
FROM
    Orders o
JOIN
    Shipping s ON o.order_id = s.order_id
JOIN
    Payments p ON o.order_id = p.order_id
WHERE
    p.payment_status = 'Completed';


-- SQL query 5.2 ( Retrieve average total time by City )  
SELECT
    s.city,
    AVG(DATEDIFF(day, o.created_at, s.shipping_date)) AS average_total_time_days
FROM
    Orders o
JOIN
    Shipping s ON o.order_id = s.order_id
JOIN
    Payments p ON o.order_id = p.order_id
WHERE
    p.payment_status = 'Completed'
GROUP BY
    s.city
ORDER BY
    average_total_time_days DESC;
