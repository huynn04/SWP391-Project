﻿GO
CREATE DATABASE ShopFMSOS;
GO
USE ShopFMSOS;
GO

-- Tạo bảng roles
CREATE TABLE roles (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(MAX)
);

-- Insert các vai trò mặc định
INSERT INTO roles (role_name, description)
VALUES 
    ('admin', 'Administrator with full access to the system'),
    ('staff', 'Staff with limited access to manage the shop'),
    ('customer', 'Registered user with the ability to browse and purchase products'),
    ('guest', 'Unregistered user with limited browsing access');

-- Tạo bảng users
CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    role_id INT NOT NULL DEFAULT 3,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone_number VARCHAR(15),
    address VARCHAR(100) NULL,  -- Đổi từ address_id thành address
    password VARCHAR(255) NOT NULL,
    avatar VARCHAR(255),
    status SMALLINT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- Tạo bảng addresses để lưu nhiều địa chỉ của user
CREATE TABLE addresses (
    address_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    city VARCHAR(100) NOT NULL, -- Cái này sẽ được sao chép vào trường address của bảng users
    district VARCHAR(100) NOT NULL,
    ward VARCHAR(100) NOT NULL,
    specific_address VARCHAR(255) NOT NULL,
    address_type VARCHAR(50) NOT NULL CHECK (address_type IN ('home', 'office')),
    is_default BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Cập nhật giá trị cho trường address trong bảng users từ trường city của bảng addresses
UPDATE users
SET address = a.city
FROM users u
JOIN addresses a ON u.user_id = a.user_id;


-- Cập nhật giá trị cho trường phone_number trong bảng users từ trường phone của bảng addresses
UPDATE users
SET phone_number = a.phone
FROM users u
JOIN addresses a ON u.user_id = a.user_id;



-- Tạo bảng categories
CREATE TABLE categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    description VARCHAR(MAX),
    image VARCHAR(255),
    status SMALLINT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Tạo bảng products
CREATE TABLE products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    detail_desc VARCHAR(MAX),
    image VARCHAR(255),
    price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2) DEFAULT 0,
    quantity INT NOT NULL,
    sold INT DEFAULT 0,
    target VARCHAR(255),
    factory VARCHAR(255),
    status SMALLINT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Tạo bảng cart
CREATE TABLE cart (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Tạo bảng cart_details
CREATE TABLE cart_details (
    cart_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (cart_id) REFERENCES cart(cart_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Tạo bảng orders
CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    order_date DATETIME DEFAULT GETDATE(),
    status SMALLINT DEFAULT 0,
    note VARCHAR(MAX),
    receiver_name VARCHAR(255) NOT NULL,
    receiver_address_id INT NOT NULL,
    receiver_phone VARCHAR(15) NOT NULL,
    payment_method VARCHAR(50) DEFAULT 'COD',
    discount_code VARCHAR(50),
    delivered_at DATETIME NULL,
    canceled_at DATETIME NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (receiver_address_id) REFERENCES addresses(address_id)
);

-- Tạo bảng order_details
CREATE TABLE order_details (
    order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    tax DECIMAL(5,2) DEFAULT 0,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Tạo bảng product_reviews
CREATE TABLE product_reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    order_detail_id INT NOT NULL,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    review_content VARCHAR(MAX),
    rating SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    title VARCHAR(255),
    likes INT DEFAULT 0,
    status SMALLINT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (order_detail_id) REFERENCES order_details(order_detail_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Tạo bảng news
CREATE TABLE news (
    news_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content VARCHAR(MAX) NOT NULL,
    image VARCHAR(255),
    status SMALLINT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Tạo bảng news_comments
CREATE TABLE news_comments (
    comment_id INT IDENTITY(1,1) PRIMARY KEY,
    news_id INT NOT NULL,
    user_id INT NOT NULL,
    content VARCHAR(MAX) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (news_id) REFERENCES news(news_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Tạo bảng password_reset_tokens
CREATE TABLE password_reset_tokens (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    expires_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Tạo bảng discounts
CREATE TABLE discounts (
    discount_id INT IDENTITY(1,1) PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    discount_type VARCHAR(10) CHECK (discount_type IN ('percent', 'fixed')),
    min_order_value DECIMAL(10,2) DEFAULT 0,
    expiry_date DATE NOT NULL,
    status SMALLINT DEFAULT 1
);

-- Thêm cột discount_id vào bảng orders
ALTER TABLE orders ADD discount_id INT NULL;
ALTER TABLE orders ADD discount_amount DECIMAL(10,2) DEFAULT 0;
ALTER TABLE orders ADD CONSTRAINT FK_orders_discounts FOREIGN KEY (discount_id) REFERENCES discounts(discount_id);

-- Thêm dữ liệu mẫu nếu chưa có
IF NOT EXISTS (SELECT * FROM discounts WHERE code = 'SALE10')
BEGIN
    INSERT INTO discounts (code, discount_value, discount_type, min_order_value, expiry_date, status)
    VALUES 
        ('SALE10', 10, 'percent', 100, '2025-12-31', 1), 
        ('FIXED50', 50, 'fixed', 200, '2025-06-30', 1),
        ('FREESHIP', 30, 'fixed', 150, '2025-09-30', 1);
END
GO
